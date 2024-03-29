#!/usr/bin/zsh

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯SeparatorPlaceHolder⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
# unsetopt completealiases
#
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯设置输入法框架⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
local function setIm () {
	case $1 in
		fcitx ):
			# fcitx5 输入法相关配置
			# https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
			export INPUT_METHOD=fcitx
			export GTK_IM_MODULE=fcitx
			export QT_IM_MODULE=fcitx
			export XMODIFIERS=@im=fcitx
			export SDL_IM_MODULE=fcitx
			export GLFW_IM_MODULE=ibus
			export RIME_USER_PATH="$HOME/.local/share/fcitx5/rime";;
		ibus ):
			# ibus输入法相关设置
			export INPUT_METHOD=ibus
			export GTK_IM_MODULE=ibus
			export QT_IM_MODULE=ibus
			export XMODIFIERS=@im=ibus
			export RIME_USER_PATH="$HOME/.config/ibus/rime";;
		* ):
			error "Wrong Input Module Settings"
	esac
}

setIm ibus

# editor
export EDITOR='nvim'

# zsh config dir
export ZSH_CFG_DIR="$HOME/.config/zsh/"

# aliyunpan-go 配置文件目录
export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/config"

# Git克隆仓库
export GIT_REPO_DIR="$HOME/Documents/gitRepos"

# 需要备份的相关数据
export LOGSEQ_DIR="$HOME/Documents/WorkSpace"
export RIME_SYNC_PATH="$HOME/Documents/gitRepos/rime"
export DOTFILES_PATH="$XDG_DATA_HOME/chezmoi"

# ranger config
# 避免ranger重新加载配置文件
export RANGER_LOAD_DEFAULT_RC=false
export RANGER_DEVICONS_SEPARATOR=" "


# blog 博客相关配置
export blogDir="$HOME/Documents/Blog/coffee周报"
export publishDir="$blogDir/public"

# remote 远程服务器
export CloudServer="124.222.107.205"
export CloudUser="root"
#export CloudUser="ubuntu"
#export CloudUser="lighthouse"
export RemoteUser="$CloudUser@$CloudServer"

# zoxide 配置
# Specifies the directory in which the database is stored
export _ZO_DATA_DIR="$XDG_DATA_HOME"
export _ZO_ECHO=0

# 需要备份的cache目录
cacheDir=()
cacheDir+=("$HOME/.cache/netease-cloud-music")
cacheDir+=("$HOME/.cache/goldendict")

# ssh私钥文件
export PrivKey="$HOME/.ssh/id_rsa"
export PubKey="$HOME/.ssh/id_rsa.pub"

# gnome-shell theme folder
export GNOME_SHELL_THEME_FOLDER="$HOME/Documents/gitRepos/gnome-shell/data/theme"
export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_WAYLAND_DECORATION=adwaita
# export GnomeShellTheme="$HOME/.local/share/themes/adwaita-dakr-shell-theme/gnome-shell/gnome-shell.css"

# USUAL config dir

export ARCHIVE_REMOTE_HTTPS="https://e.coding.net/zerolaboratory/linux-dotfiles/archives.git"
export ARCHIVE_REMOTE_SSH="git@e.coding.net:zerolaboratory/linux-dotfiles/archives.git"
export ARCHIVE_DESTINATION_DIR="$HOME/Documents/archives"
export ARCHIVE_EXCLUDE_FILE="$XDG_CONFIG_HOME/archive_exclude.txt"

ARCHIVE_LIST=()
ARCHIVE_LIST+=("$HOME/.local/share/gnome-shell/extensions")
ARCHIVE_LIST+=("$HOME/.local/share/applications")
ARCHIVE_LIST+=("$HOME/.config/nvim/plugged")
ARCHIVE_LIST+=("$HOME/.cache/netease-cloud-music/Cef")
ARCHIVE_LIST+=("$HOME/.logseq")
ARCHIVE_LIST+=("$HOME/.zim")
ARCHIVE_LIST+=("$HOME/.local/share/icons")
# ARCHIVE_LIST+=("$ALIYUNPAN_CONFIG_DIR")

# Tiddlywiki 相关配置
export TIDDLYWIKI_COFFEE_PATH="$HOME/Documents/wikis/coffee-weekly"
export TIDDLYWIKI_COFFEE_PORT=8090
export TIDDLYWIKI_PRACTICE_PATH="$HOME/Documents/wikis/practice"
export TIDDLYWIKI_PRACTICE_PORT=9090
export TIDDLYWIKI_LOVEPOEM_PATH="$HOME/Documents/wikis/LovePoemForJiayu"
export TIDDLYWIKI_LOVEPOEM_PORT=9999
export TIDDLYWIKI_DOCUMENT_PATH="/usr/lib/node_modules/tiddlywiki/editions/tw5.com"
export TIDDLYWIKI_DOCUMENT_PORT=9898
export TIDDLYWIKI_COLLECTION_PATH="$HOME/Documents/wikis/TiddlywikiCollections"

# anki confirm compatibility with Qt6
# export DISABLE_QT5_COMPAT=1
# export SYNC_USER1="1497911983@qq.com:54264hui936"
# export GTK_THEME="Adwaita"

# proxy config
# export http_proxy=http://127.0.0.1:2081
# export https_proxy=http://127.0.0.1:2081


# zellij environment
export ZELLIJ_AUTO_ATTACH='false'
export ZELLIJ_AUTO_EXIT='true'
export TERMINAL='alacritty'
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯Enable wayland on firefox⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
export MOZ_ENABLE_WAYLAND=1

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯Default Merge tool for pacdiff⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯#
export DIFFPROG="/usr/bin/nvim"
