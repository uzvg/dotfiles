#!/usr/bin/zsh

# 打印回显信息
# 调整颜色编号（1=红，2=绿，3=黄）
function _show_correct() { print -u1 -P "%F{green}✓%f %B%F{2}CORRECT:%f%b ${(j: :)@}" }
function _show_tip() { print -u1 -P "%F{green}✓%f %B%F{2}TIP:%f%b ${(j: :)@}" }
function _show_warning() { print -u1 -P "%F{yellow}⚠%f %B%F{3}WARNING:%f%b ${(j: :)@}" }
function _show_error() { print -u2 -P "%F{red}✗%f %B%F{1}ERROR:%f%b ${(j: :)@}" }

# Edit config file with `chezmoi edit`
_chezmoi_edit() {
  local config_file="$1"
  [[ -f "${config_file}" ]] || {
    _show_error "${config_file} does not exist"
    return 1
  }

  ${commands[chezmoi]} edit "${config_file}" --apply || {
    _show_error "Failed to edit ${config_file:t} with chezmoi"
    return 1
  }

  if [[ -N "${config_file}" ]]; then 
    exec ${commands[zsh]}
    # source "${config_file}" || {
    #   _show_error "Failed to reload ${config_file:t}"
    #   return 1
    #  }
    # _show_correct "${config_file:t} reloaded successfully"
  else 
    _show_tip "No changes detected in ${config_file:t}"
  fi
}

# Deploy Rime input method configuration
# Usage: _rime_edit <config_file>
_rime_edit() {
  local config_file="${1}" 
  local log_file="/tmp/rime_deploy.log"
  local build_dir="${RIME_USER_PATH}/build"

  # Validate config file
  [[ -f "${config_file}" ]] || {
    _show_error "Configuration file not found: ${config_file:t}"
    return 1
  }

  # Open editor
  if ! "${EDITOR}" "${config_file}"; then
    _show_error "Failed to open editor for ${config_file:t}"
    return 1
  fi

  # Check file modification
  [[ ! -N "${config_file}" ]] && {
    _show_tip "No changes detected in ${config_file:t}"
    return 0
  }

# Check rime_deployer command is valid
  (( ! $+commands[rime_deployer] )) && {
    _show_error "rime_deployer not found in PATH"
    return 1
  }

  _show_warning "Starting input method deployment..."
  
  case "${GTK_IM_MODULE}" in
    (fcitx)
      fcitx5-remote -e
      if ! rime_deployer --build "${RIME_USER_PATH}" "/usr/share/rime-data" "${build_dir}" > "${log_file}" 2>&1; then
        _show_error $'Deployment failed. Log details:\n%B%F{red}${log_file}%f%b'
        fcitx5-remote -o  # Restart regardless of failure
        return 1
      fi
      fcitx5-remote -o
      ;;
    (ibus)
      ibus exit >/dev/null 2>&1
      if ! rime_deployer --build "${RIME_USER_PATH}" "/usr/share/rime-data" "${build_dir}" > "${log_file}" 2>&1; then
        _show_error $'Deployment failed. Log details:\n%B%F{red}${log_file}%f%b'
        ibus-daemon -dr >/dev/null 2>&1  # Restart regardless of failure
        return 1
      fi
      ibus-daemon -dr >/dev/null 2>&1
      ;;
    (*)
      _show_error "Unsupported input method framework: ${GTK_IM_MODULE}"
      return 1
      ;;
  esac

  _show_correct "Successfully deployed Rime configuration"
  return 0
}

rimeicon() {
  local config_file="$RIME_USER_PATH/uggx_fluency.custom.yaml"
  _rime_edit "${config_file}"
}

rimewd() {
  local config_file="$RIME_USER_PATH/custom_phrase.txt"
  _rime_edit "${config_file}"
}

# Copy file into the clipboard
cpfile () {
  local file="$1"
  [[ -f "$file" ]] || {
    _show_error "${file:t} is not a valid file"
    return 1
  }
  case $XDG_SESSION_TYPE in
    (wayland)
      if (( ! ${+commands[wl-copy]} )); then {
        _show_error "wl-copy command was not found"
        _show_tip "Install the wl-clipboard to resolve this"
        return 1
      }
      fi
			wl-copy < "${file}" || {
        _show_error "Failed to copy using wl-copy"
        return 1
      } 
      ;;
    (xorg)
      if (( ! ${+commands[xclip]} )); then {
        _show_error "xclip command was not found"
        _show_tip "Install the xclip to resolve this"
        return 1
      }
      fi
      xclip -selection clipboard -in < "${file}" || {
        _show_error "Failed to copy using xclip"
        return 1
      } 
      ;;
    (*)
      _show_error "Unsupported display server: $XDG_SESSION_TYPE"
      return 1
      ;;
  esac
  _show_correct "File copied to clipboard successfully"
}

