#======================================#
# IMPORTS
#======================================#
Import-Module "$PSScriptRoot\file\file.psm1"
Import-Module "$PSScriptRoot\main\main.psm1"
Import-Module "$PSScriptRoot\network\network.psm1"
Import-Module "$PSScriptRoot\richtextbox\richtextbox.psm1"
Import-Module "$PSScriptRoot\thread\thread.psm1" 
Import-Module "$PSScriptRoot\update\update.psm1"
Import-Module "$PSScriptRoot\window\window.psm1"
#======================================#
# ADD Types
#======================================#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
#======================================#
# MAIN
#======================================#
$CurrentVersion = Update $MyInvocation

$SystemWindowsWindow, $LoadingBar, $LoadingBarFrames = Logo
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 0

$ThreadPool = ThreadPool
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 1
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 2
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 3
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 4
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 5
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 6
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 7

$SystemWindowsWindow, $SystemWindowsControlsCanvas, $UpdateNowButton, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2 = System

$UpdateNowButton.Active = $true


RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "Task                                    |                                                                                        RESULT" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:Network} -TaskName "SCAN Network"
   if ($Result) {
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> SCAN Network                         | $Result" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   } else {
      $NetworkCancel = [System.Windows.MessageBox]::Show(
      "No Network could be found",
      "No Network",
      "OK",
      "Error"
      )
      if ($NetworkCancel -eq "OK") {
         $SystemWindowsWindow.Close()
         exit
      }
   }
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 ">> SCAN Network                         | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:FileCheckSettings} -Parameter $PSScriptRoot -TaskName "LOAD Settings"
   if ($Result -eq 1) {
      $FilePathSettings = Join-Path $PSScriptRoot "file\files\settings"
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD Settings                        | $FilePathSettings" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD Settings                        | $Result" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 ">>                                        SYSTEM created NEW BUT EMPTY Settings" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   } 
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD Settings                        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:FileCheckAutologon} -Parameter $PSScriptRoot -TaskName "CHECK AddONs"
   if ($Result -eq 1) {
      $FilePathAddOns = Join-Path $PSScriptRoot "file\files\AutoLogon.exe"
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD AddONs                          | $FilePathAddOns" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD AddONs                          | $Result" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 ">>                                        Download Link - https://learn.microsoft.com/en-us/sysinternals/downloads/autologon" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   }
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 ">> LOAD AddONs                    | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
$EnvironmentKVariables = @('COMPUTERNAME','USERNAME','USERDOMAIN','USERDNSDOMAIN','OS','PROCESSOR_ARCHITECTURE','PROCESSOR_IDENTIFIER','NUMBER_OF_PROCESSORS','LOGONSERVER')
foreach ($Variable in $EnvironmentKVariables) {
   $VariableValue = [System.Environment]::GetEnvironmentVariable($Variable)
   if ($VariableValue) { 
      RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1}" -f $Variable, $VariableValue) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   }
}
$UserID   = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$UserPrincipal = New-Object System.Security.Principal.WindowsPrincipal($UserID)
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "IDENTITY", $UserID.Name) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "ADMIN IN SESSION", $UserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
Window | Out-Null
Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} |" -f $_.Description) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "MAC", $_.MACAddress) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "IP", ($_.IPAddress -join ', ')) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
$OperatingSystem = Get-CimInstance Win32_OperatingSystem
RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1}" -f "OS", $OperatingSystem.Caption) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "ARCHITECTURE", $OperatingSystem.OSArchitecture) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "UPTIME", ((Get-Date) - $OperatingSystem.LastBootUpTime).ToString("d'd 'h'h 'm'm'")) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "PRODUCTTYPE", @{1='Workstation';2='Domain Controller';3='Server'}[[int]$OperatingSystem.ProductType]) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
Window | Out-Null
Get-CimInstance Win32_Processor | ForEach-Object {
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1}" -f "CPU", $_.Name.Trim()) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "CORES", $_.NumberOfCores) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "LOGICAL CORES", $_.NumberOfLogicalProcessors) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "ARCHITECTURE", @{0='x86';1='MIPS';2='Alpha';3='PowerPC';5='ARM';6='ia64';9='x64'}[[int]$_.Architecture]) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
Get-CimInstance Win32_VideoController | ForEach-Object {
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1}" -f "GPU", $_.Name) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "DRIVER", $_.DriverVersion) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}

# check GPU DRIVER HERE 

$RAMTotalCapacity  = [math]::Round($OperatingSystem.TotalVisibleMemorySize / 1MB, 2)
RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1} GB" -f "RAM GB", $RAMTotalCapacity) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
Window | Out-Null
Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
   $RAMPhysicalTotalCapacity = [math]::Round($_.Capacity / 1GB, 1)
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1} GB {2} MHz" -f $_.DeviceLocator, $RAMPhysicalTotalCapacity, $_.Speed) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
Get-CimInstance Win32_DiskDrive | ForEach-Object {
   $DiskTotalCapacity = [math]::Round($_.Size / 1GB, 1)
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-37} | {1} GB" -f $_.Model, $DiskTotalCapacity) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "SERIAL", $_.SerialNumber.Trim()) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1}" -f "PARTITIONS", $_.Partitions) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
   $DiskTotalCapacityUsed = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-37}| {1} GB / {2} GB" -f $_.Name, $DiskTotalCapacityUsed, [math]::Round($_.Used / 1GB, 2)) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWindowsUpdate} -TaskName "PreSCAN Windows Update"
   if ($Result -eq 0) {
      RichTextBox $SystemWindowsControlsRichTextBox1 "No Windows Updates available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } elseif ($Result -eq 1) {
      $RebootFlag = $true
      RichTextBox $SystemWindowsControlsRichTextBox1 "No Windows Updates available - Reboot Required" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox1 $Result -Clear | Out-Null
      Window | Out-Null
   }
   RichTextBox $SystemWindowsControlsRichTextBox0 "> PreSCAN Windows Update                | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> PreSCAN Windows Update                | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWinget} -TaskName "PreSCAN Winget"
   $Result2 = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWingetApps} -TaskName "PreSCAN Winget Applist"
   $AppList = $Result2
   if ($null -eq $AppList -or $AppList.Count -eq 0) {
      RichTextBox $SystemWindowsControlsRichTextBox2 "No Updates for Apps available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox2 $Result -Clear | Out-Null
      Window | Out-Null
   }
   RichTextBox $SystemWindowsControlsRichTextBox0 "> PreSCAN Winget                        | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> PreSCAN Winget                        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
if ($RebootFlag -eq $true) {
   $ResultQuestion = [System.Windows.MessageBox]::Show(
   "It was detected that a Reboot is needed`n`nDo you want to reboot now ?",
   "Reboot ?",
   "YesNo",
   "Question"
   )
   if ($ResultQuestion -eq "Yes") {
      Restart-Computer -Force
      exit
   }
}
RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 " ALL Programs" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
Window | Out-Null
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
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}" -f $Line) -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
Start-Sleep -Seconds 2
$UserName = [System.Environment]::GetEnvironmentVariable("USERNAME")
RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "Welcome $UserName" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
Window | Out-Null


$UpdateNowButton.Active = $false


$SystemWindowsWindow.Hide()
$SystemWindowsWindow.ShowDialog()
#======================================#
# EXIT
#======================================#
$ThreadPool.Close()
$ThreadPool.Dispose()
exit