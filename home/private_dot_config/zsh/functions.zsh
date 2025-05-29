#!/usr/bin/zsh

# 打印回显信息
# 调整颜色编号（1=红，2=绿，3=黄）
function _show_correct() { print -u1 -P "%F{green}✓%f %B%F{2}CORRECT:%f%b ${(j: :)@}" }
function _show_tip() { print -u1 -P "%F{green}✓%f %B%F{2}TIP:%f%b ${(j: :)@}" }
function _show_warning() { print -u1 -P "%F{yellow}⚠%f %B%F{3}WARNING:%f%b ${(j: :)@}" }
function _show_error() { print -u2 -P "%F{red}✗%f %B%F{1}ERROR:%f%b ${(j: :)@}" }

# Edit config file with `chezmoi edit`
_chezmoi_edit() {
  local config_file="$1"
  [[ -f "${config_file}" ]] || {
    _show_error "${config_file} does not exist"
    return 1
  }

  ${commands[chezmoi]} edit "${config_file}" --apply || {
    _show_error "Failed to edit ${config_file:t} with chezmoi"
    return 1
  }

  if [[ -N "${config_file}" ]]; then 
    exec ${commands[zsh]}
    # source "${config_file}" || {
    #   _show_error "Failed to reload ${config_file:t}"
    #   return 1
    #  }
    # _show_correct "${config_file:t} reloaded successfully"
  else 
    _show_tip "No changes detected in ${config_file:t}"
  fi
}

# Deploy Rime input method configuration
# Usage: _rime_edit <config_file>
_rime_edit() {
  local config_file="${1}" 
  local log_file="/tmp/rime_deploy.log"
  local build_dir="${RIME_USER_PATH}/build"

  # Validate config file
  [[ -f "${config_file}" ]] || {
    _show_error "Configuration file not found: ${config_file:t}"
    return 1
  }

  # Open editor
  if ! "${EDITOR}" "${config_file}"; then
    _show_error "Failed to open editor for ${config_file:t}"
    return 1
  fi

  # Check file modification
  [[ ! -N "${config_file}" ]] && {
    _show_tip "No changes detected in ${config_file:t}"
    return 0
  }

# Check rime_deployer command is valid
  (( ! $+commands[rime_deployer] )) && {
    _show_error "rime_deployer not found in PATH"
    return 1
  }

  _show_warning "Starting input method deployment..."
  
  case "${GTK_IM_MODULE}" in
    (fcitx)
      fcitx5-remote -e
      if ! rime_deployer --build "${RIME_USER_PATH}" "/usr/share/rime-data" "${build_dir}" > "${log_file}" 2>&1; then
        _show_error $'Deployment failed. Log details:\n%B%F{red}${log_file}%f%b'
        fcitx5-remote -o  # Restart regardless of failure
        return 1
      fi
      fcitx5-remote -o
      ;;
    (ibus)
      ibus exit >/dev/null 2>&1
      if ! rime_deployer --build "${RIME_USER_PATH}" "/usr/share/rime-data" "${build_dir}" > "${log_file}" 2>&1; then
        _show_error $'Deployment failed. Log details:\n%B%F{red}${log_file}%f%b'
        ibus-daemon -dr >/dev/null 2>&1  # Restart regardless of failure
        return 1
      fi
      ibus-daemon -dr >/dev/null 2>&1
      ;;
    (*)
      _show_error "Unsupported input method framework: ${GTK_IM_MODULE}"
      return 1
      ;;
  esac

  _show_correct "Successfully deployed Rime configuration"
  return 0
}

rimeicon() {
  local config_file="$RIME_USER_PATH/uggx_fluency.custom.yaml"
  _rime_edit "${config_file}"
}

rimewd() {
  local config_file="$RIME_USER_PATH/custom_phrase.txt"
  _rime_edit "${config_file}"
}

