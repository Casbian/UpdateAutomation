#═════════════════════════════════════════════════════════════
# Main Script | Parameter
#═════════════════════════════════════════════════════════════
param(
   [switch]$EXELaunch
)
#═════════════════════════════════════════════════════════════
# Main Script | False Run Catch
#═════════════════════════════════════════════════════════════
if ($EXELaunch -ne $true) {
   $SystemWindowsWindow.Close()
   $ThreadPool.Close()
   $ThreadPool.Dispose()
   exit
}
#═════════════════════════════════════════════════════════════
# Main Script | Module Imports and Add Types
#═════════════════════════════════════════════════════════════
Import-Module "$PSScriptRoot\app\app.psm1"

Import-Module "$PSScriptRoot\update\update.psm1"
$CurrentVersion = Update $MyInvocation

Import-Module "$PSScriptRoot\flag\flag.psm1"
if ($EXELaunch -eq $false) {
   $FlagValue = ChecklastautomatedrunFlag $PSScriptRoot
   if ($FlagValue -eq 1) {
      exit
   }
}

Import-Module "$PSScriptRoot\automation\automation.psm1"
Import-Module "$PSScriptRoot\cpu\cpu.psm1"
Import-Module "$PSScriptRoot\gpu\gpu.psm1"
Import-Module "$PSScriptRoot\network\network.psm1"
Import-Module "$PSScriptRoot\ram\ram.psm1"
Import-Module "$PSScriptRoot\richtextbox\richtextbox.psm1"
Import-Module "$PSScriptRoot\system\system.psm1"
Import-Module "$PSScriptRoot\thread\thread.psm1" 
Import-Module "$PSScriptRoot\window\window.psm1"
Import-Module "$PSScriptRoot\windowsupdate\windowsupdate.psm1"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
#═════════════════════════════════════════════════════════════
# Main Script | Application Startup
#═════════════════════════════════════════════════════════════
$SystemWindowsWindow, $LoadingBar, $LoadingBarFrames = SystemLogo
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 0

$Network = NetworkConnect
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 1

if (-not $Network) {
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






$NetworkAdapterValues = NetworkGetAdapterValues
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 2

$ThreadPool = ThreadPool
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 3

$ThreadList = New-Object System.Collections.Generic.List[object]
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 4

$ThreadWrapper = { param($Function, $Parameter); $FunctionBlock = [scriptblock]::Create($Function); & $FunctionBlock $Parameter }
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 5

$WindowsUpdateInfoSave = [System.Collections.Generic.List[object]]::new()
$CustomKB = 1
$WindowsUpdateRunning = $false

$AppUpdateInfoSave = [System.Collections.Generic.List[object]]::new()
$AppUpdateRunning = $false
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 6

$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:GPUGetAdapterValues}))
$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:CPUGetAdapterValues}))
$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:RAMGetAdapterValues}))
$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:SystemGetAdapterValues}))
SystemLogoContinueOneFrame $SystemWindowsWindow $LoadingBar $LoadingBarFrames 7
#═════════════════════════════════════════════════════════════
# Main Script | Application Start
#═════════════════════════════════════════════════════════════
$SystemWindowsWindow, $SystemWindowsControlsCanvas, $SystemWindowsControlsRichTextBoxButtonInfoPopup, $SystemWindowsControlsRichTextBoxSideBarSystemSection, $ButtonDashboard, $ButtonUpdates, $SystemWindowsControlsRichTextBoxSideBarAutomationSection, $ButtonAutomation, $PageDashboard, $SystemWindowsControlsRichTextBoxPageDashboardNetwork0, $SystemWindowsControlsRichTextBoxPageDashboardNetwork1, $SystemWindowsControlsRichTextBoxPageDashboardGPU0, $SystemWindowsControlsRichTextBoxPageDashboardGPU1, $SystemWindowsControlsRichTextBoxPageDashboardCPU0, $SystemWindowsControlsRichTextBoxPageDashboardCPU1, $SystemWindowsControlsRichTextBoxPageDashboardRAM0, $SystemWindowsControlsRichTextBoxPageDashboardRAM1, $SystemWindowsControlsRichTextBoxPageDashboardRAM2, $SystemWindowsControlsRichTextBoxPageDashboardLogBar, $SystemWindowsControlsRichTextBoxPageDashboardLog, $SystemWindowsControlsRichTextBoxPageDashboardTaskBar, $SystemWindowsControlsRichTextBoxPageDashboardTask, $PageUpdate, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2, $PageUpdateStackPanelWindowsUpdate, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2, $PageUpdateStackPanelAppUpdate, $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0, $PageAutomation, $SystemWindowsControlsRichTextBoxStatusBar0, $SystemWindowsControlsRichTextBoxStatusBar1 = System $MyInvocation
#═════════════════════════════════════════════════════════════
# Main Script | RichTextBox Clear All
#═════════════════════════════════════════════════════════════
RichTextBoxClear $SystemWindowsControlsRichTextBoxButtonInfoPopup | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxSideBarSystemSection | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxSideBarAutomationSection | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardNetwork0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardNetwork1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardGPU0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardGPU1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardCPU0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardCPU1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM2 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardLogBar | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardLog | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardTaskBar | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardTask | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxStatusBar0 | Out-Null
RichTextBoxClear $SystemWindowsControlsRichTextBoxStatusBar1 | Out-Null
Window | Out-Null
#═════════════════════════════════════════════════════════════
# Main Script | System First Scan Threads
#═════════════════════════════════════════════════════════════
$WindowsUpdateRunning = $true
$AppUpdateRunning = $true

