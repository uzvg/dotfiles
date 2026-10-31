#!/usr/bin/env zsh
# vim:et sts=2 sw=2 ft=zsh

# 统一日志输出
# 用法: _zlog [info|success|warn|error] <message...>
# 注意：emulate 必须放在函数内部。若放在被 source 的文件顶层，
# 会把 environment 模块设置的 AUTO_CD/EXTENDED_GLOB/NO_CLOBBER 等选项全部重置。
_zlog() {
  emulate -L zsh

  local level=${1:-info}
  (( $# )) && shift
  local msg="${(j: :)@}"

  # 防止消息中的 % 被 print -P 当作提示符转义
  msg=${msg//\%/%%}

  local color label icon fd=1
  local ts
  ts=$(date '+%H:%M:%S')

  case "$level" in
    info)    color=4; label="INFO"; icon="🛈" ;;
    success) color=2; label="OK";   icon="✓" ;;
    warn)    color=3; label="WARN"; icon="⚠" ;;
    error)   color=1; label="ERR";  icon="✗"; fd=2 ;;
    *)       color=7; label="LOG";  icon="•" ;;
  esac

  print -u$fd -P "%F{8}${ts}%f %B%F{$color}${icon} ${label}:%f%b ${msg}"
}
