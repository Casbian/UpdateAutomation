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
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 1
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 2
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 3
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 4
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 5
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 6
LogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 7

$ThreadPool = ThreadPool

$SystemWindowsWindow, $SystemWindowsControlsCanvas, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2 = System

RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM $CurrentVersion         | StartUp" -Clear -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
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