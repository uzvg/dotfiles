#!/usr/bin/zsh

[[ -z $TIDDLYWIKI_PLUGIN_PATH ]] && TIDDLYWIKI_PLUGIN_PATH="$XDG_DATA_HOME/tiddlywiki/plugins"
PUBLISHED_PLUGINS=(${(@f)$(jq -r '.published_plugins[]' tiddlywiki.info)})

for plug in $PUBLISHED_PLUGINS; do
  local plug_name=${plug#*/}
  local plug_src="$TIDDLYWIKI_PLUGIN_PATH/$plug/"
  local plug_dest="$PWD/plugins/$plug_name/"
  _zlog info "  同步$plug"
  rsync -aL --mkpath "$plug_src" "$plug_dest" || {
    _zlog error "部署插件失败"
    _zlog info "当前插件：$plug_name"
    exit 1
  }
done

#vim ft=zsh
