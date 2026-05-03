#!/usr/bin/zsh

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯SeparatorPlaceHolder⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# ==============================================
# Default editor
# ==============================================
export EDITOR='nvim'

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
# DEPRACATED: Using yazi instead.
# ==============================================
# 避免ranger重新加载配置文件
# export RANGER_LOAD_DEFAULT_RC=false
# export RANGER_DEVICONS_SEPARATOR=" "

# ==============================================
# zoxide configuration
# ==============================================
# Specify the directory in which the database is stored
# _ZO_DATA_DIR must be an absolute dir 
export _ZO_DATA_DIR="/home/uzvg/.local/share/"
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
# 提升rust编译速度
# ==============================================
# 启用sccache 提升rust编译速度，Need install sccache before this
export RUSTC_WRAPPER=sccache

# 使用 mold 极速链接
# export RUSTFLAGS="-C link-arg=-fuse-ld=mold"  # 若使用 mold

# ==============================================
# 在终端中启动系统代理2080/3067
# ==============================================
export http_proxy="http://127.0.0.1:2080"
export https_proxy="http://127.0.0.1:2080"
export all_proxy="socks5://127.0.0.1:2080"

# export http_proxy="http://127.0.0.1:3067"
# export https_proxy="http://127.0.0.1:3067"
# export all_proxy="socks5://127.0.0.1:3067"
#

# ==============================================
# 指定superfile/yazi 的运行时暂存路径
# ==============================================
# export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
export YAZI_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/yazi/lastdir"


