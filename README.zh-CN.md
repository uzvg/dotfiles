# 🔧 uzvg 的 Dotfiles

[English](README.md) | **简体中文**

使用 [chezmoi](https://www.chezmoi.io/) 管理的个人 dotfiles。所有内容都位于受版本管理的 `home/` 目录树中（`.chezmoiroot` 为 `home`），并部署到 `$HOME`。

## 📦 包含内容

**Linux —— 完整配置**

- 🐚 **Zsh** —— 引导用的 `.zshenv`、zimfw、别名、环境变量、辅助函数
- 🖥️ **终端与桌面** —— Kitty、Ghostty、Alacritty、Zellij、fontconfig 规则、Kitty 的 `.desktop` 入口
- ⚙️ **systemd 用户单元** —— borg 备份、WikiSpace 自动化、dsh-web
- 🌐 **Linux 专属服务** —— dae（eBPF 代理）、mpd + rmpc、IBus/Rime
- 🧰 **工具** —— git 配置与 `pre-push` 钩子、btop、yazi、lazygit、fastfetch、superfile、elio、taskwarrior、rclone、aliyunpan
- 🔐 **密钥** —— SSH 私钥与凭据，使用 [age](https://age-encryption.org/) 加密

**Windows —— 原生环境，非 WSL**

- ⚙️ chezmoi 配置、`~/.ssh`、`~/.cargo`、opencode、WezTerm
- 🧰 yazi、lazygit、fastfetch、superfile、elio、taskwarrior、rclone、aliyunpan —— 写入各自原生的 `%APPDATA%` 路径

仅在 Linux 上生效的文件（zsh、systemd、kitty、ghostty……）在 Windows 上不会被部署。当某个工具在不同平台使用不同路径时，内容只保存在 `.chezmoitemplates/` 中一份，各平台再放一个单行包装文件引用它，因此不存在需要同步的第二份副本。完整映射见 [AGENTS.md](AGENTS.md)。

---

## 🚀 快速上手：部署到新机器

```bash
chezmoi init --apply uzvg -v
```

提示时请输入 **age** 口令（本仓库不使用 GPG）。首次 apply 时，`run_onchange_before_` 脚本会从 `secrets/keys/key.txt.age` 解密出 age identity `~/.config/chezmoi/key.txt`。

前置依赖：

- `PATH` 中有 `chezmoi` 和 `age` —— 配置使用 `encryption = "age"`
- Windows：需要 [Git for Windows](https://gitforwindows.org/)，它提供引导脚本所需的 `sh`

---

## 📝 apply 之后

- **systemd 单元会被部署，但不会自动启用：**
  ```bash
  systemctl --user daemon-reload
  systemctl --user enable --now borg-backup.timer
  ```
- 字体（BlexMono Nerd Font、Noto Sans CJK）、终端模拟器等应用**不会**由本仓库安装 —— 仓库只管理它们的配置。
- 诸如 `/home/uzvg`、`/mnt/backup`、`/usr/bin/gh` 的绝对路径是针对这台机器定制的；在其他机器上复用前请先调整。
