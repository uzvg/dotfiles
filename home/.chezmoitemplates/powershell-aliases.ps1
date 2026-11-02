# PowerShell aliases/functions shared by PowerShell 7 and Windows PowerShell 5.1.
# Managed by chezmoi: edit .chezmoitemplates/powershell-aliases.ps1, not this file.
#
# Optional tools (install with winget):
#   winget install lsd-rs.lsd
#   winget install sharkdp.bat
#   winget install aristocratos.btop4win
#   winget install Fastfetch-cli.Fastfetch
#   winget install muesli.duf
#   winget install bootandy.dust
#   winget install Neovim.Neovim
#   winget install Rclone.Rclone
#   winget install BurntSushi.ripgrep.MSVC

# Prefer Microsoft Coreutils over conflicting PowerShell aliases.
$coreutilsCommands = @(
    'cat',
    'cp',
    'date',
    'echo',
    'ls',
    'mkdir',
    'mv',
    'pwd',
    'rm',
    'rmdir',
    'sleep',
    'sort',
    'tee',
    'uptime'
)

foreach ($name in $coreutilsCommands) {
    Remove-Item "Alias:$name" -Force -ErrorAction SilentlyContinue
}

function _HasCommand {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

# Editor fallback for e and chezmoi edit.
if (-not $env:EDITOR) {
    if (_HasCommand edit) {
        $env:EDITOR = 'edit'
    } elseif (_HasCommand nvim) {
        $env:EDITOR = 'nvim'
    } else {
        $env:EDITOR = 'notepad'
    }
}
if (-not $env:VISUAL) {
    $env:VISUAL = $env:EDITOR
}

# ---------------------------------------------------------------
# General
# ---------------------------------------------------------------
if (_HasCommand lsd) {
    function ls { lsd @args }
    function la { lsd -a @args }
    function l { lsd -l @args }
    function ll { lsd -lha @args }
} else {
    function la { ls -a @args }
    function l { ls -l @args }
    function ll { ls -lha @args }
}

if (_HasCommand lazygit) { Set-Alias g lazygit }

if (_HasCommand bat) {
    Set-Alias c bat
} else {
    Set-Alias c cat
}

if (_HasCommand btop) {
    function t { btop --preset 1 @args }
}

function e {
    & $env:EDITOR @args
}

function q {
    exit
}

if (_HasCommand duf) { Set-Alias df duf }
if (_HasCommand dust) { Set-Alias du dust }
if (_HasCommand fastfetch) { Set-Alias ff fastfetch }
if (_HasCommand taskwarrior-tui) { Set-Alias tt taskwarrior-tui }

function weather {
    curl.exe wttr.in/Shanghai @args
}

# ---------------------------------------------------------------
# chezmoi
# ---------------------------------------------------------------
Set-Alias czm chezmoi
function czmr { chezmoi re-add @args }
function czmcd { chezmoi cd @args }
function czmd { chezmoi managed -i dirs @args }
function czmf { chezmoi managed -i files @args }
function czmst { chezmoi status @args }
function czmrc { chezmoi edit-config-template @args }

# Equivalent of the zsh chezmoi_edit helper.
function ce {
    if (-not $args -or $args.Count -eq 0) {
        Write-Error 'missing config file'
        return
    }
    foreach ($p in $args) {
        if (-not (Test-Path -LiteralPath $p)) {
            Write-Error "$p does not exist"
            continue
        }
        chezmoi edit --apply -- $p
    }
}

if (_HasCommand lazygit) {
    function dotfiles { lazygit -p "$HOME\.local\share\chezmoi" @args }
}

# Windows-side config editors.
function wtrc { chezmoi edit --apply -- "$HOME\.config\wezterm\wezterm.lua" }
function rarc { chezmoi edit --apply -- "$env:APPDATA\yazi\config\yazi.toml" }

# ---------------------------------------------------------------
# File manager / system tools
# ---------------------------------------------------------------
if (_HasCommand yazi) { Set-Alias ra yazi }
if (_HasCommand gdu_windows_amd64.exe) {
    function gdu { gdu_windows_amd64.exe @args }
}
if (_HasCommand opencode) { Set-Alias oc opencode }

if (_HasCommand rclone) {
    function wpsync {
        rclone sync "$HOME\Pictures\Wallpapers" OneDrive:Wallpapers --progress @args
    }
}

# ---------------------------------------------------------------
# Neovim per-app configs
# ---------------------------------------------------------------
if (_HasCommand nvim) {
    function mm {
        $previous = $env:NVIM_APPNAME
        $env:NVIM_APPNAME = 'nvim-minimax'
        try { nvim @args } finally { $env:NVIM_APPNAME = $previous }
    }
    function nv {
        $previous = $env:NVIM_APPNAME
        $env:NVIM_APPNAME = 'nvchad'
        try { nvim @args } finally { $env:NVIM_APPNAME = $previous }
    }
    function lv {
        $previous = $env:NVIM_APPNAME
        $env:NVIM_APPNAME = 'lazyvim'
        try { nvim @args } finally { $env:NVIM_APPNAME = $previous }
    }
}

Remove-Item Function:\_HasCommand -Force -ErrorAction SilentlyContinue
