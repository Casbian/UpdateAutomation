if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}
#======================================#
# Add-Types
#======================================#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#======================================#
# File Checks
#======================================#
$Autologon = Join-Path $PSScriptRoot "AutoLogon.exe"
if (!(Test-Path $Autologon)) {
   [System.Windows.Forms.MessageBox]::Show("AutoLogon.exe - None`nPath - $Autologon`nDownload - https://learn.microsoft.com/en-us/sysinternals/downloads/autologon","Error","OK","Error")
   return
}
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
#======================================#
# ROOT
#======================================#
$Root = New-Object Windows.Forms.Form
$Root.Text = "TWUAutomation Settings"
$Root.StartPosition = "CenterScreen"
$Root.FormBorderStyle = 'FixedDialog'
$Root.MaximizeBox = $false
$Root.Width = 1840
$Root.Height = 800
$Root.Font = New-Object System.Drawing.Font("Consolas",10)
$Root.Icon = New-Object System.Drawing.Icon(Join-Path $PSScriptRoot "Icon.ico")
#======================================#
# Console
#======================================#
$ConsoleBox = New-Object Windows.Forms.RichTextBox
$ConsoleBox.Location = New-Object Drawing.Point(400,30)
$ConsoleBox.Size = New-Object Drawing.Size(475,350)
$ConsoleBox.ReadOnly = $true
$ConsoleBox.Multiline = $true
$ConsoleBox.ScrollBars = 'Vertical'
$ConsoleBox.Font = New-Object Drawing.Font("Consolas",10)
$ConsoleBox.BackColor = [Drawing.Color]::Black
$Root.Controls.Add($ConsoleBox)
function Write-UiLog([string]$msg) {
   $ConsoleBox.ForeColor = [Drawing.Color]::LightGreen
   $ConsoleBox.AppendText("$msg`r`n")
   $ConsoleBox.SelectionStart = $ConsoleBox.TextLength
   $ConsoleBox.ScrollToCaret()
}
function Write-UiLogError([string]$msg) {
   $ConsoleBox.ForeColor = [Drawing.Color]::Red
   $ConsoleBox.AppendText("$msg`r`n")
   $ConsoleBox.SelectionStart = $ConsoleBox.TextLength
   $ConsoleBox.ScrollToCaret()
}
#======================================#
# Automation Check
#======================================#
$LabelAutomationCheck = New-Object Windows.Forms.Label
$LabelAutomationCheck.Text = "Automation OFF"
$LabelAutomationCheck.Font = New-Object System.Drawing.Font("Consolas",16)
$LabelAutomationCheck.Location = New-Object Drawing.Point(20,30)
$LabelAutomationCheck.AutoSize = $true
$LabelAutomationCheck.Enabled = $false
$Root.Controls.Add($LabelAutomationCheck)

$AutomationFileCheck = "C:\TWUAutomation\Automation.ps1"
if (!(Test-Path $AutomationFileCheck)) {
   $AutomationSwitch = New-Object Windows.Forms.Button
   $AutomationSwitch.Text = "Activate`r`nAutomation"
   $AutomationSwitch.Size = New-Object Drawing.Size(120,50)
   $AutomationSwitch.Location = New-Object Drawing.Point(250,20)
   $Root.Controls.Add($AutomationSwitch)
}
else {
   $AutomationSwitch = New-Object Windows.Forms.Button
   $AutomationSwitch.Text = "Deactivate`r`nAutomation"
   $AutomationSwitch.Size = New-Object Drawing.Size(120,50)
   $AutomationSwitch.Location = New-Object Drawing.Point(250,20)
   $Root.Controls.Add($AutomationSwitch)
}
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


