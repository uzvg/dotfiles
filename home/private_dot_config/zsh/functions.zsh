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
	fi
}

