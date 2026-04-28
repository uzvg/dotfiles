#!/usr/bin/zsh
emulate -L zsh

usage() {
  cat << 'EOF'
DESCRIPTION:
  twks-image-sync.zsh is a zsh shell script to sync images to the remote with rclone tool.
USAGE:
  twks-image-sync <SOURCE_DIR> <REMOTE_DEST_PATH>
  twks-image-sync -s <SOURCE_DIR> -d <DEST_DIR> [Options]
Options:
  -h, --help               显示帮助
  -v, --verbose            显示详细信息
  -s, --source <DIR>       源目录（必填）
  -d, --dest   <DIR>       目标目录（必填）
Example:
  twks-image-sync -s ./photos -d OneDrive:output
EOF
}

# ── 主函数 ───────────────────────────────────────────
main() {
  # ── 参数解析 ────────────────────────────────────────
  local -A opts
  zparseopts -D -E -F -A opts \
    h -help \
    v -verbose \
    s: -source: \
    d: -dest: \
    || { usage; return 1 }

  (( ${+opts[-h]} || ${+opts[--help]} )) && { usage; return 0 }

  local verbose=false
  (( ${+opts[-v]} || ${+opts[--verbose]} )) && verbose=true

  # 移除 zparseopts 留下的 -- 分隔符
  [[ ${1} == "--" ]] && shift

  # 合并参数：选项优先，位置参数兜底
  local src_dir="${opts[-s]:-${opts[--source]:-${1}}}"
  local dest_path="${opts[-d]:-${opts[--dest]:-${2}}}"

  # verbose flag 用数组更健壮
  local -a output_flags
  [[ $verbose == true ]] && output_flags=(--progress) || output_flags=(--quiet)

  # source "${0:A:h}/pretty-print.zsh" || {
  #   _zlog error "加载 pretty-print.zsh 出错，请检查其是否存在。"
  # }

  # ── 校验逻辑 ────────────────────────────────────────
  if [[ -z $src_dir || -z $dest_path ]]; then
    _zlog error "错误: -s/--source 和 -d/--dest 不能为空。"
    usage; return 1
  fi

  if [[ ! -d $src_dir ]]; then
    _zlog error "错误: 源目录不存在: $src_dir"
    return 1
  fi

  (( ! ${+commands[rclone]} )) && {
    _zlog error "rclone 命令不存在，请检查 rclone 是否已安装。"
    return 1
  }

  # ── 开始备份 ─────────────────────────────────────────
  _zlog info "Backing up images..."
  rclone sync "${src_dir}" "${dest_path}" "${output_flags[@]}" \
    --exclude "*.meta" \
    --exclude "*.tid" \
    --delete-excluded && {
      _zlog success "Images sync done"
    } || {
      _zlog error "Failing to sync images to ${dest_path}"
      return 1
    }
}

main "$@"
# vim: ft=zsh
