if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $pwsh = Get-Command pwsh.exe -ErrorAction SilentlyContinue
    if ($pwsh) {
        try {
            Start-Process winget.exe -ArgumentList "upgrade --id Microsoft.Powershell --silent --accept-package-agreements --accept-source-agreements" -Wait #-WindowStyle Hidden 
            $Path = Join-Path (Split-Path ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)) "root\main.ps1"
            Start-Process pwsh.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$Path`" -EXELaunch" #-WindowStyle Hidden
            exit
        } catch {
            exit
        }
    }
    try {
        Start-Process winget.exe -ArgumentList "install --id Microsoft.PowerShell --uninstall-previous --accept-package-agreements --accept-source-agreements --force" -Wait
        Start-Process pwsh.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -EXELaunch" #-WindowStyle Hidden
        exit
    } catch {
        exit
    }
}