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

	fi
}

