$ProgrammValues = @()
    $ProgrammsAllRegistryPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $ProgrammsAll = Get-ItemProperty $ProgrammsAllRegistryPaths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -and ($_.SystemComponent -ne 1) } | Select-Object @{Name="Software Name"; Expression={$_.DisplayName.Trim()}}, @{Name="Version"; Expression={$_.DisplayVersion}} | Sort-Object "Software Name" -Unique | Out-String
    $ProgrammsAll = $ProgrammsAll -split "`r?`n" | Where-Object { 
        $_ -and 
        $_ -notmatch "Software Name" -and 
        $_ -notmatch "-------" 
    }
    $ProgrammsAll = $ProgrammsAll.Trim()
    foreach ($Line in $ProgrammsAll) {
    $ProgrammValues += $Line
    }