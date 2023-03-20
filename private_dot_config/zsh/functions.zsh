#!/usr/bin/zsh

function warning {
	echo -e "\033[33m ⚠️  WARNING: $1 \033[0m"
}

function error {
	echo -e "\033[31m ❗ ERROR: $1 \033[0m"
}

function correct {
	echo -e "\033[32m ⌛ DONE: $1 \033[0m"
}

# edit configuration
function zshcfg {
	$EDITOR $HOME/.zshrc
	if [ -N $HOME/.zshrc ]
	then
		source $HOME/.zshrc
		correct "zshrc reloaded completed!"
	fi
}


function alcfg {
	$EDITOR $ZSH_CFG_DIR/alias.zsh
	if [ -N $ZSH_CFG_DIR/alias.zsh ]
	then
		source $ZSH_CFG_DIR/alias.zsh
		correct "alias configuration files reloaded successfully"
	fi
}

function envcfg {
	$EDITOR $ZSH_CFG_DIR/environment.zsh
	if [ -N $ZSH_CFG_DIR/environment.zsh ]
	then
		source $ZSH_CFG_DIR/environment.zsh
		correct "配置文件已重载"
	fi
}

function fucfg {
	#mtime_old="$(stat $ZSH_CFG_DIR/functions.zsh --printf=%y)"
	$EDITOR $ZSH_CFG_DIR/functions.zsh
	#mtime="$(stat $ZSH_CFG_DIR/functions.zsh --printf=%y)"
	#if [[ $mtime != $mtime_old ]]
	if [ -N $ZSH_CFG_DIR/functions.zsh ]
	then
		source $ZSH_CFG_DIR/functions.zsh
		correct "配置文件已重载"
	fi
}

#判断git仓库是否没有新的修改
function gsn (){
	if [ -d $1 ]
	then
		if cd $1 && git status &> /dev/null	
		then
			
			if [[ -n $(git status --porcelain) ]]
			then
				warning "The repository is dirty"
				cd -
				return 1
			elif [[ -z $(git status --porcelain) ]]
			then
				correct "The repository is clean"
				cd -
				return 0
			fi
		else
			error "$(realpath $1) 不是git仓库"
			cd -
			return 2
		fi
	else
		error "$1不是目录"
		cd -
		return 3
	fi
}

# transform file code to UTF_8
function text_utf8 {
	if [ -e $1 ]; then
		iconv -f GB2312 -t UTF-8 $1 -o $1
	else
		echo "transform ERROR"
	fi
}

# Apply dark scheme for correspondending applications
function dark_mode {
	sed -i '/\/light-256/s/light/dark/' ~/.taskrc
	sed -i '/lightTheme/s/true/false/' ~/.config/lazygit/config.yml
	sed -i 's/Adwaita-Dark/Adwaita/' ~/.config/qt5ct/qt5ct.conf
	sed -i 's/Adwaita/Adwaita-Dark/' ~/.config/qt5ct/qt5ct.conf
	sed -i '/background/s/light/dark/' ~/.config/nvim/init.vim
	sed -i '/useDarkTheme/s/false/true/' ~/.config/qv2ray/Qv2ray.conf
	sed -i '/CreatorTheme/s/light/dark/' ~/.config/QtProject/QtCreator.ini
	sed -i '/gtk-application-prefer-dark-theme/s/0/1/' ~/.config/gtk-3.0/settings.ini
	# gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
	gsettings set org.gnome.shell.extensions.user-theme name Adwaita-dark
}

# Apply light scheme for correspondending applications
function light_mode {
	sed -i '/\/dark-256/s/dark/light/' ~/.taskrc
	sed -i '/lightTheme/s/false/true/' ~/.config/lazygit/config.yml
	sed -i 's/Adwaita-Dark/Adwaita/' ~/.config/qt5ct/qt5ct.conf
	sed -i '/background/s/dark/light/' ~/.config/nvim/init.vim
	sed -i '/useDarkTheme/s/true/false/' ~/.config/qv2ray/Qv2ray.conf
	sed -i '/Theme/s/dark/light/' ~/.config/QtProject/QtCreator.ini
	sed -i '/Theme/s/dark/light/' ~/.config/QtProject/QtCreator.ini
	sed -i '/gtk-application-prefer-dark-theme/s/1/0/' ~/.config/gtk-3.0/settings.ini
	# gsettings set org.gnome.desktop.interface gtk-theme Adwaita
	gsettings set org.gnome.shell.extensions.user-theme name Adwaita-light
}

