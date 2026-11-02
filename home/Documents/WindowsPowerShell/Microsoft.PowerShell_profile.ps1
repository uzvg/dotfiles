if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}

. "$HOME\Documents\WindowsPowerShell\aliases.ps1"
