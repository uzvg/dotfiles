---
name: chezmoi 配置管理
description: 在创建、修改、导入、删除 $HOME 下的配置文件（dotfiles）之前使用；判断文件是否由 chezmoi 管理、是否应纳管、编辑正确的源文件/模板/.chezmoitemplates，处理 Linux 与 Windows 的平台差异，并在 apply 后验证。
---

# Chezmoi 配置管理

## 何时使用

- 目标位于 `$HOME` 下，是应用、Shell 或编辑器的配置文件/点文件。
- 用户要求修改 zsh、PowerShell、git、nvim、yazi、lazygit、kitty、opencode 等配置。
- 同一份配置需要同时适配 Linux 与 Windows。
- 用户要求把某个现有配置“纳管”进 dotfiles。

不适用：

- 项目仓库里的源码、构建产物、`.git` 内容。
- 缓存、数据库、日志、浏览器 profile、应用运行时状态。
- `$HOME` 之外的文件（除非用户明确要求使用 chezmoi 的 `--destination` 或 external）。

## 硬性规则

1. **不要直接编辑被 chezmoi 管理的目标文件**。先 `chezmoi source-path`，编辑源文件，再 `chezmoi apply`。
2. **不要运行交互式命令**：`chezmoi edit`、`chezmoi diff`、`chezmoi apply --dry-run`。本机 `diff`/`merge` 配置为 nvim，会卡住会话。查看 diff 用 `chezmoi diff --use-builtin-diff` 或 `git -C "$(chezmoi source-path)" diff`。
3. **不要把明文密钥写入仓库**。`encrypted_*` / `*.age` 走专门流程，必要时让用户手动操作。
4. **未管理文件默认只建议，不自动 `chezmoi add`**。先说明理由、平台范围和源路径，征得用户同意。
5. **新增或移动文件前先确定平台范围**，并同步更新 `.chezmoiignore.tmpl`。
6. 不确定就停下来问用户，不要猜平台、不要猜路径。

## 第 0 步：前置检查

```sh
command -v chezmoi
target=/absolute/path/to/config
```

目标必须是绝对路径；相对路径先转成绝对路径。目标必须在 chezmoi 的 home 之下：

```sh
home=$(chezmoi execute-template '{{ .chezmoi.homeDir }}')
```

如果 dotfiles 仓库根目录有 `AGENTS.md`，先读它；它是本仓库约定的最新来源：

```sh
repo=$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel 2>/dev/null \
  || dirname "$(chezmoi source-path)")
if [ -f "$repo/AGENTS.md" ]; then cat "$repo/AGENTS.md"; fi
```

先运行只读检查脚本（如果存在）：

```sh
~/.config/opencode/skills/chezmoi/scripts/inspect.sh "$target"
```

它会输出 `state`、`source`、`kind`、`drift`、`linux`、`windows` 等字段。下面的步骤是它的展开说明。

## 第 1 步：判定状态

**不要用 `chezmoi managed` 判定**：它对未管理路径也可能返回 0 且没有输出。

判定逻辑：

```sh
rel=${target#"$home"/}
state=unmanaged
if src=$(chezmoi source-path -- "$target" 2>/dev/null); then
  state=managed
else
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    p=${p%/}
    case "$rel" in
      "$p"|"$p"/*) state=ignored; break ;;
    esac
  done <<EOF
$(chezmoi ignored)
EOF
fi
```

| 状态 | 判据 | 处理 |
|---|---|---|
| `managed` | `chezmoi source-path` 成功 | 编辑 `$src` |
| `ignored` | source-path 失败，且相对路径命中 `chezmoi ignored` 的条目 | 不要 add；确认平台；必要时改 ignore 模板 |
| `unmanaged` | source-path 失败，且不在 ignored 列表 | 按第 4 步询问是否纳管 |
| `outside-home` | stderr 含 `not in destination directory` | 不走 chezmoi |
| `no-chezmoi` | `command -v chezmoi` 失败 | 普通编辑，提示用户 |

漂移检查用 `verify`，不要用 `status` 的退出码：

```sh
chezmoi verify -- "$target"   # 0 = 干净，1 = 有漂移
chezmoi status -- "$target"   # 仅用于展示
```

**`ignored` 不一定是“未纳管”**：本仓库在 Linux 上用 `{{ if ne .chezmoi.os "linux" }}` 排除 Windows 专属路径（`AppData`、`.taskrc`），在 Windows 上排除 Linux 专属路径。看到 `~/AppData/...` 在 Linux 上被忽略是正常的，不要再 `chezmoi add`。

