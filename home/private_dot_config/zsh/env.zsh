#!/usr/bin/zsh

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯SeparatorPlaceHolder⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# unsetopt completealiases
# alias命令tab补全
# setopt completealiases
setopt clobber
#
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯xdg home dir config⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# 不用手动定义，直接使用xdg-dirs-update命令更新
#
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_RUNNING_HOME="/run/user/$(id -u)"
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯设置输入法框架⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# local function setIm () {
# 	case $1 in
# 		fcitx ):
# 			# fcitx5 输入法相关配置
# 			# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
# 			export INPUT_METHOD=fcitx
# 			export GTK_IM_MODULE=fcitx
# 			export QT_IM_MODULE=fcitx
# 			export XMODIFIERS=@im=fcitx
# 			export SDL_IM_MODULE=fcitx
# 			export GLFW_IM_MODULE=ibus
# 			export RIME_USER_PATH="$HOME/.local/share/fcitx5/rime";;
# 		ibus ):
# 			# ibus输入法相关设置
# 			export INPUT_METHOD=wayland
# 			# export INPUT_METHOD=ibus
# 			export GTK_IM_MODULE=ibus
# 			export GLFW_IM_MODULE=ibus
# 			export QT_IM_MODULE=ibus
# 			export XMODIFIERS=@im=ibus
# 			export RIME_USER_PATH="$HOME/.config/ibus/rime";;
# 		* ):
# 			error "Wrong Input Module Settings"
# 	esac
# }
# setIm ibus
export RIME_USER_PATH="$HOME/.config/ibus/rime"

# editor
export EDITOR='nvim'
#
# 让obs、微信、wps等原先hidpi适配不正常的程序放大1.2倍，但也会将原先正常缩放的程序如Anki，goldendict放大1.2
# 建议使用在单个Qt程度程序上，而非全局环境变量
# export QT_FONT_DPI=120

# zsh config dir
# Deprecated USE ZDOTDIR
# export ZSH_CFG_DIR="$HOME/.config/zsh/"

# aliyunpan-go 配置文件目录
export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/config"

# Git克隆仓库
export GIT_REPO_DIR="$HOME/Documents/gitRepos"

# 需要备份的相关数据
# export LOGSEQ_DIR="$HOME/Documents/WorkSpace"
# export RIME_SYNC_PATH="$HOME/Documents/Repos/rime"
# export DOTFILES_PATH="$XDG_DATA_HOME/chezmoi"

# ranger config
# 避免ranger重新加载配置文件
# export RANGER_LOAD_DEFAULT_RC=false
# export RANGER_DEVICONS_SEPARATOR=" "

# blog 博客相关配置
# export blogDir="$HOME/Documents/Blog/coffee周报"
# export publishDir="$blogDir/public"

# remote 远程服务器
# export CloudServer="124.222.107.205"
# export CloudUser="root"
# export CloudUser="ubuntu"
# export CloudUser="lighthouse"
# export RemoteUser="$CloudUser@$CloudServer"

# =============== zoxide 配置 ================ #

# Specifies the directory in which the database is stored
# _ZO_DATA_DIR must be an absolute dir 
# export _ZO_DATA_DIR="$XDG_DATA_HOME"
export _ZO_DATA_DIR="/home/uzvg/.local/share/"
export _ZO_ECHO=0

# gnome-shell theme folder
# export GNOME_SHELL_THEME_FOLDER="$HOME/Documents/gitRepos/gnome-shell/data/theme"
# export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_WAYLAND_DECORATION=adwaita
# export GnomeShellTheme="$HOME/.local/share/themes/adwaita-dakr-shell-theme/gnome-shell/gnome-shell.css"

# Tiddlywiki 相关配置
# export TIDDLYWIKI_PATH="$HOME/Documents/wikis"
# export TIDDLYWIKI_COFFEE_PATH="$HOME/Documents/wikis/coffee-weekly"
# export TIDDLYWIKI_COFFEE_PORT=8090
# export TIDDLYWIKI_PRACTICE_PATH="$HOME/Documents/wikis/practice"
# export TIDDLYWIKI_PRACTICE_PORT=9090
# #export TIDDLYWIKI_LOVEPOEM_PATH="$HOME/Documents/wikis/LovePoemForJiayu"
# export TIDDLYWIKI_LOVEPOEM_PORT=9999
# export TIDDLYWIKI_DOCUMENT_PATH="/usr/lib/node_modules/tiddlywiki/editions/tw5.com"
# export TIDDLYWIKI_DOCUMENT_PORT=9898
# export TIDDLYWIKI_COLLECTION_PATH="$HOME/Documents/wikis/TiddlywikiCollections"
# 
export TIDDLYWIKI_WKS_PATH="$HOME/Documents/wikis/WikiSpace"
export TIDDLYWIKI_WKS_PORT=9191
# export TIDDLYWIKI_PRODUCT_PATH="$HOME/Documents/wikis/twProduct"
# export TIDDLYWIKI_PRODUCT_PORT=8989

# anki confirm compatibility with Qt6
# export DISABLE_QT5_COMPAT=1
# export SYNC_USER1="$mail:$password"
# export GTK_THEME="Adwaita"

# proxy config
# export http_proxy=http://127.0.0.1:2081
# export https_proxy=http://127.0.0.1:2081


# zellij environment
# export ZELLIJ_AUTO_ATTACH='false'
# ZELLIJ_AUTO_EXIT='true'
#
# =============== Enable wayland on firefox ======================
export MOZ_ENABLE_WAYLAND=1

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯Default Merge tool for pacdiff⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
export DIFFPROG="/usr/bin/nvim"

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯  Nvidia Related Environment Variable ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# export VDPAU_DRIVER="nvidia"
# export DRI_PRIME=1
# export __NV_PRIME_RENDER_OFFLOAD=1
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export LIBVA_DRIVER_NAME="vdpau"
# export VDPAU_DRIVER="nvidia"
# export __NV_PRIME_RENDER_OFFLOAD=1
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
# export DRI_PRIME=pci-0000_01_00_0
# export __VK_LAYER_NV_optimus=NVIDIA_only

# function zvm_config() {
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
#   ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
# }

# source ~/zsh-vi-mode.zsh
# export RANGER_LOAD_DEFAULT_RC=false