function rimeSync {
	# rime 词库同步
	if [ -d $RIME_USER_PATH ]
	then
		# 词库合并
		case $GTK_IM_MODULE in
		fcitx ):
			fcitx5-remote -e
			cd $RIME_USER_PATH
			warning "词库合并中......"
			rime_dict_manager -s &> /dev/null
			fcitx5-remote -o
			cd -;;
		ibus ):
			ibus exit
			cd $RIME_USER_PATH
			warning "词库合并中......"
			rime_dict_manager -s &> /dev/null
			ibus start
			cd -;;
		* ):
			error "词库合并：输入法配置错误";;
		esac

		correct "词库合并成功,开始同步......"
		if [ -d "$RIME_SYNC_PATH" ];then
			local COMMIT_WORD="rime sync on Archlinux at $(date +%Y/%m/%d-%H:%M)"
			cd $RIME_SYNC_PATH
			git add -A > /dev/null
			git commit -a -m "$COMMIT_WORD" > /dev/null
			git push &> /dev/null
			cd -
			correct "词库同步成功"
		else
			error "rime 同步仓库路径错误"
		fi
	fi
}

function rimeicon {
	if [ -f $RIME_USER_PATH/uggx_fluency.custom.yaml ]
	then
		$EDITOR $RIME_USER_PATH/uggx_fluency.custom.yaml
		if [ -N $RIME_USER_PATH/uggx_fluency.custom.yaml ]
		then
			warning "输入法部署中...."
			case $GTK_IM_MODULE in
			fcitx ):
				fcitx5-remote -e
				rime_deployer --build $RIME_USER_PATH /usr/share/rime-data $RIME_USER_PATH/build &> /dev/null
				fcitx5-remote -o;;
			ibus ):
				ibus exit
				rime_deployer --build $RIME_USER_PATH /usr/share/rime-data $RIME_USER_PATH/build &> /dev/null
				ibus start;;
			* ):
				error "输入法框架配置错误";;
			esac
			correct "输入法部署完成...."
		fi
	fi
}

function rimewd {
	if [ -f $RIME_USER_PATH/custom_phrase.txt ]
	then
		$EDITOR $RIME_USER_PATH/custom_phrase.txt
		if [ -N $RIME_USER_PATH/custom_phrase.txt ]
		then
			warning "输入法部署中...."
			case $GTK_IM_MODULE in
			fcitx ):
				fcitx5-remote -e
				rime_deployer --build $RIME_USER_PATH /usr/share/rime-data $RIME_USER_PATH/build &> /dev/null
				fcitx5-remote -o;;
			ibus ):
				ibus exit
				rime_deployer --build $RIME_USER_PATH /usr/share/rime-data $RIME_USER_PATH/build &> /dev/null
				ibus start;;
			* ):
				error "输入法框架配置错误";;
			esac
			correct "输入法部署完成...."
		fi
	fi
} 

function svwk {
	local COMMIT_WORD="save logseq workspace on Archlinux"
	if [ -d "$LOGSEQ_DIR" ]
	then
		warning "同步中...."
		cd $LOGSEQ_DIR
		git add -A &> /dev/null
		git commit -a -m "$COMMIT_WORD"  &> /dev/null
		git push &> /dev/null
		cd -
		correct "logseq工作空间同步成功"
	else
		error "logseq wokrspace目录不存在"
	fi
}

function svdotfiles {
	if gsn $DOTFILES_PATH > /dev/null
	then
		correct "配置文件已同步，无需操作"
	else
		local COMMIT_WORD="dotfiles auto backup on Archlinux"
		if [ -d "$DOTFILES_PATH" ];then
			cd $DOTFILES_PATH
			git add -A > /dev/null
			git commit -a -m "$COMMIT_WORD" > /dev/null
			git push > /dev/null
			correct "配置文件同步成功"
			cd -
		else
			error "dotfiles sync dir do not exist"
		fi
	fi
}

