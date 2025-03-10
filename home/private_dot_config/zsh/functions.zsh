#!/usr/bin/zsh

# 打印回显信息
# 调整颜色编号（1=红，2=绿，3=黄）
function _show_correct() { print -u1 -P "%F{green}✓%f %B%F{2}CORRECT:%f%b ${(j: :)@}" }
function _show_tip() { print -u1 -P "%F{green}✓%f %B%F{2}TIP:%f%b ${(j: :)@}" }
function _show_warning() { print -u1 -P "%F{yellow}⚠%f %B%F{3}WARNING:%f%b ${(j: :)@}" }
function _show_error() { print -u2 -P "%F{red}✗%f %B%F{1}ERROR:%f%b ${(j: :)@}" }

# Edit config file with `chezmoi edit`
function _chezmoi_edit() {
  chezmoi edit --apply $1
	if [ -N $1 ]; then
	  exec zsh
		_show_correct "$1 reloaded successfully!"
	fi
}

