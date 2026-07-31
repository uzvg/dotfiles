# ==============================================
# General aliases
# ==============================================
alias ls='lsd'
alias la='lsd -a'
alias l='lsd -lha'
alias ll='lsd -lha'
alias g='lazygit'
alias c='bat'
alias t="btop --config $XDG_CONFIG_HOME/btop/btop_proc_only.conf --preset 1"
alias e="$EDITOR"
# alias hx="helix"
alias se="sudoedit"
alias q='exit'
alias Q='exit'
alias zdebug='time ZSH_DEBUGRC=1 zsh -i -c exit'
alias df="duf"
# alias du="dust -X Games"
alias du="dust"
# alias fd="fd -H -E Games -E ExtendDisk"
alias udd='update-desktop-database $XDG_DATA_HOME/applications/'
alias gedit="gnome-text-editor"
alias macc="macchina -t Helium"
# gdu but exclude Games disk
# alias gdu="gdu -i $HOME/Games -i $HOME/ExtendDisk"
alias ff="fastfetch"

# ==============================================
# zellij alias
# ==============================================
# alias zj="zellij"
# zellij_doc_url="https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl"
# alias zjdoc="gio open $zellij_doc_url" &> /dev/null
# alias zjrc="chezmoi_edit $XDG_CONFIG_HOME/zellij/config.kdl"

# ==============================================
# taskwarrior-tui alias
# ==============================================
alias tt='taskwarrior-tui'

# ==============================================
# zsh
# ==============================================
alias zshrc="chezmoi_edit '$ZDOTDIR/.zshrc'"
alias alrc="chezmoi_edit '$ZDOTDIR/alias.zsh'"
alias envrc="chezmoi_edit '$ZDOTDIR/env.zsh'"
alias zimrc="chezmoi_edit $ZDOTDIR/.zimrc"

# ----------------------------------------------
# chezmoi edit
# ----------------------------------------------
# fontconfig
alias ftrc="chezmoi_edit $XDG_CONFIG_HOME/fontconfig/conf.d/40-family-prefer.conf"

# wezterm
# alias wtrc="_chezmoi_edit $HOME/.config/wezterm/wezterm.lua"

# alacritty
alias altrc="chezmoi_edit $XDG_CONFIG_HOME/alacritty/alacritty.toml"

# kitty
alias ktrc="chezmoi_edit $XDG_CONFIG_HOME/kitty/kitty.conf"
alias ktmp="chezmoi_edit $XDG_CONFIG_HOME/kitty/keymaps.conf"
alias ktbrc="chezmoi_edit $XDG_CONFIG_HOME/kitty/tab_bar.conf"

# ==============================================
# git bare repository alias for managing dotfiles
# (Replaced by chezmoi)
# ==============================================
# alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# config config status.showUntrackedFiles no

# ==============================================
# chezmoi
# ==============================================
alias czm="chezmoi"
alias czmr="chezmoi re-add"
alias czmcd="chezmoi cd"
# list directories managed by chezmoi
alias czmd="chezmoi managed -i dirs"
# list files managed by chezmoi
alias czmf="chezmoi managed -i files"
alias ce="chezmoi_edit"
alias czmst="chezmoi status"

# edit chezmoi config
#   use chezmoi init to make it work
alias czmrc="chezmoi edit-config-template"

# ==============================================
# edit eww widget config alias
# ==============================================
# alias oew="eww open example"
# alias cew="eww close-all"

# ==============================================
# joshuto, a ranger-like file manager written in rust
# (Replaced by yazi)
# ==============================================
# alias js="joshuto"
# alias jsrc="$EDITOR $XDG_CONFIG_HOME/joshuto/joshuto.toml"

# ==============================================
# hyprland config
# ==============================================
# alias hyprcfg="$EDITOR $HOME/.config/hypr/hyprland.conf"
# alias hyprinit="$EDITOR $HOME/.config/hypr/hyprinit.conf"
# alias hyprbind="$EDITOR $HOME/.config/hypr/hyprbinds.conf"
# alias hyprule="$EDITOR $HOME/.config/hypr/hyprules.conf"
# alias swidlecfg="$EDITOR $XDG_CONFIG_HOME/swayidle/config"

# waybar config
# alias wbarcfg="$EDITOR $XDG_CONFIG_HOME/waybar/config"
# alias wbarstyle="$EDITOR $XDG_CONFIG_HOME/waybar/style.css"

