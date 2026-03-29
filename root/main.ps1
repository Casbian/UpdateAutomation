#======================================#
# CHECK Administrator
#======================================#
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
   try {
      Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden
      exit
   } catch {
      if ($_.Exception.Message -match 'cancel') {
            exit
      }
      Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden
      exit
   }
   exit
}
#======================================#
# CHECK Powershell 7
#======================================#
if ($PSVersionTable.PSVersion.Major -lt 7) {
   winget install --id Microsoft.PowerShell --uninstall-previous --accept-package-agreements --accept-source-agreements --silent --force
   Start-Process pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
   exit
}
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

$Network = Network
if (-not $Network) {
   $NetworkCancel = [System.Windows.MessageBox]::Show(
   "No Network could be found",
   "No Network",
   "OK",
   "Error"
   )
   if ($NetworkCancel -eq "OK") {
      exit
   }
}
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 2


LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 3
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 4
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 5
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 6
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 7



$SystemWindowsWindow, $SystemWindowsControlsCanvas, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2 = System




RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM $CurrentVersion" -Clear | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM Base Environment" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
$EnvironmentKVariables = @('COMPUTERNAME','USERNAME','USERDOMAIN','USERDNSDOMAIN','OS','PROCESSOR_ARCHITECTURE','PROCESSOR_IDENTIFIER','NUMBER_OF_PROCESSORS','LOGONSERVER')
foreach ($Variable in $EnvironmentKVariables) {
   $VariableValue = [System.Environment]::GetEnvironmentVariable($Variable)
   if ($VariableValue) { 
      RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1}" -f $Variable, $VariableValue) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
      Window | Out-Null
   }
}
$UserID   = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$UserPrincipal = New-Object System.Security.Principal.WindowsPrincipal($UserID)
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "IDENTITY", $UserID.Name) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "ADMIN IN SESSION", $UserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM Detailed Environment" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
$OperatingSystem = Get-CimInstance Win32_OperatingSystem
RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1}" -f "OS", $OperatingSystem.Caption) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "ARCHITECTURE", $OperatingSystem.OSArchitecture) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "UPTIME", ((Get-Date) - $OperatingSystem.LastBootUpTime).ToString("d'd 'h'h 'm'm'")) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "PRODUCTTYPE", @{1='Workstation';2='Domain Controller';3='Server'}[[int]$OperatingSystem.ProductType]) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
Window | Out-Null
Get-CimInstance Win32_Processor | ForEach-Object {
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1}" -f "CPU", $_.Name.Trim()) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "CORES", $_.NumberOfCores) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "LOGICAL CORES", $_.NumberOfLogicalProcessors) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "ARCHITECTURE", @{0='x86';1='MIPS';2='Alpha';3='PowerPC';5='ARM';6='ia64';9='x64'}[[int]$_.Architecture]) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   Window | Out-Null
}
Get-CimInstance Win32_VideoController | ForEach-Object {
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1}" -f "GPU", $_.Name) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "DRIVER", $_.DriverVersion) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   Window | Out-Null
}

# check GPU DRIVER HERE 


$RAMTotalCapacity  = [math]::Round($OperatingSystem.TotalVisibleMemorySize / 1MB, 2)
RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1} GB" -f "RAM GB", $RAMTotalCapacity) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
Window | Out-Null
Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
   $RAMPhysicalTotalCapacity = [math]::Round($_.Capacity / 1GB, 1)
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1} GB {2} MHz" -f $_.DeviceLocator, $RAMPhysicalTotalCapacity, $_.Speed) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   Window | Out-Null
}
Get-CimInstance Win32_DiskDrive | ForEach-Object {
   $DiskTotalCapacity = [math]::Round($_.Size / 1GB, 1)
   RichTextBox $SystemWindowsControlsRichTextBox0 ("> {0,-30} : {1} GB" -f $_.Model, $DiskTotalCapacity) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "SERIAL", $_.SerialNumber.Trim()) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1}" -f "PARTITIONS", $_.Partitions) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   Window | Out-Null
}
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
   $DiskTotalCapacityUsed = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
   RichTextBox $SystemWindowsControlsRichTextBox0 (">> {0,-30}: {1} GB / {2} GB" -f $_.Name, $DiskTotalCapacityUsed, [math]::Round($_.Used / 1GB, 2)) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
   Window | Out-Null
}

# Fix LAter

#$regPaths = @(
#    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
#    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
#    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
#)


#Get-ItemProperty $regPaths -ErrorAction SilentlyContinue | 
#    Where-Object { $_.DisplayName -and ($_.SystemComponent -ne 1) } | 
 #   Select-Object @{Name="Software Name"; Expression={$_.DisplayName.Trim()}}, 
#                  @{Name="Version"; Expression={$_.DisplayVersion}} | 
#    Sort-Object "Software Name" -Unique | 
 #   Format-Table -AutoSize | Out-String | Write-Host




#Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
#   RichTextBox $SystemWindowsControlsRichTextBox0 ("> Network Adapter [{0}] {1}" -f $_.Index, $_.Description) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
#   RichTextBox $SystemWindowsControlsRichTextBox0 (">> MAC " + $_.MACAddress) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
#   RichTextBox $SystemWindowsControlsRichTextBox0 (">> IP  " + ($_.IPAddress -join ', ')) -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
#   Window | Out-Null
#}
#RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM Network using $Network ✓" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null


RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "‎  MODULE               | TASK           | RESULT" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null

try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:FileCheckSettings} -Parameter $PSScriptRoot -TaskName "SettingsFile"
   if ($Result -eq 1) {
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ✗" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM could not find SettingsFile at $Result" -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM created a new EMPTY SettingsFile" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   } 
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}

RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:FileCheckAutologon} -Parameter $PSScriptRoot -TaskName "AutologonExe"
   if ($Result -eq 1) {
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox0 "" -RemoveLast | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ✗" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM could not find AutologonExe at $Result" -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM Download at - https://learn.microsoft.com/en-us/sysinternals/downloads/autologon" -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
      Window | Out-Null
   }
} catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}
  
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWindowsUpdate} -TaskName "PreScan"
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
   RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | PreScan        | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | PreScan        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
   Window | Out-Null
}

RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
Window | Out-Null
try {
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWinget} -TaskName "PreScan"
   $Result2 = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:ListWingetApps} -TaskName "PreScan"
   $AppList = $Result2
   if ($null -eq $AppList -or $AppList.Count -eq 0) {
      RichTextBox $SystemWindowsControlsRichTextBox2 "No Updates for Apps available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } else {
      RichTextBox $SystemWindowsControlsRichTextBox2 $Result -Clear | Out-Null
      Window | Out-Null
   }
   RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | PreScan        | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
}
catch {
   RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | PreScan        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
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

SystemAddUpdateButton $SystemWindowsControlsCanvas $AppList

$SystemWindowsWindow.Hide()
$SystemWindowsWindow.ShowDialog()
#======================================#
# EXIT
#======================================#
$ThreadPool.Close()
$ThreadPool.Dispose()
exit