## 第 2 步：识别源文件类型

拿到 `$src` 后，先判断它属于哪一类：

| 类型 | 特征 | 编辑位置 |
|---|---|---|
| 普通文件 | 直接内容 | `$src` |
| 模板 | 文件名以 `.tmpl` 结尾 | `$src` |
| 薄 wrapper | 内容只有 `{{- template "xxx" . -}}` | `$(chezmoi source-path)/.chezmoitemplates/xxx` |
| 共享模板 | 位于 `.chezmoitemplates/` | 该文件 |
| 加密文件 | `encrypted_*` 或 `*.age` | 见“加密文件” |
| 加密模板 | 内容含 `include ... \| decrypt` | 见“加密文件” |

薄 wrapper 例子：

```gotemplate
{{- template "yazi-yazi.toml" . -}}
```

真正内容在 `.chezmoitemplates/yazi-yazi.toml`，不要改 wrapper。wrapper 的改动会影响所有平台。

## 第 3 步：跨平台判定

先回答：**这个配置由哪些平台上的应用读取？** 不要只看文件扩展名。

```text
仅 Linux
├─ 目标路径已在 `{{ if ne .chezmoi.os "linux" }}` 块中 → 直接放源文件
└─ 否则 → 放源文件，并把目标路径加入该 block

仅 Windows
├─ 目标在 AppData/ 或 .taskrc → 已被现有 block 覆盖
└─ 其他（如 Documents/PowerShell/...）→ 放源文件，并加入 `{{ if ne .chezmoi.os "windows" }}` block

两平台
├─ 目标相对路径相同 → 单文件（如 .gitconfig）
├─ 路径不同、内容相同 → .chezmoitemplates/<id> + 每平台薄 wrapper
└─ 内容也不同 → 分开文件，各自在另一 OS 的 ignore block 中排除；或用模板条件
```

本仓库常见映射：

