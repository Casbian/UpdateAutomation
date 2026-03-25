function Home(){
   $SystemWindowsWindow = New-Object System.Windows.Window
   $SystemWindowsWindow.WindowStyle = "None"
   $SystemWindowsWindow.AllowsTransparency = $true
   $SystemWindowsWindow.Background = "Transparent"
   $SystemWindowsWindow.ResizeMode = "NoResize"
   $SystemWindowsWindow.Topmost = $false
   $SystemWindowsWindow.Width = 900
   $SystemWindowsWindow.Height = 500
   $ScreenParameter = [System.Windows.SystemParameters]
   $SystemWindowsWindow.Left = ($ScreenParameter::PrimaryScreenWidth - 900) / 2
   $SystemWindowsWindow.Top = ($ScreenParameter::PrimaryScreenHeight * 0.45) - (500 / 2)
   $SystemWindowsWindow.Icon = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Icon.ico")))

   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Background.png")))
   $Background.Width = 900
   $Background.Height = 500

   $DragBarImage = New-Object System.Windows.Controls.Image
   $DragBarImage.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\DragBar.png")))
   $DragBarImage.Width = 900
   $DragBarImage.Height = 40
   $DragBarImage.Add_MouseLeftButtonDown({
      [System.Windows.Window]::GetWindow($args[0]).DragMove()
   })

   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\LogoSmallWhite.png")))
   $Logo.Width = 44
   $Logo.Height = 44

   $SystemWindowsControlsRichTextBoxImage0 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage0.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\ConsoleBox.png")))
   $SystemWindowsControlsRichTextBoxImage0.Width = 760
   $SystemWindowsControlsRichTextBoxImage0.Height = 310
  
   $SystemWindowsControlsRichTextBox0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox0.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox0.FontSize = 10
   $SystemWindowsControlsRichTextBox0.Width = 760
   $SystemWindowsControlsRichTextBox0.Height = 290
   $SystemWindowsControlsRichTextBox0.BorderThickness = 0
   $SystemWindowsControlsRichTextBox0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox0.Foreground = [System.Windows.Media.Brushes]::White
  
   $SystemWindowsControlsRichTextBoxImage1 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage1.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\WindowsUpdateBox.png")))
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
   $SystemWindowsControlsRichTextBoxImage2.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\AppUpdateBox.png")))
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

   $HomeButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $HomeButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarActiveHover.png")))
   $HomeButton.Button.Width = 30
   $HomeButton.Button.Height = 30
   $HomeButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\HomePressed.png")))
   $HomeButton.Icon.Width = 14
   $HomeButton.Icon.Height = 14
   $HomeButton.Button.Tag = $HomeButton
   $HomeButton.Icon.Tag   = $HomeButton

   $SignCheckAutomation = @{
      Box = New-Object System.Windows.Controls.Image
      Text   = New-Object System.Windows.Controls.Image
   }
   $SignCheckAutomation.Box.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\SignCheckAutomation.png")))
   $SignCheckAutomation.Box.Width = 110
   $SignCheckAutomation.Box.Height = 30
   $SignCheckAutomation.Text.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\SignCheckAutomationText.png")))
   $SignCheckAutomation.Text.Width = 94
   $SignCheckAutomation.Text.Height = 18

   $SettingsButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $SettingsButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $SettingsButton.Button.Width = 30
   $SettingsButton.Button.Height = 30
   $SettingsButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Settings.png")))
   $SettingsButton.Icon.Width = 18
   $SettingsButton.Icon.Height = 18
   $SettingsButton.Button.Tag = $SettingsButton
   $SettingsButton.Icon.Tag   = $SettingsButton
   $SettingsButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\SettingsHover.png")))
   })
   $SettingsButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Settings.png")))
   })
   $SettingsButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\SettingsHover.png")))
   })
   $SettingsButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Settings.png")))
   })

   $CloseButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $CloseButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
   $CloseButton.Button.Width = 30
   $CloseButton.Button.Height = 30
   $CloseButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Close.png")))
   $CloseButton.Icon.Width = 22
   $CloseButton.Icon.Height = 22
   $CloseButton.Button.Tag = $CloseButton
   $CloseButton.Icon.Tag   = $CloseButton
   $CloseButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\CloseHover.png")))
   })
   $CloseButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Close.png")))
   })
   $CloseButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\CloseHover.png")))
   })
   $CloseButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Close.png")))
   })
   $CloseButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\ClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         [System.Windows.Window]::GetWindow($this).Close()
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Close.png")))
    }
   })
   $CloseButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\ClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         [System.Windows.Window]::GetWindow($this).Close()
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Close.png")))
    }
   })
   
   [System.Windows.Controls.Canvas]::SetLeft($Background, 0)
   [System.Windows.Controls.Canvas]::SetTop($Background, 0)
   [System.Windows.Controls.Canvas]::SetLeft($DragBarImage, 0)
   [System.Windows.Controls.Canvas]::SetTop($DragBarImage, 0)
   [System.Windows.Controls.Canvas]::SetLeft($Logo, 0)
   [System.Windows.Controls.Canvas]::SetTop($Logo, 5)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage0, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage0, 50)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox0, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox0, 60)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage1, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage1, 370)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox1, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox1, 380)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage2, 430)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage2, 370)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox2, 435)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox2, 380)
   [System.Windows.Controls.Canvas]::SetLeft($HomeButton.Button, 780)
   [System.Windows.Controls.Canvas]::SetTop($HomeButton.Button, 10)
   [System.Windows.Controls.Canvas]::SetLeft($HomeButton.Icon, 788)
   [System.Windows.Controls.Canvas]::SetTop($HomeButton.Icon, 18)
   [System.Windows.Controls.Canvas]::SetLeft($SignCheckAutomation.Box, 780)
   [System.Windows.Controls.Canvas]::SetTop($SignCheckAutomation.Box, 50)
   [System.Windows.Controls.Canvas]::SetLeft($SignCheckAutomation.Text, 790)
   [System.Windows.Controls.Canvas]::SetTop($SignCheckAutomation.Text, 55)
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Button, 820)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Button, 10)
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Icon, 826)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Icon, 16)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 860)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 10)
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 864)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 14)

   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($DragBarImage) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage0) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox0) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage1) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox1) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage2) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox2) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($HomeButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($HomeButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SignCheckAutomation.Box) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SignCheckAutomation.Text) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon) | Out-Null
   $SystemWindowsWindow.Content = $SystemWindowsControlsCanvas

   $SystemWindowsWindow.Show()
   return $SystemWindowsWindow, $SystemWindowsControlsCanvas, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2
}
function HomeUpdateButton($SystemWindowsControlsCanvas, $AppList) {
   $UpdateNowButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon = New-Object System.Windows.Controls.Image
      Text = New-Object System.Windows.Controls.Image
   }
   $UpdateNowButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
   $UpdateNowButton.Button.Width = 110
   $UpdateNowButton.Button.Height = 30
   $UpdateNowButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
   $UpdateNowButton.Icon.Width = 18
   $UpdateNowButton.Icon.Height = 18
   $UpdateNowButton.Text.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))
   $UpdateNowButton.Text.Width = 46
   $UpdateNowButton.Text.Height = 19
   $UpdateNowButton.Button.Tag = $UpdateNowButton
   $UpdateNowButton.Icon.Tag   = $UpdateNowButton
   $UpdateNowButton.Text.Tag = $UpdateNowButton
   $UpdateNowButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconHover.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonTextHover.png")))
   })
   $UpdateNowButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))
   })
   $UpdateNowButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconHover.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonTextHover.png")))
   })
   $UpdateNowButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))
   })
   $UpdateNowButton.Text.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconHover.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonTextHover.png")))
   })
   $UpdateNowButton.Text.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))
   })
   $UpdateNowButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconPressed.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonTextPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $UpdateNowButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))  
         StartUpdateRun $AppList
      } else {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))  
    }
   })
   $UpdateNowButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconPressed.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png"))) 
      $this.CaptureMouse() | Out-Null
   })
   $UpdateNowButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))  
         StartUpdateRun $AppList    
      } else {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))  
    }
   })
   $UpdateNowButton.Text.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIconPressed.png")))
      $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonTextPressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $UpdateNowButton.Text.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))  
         StartUpdateRun $AppList
      } else {
         $this.Tag.Button.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButton.png")))
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonIcon.png")))
         $this.Tag.Text.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateButtonText.png")))
    }
   })

   [System.Windows.Controls.Canvas]::SetLeft($UpdateNowButton.Button, 780)
   [System.Windows.Controls.Canvas]::SetTop($UpdateNowButton.Button, 90)
   [System.Windows.Controls.Canvas]::SetLeft($UpdateNowButton.Icon, 790)
   [System.Windows.Controls.Canvas]::SetTop($UpdateNowButton.Icon, 95)
   [System.Windows.Controls.Canvas]::SetLeft($UpdateNowButton.Text, 820)
   [System.Windows.Controls.Canvas]::SetTop($UpdateNowButton.Text, 96)

   $SystemWindowsControlsCanvas.Children.Add($UpdateNowButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($UpdateNowButton.Icon) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($UpdateNowButton.Text) | Out-Null
}
function StartUpdateRun($AppList) {
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "‎  Update Run"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 "_________________________________________________________________"  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   RichTextBox $SystemWindowsControlsRichTextBox0 ""  | Out-Null
   Window  | Out-Null

   $Result = Thread {
      param($Function, $Parameter)
      $FunctionBlock = [scriptblock]::Create($Function)
      & $FunctionBlock $Parameter
   } -ThreadPool $ThreadPool -Function ${function:UpdateRunWindowsUpdate} -TaskName "Windows Updates"
   
   RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | Windows Update | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 "> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
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

   RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | App Update     | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
   Window | Out-Null
   $Lines = $Result -split "`r?`n"
   foreach ($Line in $Lines) {
      if (-not [string]::IsNullOrWhiteSpace($Line)) {
         RichTextBox $SystemWindowsControlsRichTextBox0 "> $($Line.Trim())" -Color ([System.Windows.Media.Brushes]::Cyan) | Out-Null
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
      RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | ReScan         | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | ReScan         | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
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
      RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | ReScan         | ✓" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen) | Out-Null
      Window | Out-Null
   } catch {
      RichTextBox $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | ReScan         | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red) | Out-Null
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