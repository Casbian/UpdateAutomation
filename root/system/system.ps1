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
function SystemGetAdapterValues() {
   $Environment = @('USERNAME','COMPUTERNAME','USERDOMAIN','LOGONSERVER')
   $SystemAdapterValues = @()
   foreach ($Variable in $Environment) {
      $SystemAdapterValues += [System.Environment]::GetEnvironmentVariable($Variable)
   }
   $UserID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
   $UserPrincipal = New-Object System.Security.Principal.WindowsPrincipal($UserID)
   $UserPrincipal = $UserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
   if ($UserPrincipal) {
      $SystemAdapterValues += "Administrator"
   }
   $OS = Get-CimInstance Win32_OperatingSystem
   $SystemAdapterValues += $OS.Caption
   $SystemAdapterValues += $OS.OSArchitecture
   $SystemAdapterValues += @{1='Workstation';2='Domain Controller';3='Server'}[[int]$OS.ProductType]
   $SystemAdapterValues += ((Get-Date) - $OS.LastBootUpTime).ToString("d'd 'h'h 'm'm'")
   return $SystemAdapterValues
}
function System($MyInvocation){
   #═════════════════════════════════════════════════════════════
   # Main Window
   #═════════════════════════════════════════════════════════════
   $SystemWindowsWindow = New-Object System.Windows.Window
   $SystemWindowsWindow.Topmost = $false
   $SystemWindowsWindow.WindowStyle = "None"
   $SystemWindowsWindow.ResizeMode = "NoResize"
   $SystemWindowsWindow.AllowsTransparency = $true
   $SystemWindowsWindow.Width = 1060
   $SystemWindowsWindow.Height = 800
   $ScreenParameter = [System.Windows.SystemParameters]
   $SystemWindowsWindow.Left = ($ScreenParameter::PrimaryScreenWidth - 1060) / 2
   $SystemWindowsWindow.Top = ($ScreenParameter::PrimaryScreenHeight - 800) / 2
   $SystemWindowsWindow.Title = "CoreForge"
   $SystemWindowsWindow.Background = [System.Windows.Media.Brushes]::Transparent
   $FontPathIBMPlexMono = ((Join-Path $PSScriptRoot "..\font\#IBM Plex Mono"))
   #═════════════════════════════════════════════════════════════
   # Main Backdrop Border
   #═════════════════════════════════════════════════════════════
   $SystemWindowsControlsBorder = New-Object System.Windows.Controls.Border
   $SystemWindowsControlsBorder.Width = 1060
   $SystemWindowsControlsBorder.Height = 800
   $SystemWindowsControlsBorder.CornerRadius = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   $SystemWindowsControlsBorder.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   #═════════════════════════════════════════════════════════════
   # Main Canvas
   #═════════════════════════════════════════════════════════════
   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   $SystemWindowsControlsCanvas.Width = 1060
   $SystemWindowsControlsCanvas.Height = 800
   $SystemWindowsControlsCanvas.Background = [System.Windows.Media.Brushes]::Transparent
   #═════════════════════════════════════════════════════════════
   # Main Container Setup
   #═════════════════════════════════════════════════════════════
   $SystemWindowsControlsBorder.Child = $SystemWindowsControlsCanvas
   $SystemWindowsWindow.Content = $SystemWindowsControlsBorder
   #═════════════════════════════════════════════════════════════
   # Drag Bar Setup
   #═════════════════════════════════════════════════════════════
   $DragBar = New-Object System.Windows.Controls.Border
   $DragBar.Width = 1060
   $DragBar.Height = 40
   $DragBar.CornerRadius = New-Object System.Windows.CornerRadius(5, 5, 0, 0)
   $DragBar.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
   $DragBar.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $DragBar.BorderThickness = [System.Windows.Thickness]::new(0, 0, 0, 1)
   $DragBar.Add_MouseLeftButtonDown({
      $SystemWindowsWindow.DragMove()
   })
   #═════════════════════════════════════════════════════════════
   # Logo Setup
   #═════════════════════════════════════════════════════════════
   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\Logo.png")))
   $Logo.Width = 156
   $Logo.Height = 40
   #═════════════════════════════════════════════════════════════
   # Button Info Setup
   #═════════════════════════════════════════════════════════════
   $ButtonInfoPopup = New-Object System.Windows.Controls.Border
   $ButtonInfoPopup.Width = 110
   $ButtonInfoPopup.Height = 15
   $ButtonInfoPopup.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#323232")
   $ButtonInfoPopup.CornerRadius = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   $ButtonInfoPopup.Visibility = "Collapsed"
   
   $SystemWindowsControlsRichTextBoxButtonInfoPopup = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.FontSize = 10
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.Width = 110
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.Height = 15
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxButtonInfoPopup.SetValue([System.Windows.UIElement]::FocusableProperty, $false)

   $ButtonInfoPopup.Child = $SystemWindowsControlsRichTextBoxButtonInfoPopup

   $ButtonInfo = @{
      ButtonMain = New-Object System.Windows.Controls.Button
      Active  = $false
      ButtonInfoPopup = $ButtonInfoPopup
      SystemWindowsControlsRichTextBoxButtonInfoPopup = $SystemWindowsControlsRichTextBoxButtonInfoPopup
   }
   $ButtonInfo.ButtonMain.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonInfo.ButtonMain.Cursor = [System.Windows.Input.Cursors]::Arrow
   $ButtonInfo.ButtonMain.Width = 15
   $ButtonInfo.ButtonMain.Height = 15
   $ButtonInfo.ButtonMain.Content = "i"
   $ButtonInfo.ButtonMain.FontSize = 10
   $ButtonInfo.ButtonMain.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $ButtonInfo.ButtonMain.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonInfo.ButtonMain.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonInfo.ButtonMain.Tag = $ButtonInfo
   $ButtonInfo.ButtonMain.Add_Click({
      if ($this.Tag.ButtonInfoPopup.Visibility -eq [System.Windows.Visibility]::Collapsed) {
         $this.Tag.ButtonInfoPopup.Visibility = [System.Windows.Visibility]::Visible
      } else {
         $this.Tag.ButtonInfoPopup.Visibility = [System.Windows.Visibility]::Collapsed
      }
   })
   #═════════════════════════════════════════════════════════════
   # Button Close Setup
   #═════════════════════════════════════════════════════════════
   $ButtonClose = New-Object System.Windows.Controls.Button
   $ButtonClose.BorderThickness = New-Object System.Windows.Thickness(0)
   $ButtonClose.Cursor = [System.Windows.Input.Cursors]::Arrow
   $ButtonClose.Width = 25
   $ButtonClose.Height = 25
   $ButtonClose.Content = "✕"
   $ButtonClose.FontSize = 15
   $ButtonClose.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $ButtonClose.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonClose.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonClose.Add_Click({
      $WindowsUpdateRebootNeeded = Get-WURebootStatus -Silent
      if ($WindowsUpdateRebootNeeded -eq $true) {
         $ResultQuestion = [System.Windows.MessageBox]::Show(
         "Your System will needs a Reboot`nIt will be triggered on application exit.",
         "Reboot NOW ?",
         "YesNo",
         "Question"
         )
         if ($ResultQuestion -eq "No") {
            return
         }
         $SystemWindowsWindow.Close()
         $ThreadPool.Close()
         $ThreadPool.Dispose()
         Restart-Computer
      }
      $SystemWindowsWindow.Close()
      $ThreadPool.Close()
      $ThreadPool.Dispose()
      exit
   })
   #═════════════════════════════════════════════════════════════
   # Side Bar Setup
   #═════════════════════════════════════════════════════════════
   $SideBar = New-Object System.Windows.Shapes.Rectangle
   $SideBar.Width = 249
   $SideBar.Height = 740
   $SideBar.Fill = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")

   $SideBarDivider = New-Object System.Windows.Controls.Border
   $SideBarDivider.Width           = 250
   $SideBarDivider.Height          = 740
   $SideBarDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $SideBarDivider.BorderThickness = [System.Windows.Thickness]::new(0, 0, 1, 0)
   $SideBarDivider.Background      = [System.Windows.Media.Brushes]::Transparent
   
   $SystemWindowsControlsRichTextBoxSideBarSystemSection = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.FontSize = 14
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.Width = 249
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.Height = 30
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxSideBarSystemSection.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   
   $ButtonDashboard = New-Object System.Windows.Controls.Button
   $ButtonDashboard.Content = "Dashboard"
   $ButtonDashboard.Width = 249
   $ButtonDashboard.Height = 30
   $ButtonDashboard.FontSize = 12
   $ButtonDashboard.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $ButtonDashboard.HorizontalContentAlignment = "Center"
   $ButtonDashboard.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#323232")
   $ButtonDashboard.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonDashboard.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $ButtonDashboard.Cursor = [System.Windows.Input.Cursors]::Arrow
   
   $ButtonUpdates = New-Object System.Windows.Controls.Button
   $ButtonUpdates.Content = "Updates"
   $ButtonUpdates.Width = 249
   $ButtonUpdates.Height = 30
   $ButtonUpdates.FontSize = 12
   $ButtonUpdates.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $ButtonUpdates.HorizontalContentAlignment = "Center"
   $ButtonUpdates.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonUpdates.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonUpdates.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonUpdates.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $ButtonUpdates.Cursor = [System.Windows.Input.Cursors]::Arrow

   $SystemWindowsControlsRichTextBoxSideBarAutomationSection = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.FontSize = 14
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.Width = 249
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.Height = 30
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxSideBarAutomationSection.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   
   $ButtonAutomation = New-Object System.Windows.Controls.Button
   $ButtonAutomation.Content = "Automation"
   $ButtonAutomation.Width = 249
   $ButtonAutomation.Height = 30
   $ButtonAutomation.FontSize = 12
   $ButtonAutomation.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $ButtonAutomation.HorizontalContentAlignment = "Center"
   $ButtonAutomation.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonAutomation.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
   $ButtonAutomation.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $ButtonAutomation.BorderThickness = New-Object System.Windows.Thickness(2, 0, 0, 0)
   $ButtonAutomation.Cursor = [System.Windows.Input.Cursors]::Arrow

   

  
   #═════════════════════════════════════════════════════════════
   # Page Dashboard Setup
   #═════════════════════════════════════════════════════════════

   $PageDashboard = New-Object System.Windows.Controls.Canvas
   $PageDashboard.Width = 810
   $PageDashboard.Height = 740
   $PageDashboard.Visibility = "Visible"
   $PageDashboard.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")

   $PageDashboardNetworkDivider = New-Object System.Windows.Controls.Border
   $PageDashboardNetworkDivider.Width           = 190
   $PageDashboardNetworkDivider.Height          = 125
   $PageDashboardNetworkDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardNetworkDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardNetworkDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardNetworkDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardNetworkDivider, 10)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardNetworkDivider, 10)
   $PageDashboard.Children.Add($PageDashboardNetworkDivider) | Out-Null

   $PageDashboardNetworkIcon = New-Object System.Windows.Controls.Image
   $PageDashboardNetworkIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconNetwork.png")))
   $PageDashboardNetworkIcon.Width = 30
   $PageDashboardNetworkIcon.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardNetworkIcon, 160)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardNetworkIcon, 20)
   $PageDashboard.Children.Add($PageDashboardNetworkIcon) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.Height = 105
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardNetwork0, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardNetwork0, 20)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardNetwork0) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardNetwork1, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardNetwork1, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.Height = 85
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardNetwork1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardNetwork1, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardNetwork1, 40)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardNetwork1) | Out-Null

   $PageDashboardGPUDivider = New-Object System.Windows.Controls.Border
   $PageDashboardGPUDivider.Width           = 190
   $PageDashboardGPUDivider.Height          = 125
   $PageDashboardGPUDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardGPUDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardGPUDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardGPUDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardGPUDivider, 210)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardGPUDivider, 10)
   $PageDashboard.Children.Add($PageDashboardGPUDivider) | Out-Null

   $PageDashboardGPUIcon = New-Object System.Windows.Controls.Image
   $PageDashboardGPUIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconGPU.png")))
   $PageDashboardGPUIcon.Width = 30
   $PageDashboardGPUIcon.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardGPUIcon, 360)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardGPUIcon, 20)
   $PageDashboard.Children.Add($PageDashboardGPUIcon) | Out-Null
   
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.Height = 105
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardGPU0, 220)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardGPU0, 20)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardGPU0) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardGPU1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardGPU1, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardGPU1, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.Height = 85
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardGPU1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardGPU1, 220)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardGPU1, 40)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardGPU1) | Out-Null

   $PageDashboardCPUDivider = New-Object System.Windows.Controls.Border
   $PageDashboardCPUDivider.Width           = 190
   $PageDashboardCPUDivider.Height          = 125
   $PageDashboardCPUDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardCPUDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardCPUDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardCPUDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardCPUDivider, 410)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardCPUDivider, 10)
   $PageDashboard.Children.Add($PageDashboardCPUDivider) | Out-Null

   $PageDashboardCPUIcon = New-Object System.Windows.Controls.Image
   $PageDashboardCPUIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconCPU.png")))
   $PageDashboardCPUIcon.Width = 30
   $PageDashboardCPUIcon.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardCPUIcon, 560)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardCPUIcon, 20)
   $PageDashboard.Children.Add($PageDashboardCPUIcon) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardCPU0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.Height = 105
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardCPU0, 420)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardCPU0, 20)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardCPU0) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardCPU1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardCPU1, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardCPU1, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.Width = 170
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.Height = 85
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardCPU1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardCPU1, 420)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardCPU1, 40)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardCPU1) | Out-Null

   $PageDashboardRAMDivider = New-Object System.Windows.Controls.Border
   $PageDashboardRAMDivider.Width           = 190
   $PageDashboardRAMDivider.Height          = 125
   $PageDashboardRAMDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardRAMDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardRAMDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardRAMDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardRAMDivider, 610)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardRAMDivider, 10)
   $PageDashboard.Children.Add($PageDashboardRAMDivider) | Out-Null

   $PageDashboardRAMIcon = New-Object System.Windows.Controls.Image
   $PageDashboardRAMIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\IconRAM.png")))
   $PageDashboardRAMIcon.Width = 30
   $PageDashboardRAMIcon.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardRAMIcon, 760)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardRAMIcon, 20)
   $PageDashboard.Children.Add($PageDashboardRAMIcon) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardRAM0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.Width = 160
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.Height = 105
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardRAM0, 620)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardRAM0, 20)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardRAM0) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardRAM1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardRAM1, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardRAM1, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.Width = 80
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.Height = 85
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardRAM1, 620)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardRAM1, 40)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardRAM1) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardRAM2 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardRAM2, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardRAM2, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.Width = 80
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.Height = 85
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardRAM2.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardRAM2, 700)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardRAM2, 40)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardRAM2) | Out-Null

   $PageDashboardLogBarDivider = New-Object System.Windows.Controls.Border
   $PageDashboardLogBarDivider.Width           = 390
   $PageDashboardLogBarDivider.Height          = 35
   $PageDashboardLogBarDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardLogBarDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardLogBarDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardLogBarDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardLogBarDivider, 10)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardLogBarDivider, 145)
   $PageDashboard.Children.Add($PageDashboardLogBarDivider) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardLogBar = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.Width = 190
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.Height = 40
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardLogBar.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardLogBar, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardLogBar, 150)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardLogBar) | Out-Null

   $PageDashboardLogDivider = New-Object System.Windows.Controls.Border
   $PageDashboardLogDivider.Width           = 390
   $PageDashboardLogDivider.Height          = 425
   $PageDashboardLogDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardLogDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardLogDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardLogDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardLogDivider, 10)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardLogDivider, 190)
   $PageDashboard.Children.Add($PageDashboardLogDivider) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardLog = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardLog.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardLog, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardLog, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardLog.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardLog.Width = 370
   $SystemWindowsControlsRichTextBoxPageDashboardLog.Height = 405
   $SystemWindowsControlsRichTextBoxPageDashboardLog.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardLog.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardLog.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardLog.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardLog.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardLog.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardLog.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardLog.LayoutTransform = New-Object System.Windows.Media.ScaleTransform(1, -1)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardLog, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardLog, 200)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardLog) | Out-Null

   $PageDashboardTaskBarDivider = New-Object System.Windows.Controls.Border
   $PageDashboardTaskBarDivider.Width           = 390
   $PageDashboardTaskBarDivider.Height          = 35
   $PageDashboardTaskBarDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardTaskBarDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardTaskBarDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardTaskBarDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardTaskBarDivider, 410)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardTaskBarDivider, 145)
   $PageDashboard.Children.Add($PageDashboardTaskBarDivider) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.Width = 190
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.Height = 35
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardTaskBar.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardTaskBar, 420)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardTaskBar, 150)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardTaskBar) | Out-Null

   $PageDashboardTaskDivider = New-Object System.Windows.Controls.Border
   $PageDashboardTaskDivider.Width           = 390
   $PageDashboardTaskDivider.Height          = 425
   $PageDashboardTaskDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageDashboardTaskDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageDashboardTaskDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageDashboardTaskDivider.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboardTaskDivider, 410)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboardTaskDivider, 190)
   $PageDashboard.Children.Add($PageDashboardTaskDivider) | Out-Null

   $SystemWindowsControlsRichTextBoxPageDashboardTask = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageDashboardTask.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxPageDashboardTask, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxPageDashboardTask, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxPageDashboardTask.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageDashboardTask.Width = 370
   $SystemWindowsControlsRichTextBoxPageDashboardTask.Height = 405
   $SystemWindowsControlsRichTextBoxPageDashboardTask.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageDashboardTask.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageDashboardTask.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageDashboardTask.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageDashboardTask.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageDashboardTask.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageDashboardTask.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageDashboardTask, 420)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageDashboardTask, 200)
   $PageDashboard.Children.Add($SystemWindowsControlsRichTextBoxPageDashboardTask) | Out-Null







      
   
   #═════════════════════════════════════════════════════════════
   # Page Update Setup
   #═════════════════════════════════════════════════════════════
   $PageUpdate = New-Object System.Windows.Controls.Canvas
   $PageUpdate.Width = 810
   $PageUpdate.Height = 740
   $PageUpdate.Visibility = "Collapsed"
   $PageUpdate.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")


   $PageUpdateIconMainWindows = New-Object System.Windows.Controls.Image
   $PageUpdateIconMainWindows.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconWindowsMain.png")))
   $PageUpdateIconMainWindows.Width = 40
   $PageUpdateIconMainWindows.Height = 40
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateIconMainWindows, 20)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateIconMainWindows, 10)
   $PageUpdate.Children.Add($PageUpdateIconMainWindows) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.Width = 200
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.Height = 45
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0, 70)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0, 20)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0) | Out-Null

   $PageUpdateWindowsUpdateDivider1and2 = New-Object System.Windows.Controls.Border
   $PageUpdateWindowsUpdateDivider1and2.Width           = 300
   $PageUpdateWindowsUpdateDivider1and2.Height          = 40
   $PageUpdateWindowsUpdateDivider1and2.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageUpdateWindowsUpdateDivider1and2.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageUpdateWindowsUpdateDivider1and2.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageUpdateWindowsUpdateDivider1and2.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateWindowsUpdateDivider1and2, 500)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateWindowsUpdateDivider1and2, 10)
   $PageUpdate.Children.Add($PageUpdateWindowsUpdateDivider1and2) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.Width = 300
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1, 500)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1, 10)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.Width = 300
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2, 500)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2, 30)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2) | Out-Null

   $PageUpdateScrollViewerWindowsUpdate = New-Object System.Windows.Controls.ScrollViewer
   $PageUpdateScrollViewerWindowsUpdate.Width = 790
   $PageUpdateScrollViewerWindowsUpdate.Height = 200
   $PageUpdateScrollViewerWindowsUpdate.VerticalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Hidden
   $PageUpdateScrollViewerWindowsUpdate.HorizontalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Hidden
   $PageUpdateStackPanelWindowsUpdate = New-Object System.Windows.Controls.StackPanel
   $PageUpdateStackPanelWindowsUpdate.Orientation = [System.Windows.Controls.Orientation]::Vertical
   $PageUpdateScrollViewerWindowsUpdate.Content = $PageUpdateStackPanelWindowsUpdate
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateScrollViewerWindowsUpdate, 10)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateScrollViewerWindowsUpdate, 60)
   $PageUpdate.Children.Add($PageUpdateScrollViewerWindowsUpdate) | Out-Null



   


   $PageUpdateIconMainApp = New-Object System.Windows.Controls.Image
   $PageUpdateIconMainApp.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconAppMain.png")))
   $PageUpdateIconMainApp.Width = 40
   $PageUpdateIconMainApp.Height = 40
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateIconMainApp, 20)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateIconMainApp, 270)
   $PageUpdate.Children.Add($PageUpdateIconMainApp) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.Width = 200
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0, 70)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0, 280)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0) | Out-Null



   $PageUpdateAppUpdateDivider1and2 = New-Object System.Windows.Controls.Border
   $PageUpdateAppUpdateDivider1and2.Width           = 300
   $PageUpdateAppUpdateDivider1and2.Height          = 40
   $PageUpdateAppUpdateDivider1and2.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $PageUpdateAppUpdateDivider1and2.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
   $PageUpdateAppUpdateDivider1and2.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
   $PageUpdateAppUpdateDivider1and2.CornerRadius      = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateAppUpdateDivider1and2, 500)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateAppUpdateDivider1and2, 270)
   $PageUpdate.Children.Add($PageUpdateAppUpdateDivider1and2) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.Width = 300
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1, 500)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1, 270)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.FontSize = 12
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.Width = 300
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2, 500)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2, 290)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2) | Out-Null



   $PageUpdateScrollViewerAppUpdate = New-Object System.Windows.Controls.ScrollViewer
   $PageUpdateScrollViewerAppUpdate.Width = 790
   $PageUpdateScrollViewerAppUpdate.Height = 200
   $PageUpdateScrollViewerAppUpdate.VerticalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Hidden
   $PageUpdateScrollViewerAppUpdate.HorizontalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Hidden
   $PageUpdateStackPanelAppUpdate = New-Object System.Windows.Controls.StackPanel
   $PageUpdateStackPanelAppUpdate.Orientation = [System.Windows.Controls.Orientation]::Vertical
   $PageUpdateScrollViewerAppUpdate.Content = $PageUpdateStackPanelAppUpdate
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateScrollViewerAppUpdate, 10)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateScrollViewerAppUpdate, 320)
   $PageUpdate.Children.Add($PageUpdateScrollViewerAppUpdate) | Out-Null






   $PageUpdateIconMainGPU = New-Object System.Windows.Controls.Image
   $PageUpdateIconMainGPU.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconGPUMain.png")))
   $PageUpdateIconMainGPU.Width = 40
   $PageUpdateIconMainGPU.Height = 40
   [System.Windows.Controls.Canvas]::SetLeft($PageUpdateIconMainGPU, 20)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdateIconMainGPU, 530)
   $PageUpdate.Children.Add($PageUpdateIconMainGPU) | Out-Null

   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.FontFamily = New-Object System.Windows.Media.FontFamily('Consolas')
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.FontSize = 15
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.Width = 200
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.Height = 20
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0, 70)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0, 540)
   $PageUpdate.Children.Add($SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0) | Out-Null
   




   #═════════════════════════════════════════════════════════════
   # Page Automation Setup
   #═════════════════════════════════════════════════════════════
   
   $PageAutomation = New-Object System.Windows.Controls.Canvas
   $PageAutomation.Width = 810
   $PageAutomation.Height = 740
   $PageAutomation.Visibility = "Collapsed"
   $PageAutomation.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")

   


   
   




   #═════════════════════════════════════════════════════════════
   # Status Bar Setup
   #═════════════════════════════════════════════════════════════
   $StatusBar = New-Object System.Windows.Controls.Border
   $StatusBar.Width = 1060
   $StatusBar.Height = 20
   $StatusBar.CornerRadius = New-Object System.Windows.CornerRadius(0, 0, 5, 5)
   $StatusBar.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
   $StatusBar.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
   $StatusBar.BorderThickness = [System.Windows.Thickness]::new(0, 1, 0, 0)

   $SystemWindowsControlsCanvasStatusBar = New-Object System.Windows.Controls.Canvas
   $SystemWindowsControlsCanvasStatusBar.Width = 1060
   $SystemWindowsControlsCanvasStatusBar.Height = 20
   $SystemWindowsControlsCanvasStatusBar.Background = [System.Windows.Media.Brushes]::Transparent

   $StatusBar.Child = $SystemWindowsControlsCanvasStatusBar

   $SystemWindowsControlsRichTextBoxStatusBar0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxStatusBar0.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxStatusBar0, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxStatusBar0, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxStatusBar0.FontSize = 12
   $SystemWindowsControlsRichTextBoxStatusBar0.Width = 1060
   $SystemWindowsControlsRichTextBoxStatusBar0.Height = 20
   $SystemWindowsControlsRichTextBoxStatusBar0.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxStatusBar0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxStatusBar0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxStatusBar0.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxStatusBar0.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxStatusBar0.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxStatusBar0.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxStatusBar0, 0)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxStatusBar0, 0)
   $SystemWindowsControlsCanvasStatusBar.Children.Add($SystemWindowsControlsRichTextBoxStatusBar0) | Out-Null

   $SystemWindowsControlsRichTextBoxStatusBar1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBoxStatusBar1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
   [System.Windows.Media.TextOptions]::SetTextFormattingMode($SystemWindowsControlsRichTextBoxStatusBar1, [System.Windows.Media.TextFormattingMode]::Display)
   [System.Windows.Media.TextOptions]::SetTextRenderingMode($SystemWindowsControlsRichTextBoxStatusBar1, [System.Windows.Media.TextRenderingMode]::ClearType)
   $SystemWindowsControlsRichTextBoxStatusBar1.FontSize = 12
   $SystemWindowsControlsRichTextBoxStatusBar1.Width = 1060
   $SystemWindowsControlsRichTextBoxStatusBar1.Height = 20
   $SystemWindowsControlsRichTextBoxStatusBar1.BorderThickness = 0
   $SystemWindowsControlsRichTextBoxStatusBar1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBoxStatusBar1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBoxStatusBar1.Foreground = [System.Windows.Media.Brushes]::White
   $SystemWindowsControlsRichTextBoxStatusBar1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
   $SystemWindowsControlsRichTextBoxStatusBar1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
   $SystemWindowsControlsRichTextBoxStatusBar1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxStatusBar1, 0)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxStatusBar1, 0)
   $SystemWindowsControlsCanvasStatusBar.Children.Add($SystemWindowsControlsRichTextBoxStatusBar1) | Out-Null

   




   #═════════════════════════════════════════════════════════════
   # All Controls Placement
   #═════════════════════════════════════════════════════════════

   [System.Windows.Controls.Canvas]::SetLeft($SideBar, 0)
   [System.Windows.Controls.Canvas]::SetTop($SideBar, 40)
   [System.Windows.Controls.Canvas]::SetLeft($SideBarDivider, 0)
   [System.Windows.Controls.Canvas]::SetTop($SideBarDivider, 40)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxSideBarSystemSection, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxSideBarSystemSection, 75)
   [System.Windows.Controls.Canvas]::SetLeft($ButtonDashboard, 0)
   [System.Windows.Controls.Canvas]::SetTop($ButtonDashboard, 105)
   [System.Windows.Controls.Canvas]::SetLeft($ButtonUpdates, 0)
   [System.Windows.Controls.Canvas]::SetTop($ButtonUpdates, 140)
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxSideBarAutomationSection, 20)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxSideBarAutomationSection, 190)
   [System.Windows.Controls.Canvas]::SetLeft($ButtonAutomation, 0)
   [System.Windows.Controls.Canvas]::SetTop($ButtonAutomation, 220)
   


   
   [System.Windows.Controls.Canvas]::SetLeft($PageDashboard, 250)
   [System.Windows.Controls.Canvas]::SetTop($PageDashboard, 40)

   [System.Windows.Controls.Canvas]::SetLeft($PageUpdate, 250)
   [System.Windows.Controls.Canvas]::SetTop($PageUpdate, 40)
   [System.Windows.Controls.Canvas]::SetLeft($PageAutomation, 250)
   [System.Windows.Controls.Canvas]::SetTop($PageAutomation, 40)



   [System.Windows.Controls.Canvas]::SetLeft($DragBar, 0)
   [System.Windows.Controls.Canvas]::SetTop($DragBar, 0)

   [System.Windows.Controls.Canvas]::SetLeft($Logo, 5)
   [System.Windows.Controls.Canvas]::SetTop($Logo, 0)

   [System.Windows.Controls.Canvas]::SetLeft($ButtonInfoPopup, 105)
   [System.Windows.Controls.Canvas]::SetTop($ButtonInfoPopup, 45)
   [System.Windows.Controls.Canvas]::SetLeft($ButtonInfo.ButtonMain, 165)
   [System.Windows.Controls.Canvas]::SetTop($ButtonInfo.ButtonMain, 17.5)
   

   [System.Windows.Controls.Canvas]::SetLeft($ButtonClose, 1025)
   [System.Windows.Controls.Canvas]::SetTop($ButtonClose, 7.5)

   [System.Windows.Controls.Canvas]::SetLeft($StatusBar, 0)
   [System.Windows.Controls.Canvas]::SetTop($StatusBar, 780)
   



   #═════════════════════════════════════════════════════════════
   # All Controls add to Main Canvas
   #═════════════════════════════════════════════════════════════

   $SystemWindowsControlsCanvas.Children.Add($SideBar) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SideBarDivider) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxSideBarSystemSection) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($ButtonDashboard) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($ButtonUpdates) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxSideBarAutomationSection) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($ButtonAutomation) | Out-Null
   

   $SystemWindowsControlsCanvas.Children.Add($PageDashboard) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($PageUpdate) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($PageAutomation) | Out-Null


   $SystemWindowsControlsCanvas.Children.Add($DragBar) | Out-Null

   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null
   
   $SystemWindowsControlsCanvas.Children.Add($ButtonInfoPopup) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($ButtonInfo.ButtonMain) | Out-Null

   $SystemWindowsControlsCanvas.Children.Add($ButtonClose) | Out-Null

   $SystemWindowsControlsCanvas.Children.Add($StatusBar) | Out-Null



   $SystemWindowsWindow.Show()
   return $SystemWindowsWindow, $SystemWindowsControlsCanvas, $SystemWindowsControlsRichTextBoxButtonInfoPopup, $SystemWindowsControlsRichTextBoxSideBarSystemSection, $ButtonDashboard, $ButtonUpdates, $SystemWindowsControlsRichTextBoxSideBarAutomationSection, $ButtonAutomation, $PageDashboard, $SystemWindowsControlsRichTextBoxPageDashboardNetwork0, $SystemWindowsControlsRichTextBoxPageDashboardNetwork1, $SystemWindowsControlsRichTextBoxPageDashboardGPU0, $SystemWindowsControlsRichTextBoxPageDashboardGPU1, $SystemWindowsControlsRichTextBoxPageDashboardCPU0, $SystemWindowsControlsRichTextBoxPageDashboardCPU1, $SystemWindowsControlsRichTextBoxPageDashboardRAM0, $SystemWindowsControlsRichTextBoxPageDashboardRAM1, $SystemWindowsControlsRichTextBoxPageDashboardRAM2, $SystemWindowsControlsRichTextBoxPageDashboardLogBar, $SystemWindowsControlsRichTextBoxPageDashboardLog, $SystemWindowsControlsRichTextBoxPageDashboardTaskBar, $SystemWindowsControlsRichTextBoxPageDashboardTask, $PageUpdate, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate0, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1, $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2, $PageUpdateStackPanelWindowsUpdate, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate0, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1, $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2, $PageUpdateStackPanelAppUpdate, $SystemWindowsControlsRichTextBoxPageUpdateGPUUpdate0, $PageAutomation, $SystemWindowsControlsRichTextBoxStatusBar0, $SystemWindowsControlsRichTextBoxStatusBar1
}