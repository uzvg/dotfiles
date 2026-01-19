#================= Some Simple Aliases ================= #
alias ls='lsd'
alias la='lsd -a'
alias l='lsd -lha'
alias ll='lsd -lha'
alias g='lazygit'
alias c='bat'
alias t="btop --config $XDG_CONFIG_HOME/btop/btop_proc_only.conf --preset 1"
alias e="$EDITOR"
alias vim="$EDITOR"
alias hx="helix"
alias se="sudoedit"
alias q='exit'
alias Q='exit'
alias zdebug='time ZSH_DEBUGRC=1 zsh -i -c exit'
alias df="duf"
alias du="dust -X Games"
alias fd="fd -H -E Games -E ExtendDisk"
alias udd='update-desktop-database $XDG_DATA_HOME/applications/'
alias gedit="gnome-text-editor"
alias macc="macchina -t Helium"
#alias ls='eza --icons'
# alias du="dust -r -X Games"
# zellij alias
# alias zj="zellij"
# open zjdoc
zellij_doc_url="https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl"
alias zjdoc="gio open $zellij_doc_url" &> /dev/null
# zellij config
alias zjrc="_chezmoi_edit $XDG_CONFIG_HOME/zellij/config.kdl"

# alias tt='taskwarrior-tui'
# alias rlc="source $HOME/.zshrc"

#================= edit and/or reload config file ================= #
# Edit and reload zshrc file
alias zshrc="_chezmoi_edit '$ZDOTDIR/.zshrc'"
# Edit and reload alias file
alias alrc="_chezmoi_edit '$ZDOTDIR/alias.zsh'"
# Edit and reload env file
alias envrc="_chezmoi_edit '$ZDOTDIR/env.zsh'"
# Edit and reload funcs file
alias funrc="_chezmoi_edit '$ZDOTDIR/functions.zsh'"
# edit fontconfig
alias ftrc="_chezmoi_edit $HOME/.config/fontconfig/conf.d/04-prefer-fonts-for-each-class.conf"
# aliyunpan-go config
# alias alyrc="$_chezmoi_edit $ALIYUNPAN_CONFIG_DIR/aliyunpan_config.json"
# edit zimrc file
alias zimrc="_chezmoi_edit $ZDOTDIR/.zimrc"
# edit atuin file
# alias atrc="_chezmoi_edit $HOME/.config/atuin/config.toml"
# edit wezterm config file
# alias wtrc="_chezmoi_edit $HOME/.config/wezterm/wezterm.lua"
# edit chezmoi config
alias czmrc="chezmoi edit-config-template"

#================= dotfiles management ================= #
# alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#
#================= chezmoi shortcuts ================= #
alias czm="chezmoi"
alias czmr="chezmoi re-add"
alias czmcd="chezmoi cd"
alias czmd="chezmoi managed -i dirs"
alias czmf="chezmoi managed -i files"
alias czma="chezmoi apply"
alias czme="chezmoi edit --apply"
alias czmst="chezmoi status"
# alias czma="chezmoi add --follow"

# eww widget shortcuts
# alias oew="eww open example"
# alias cew="eww close-all"

# joshuto
# ranger-like file manager written in rust
# alias js="joshuto"
# alias jsrc="$EDITOR $XDG_CONFIG_HOME/joshuto/joshuto.toml"

# alacritty config
alias altrc="_chezmoi_edit $XDG_CONFIG_HOME/alacritty/alacritty.toml"

# kitty config 
# alias ktcfg="$EDITOR $XDG_CONFIG_HOME/kitty/kitty.conf"

# hyprland config
# alias hyprcfg="$EDITOR $HOME/.config/hypr/hyprland.conf"
# alias hyprinit="$EDITOR $HOME/.config/hypr/hyprinit.conf"
# alias hyprbind="$EDITOR $HOME/.config/hypr/hyprbinds.conf"
# alias hyprule="$EDITOR $HOME/.config/hypr/hyprules.conf"
# alias swidlecfg="$EDITOR $XDG_CONFIG_HOME/swayidle/config"

# waybar config
# alias wbarcfg="$EDITOR $XDG_CONFIG_HOME/waybar/config"
# alias wbarstyle="$EDITOR $XDG_CONFIG_HOME/waybar/style.css"

