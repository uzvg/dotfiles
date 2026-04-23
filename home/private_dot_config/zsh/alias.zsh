#================= Some Simple Aliases =================
alias ls='lsd'
alias la='lsd -a'
alias l='lsd -lha'
alias ll='lsd -lha'
alias g='lazygit'
alias c='bat'
alias t="btop --config $XDG_CONFIG_HOME/btop/btop_proc_only.conf --preset 1"
alias e="$EDITOR"
alias vim="$EDITOR"
# alias hx="helix"
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

# zellij alias
alias zj="zellij"
# open zjdoc
zellij_doc_url="https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl"
alias zjdoc="gio open $zellij_doc_url" &> /dev/null
# zellij config
alias zjrc="chezmoi_edit $XDG_CONFIG_HOME/zellij/config.kdl"

# alias tt='taskwarrior-tui'

#================= edit and/or reload config file ================= #
# Edit and reload zshrc file
alias zshrc="chezmoi_edit '$ZDOTDIR/.zshrc'"
# Edit and reload alias file
alias alrc="chezmoi_edit '$ZDOTDIR/alias.zsh'"
# Edit and reload env file
alias envrc="chezmoi_edit '$ZDOTDIR/env.zsh'"
# Edit and reload funcs file
# alias funrc="chezmoi_edit '$ZDOTDIR/functions.zsh'"
# edit fontconfig
alias ftrc="chezmoi_edit $XDG_CONFIG_HOME/fontconfig/conf.d/40-family-prefer.conf"
# edit zimrc file
alias zimrc="chezmoi_edit $ZDOTDIR/.zimrc"
# edit wezterm config file
# alias wtrc="_chezmoi_edit $HOME/.config/wezterm/wezterm.lua"
# edit chezmoi config
alias czmrc="chezmoi edit-config-template"
# use chezmoi init to make it work

#=================Use git bare repository to manage dotfiles=================
# alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# config config status.showUntrackedFiles no

#================= chezmoi shortcuts ================= #
alias czm="chezmoi"
alias czmr="chezmoi re-add"
alias czmcd="chezmoi cd"
alias czmd="chezmoi managed -i dirs"
alias czmf="chezmoi managed -i files"
# alias czma="chezmoi apply"
# alias czme="chezmoi edit --apply"
alias ce="chezmoi_edit"
alias czmst="chezmoi status"

# eww widget shortcuts
# alias oew="eww open example"
# alias cew="eww close-all"

# joshuto
# ranger-like file manager written in rust
# alias js="joshuto"
# alias jsrc="$EDITOR $XDG_CONFIG_HOME/joshuto/joshuto.toml"

# alacritty config
alias altrc="chezmoi_edit $XDG_CONFIG_HOME/alacritty/alacritty.toml"

# kitty config 
alias ktyrc="chezmoi_edit $XDG_CONFIG_HOME/kitty/kitty.conf"

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
alias rimeicon="rime_edit '$RIME_USER_PATH/uggx_fluency.custom.yaml'"
alias rimewd="rime_edit '$RIME_USER_PATH/custom_phrase.txt'"
# alias get-ascii-mode="gdbus call --session \
#   --dest com.github.rime.ibus.Rime \
#   --object-path /com/github/rime/ibus/Rime \
#   --method com.github.rime.ibus.Rime.AsciiMode.GetAsciiMode"

# CloudServer
# alias rmsv="ssh -i $HOME/.ssh/id_rsa -l $CloudUser $CloudServer"

# docker shortcuts
# alias dkstart="systemctl start docker.service"

# manage dotfiles
alias dotfiles="lazygit -p $XDG_DATA_HOME/chezmoi"

# uzvg zsh plugins dir
alias uzpd="lazygit -p '$ZDOTDIR/plugins'"

# systemctl
alias sss="systemctl status"
alias wkstatus="systemctl status wikispace --user"
alias wkstart="systemctl start wikispace --user"
alias wkstop="systemctl stop wikispace --user"
alias wkrestart="systemctl restart wikispace --user"

# clean journalctl file
alias logclean="sudo journalctl --vacuum-size=200M"

# hugo shortcuts
# alias hgs="hugo server -s $blogDir"
# alias hgd="hugo server -s $blogDir -D"

# gnome-terminal 主题修改👉https://gogh-co.github.io/Gogh/
# alias gogh= bash -c "$(curl -sLo- https://git.io/vQgMr)"

# starship config
# alias ssrc="$EDITOR $HOME/.config/starship.toml"

# tmux config
# alias tmxcfg="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"

# neofetch
alias ff="fastfetch"

# check nvidia status
# alias nvss="watch -n 2 -d nvidia-smi"

# gdu but exclude Games disk
alias gdu="gdu -i $HOME/Games -i $HOME/ExtendDisk"

# shadowsocks
# start shadowsocks service
# alias ssstart="sudo sslocal -c /etc/shadowsocks/config.json -d start"
# alias ssstop="sudo sslocal -c /etc/shadowsocks/config.json -d stop"
#

# starship config
# alias stcfg="$EDITOR $XDG_CONFIG_HOME/starship.toml"

# Killing motherfucker QQ, wechat & steam background
alias fkqq="killall qq"
alias fkvv="flatpak kill com.valvesoftware.Steam"
alias fkwc="flatpak kill com.tencent.WeChat"

# jump to bottles directory
alias btshome="cd .var/app/com.usebottles.bottles/data/bottles/bottles/Quark-Drive/drive_c/users/steamuser"

# Replace sudo with sudo-rs
# alias sudo="sudo-rs"

# Sync system time
alias timesync="systemctl restart systemd-timesyncd.service"

# sync wallpapers
alias wpsync="rclone sync $HOME/Pictures/Wallpapers OneDrive:Wallpapers --progress"

# daed 管理快捷命令
# alias ddstart='systemctl start dae.service'
# alias ddstop='systemctl stop dae.service'
# alias ddrestart='systemctl restart dae.service'
# alias ddrld='systemctl reload dae.service'
# alias ddst='systemctl status dae.service'
# 查看实时日志 (显示最后50行并持续滚动)
# alias ddlog='journalctl -u dae.service -f -n 50'
# alias ddlg='journalctl -u dae.service -f -o cat'
# alias daerc="chezmoi_edit $XDG_CONFIG_HOME/dae/config.dae"
