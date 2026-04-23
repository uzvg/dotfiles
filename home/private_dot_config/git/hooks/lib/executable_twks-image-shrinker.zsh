#!/usr/bin/env zsh
# shrink_images.zsh — 批量将图片转换并压缩为 AVIF 格式
# 依赖: vips (libvips), coreutils (realpath) pretty-print.zsh
# print_success
# print_tip
# print_warning
# print_error

# ── 工具函数 ─────────────────────────────────────────

usage() {
  cat << 'EOF'
Usage: shrink_images.zsh -s <SOURCE_DIR> -d <DEST_DIR> [Options]

Options:
  -h, --help               显示帮助
  -v, --verbose            显示详细信息
  -s, --source <DIR>       源目录（必填）
  -d, --dest   <DIR>       目标目录（必填）
  -w, --width  <width>     缩放宽度，默认 1920
  -q, --quality <1-100>    输出质量，默认 85
  -e, --effort  <0-9>      编码速度，默认 5（越小体积越小，压缩速度越慢）
  -m, --max-size <size>    跳过小于该大小的文件，支持 K/M/G，默认 0（处理全部）

Example:
  shrink_images.zsh -s ./photos -d ./output -w 1920 -q 80 -m 500K
EOF
}

# 转换带单位的字符串为字节数
parse_size() {
  local raw="${1:u}"
  if [[ $raw =~ '^([0-9]+)([KMG]?)$' ]]; then
    local num=$match[1]
    local unit=$match[2]
    case $unit in
      K) print $(( num * 1024 )) ;;
      M) print $(( num * 1024 * 1024 )) ;;
      G) print $(( num * 1024 * 1024 * 1024 )) ;;
      *) print $num ;;
    esac
  else
    print_error "错误: 无法解析大小参数 '$1'（示例: 500K 1M 2G）"
    return 1
  fi
}

log_verbose() {
  [[ $verbose == true ]] && print "  $*"
}

