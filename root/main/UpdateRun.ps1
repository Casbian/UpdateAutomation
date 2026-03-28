function UpdateRunWindowsUpdate() {
    try {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Remove-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
            Install-Module PSWindowsUpdate -Force -Scope AllUsers -ErrorAction SilentlyContinue
        }
        Import-Module PSWindowsUpdate;
        $Services = @('wuauserv', 'bits', 'cryptsvc')
        foreach ($ServiceName in $Services) {
            $serviceRunning = $false;
            while ($serviceRunning -eq $false) {
                $Service = Get-Service -Name $ServiceName;
                if ($null -eq $service) {
                    break;
                }
                if ($service.Status -ne 'Running') {
                    Start-Service $ServiceName;
                } else {
                    $ServiceRunning = $true;
                    break;
                }
            }
        }
        $StringBuilder = New-Object System.Text.StringBuilder
        $Output = Get-WindowsUpdate -AcceptAll -Install -Verbose -IgnoreReboot 4>&1 
        foreach ($Line in $Output) {
            $TrimmedLine = $Line.Message -replace 'Please wait\.\.\.', ''
            $StringBuilder.AppendLine($TrimmedLine) | Out-Null
        }
        return $StringBuilder.ToString().Trim()
    } catch {
        <#SOON#>
    }
}
function UpdateRunWinget($AppList) {
    try {
        winget source add --name "winget" --arg "https://cdn.winget.microsoft.com/cache" --type "Microsoft.PreIndexed.Package" | Out-Null
        winget source add --name "msstore" --arg "https://storeedgefd.dsx.mp.microsoft.com/v9.0" --type "Microsoft.Rest" | Out-Null
        winget source update | Out-Null
        $StringBuilder = New-Object System.Text.StringBuilder
        foreach ($App in $AppList) {
            $AppID = $App.id
            $AppName = $App.name
            $Output = winget upgrade --id $AppID --silent --accept-package-agreements --accept-source-agreements 4>&1
            if ($LASTEXITCODE -ne 0) {
                $Output = winget install --id $AppID --silent --uninstall-previous --accept-package-agreements --accept-source-agreements 4>&1
            }
            if ($LASTEXITCODE -eq 0) {
                foreach ($Line in $Output) {
                    $LineString = $Line.ToString().Trim()
                    if ($LineString -match '^[-\\|/]$') { continue }
                    if ($LineString -match 'ÔûÆ|Ôûê|Ôûæ|^\s*[\d.]+ [KMGT]?B') { continue }
                    $LineString = $LineString -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
                    if ($LineString -ne '') {
                        $StringBuilder.AppendLine($LineString) | Out-Null
                    }
                }
            } else {
                $StringBuilder.AppendLine("Unable to update $AppName") | Out-Null
            }    
        }
        return $StringBuilder.ToString().Trim()
    } catch {
        <#SOON#>
    }
}