#!/usr/bin/zsh

# REPO_ROOT=$(git rev-parse --show-toplevel)
# REPO_NAME=${${REMOTE##*/}%.git}
REMOTE="$2"
LIB_ROOT="${0:A:h}"
REPO_ROOT="$PWD"
REPO_NAME=${REMOTE:t:r}

SHRINK_SOURCE="$REPO_ROOT/tiddlers/images/public"
SHRINK_DEST="$REPO_ROOT/.shrinks"

BACKUP_SOURCE="$REPO_ROOT/tiddlers/images"
BACKUP_DEST="OneDrive:wikis/$REPO_NAME/images"

PUBLISH_SOURCE="$SHRINK_DEST"
PUBLISH_DEST="CloudFlare:images/$REPO_NAME"

# Source pretty-print.zsh
source "${LIB_ROOT}/pretty-print.zsh" || {
  print -u2 "Failed to source pretty-print."
  print -u2 "The source path is ${LIB_ROOT}"
  exit 1
}

_zlog info "开始部署插件..."
source ${LIB_ROOT}/twks-ensure-plugins.zsh || exit 1

_zlog info "开始压缩图片..."
source ${LIB_ROOT}/twks-image-shrink.zsh \
  --source "$SHRINK_SOURCE" \
  --dest "$SHRINK_DEST" || {
    _zlog error "图片压缩失败"
    _zlog info "当前工作目录: $PWD"
    exit 1
  }

# 备份到OnedDrive
_zlog info "开始备份到Onedrive..."
source ${LIB_ROOT}/twks-image-sync.zsh \
  --source $BACKUP_SOURCE \
  --dest $BACKUP_DEST || {
    _zlog error "图片备份失败"
    _zlog info "当前工作目录: $PWD"
    exit 1
  }

# 上传到CloudFlare
_zlog info "开始上传到CloudFlare..."
source ${LIB_ROOT}/twks-image-sync.zsh \
  --source $PUBLISH_SOURCE \
  --dest $PUBLISH_DEST || {
    _zlog error "图片备份失败"
    _zlog info "当前工作目录: $PWD"
    exit 1
  }

_zlog "开始push到远程仓库..."

# vim: ft=zsh
