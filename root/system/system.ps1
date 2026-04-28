function SystemLogo(){
   $SystemWindowsWindow = New-Object System.Windows.Window
   $SystemWindowsWindow.WindowStyle = "None"
   $SystemWindowsWindow.AllowsTransparency = $true
   $SystemWindowsWindow.Background = "Transparent"
   $SystemWindowsWindow.ResizeMode = "NoResize"
   $SystemWindowsWindow.Topmost = $true
   $SystemWindowsWindow.Width = 300
   $SystemWindowsWindow.Height = 310
   $ScreenParameter = [System.Windows.SystemParameters]
   $SystemWindowsWindow.Left = ($ScreenParameter::PrimaryScreenWidth - 300) / 2
   $SystemWindowsWindow.Top = ($ScreenParameter::PrimaryScreenHeight * 0.45) - (310 / 2)
   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconBig.png")))
   $Logo.Width = 282
   $Logo.Height = 282
   $LoadingBar = New-Object System.Windows.Controls.Image
   $LoadingBar.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\LoadingBar1.png")))
   $LoadingBar.Width = 292
   $LoadingBar.Height = 30
   $LoadingBarFrames = @("LoadingBar2","LoadingBar3","LoadingBar4","LoadingBar5","LoadingBar6","LoadingBar7","LoadingBar8","LoadingBar9")
   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   [System.Windows.Controls.Canvas]::SetTop($LoadingBar, 270)
   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($LoadingBar) | Out-Null
   $SystemWindowsWindow.Content = $SystemWindowsControlsCanvas
   $SystemWindowsWindow.Show()
   return $SystemWindowsWindow, $LoadingBar, $LoadingBarFrames
}
function SystemLogoContinueOneFrame($SystemWindowsWindow, $LoadingBar, $LoadingBarFrames, $Counter) {
   $LoadingBar.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\$($LoadingBarFrames[$Counter]).png")))
   Window
   if ($Counter -eq 7) {
      $Counter = 0
      $SystemWindowsWindow.Close()
   }
}
function System(){
   $SystemWindowsWindow = New-Object System.Windows.Window
   $SystemWindowsWindow.WindowStyle = "None"
   $SystemWindowsWindow.AllowsTransparency = $true
   $SystemWindowsWindow.Background = "Transparent"
   $SystemWindowsWindow.ResizeMode = "NoResize"
   $SystemWindowsWindow.Topmost = $false
   $SystemWindowsWindow.Width = 1350
   $SystemWindowsWindow.Height = 880
   $ScreenParameter = [System.Windows.SystemParameters]
   $SystemWindowsWindow.Left = ($ScreenParameter::PrimaryScreenWidth - 900) / 2
   $SystemWindowsWindow.Top = ($ScreenParameter::PrimaryScreenHeight * 0.30) - (500 / 2)
   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BackgroundSystem.png")))
   $Background.Width = 900
   $Background.Height = 630
   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSmall.png")))
   $Logo.Width = 44
   $Logo.Height = 44
   $DragBarImage = New-Object System.Windows.Controls.Image
   $DragBarImage.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\DragBar.png")))
   $DragBarImage.Width = 900
   $DragBarImage.Height = 40
   $DragBarImage.Add_MouseLeftButtonDown({
      [System.Windows.Window]::GetWindow($args[0]).DragMove()
   })
   $AutomationCheck = Get-ScheduledTask -TaskName "CoreForge_Automation"
   $AutomationButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      Active  = $false
      AutomationCheck = $AutomationCheck
   }
   $AutomationButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabel.png")))
   $AutomationButton.Button.Width = 110
   $AutomationButton.Button.Height = 30
   $AutomationButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelText.png")))
   $AutomationButton.Icon.Width = 94
   $AutomationButton.Icon.Height = 18
   $AutomationButton.Button.Tag = $AutomationButton
   $AutomationButton.Icon.Tag   = $AutomationButton
   if (-not $AutomationCheck) {
      $AutomationButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
      $AutomationButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
   } else {
      $AutomationButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
      $AutomationButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
   }
   $AutomationButton.Button.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabel.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelText.png")))
      }
   })
   $AutomationButton.Button.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         if (-not $this.Tag.AutomationCheck) {
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
            $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
         } else {
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
            $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
         }
      }
   })
   $AutomationButton.Icon.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabel.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelText.png")))
      }
   })
   $AutomationButton.Icon.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         if (-not $this.Tag.AutomationCheck) {
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
            $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
         } else {
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
            $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
         }
      }
   })
   $AutomationButton.Button.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextPressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $AutomationButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            if (-not $this.Tag.AutomationCheck) {
               AutomationActivate
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
               $this.Tag.AutomationCheck = Get-ScheduledTask -TaskName "CoreForge_Automation"
            } else {
               AutomationDeactivate
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
               $this.Tag.AutomationCheck = Get-ScheduledTask -TaskName "CoreForge_Automation"
            }
            $this.Tag.Active = $false
         }
      } else {
         if (-not $this.Tag.Active) {
            if (-not $this.Tag.AutomationCheck) {
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
            } else {
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
            }
         }
      }
   })
   $AutomationButton.Icon.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextPressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $AutomationButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            if (-not $this.Tag.AutomationCheck) {
               AutomationActivate
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
               $this.Tag.AutomationCheck = Get-ScheduledTask -TaskName "CoreForge_Automation"
            } else {
               AutomationDeactivate
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
               $this.Tag.AutomationCheck = Get-ScheduledTask -TaskName "CoreForge_Automation"
            }
            $this.Tag.Active = $false
         }
      } else {
         if (-not $this.Tag.Active) {
            if (-not $this.Tag.AutomationCheck) {
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelInactive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextInactive.png")))
            } else {
               $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelActive.png")))
               $this.Tag.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationLabelTextActive.png")))
            }
         }
      }
   })
   $UpdateNowButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      Active  = $false
   }
   $UpdateNowButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $UpdateNowButton.Button.Width = 30
   $UpdateNowButton.Button.Height = 30
   $UpdateNowButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
   $UpdateNowButton.Icon.Width = 18
   $UpdateNowButton.Icon.Height = 18
   $UpdateNowButton.Button.Tag = $UpdateNowButton
   $UpdateNowButton.Icon.Tag   = $UpdateNowButton
   $UpdateNowButton.Button.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdateHover.png")))
      }
   })
   $UpdateNowButton.Button.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
      }
   })
   $UpdateNowButton.Icon.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdateHover.png")))
      }
   })
   $UpdateNowButton.Icon.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
      }
   })
   $UpdateNowButton.Button.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdatePressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $UpdateNowButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
            UpdateRun $AppList
            $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
            $this.Tag.Active = $false
         }
      } else {
         if (-not $this.Tag.Active) {
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
         }
      }
   })
   $UpdateNowButton.Icon.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdatePressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $UpdateNowButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
            UpdateRun $AppList
            $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
            $this.Tag.Active = $false
         }
      } else {
         if (-not $this.Tag.Active) {
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemUpdate.png")))
         }
      }
   })
   $InfoButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      Active  = $false
   }
   $InfoButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $InfoButton.Button.Width = 30
   $InfoButton.Button.Height = 30
   $InfoButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
   $InfoButton.Icon.Width = 18
   $InfoButton.Icon.Height = 18
   $InfoButton.Button.Tag = $InfoButton
   $InfoButton.Icon.Tag   = $InfoButton
   $InfoButton.Button.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoHover.png")))
      }
   })
   $InfoButton.Button.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
      }
   })
   $InfoButton.Icon.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoHover.png")))
      }
   })
   $InfoButton.Icon.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
      }
   })
   $InfoButton.Button.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $InfoButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
            $EnvironmentValues, $NetworkValues, $CPUValues, $GPUValues, $RAMValues = SystemInfoGet
            SystemInfo $SystemWindowsControlsCanvas $this.Tag $EnvironmentValues $NetworkValues $CPUValues $GPUValues $RAMValues
         }
      } else {
         if (-not $this.Tag.Active) {
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
         }
    }
   })
   $InfoButton.Icon.Add_MouseLeftButtonDown({
      if (-not $this.Tag.Active) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
         $this.CaptureMouse() | Out-Null
      }
   })
   $InfoButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         if (-not $this.Tag.Active) {
            $this.Tag.Active = $true
            $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
            $EnvironmentValues, $NetworkValues, $CPUValues, $GPUValues, $RAMValues = SystemInfoGet
            SystemInfo $SystemWindowsControlsCanvas $this.Tag $EnvironmentValues $NetworkValues $CPUValues $GPUValues $RAMValues
         }
      } else {
         if (-not $this.Tag.Active) {
            $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
         }
    }
   })
   $SettingsButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      Active  = $false
   }
   $SettingsButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $SettingsButton.Button.Width = 30
   $SettingsButton.Button.Height = 30
   $SettingsButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
   $SettingsButton.Icon.Width = 18
   $SettingsButton.Icon.Height = 18
   $SettingsButton.Button.Tag = $SettingsButton
   $SettingsButton.Icon.Tag   = $SettingsButton
   $SettingsButton.Button.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsHover.png")))
      }
   })
   $SettingsButton.Button.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
      }
   })
   $SettingsButton.Icon.Add_MouseEnter({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsHover.png")))
      }
   })
   $SettingsButton.Icon.Add_MouseLeave({
      if (-not $this.Tag.Active) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
      }
   })
   $SettingsButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $SettingsButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsPressed.png")))
         if (-not $this.Tag.Active) {
            SystemSettings $SystemWindowsControlsCanvas $this.Tag
         }
         $this.Tag.Active = $true
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
    }
   })
   $SettingsButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $SettingsButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettingsPressed.png")))
         if (-not $this.Tag.Active) {
            SystemSettings $SystemWindowsControlsCanvas $this.Tag
         }
         $this.Tag.Active = $true
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
    }
   })
   $CloseButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $CloseButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $CloseButton.Button.Width = 30
   $CloseButton.Button.Height = 30
   $CloseButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   $CloseButton.Icon.Width = 22
   $CloseButton.Icon.Height = 22
   $CloseButton.Button.Tag = $CloseButton
   $CloseButton.Icon.Tag   = $CloseButton
   $CloseButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         $SystemWindowsWindow.Close()
         exit
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
    }
   })
   $CloseButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         $SystemWindowsWindow.Close()
         exit
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
    }
   })
   $SystemWindowsControlsRichTextBoxImage0 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage0.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\TextBoxConsole.png")))
   $SystemWindowsControlsRichTextBoxImage0.Width = 880
   $SystemWindowsControlsRichTextBoxImage0.Height = 310
   $SystemWindowsControlsRichTextBox0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox0.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox0.FontSize = 10
   $SystemWindowsControlsRichTextBox0.Width = 880
   $SystemWindowsControlsRichTextBox0.Height = 290
   $SystemWindowsControlsRichTextBox0.BorderThickness = 0
   $SystemWindowsControlsRichTextBox0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxImage1 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage1.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\TextBoxWindowsUpdates.png")))
   $SystemWindowsControlsRichTextBoxImage1.Width = 410
   $SystemWindowsControlsRichTextBoxImage1.Height = 120
   $SystemWindowsControlsRichTextBox1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox1.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox1.FontSize = 10
   $SystemWindowsControlsRichTextBox1.Width = 410
   $SystemWindowsControlsRichTextBox1.Height = 100
   $SystemWindowsControlsRichTextBox1.BorderThickness = 0
   $SystemWindowsControlsRichTextBox1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxImage2 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage2.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\TextBoxApps.png")))
   $SystemWindowsControlsRichTextBoxImage2.Width = 460
   $SystemWindowsControlsRichTextBoxImage2.Height = 120
   $SystemWindowsControlsRichTextBox2 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox2.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox2.FontSize = 10
   $SystemWindowsControlsRichTextBox2.Width = 460
   $SystemWindowsControlsRichTextBox2.Height = 100
   $SystemWindowsControlsRichTextBox2.BorderThickness = 0
   $SystemWindowsControlsRichTextBox2.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox2.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox2.Foreground = [System.Windows.Media.Brushes]::White

   $SystemWindowsControlsRichTextBoxImage3 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage3.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\TextBoxGPU.png")))
   $SystemWindowsControlsRichTextBoxImage3.Width = 880
   $SystemWindowsControlsRichTextBoxImage3.Height = 120
   $SystemWindowsControlsRichTextBox3 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox3.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox3.FontSize = 10
   $SystemWindowsControlsRichTextBox3.Width = 880
   $SystemWindowsControlsRichTextBox3.Height = 100
   $SystemWindowsControlsRichTextBox3.BorderThickness = 0
   $SystemWindowsControlsRichTextBox3.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox3.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox3.Foreground = [System.Windows.Media.Brushes]::White

   [System.Windows.Controls.Canvas]::SetLeft($Background, 0)
   [System.Windows.Controls.Canvas]::SetTop($Background, 250)
   [System.Windows.Controls.Canvas]::SetLeft($Logo, 0)
   [System.Windows.Controls.Canvas]::SetTop($Logo, 255)
   [System.Windows.Controls.Canvas]::SetLeft($DragBarImage, 0)
   [System.Windows.Controls.Canvas]::SetTop($DragBarImage, 250)
   [System.Windows.Controls.Canvas]::SetLeft($AutomationButton.Button, 50)
   [System.Windows.Controls.Canvas]::SetTop($AutomationButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($AutomationButton.Icon, 60)
   [System.Windows.Controls.Canvas]::SetTop($AutomationButton.Icon, 265)
   [System.Windows.Controls.Canvas]::SetLeft($UpdateNowButton.Button, 740)
   [System.Windows.Controls.Canvas]::SetTop($UpdateNowButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($UpdateNowButton.Icon, 746)
   [System.Windows.Controls.Canvas]::SetTop($UpdateNowButton.Icon, 266)
   [System.Windows.Controls.Canvas]::SetLeft($InfoButton.Button, 780)
   [System.Windows.Controls.Canvas]::SetTop($InfoButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($InfoButton.Icon, 786)
   [System.Windows.Controls.Canvas]::SetTop($InfoButton.Icon, 266)
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Button, 820)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Icon, 826)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Icon, 266)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 860)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 864)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 264)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage0, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage0, 300)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox0, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox0, 310)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage1, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage1, 620)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox1, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox1, 630)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage2, 430)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage2, 620)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox2, 435)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox2, 630)

   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage3, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage3, 750)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox3, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox3, 760)

   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   $SystemWindowsWindow.Content = $SystemWindowsControlsCanvas
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($DragBarImage) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($AutomationButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($AutomationButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($UpdateNowButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($UpdateNowButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($InfoButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($InfoButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage0) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox0) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage1) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox1) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage2) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox2) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage3) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox3) | Out-Null
   $SystemWindowsWindow.Show()
   return $SystemWindowsWindow, $SystemWindowsControlsCanvas, $AutomationButton, $UpdateNowButton, $InfoButton, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2, $SystemWindowsControlsRichTextBox3, $AutomationCheck
}
function SystemSettings($SystemWindowsControlsCanvas, $SettingsButton) {
   $Elements = [System.Collections.Generic.List[System.Windows.UIElement]]::new()
   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BackgroundSystemSettings.png")))
   $Background.Width = 450
   $Background.Height = 500
   $CloseButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      SystemWindowsControlsCanvas = $SystemWindowsControlsCanvas
      SettingsButton = $SettingsButton
      Elements = $Elements
   }
   $CloseButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $CloseButton.Button.Width = 30
   $CloseButton.Button.Height = 30
   $CloseButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   $CloseButton.Icon.Width = 22
   $CloseButton.Icon.Height = 22
   $CloseButton.Button.Tag = $CloseButton
   $CloseButton.Icon.Tag   = $CloseButton
   $CloseButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         foreach ($Element in $this.Tag.Elements) {
            $this.Tag.SystemWindowsControlsCanvas.Children.Remove($Element) | Out-Null
         }         
         $this.Tag.SettingsButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.SettingsButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
         $this.Tag.SettingsButton.Active = $false
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
    }
   })
   $CloseButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         foreach ($Element in $this.Tag.Elements) {
            $this.Tag.SystemWindowsControlsCanvas.Children.Remove($Element) | Out-Null
         }
         $this.Tag.SettingsButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.SettingsButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
         $this.Tag.SettingsButton.Active = $false
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemSettings.png")))
    }
   })
   [System.Windows.Controls.Canvas]::SetLeft($Background, 900)
   [System.Windows.Controls.Canvas]::SetTop($Background, 250)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 1310)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 260)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 1314)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 264)
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $Elements.Add($Background)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $Elements.Add($CloseButton.Button)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon) | Out-Null
   $Elements.Add($CloseButton.Icon)
}
function SystemInfo($SystemWindowsControlsCanvas, $InfoButton, $EnvironmentValues, $NetworkValues, $CPUValues, $GPUValues, $RAMValues) {
   $Elements = [System.Collections.Generic.List[System.Windows.UIElement]]::new()
   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BackgroundSystemInfo.png")))
   $Background.Width = 720
   $Background.Height = 250
   $IconEnvironmentValues = New-Object System.Windows.Controls.Image
   $IconEnvironmentValues.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconEnvironmentValues.png")))
   $IconEnvironmentValues.Width = 30
   $IconEnvironmentValues.Height = 30
   $TextBoxEnvironmentValues = New-Object System.Windows.Controls.RichTextBox
   $TextBoxEnvironmentValues.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $TextBoxEnvironmentValues.FontSize = 12
   $TextBoxEnvironmentValues.Width = 340
   $TextBoxEnvironmentValues.Height = 130
   $TextBoxEnvironmentValues.BorderThickness = 0
   $TextBoxEnvironmentValues.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $TextBoxEnvironmentValues.Background = [System.Windows.Media.Brushes]::Transparent
   $TextBoxEnvironmentValues.Foreground = [System.Windows.Media.Brushes]::White
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "PC Name", $EnvironmentValues[0]) -Clear | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "Domain", $EnvironmentValues[1]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "Logon Server", $EnvironmentValues[2]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "User", $EnvironmentValues[3]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "Session Admin", $EnvironmentValues[4]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "OS", $EnvironmentValues[5]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "Architecture", $EnvironmentValues[6]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "Type", $EnvironmentValues[7]) | Out-Null
   RichTextBox $TextBoxEnvironmentValues ("{0,-14}| {1}" -f "UPTime", $EnvironmentValues[8]) | Out-Null
   Window | Out-Null
   $IconNetworkValues = New-Object System.Windows.Controls.Image
   $IconNetworkValues.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconNetworkValues.png")))
   $IconNetworkValues.Width = 30
   $IconNetworkValues.Height = 30
   $TextBoxNetworkValues = New-Object System.Windows.Controls.RichTextBox
   $TextBoxNetworkValues.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $TextBoxNetworkValues.FontSize = 12
   $TextBoxNetworkValues.Width = 370
   $TextBoxNetworkValues.Height = 100
   $TextBoxNetworkValues.BorderThickness = 0
   $TextBoxNetworkValues.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $TextBoxNetworkValues.Background = [System.Windows.Media.Brushes]::Transparent
   $TextBoxNetworkValues.Foreground = [System.Windows.Media.Brushes]::White
   for ($i = 0; $i -lt $NetworkValues.Count; $i += 3) {
      if ($i -eq 0) {
         RichTextBox $TextBoxNetworkValues ("{0,-5}| {1}" -f "Name", $NetworkValues[$i]) -Clear | Out-Null
      } else {
         RichTextBox $TextBoxNetworkValues ("{0,-5}| {1}" -f "Name", $NetworkValues[$i]) | Out-Null
      }
      RichTextBox $TextBoxNetworkValues ("{0,-5}| {1}" -f "MAC", $NetworkValues[$i+1]) | Out-Null
      RichTextBox $TextBoxNetworkValues ("{0,-5}| {1}" -f "IP'S", $NetworkValues[$i+2]) | Out-Null
      Window | Out-Null
   }
   $IconCPUValues = New-Object System.Windows.Controls.Image
   $IconCPUValues.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCPUValues.png")))
   $IconCPUValues.Width = 30
   $IconCPUValues.Height = 30
   $TextBoxCPUValues = New-Object System.Windows.Controls.RichTextBox
   $TextBoxCPUValues.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $TextBoxCPUValues.FontSize = 12
   $TextBoxCPUValues.Width = 310
   $TextBoxCPUValues.Height = 70
   $TextBoxCPUValues.BorderThickness = 0
   $TextBoxCPUValues.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $TextBoxCPUValues.Background = [System.Windows.Media.Brushes]::Transparent
   $TextBoxCPUValues.Foreground = [System.Windows.Media.Brushes]::White
   RichTextBox $TextBoxCPUValues $CPUValues[0] -Clear | Out-Null
   RichTextBox $TextBoxCPUValues ("{0,-14}| {1}" -f "Architecture", $CPUValues[1]) | Out-Null
   RichTextBox $TextBoxCPUValues ("{0,-14}| {1}" -f "Cores", $CPUValues[2]) | Out-Null
   RichTextBox $TextBoxCPUValues ("{0,-14}| {1}" -f "Logical Cores", $CPUValues[3]) | Out-Null
   Window | Out-Null
   $IconGPUValues = New-Object System.Windows.Controls.Image
   $IconGPUValues.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconGPUValues.png")))
   $IconGPUValues.Width = 30
   $IconGPUValues.Height = 30
   $TextBoxGPUValues = New-Object System.Windows.Controls.RichTextBox
   $TextBoxGPUValues.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $TextBoxGPUValues.FontSize = 12
   $TextBoxGPUValues.Width = 250
   $TextBoxGPUValues.Height = 40
   $TextBoxGPUValues.BorderThickness = 0
   $TextBoxGPUValues.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $TextBoxGPUValues.Background = [System.Windows.Media.Brushes]::Transparent
   $TextBoxGPUValues.Foreground = [System.Windows.Media.Brushes]::White
   RichTextBox $TextBoxGPUValues $GPUValues[0] -Clear | Out-Null
   RichTextBox $TextBoxGPUValues ("{0,-7}| {1}" -f "Driver", $GPUValues[1]) | Out-Null
   Window | Out-Null
   $IconRAMValues = New-Object System.Windows.Controls.Image
   $IconRAMValues.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconRAMValues.png")))
   $IconRAMValues.Width = 30
   $IconRAMValues.Height = 30
   $TextBoxRAMValues = New-Object System.Windows.Controls.RichTextBox
   $TextBoxRAMValues.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $TextBoxRAMValues.FontSize = 12
   $TextBoxRAMValues.Width = 210
   $TextBoxRAMValues.Height = 80
   $TextBoxRAMValues.BorderThickness = 0
   $TextBoxRAMValues.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $TextBoxRAMValues.Background = [System.Windows.Media.Brushes]::Transparent
   $TextBoxRAMValues.Foreground = [System.Windows.Media.Brushes]::White
   for ($i = 0; $i -lt $NetworkValues.Count; $i += 3) {
      if ($i -eq 0) {
         RichTextBox $TextBoxRAMValues ("{0} {1} GB {2} MHZ" -f $RAMValues[$i], $RAMValues[$i+1], $RAMValues[$i+2]) -Clear | Out-Null
      } else {
         RichTextBox $TextBoxRAMValues ("{0} {1} GB {2} MHZ" -f $RAMValues[$i], $RAMValues[$i+1], $RAMValues[$i+2]) | Out-Null
      }
   }
   $CloseButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
      SystemWindowsControlsCanvas = $SystemWindowsControlsCanvas
      InfoButton = $InfoButton
      Elements = $Elements
   }
   $CloseButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $CloseButton.Button.Width = 30
   $CloseButton.Button.Height = 30
   $CloseButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   $CloseButton.Icon.Width = 22
   $CloseButton.Icon.Height = 22
   $CloseButton.Button.Tag = $CloseButton
   $CloseButton.Icon.Tag   = $CloseButton
   $CloseButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCloseHover.png")))
   })
   $CloseButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
   })
   $CloseButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         foreach ($Element in $this.Tag.Elements) {
            $this.Tag.SystemWindowsControlsCanvas.Children.Remove($Element) | Out-Null
         }         
         $this.Tag.InfoButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.InfoButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
         $this.Tag.InfoButton.Active = $false
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
    }
   })
   $CloseButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         foreach ($Element in $this.Tag.Elements) {
            $this.Tag.SystemWindowsControlsCanvas.Children.Remove($Element) | Out-Null
         }
         $this.Tag.InfoButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
         $this.Tag.InfoButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
         $this.Tag.InfoButton.Active = $false
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconClose.png")))
    }
   })
   [System.Windows.Controls.Canvas]::SetLeft($Background, 180)
   [System.Windows.Controls.Canvas]::SetTop($Background, 0)
   [System.Windows.Controls.Canvas]::SetLeft($IconEnvironmentValues, 190)
   [System.Windows.Controls.Canvas]::SetTop($IconEnvironmentValues, 15)
   [System.Windows.Controls.Canvas]::SetLeft($IconNetworkValues, 190)
   [System.Windows.Controls.Canvas]::SetTop($IconNetworkValues, 150)
   [System.Windows.Controls.Canvas]::SetLeft($TextBoxEnvironmentValues, 230)
   [System.Windows.Controls.Canvas]::SetTop($TextBoxEnvironmentValues, 15)
   [System.Windows.Controls.Canvas]::SetLeft($TextBoxNetworkValues, 230)
   [System.Windows.Controls.Canvas]::SetTop($TextBoxNetworkValues, 150)
   [System.Windows.Controls.Canvas]::SetLeft($IconCPUValues, 520)
   [System.Windows.Controls.Canvas]::SetTop($IconCPUValues, 15)
   [System.Windows.Controls.Canvas]::SetLeft($IconGPUValues, 520)
   [System.Windows.Controls.Canvas]::SetTop($IconGPUValues, 80)
   [System.Windows.Controls.Canvas]::SetLeft($IconRAMValues, 520)
   [System.Windows.Controls.Canvas]::SetTop($IconRAMValues, 120)
   [System.Windows.Controls.Canvas]::SetLeft($TextBoxCPUValues, 570)
   [System.Windows.Controls.Canvas]::SetTop($TextBoxCPUValues, 15)
   [System.Windows.Controls.Canvas]::SetLeft($TextBoxGPUValues, 570)
   [System.Windows.Controls.Canvas]::SetTop($TextBoxGPUValues, 80)
   [System.Windows.Controls.Canvas]::SetLeft($TextBoxRAMValues, 570)
   [System.Windows.Controls.Canvas]::SetTop($TextBoxRAMValues, 120)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 860)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 10)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 864)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 14)
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $Elements.Add($Background)
   $SystemWindowsControlsCanvas.Children.Add($IconEnvironmentValues) | Out-Null
   $Elements.Add($IconEnvironmentValues)
   $SystemWindowsControlsCanvas.Children.Add($IconNetworkValues) | Out-Null
   $Elements.Add($IconNetworkValues)
   $SystemWindowsControlsCanvas.Children.Add($TextBoxEnvironmentValues) | Out-Null
   $Elements.Add($TextBoxEnvironmentValues)
   $SystemWindowsControlsCanvas.Children.Add($TextBoxNetworkValues) | Out-Null
   $Elements.Add($TextBoxNetworkValues)
   $SystemWindowsControlsCanvas.Children.Add($IconCPUValues) | Out-Null
   $Elements.Add($IconCPUValues)
   $SystemWindowsControlsCanvas.Children.Add($IconGPUValues) | Out-Null
   $Elements.Add($IconGPUValues)
   $SystemWindowsControlsCanvas.Children.Add($IconRAMValues) | Out-Null
   $Elements.Add($IconRAMValues)
   $SystemWindowsControlsCanvas.Children.Add($TextBoxCPUValues) | Out-Null
   $Elements.Add($TextBoxCPUValues)
   $SystemWindowsControlsCanvas.Children.Add($TextBoxGPUValues) | Out-Null
   $Elements.Add($TextBoxGPUValues)
   $SystemWindowsControlsCanvas.Children.Add($TextBoxRAMValues) | Out-Null
   $Elements.Add($TextBoxRAMValues)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $Elements.Add($CloseButton.Button)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon) | Out-Null
   $Elements.Add($CloseButton.Icon)
}
function SystemInfoGet() {
   $Environment = @('COMPUTERNAME','USERDOMAIN','LOGONSERVER', 'USERNAME')
   $EnvironmentValues = @()
   foreach ($Variable in $Environment) {
      $EnvironmentValues += [System.Environment]::GetEnvironmentVariable($Variable)
   }
   $UserID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
   $UserPrincipal = New-Object System.Security.Principal.WindowsPrincipal($UserID)
   $UserPrincipal = $UserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
   $EnvironmentValues += $UserPrincipal
   $OS = Get-CimInstance Win32_OperatingSystem
   $EnvironmentValues += $OS.Caption
   $EnvironmentValues += $OS.OSArchitecture
   $EnvironmentValues += @{1='Workstation';2='Domain Controller';3='Server'}[[int]$OS.ProductType]
   $EnvironmentValues += ((Get-Date) - $OS.LastBootUpTime).ToString("d'd 'h'h 'm'm'")
   $NetworkValues = @()
   Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
   $NetworkValues += $_.Description
   $NetworkValues += $_.MACAddress
   $NetworkValues += ($_.IPAddress | Where-Object { $_ -notmatch ':' }) -join ', '
   }
   $CPUValues = @()
   Get-CimInstance Win32_Processor | ForEach-Object {
   $CPUValues += $_.Name.Trim()
   $CPUValues += @{0='x86';1='MIPS';2='Alpha';3='PowerPC';5='ARM';6='ia64';9='x64'}[[int]$_.Architecture]
   $CPUValues += $_.NumberOfCores
   $CPUValues += $_.NumberOfLogicalProcessors
   }
   $GPUValues = @()
   Get-CimInstance Win32_VideoController | ForEach-Object {
   $GPUValues += $_.Name
   $GPUValues += $_.DriverVersion
   }
   $RAMValues = @()
   Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
   $RAMValues += $_.DeviceLocator
   $RAMValues += [math]::Round($_.Capacity / 1GB, 1)
   $RAMValues += $_.Speed
   }
   return $EnvironmentValues, $NetworkValues, $CPUValues, $GPUValues, $RAMValues
}
function UpdateRun($AppList) {
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Update Run"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "______________________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Windows Updates"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window  | Out-Null
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:UpdateRunWindowsUpdate} -TaskName "Windows Updates"
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  -RemoveLast -Replace | Out-Null
   Window  | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         Window | Out-Null
      }
   }
   RichTextBox $SystemWindowsControlsRichTextBox0 "______________________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Application Updates"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window | Out-Null
   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:UpdateRunWinget} -Parameter $AppList -TaskName "App Updates"
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  -RemoveLast -Replace | Out-Null
   Window  | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         Window | Out-Null
      }
   }
   RichTextBox $SystemWindowsControlsRichTextBox0 "______________________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "ReScan"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window | Out-Null
   try {
      $Result = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:WindowsUpdateGetStatus} -TaskName "ReSCAN Windows Update"
      if ($Result -eq 0) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReSCAN Windows Update                | No Windows Updates available" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox1 "No Windows Updates available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
         Window | Out-Null
      } elseif ($Result -eq 1) {
         $RebootFlag = $true
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReSCAN Windows Update                | No Windows Updates available - Reboot Required" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox1 "No Windows Updates available - Reboot Required" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
         Window | Out-Null
      } else {
         RichTextBox $SystemWindowsControlsRichTextBox1 $Result -Clear | Out-Null
         Window | Out-Null
      }
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReSCAN Windows Update                | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      Window | Out-Null
   }
   try {
      $Result = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:AppGetStatus} -TaskName "ReSCAN Winget"
      $Result2 = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:AppGetApplist} -TaskName "PreSCAN Winget Applist"
      $AppList = $Result2
      if ($null -eq $AppList -or $AppList.Count -eq 0) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReSCAN Winget                        | No Updates for Apps available" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox2 "No Updates for Apps available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
         Window | Out-Null
      } else {
         RichTextBox $SystemWindowsControlsRichTextBox2 $Result -Clear | Out-Null
         Window | Out-Null
      }
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReSCAN Winget                        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
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
}
function AutomationActivate() {
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Activate Automation"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "______________________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "!!! if you move the CoreForge Folder please reactivate Automation !!!"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "This starts and runs CoreForge at your first Login of the Day"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Updates will be downloaded and installed automatically"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "You can still launch in non automated Mode through CoreForge.exe"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window  | Out-Null
   $MainScriptPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\main.ps1"))
   $TaskName = "CoreForge_Automation";
   $TaskUser = "$env:USERDOMAIN\$env:USERNAME";
   $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn;
   $TaskTrigger.UserId = $TaskUser;
   $TaskTrigger.Delay = "PT0M";
   $MainScriptPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\main.ps1"))
   $TaskAction = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-ExecutionPolicy Bypass -File `"$MainScriptPath`" -WindowStyle Hidden";
   $TaskPrincipal = New-ScheduledTaskPrincipal -UserId $TaskUser -LogonType Interactive -RunLevel Highest;
   $TaskSettings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopOnIdleEnd;
   Register-ScheduledTask -TaskName $TaskName -Trigger $TaskTrigger -Action $TaskAction -Principal $TaskPrincipal -Settings $TaskSettings;
   RichTextBox $SystemWindowsControlsRichTextBox0 "Automation Activated" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window  | Out-Null
   
}
function AutomationDeactivate() {
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Deactivate Automation"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "______________________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window  | Out-Null
   Unregister-ScheduledTask -TaskName "CoreForge_Automation" -Confirm:$false
   RichTextBox $SystemWindowsControlsRichTextBox0 "Automation Deactivated" -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window  | Out-Null
}