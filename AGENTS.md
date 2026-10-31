# AGENTS.md

Personal chezmoi dotfiles deployed to `$HOME` (remote: `git@github.com:uzvg/dotfiles.git`). The tracked `home/` tree is the source of truth; live files under `~/` may have unrelated drift.

## Source layout and naming

- `.chezmoiroot` is `home`, so every managed source lives under `home/`, not the repo root.
- Chezmoi encodes the target name and mode in filenames:
  - `dot_` → leading `.`; `private_` → no prefix and mode `0600`. Example: `home/private_dot_config/zsh/private_dot_zshrc.tmpl` → `~/.config/zsh/.zshrc`.
  - `executable_` → executable bit; `encrypted_…age` → age-decrypted target. Example: `home/private_dot_ssh/encrypted_private_id_ed25519.age` → `~/.ssh/id_ed25519`.
  - `.tmpl` → Go template. Render with `chezmoi execute-template`; `home/.chezmoi.toml.tmpl` needs `chezmoi execute-template --init`.
- `home/secrets/` is tracked but excluded from deployment by `home/.chezmoiignore.tmpl`. Templates pull secrets with `{{ include (joinPath .chezmoi.sourceDir "secrets/keys/<name>.txt.age") | decrypt | trim }}`; see `home/private_dot_config/private_borg/env.tmpl`.

## Editing and verification

- Edit the `home/...` source, then deploy with `chezmoi apply <absolute-target>`. Do not edit `~/.config/...` directly: changes are overwritten and untracked. To import a live edit instead, use `chezmoi re-add <target>`.
- `chezmoi status` is the fast drift check; `chezmoi verify` exits non-zero when the destination differs.
- Do **not** run `chezmoi diff` or `chezmoi apply --dry-run` unattended. `home/.chezmoi.toml.tmpl` sets `diff.command = "nvim"`, so both launch interactive nvim and hang. Use `chezmoi diff --use-builtin-diff` for a text diff. `chezmoi edit` is also interactive.
- There is no build, test, lint, or CI suite. Validate changes with:
  - `zsh -n <file>` for zsh scripts/functions
  - `python3 -m py_compile <file>` for the Python script
  - `chezmoi execute-template < file.tmpl` for templates
- Commits use the observed `[component] lowercase description` style, e.g. `[alias] add opencode alias`.

## Secrets and apply side effects

- Encryption is **age**, not GPG; the README's “GPG passphrase” wording is stale. The age recipient is hardcoded in `home/.chezmoi.toml.tmpl` and `czm_encryptier`.
- The age identity is `~/.config/chezmoi/key.txt`, decrypted from `home/secrets/keys/key.txt.age` by `home/.chezmoiscripts/run_onchange_before_decrypt-private-key.sh.tmpl` on first apply. A fresh machine prompts for the passphrase.
- Interactive zsh helpers: `czm_encryptier <key_name> <key_text>` writes `secrets/keys/<key_name>.txt.age` and copies a ready-to-paste include snippet; `czm_decryptier <key_name>` decrypts.
- The `run_onchange_*` apply scripts re-run only when their contents change. On a fresh machine this includes downloading a Kitty icon via `curl`, so applying needs network.
- `secrets/keys/*.age` are intentionally committed encrypted. Never commit plaintext secrets.

## Environment quirks

- `~/.zshenv` only sets `ZDOTDIR=$HOME/.config/zsh`. Shell setup then comes from `~/.config/zsh/.zshenv`, `env.zsh`, `alias.zsh`, and the `.zshrc` template. Add aliases to `alias.zsh`; use the `chezmoi_edit` helper for managed config edits.
- `env.zsh` sets `NVIM_APPNAME=lazyvim`, so plain `nvim` loads `~/.config/lazyvim`, not this repo's NvChad config at `~/.config/nvim`. Test it with `NVIM_APPNAME=nvim nvim` (or unset `NVIM_APPNAME`).
- systemd user units under `home/private_dot_config/systemd/user/` are deployed but not enabled. After changing them run `systemctl --user daemon-reload` and `systemctl --user enable --now <unit>`.
- Despite their names, `auto_commit.zsh` and `auto_publish.zsh` automate the external `~/Documents/wikis/WikiSpace` repo, not these dotfiles. They require tiddlywiki, rclone, fd, and rg.
- Absolute `/home/uzvg` paths appear in systemd units and WikiSpace scripts; this repo is tailored to this machine/user and is not portable as-is.
- Global `core.hooksPath` points to `~/.config/git/hooks`. Its `pre-push` is a dispatcher that only acts on TiddlyWiki repos (`.tiddlywiki`) or when `.git/hooks/pre-push` exists; dotfiles pushes get no special checks.
