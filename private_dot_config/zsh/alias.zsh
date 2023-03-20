# 一些常用命令的替换
alias ls='exa'
alias l='exa -lha'
alias g='lazygit'
alias c='bat'
alias e="$EDITOR"
alias q='exit'
alias du="dust -r"
alias df="duf"
alias tt='taskwarrior-tui'
alias udd='update-desktop-database $HOME/.local/share/applications/'
alias fd="fd -H"
alias top="btop"
alias wd="sdcv --color"
alias gedit="gnome-text-editor"
alias vim="$EDITOR"
alias rlc="source $HOME/.zshrc"

# chezmoi shortcuts
alias czm="chezmoi"
alias czmr="chezmoi re-add"
alias czmcd="chezmoi cd"
alias czmd="chezmoi managed -i dirs"
alias czmf="chezmoi managed -i files"
alias czma="chezmoi add --follow"
alias czmst="chezmoi status"

# ranger config
alias rr="ranger"
alias rgcfg="$EDITOR $HOME/.config/ranger/rc.conf"

# rime input method
alias ckemj="cat /usr/share/rime-data/opencc/emoji_word.txt"

#CloudServer
alias rmsv="ssh -i $HOME/.ssh/id_rsa -l $CloudUser $CloudServer"

# docker shortcuts
alias dkstart="systemctl start docker.service"

# fontconfig
alias ftcfg="$EDITOR $HOME/.config/fontconfig/fonts.conf"

# pacman
alias pkug="paru -Syyu"
alias pkss="sudo pacman -Ss"
alias rmvop="sudo pacman -Rscn $(paru -Qtdq)"

# hugo shortcuts
alias hgs="hugo server -s $blogDir"
alias hgd="hugo server -s $blogDir -D"

# 是否关闭笔记本键盘
# alias diskb='xinput --set-prop 8 "Device Enabled" 0'
# alias ebkb='xinput --set-prop 8 "Device Enabled" 1'

# 同步配置文件
alias dotfiles="lazygit -p $HOME/.local/share/chezmoi"

# gnome-terminal 主题修改👉https://gogh-co.github.io/Gogh/
alias gogh='bash -c "$(wget -qO- https://git.io/vQgMr)"'

# systemctl
alias sss="systemctl status"

# git bare repository to manage dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#config config status.showUntrackedFiles no

# tiddlywiki shortcuts
alias cfw="twLaunch $TIDDLYWIKI_COFFEE_PATH $TIDDLYWIKI_COFFEE_PORT"
alias lovePoem="twLaunch $TIDDLYWIKI_LOVEPOEM_PATH $TIDDLYWIKI_LOVEPOEM_PORT"
alias twPrac="twLaunch $TIDDLYWIKI_PRACTICE_PATH $TIDDLYWIKI_PRACTICE_PORT"
alias lovePoemDeploy="rsync -av --delete $TIDDLYWIKI_LOVEPOEM_PATH/output/index.html $RemoteUser:/www/wwwroot/jiangyuanandjiayu.love/"
