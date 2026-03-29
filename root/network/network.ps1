function Network() {
    $NetAdapter= Get-NetAdapter | Sort-Object LinkSpeed -Descending | Select-Object -First 1 -ExpandProperty Name
    Enable-NetAdapter $NetAdapter
    if (Test-Connection -ComputerName "google.com" -Count 1 -Quiet) {
        return $NetAdapter
    }
    $RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }
    Set-ItemProperty -Path $RegistryPath -Name "LetAppsAccessLocation" -Value 1 -Type DWord
    $WlanNetworkProfiles = netsh.exe wlan show profiles | Select-String "[:]\s(.+)" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
    foreach ($WlanNetworkProfile in $WlanNetworkProfiles) {
        netsh.exe wlan connect name="$WlanNetworkProfile"
        Start-Sleep -Seconds 5
        if (Test-Connection -ComputerName "google.com" -Count 1 -Quiet) {
            $RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
            if (-not (Test-Path $RegistryPath)) {
                New-Item -Path $RegistryPath -Force | Out-Null
            }
            Set-ItemProperty -Path $RegistryPath -Name "LetAppsAccessLocation" -Value 2 -Type DWord
            return "Network $WlanNetworkProfile"
        }
    }
    $WlanNetworksBlocksRaw = netsh.exe wlan show networks
    $WlanNetworksBlocks = @()
    $LineCurrent = @()
    $WlanNetworksSSIDS = @()
    foreach ($Line in $WlanNetworksBlocksRaw) {
        if ($Line -match '^SSID \d+') {
            if ($LineCurrent.Count -gt 0) { $WlanNetworksBlocks += ,@($LineCurrent) }
            $LineCurrent = @($Line)
        } elseif ($LineCurrent.Count -gt 0 -and $line.Trim() -ne '') {
            $LineCurrent += $line
        }
    }
    if ($LineCurrent.Count -gt 0) { $WlanNetworksBlocks += ,@($LineCurrent) }
    $WlanNetworksBlocks | ForEach-Object { $_ -join "`n"; "" }
    foreach ($Block in $WlanNetworksBlocks) {
        $WlanNetworkSSID =  $Block | Select-String "SSID\s+\d+\s*:\s*(.+)" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
        $WlanNetworkSecured =  $Block | Select-String  ":\s*(WPA|WEP|AES|CCMP|TKIP|802\.1x)" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
        if (-not $WlanNetworkSecured) {
            $WlanNetworksSSIDS += $WlanNetworkSSID
        }
    }
    foreach ($SSID in $WlanNetworksSSIDS) {
        $TempPathWlanNetworkProfile = "$env:TEMP\CoreForge_wifi_profile_temp.xml"
        $TempWlanNetworkProfileXML = @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$SSID</name>
    <SSIDConfig><SSID><name>$SSID</name></SSID></SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>open</authentication>
                <encryption>none</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
        </security>
    </MSM>
</WLANProfile>
"@
        $TempWlanNetworkProfileXML | Out-File -FilePath $TempPathWlanNetworkProfile -Encoding utf8BOM
        netsh.exe wlan add profile filename="$TempPathWlanNetworkProfile"  | Out-Null
        netsh.exe wlan connect name="$SSID" | Out-Null
        Start-Sleep -Seconds 5
        if (Test-Connection -ComputerName "google.com" -Count 1 -Quiet) {
            $RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
            if (-not (Test-Path $RegistryPath)) {
                New-Item -Path $RegistryPath -Force | Out-Null
            }
            Set-ItemProperty -Path $RegistryPath -Name "LetAppsAccessLocation" -Value 2 -Type DWord
            return "Network $SSID"
        }
    }
}