# rime input method
alias ckemj="bat /usr/share/rime-data/opencc/emoji_word.txt"

# CloudServer
# alias rmsv="ssh -i $HOME/.ssh/id_rsa -l $CloudUser $CloudServer"

# docker shortcuts
# alias dkstart="systemctl start docker.service"

# manage dotfiles
alias dotfiles="lazygit -p $HOME/.local/share/chezmoi"
# git bare repository to manage dotfiles
#alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#config config status.showUntrackedFiles no

# systemctl
alias sss="systemctl status"
alias wkstatus="systemctl status wikispace --user"
alias wkrestart="systemctl restart wikispace --user"

# clean journalctl file
alias logclean="sudo journalctl --vacuum-size=200M"

# tiddlywiki shortcuts
# alias tw="tiddlywiki"
# alias twProduct="twLaunch $TIDDLYWIKI_PRODUCT_PATH $TIDDLYWIKI_PRODUCT_PORT"
# alias twks="_tw_launch $TIDDLYWIKI_WKS_PATH $TIDDLYWIKI_WKS_PORT"
# alias cfw="twLaunch $TIDDLYWIKI_COFFEE_PATH $TIDDLYWIKI_COFFEE_PORT"
# alias lovePoem="twLaunch $TIDDLYWIKI_LOVEPOEM_PATH $TIDDLYWIKI_LOVEPOEM_PORT"
# alias twTemp="twLaunch $HOME/Documents/wikis/tempWiki 9981"
# alias twPrac="twLaunch $TIDDLYWIKI_PRACTICE_PATH $TIDDLYWIKI_PRACTICE_PORT"
# alias twdoc="_tw_launch ${TIDDLYWIKI_DOCUMENT_PATH} 8080"
# alias twShiraz="tiddlywiki --load $TIDDLYWIKI_COLLECTION_PSTH/tiddlywiki_shiraz.html --listen port=1980"
# alias lovePoemDeploy="rsync -av --delete $TIDDLYWIKI_LOVEPOEM_PATH/output/index.html $RemoteUser:/www/wwwroot/jiangyuanandjiayu.love/"
# alias wkspace="nohup tzk listen > /dev/null 2>&1 &"

# hugo shortcuts
# alias hgs="hugo server -s $blogDir"
# alias hgd="hugo server -s $blogDir -D"

# 是否关闭笔记本键盘
# alias diskb='xinput --set-prop 8 "Device Enabled" 0'
# alias ebkb='xinput --set-prop 8 "Device Enabled" 1'

# gnome-terminal 主题修改👉https://gogh-co.github.io/Gogh/
# alias gogh= bash -c "$(curl -sLo- https://git.io/vQgMr)"

# starship config
# alias ssrc="$EDITOR $HOME/.config/starship.toml"

# tmux config
# alias tmxcfg="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"


# pip_search:the replacement of "pip search"
# Need to install pip-search
# alias pip="_pip"

# Enlarge steam UI
# alias steam="steam -forcedesktopscaling=1.25"

# neofetch
alias ff="fastfetch"

# check nvidia status
# alias nvss="watch -n 2 -d nvidia-smi"

# pacman command
# alias pacinfo="pacman -Si"

# gdu but exclude Games disk
alias gdu="gdu -i $HOME/Games -i $HOME/ExtendDisk"

# shadowsocks
# start shadowsocks service
# alias ssstart="sudo sslocal -c /etc/shadowsocks/config.json -d start"
# alias ssstop="sudo sslocal -c /etc/shadowsocks/config.json -d stop"
#

# starship config
# alias stcfg="$EDITOR $XDG_CONFIG_HOME/starship.toml"

# Fucking killing QQ, wechat & steam
alias fkqq="killall qq"
alias fkvv="flatpak kill com.valvesoftware.Steam"
alias fkwc="flatpak kill com.tencent.WeChat"

# bottles path

alias btshome="cd .var/app/com.usebottles.bottles/data/bottles/bottles/Quark-Drive/drive_c/users/steamuser"

# Replace sudo with sudo-rs
# alias sudo="sudo-rs"

# Sync system time
# alias timesync="systemctl restart systemd-timesyncd.service"
