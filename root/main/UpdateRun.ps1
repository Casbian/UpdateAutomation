function UpdateRunWindowsUpdate($AppList) {
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
        #<DO Nothing>#
    }
}
function UpdateRunWinget($AppList) {
    try {
        RichTextBox $SystemWindowsControlsRichTextBox0 ""
        Window
        foreach ($App in $AppList) {
            $AppName = $App.name
            $AppID = $App.id
            RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | Installation   | $AppName | -" -Color ([System.Windows.Media.Brushes]::Cyan)
            SystemWindow-Refresh
            winget install --id $AppID --uninstall-previous --accept-package-agreements --accept-source-agreements --force | ForEach-Object {
                RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> $_" -RemoveLast -Color ([System.Windows.Media.Brushes]::Cyan)
                SystemWindow-Refresh
            }
            RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | Installation   | ✔ - $AppName" -Color ([System.Windows.Media.Brushes]::Cyan)  
            SystemWindow-Refresh
        }
    }
    catch {
        ##
    }
}