# transform file code to UTF_8
# windows下的纯文件在Linux下打开，有时会出现乱码的情况，需要先进行转码
function text_utf8 {
	if [[ -e $1 ]]; then
		iconv -f GB2312 -t UTF-8 $1 -o $1
	else
		_show_error "TRANSFORM ERROR"
	fi
}

function rimeSync {
	# rime 词库同步
	if [ -d $RIME_USER_PATH ]
	then
		# 词库合并
		case $GTK_IM_MODULE in
		fcitx ):
			fcitx5-remote -e
			cd $RIME_USER_PATH
			_show_warning "词库合并中......"
			rime_dict_manager -s &> /dev/null
			fcitx5-remote -o
			cd -;;
		ibus ):
			ibus exit
			cd $RIME_USER_PATH
			_show_warning "词库合并中......"
			rime_dict_manager -s &> /dev/null
			ibus start
			cd -;;
		* ):
			_show_error "词库合并：输入法配置错误";;
		esac

		_show_correct "词库合并成功,开始同步......"
		if [ -d "$RIME_SYNC_PATH" ];then
			local COMMIT_WORD="rime sync on Archlinux at $(date +%Y/%m/%d-%H:%M)"
			cd $RIME_SYNC_PATH
			git add -A > /dev/null
			git commit -a -m "$COMMIT_WORD" > /dev/null
			git push &> /dev/null
			cd -
			_show_correct "词库同步成功"
		else
			_show_error "rime 同步仓库路径错误"
		fi
	fi
}


# gogh 
function gogh(){
	bash -c "$(curl -sLo- https://git.io/vQgMr)"
}

# change the current working directory when exiting Yazi
# 🔗 https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function ra() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# 删除当前电脑上的所有个人配置文件
function dotfiles_nuke() {
  _show_tip "正在查找 chezmoi 管理的文件..."
  local -a managed_files
  managed_files=$(chezmoi managed -i files)

  if [[ -z "$managed_files" ]]; then
    _show_tip "没有发现 chezmoi 管理的文件。"
    return 0
  fi

  _show_warning "以下文件将被删除："
  print "$managed_files"
  print
  read "confirm?是否确认删除以上文件？(y/N): "
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    _show_error "操作已取消。"
    return 1
  fi

  print "开始删除..."
  while IFS= read -r file; do
    if [[ -e "$file" || -L "$file" ]]; then
      rm -f -- "$file" && _show_correct "已删除 $file" || _show_error "删除失败 $file"
    else
      _show_tip "跳过 $file（不存在）"
    fi
  done <<< "$managed_files"

  _show_correct "Nuke Done!"
}

wkspace() {
  emulate -L zsh

  local wiki_dir="/home/uzvg/Documents/wikis/WikiSpace"
  local dev_branch="develop"
  local main_branch="main"
  local git=${commands[git]}
  local lazygit=${commands[lazygit]}

  # stop auto-commit timer
  systemctl --user stop auto-commit.timer || true
  # stop wikispace service
  systemctl --user stop wikispace.service || true

  # change to wiki_dir
  pushd "$wiki_dir" || {
    _show_error "$wiki_dir is not exist."
    return 1
  }

  {
    # check branch develop if exist
    # if $git show-ref --verify --quiet "refs/heads/$dev_branch"; then
    #   $git switch "$dev_branch"
    # else
    #   _show_tip "Creating branch develop..."
    #   $git switch -c "$dev_branch" "$main_branch" || {
    #     _show_error "Creating $dev_branch branch failed."
    #     return 1
    #   }
    #   $git switch "$dev_branch"
    # fi
    #
    $lazygit || {
      _show_error "lazygit failed($?), services intentionally left stopped"
      return 1
    }
  } always {
    $git switch $main_branch
    popd
  }

  # start wikispace service
  systemctl --user start wikispace.service || {
    _show_error "Failed to start wikispace service"
    return 1
  }

  # start auto-commit timer
  systemctl --user start auto-commit.timer || {
    _show_error "Failed to start auto-commit service"
    return 1
  }
}
