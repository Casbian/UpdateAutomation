if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    try {
        $Path = Join-Path (Split-Path ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)) "root\main.ps1"
        Start-Process pwsh -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$Path`"" -WindowStyle Hidden
        exit
    } catch {
        if ($_.Exception.Message -match 'cancel') {
                exit
        }
        try {
            if ($PSVersionTable.PSVersion.Major -lt 7) {
                winget install --id Microsoft.PowerShell --uninstall-previous --accept-package-agreements --accept-source-agreements --silent --force
                Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
                exit
            }
        } catch {
            $Path = Join-Path (Split-Path ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)) "root\main.ps1"
            Start-Process PowerShell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$Path`"" -WindowStyle Hidden
            exit
        }
    }
}