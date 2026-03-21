try {
   winget upgrade --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements --scope machine
}
catch {}
if ($PSVersionTable.PSVersion.Major -lt 7) {
    if (!(Get-Command pwsh -ErrorAction SilentlyContinue)) {
        winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements --scope machine
    }
    $script = $PSCommandPath
    Start-Process pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$script`""
    exit
}
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}
#======================================#
# Add Types
#======================================#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
#======================================#
# UI ROOT StartUp
#======================================#
$RootStartup = New-Object System.Windows.Window
$RootStartup.WindowStyle = "None"
$RootStartup.AllowsTransparency = $true
$RootStartup.Background = "Transparent"
$RootStartup.ResizeMode = "NoResize"
$RootStartup.Topmost = $true
$logo = New-Object System.Windows.Controls.Image
$logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "logo.png")))
$logo.Width = 613
$logo.Height = 544
$RootStartup.Content = $logo
$RootStartup.Width = 613
$RootStartup.Height = 544
$screen = [System.Windows.SystemParameters]
$RootStartup.Left = ($screen::PrimaryScreenWidth - 613) / 2
$RootStartup.Top = ($screen::PrimaryScreenHeight * 0.40) - (544 / 2)
$RootStartup.Show()
#======================================#
# UI ROOT
#======================================#
$Root = New-Object Windows.Forms.Form
$Root.Text = "WPCUA Settings"
$Root.StartPosition = "CenterScreen"
$Root.FormBorderStyle = 'FixedDialog'
$Root.MaximizeBox = $false
$Root.Width = 1510
$Root.Height = 740
$Root.Font = New-Object System.Drawing.Font("Consolas",10)
$Root.Icon = New-Object System.Drawing.Icon(Join-Path $PSScriptRoot "Icon.ico")
#======================================#
# UI
#======================================#
$TextBoxWingetWU = New-Object Windows.Forms.RichTextBox
$TextBoxWingetWU.Location = New-Object Drawing.Point(630,20)
$TextBoxWingetWU.Size = New-Object Drawing.Size(850,200)
$TextBoxWingetWU.ReadOnly = $true
$TextBoxWingetWU.Multiline = $true
$TextBoxWingetWU.ScrollBars = 'Vertical'
$TextBoxWingetWU.Font = New-Object Drawing.Font("Consolas",10)
$TextBoxWingetWU.BackColor = [Drawing.Color]::Black
$TextBoxWingetWU.ForeColor = [Drawing.Color]::White
$Root.Controls.Add($TextBoxWingetWU)

$TextBoxWU = New-Object Windows.Forms.RichTextBox
$TextBoxWU.Location = New-Object Drawing.Point(20,20)
$TextBoxWU.Size = New-Object Drawing.Size(600,200)
$TextBoxWU.ReadOnly = $true
$TextBoxWU.Multiline = $true
$TextBoxWU.ScrollBars = 'Vertical'
$TextBoxWU.Font = New-Object Drawing.Font("Consolas",10)
$TextBoxWU.BackColor = [Drawing.Color]::Black
$TextBoxWU.ForeColor = [Drawing.Color]::White
$Root.Controls.Add($TextBoxWU)

$SingleRunWingetWU = New-Object Windows.Forms.Button
$SingleRunWingetWU.Text = "Apps`r`nSingle Run"
$SingleRunWingetWU.Size = New-Object Drawing.Size(100,45)
$SingleRunWingetWU.Location = New-Object Drawing.Point(640,215)
$Root.Controls.Add($SingleRunWingetWU)

$SingleRunWU = New-Object Windows.Forms.Button
$SingleRunWU.Text = "WindowsUpdate`r`nSingle Run"
$SingleRunWU.Size = New-Object Drawing.Size(120,45)
$SingleRunWU.Location = New-Object Drawing.Point(30,215)
$Root.Controls.Add($SingleRunWU)

$LabelSplit = New-Object Windows.Forms.Label
$LabelSplit.Text = "________________________________________________________________________________________________________________________"
$LabelSplit.Font = New-Object System.Drawing.Font("Consolas",16)
$LabelSplit.Location = New-Object Drawing.Point(20,260)
$LabelSplit.AutoSize = $true
$LabelSplit.Enabled = $false
$Root.Controls.Add($LabelSplit)

$ConsoleBox = New-Object Windows.Forms.RichTextBox
$ConsoleBox.Location = New-Object Drawing.Point(20,300)
$ConsoleBox.Size = New-Object Drawing.Size(600,350)
$ConsoleBox.ReadOnly = $true
$ConsoleBox.Multiline = $true
$ConsoleBox.ScrollBars = 'Vertical'
$ConsoleBox.Font = New-Object Drawing.Font("Consolas",10)
$ConsoleBox.BackColor = [Drawing.Color]::Black
$Root.Controls.Add($ConsoleBox)



$LabelAutomationCheck = New-Object Windows.Forms.Label
$LabelAutomationCheck.Text = "Automation OFF"
$LabelAutomationCheck.Font = New-Object System.Drawing.Font("Consolas",16)
$LabelAutomationCheck.Location = New-Object Drawing.Point(650,320)
$LabelAutomationCheck.AutoSize = $true
$LabelAutomationCheck.Enabled = $false
$Root.Controls.Add($LabelAutomationCheck)


$AutomationFileCheck = "C:\TWUAutomation\Automation.ps1"
if (!(Test-Path $AutomationFileCheck)) {
   $AutomationSwitch = New-Object Windows.Forms.Button
   $AutomationSwitch.Text = "Activate`r`nAutomation"
   $AutomationSwitch.Size = New-Object Drawing.Size(120,50)
   $AutomationSwitch.Location = New-Object Drawing.Point(850,310)
   $Root.Controls.Add($AutomationSwitch)
}
else {
   $AutomationSwitch = New-Object Windows.Forms.Button
   $AutomationSwitch.Text = "Deactivate`r`nAutomation"
   $AutomationSwitch.Size = New-Object Drawing.Size(120,50)
   $AutomationSwitch.Location = New-Object Drawing.Point(850,310)
   $Root.Controls.Add($AutomationSwitch)
}

$CheckBoxDomain = New-Object Windows.Forms.CheckBox
$CheckBoxDomain.Text = "Domain - Administrator Account"
$CheckBoxDomain.Location = New-Object Drawing.Point(650,380)
$CheckBoxDomain.AutoSize = $true
$Root.Controls.Add($CheckBoxDomain)

$LabelUsernameDomain = New-Object Windows.Forms.Label
$LabelUsernameDomain.Text = "Username:"
$LabelUsernameDomain.Location = New-Object Drawing.Point(666,410)
$LabelUsernameDomain.AutoSize = $true
$LabelUsernameDomain.Enabled = $false
$Root.Controls.Add($LabelUsernameDomain)

$TextBoxUsernameDomain = New-Object Windows.Forms.TextBox
$TextBoxUsernameDomain.Width = 250
$TextBoxUsernameDomain.Location = New-Object Drawing.Point(746,407)
$TextBoxUsernameDomain.Enabled = $false
$Root.Controls.Add($TextBoxUsernameDomain)

$LabelPasswordDomain = New-Object Windows.Forms.Label
$LabelPasswordDomain.Text = "Password:"
$LabelPasswordDomain.Location = New-Object Drawing.Point(666,440)
$LabelPasswordDomain.AutoSize = $true
$LabelPasswordDomain.Enabled = $false
$Root.Controls.Add($LabelPasswordDomain)

$TextBoxPasswordDomain = New-Object Windows.Forms.TextBox
$TextBoxPasswordDomain.Width = 250
$TextBoxPasswordDomain.Location = New-Object Drawing.Point(746,437)
$TextBoxPasswordDomain.PasswordChar = '*'
$TextBoxPasswordDomain.Enabled = $false
$Root.Controls.Add($TextBoxPasswordDomain)

$CheckBoxLocal = New-Object Windows.Forms.CheckBox
$CheckBoxLocal.Text = "Local - Administrator Account"
$CheckBoxLocal.Location = New-Object Drawing.Point(650,470)
$CheckBoxLocal.AutoSize = $true
$Root.Controls.Add($CheckBoxLocal)

$LabelUsernameLocal = New-Object Windows.Forms.Label
$LabelUsernameLocal.Text = "Username:"
$LabelUsernameLocal.Location = New-Object Drawing.Point(666,500)
$LabelUsernameLocal.AutoSize = $true
$LabelUsernameLocal.Enabled = $false
$Root.Controls.Add($LabelUsernameLocal)

$TextBoxUsernameLocal = New-Object Windows.Forms.TextBox
$TextBoxUsernameLocal.Width = 250
$TextBoxUsernameLocal.Location = New-Object Drawing.Point(746,497)
$TextBoxUsernameLocal.Enabled = $false
$Root.Controls.Add($TextBoxUsernameLocal)

$LabelPasswordLocal = New-Object Windows.Forms.Label
$LabelPasswordLocal.Text = "Password:"
$LabelPasswordLocal.Location = New-Object Drawing.Point(666,530)
$LabelPasswordLocal.AutoSize = $true
$LabelPasswordLocal.Enabled = $false
$Root.Controls.Add($LabelPasswordLocal)

$TextBoxPasswordLocal = New-Object Windows.Forms.TextBox
$TextBoxPasswordLocal.Width = 250
$TextBoxPasswordLocal.Location = New-Object Drawing.Point(746,527)
$TextBoxPasswordLocal.PasswordChar = '*'
$TextBoxPasswordLocal.Enabled = $false
$Root.Controls.Add($TextBoxPasswordLocal)

$LabelLogEmail = New-Object Windows.Forms.Label
$LabelLogEmail.Text = "Log Email Address:"
$LabelLogEmail.Location = New-Object Drawing.Point(1020,380)
$LabelLogEmail.AutoSize = $true
$Root.Controls.Add($LabelLogEmail)
$TextBoxLogEmail = New-Object Windows.Forms.TextBox
$TextBoxLogEmail.Text = "None"
$TextBoxLogEmail.Width = 250
$TextBoxLogEmail.Location = New-Object Drawing.Point(1020,407)
$Root.Controls.Add($TextBoxLogEmail)

$LabelNetworkControl = New-Object Windows.Forms.Label
$LabelNetworkControl.Text = "Programm Controls Network:"
$LabelNetworkControl.Location = New-Object Drawing.Point(1020,445)
$LabelNetworkControl.AutoSize = $true
$Root.Controls.Add($LabelNetworkControl)
$RadioButtonNetworkControlTrue = New-Object Windows.Forms.RadioButton
$RadioButtonNetworkControlTrue.Text = "Yes"
$RadioButtonNetworkControlTrue.Location = New-Object Drawing.Point(1030,465)
$RadioButtonNetworkControlTrue.AutoSize = $true
$Root.Controls.Add($RadioButtonNetworkControlTrue)
$RadioButtonNetworkControlFalse = New-Object Windows.Forms.RadioButton
$RadioButtonNetworkControlFalse.Text = "No"
$RadioButtonNetworkControlFalse.Location = New-Object Drawing.Point(1090,465)
$RadioButtonNetworkControlFalse.AutoSize = $true
$RadioButtonNetworkControlFalse.Checked = $true
$Root.Controls.Add($RadioButtonNetworkControlFalse)



$SubmitButton = New-Object Windows.Forms.Button
$SubmitButton.Text = "Save Settings"
$SubmitButton.Width = 120
$SubmitButton.Location = New-Object Drawing.Point(1230,660)
$Root.Controls.Add($SubmitButton)

$CancelButton = New-Object Windows.Forms.Button
$CancelButton.Text = "Cancel"
$CancelButton.Width = 120
$CancelButton.Location = New-Object Drawing.Point(1360,660)
$Root.Controls.Add($CancelButton)
#======================================#
# Functions
#======================================#
function Write-UiSystem([string]$msg) {
   $ConsoleBox.SelectionStart = $ConsoleBox.TextLength
   $ConsoleBox.SelectionLength = 0
   $ConsoleBox.SelectionColor = [Drawing.Color]::Cyan
   $ConsoleBox.AppendText("$msg`r`n")
   $ConsoleBox.ScrollToCaret()
}
function Write-UiLog([string]$msg) {
   $ConsoleBox.SelectionStart = $ConsoleBox.TextLength
   $ConsoleBox.SelectionLength = 0
   $ConsoleBox.SelectionColor = [Drawing.Color]::LightGreen
   $ConsoleBox.AppendText("$msg`r`n")
   $ConsoleBox.ScrollToCaret()
}
function Write-UiLogError([string]$msg) {
   $ConsoleBox.SelectionStart = $ConsoleBox.TextLength
   $ConsoleBox.SelectionLength = 0
   $ConsoleBox.SelectionColor = [Drawing.Color]::Red
   $ConsoleBox.AppendText("$msg`r`n")
   $ConsoleBox.ScrollToCaret()
}




















$SingleRunWingetWU.Add_Click({
   Start-Transcript -Path $transcriptPath -Force;
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
   Write-UiLog $results
   $results
})















$AutomationSwitch.Add_Click({
   $SettingsFile = Join-Path $PSScriptRoot "settings"
   if (!(Test-Path $SettingsFile)) {
      [System.Windows.Forms.MessageBox]::Show("Settings - None`nPath - $SettingsFile`nSystem will create a new Settings File","Information","OK","Information")
      $default = @"
Network =
Email =
Type =
User =
PassEncrypted =
"@
      New-Item -Path $SettingsFile -ItemType File -Force | Out-Null
      Set-Content -Path $SettingsFile -Value $default -Encoding UTF8
}
else {
   $SettingsValues = Get-Content -Path $SettingsFile | ForEach-Object {(($_ -split '=', 2)[1]).Trim()}
   if ($SettingsValues -and ($SettingsValues | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
      Write-UiLog "Settings loaded successfully."
}
else {
   Write-UiLogError "No valid setting values found in $SettingsFile."
}
}
})


$CheckBoxDomain.Add_CheckedChanged({
 if ($CheckBoxDomain.Checked) { 
  $CheckBoxLocal.Checked = $false
  $LabelUsernameLocal.Enabled = $false
  $TextBoxUsernameLocal.Enabled = $false
  $LabelPasswordLocal.Enabled = $false
  $TextBoxPasswordLocal.Enabled = $false
 }
 $Enabled = $CheckBoxDomain.Checked
 $LabelUsernameDomain.Enabled = $Enabled
 $TextBoxUsernameDomain.Enabled = $Enabled
 $LabelPasswordDomain.Enabled = $Enabled
 $TextBoxPasswordDomain.Enabled = $Enabled
})
$CheckBoxLocal.Add_CheckedChanged({
 if ($CheckBoxLocal.Checked) { 
  $CheckBoxDomain.Checked = $false
  $LabelUsernameDomain.Enabled = $false
  $TextBoxUsernameDomain.Enabled = $false
  $LabelPasswordDomain.Enabled = $false
  $TextBoxPasswordDomain.Enabled = $false
 }
 $Enabled = $CheckBoxLocal.Checked
 $LabelUsernameLocal.Enabled = $Enabled
 $TextBoxUsernameLocal.Enabled = $Enabled
 $LabelPasswordLocal.Enabled = $Enabled
 $TextBoxPasswordLocal.Enabled = $Enabled
})







$SubmitButton.Add_Click({
   $Network = $RadioButtonNetworkControlTrue.Checked
   $Email = $TextBoxLogEmail.Text
   if ($CheckBoxDomain.Checked -and $TextBoxUsernameDomain.Text -ne "" -and $TextBoxPasswordDomain.Text -ne "") {
      $Type = "Domain"
      $User = $TextBoxUsernameDomain.Text
      $Pass = $TextBoxPasswordDomain.Text
   } elseif ($CheckBoxLocal.Checked -and $TextBoxUsernameLocal.Text -ne "" -and $TextBoxPasswordLocal.Text -ne "") {
      $Type = "Local"
      $User = $TextBoxUsernameLocal.Text
      $Pass = $TextBoxPasswordLocal.Text
   } else {
      [System.Windows.Forms.MessageBox]::Show("Credentials needed","Error","OK","Error")
      return
   }
   $SecurePass = ConvertTo-SecureString $Pass -AsPlainText -Force
   $PassEncrypted = $SecurePass | ConvertFrom-SecureString
   $SettingsContent = @"
[Settings]
Network = $Network
Email = $Email
Type = $Type
User = $User
PassEncrypted = $PassEncrypted
"@
   Set-Content -Path $SettingsFile -Value $SettingsContent -Force
   [System.Windows.Forms.MessageBox]::Show("Submit complete.`nSettings saved.","Success")
   $Root.Close()
})
$CancelButton.Add_Click({
   $Root.Close()
})
#======================================#
# StartUp Tasks
#======================================#
$RootStartup.Close()
$Root.Show()
try {
   Import-Module PSWindowsUpdate;
   Write-UiLog "> Dependencies installed and imported ..."
   $Root.Refresh()
}
catch {
   Write-UiLogError "> Dependencies ERROR !!!"
   $Root.Refresh()
}

