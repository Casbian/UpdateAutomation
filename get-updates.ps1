Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class ConsoleHelper {
    const int STD_INPUT_HANDLE = -10;
    const uint ENABLE_QUICK_EDIT = 0x0040;
    const uint ENABLE_EXTENDED_FLAGS = 0x0080;
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll")]
    static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
    [DllImport("kernel32.dll")]
    static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
    public static void DisableQuickEdit() {
        IntPtr consoleHandle = GetStdHandle(STD_INPUT_HANDLE);
        uint mode;
        if (!GetConsoleMode(consoleHandle, out mode)) return;
        mode &= ~ENABLE_QUICK_EDIT;
        mode |= ENABLE_EXTENDED_FLAGS;
        SetConsoleMode(consoleHandle, mode);
    }
}
"@
[ConsoleHelper]::DisableQuickEdit();
$Host.UI.RawUI.BackgroundColor = "Black";
Clear-Host;
$tempPath = $env:TEMP;
while ($true) {
    netsh.exe interface set interface "WLAN" admin=enable;
    netsh.exe interface set interface "Ethernet" admin=enable;
    netsh.exe interface set interface "Mobilfunk" admin=enable;
    reg.exe add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessLocation /t REG_DWORD /d 1 /f;
    $knownProfilesOutput = netsh wlan show profiles | Select-String "alle Benutzer";
    $knownProfiles = $knownProfilesOutput -replace '.*: ', '';
    if ($knownProfiles -ne "") {
        $knownProfiles | ForEach-Object { netsh.exe wlan connect name="$_"; $testServer = "google.com"; if (Test-Connection -ComputerName $testServer -Count 3 -Quiet) {break;} }
    }
    else {
        $visibleNetworks = netsh.exe wlan show networks;
        $openSSIDs = @();
        foreach ($line in $visibleNetworks) {
            if ($line -match "^SSID\s+\d+\s*:\s*(.+)$") {
                $currentSSID = $matches[1].Trim()
            }
            elseif ($currentSSID -and $line -match "^\s*Authentifizierung\s*:\s*(Offen)\s*$") {
                $openSSIDs += $currentSSID
                $currentSSID = $null
            }
        }
        $openSSIDs | ForEach-Object {
            $wlanProfilePath = Join-Path $tempPath "Wi-Fi.xml";                                                                                                                                                                               
            $wlanProfileXml = @"                                                                                                           
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$_</name>
    <SSIDConfig>
        <SSID>
            <name>$_</name>
        </SSID>
    </SSIDConfig>
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
            $wlanProfileXml | Set-Content -Path $wlanProfilePath -Encoding UTF8;
            netsh.exe wlan add profile filename="$wlanProfilePath";
            netsh.exe wlan connect name="$_";
            $testServer = "google.com";
            if (Test-Connection -ComputerName $testServer -Count 3 -Quiet) {
                break;
            }
        }
    }
}
$cleanupScriptPath = Join-Path $tempPath "CleanUp.ps1";
$cleanupScript = @'
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class ConsoleHelper {
    const int STD_INPUT_HANDLE = -10;
    const uint ENABLE_QUICK_EDIT = 0x0040;
    const uint ENABLE_EXTENDED_FLAGS = 0x0080;
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll")]
    static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
    [DllImport("kernel32.dll")]
    static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
    public static void DisableQuickEdit() {
        IntPtr consoleHandle = GetStdHandle(STD_INPUT_HANDLE);
        uint mode;
        if (!GetConsoleMode(consoleHandle, out mode)) return;
        mode &= ~ENABLE_QUICK_EDIT;
        mode |= ENABLE_EXTENDED_FLAGS;
        SetConsoleMode(consoleHandle, mode);
    }
}
"@
[ConsoleHelper]::DisableQuickEdit();
$Host.UI.RawUI.BackgroundColor = "Black";
Clear-Host;
netsh.exe wlan delete profile name="Freifunk";
$tempPath = $env:TEMP;                                                                                                    
$wlanProfilePath = Join-Path $tempPath "Wi-Fi.xml";
Remove-Item -Path `"$wlanProfilePath`" -Force -ErrorAction SilentlyContinue;
reg.exe add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessLocation /t REG_DWORD /d 2 /f;
netsh.exe interface set interface "WLAN" admin=disable;
netsh.exe interface set interface "Bluetooth-Netzwerkverbindung" admin=disable;
netsh.exe interface set interface "Ethernet" admin=disable;
netsh.exe interface set interface "Mobilfunk" admin=disable;
Get-PnpDevice | Where-Object {$_.Class -eq "Bluetooth"} | Disable-PnpDevice -Confirm:$false -ErrorAction SilentlyContinue;                                                                                                    
$cleanupScriptPath = Join-Path $tempPath "CleanUp.ps1";
Remove-Item -Path `"$cleanupScriptPath`" -Force -ErrorAction SilentlyContinue;
Unregister-ScheduledTask -TaskName "Update_CleanUp_Task" -Confirm: $false -ErrorAction SilentlyContinue;
Stop-Computer -Force;
shutdown.exe /s /t 0 /f;
'@                                                                                                                         
$cleanupScript | Set-Content -Path $cleanupScriptPath -Encoding UTF8;
$taskName = "Update_CleanUp_Task";
$currentUser = "$env:USERDOMAIN\$env:USERNAME";
$trigger = New-ScheduledTaskTrigger -AtLogOn;
$trigger.UserId = $currentUser;
$trigger.Delay = "PT0M";
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$cleanupScriptPath`"";
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Highest;
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable -AllowStartIfOnBatteries -DontStopOnIdleEnd;
Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Principal $principal -Settings $settings | Out-Null;
Install-PackageProvider -Name NuGet -Force -Scope AllUsers -ErrorAction SilentlyContinue;
Install-Module PSWindowsUpdate -Force -Confirm:$false -Scope AllUsers -ErrorAction SilentlyContinue;
Import-Module PSWindowsUpdate;
$services = @('wuauserv', 'bits', 'cryptsvc')
foreach ($serviceName in $services) {
    $serviceRunning = $false;
    while ($serviceRunning -eq $false) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue;
        if ($null -eq $service) {
            break;
        }
        if ($service.Status -ne 'Running') {
            Start-Service $serviceName -ErrorAction SilentlyContinue;
        } else {
            $serviceRunning = $true;
            break;
        }
    }
}
$transcriptPath = Join-Path $tempPath 'WindowsUpdateTranscript.txt';
$updateCommand = "while (`$true) {`$tempPath = `$env:TEMP; `$transcriptPath = Join-Path `$tempPath 'WindowsUpdateTranscript.txt'; Start-Transcript -Path `$transcriptPath -Force; Get-WindowsUpdate -AcceptAll -Install -Verbose -IgnoreReboot; if (`$?) {Stop-Transcript;break;}else {Stop-Transcript;}}";
Start-Process powershell.exe -ArgumentList "-NoProfile -Command $updateCommand" -Wait -NoNewWindow;
$allLines = Get-Content -Path $transcriptPath;
$verboseLines = $allLines | Where-Object { $_ -like 'AUSF*HRLICH:*' };
$updateResults = $verboseLines -join "`n";
Remove-Item -Path $transcriptPath -Force -ErrorAction SilentlyContinue;
Start-Transcript -Path $transcriptPath -Force;
$C2RClient = "C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe";
if(Test-Path $C2RClient) {
    Start-Process $C2RClient -Wait -NoNewWindow;
}
$apps = @(
    @{ name = "PuTTY";id = "PuTTY.PuTTY"},
    @{ name = "Firefox";id = "Mozilla.Firefox"},
    @{ name = "WinSCP";id = "WinSCP.WinSCP"},
    @{ name = "Notepad++";id = "Notepad++.Notepad++"}
)
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe;
foreach ($app in $apps) {
    Write-Warning "SYSTEM | - | Installation $($app.name)";
    winget install --id $app.id --silent --accept-package-agreements --accept-source-agreements --scope machine;
    Write-Host "SYSTEM | v/ | Installation $($app.name)" -ForegroundColor Green;
}
Stop-Transcript;
$allLines = Get-Content -Path $transcriptPath;
$matchedLines = @();
$currentApp = "";
foreach ($line in $allLines) {
    if ($line -match 'SYSTEM \| - \| Installation (.+)') {
        $currentApp = $matches[1];
        continue;
    }
    if ($line -match 'Found' -and $currentApp) {
        $matchedLines += "${currentApp}: $line";
        continue;
    }
    if ($currentApp -ne "" -and $line -notmatch 'SYSTEM') {
        $matchedLines += "${currentApp}: $line";
    }
    if ($line -match 'SYSTEM \|') {
        $currentApp = "";
    }
}
$results = $matchedLines -join "`n";
Remove-Item -Path $transcriptPath -Force -ErrorAction SilentlyContinue;
$batteryStatus = Get-CimInstance -ClassName Win32_Battery;
$fullChargedCapacity = (Get-WmiObject -Namespace "root\wmi" -Class "BatteryFullChargedCapacity").FullChargedCapacity;
$currentPercentage = $batteryStatus.EstimatedChargeRemaining;
$currentCapacity = [math]::Round($fullChargedCapacity * $currentPercentage / 100);
$computerName=$env:COMPUTERNAME;
$currentTime = Get-Date -Format "HH:mm:ss dd.MM.yyyy";
$username = "";
$appPassword = "";
$recipient = "";
$securePass = ConvertTo-SecureString $appPassword -AsPlainText -Force;
$credential = New-Object System.Management.Automation.PSCredential($username, $securePass);
$mailParams = @{
    From       = $username
    To         = $recipient
    Subject    = "Windows Update | $computerName"
    Body       = @"
Finaler Status Zeit:
$currentTime
Aktueller Batterie-Status:
$currentPercentage % | $currentCapacity mWh/ $fullChargedCapacity mWh
---------------------------
$updateResults
---------------------------
$results
---------------------------
"@
    SmtpServer = "smtp.web.de"
    Port       = 587
    Credential = $credential
    UseSsl     = $true
}
Send-MailMessage @mailParams;
Restart-Computer -Force;
shutdown.exe /r /t 0 /f;