#======================================#
# Device Account
#======================================#
$CheckBoxDomain = New-Object Windows.Forms.CheckBox
$CheckBoxDomain.Text = "Administrator Account - Domain"
$CheckBoxDomain.Location = New-Object Drawing.Point(20,80)
$CheckBoxDomain.AutoSize = $true
$Root.Controls.Add($CheckBoxDomain)
$LabelUsernameDomain = New-Object Windows.Forms.Label
$LabelUsernameDomain.Text = "Username:"
$LabelUsernameDomain.Location = New-Object Drawing.Point(20,110)
$LabelUsernameDomain.AutoSize = $true
$LabelUsernameDomain.Enabled = $false
$Root.Controls.Add($LabelUsernameDomain)
$TextBoxUsernameDomain = New-Object Windows.Forms.TextBox
$TextBoxUsernameDomain.Width = 250
$TextBoxUsernameDomain.Location = New-Object Drawing.Point(90,110)
$TextBoxUsernameDomain.Enabled = $false
$Root.Controls.Add($TextBoxUsernameDomain)
$LabelPasswordDomain = New-Object Windows.Forms.Label
$LabelPasswordDomain.Text = "Password:"
$LabelPasswordDomain.Location = New-Object Drawing.Point(20,140)
$LabelPasswordDomain.AutoSize = $true
$LabelPasswordDomain.Enabled = $false
$Root.Controls.Add($LabelPasswordDomain)
$TextBoxPasswordDomain = New-Object Windows.Forms.TextBox
$TextBoxPasswordDomain.Width = 250
$TextBoxPasswordDomain.Location = New-Object Drawing.Point(90,140)
$TextBoxPasswordDomain.PasswordChar = '*'
$TextBoxPasswordDomain.Enabled = $false
$Root.Controls.Add($TextBoxPasswordDomain)
$CheckBoxLocal = New-Object Windows.Forms.CheckBox
$CheckBoxLocal.Text = "Administrator Account - Local"
$CheckBoxLocal.Location = New-Object Drawing.Point(20,180)
$CheckBoxLocal.AutoSize = $true
$Root.Controls.Add($CheckBoxLocal)
$LabelUsernameLocal = New-Object Windows.Forms.Label
$LabelUsernameLocal.Text = "Username:"
$LabelUsernameLocal.Location = New-Object Drawing.Point(20,210)
$LabelUsernameLocal.AutoSize = $true
$LabelUsernameLocal.Enabled = $false
$Root.Controls.Add($LabelUsernameLocal)
$TextBoxUsernameLocal = New-Object Windows.Forms.TextBox
$TextBoxUsernameLocal.Width = 250
$TextBoxUsernameLocal.Location = New-Object Drawing.Point(90,210)
$TextBoxUsernameLocal.Enabled = $false
$Root.Controls.Add($TextBoxUsernameLocal)
$LabelPasswordLocal = New-Object Windows.Forms.Label
$LabelPasswordLocal.Text = "Password:"
$LabelPasswordLocal.Location = New-Object Drawing.Point(20,240)
$LabelPasswordLocal.AutoSize = $true
$LabelPasswordLocal.Enabled = $false
$Root.Controls.Add($LabelPasswordLocal)
$TextBoxPasswordLocal = New-Object Windows.Forms.TextBox
$TextBoxPasswordLocal.Width = 250
$TextBoxPasswordLocal.Location = New-Object Drawing.Point(90,240)
$TextBoxPasswordLocal.PasswordChar = '*'
$TextBoxPasswordLocal.Enabled = $false
$Root.Controls.Add($TextBoxPasswordLocal)
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
#======================================#
# Log Email
#======================================#
$LabelLogEmail = New-Object Windows.Forms.Label
$LabelLogEmail.Text = "Log Email Address:"
$LabelLogEmail.Location = New-Object Drawing.Point(20,330)
$LabelLogEmail.AutoSize = $true
$Root.Controls.Add($LabelLogEmail)
$TextBoxLogEmail = New-Object Windows.Forms.TextBox
$TextBoxLogEmail.Text = "None"
$TextBoxLogEmail.Width = 250
$TextBoxLogEmail.Location = New-Object Drawing.Point(20,355)
$Root.Controls.Add($TextBoxLogEmail)
#======================================#
# Network Control
#======================================#
$LabelNetworkControl = New-Object Windows.Forms.Label
$LabelNetworkControl.Text = "Programm Controls Network:"
$LabelNetworkControl.Location = New-Object Drawing.Point(20,280)
$LabelNetworkControl.AutoSize = $true
$Root.Controls.Add($LabelNetworkControl)
$RadioButtonNetworkControlTrue = New-Object Windows.Forms.RadioButton
$RadioButtonNetworkControlTrue.Text = "Yes"
$RadioButtonNetworkControlTrue.Location = New-Object Drawing.Point(20,300)
$RadioButtonNetworkControlTrue.AutoSize = $true
$Root.Controls.Add($RadioButtonNetworkControlTrue)
$RadioButtonNetworkControlFalse = New-Object Windows.Forms.RadioButton
$RadioButtonNetworkControlFalse.Text = "No"
$RadioButtonNetworkControlFalse.Location = New-Object Drawing.Point(80,300)
$RadioButtonNetworkControlFalse.AutoSize = $true
$RadioButtonNetworkControlFalse.Checked = $true
$Root.Controls.Add($RadioButtonNetworkControlFalse)
#======================================#
# Winget WU
#======================================#
$TextBoxWingetWU = New-Object Windows.Forms.TextBox
$TextBoxWingetWU.Multiline = $true
$TextBoxWingetWU.WordWrap = $false
$TextBoxWingetWU.ScrollBars = 'Vertical'
$TextBoxWingetWU.ReadOnly = $true
$TextBoxWingetWU.Width = 870
$TextBoxWingetWU.Height = 210
$TextBoxWingetWU.Location = New-Object Drawing.Point(20,400)
$TextBoxWingetWU.Font = New-Object System.Drawing.Font("Consolas",10)
$Root.Controls.Add($TextBoxWingetWU)
try {
   $OutputWingetWU = "Y" | winget list --upgrade-available | Out-String
   $OutputWingetWU = $OutputWingetWU -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇª','…'
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
}catch {
   $TextBoxWingetWU.Text = "WinGet - Error"
}
$SingleRunWingetWU = New-Object Windows.Forms.Button
$SingleRunWingetWU.Text = "Apps`r`nSingle Run"
$SingleRunWingetWU.Size = New-Object Drawing.Size(100,45)
$SingleRunWingetWU.Location = New-Object Drawing.Point(790,610)
$Root.Controls.Add($SingleRunWingetWU)
$SingleRunWingetWU.Add_Click({
   $SingleRunWingetWUDump = winget upgrade --all --include-unknown --silent --accept-package-agreements --accept-source-agreements --scope machine
   Write-UiLog $SingleRunWingetWUDump
})




