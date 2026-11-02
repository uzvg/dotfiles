if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}

. "$HOME\Documents\PowerShell\aliases.ps1"