$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:WindowsUpdateGetStatus} -Parameter @{RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2}))

$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:AppGetStatus} -Parameter @{RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 = $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2}))
#$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:AppGetStatus}))





#$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:GPUGetInstalledVersion}))
#$ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:GPUGetLatestVersion}))
#═════════════════════════════════════════════════════════════
# Button Info Popup | Version Info Setup
#═════════════════════════════════════════════════════════════
RichTextBox $SystemWindowsControlsRichTextBoxButtonInfoPopup " Version: v$CurrentVersion" -Indicator "DOTBLUE" -IndicatorSize 10 | Out-Null
Window | Out-Null
#═════════════════════════════════════════════════════════════
# Sidebar | Label Setup / Button Functions Setup
#═════════════════════════════════════════════════════════════
RichTextBox $SystemWindowsControlsRichTextBoxSideBarSystemSection "SYSTEM" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxSideBarAutomationSection "AUTOMATION" | Out-Null
Window | Out-Null
$ButtonDashboard.Add_Click({
   $ButtonUpdates.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonUpdates.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonUpdates.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonAutomation.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonAutomation.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonAutomation.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonDashboard.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#323232")
   $ButtonDashboard.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $PageUpdate.Visibility = "Collapsed"
   $PageAutomation.Visibility = "Collapsed"
   $PageDashboard.Visibility = "Visible"
})
$ButtonUpdates.Add_Click({
   $ButtonDashboard.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonDashboard.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonAutomation.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonAutomation.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonAutomation.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonUpdates.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#323232")
   $ButtonUpdates.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonUpdates.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonUpdates.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $PageDashboard.Visibility = "Collapsed"
   $PageAutomation.Visibility = "Collapsed"
   $PageUpdate.Visibility = "Visible"
})
$ButtonAutomation.Add_Click({
   $ButtonDashboard.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonDashboard.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonUpdates.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonUpdates.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonUpdates.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonAutomation.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#323232")
   $ButtonAutomation.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonAutomation.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonAutomation.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $PageDashboard.Visibility = "Collapsed"
   $PageUpdate.Visibility = "Collapsed"
   $PageAutomation.Visibility = "Visible"
})
#═════════════════════════════════════════════════════════════
# Page Dashboard | Setup 
#═════════════════════════════════════════════════════════════
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardNetwork0 "Network" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardNetwork1 $Network | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardNetwork1 $NetworkAdapterValues -ScrollUP | Out-Null
$Time = Get-Date -Format "HH:mm:ss"
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time] |" -BottomToTop -Tag "OK" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog " Network SCAN" -NoNewLine -BottomToTop | Out-Null

RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU0 "GPU" -Indicator "DOTORANGE" -IndicatorSize 15 | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU0 "CPU" -Indicator "DOTORANGE" -IndicatorSize 15 | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM0 "RAM" -Indicator "DOTORANGE" -IndicatorSize 15 | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLogBar "SYSTEM LOG" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTaskBar "ACTIVE TASKS" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
#═════════════════════════════════════════════════════════════
# Page Updates | Setup 
#═════════════════════════════════════════════════════════════
RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0 "WINDOWS UPDATES" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0 "APP UPDATES" | Out-Null
RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0 "GPU UPDATES" | Out-Null
Window | Out-Null
#═════════════════════════════════════════════════════════════
# Main Script | System First Scan Results
#═════════════════════════════════════════════════════════════
#, "Application Update Status", "Application Update List", "GPU Latest Version Scan", "GPU Latest Version Scan"
$TaskName = @("GPU Info", "CPU Info", "RAM Info", "System Info", "Windows-Update Status", "App-Update Status")
$AlreadyLogged = @()
$Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
$FrameIndex = 0
$LinestoDeleteTask = 0
$LinestoDeleteWindowsUpdate = 0
$LinestoDeleteAppUpdate = 0
while ($ThreadList | Where-Object { -not $_.Handle.IsCompleted }) {
   $Frame = $Frames[$FrameIndex % $Frames.Count]
   if ($FrameIndex -gt 0 -and $LinestoDeleteTask -gt 0) {
      for ($i = 0; $i -lt $LinestoDeleteTask; $i++) {
         RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageDashboardTask | Out-Null
      }
   }
   if ($FrameIndex -gt 0 -and $LinestoDeleteWindowsUpdate -gt 0) {
      for ($i = 0; $i -lt $LinestoDeleteWindowsUpdate; $i++) {
         RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 | Out-Null
      }
   }
   if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
      for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
         RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
      }
   }
   $LinestoDeleteTask = 0
   $LinestoDeleteWindowsUpdate = 0
   $LinestoDeleteAppUpdate = 0
   for ($i = 0; $i -lt $ThreadList.Count; $i++) {
      if (-not $ThreadList[$i].Handle.IsCompleted) {
         $Time = Get-Date -Format "HH:mm:ss"
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
         $LinestoDeleteTask++
         if ($i -eq 4) {
            $Time = Get-Date -Format "HH:mm:ss"
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 "$Frame" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " Status" -NoNewLine | Out-Null
            $LinestoDeleteWindowsUpdate++
         }
         if ($i -eq 5) {
            $Time = Get-Date -Format "HH:mm:ss"
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 "$Frame" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " Status" -NoNewLine | Out-Null
            $LinestoDeleteAppUpdate++
         }
      }
      if ($ThreadList[$i].Handle.IsCompleted -and ($i -notin $AlreadyLogged)) {
         $Time = Get-Date -Format "HH:mm:ss"
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time] |" -BottomToTop -Tag "OK" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog " $($TaskName[$i])" -NoNewLine -BottomToTop | Out-Null
         $AlreadyLogged += $i
         if ($i -eq 0) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $GPUAdapterValues = $Result
         }
         if ($i -eq 1) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $CPUAdapterValues = $Result
            RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardCPU0 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU0 "CPU" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 $CPUAdapterValues[0] | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "Architecture | $($CPUAdapterValues[1])" | Out-Null
         }
         if ($i -eq 2) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $RAMAdapterValues = $Result
            RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM0 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM0 "RAM" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 $RAMAdapterValues[0] | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[1]) GB" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[2]) MHZ" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 $RAMAdapterValues[3] | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[4]) GB" | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[5]) MHZ" | Out-Null
         }
         if ($i -eq 3) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $SystemAdapterValues = $Result
            RichTextBox $SystemWindowsControlsRichTextBoxStatusBar0 "$($SystemAdapterValues[0]) | $($SystemAdapterValues[4])@$($SystemAdapterValues[1]).$($SystemAdapterValues[2])$($SystemAdapterValues[3])" -Indicator "DOTBLUE" -IndicatorSize 15 -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxStatusBar1 "$($SystemAdapterValues[5]) $($SystemAdapterValues[6]) $($SystemAdapterValues[7]) [$($SystemAdapterValues[8])] " -RightAlign -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxStatusBar1 "" -Indicator "DOTGREEN" -IndicatorSize 15 -RightAlign -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray)| Out-Null
         }
         if ($i -eq 4) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $WindowsUpdateInfo = $Result
            WindowsUpdateCreateUpdateBar $WindowsUpdateInfo
         }
         if ($i -eq 5) {
            $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
            if ($ThreadList[$i].Instance.HadErrors) {
               $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
            }
            $ThreadList[$i].Instance.Dispose()
            $AppList = $Result
            AppCreateUpdateBar $AppList
         }
      }
   }
   Window | Out-Null
   $FrameIndex++
   Start-Sleep -Seconds 0.04
}
$Frame = $Frames[$FrameIndex % $Frames.Count]
if ($FrameIndex -gt 0 -and $LinestoDeleteTask -gt 0) {
   for ($i = 0; $i -lt $LinestoDeleteTask; $i++) {
      RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageDashboardTask | Out-Null
   }
}
if ($FrameIndex -gt 0 -and $LinestoDeleteWindowsUpdate -gt 0) {
   for ($i = 0; $i -lt $LinestoDeleteWindowsUpdate; $i++) {
      RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 | Out-Null
   }
}
if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
   for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
      RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
   }
}
$LinestoDeleteTask = 0
$LinestoDeleteWindowsUpdate = 0
$LinestoDeleteAppUpdate = 0
for ($i = 0; $i -lt $ThreadList.Count; $i++) {
   if ($ThreadList[$i].Handle.IsCompleted -and ($i -notin $AlreadyLogged)) {
      $Time = Get-Date -Format "HH:mm:ss"
      RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time] |" -BottomToTop -Tag "OK" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog " $($TaskName[$i])" -NoNewLine -BottomToTop | Out-Null
      $AlreadyLogged += $i
      if ($i -eq 0) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $GPUAdapterValues = $Result
      }
      if ($i -eq 1) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $CPUAdapterValues = $Result
         RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardCPU0 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU0 "CPU" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 $CPUAdapterValues[0] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "Architecture | $($CPUAdapterValues[1])" | Out-Null
      }
      if ($i -eq 2) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $RAMAdapterValues = $Result
         RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM0 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM0 "RAM" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 $RAMAdapterValues[0] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[1]) GB" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[2]) MHZ" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 $RAMAdapterValues[3] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[4]) GB" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[5]) MHZ" | Out-Null
      }
      if ($i -eq 3) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $SystemAdapterValues = $Result
         RichTextBox $SystemWindowsControlsRichTextBoxStatusBar0 "$($SystemAdapterValues[0]) | $($SystemAdapterValues[4])@$($SystemAdapterValues[1]).$($SystemAdapterValues[2])$($SystemAdapterValues[3])" -Indicator "DOTBLUE" -IndicatorSize 15 -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxStatusBar1 "$($SystemAdapterValues[5]) $($SystemAdapterValues[6]) $($SystemAdapterValues[7]) [$($SystemAdapterValues[8])] " -RightAlign -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxStatusBar1 "" -Indicator "DOTGREEN" -IndicatorSize 15 -RightAlign -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray)| Out-Null
      }
      if ($i -eq 4) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $WindowsUpdateInfo = $Result
         WindowsUpdateCreateUpdateBar $WindowsUpdateInfo
      }
      if ($i -eq 5) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $AppList = $Result
         AppCreateUpdateBar $AppList
      }
   }
}
Window | Out-Null
$ThreadList.Clear()