# 检查外部依赖
check_deps() {
  local -a missing=()
  for cmd (vips realpath); do
    (( $+commands[$cmd] )) || missing+=($cmd)
  done
  if (( ${#missing} )); then
    print_error "错误: 缺少依赖命令: ${(j:, :)missing}"
    return 1
  fi
}

# ── 主函数 ───────────────────────────────────────────
main() {
  # ── 参数解析 ────────────────────────────────────────
  source ${0:A:h}/pretty-print.zsh
  local -A opts
  zparseopts -D -E -F -A opts \
    h -help \
    v -verbose \
    s: -source: \
    d: -dest: \
    w: -width: \
    q: -quality: \
    e: -effort: \
    m: -max-size: || { usage; return 1 }

  (( ${+opts[-h]} || ${+opts[--help]} )) && { usage; return 0 }

  local verbose=false
  (( ${+opts[-v]} || ${+opts[--verbose]} )) && verbose=true

  # 提取参数值（合并长短选项，设置默认值）
  local src_dir="${opts[-s]:-${opts[--source]}}"
  local dest_dir="${opts[-d]:-${opts[--dest]}}"
  local width="${opts[-w]:-${opts[--width]:-1920}}"
  local quality="${opts[-q]:-${opts[--quality]:-85}}"
  local effort="${opts[-e]:-${opts[--effort]:-5}}"
  local max_size_raw="${opts[-m]:-${opts[--max-size]:-0}}"

  # ── 校验逻辑 ────────────────────────────────────────
  if [[ -z $src_dir || -z $dest_dir ]]; then
    print_error "错误: -s/--source 和 -d/--dest 为必填参数。"
    usage; return 1
  fi
  if [[ ! -d $src_dir ]]; then
    print_error "错误: 源目录不存在: $src_dir"
    return 1
  fi
  if ! [[ $width =~ '^[1-9][0-9]*$' ]]; then
    print_error "错误: 宽度必须为正整数，当前值: $width"
    return 1
  fi
  if ! [[ $quality =~ '^([1-9][0-9]?|100)$' ]]; then
    print_error "错误: 质量必须为 1-100，当前值: $quality"
    return 1
  fi
  if ! [[ $effort =~ '^[0-9]$' ]]; then
    print_error "错误: 速度必须为 0-9，当前值: $effort"
    return 1
  fi

  local -i max_size_bytes
  max_size_bytes=$(parse_size "$max_size_raw") || return 1

  check_deps || return 1

  # 路径标准化
  src_dir=$(realpath "$src_dir")
  dest_dir=$(realpath -m "$dest_dir")

  # ── 发现与过滤 ──────────────────────────────────────
  zmodload zsh/stat
  setopt extended_glob local_options

  print_tip "扫描源目录: $src_dir"
  local -a source_files=( ${src_dir}/**/*.(#i)(jpg|jpeg|png|webp)(N.:a) )
  local -i total_found=${#source_files}

  if (( total_found == 0 )); then
    print_tip "未找到任何支持的图片文件，退出。"
    return 0
  fi
  print_tip "共发现 ${total_found} 张图片。"

  local -a missing_files files_to_process
  local -i skip_count=0

  # 1. 优先过滤已存在的目标文件 (成本最低)
  for src_file in "${source_files[@]}"; do
    local rel_path="${src_file#$src_dir/}"
    local dest_file="$dest_dir/${rel_path:r}.avif"

    if [[ -f $dest_file ]]; then
      (( skip_count++ ))
      log_verbose "跳过(已存在): $dest_file"
    else
      missing_files+=("$src_file")
    fi
  done

  # 2. 按大小过滤剩余文件 (批量调用 stat，成本其次)
  if (( max_size_bytes > 0 && ${#missing_files} > 0 )); then
    local -a file_sizes
    zstat -A file_sizes +size "${missing_files[@]}"

    for i in {1..${#missing_files}}; do
      if (( file_sizes[i] >= max_size_bytes )); then
        files_to_process+=("${missing_files[i]}")
      else
        (( skip_count++ ))
        log_verbose "跳过(大小 ${file_sizes[i]}B 不足): ${missing_files[i]:t}"
      fi
    done
  else
    files_to_process=("${missing_files[@]}")
  fi

  # ── 执行转换 ────────────────────────────────────────
  local -i pending_count=${#files_to_process}
  local -i success_count=0 err_count=0

  if (( pending_count == 0 )); then
    print_tip "所有符合条件的图片均已处理，无需重复转换。"
  else
    print_tip "开始转换 ${pending_count} 张图片...\n"
    
    local -A created_dirs # 缓存已确认创建的目录结构，减少 IO

    for src_file in "${files_to_process[@]}"; do
      local rel_path="${src_file#$src_dir/}"
      local dest_file="$dest_dir/${rel_path:r}.avif"
      local dest_parent="${dest_file:h}"

      # 目录创建逻辑 (带缓存)
      if [[ -z ${created_dirs[$dest_parent]} && ! -d $dest_parent ]]; then
        if ! mkdir -p "$dest_parent"; then
          print_error "错误: 无法创建目录: $dest_parent"
          (( err_count++ ))
          continue
        fi
        created_dirs[$dest_parent]=1
      fi

      log_verbose "处理: $rel_path"

      # 执行转换
      if vips thumbnail \
           "$src_file" \
           "${dest_file}[Q=${quality},strip,effort=${effort}]" \
           "$width" \
           --size down \
           --linear \
           2>/dev/null; then
        (( success_count++ ))
      else
        (( err_count++ ))
        print_error "  转换失败: $src_file"
      fi
    done
  fi

  # ── 运行报告 ────────────────────────────────────────
  print "\n══════════════════════════════"
  print "  扫描图片总数:   ${total_found}"
  print "  成功转换:       ${success_count}"
  print "  跳过处理:       ${skip_count}"
  print "  转换失败:       ${err_count}"
  print "══════════════════════════════"

  return $(( err_count > 0 ? 1 : 0 ))
}

main "$@"
