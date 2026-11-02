# 🔧 Dotfiles by uzvg

**English** | [简体中文](README.zh-CN.md)

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Everything lives in the tracked `home/` tree (`.chezmoiroot` is `home`) and is deployed to `$HOME`.

## 📦 What's included

**Linux — full setup**

- 🐚 **Zsh** — bootstrapped `.zshenv`, zimfw, aliases, environment, helper functions
- 🖥️ **Terminals & desktop** — Kitty, Ghostty, Alacritty, Zellij, fontconfig rules, Kitty `.desktop` entry
- ⚙️ **systemd user units** — borg backup, WikiSpace automations, dsh-web
- 🌐 **Linux-only services** — dae (eBPF proxy), mpd + rmpc, IBus/Rime
- 🧰 **Tools** — git config + `pre-push` hooks, btop, yazi, lazygit, fastfetch, superfile, elio, taskwarrior, rclone, aliyunpan
- 🔐 **Secrets** — SSH keys and credentials, encrypted with [age](https://age-encryption.org/)

**Windows — native, not WSL**

- ⚙️ chezmoi config, `~/.ssh`, `~/.cargo`, opencode, WezTerm
- 🧰 yazi, lazygit, fastfetch, superfile, elio, taskwarrior, rclone, aliyunpan — written to their native `%APPDATA%` locations

Linux-only files (zsh, systemd, kitty, ghostty, …) are simply not deployed on Windows. Where a tool uses a different path per platform, the content is stored once in `.chezmoitemplates/` and each platform gets a one-line wrapper that pulls it in, so there is never a second copy to keep in sync. See [AGENTS.md](AGENTS.md) for the full mapping.

---

## 🚀 Quick Setup: Deploy to a New Machine

```bash
chezmoi init --apply uzvg -v
```

When prompted, enter the **age** passphrase (this repo does not use GPG). The age identity `~/.config/chezmoi/key.txt` is decrypted from `secrets/keys/key.txt.age` by a `run_onchange_before_` script on first apply.

Prerequisites:

- `chezmoi` and `age` on `PATH` — the config uses `encryption = "age"`
- On Windows: [Git for Windows](https://gitforwindows.org/), which provides the `sh` used by the bootstrap script

---

## 📝 After applying

- **systemd units are deployed but not enabled:**
  ```bash
  systemctl --user daemon-reload
  systemctl --user enable --now borg-backup.timer
  ```
- Fonts (BlexMono Nerd Font, Noto Sans CJK), terminal emulators, and other applications are **not** installed by this repo — only their configs are.
- Absolute paths such as `/home/uzvg`, `/mnt/backup`, and `/usr/bin/gh` are tailored to this machine; adjust them before reusing this repo elsewhere.
