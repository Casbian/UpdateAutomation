param(
   [switch]$EXELaunch
)

Import-Module "$PSScriptRoot\update\update.psm1"
$CurrentVersion = Update $MyInvocation

Import-Module "$PSScriptRoot\flag\flag.psm1"
if ($EXELaunch -eq $false) {
   $FlagValue = ChecklastautomatedrunFlag $PSScriptRoot
   if ($FlagValue -eq 1) {
      exit
   }
}

Import-Module "$PSScriptRoot\main\main.psm1"
Import-Module "$PSScriptRoot\network\network.psm1"
Import-Module "$PSScriptRoot\richtextbox\richtextbox.psm1"
Import-Module "$PSScriptRoot\thread\thread.psm1" 
Import-Module "$PSScriptRoot\window\window.psm1"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore

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

$SystemWindowsWindow, $SystemWindowsControlsCanvas, $AutomationButton, $UpdateNowButton, $InfoButton, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2, $AutomationCheck = System
$AutomationButton.Active = $true
$UpdateNowButton.Active = $true

RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "Task                                    |                                                                                                             RESULT" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBox0 "____________________________________________________________________________________________________________________________________________________________" | Out-Null
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

if ($EXELaunch -eq $true) {
   $UserName = [System.Environment]::GetEnvironmentVariable("USERNAME")
   RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Welcome $UserName" | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "____________________________________________________________________________________________________________________________________________________________" | Out-Null
   Window | Out-Null
   $AutomationButton.Active = $false
   $UpdateNowButton.Active = $false
   $SystemWindowsWindow.Hide()
   $SystemWindowsWindow.ShowDialog()
   $ThreadPool.Close()
   $ThreadPool.Dispose()
   exit
}

if ($AutomationCheck) {
   $UserName = [System.Environment]::GetEnvironmentVariable("USERNAME")
   RichTextBox $SystemWindowsControlsRichTextBox0 "SYSTEM v$CurrentVersion" -Clear | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Welcome $UserName" | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "____________________________________________________________________________________________________________________________________________________________" | Out-Null
   UpdateRun $AppList
   $SystemWindowsWindow.Hide()
   $SystemWindowsWindow.Show()
   $ThreadPool.Close()
   $ThreadPool.Dispose()
   exit
}