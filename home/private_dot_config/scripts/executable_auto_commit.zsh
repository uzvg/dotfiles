#!/usr/bin/zsh

# 设置我的 Wiki 仓库路径
cd /home/uzvg/Documents/wikis/WikiSpace

# 判断是否有变更
if [[ -n $(git status --porcelain) ]]; then
  commit_message="Auto commit on $(date '+%Y-%m-%d %H:%M:%S')"
  git add .
  git commit -m "${commit_message}"
  git push
else
  echo "No changes to commit."
fi