function purge {
	if ! command -v $1
	then
		echo "程序不存在"
	else
		echo "正在卸载$1："
		sudo pacman -Rscn $1
	fi
}

function enlarge {
	if  command -v $1
		$1 --force-device-scale-factor=1.25 &> /dev/null
	then
		echo "程序未安装"
	fi
}

# 将文件传输到远程服务器用户的Documents文件夹下
function ttremote {
	if [ -f $(realpath -s $1) ];then
		rsync $1 $RemoteUser:Documents
		correct "文件已传输到远程服务器的$CloudUser/Documents文件夹下"
	else
		error "传输出错"
	fi
}

# 备份cache目录中的文件👉cacheDir
function ccbk {
	if [ -n "$cacheDir" ]
	then
		for Dir in "${cacheDir[@]}"
		do
			if [ -d $Dir ]
			then
				rsync -av --delete $HOME/.cache/$Dir/ $HOME/Documents/cacheBackup/$Dir &> /dev/null
				correct "$Dir 缓存已备份"
			else
				error "$Dir 不是目录"
			fi
		done
	else
		error "需缓存的目录未设置"
	fi
}

# 复制文件内容到剪贴板
function cf {
	if [ -f  $1 ]
	then
		if command -v xclip
		then
			xclip -selection clipboard -i $1
		else
			error "缺乏软件包xclip"	
		fi
	else
		error "文件不存在"
	fi
}

# 登录远程服务器
function lgrmt(){
	if [ $# -eq 0 ]
	then
		ssh -i $PrivKey -l root $CloudServer
	elif [ -n $PrivKey ] && [ -n $CloudServer ] && [ -n $1 ]
	then
		ssh -i $PrivKey -l $1 $CloudServer
	else
		error "远程登录出错"
	fi
}

# 博客部署
function blogDeploy {
	# 部署到本地
	#if [ $# -eq 0 ]
	#then
	#	warning "usage:"
	#	echo "blogDeploy -t[--type] tiddlywiki/hugo"
	#	echo "blogDeploy -p[--path] path of blogDir"
	#else
	#	case $1 in
	#if [ -n $blogDir ]
	#then
	#	cd $blogDir
	#	if [ -n $publishDir ]
	#	then
	#		hugo --destination $publishDir
	#		rsync -av --delete $publishDir/ $RemoteUser:/etc/www/uzvg
	#		echo "部署完成"
	#	fi
	#else
	#	echo "博客build目录错误"
	#fi
}

# gnome-shell 主题修改
#function gstc {
#	if [ -d $GnomeShellFolder ] && command -v sassc
#	then
#		cd $GnomeShellFolder
#		sassc gnome-shell.scss > ~/.local/share/themes/adwaita-dakr-shell-theme/gnome-shell/gnome-shell.css
#	else
#		echo "something wrong with your gnome shell theme config"
#	fi
#}

#function genBlog {
#	local title=$(date +%Y-%m-%d-%H-%M)
#	cd $blogDir
#	hugo new post/$title.md
#	$EDITOR $blogDir/content/post/$title.md
#}

function twLaunch {
	if [ -d $1 ] && [ -n $2 ]
	then
		if ! ps aux | grep tiddlywiki | grep -v grep | grep -q $1
		then
			warning "$(basename $1)开始加载......"
			zsh -c "nohup tiddlywiki $1 --listen port=$2 &> /dev/null &"
			correct "$(basename $1)已加载，入口地址：http://127.0.0.1:$2"
		else
			# warning "$(basename $1)已加载，入口地址：https://127.0.0.1:$(eval echo \$$2)"
			warning "$(basename $1)已加载，入口地址：http://127.0.0.1:$2"
		fi
	else
		error "tiddlywiki根路径错误"
	fi
}

function twlist {
	ps aux |grep tiddlywiki| grep -v grep | awk -F '[ =]+' '{print "进程号："$2"\t工作目录："$13"\t入口地址为：http://127.0.0.1:"$16}'
function tw5 {
	cd /usr/lib/node_modules/tiddlywiki/
	nohup ./bin/serve.sh editions/tw5.com &> /dev/null &
	correct "tiddlywiki文档已加载，入口地址：http://127.0.0.1:8080"
	cd -
}

function ktw {
	if [ $# -eq 0 ]
	then
		echo "使用帮助："
		echo "\tktw -a[--all]"
		echo "\tktw -n[--number]"
	else
		IFS_OLD=$IFS
		IFS=$'\n'
		local -a twPid
		twPid=($(ps aux |grep tiddlywiki| grep -v grep | awk '{print $2}'))
		case $1 in
			-a|--all)
				correct "所有tiddlywiki进程已关闭!"
				for pcs in ${twPid[@]}
				do
					kill $pcs
				done
				;;
			-n|--number)
				if [ -z $2 ]
				then
					warning "请指定进程号👉 Number："
					ps aux | grep tiddlywiki | grep -v grep | gawk -F '[ =]+' 'BEGIN{i=0}{i++}{printf "Number: %d\t进程: %s\n",i,$13}'
				elif [ -n $2 ]
				then
					kill ${twPid[$2]}
				fi
				;;
			*)
				error "参数错误"
				ktw
		esac
		IFS=$IFS_OLD
	fi
}
#function blogDeploy {}

