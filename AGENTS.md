# AGENTS.md

个人 chezmoi dotfiles，部署到 `$HOME`（远程仓库：`git@github.com:uzvg/dotfiles.git`）。受版本管理的 `home/` 目录树是唯一事实来源；`~/` 下的实际文件可能存在与之无关的漂移。

## 源目录结构与命名

- `.chezmoiroot` 为 `home`，因此所有受管理源文件都位于 `home/` 下，而非仓库根目录。
- Chezmoi 通过文件名编码目标名称与权限模式：
  - `dot_` → 前导 `.`；`private_` → 无前缀且权限为 `0600`。示例：`home/private_dot_config/zsh/private_dot_zshrc.tmpl` → `~/.config/zsh/.zshrc`。
  - `executable_` → 可执行位；`encrypted_…age` → 经 age 解密后的目标。示例：`home/private_dot_ssh/encrypted_private_id_ed25519.age` → `~/.ssh/id_ed25519`。
  - `.tmpl` → Go 模板。用 `chezmoi execute-template` 渲染；`home/.chezmoi.toml.tmpl` 需要 `chezmoi execute-template --init`。
- `home/secrets/` 受版本管理，但被 `home/.chezmoiignore.tmpl` 排除在部署之外。模板通过 `{{ include (joinPath .chezmoi.sourceDir "secrets/keys/<name>.txt.age") | decrypt | trim }}` 取用密钥；参见 `home/private_dot_config/private_borg/env.tmpl`。
- `home/.chezmoitemplates/` 存放跨平台共享的配置内容，**不会被部署**。目标侧只放一行 `{{- template "<name>" . -}}` 的薄包装，据此让同一份内容落到各平台的原生路径。

## 编辑与验证

- 编辑 `home/...` 下的源文件，然后用 `chezmoi apply <绝对目标路径>` 部署。不要直接编辑 `~/.config/...`：改动会被覆盖，且不受版本管理。若要把线上改动导入回来，改用 `chezmoi re-add <target>`。
- `chezmoi status` 是快速的漂移检查；当目标文件与源不一致时，`chezmoi verify` 会以非零状态退出。
- **不要**在无人值守的情况下运行 `chezmoi diff` 或 `chezmoi apply --dry-run`。`home/.chezmoi.toml.tmpl` 设置了 `diff.command = "nvim"`，两者都会启动交互式 nvim 并卡住。查看文本 diff 请用 `chezmoi diff --use-builtin-diff`。`chezmoi edit` 同样是交互式的。
- 没有 build、test、lint 或 CI 流程。用以下方式验证改动：
  - zsh 脚本/函数：`zsh -n <file>`
  - POSIX sh 脚本：`sh -n <file>`
  - Python 脚本：`python3 -m py_compile <file>`
  - 模板：`chezmoi execute-template < file.tmpl`
- 提交信息沿用现有的 `[component] 小写描述` 风格，例如 `[alias] add opencode alias`。

## 密钥与 apply 副作用

- 加密使用 **age**，不是 GPG；README 中的“GPG passphrase”措辞已过时。age recipient 硬编码在 `home/.chezmoi.toml.tmpl` 和 `czm_encryptier` 中。
- age identity 是 `~/.config/chezmoi/key.txt`，首次 apply 时由 `home/.chezmoiscripts/run_onchange_before_decrypt-private-key.{sh,ps1}.tmpl`（按平台二选一）从 `home/secrets/keys/key.txt.age` 解密得到。全新机器上会提示输入 passphrase。
- 交互式 zsh 辅助函数：`czm_encryptier <key_name> <key_text>` 写入 `secrets/keys/<key_name>.txt.age`，并复制一段可直接粘贴的 include 片段；`czm_decryptier <key_name>` 负责解密。
- `run_onchange_*` 这类 apply 脚本仅在其内容变化时重新运行。在全新机器上，其中包含通过 `curl` 下载 Kitty 图标，因此 apply 需要联网。
- `secrets/keys/*.age` 是有意以加密形式提交的。绝不要提交明文密钥。

## 平台差异（Linux / 原生 Windows）

仓库同时支持 Linux 与**原生 Windows**（非 WSL），靠两个机制区分：

1. **`.chezmoiignore.tmpl` 按 OS 过滤**。模式匹配的是**目标路径**（`.config/zsh`），不是源文件名；忽略目录会连同子文件一起忽略。忽略 `.chezmoiscripts/` 下的脚本必须写全前缀（`.chezmoiscripts/foo.sh`），只写文件名无效。
   - `{{ if ne .chezmoi.os "linux" }}`：zsh、systemd、kitty、ghostty、alacritty、btop、mpd、rmpc、dae、ibus、borg、zellij、scripts、fontconfig、git/hooks、`kitty.desktop`、`pull_kitty_icon.sh`、`decrypt-private-key.sh`。
   - `{{ if ne .chezmoi.os "windows" }}`：`AppData`、`.taskrc`、`Documents/PowerShell`、`Documents/WindowsPowerShell`、`decrypt-private-key.ps1`。