$WindowsUpdateRunning = $false
$AppUpdateRunning = $false

#═════════════════════════════════════════════════════════════
# Main Script | Main
#═════════════════════════════════════════════════════════════

if ($EXELaunch -eq $true) {
   $SystemWindowsWindow.Hide()
   $SystemWindowsWindow.ShowDialog()
   $ThreadPool.Close()
   $ThreadPool.Dispose()
   exit
}

if ($AutomationCheck) {
   $SystemWindowsWindow.Hide()
   $SystemWindowsWindow.Show()
   $ThreadPool.Close()
   $ThreadPool.Dispose()
   exit
}







<#


for ($i = 0; $i -lt $ThreadList.Count; $i++) {
   if ($ThreadList[$i].Handle.IsCompleted -and ($i -notin $AlreadyLogged)) {
      $Time = Get-Date -Format "HH:mm:ss"
      RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time] |" -BottomToTop -Tag "OK" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
      RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog " $($TaskName[$i])" -NoNewLine -BottomToTop | Out-Null
      $AlreadyLogged += $i
      if ($i -eq 0) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $WindowsUpdateInfo = $Result
         WindowsUpdateCreateUpdateBar $WindowsUpdateInfo
      }
      if ($i -eq 1) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $WingetStatus = $Result
      }
      if ($i -eq 2) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $WingetAppList = $Result
      }
      if ($i -eq 3) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $GPUInsalledVersion = $Result
      }
      if ($i -eq 4) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $GPULatestVersion = $Result
      }
      if ($i -eq 5) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $GPUAdapterValues = $Result
      }
      if ($i -eq 6) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $CPUAdapterValues = $Result
         RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardCPU0 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU0 "CPU" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 $CPUAdapterValues[0] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardCPU1 "Architecture | $($CPUAdapterValues[1])" | Out-Null
      }
      if ($i -eq 7) {
         $Result = $ThreadList[$i].Instance.EndInvoke($ThreadList[$i].Handle)
         if ($ThreadList[$i].Instance.HadErrors) {
            $ThreadList[$i].Instance.Streams.Error | ForEach-Object { Write-Warning "Thread error: $_" }
         }
         $ThreadList[$i].Instance.Dispose()
         $RAMAdapterValues = $Result
         RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardRAM0 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM0 "RAM" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "--------" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 $RAMAdapterValues[0] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[1]) GB" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM1 "$($RAMAdapterValues[2]) MHZ" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 $RAMAdapterValues[3] | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[4]) GB" | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardRAM2 "$($RAMAdapterValues[5]) MHZ" | Out-Null
      }
      if ($i -eq 1 -or $i -eq 2 -and $AlreadyLogged -contains 1 -and $AlreadyLogged -contains 2) {
         if ($null -eq $WingetAppList -or $WingetAppList.Count -eq 0) {
            RichTextBox $SystemWindowsControlsRichTextBox7 "Up to Date" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         } else {
            $AppUpdateNeeded = $true
            RichTextBox $SystemWindowsControlsRichTextBox5 "" -Tag "WARNING" -Color ([System.Windows.Media.Brushes]::Yellow) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBox7 $WingetStatus | Out-Null
         }
      }
      if ($i -eq 3 -or $i -eq 4 -or $i -eq 5 -and $AlreadyLogged -contains 3 -and $AlreadyLogged -contains 4 -and $AlreadyLogged -contains 5) {
         if (-not $GPULatestVersion -eq 0) {
            if ($GPUInsalledVersion -eq $GPULatestVersion) {
               RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardGPU0 | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU0 "GPU" -Indicator "DOTGREEN" -IndicatorSize 15 | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 "v$GPULatestVersion" -Color ([System.Windows.Media.Brushes]::Green) | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 $GPUAdapterValues -ScrollUP | Out-Null
            } else {
               $GPUUpdateNeeded = $true
               RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardGPU0 | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU0 "GPU" -Indicator "UP" -IndicatorSize 15 | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 "v$GPULatestVersion" -Color ([System.Windows.Media.Brushes]::Yellow) | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 $GPUAdapterValues -ScrollUP | Out-Null
               $Time = Get-Date -Format "HH:mm:ss"
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time]" -BottomToTop -Tag "INFO" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "Nvidia Game Ready Driver v$GPULatestVersion available" -BottomToTop | Out-Null
               RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
            }
         } else {
            RichTextBoxClear $SystemWindowsControlsRichTextBoxPageDashboardGPU0 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU0 "GPU" -Indicator "DOTORANGE" -IndicatorSize 15 | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 "No Database Match" -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardGPU1 $GPUAdapterValues -ScrollUP | Out-Null
            $Time = Get-Date -Format "HH:mm:ss"
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time]" -BottomToTop -Tag "WARNING" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "No Database Match for GPU" -BottomToTop | Out-Null
            RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
         }
      }
   }
}

#>