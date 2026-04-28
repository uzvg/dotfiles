#!/usr/bin/zsh
# vim:et sts=2 sw=2 ft=zsh

emulate -L zsh
# _show_correct() { print -u1 -P "%F{green}✓%f %B%F{2}CORRECT:%f%b ${(j: :)@}" }
# _show_tip() { print -u1 -P "%F{green}🛈%f %B%F{2}TIP:%f%b ${(j: :)@}" }
# _show_warning() { print -u1 -P "%F{yellow}⚠%f %B%F{3}WARNING:%f%b ${(j: :)@}" }
# _show_error() { print -u2 -P "%F{red}✗%f %B%F{1}ERROR:%f%b ${(j: :)@}" }

# 打印回显信息
# 调整颜色编号（1=红，2=绿，3=黄, 4=蓝）
_zlog() {
  local level="$1"; shift
  local msg="${(j: :)@}"

  local color label icon fd=1
  local ts="$(date '+%H:%M:%S')"

  case "$level" in
    info)    color=4; label="INFO"; icon="🛈" ;;
    success) color=2; label="OK";   icon="✓" ;;
    warn)    color=3; label="WARN"; icon="⚠" ;;
    error)   color=1; label="ERR";  icon="✗"; fd=2 ;;
    *)       color=7; label="LOG";  icon="•" ;;
  esac

  print -u$fd -P "%F{8}${ts}%f %B%F{$color}${icon} ${label}:%f%b ${msg}"
}
