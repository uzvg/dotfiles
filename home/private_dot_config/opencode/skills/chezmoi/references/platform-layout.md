# 平台布局与 ignore 规则

本文件补充 `SKILL.md` 的跨平台细节。本仓库的约定以仓库根目录的 `AGENTS.md` 为准；如果两者冲突，先读 `AGENTS.md`。

## 目标根与源目录

- Linux 目标根：`$HOME`
- Windows 目标根：`%USERPROFILE%`
- 源目录：`chezmoi source-path`（本仓库为 `<repo>/home`）
- 仓库根：`git -C "$(chezmoi source-path)" rev-parse --show-toplevel`

## 两套机制

1. `.chezmoiignore.tmpl` 按 OS 过滤**目标路径**。
2. `.chezmoitemplates/` 共享内容 + 每平台薄 wrapper。

### ignore 模板

```gotemplate
{{ if ne .chezmoi.os "linux" }}
# 非 Linux 平台不部署
...
{{ end }}

{{ if ne .chezmoi.os "windows" }}
AppData
.taskrc
{{ end }}
```

规则：

- 模式匹配目标路径，不是源文件名。
- 忽略目录会连带子文件。
- `.chezmoiscripts/` 下的脚本必须写全前缀，例如 `.chezmoiscripts/pull_kitty_icon.sh`。
- 修改后验证当前 OS：`chezmoi ignored`
- 验证另一 OS：

  ```sh
  chezmoi execute-template --override-data '{"chezmoi":{"os":"windows"}}' \
    < "$(chezmoi source-path)/.chezmoiignore.tmpl"
  ```

  把 `windows` 换成 `linux` 可以看 Linux 的忽略列表。

### 薄 wrapper

平台目标路径不同、内容相同时使用。源文件只有一行：

```gotemplate
{{- template "yazi-yazi.toml" . -}}
```

真正内容在 `.chezmoitemplates/yazi-yazi.toml`。编辑后者；wrapper 本身通常不用改。

### 加密共享模板

```gotemplate
{{ (include ".chezmoitemplates/rclone.conf.age") | decrypt }}
```

结构可能是：平台 wrapper → `.chezmoitemplates/rclone.conf`（加密模板）→ `.chezmoitemplates/rclone.conf.age`。
`chezmoi edit <目标>` 只会编辑外层 wrapper，不会编辑真正的加密内容。遇到这种文件，停下来让用户确认，或按 `SKILL.md` 的加密文件流程处理。

## 路径映射