# archive Dir ARCHIVE_DESTINATION_DIR mtime
# 如果dir中的文件在mtime时间之内发生改变，就将其打包到归档目录
# ARCHIVE_DESTINATION_DIR
function archive {
	if [[ $USER == uzvg ]]
	then
		if [ -d $1 ]
		then
			if realpath $1 | grep -q $HOME
			then
				local source_name=$(basename $1)
				if [ $(find $1 -mmin -$2 | wc -l) -ne 0 ] || [ ! -f $ARCHIVE_DESTINATION_DIR/$source_name.tar.xz ]
				then
					warning "文档打包中......"
					local relative_dir=$(realpath $1 | sed 's!'$HOME'/!!g')
					#echo $relative_dir
					tar -X $ARCHIVE_EXCLUDE_FILE -C $HOME -cJPf $ARCHIVE_DESTINATION_DIR/$source_name.tar.xz $relative_dir
					correct "$(basename $1)打包完毕"
				else
					correct "$(basename $1)目录$2分钟内无改动，无需归档"
				fi
				
			else
				error "$1非家目录中的文件，无法归档"
			fi
		else
			error "源目录错误"
		fi
	else
		error "不是主用户，无权限提交归档文件"
	fi
}

function archive_backup {
	for file in $ARCHIVE_LIST
	do
		echo "============================="
		archive $file 180
	done
}

function archive_deploy {
	if [ -d $ARCHIVE_DESTINATION_DIR ]
	then
		cd $ARCHIVE_DESTINATION_DIR
		warning "更新配置文件"
		git pull
		correct "更新完成！开始恢复归档文件"

		for file in $(find $ARCHIVE_DESTINATION_DIR/ -name "*.tar.xz")
		do
			tar -C $HOME -xJPf $file
		done
		post_archive_deploy
		correct "归档备份文件恢复完成"
		cd -
	else
		warning "归档文件下载中....."
		git clone $ARCHIVE_REMOTE_HTTPS $ARCHIVE_DESTINATION_DIR
		correct "归档文件下载完成"
	fi
}

function post_archive_deploy {
	sed -i 's!/home/uzvg!'$HOME'!g' $HOME/.zim/init.zsh
}

# 问题如下：
# zimfw 目录替换
# 如果目标目录不存在的话，使用while循环

function get_ssh_key {
	if [ -f $HOME/.ssh/id_rsa ] && [[ -f $HOME/.ssh/id_rsa.pub ]]
	then
		correct "秘钥如下："
		cf $HOME/.ssh/id_rsa.pub
	else
		warning "创建ssh key"
		ssh-keygen -t rsa -C "1497911983@qq.com"
	fi
}

