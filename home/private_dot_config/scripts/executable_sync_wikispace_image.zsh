#!/usr/bin/env zsh
#
# ==========================================
# WikiSpace Image Manager
#
# 功能：
# 1. 本地图片备份到 OneDrive
# 2. 公共图片同步到 OSS
# 3. 预留：图片压缩（shrink）
# ==========================================

emulate -L zsh
set -euo pipefail

# ---------- Logging ----------
_show_correct() { print -u1 -P "%F{green}✓%f %B%F{2}CORRECT:%f%b ${(j: :)@}" }
_show_tip() { print -u1 -P "%F{green}✓%f %B%F{2}TIP:%f%b ${(j: :)@}" }
_show_warning() { print -u1 -P "%F{yellow}⚠%f %B%F{3}WARNING:%f%b ${(j: :)@}" }
_show_error() { print -u2 -P "%F{red}✗%f %B%F{1}ERROR:%f%b ${(j: :)@}" }

# ---------- Path Config ----------
typeset -r WIKISPACE_PATH="$HOME/Documents/wikis/WikiSpace"
typeset -r LOCAL_IMAGE_DIR="$WIKISPACE_PATH/tiddlers/Images"

typeset -r REMOTE_BACKUP_PATH="OneDrive:WikiSpace/Images"
typeset -r OSS_BUCKET_PATH="CloudFlare:wikispace/Images"

typeset -ra PUBLIC_IMAGE_SOURCE_DIRS=(
  "$LOCAL_IMAGE_DIR/Public"
  "$LOCAL_IMAGE_DIR/Covers"
)

typeset -r PUBLIC_IMAGE_TARGET_DIR="$HOME/Documents/publish_images"

# ---------- Check local path ----------
check_local_path() {
  if [[ ! -d $LOCAL_IMAGE_DIR ]]; then
    _show_tip "Local image path is not exist, Exit sync."
    exit 0
  fi
}

# ---------- Sync to OneDrive ----------
sync_to_onedrive() {
  _show_tip "Syncing all images to OneDrive..."

  if rclone sync "$LOCAL_IMAGE_DIR" "$REMOTE_BACKUP_PATH" \
      --exclude "*.meta" --delete-excluded --progress; then
    _show_correct "OneDrive sync completed"
  else
    _show_error "OneDrive sync failed"
    return 1
  fi
}

# ---------- shrink images ----------

shrink_images() {
  for dir in "${PUBLIC_IMAGE_SOURCE_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
      _show_tip "Skip: $dir not found"
      continue
    fi

    _show_tip "开始缩减图片......"
    python3 ./image_shrink.py $dir $PUBLIC_IMAGE_TARGET_DIR &&{
      _show_correct "$dir 同步缩减完成"
    } || {
      _show_error "$dir 同步缩减失败"
      exit 0
    }
  done
}

# ---------- Sync to OSS ----------
sync_to_bucket() {
  _show_tip "Syncing public images to OSS..."

  if rclone sync "$PUBLIC_IMAGE_TARGET_DIR" "$OSS_BUCKET_PATH" \
      --exclude "*.meta" --delete-excluded --progress; then
    _show_correct "Synced: $(basename "$dir")"
  else
    _show_error "Failed: $(basename "$dir")"
  fi
}

# ---------- Main ----------
main() {
  check_local_path
  sync_to_onedrive
  shrink_images
  sync_to_bucket
}

main "$@"