#======================================#
# Main Buttons
#======================================#




$SubmitButton = New-Object Windows.Forms.Button
$SubmitButton.Text = "Save Settings"
$SubmitButton.Width = 120
$SubmitButton.Location = New-Object Drawing.Point(620,700)
$Root.Controls.Add($SubmitButton)

$CancelButton = New-Object Windows.Forms.Button
$CancelButton.Text = "Cancel"
$CancelButton.Width = 120
$CancelButton.Location = New-Object Drawing.Point(750,700)
$Root.Controls.Add($CancelButton)

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

$CancelButton.Add_Click({$Root.Close()})











$tempPath = $env:TEMP;
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
$updateCommand = "while (`$true) {`$tempPath = `$env:TEMP; `$transcriptPath = Join-Path `$tempPath 'WindowsUpdateTranscript.txt'; Start-Transcript -Path `$transcriptPath -Force; Get-WindowsUpdate -Verbose; if (`$?) {Stop-Transcript;break;}else {Stop-Transcript;}}";
Start-Process powershell.exe -ArgumentList "-NoProfile -Command $updateCommand" -Wait -NoNewWindow;
$allLines = Get-Content -Path $transcriptPath;
$verboseLines = $allLines | Where-Object { $_ -like 'AUSF*HRLICH:*' };
$updateResults = $verboseLines -join "`n";
Remove-Item -Path $transcriptPath -Force -ErrorAction SilentlyContinue;
Write-Host $updateResults


























$Root.ShowDialog()