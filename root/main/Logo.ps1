function Logo(){
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
function LogoContinueOneFrame($SystemWindowsWindow, $LoadingBar, $LoadingBarFrames, $Counter) {
   $LoadingBar.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\$($LoadingBarFrames[$Counter]).png")))
   Window
   if ($Counter -eq 7) {
      $Counter = 0
      $SystemWindowsWindow.Close()
   }
}