# Copy file into the clipboard
cpfile () {
  local file="$1"
  [[ -f "$file" ]] || {
    _show_error "${file:t} is not a valid file"
    return 1
  }
  case $XDG_SESSION_TYPE in
    (wayland)
      if (( ! ${+commands[wl-copy]} )); then {
        _show_error "wl-copy command was not found"
        _show_tip "Install the wl-clipboard to resolve this"
        return 1
      }
      fi
			wl-copy < "${file}" || {
        _show_error "Failed to copy using wl-copy"
        return 1
      } 
      ;;
    (xorg)
      if (( ! ${+commands[xclip]} )); then {
        _show_error "xclip command was not found"
        _show_tip "Install the xclip to resolve this"
        return 1
      }
      fi
      xclip -selection clipboard -in < "${file}" || {
        _show_error "Failed to copy using xclip"
        return 1
      } 
      ;;
    (*)
      _show_error "Unsupported display server: $XDG_SESSION_TYPE"
      return 1
      ;;
  esac
  _show_correct "File copied to clipboard successfully"
}

#判断git仓库是否没有新的修改
# function gsn (){
# 	if [ -d $1 ]
# 	then
# 		if cd $1 && git status &> /dev/null	
# 		then
# 			
# 			if [[ -n $(git status --porcelain) ]]
# 			then
# 				warning "The repository is dirty"
# 				cd -
# 				return 1
# 			elif [[ -z $(git status --porcelain) ]]
# 			then
# 				correct "The repository is clean"
# 				cd -
# 				return 0
# 			fi
# 		else
# 			error "$(realpath $1) 不是git仓库"
# 			cd -
# 			return 2
# 		fi
# 	else
# 		error "$1不是目录"
# 		cd -
# 		return 3
# 	fi
# }

# transform file code to UTF_8
# windows下的纯文件在Linux下打开，有时会出现乱码的情况，需要先进行转码
function text_utf8 {
	if [[ -e $1 ]]; then
		iconv -f GB2312 -t UTF-8 $1 -o $1
	else
		_show_error "TRANSFORM ERROR"
	fi
}

# Apply dark scheme for correspondending applications
# 很久之前写的用于给系统整体切换主题的脚本
# function dark_mode {
# 	sed -i '/\/light-256/s/light/dark/' ~/.taskrc
# 	sed -i '/lightTheme/s/true/false/' ~/.config/lazygit/config.yml
# 	sed -i 's/Adwaita-Dark/Adwaita/' ~/.config/qt5ct/qt5ct.conf
# 	sed -i 's/Adwaita/Adwaita-Dark/' ~/.config/qt5ct/qt5ct.conf
# 	sed -i '/background/s/light/dark/' ~/.config/nvim/init.vim
# 	sed -i '/useDarkTheme/s/false/true/' ~/.config/qv2ray/Qv2ray.conf
# 	sed -i '/CreatorTheme/s/light/dark/' ~/.config/QtProject/QtCreator.ini
# 	sed -i '/gtk-application-prefer-dark-theme/s/0/1/' ~/.config/gtk-3.0/settings.ini
# 	# gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
# 	gsettings set org.gnome.shell.extensions.user-theme name Adwaita-dark
# }

# Apply light scheme for correspondending applications
# function light_mode {
# 	sed -i '/\/dark-256/s/dark/light/' ~/.taskrc
# 	sed -i '/lightTheme/s/false/true/' ~/.config/lazygit/config.yml
# 	sed -i 's/Adwaita-Dark/Adwaita/' ~/.config/qt5ct/qt5ct.conf
# 	sed -i '/background/s/dark/light/' ~/.config/nvim/init.vim
# 	sed -i '/useDarkTheme/s/true/false/' ~/.config/qv2ray/Qv2ray.conf
# 	sed -i '/Theme/s/dark/light/' ~/.config/QtProject/QtCreator.ini
# 	sed -i '/Theme/s/dark/light/' ~/.config/QtProject/QtCreator.ini
# 	sed -i '/gtk-application-prefer-dark-theme/s/1/0/' ~/.config/gtk-3.0/settings.ini
# 	# gsettings set org.gnome.desktop.interface gtk-theme Adwaita
# 	gsettings set org.gnome.shell.extensions.user-theme name Adwaita-light
# }

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

