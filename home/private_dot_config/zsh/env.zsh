# vim: ft=zsh

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯SeparatorPlaceHolder⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# ==============================================
# Default editor
# ==============================================
# EDITOR 必须是单个可执行命令，不能写成 "VAR=val cmd" 形式，
# 否则直接 exec 的程序会报 command not found。
# 需要切换 Neovim 配置时，用 NVIM_APPNAME 环境变量单独指定。
export NVIM_APPNAME='lazyvim'
export EDITOR='nvim'
export VISUAL="$EDITOR"

# ==============================================
# Rime Input Method Environment Variables
# ==============================================
export RIME_USER_PATH="$HOME/.config/ibus/rime"
export RIME_SYNC_PATH="$HOME/Documents/Repos/rime"

# ==============================================
# Qt 应用程序放大
#   让obs、微信、wps等原先hidpi适配不正常的程序放大1.2倍
#   但也会将原先正常缩放的程序如Anki，goldendict放大1.2
#   建议使用在单个Qt程度程序上，而非全局环境变量
# ==============================================
# export QT_FONT_DPI=120

# ==============================================
# aliyunpan-go 配置文件目录
# ==============================================
export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/config"

# ==============================================
# ranger config
# DEPRACATED: Replaced with yazi
# ==============================================
# 避免ranger重新加载配置文件
# export RANGER_LOAD_DEFAULT_RC=false
# export RANGER_DEVICONS_SEPARATOR=" "

# ==============================================
# zoxide configuration
# ==============================================
# Specify the directory in which the database is stored
# _ZO_DATA_DIR must be an absolute dir
export _ZO_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
export _ZO_ECHO=0

# ==============================================
# Tiddlywiki Environment Variables
# ==============================================
export TIDDLYWIKI_PLUGIN_PATH="$XDG_DATA_HOME/tiddlywiki/plugins"

# ==============================================
# Zellij Environment
# ==============================================
# export ZELLIJ_AUTO_ATTACH='false
# ZELLIJ_AUTO_EXIT='true'

# ==============================================
# mozilla firfox
# ==============================================
#Enable wayland on firefox
# export MOZ_ENABLE_WAYLAND=1

# ==============================================
# Default Merge tool for pacdiff
# ==============================================
export DIFFPROG="/usr/bin/nvim"

# ==============================================
# 用于zim-atuin中的函数清理机制
# 为什么需要清理？
#   内存优化: 插件加载完成后，辅助函数已无用处，可以释放内存
#   命名空间清洁: 避免函数名污染全局命名空间
#   安全考虑: 防止内部函数被外部误用
# tips: 可以使用typeset -f |grep <辅助函数> 来验证
# ==============================================
export ZIM_PLUGIN_CLEANUP=1

# ==============================================
# mpd host socket configuration
# ==============================================
# export MPD_HOST="$XDG_RUNTIME_DIR/mpd/socket"

# ==============================================
# zsh-vi-mode configuration
# ==============================================
# Copy to the system clipboard when stroke yy, yw and so on
ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# ==============================================
# 在终端中启动系统代理2080/3067/7890
# ==============================================
export http_proxy="http://127.0.0.1:2080"
export https_proxy="$http_proxy"
export all_proxy="socks5://127.0.0.1:2080"
export no_proxy="localhost,127.0.0.1,::1,.local"
export NO_PROXY="$no_proxy"

# export http_proxy="http://127.0.0.1:7890"
# export https_proxy="http://127.0.0.1:7890"
# export all_proxy="socks5://127.0.0.1:7890"
#
# export http_proxy="http://127.0.0.1:3067"
# export https_proxy="http://127.0.0.1:3067"
# export all_proxy="socks5://127.0.0.1:3067"
#
# ==============================================
# 指定superfile/yazi 的运行时暂存路径
# ==============================================
# export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
export YAZI_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/yazi/lastdir"

# ==============================================
# bun npm manager configs
# ==============================================
# Installation path
export BUN_INSTALL="${XDG_DATA_HOME:-$HOME/.local/share}/bun"

# ==============================================
# GO Environment Variables
# ==============================================
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOBIN="$HOME/.local/bin"

# 统一在最后合并 PATH，避免多次前置导致顺序难以维护
typeset -U path
path=("$GOBIN" "$BUN_INSTALL/bin" $path)
export PATH
