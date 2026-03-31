function System(){
   $SystemWindowsWindow = New-Object System.Windows.Window
   $SystemWindowsWindow.WindowStyle = "None"
   $SystemWindowsWindow.AllowsTransparency = $true
   $SystemWindowsWindow.Background = "Transparent"
   $SystemWindowsWindow.ResizeMode = "NoResize"
   $SystemWindowsWindow.Topmost = $false
   $SystemWindowsWindow.Width = 1350
   $SystemWindowsWindow.Height = 750
   $ScreenParameter = [System.Windows.SystemParameters]
   $SystemWindowsWindow.Left = ($ScreenParameter::PrimaryScreenWidth - 900) / 2
   $SystemWindowsWindow.Top = ($ScreenParameter::PrimaryScreenHeight * 0.30) - (500 / 2)

   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BackgroundSystem.png")))
   $Background.Width = 900
   $Background.Height = 500

   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSmall.png")))
   $Logo.Width = 44
   $Logo.Height = 44

   $SignCheckAutomation = @{
      Box = New-Object System.Windows.Controls.Image
      Text   = New-Object System.Windows.Controls.Image
   }
   $SignCheckAutomation.Box.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationCheck.png")))
   $SignCheckAutomation.Box.Width = 110
   $SignCheckAutomation.Box.Height = 30
   $SignCheckAutomation.Text.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarAutomationCheckText.png")))
   $SignCheckAutomation.Text.Width = 94
   $SignCheckAutomation.Text.Height = 18

   $DragBarImage = New-Object System.Windows.Controls.Image
   $DragBarImage.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\DragBar.png")))
   $DragBarImage.Width = 900
   $DragBarImage.Height = 40
   $DragBarImage.Add_MouseLeftButtonDown({
      [System.Windows.Window]::GetWindow($args[0]).DragMove()
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
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $InfoButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Icon.IsMouseOver) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
         if (-not $this.Tag.Active) {
            SystemInfo $SystemWindowsControlsCanvas $this.Tag
         }
         $this.Tag.Active = $true
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
    }
   })
   $InfoButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $InfoButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver -or $this.Tag.Button.IsMouseOver) {
         $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfoPressed.png")))
         if (-not $this.Tag.Active) {
            SystemInfo $SystemWindowsControlsCanvas $this.Tag
         }
         $this.Tag.Active = $true
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconSystemInfo.png")))
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

   
   
   [System.Windows.Controls.Canvas]::SetLeft($Background, 0)
   [System.Windows.Controls.Canvas]::SetTop($Background, 250)
   [System.Windows.Controls.Canvas]::SetLeft($Logo, 0)
   [System.Windows.Controls.Canvas]::SetTop($Logo, 255)
   [System.Windows.Controls.Canvas]::SetLeft($SignCheckAutomation.Box, 50)
   [System.Windows.Controls.Canvas]::SetTop($SignCheckAutomation.Box, 260)
   [System.Windows.Controls.Canvas]::SetLeft($SignCheckAutomation.Text, 60)
   [System.Windows.Controls.Canvas]::SetTop($SignCheckAutomation.Text, 265)
   [System.Windows.Controls.Canvas]::SetLeft($DragBarImage, 0)
   [System.Windows.Controls.Canvas]::SetTop($DragBarImage, 250)
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
   
   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   $SystemWindowsWindow.Content = $SystemWindowsControlsCanvas
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SignCheckAutomation.Box) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SignCheckAutomation.Text) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($DragBarImage) | Out-Null
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
   

   $SystemWindowsWindow.Show()
   return $SystemWindowsWindow, $SystemWindowsControlsCanvas, $UpdateNowButton, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2
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
function SystemInfo($SystemWindowsControlsCanvas, $InfoButton) {

 
   $Elements = [System.Collections.Generic.List[System.Windows.UIElement]]::new()


   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BackgroundSystemInfo.png")))
   $Background.Width = 900
   $Background.Height = 250


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


   

   [System.Windows.Controls.Canvas]::SetLeft($Background, 0)
   [System.Windows.Controls.Canvas]::SetTop($Background, 0)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 860)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 10)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 864)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 14)
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $Elements.Add($Background)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $Elements.Add($CloseButton.Button)
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon) | Out-Null
   $Elements.Add($CloseButton.Icon)


}
function UpdateRun($AppList) {
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "Update Run"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "_________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window  | Out-Null

   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:UpdateRunWindowsUpdate} -TaskName "Windows Updates"
   RichTextBox $SystemWindowsControlsRichTextBox0 ">> Windows Update                       | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
         Window | Out-Null
      }
   }

   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window | Out-Null

   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:UpdateRunWinget} -Parameter $AppList -TaskName "App Updates"
   RichTextBox $SystemWindowsControlsRichTextBox0 ">> App Update                           | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 ">> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
         Window | Out-Null
      }
   }

   RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
   Window | Out-Null
   try {
      $Result = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:ListWindowsUpdate} -TaskName "ReScan"
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
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReScan                               | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReScan                               | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
      Window | Out-Null
   }

   RichTextBox $SystemWindowsControlsRichTextBox0 "" | Out-Null
   Window | Out-Null
   try {
      $Result = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:ListWinget} -TaskName "ReScan"
      $Result2 = Thread {
         param($Function, $Parameter)
         $FunctionBlock = [scriptblock]::Create($Function)
         & $FunctionBlock $Parameter
      } -ThreadPool $ThreadPool -Function ${function:ListWingetApps} -TaskName "ReScan"
      if ($null -eq $Result2 -or $Result2.Count -eq 0) {
         RichTextBox $SystemWindowsControlsRichTextBox2 "No Updates for Apps available" -Clear -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
         Window | Out-Null
      } else {
         RichTextBox $SystemWindowsControlsRichTextBox2 $Result -Clear | Out-Null
         Window | Out-Null
      }
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReScan                               | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 ">> ReScan                               | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
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