$SettingsFile = Join-Path $PSScriptRoot "settings"
if (!(Test-Path $SettingsFile)) {
   Write-UiLogError "> Settings File corrupted or not found !!!"
   Write-UiLogError "> $SettingsFile"
   $default = @"
Network =
Email =
Type =
User =
PassEncrypted =
"@
   New-Item -Path $SettingsFile -ItemType File -Force | Out-Null
   Set-Content -Path $SettingsFile -Value $default -Encoding UTF8
   Write-UiLog "> new Settings File created ..."
   $Root.Refresh()
} else {
   Write-UiLog "> Settings File loaded ..."
   $Root.Refresh()
}
$Autologon = Join-Path $PSScriptRoot "AutoLogon.exe"
if (!(Test-Path $Autologon)) {
   Write-UiLogError "> AutoLogon.exe corrupted or not found !!!"
   Write-UiLogError "> $Autologon"
   Write-UiLogError "> Download - https://learn.microsoft.com/en-us/sysinternals/downloads/autologon"
   $Root.Refresh()
   return
} else {
   Write-UiLog "> Autologon loaded ..."
   $Root.Refresh()
}
try {
   $tempPath = $env:TEMP;
   $services = @('wuauserv', 'bits', 'cryptsvc')
   foreach ($serviceName in $services) {
      $serviceRunning = $false;
      while ($serviceRunning -eq $false) {
         $service = Get-Service -Name $serviceName;
         if ($null -eq $service) {
               break;
         }
         if ($service.Status -ne 'Running') {
               Start-Service $serviceName;
         } else {
               $serviceRunning = $true;
               break;
         }
      }
   }
   $transcriptPath = Join-Path $tempPath 'WindowsUpdateTranscript.txt';
   $updateCommand = "while (`$true) {`$tempPath = `$env:TEMP; `$transcriptPath = Join-Path `$tempPath 'WindowsUpdateTranscript.txt'; Start-Transcript -Path `$transcriptPath -Force; Get-WindowsUpdate -Verbose; if (`$?) {Stop-Transcript;break;}else {Stop-Transcript;}}";
   Start-Process powershell.exe -ArgumentList "-NoProfile -Command $updateCommand" -Wait -NoNewWindow;
   $allLines = Get-Content -Path $transcriptPath;
   $verboseLines = $allLines | Where-Object { $_ -like 'AUSF*HRLICH:*' }
   Remove-Item -Path $transcriptPath -Force
   foreach ($line in $verboseLines) {
      $trimmedLine = $line -replace 'Please wait\.\.\.', ''
      $TextBoxWU.AppendText("$trimmedLine`r`n")
      $Root.Refresh()
   }
   Write-UiLog "> Windows Update Loaded..."
}
catch {
   Write-UiLogError "> Windows Update Error"
   $Root.Refresh()
}
try {
   $OutputWingetWU = "Y" | winget list --upgrade-available | Out-String
   $OutputWingetWU = $OutputWingetWU -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
   $apps = @()
   $lines = "Y" | winget list --upgrade-available
   $lines = $lines -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…'
   foreach($line in $lines){
      if($line -match '^(.+?)\s+([A-Za-z][\w.-]+\.[A-Za-z][\w.-]+)\s+[\d]'){
         $apps += @{
               name = $matches[1].Trim()
               id   = $matches[2].Trim()
         }
      }
   }
   $lines = $OutputWingetWU -split "`n"
   $OutputWingetWU = $OutputWingetWU.TrimStart()
   $OutputWingetWU = $OutputWingetWU.TrimEnd()
   $OutputWingetWU = $OutputWingetWU -split "(`r`n|`n|`r)"
   $OutputStart = $false
   $OutputWingetWUFinal = ""
   foreach ($line in $OutputWingetWU) {
      if (-not $OutputStart -and $line -like 'Name*') { $OutputStart = $true }
      if ($OutputStart) { $OutputWingetWUFinal += $line}
   }
   $OutputWingetWUFinal = $OutputWingetWUFinal.TrimStart()
   $OutputWingetWUFinal = $OutputWingetWUFinal.TrimEnd()
   $TextBoxWingetWU.Text = $OutputWingetWUFinal
   Write-UiLog "> WinGet Apps loaded"
}catch {
   $TextBoxWingetWU.Text = "WinGet Error"
   Write-UiLogError "> WinGet Error"

}
Write-UiSystem "************************************************************************************"
Write-UiSystem "                                 WELCOME to WPCUA                                   "
Write-UiSystem "                                    by Casbian                                      "
Write-UiSystem "************************************************************************************"
$Root.Hide()
$Root.ShowDialog()