# function svwk {
# 	local COMMIT_WORD="save logseq workspace on Archlinux"
# 	if [ -d "$LOGSEQ_DIR" ]
# 	then
# 		warning "同步中...."
# 		cd $LOGSEQ_DIR
# 		git add -A &> /dev/null
# 		git commit -a -m "$COMMIT_WORD"  &> /dev/null
# 		git push &> /dev/null
# 		cd -
# 		correct "logseq工作空间同步成功"
# 	else
# 		error "logseq wokrspace目录不存在"
# 	fi
# }

# function svdotfiles {
# 	if gsn $DOTFILES_PATH > /dev/null
# 	then
# 		correct "配置文件已同步，无需操作"
# 	else
# 		local COMMIT_WORD="dotfiles auto backup on Archlinux"
# 		if [ -d "$DOTFILES_PATH" ];then
# 			cd $DOTFILES_PATH
# 			git add -A > /dev/null
# 			git commit -a -m "$COMMIT_WORD" > /dev/null
# 			git push > /dev/null
# 			correct "配置文件同步成功"
# 			cd -
# 		else
# 			error "dotfiles sync dir do not exist"
# 		fi
# 	fi
# }

# 将文件传输到远程服务器用户的Documents文件夹下
# function ttremote {
# 	if [ -f $(realpath -s $1) ];then
# 		rsync $1 $RemoteUser:Documents
# 		correct "文件已传输到远程服务器的$CloudUser/Documents文件夹下"
# 	else
# 		error "传输出错"
# 	fi
# }

# 登录远程服务器
# function lgrmt(){
# 	if [ $# -eq 0 ]
# 	then
# 		ssh -i $PrivKey -l root $CloudServer
# 	elif [ -n $PrivKey ] && [ -n $CloudServer ] && [ -n $1 ]
# 	then
# 		ssh -i $PrivKey -l $1 $CloudServer
# 	else
# 		error "远程登录出错"
# 	fi
# }

# 博客部署
# function blogDeploy {
	
	#case in 

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
  # }

# GNOME-SHELL theme Css Generation
# function gscg {
# 	if [ -d $GNOME_SHELL_THEME_FOLDER ] && command -v sassc
# 	then
# 		cd $GNOME_SHELL_THEME_FOLDER
# 		sassc gnome-shell-dark.scss > ~/.local/share/themes/adwaita-dark-shell-theme/gnome-shell/gnome-shell.css
# 	else
# 		echo "something wrong with your gnome shell theme config"
# 	fi
# }

#function genBlog {
#	local title=$(date +%Y-%m-%d-%H-%M)
#	cd $blogDir
#	hugo new post/$title.md
#	$EDITOR $blogDir/content/post/$title.md
#}

function _tw_launch {
	if [ -d $1 ] && [ -n $2 ]
	then
    # 如果在进程中找到了tiddlywiki的工作目录，说明进程已经在运行中，就发出警告，说明进程已经在运行中，没有必要重新启动
		if ! pgrep -f $1; then
			_show_warning "$(basename $1)开始加载......"
			# zsh -c "nohup tiddlywiki $1 --listen port=$2 &> /dev/null &"
			setsid nohup tiddlywiki $1 --listen port=$2 &>/dev/null
			_show_correct "$(basename $1)已加载，入口地址：http://127.0.0.1:$2"
		else
			_show_warning "$(basename $1)已加载，入口地址：http://127.0.0.1:$2"
		fi
	else
		_show_error "tiddlywiki根路径错误"
	fi
}

function twList {
	ps aux |grep tiddlywiki| grep -v grep | awk -F '[ =]+' '{print "进程号: "$2"\t工作目录: "$13"\t入口地址为：http://127.0.0.1:"$16}'
}

