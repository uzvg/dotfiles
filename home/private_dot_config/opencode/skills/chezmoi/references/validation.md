# 验证命令

先做 chezmoi 层面的验证，再做文件类型层面的语法检查。

## 通用

```sh
target=/absolute/path/to/config

chezmoi cat    -- "$target" >/dev/null   # 模板必须能渲染
chezmoi apply  -- "$target"
chezmoi verify -- "$target"              # 0 = 干净
chezmoi status -- "$target"              # 应为空

git -C "$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel)" diff
```

## 按类型

### zsh

```sh
zsh -n "$file"

# 模板：先渲染再检查
chezmoi cat -- "$target" | zsh -n
```

### POSIX sh

```sh
sh -n "$file"
```

### Python

```sh
python3 -m py_compile "$file"
```

模板先渲染到临时文件，再检查：

```sh
tmp=$(mktemp --suffix=.py)
chezmoi cat -- "$target" > "$tmp"
python3 -m py_compile "$tmp"
rm -f "$tmp"
```

### TOML

```sh
python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb"))' "$file"
```

### JSON（严格）

```sh
jq empty "$file"
```

### JSONC

JSONC 允许注释和尾逗号，`jq` 会失败。优先用应用自身的校验；如果本机装了 `json5`：

```sh
python3 -c 'import json5,sys; json5.load(open(sys.argv[1]))' "$file"
```

### YAML

```sh
python3 -c 'import yaml,sys; yaml.safe_load(open(sys.argv[1]))' "$file"
```

### Lua

```sh
luac -p "$file"
```

### systemd unit

```sh
systemd-analyze verify "$file"
```

### 模板

```sh
chezmoi cat -- "$target" >/dev/null
```

`.chezmoi.toml.tmpl` 是特殊模板：

```sh
chezmoi execute-template --init < "$file"
```

### .chezmoiignore.tmpl

```sh
chezmoi ignored >/dev/null
```

再检查另一平台：

```sh
chezmoi execute-template --override-data '{"chezmoi":{"os":"windows"}}' \
  < "$(chezmoi source-path)/.chezmoiignore.tmpl"
```

## 本仓库常用文件

| 文件 | 建议命令 |
|---|---|
| `home/private_dot_config/zsh/**/*.zsh` | `zsh -n` |
| `home/private_dot_config/zsh/plugins/functions/*` | `zsh -n` |
| `home/private_dot_config/scripts/executable_*.zsh` | `zsh -n` |
| `home/private_dot_config/scripts/executable_image_shrink.py` | `python3 -m py_compile` |
| `home/private_dot_config/systemd/user/*.service` | `systemd-analyze verify` |
| `home/private_dot_config/git/hooks/executable_pre-push` | `sh -n` 或 `zsh -n`（按 shebang） |
| `home/private_dot_config/rmpc/config.ron` | 用 rmpc 自身校验（如 `rmpc config check`，若可用） |
| `home/private_dot_config/zellij/config.kdl` | 用 zellij 自身校验（如 `zellij setup --check`） |
| `home/private_dot_config/opencode/opencode.jsonc` | 用 OpenCode 自身加载验证 |
| `home/private_dot_config/yazi/*.toml` | 用 yazi 自身启动验证，或 TOML 解析 |
| `home/private_dot_config/kitty/*.conf` | `kitty +kitten show_key` 不适用；用 kitty 重载观察报错 |

应用自身校验不可用时，至少做 TOML/JSON/语法层面的检查，并明确告诉用户“未做应用级验证”。

## 应用重载

- zsh：新开 shell 或 `exec zsh`
- systemd：`systemctl --user daemon-reload`；需要时 `systemctl --user enable --now <unit>`
- kitty/ghostty：重载配置或重启
- OpenCode：配置热重载；必要时 `/reload`
- `run_onchange_*` 脚本：内容变化后需要完整 `chezmoi apply` 才会重新运行；注意联网和副作用