| 内容 | Linux | Windows | 机制 |
|---|---|---|---|
| zsh | `~/.config/zsh` | 不部署 | Linux 专属 |
| systemd | `~/.config/systemd/user` | 不部署 | Linux 专属 |
| kitty / ghostty / alacritty | `~/.config/<app>` | 不部署 | Linux 专属 |
| btop / mpd / rmpc / dae / ibus / borg / zellij / scripts / fontconfig | `~/.config/...` | 不部署 | Linux 专属 |
| yazi | `~/.config/yazi` | `%APPDATA%\yazi` | 共享模板 + wrapper |
| lazygit | `~/.config/lazygit` | `%APPDATA%\lazygit` | 共享模板 + wrapper |
| fastfetch | `~/.config/fastfetch` | `%APPDATA%\fastfetch` | 共享模板 + wrapper |
| superfile | `~/.config/superfile` | `%APPDATA%\superfile` | 共享模板 + wrapper |
| elio | `~/.config/elio` | `%APPDATA%\elio` | 共享模板 + wrapper |
| taskwarrior | `~/.config/task/taskrc` | `~/.taskrc` | 共享模板 + wrapper |
| rclone | `~/.config/rclone/rclone.conf` | `%APPDATA%\rclone\rclone.conf` | 共享加密模板 + wrapper |
| aliyunpan | `~/.config/aliyunpan/config/` | `%APPDATA%\aliyunpan\` | 共享加密模板 + wrapper |
| git | `~/.config/git/config` | `%USERPROFILE%\.config\git\config` | 单文件/模板 |
| opencode | `~/.config/opencode` | `%USERPROFILE%\.config\opencode` | 单文件/模板 |

Windows 的 `%APPDATA%` 等于 `%USERPROFILE%\AppData\Roaming`，所以源树里的 `home/AppData/Roaming/<app>/...` 在 Windows 上落到 `%APPDATA%\<app>\...`；在 Linux 上由 `AppData` 的 ignore 规则排除。

## 新增平台专属配置

1. 确认应用只在目标 OS 读取这个文件。
2. 在源树创建文件：
   - Linux：`home/private_dot_config/...`
   - Windows：`home/AppData/Roaming/...`、`home/.taskrc`，或 `home/Documents/PowerShell/...`
3. 在 `.chezmoiignore.tmpl` 对应 block 中加入目标路径（如果尚未覆盖）：
   - Linux 专属：`{{ if ne .chezmoi.os "linux" }}` block
   - Windows 专属：`{{ if ne .chezmoi.os "windows" }}` block
4. 检查映射：
   ```sh
   chezmoi target-path <source-file>
   chezmoi execute-template --override-data '{"chezmoi":{"os":"windows"}}' \
     < "$(chezmoi source-path)/.chezmoiignore.tmpl"
   ```
5. 在目标 OS 上 `chezmoi apply <target>`；当前 OS 上至少确认 `chezmoi ignored` 的归属正确。

只存在于另一平台的配置，不要在当前 OS 上 `chezmoi add` 一个不存在的目标；直接创建源文件即可。

## 新增跨平台配置

### 目标相对路径相同

例如 `.gitconfig`：

- Linux：`~/.gitconfig`
- Windows：`%USERPROFILE%\.gitconfig`

直接放一份源文件，通常再加 `--template` 处理机器差异。

### 路径不同、内容相同

例如 taskwarrior：

- Linux：`~/.config/task/taskrc`
- Windows：`~/.taskrc`

做法：

1. 内容放 `home/.chezmoitemplates/task-taskrc`。
2. 两个平台各放一个薄 wrapper：
   ```gotemplate
   {{- template "task-taskrc" . -}}
   ```
3. 不要在两个平台的 ignore block 中排除这两个目标路径。

### 内容也不同

例如 zsh 和 PowerShell：分成两个平台专属文件，各自在另一 OS 的 ignore block 中排除。不要为了“共享”强行合并。

同一份 `.chezmoitemplates` 内容里可以用模板条件处理平台差异，例如：

```gotemplate
{{ if eq .chezmoi.os "linux" }}
...
{{ else if eq .chezmoi.os "windows" }}
...
{{ end }}
```

但路径差异仍然需要 wrapper。

## 验证 Windows 分支

快速检查：用上面的 `--override-data` 渲染 ignore 列表。

完整模拟：

```sh
src=$(chezmoi source-path)
tmp=$(mktemp -d)
cp -a "$src" "$tmp/home"
# Linux 上用 GNU sed；BSD/macOS 请改用 sed -i ''
sed -i 's/ne \.chezmoi\.os/eq .chezmoi.os/g' "$tmp/home/.chezmoiignore.tmpl"
chezmoi -S "$tmp/home" managed --include files | wc -l   # 应为 23
rm -rf "$tmp"
```

注意：这是静态模拟，不等于在 Windows 上真实 apply；模板渲染、路径存在性和权限仍需在 Windows 上确认。

## 常见坑

- `chezmoi managed` 对未管理路径也可能返回 0 且无输出，不能用来判定。
- `chezmoi status` 的退出码不表示漂移；漂移用 `chezmoi verify`。
- `chezmoi edit`、`chezmoi diff`、`chezmoi apply --dry-run` 会调用 nvim，交互式卡住。
- `AppData` 在 Linux 上被忽略，`source-path` 会报 `not managed`；这是正常的。
- `.taskrc` 在 Linux 上被忽略；Linux 用 `.config/task/taskrc`。
- `.chezmoiignore.tmpl` 的 `secrets/` 是目录规则，`secrets/keys/*` 也是。
- `run_onchange_*` 脚本只在内容变化时重新运行；编辑后需要完整 `chezmoi apply` 才会触发。
- Windows 上 `%APPDATA%` 不是 chezmoi 的目标根，目标根是 `%USERPROFILE%`；源路径要写成 `AppData/Roaming/...`。