function ktw {
	if [ $# -eq 0 ]
	then
		echo "ktw(kill tiddlywiki process)使用帮助："
		echo "\tktw -a[--all]"
		echo "\tktw -n[--number]"
	else
		IFS_OLD=$IFS
		IFS=$'\n'
		local -a twPid
		twPid=($(ps aux |grep tiddlywiki| grep -v grep | awk '{print $2}'))
		case $1 in
			-a|--all)
				_show_correct "所有tiddlywiki进程已关闭!"
				for pcs in ${twPid[@]}
				do
					kill $pcs
				done
				;;
			-n|--number)
				if [ -z $2 ]
				then
					_show_warning "请指定进程号👉 Number："
					ps aux | grep tiddlywiki | grep -v grep | gawk -F '[ =]+' 'BEGIN{i=0}{i++}{printf "Number: %d\t进程: %s\n",i,$13}'
				elif [ -n $2 ]
				then
					kill ${twPid[$2]}
				fi
				;;
			*)
				_show_error "参数错误"
				ktw
		esac
		IFS=$IFS_OLD
	fi
}

# function blogDeploy {}

# archive Dir ARCHIVE_DESTINATION_DIR mtime
# 如果dir中的文件在mtime时间之内发生改变，就将其打包到归档目录
# ARCHIVE_DESTINATION_DIR
# function archive {
# 	if [[ $USER == uzvg ]]
# 	then
# 		if [ -d $1 ]
# 		then
# 			if realpath $1 | grep -q $HOME
# 			then
# 				local source_name=$(basename $1)
# 				if [ $(find $1 -mmin -$2 | wc -l) -ne 0 ] || [ ! -f $ARCHIVE_DESTINATION_DIR/$source_name.tar.xz ]
# 				then
# 					warning "文档打包中......"
# 					local relative_dir=$(realpath $1 | sed 's!'$HOME'/!!g')
# 					#echo $relative_dir
# 					tar -X $ARCHIVE_EXCLUDE_FILE -C $HOME -cJPf $ARCHIVE_DESTINATION_DIR/$source_name.tar.xz $relative_dir
# 					correct "$(basename $1)打包完毕"
# 				else
# 					correct "$(basename $1)目录$2分钟内无改动，无需归档"
# 				fi
# 				
# 			else
# 				error "$1非家目录中的文件，无法归档"
# 			fi
# 		else
# 			error "源目录错误"
# 		fi
# 	else
# 		error "不是主用户，无权限提交归档文件"
# 	fi
# }

#上传图片到云服务器，同时将云服务器中的地址重复到剪贴板
# step1: 判断图片是否存在并且是否是否真的是图片文件
# step2: 将图片上传到云服务器
# step3: 复制图片的地址到剪贴板
# step4: 将图片同步到远程仓库

# function upImage {
# 	if [ -f $1 ]
# 	then
# 		filetype=$(file --mime-type $1)
# 		if [[ $filetype == *image* ]]
# 		then
# 			if rsync -av --delete $1 $RemoteUser:/www/wwwroot/uzvg.site/images/
# 			then
# 				local filename=$(basename $1 | sed 's/ /%20/g')
# 				imageUrl=https://uzvg.site/images/$filename
# 				correct "URL of image 👉 $imageUrl"
# 				echo $imageUrl | xclip -selection clipboard
# 				correct "And the address of the image was copied in your clipboard!"
# 				cp $1 $TIDDLYWIKI_COFFEE_PATH/images
# 				local COMMIT_WORD="image sync on Archlinux at $(date +%Y/%m/%d-%H:%M)"
# 				cd $TIDDLYWIKI_COFFEE_PATH/
# 				git add images/$(basename $1) > /dev/null
# 				git commit -m "$COMMIT_WORD" > /dev/null
# 				git push &> /dev/null
# 				cd -
# 				correct "Image sync successfully!"
# 			else
# 				error "file transfer failed"
# 			fi
# 		else
# 			error "The file you uploaded is not image, please check it again!"
# 		fi
# 	else
# 		error "目标文件不存在"
# 	fi
# }

# python-search
alias pip='function _pip(){
    if [ $1 = "search" ]; then
        pip_search "$2";
    else pip "$@";
    fi;
};_pip'

# gogh 
function gogh(){
	bash -c "$(curl -sLo- https://git.io/vQgMr)"
}