2. **`.chezmoitemplates` 共享内容 + 每平台薄包装**，对应 chezmoi 文档 "Handle different file locations on different systems with the same contents"。
   - PowerShell alias 只在 Windows 部署：`Documents/PowerShell/aliases.ps1` 与 `Documents/WindowsPowerShell/aliases.ps1` 都是 `.chezmoitemplates/powershell-aliases.ps1` 的薄包装；两个 `Microsoft.PowerShell_profile.ps1` 仅初始化 starship 并 dot-source 同目录的 `aliases.ps1`。不要直接编辑部署后的文件，改模板后重新 apply。

目标路径映射（`%APPDATA%` = `%USERPROFILE%\AppData\Roaming`，而 chezmoi 在 Windows 上的目标根就是 `%USERPROFILE%`）：

| 内容 | Linux | Windows |
|---|---|---|
| yazi / lazygit / fastfetch / superfile / elio | `.config/<app>/` | `AppData/Roaming/<app>/` |
| taskwarrior | `.config/task/taskrc` | `.taskrc` |
| rclone | `.config/rclone/rclone.conf` | `AppData/Roaming/rclone/rclone.conf` |
| aliyunpan | `.config/aliyunpan/config/` | `AppData/Roaming/aliyunpan/` |

- 加密的 rclone / aliyunpan 只保留一份密文（`.chezmoitemplates/*.age`），包装模板用 `{{ (include ".chezmoitemplates/<name>.age") | decrypt }}` 解密，避免两份密文漂移。
- 内容层面的平台差异也可用模板条件表达，例如 `fastfetch-config.jsonc` 的 `logo.source` 按 `.chezmoi.os` 切换。
- `git/config.tmpl` 在非 Linux 上不写 `hooksPath`，credential helper 去掉 `/usr/bin/` 前缀。
- key 引导脚本分平台两份：Linux 用 `run_onchange_before_decrypt-private-key.sh.tmpl`（POSIX `sh`），Windows 用 `run_onchange_before_decrypt-private-key.ps1.tmpl`（chezmoi 默认 `.ps1` 解释器，优先 `pwsh`、回退 `powershell`，不再依赖 Git for Windows 的 `sh`）；`.chezmoiignore.tmpl` 在各自平台忽略另一份。同时仍需手动安装外部 `age`（`encryption = "age"` 且未启用 builtin）。
- 走路径映射而非 symlink/junction，因此 Windows 上不需要开发者模式；但若 `%APPDATA%\...` 已存在真实目录，首次 apply 会报冲突，需先移走。
- 这些配置在 Windows 上读取的字体/编辑器/主题包仍需单独安装，仓库只负责文件落位。

验证：

```bash
chezmoi managed --include files | wc -l     # Linux 应为 97
chezmoi ignored                             # 应包含 AppData、.taskrc、secrets
```

Windows 分支可在 Linux 上模拟：把源树复制到临时目录，将 `.chezmoiignore.tmpl` 里所有 `{{ if ne .chezmoi.os ... }}` 中的 `ne` 都改成 `eq`，再跑 `chezmoi -S <副本>/home managed --include files`（应为 31 个）。

## 环境相关注意事项

- `~/.zshenv` 仅设置 `ZDOTDIR=$HOME/.config/zsh`。Shell 配置随后来自 `~/.config/zsh/.zshenv`、`env.zsh`、`alias.zsh` 以及 `.zshrc` 模板。别名添加到 `alias.zsh`；编辑受管理的配置请用 `chezmoi_edit` 辅助函数。Windows PowerShell 别名添加到 `.chezmoitemplates/powershell-aliases.ps1`。
- `env.zsh` 设置了 `NVIM_APPNAME=lazyvim`，因此直接运行 `nvim` 加载的是 `~/.config/lazyvim`，而不是本仓库位于 `~/.config/nvim` 的 NvChad 配置。测试时用 `NVIM_APPNAME=nvim nvim`（或 unset `NVIM_APPNAME`）。
- `home/private_dot_config/systemd/user/` 下的 systemd 用户单元会被部署，但不会被启用。修改后需运行 `systemctl --user daemon-reload` 和 `systemctl --user enable --now <unit>`。
- 尽管名字如此，`auto_commit.zsh` 和 `auto_publish.zsh` 自动化的是外部仓库 `~/Documents/wikis/WikiSpace`，而非这些 dotfiles。它们依赖 tiddlywiki、rclone、fd 和 rg。
- systemd 单元和 WikiSpace 脚本中出现了绝对路径 `/home/uzvg`；本仓库是针对这台机器/该用户定制的，不能原样移植。
- 全局 `core.hooksPath` 指向 `~/.config/git/hooks`，且只在 Linux 上写入（Windows 既不部署 hooks，也不写该键）。其 `pre-push` 是一个分发器，只对 TiddlyWiki 仓库（`.tiddlywiki`）生效，或当 `.git/hooks/pre-push` 存在时才生效；dotfiles 的 push 不会做任何特殊检查。
