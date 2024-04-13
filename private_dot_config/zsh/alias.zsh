# 常用命令替换
alias ls='eza --icons'
# alias ls='lsd'
alias la='ls -a'
alias l='ls -lha'
alias g='lazygit'
alias c='bat'
alias e="$EDITOR"
alias se="sudoedit"
alias q='exit'
alias Q='exit'
# alias du="dust -r -X Games"
alias du="dust -X Games"
alias df="duf"
alias zlj="zellij"
alias tt='taskwarrior-tui'
alias udd='update-desktop-database $XDG_DATA_HOME/applications/'
alias fd="fd -H -E Games"
alias t="btop"
alias wd="sdcv --color"
alias gedit="gnome-text-editor"
alias vim="$EDITOR"
alias rlc="source $HOME/.zshrc"
alias macc="macchina -t Helium"

# chezmoi shortcuts
alias czm="chezmoi"
alias czmr="chezmoi re-add"
alias czmcd="chezmoi cd"
alias czmd="chezmoi managed -i dirs"
alias czmf="chezmoi managed -i files"
alias czma="chezmoi add --follow"
alias czmst="chezmoi status"

# eww widget shortcuts
alias oew="eww open example"
alias cew="eww close-all"

# joshuto
# ranger-like file manager written in rust
alias js="joshuto"
alias jsrc="$EDITOR $XDG_CONFIG_HOME/joshuto/joshuto.toml"

# alacritty config
alias alacfg="$EDITOR $XDG_CONFIG_HOME/alacritty/alacritty.yml"

# kitty config 
# alias ktcfg="$EDITOR $XDG_CONFIG_HOME/kitty/kitty.conf"

# hyprland config
#alias hyprcfg="$EDITOR $HOME/.config/hypr/hyprland.conf"
#alias hyprinit="$EDITOR $HOME/.config/hypr/hyprinit.conf"
#alias hyprbind="$EDITOR $HOME/.config/hypr/hyprbinds.conf"
#alias hyprule="$EDITOR $HOME/.config/hypr/hyprules.conf"
#alias swidlecfg="$EDITOR $XDG_CONFIG_HOME/swayidle/config"

# waybar config
#alias wbarcfg="$EDITOR $XDG_CONFIG_HOME/waybar/config"
#alias wbarstyle="$EDITOR $XDG_CONFIG_HOME/waybar/style.css"

# rime input method
alias ckemj="bat /usr/share/rime-data/opencc/emoji_word.txt"

#CloudServer
alias rmsv="ssh -i $HOME/.ssh/id_rsa -l $CloudUser $CloudServer"

# docker shortcuts
# alias dkstart="systemctl start docker.service"

# fontconfig
alias ftcfg="$EDITOR $HOME/.config/fontconfig/conf.d/04-prefer-fonts-for-each-class.conf"

# 同步配置文件
alias dotfiles="lazygit -p $HOME/.local/share/chezmoi"

# systemctl
alias sss="systemctl status"

# git bare repository to manage dotfiles
#alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#config config status.showUntrackedFiles no

# tiddlywiki shortcuts
alias tw="tiddlywiki"
alias twProduct="twLaunch $TIDDLYWIKI_PRODUCT_PATH $TIDDLYWIKI_PRODUCT_PORT"
alias cfw="twLaunch $TIDDLYWIKI_COFFEE_PATH $TIDDLYWIKI_COFFEE_PORT"
alias lovePoem="twLaunch $TIDDLYWIKI_LOVEPOEM_PATH $TIDDLYWIKI_LOVEPOEM_PORT"
alias twTemp="twLaunch $HOME/Documents/wikis/tempWiki 9981"
alias twPrac="twLaunch $TIDDLYWIKI_PRACTICE_PATH $TIDDLYWIKI_PRACTICE_PORT"
alias twDoc="twLaunch $TIDDLYWIKI_DOCUMENT_PATH $TIDDLYWIKI_DOCUMENT_PORT"
alias twShiraz="tiddlywiki --load $TIDDLYWIKI_COLLECTION_PSTH/tiddlywiki_shiraz.html --listen port=1980"
alias lovePoemDeploy="rsync -av --delete $TIDDLYWIKI_LOVEPOEM_PATH/output/index.html $RemoteUser:/www/wwwroot/jiangyuanandjiayu.love/"

# ranger config
alias ra="ranger"
alias rgcfg="$EDITOR $XDG_CONFIG_HOME/ranger/rc.conf"

# hugo shortcuts
# alias hgs="hugo server -s $blogDir"
# alias hgd="hugo server -s $blogDir -D"

# 是否关闭笔记本键盘
# alias diskb='xinput --set-prop 8 "Device Enabled" 0'
# alias ebkb='xinput --set-prop 8 "Device Enabled" 1'

# gnome-terminal 主题修改👉https://gogh-co.github.io/Gogh/
# alias gogh= bash -c "$(curl -sLo- https://git.io/vQgMr)"

# zimfw alias
alias zimrc="$EDITOR $HOME/.zimrc"
# starship config
alias ssrc="$EDITOR $HOME/.config/starship.toml"

# tmux config
alias tmxcfg="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"

# zellij config
alias zljcfg="$EDITOR $XDG_CONFIG_HOME/zellij/config.kdl"

# pip_search:the replacement of "pip search"
alias pip="_pip"

# Enlarge steam UI
alias steam="steam -forcedesktopscaling=1.25"

# neofetch
alias ff="fastfetch"

# check nvidia status
alias nvss="watch -n 2 -d nvidia-smi"

# pacman command
alias pacinfo="pacman -Si"

# gdu for excluding Games disk
alias gdu="gdu -i $HOME/Games"

# grep
# alias grep="grep -v grep"

# shadowsocks
# start shadowsocks service
# alias ssstart="sudo sslocal -c /etc/shadowsocks/config.json -d start"
# alias ssstop="sudo sslocal -c /etc/shadowsocks/config.json -d stop"