| 内容 | Linux | Windows |
|---|---|---|
| zsh | `~/.config/zsh` | 不部署 |
| systemd / kitty / ghostty / alacritty / btop / mpd / rmpc / dae / ibus / borg / zellij / scripts / fontconfig | `~/.config/...` | 不部署 |
| yazi / lazygit / fastfetch / superfile / elio | `~/.config/<app>/` | `%APPDATA%\<app>\` |
| taskwarrior | `~/.config/task/taskrc` | `~/.taskrc` |
| rclone | `~/.config/rclone/rclone.conf` | `%APPDATA%\rclone\rclone.conf` |
| aliyunpan | `~/.config/aliyunpan/config/` | `%APPDATA%\aliyunpan\` |
| git / opencode | `~/.config/...` | `%USERPROFILE%\.config\...` |

规则：

- `.chezmoiignore.tmpl` 匹配**目标路径**，不是源文件名；忽略目录会连带子文件。
- `.chezmoiscripts/` 下的脚本要写全前缀，例如 `.chezmoiscripts/pull_kitty_icon.sh`。
- 不要猜 PowerShell / Windows Terminal 的路径。PowerShell 用 `$PROFILE` 查；Windows Terminal 的 `settings.json` 带随机包名，且属于应用频繁重写的文件，默认不建议纳管。
- 当前 OS 无法真实验证另一平台。快速检查：

  ```sh
  chezmoi execute-template --override-data '{"chezmoi":{"os":"windows"}}' \
    < "$(chezmoi source-path)/.chezmoiignore.tmpl"
  ```

  完整模拟：复制源树，把 ignore 模板里的 `ne` 改成 `eq`，再跑 `chezmoi -S <副本>/home managed --include files`（应为 23 个）。
- 只存在于另一平台的配置：可以直接在源树里创建文件，补好 ignore，再用 `chezmoi target-path` 检查映射；不要在当前 OS 上 `chezmoi add` 一个不存在的目标。

## 第 4 步：是否纳管

只在 `state=unmanaged` 时执行。先给用户一个简短结论，再问。

| 情况 | 建议 |
|---|---|
| 用户偏好、文本、体积小、长期稳定 | 可以纳管 |
| 需要跨机器/跨平台复用 | 优先纳管 |
| 含密钥 | 用 `--encrypt` 或 `{{ include ... \| decrypt }}`；否则不纳管 |
| 缓存、数据库、日志、历史、浏览器 profile | 不纳管 |
| 应用频繁重写的状态文件（窗口布局、最近打开、token） | 不纳管 |
| 大二进制、字体、图片 | 不纳管（交给包管理器） |
| 机器相关的绝对路径/主机名 | 先模板化，否则不纳管 |
| 已被其他工具管理 | 谨慎，避免双写冲突 |
| `$HOME` 之外 | 默认不纳管 |

获得同意后：

```sh
chezmoi add --secrets=error -- "$target"
chezmoi chattr +private -- "$target"      # 需要 0600
chezmoi chattr +executable -- "$target"   # 需要可执行位
chezmoi chattr +template -- "$target"     # 需要模板化
```

然后立刻检查平台归属：如果是平台专属，更新 `.chezmoiignore.tmpl`，再 apply。

## 第 5 步：编辑

### 普通文件 / 模板

```sh
src=$(chezmoi source-path -- "$target")
# 用 edit 工具修改 $src；保留模板语法和原有格式
chezmoi cat -- "$target" >/dev/null   # 模板先确认能渲染
```

### 薄 wrapper

```sh
# 从 wrapper 中取出模板名
grep -o -E 'template[[:space:]]+"[^"]+"' "$src"
# 编辑 $(chezmoi source-path)/.chezmoitemplates/<name>
```

### 漂移

如果目标文件被直接改过，先问用户：

- 想保留目标文件的改动 → `chezmoi re-add -- "$target"`（把目标导入源）。
- 想以源为准 → `chezmoi apply -- "$target"`（会覆盖目标）。

不要默认选一个。

### 删除 / 移动

先问清楚“只从 chezmoi 移除”还是“连目标文件一起删”：

- `chezmoi forget -- "$target"`：从源状态移除，保留目标文件。
- `chezmoi destroy -- "$target"`：删除源状态和目标文件（危险，需确认）。
- 移动目标：手动改源文件名后 apply，并清理旧目标；先与用户确认。

### 加密文件

`encrypted_*` / `*.age`：

- 不要用 write 工具直接写 `.age`。
- `chezmoi edit` 能解密到临时目录再加密回去，但它是交互式的；让用户手动执行。
- 需要自动化时，用 age 解密到 `/tmp/opencode/`，编辑后再加密回去；确保不留下明文，权限 0600。
- 特别注意 `.chezmoitemplates/rclone.conf.age` 这种双层结构：`chezmoi edit <目标>` 只会编辑外层 wrapper，不会编辑真正的加密内容。遇到这种情况，停下来让用户确认。

## 第 6 步：apply 与验证

```sh
chezmoi apply  -- "$target"
chezmoi verify -- "$target"     # 必须为 0
chezmoi status -- "$target"     # 应为空
```

按文件类型做语法检查，详见 `references/validation.md`：

- zsh：`zsh -n <file>`
- POSIX sh：`sh -n <file>`
- Python：`python3 -m py_compile <file>`
- TOML：`python3 -c 'import tomllib,sys; tomllib.load(open(sys.argv[1],"rb"))' <file>`
- JSON（严格）：`jq empty <file>`
- JSONC：用应用自身校验，或 `python3` + `json5`（如果安装）
- Lua：`luac -p <file>`
- 模板：`chezmoi cat -- "$target" >/dev/null`；`.chezmoi.toml.tmpl` 用 `chezmoi execute-template --init < file`

应用重载：

- zsh：新开 shell 或 `exec zsh`
- systemd：`systemctl --user daemon-reload`，必要时 `enable --now`
- kitty/ghostty：重载配置或重启
- OpenCode：配置热重载；必要时 `/reload`
- `run_onchange_*` 脚本：内容变化后需要完整 `chezmoi apply` 才会重新运行；注意副作用和联网

## 第 7 步：提交

```sh
repo=$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel 2>/dev/null \
  || dirname "$(chezmoi source-path)")
git -C "$repo" status --short
git -C "$repo" diff --stat
```

按仓库惯例提交，例如：

```sh
git -C "$repo" add -- <changed source files>
git -C "$repo" commit -m "[opencode] add chezmoi skill"
```

用户没有要求提交时，先展示 diff 并询问，不要擅自提交。

## 停止条件

遇到以下情况，停下来问用户：

- 平台范围不确定。
- 是否纳管不确定，或涉及删除/移动。
- 涉及密钥、`encrypted_*`、`.age`。
- `chezmoi apply` 出现冲突或交互提示。
- 需要修改 `.chezmoiignore.tmpl` 但不确定该放哪个 block。
