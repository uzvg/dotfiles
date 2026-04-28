#!/usr/bin/zsh

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