# ==============================================
# rime input method alias
# ==============================================
# check rime emoji icons
alias ckemj="bat /usr/share/rime-data/opencc/emoji_word.txt"
# customize rime icon
alias rimeicon="rime_edit '$RIME_USER_PATH/uggx_fluency.custom.yaml'"
# edit rime custom_phrse.txt and re-deploy rime automatically
alias rimewd="rime_edit '$RIME_USER_PATH/custom_phrase.txt'"
# get rime ascii mode (deprecated, but still useful)
# alias get-ascii-mode="gdbus call --session \
#   --dest com.github.rime.ibus.Rime \
#   --object-path /com/github/rime/ibus/Rime \
#   --method com.github.rime.ibus.Rime.AsciiMode.GetAsciiMode"

# ==============================================
# wikispace
# ==============================================
alias wkstatus="systemctl status wikispace --user"
alias wkstart="systemctl start wikispace --user"
alias wkstop="systemctl stop wikispace --user"
alias wkrestart="systemctl restart wikispace --user"
alias wklog="journalctl --user --unit wikispace -f"

# ==============================================
# borg backup
# ==============================================
alias borgst="systemctl status borg-backup --user"
alias borgex="chezmoi_edit $XDG_CONFIG_HOME/borg/excludes"
alias borgls="borg list /mnt/backup/uzvg@archlinux"
alias borglog="journalctl --user --unit borg-backup -f"

# ==============================================
# systemd-related
# ==============================================
alias sss="systemctl status"
# clean journalctl file
alias logclean="sudo journalctl --vacuum-size=200M"
# Sync system time
alias timesync="systemctl restart systemd-timesyncd.service"

# ==============================================
# hugo
# ==============================================
# alias hgs="hugo server -s $blogDir"
# alias hgd="hugo server -s $blogDir -D"

# ==============================================
# Killing motherfucker QQ wechat & steam background jobs
# ==============================================
# alias fkqq="killall qq"
# alias fkvv="flatpak kill com.valvesoftware.Steam"
# alias fkwc="flatpak kill com.tencent.WeChat"

# ==============================================
# dae 管理快捷命令
# ==============================================
# alias ddstart='systemctl start dae.service'
# alias ddstop='systemctl stop dae.service'
# alias ddrestart='systemctl restart dae.service'
# alias ddrld='systemctl reload dae.service'
# alias ddst='systemctl status dae.service'
# 查看实时日志 (显示最后50行并持续滚动)
# alias ddlog='journalctl -u dae.service -f -n 50'
# alias ddlg='journalctl -u dae.service -f -o cat'
# alias daerc="chezmoi_edit $XDG_CONFIG_HOME/dae/config.dae"

# ==============================================
# mpd
# ==============================================
# mpd config
alias mpdrc="chezmoi_edit $XDG_CONFIG_HOME/mpd/mpd.conf"
alias rrc="chezmoi_edit $XDG_CONFIG_HOME/rmpc/config.ron"
# lyrics download tool
alias lyrics-tool="ZonyLrcTools.Cli"

# ==============================================
# others
# ==============================================
# gnome-terminal 主题修改👉https://gogh-co.github.io/Gogh/
# alias gogh= bash -c "$(curl -sLo- https://git.io/vQgMr)"

# starship config
# alias ssrc="$EDITOR $HOME/.config/starship.toml"

# tmux config
# alias tmxcfg="$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf"

# check nvidia status
# alias nvss="watch -n 2 -d nvidia-smi"

# shadowsocks
# start shadowsocks service
# alias ssstart="sudo sslocal -c /etc/shadowsocks/config.json -d start"
# alias ssstop="sudo sslocal -c /etc/shadowsocks/config.json -d stop"

# starship config
# alias stcfg="$EDITOR $XDG_CONFIG_HOME/starship.toml"

# edit ghostty config
alias gstrc="chezmoi_edit $XDG_CONFIG_HOME/ghostty/config.ghostty"

# yazi config
alias rarc="chezmoi_edit $XDG_CONFIG_HOME/yazi/yazi.toml"

# jump to bottles directory
alias btshome="cd .var/app/com.usebottles.bottles/data/bottles/bottles/Quark-Drive/drive_c/users/steamuser"

# Replace sudo with sudo-rs
# alias sudo="sudo-rs"

# sync wallpapers
alias wpsync="rclone sync $HOME/Pictures/Wallpapers OneDrive:Wallpapers --progress"

# CloudServer
# alias rmsv="ssh -i $HOME/.ssh/id_rsa -l $CloudUser $CloudServer"

# docker shortcuts
# alias dkstart="systemctl start docker.service"

# manage dotfiles
alias dotfiles="lazygit -p $XDG_DATA_HOME/chezmoi"

# uzvg zsh plugins dir
alias uzpd="lazygit -p '$ZDOTDIR/plugins'"

# Others
alias weather="curl wttr.in/Shanghai"
alias goodbye="lolcat -a -s 60 --spread 5 <(toilet 'Good Bye!' --font 'bigmono9')"

# opencode
alias oc="opencode"
