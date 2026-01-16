#!/usr/bin/zsh

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯SeparatorPlaceHolder⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
setopt clobber
#
export RIME_USER_PATH="$HOME/.config/ibus/rime"
# editor
export EDITOR='nvim'

#----------------------------------------------
# Qt 应用程序放大
#   让obs、微信、wps等原先hidpi适配不正常的程序放大1.2倍
#   但也会将原先正常缩放的程序如Anki，goldendict放大1.2
#   建议使用在单个Qt程度程序上，而非全局环境变量
#----------------------------------------------
#export QT_FONT_DPI=120

#----------------------------------------------
# aliyunpan-go 配置文件目录
export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/config"
#----------------------------------------------

# Git仓库文件夹路径
export GIT_REPO_DIR="$HOME/Documents/gitRepos"

#--------------------------------------------
# 需要备份的相关数据
#--------------------------------------------
#export LOGSEQ_DIR="$HOME/Documents/WorkSpace"
#export RIME_SYNC_PATH="$HOME/Documents/Repos/rime"
#export DOTFILES_PATH="$XDG_DATA_HOME/chezmoi"


#--------------------------------------------
# ranger config
# DEPRACATED: Using yazi instead.
# 避免ranger重新加载配置文件
#--------------------------------------------
#export RANGER_LOAD_DEFAULT_RC=false
#export RANGER_DEVICONS_SEPARATOR=" "


#--------------------------------------------
# zoxide configuration
# Specify the directory in which the database is stored
# _ZO_DATA_DIR must be an absolute dir 
#--------------------------------------------
export _ZO_DATA_DIR="/home/uzvg/.local/share/"
export _ZO_ECHO=0

#--------------------------------------------
# Tiddlywiki Path and port environment value
#--------------------------------------------
# export TIDDLYWIKI_DOCUMENT_PATH="/usr/lib/node_modules/tiddlywiki/editions/tw5.com"
# export TIDDLYWIKI_WKS_PATH="$HOME/Documents/wikis/WikiSpace"
# export TIDDLYWIKI_WKS_PORT=9191

#--------------------------------------------
# anki confirm compatibility with Qt6
#--------------------------------------------
# export DISABLE_QT5_COMPAT=1
# export SYNC_USER1="$mail:$password"
# export GTK_THEME="Adwaita"

#--------------------------------------------
# zellij environment
#--------------------------------------------
# export ZELLIJ_AUTO_ATTACH='false
# ZELLIJ_AUTO_EXIT='true'

#--------------------------------------------
#Enable wayland on firefox
#--------------------------------------------
# export MOZ_ENABLE_WAYLAND=1

#--------------------------------------------
# Default Merge tool for pacdiff
#--------------------------------------------
export DIFFPROG="/usr/bin/nvim"

#--------------------------------------------
# 用于zim-atuin中的函数清理机制
# 为什么需要清理？
#   内存优化: 插件加载完成后，辅助函数已无用处，可以释放内存
#   命名空间清洁: 避免函数名污染全局命名空间
#   安全考虑: 防止内部函数被外部误用
# tips: 可以使用typeset -f |grep <辅助函数> 来验证
#--------------------------------------------
export ZIM_PLUGIN_CLEANUP=1
#--------------------------------------------
# mpd host socket configuration
export MPD_HOST="$XDG_RUNTIME_DIR/mpd/socket"
