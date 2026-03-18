if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" 
    exit
}
if ($PSVersionTable.PSVersion.Major -lt 7) {
    if (!(Get-Command pwsh -ErrorAction SilentlyContinue)) {
        winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements --scope machine
    } else {
        winget upgrade --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements --scope machine
    }
    Start-Process pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" 
    exit
}
#======================================#
# Add Types
#======================================#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
#======================================#
# Functions
#======================================#
function StartUpLogo-Show(){
   $Width = 282
   $Height = 282
   $Root = New-Object System.Windows.Window
   $Root.WindowStyle = "None"
   $Root.AllowsTransparency = $true
   $Root.Background = "Transparent"
   $Root.ResizeMode = "NoResize"
   $Root.Topmost = $true
   $Root.Width = $Width
   $Root.Height = $Height
   $ScreenParameter = [System.Windows.SystemParameters]
   $Root.Left = ($ScreenParameter::PrimaryScreenWidth - $Width) / 2
   $Root.Top = ($ScreenParameter::PrimaryScreenHeight * 0.45) - ($Height / 2)
   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\LogoBig.png")))
   $Logo.Width = $Width
   $Logo.Height = $Height
   $Root.Content = $Logo
   $Root.Show()
   return $Root
}
function SystemWindow-Home(){
   $Width = 900
   $Height = 500
   $Root = New-Object System.Windows.Window
   $Root.WindowStyle = "None"
   $Root.AllowsTransparency = $true
   $Root.Background = "Transparent"
   $Root.ResizeMode = "NoResize"
   $Root.Topmost = $false
   $Root.Width = $Width
   $Root.Height = $Height
   $ScreenParameter = [System.Windows.SystemParameters]
   $Root.Left = ($ScreenParameter::PrimaryScreenWidth - $Width) / 2
   $Root.Top = ($ScreenParameter::PrimaryScreenHeight * 0.45) - ($Height / 2)
   $Root.Icon = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Icon.ico")))
   $SystemWindowsControlsCanvas = New-Object System.Windows.Controls.Canvas
   
   $Background = New-Object System.Windows.Controls.Image
   $Background.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Background.png")))
   $Background.Width = $Width
   $Background.Height = $Height
   [System.Windows.Controls.Canvas]::SetLeft($Background, 0)
   [System.Windows.Controls.Canvas]::SetTop($Background, 0)
   $SystemWindowsControlsCanvas.Children.Add($Background) | Out-Null

   $Logo = New-Object System.Windows.Controls.Image
   $Logo.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\LogoSmallWhite.png")))
   $Logo.Width = 44
   $Logo.Height = 44
   [System.Windows.Controls.Canvas]::SetLeft($Logo, 0)
   [System.Windows.Controls.Canvas]::SetTop($Logo, 5)
   $SystemWindowsControlsCanvas.Children.Add($Logo) | Out-Null

   $DragBarImage = New-Object System.Windows.Controls.Image
   $DragBarImage.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\DragBar.png")))
   $DragBarImage.Width = 900
   $DragBarImage.Height = 40
   [System.Windows.Controls.Canvas]::SetLeft($DragBarImage, 0)
   [System.Windows.Controls.Canvas]::SetTop($DragBarImage, 0)
   $DragBarImage.Add_MouseLeftButtonDown({
      [System.Windows.Window]::GetWindow($args[0]).DragMove()
   })
   $SystemWindowsControlsCanvas.Children.Add($DragBarImage) | Out-Null

   $CloseButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $CloseButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
   $CloseButton.Button.Width = 30
   $CloseButton.Button.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Button, 860)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Button, 10)
   $CloseButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Close.png")))
   $CloseButton.Icon.Width = 22
   $CloseButton.Icon.Height = 22
   [System.Windows.Controls.Canvas]::SetLeft($CloseButton.Icon, 864)
   [System.Windows.Controls.Canvas]::SetTop($CloseButton.Icon, 14)
   $CloseButton.Button.Tag = $CloseButton
   $CloseButton.Icon.Tag   = $CloseButton
   $CloseButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\CloseHover.png")))
   })
   $CloseButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Close.png")))
   })
   $CloseButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\CloseHover.png")))
   })
   $CloseButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Close.png")))
   })
   $CloseButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\ClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         [System.Windows.Window]::GetWindow($this).Close()
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Close.png")))
    }
   })
   $CloseButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\ClosePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $CloseButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         [System.Windows.Window]::GetWindow($this).Close()
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Close.png")))
    }
   })
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($CloseButton.Icon)   | Out-Null

   $SettingsButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $SettingsButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
   $SettingsButton.Button.Width = 30
   $SettingsButton.Button.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Button, 820)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Button, 10)
   $SettingsButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Settings.png")))
   $SettingsButton.Icon.Width = 18
   $SettingsButton.Icon.Height = 18
   [System.Windows.Controls.Canvas]::SetLeft($SettingsButton.Icon, 826)
   [System.Windows.Controls.Canvas]::SetTop($SettingsButton.Icon, 16)
   $SettingsButton.Button.Tag = $SettingsButton
   $SettingsButton.Icon.Tag   = $SettingsButton
   $SettingsButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\SettingsHover.png")))
   })
   $SettingsButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Settings.png")))
   })
   $SettingsButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\SettingsHover.png")))
   })
   $SettingsButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Bar.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Settings.png")))
   })
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($SettingsButton.Icon)   | Out-Null

   $HomeButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $HomeButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarActive.png")))
   $HomeButton.Button.Width = 30
   $HomeButton.Button.Height = 30
   [System.Windows.Controls.Canvas]::SetLeft($HomeButton.Button, 780)
   [System.Windows.Controls.Canvas]::SetTop($HomeButton.Button, 10)
   $HomeButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
   $HomeButton.Icon.Width = 14
   $HomeButton.Icon.Height = 14
   [System.Windows.Controls.Canvas]::SetLeft($HomeButton.Icon, 788)
   [System.Windows.Controls.Canvas]::SetTop($HomeButton.Icon, 18)
   $HomeButton.Button.Tag = $HomeButton
   $HomeButton.Icon.Tag   = $HomeButton
   $HomeButton.Button.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarActiveHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\HomeHover.png")))
   })
   $HomeButton.Button.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarActive.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
   })
   $HomeButton.Icon.Add_MouseEnter({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarActiveHover.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\HomeHover.png")))
   })
   $HomeButton.Icon.Add_MouseLeave({
      $this.Tag.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BarActive.png")))
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
   })
   $HomeButton.Button.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\HomePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $HomeButton.Button.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
    }
   })
   $HomeButton.Icon.Add_MouseLeftButtonDown({
      $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\HomePressed.png")))
      $this.CaptureMouse() | Out-Null
   })
   $HomeButton.Icon.Add_MouseLeftButtonUp({
      $this.ReleaseMouseCapture()
      if ($this.IsMouseOver) {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
      } else {
         $this.Tag.Icon.Source   = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\Home.png")))
    }
   })
   $SystemWindowsControlsCanvas.Children.Add($HomeButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($HomeButton.Icon)   | Out-Null

   $BigButton = @{
      Button = New-Object System.Windows.Controls.Image
      Icon   = New-Object System.Windows.Controls.Image
   }
   $BigButton.Button.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\BigButton.png")))
   $BigButton.Button.Width = 110
   $BigButton.Button.Height = 310
   [System.Windows.Controls.Canvas]::SetLeft($BigButton.Button, 780)
   [System.Windows.Controls.Canvas]::SetTop($BigButton.Button, 50)
   $BigButton.Icon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\AutomationCheckBlack.png")))
   $BigButton.Icon.Width = 128
   $BigButton.Icon.Height = 64
   [System.Windows.Controls.Canvas]::SetLeft($BigButton.Icon, 766)
   [System.Windows.Controls.Canvas]::SetTop($BigButton.Icon, 70)
   $SystemWindowsControlsCanvas.Children.Add($BigButton.Button) | Out-Null
   $SystemWindowsControlsCanvas.Children.Add($BigButton.Icon)   | Out-Null

   $SystemWindowsControlsRichTextBoxImage0 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage0.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\ConsoleBox.png")))
   $SystemWindowsControlsRichTextBoxImage0.Width = 760
   $SystemWindowsControlsRichTextBoxImage0.Height = 310
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage0, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage0, 50)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage0) | Out-Null

   $SystemWindowsControlsRichTextBox0 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox0.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox0.FontSize = 10
   $SystemWindowsControlsRichTextBox0.Width = 760
   $SystemWindowsControlsRichTextBox0.Height = 310
   $SystemWindowsControlsRichTextBox0.BorderThickness = 0
   $SystemWindowsControlsRichTextBox0.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox0.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox0.Foreground = [System.Windows.Media.Brushes]::White
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox0, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox0, 60)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox0) | Out-Null

   $SystemWindowsControlsRichTextBoxImage1 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage1.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\WindowsUpdateBox.png")))
   $SystemWindowsControlsRichTextBoxImage1.Width = 410
   $SystemWindowsControlsRichTextBoxImage1.Height = 120
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage1, 10)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage1, 370)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage1) | Out-Null

   $SystemWindowsControlsRichTextBox1 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox1.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox1.FontSize = 10
   $SystemWindowsControlsRichTextBox1.Width = 410
   $SystemWindowsControlsRichTextBox1.Height = 120
   $SystemWindowsControlsRichTextBox1.BorderThickness = 0
   $SystemWindowsControlsRichTextBox1.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox1.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox1.Foreground = [System.Windows.Media.Brushes]::White
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox1, 15)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox1, 380)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox1) | Out-Null

   $SystemWindowsControlsRichTextBoxImage2 = New-Object System.Windows.Controls.Image
   $SystemWindowsControlsRichTextBoxImage2.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "assets\AppUpdateBox.png")))
   $SystemWindowsControlsRichTextBoxImage2.Width = 460
   $SystemWindowsControlsRichTextBoxImage2.Height = 120
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBoxImage2, 430)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBoxImage2, 370)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBoxImage2) | Out-Null

   $SystemWindowsControlsRichTextBox2 = New-Object System.Windows.Controls.RichTextBox
   $SystemWindowsControlsRichTextBox2.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
   $SystemWindowsControlsRichTextBox2.FontSize = 10
   $SystemWindowsControlsRichTextBox2.Width = 460
   $SystemWindowsControlsRichTextBox2.Height = 120
   $SystemWindowsControlsRichTextBox2.BorderThickness = 0
   $SystemWindowsControlsRichTextBox2.Document.PagePadding = [System.Windows.Thickness]::new(0)
   $SystemWindowsControlsRichTextBox2.Background = [System.Windows.Media.Brushes]::Transparent
   $SystemWindowsControlsRichTextBox2.Foreground = [System.Windows.Media.Brushes]::White
   [System.Windows.Controls.Canvas]::SetLeft($SystemWindowsControlsRichTextBox2, 435)
   [System.Windows.Controls.Canvas]::SetTop($SystemWindowsControlsRichTextBox2, 380)
   $SystemWindowsControlsCanvas.Children.Add($SystemWindowsControlsRichTextBox2) | Out-Null

   $Root.Content = $SystemWindowsControlsCanvas
   return $Root, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2
}
function SystemWindow-Settings([System.Windows.Window]$SystemWindowsWindow){
   <#Do this if a terminating exception happens#>
}
function SystemWindow-Show([System.Windows.Window]$SystemWindowsWindow){
   $SystemWindowsWindow.Show()
}
function SystemWindow-Refresh(){
   [System.Windows.Forms.Application]::DoEvents()
}
function SystemWindow-Hide([System.Windows.Window]$SystemWindowsWindow){
   $SystemWindowsWindow.Hide()
}
function SystemWindow-ShowDialog([System.Windows.Window]$SystemWindowsWindow){
   $SystemWindowsWindow.ShowDialog()
}
function SystemWindow-Close([System.Windows.Window]$SystemWindowsWindow){
   $SystemWindowsWindow.Close()
}
function RichTextBox-Write([System.Windows.Controls.RichTextBox]$SystemWindowsControlsRichTextBox, [string]$Text, [switch]$Clear, [switch]$RemoveLast, [System.Windows.Media.Brush]$Color = [System.Windows.Media.Brushes]::White) {
    if ($Clear) { $SystemWindowsControlsRichTextBox.Document.Blocks.Clear() }
    if ($RemoveLast -and $SystemWindowsControlsRichTextBox.Document.Blocks.Count -gt 0) {
        $SystemWindowsControlsRichTextBox.Document.Blocks.Remove($SystemWindowsControlsRichTextBox.Document.Blocks.LastBlock)
    }
    $Run = New-Object System.Windows.Documents.Run $Text.Trim()
    $Run.Foreground = $Color
    $Paragraph = New-Object System.Windows.Documents.Paragraph $Run
    $Paragraph.Margin = [System.Windows.Thickness]::new(0)
    $SystemWindowsControlsRichTextBox.Document.Blocks.Add($Paragraph)
}
function Winget-Get() {
    try {
        $lines = "Y" | winget list --upgrade-available --include-unknown
        $lines = $lines -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
        $AppList = @()
        $StringBuilder = New-Object System.Text.StringBuilder
        $OutputStart = $false
        foreach ($line in $lines) {
            if (-not $OutputStart -and $line -like 'Name*') { $OutputStart = $true }
            if ($OutputStart) { $StringBuilder.AppendLine($line) | Out-Null }
            if ($line -match '^(.+?)\s+([A-Za-z][\w.-]+\.[A-Za-z][\w.-]+)\s+[\d]') {
                $AppList += @{
                    name = $matches[1].Trim()
                    id   = $matches[2].Trim()
                }
            }
        }
        return $StringBuilder.ToString().Trim(), $AppList
    } catch {
        <#Do this if a terminating exception happens#>
    }
}

function WindowsUpdate-Get() {
   try {
      Import-Module PSWindowsUpdate;
      $services = @('wuauserv', 'bits', 'cryptsvc')
      foreach ($serviceName in $services) {
         $serviceRunning = $false;
         while ($serviceRunning -eq $false) {
            $service = Get-Service -Name $serviceName;
            if ($null -eq $service) {
                  break;
            }
            if ($service.Status -ne 'Running') {
                  Start-Service $serviceName;
            } else {
                  $serviceRunning = $true;
                  break;
            }
         }
      }
      $StringBuilder = New-Object System.Text.StringBuilder
      while ($true) {
         $verbose = Get-WindowsUpdate -Verbose 4>&1
         if ($?) {
            foreach ($line in $verbose) {
                  $trimmedLine = $line.Message -replace 'Please wait\.\.\.', ''
                  $StringBuilder.AppendLine($trimmedLine) | Out-Null
            }
            break
         }
      }
      return $StringBuilder.ToString()
   } catch {
      <#Do this if a terminating exception happens#>
   }
}
function SettingsFileCheck($PSScriptRoot) {
   $SettingsFilePath = Join-Path $PSScriptRoot "settings"
   if (Test-Path $SettingsFilePath) {
      return 1
   } else {
      $default = @"
Network =
LogEmail =
"@
      New-Item -Path $SettingsFilePath -ItemType File -Force | Out-Null
      Set-Content -Path $SettingsFilePath -Value $default -Encoding utf8BOM
      return $SettingsFilePath
   }
}
function AutologonExeCheck($PSScriptRoot) {
   $AutologonExePath = Join-Path $PSScriptRoot "AutoLogon.exe"
   if (Test-Path $AutologonExePath) {
      return 1
   } else {
      return $AutologonExePath
   }
}



#======================================#
# MAIN
#======================================#
$SystemWindowsWindow = StartUpLogo-Show
Start-Sleep -Seconds 2
SystemWindow-Close $SystemWindowsWindow

$SystemWindowsWindow, $SystemWindowsControlsRichTextBox0, $SystemWindowsControlsRichTextBox1, $SystemWindowsControlsRichTextBox2 = SystemWindow-Home
SystemWindow-Show $SystemWindowsWindow

RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | StartUp" -Clear -Color ([System.Windows.Media.Brushes]::Cyan)
SystemWindow-Refresh
RichTextBox-Write $SystemWindowsControlsRichTextBox0 ""
SystemWindow-Refresh
RichTextBox-Write $SystemWindowsControlsRichTextBox0 "‎  MODULE               | TASK           | RESULT                                                                               "
SystemWindow-Refresh
RichTextBox-Write $SystemWindowsControlsRichTextBox0 "_______________________________________________________________________________________________________________________________________"
SystemWindow-Refresh
RichTextBox-Write $SystemWindowsControlsRichTextBox0 ""
SystemWindow-Refresh
RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | -" -Color ([System.Windows.Media.Brushes]::Cyan)
SystemWindow-Refresh
try {
   $SettingsFileCheckReturn = SettingsFileCheck $PSScriptRoot
   if ($SettingsFileCheckReturn -eq 1) {
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ✔" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen)
      SystemWindow-Refresh
   } else {
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ✖" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM could not find SettingsFile at $SettingsFileCheckReturn" -Color ([System.Windows.Media.Brushes]::Red)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM created a new EMPTY SettingsFile" -Color ([System.Windows.Media.Brushes]::LightGreen)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 ""
      SystemWindow-Refresh
   }
   
}
catch {
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | SettingsFile   | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
   SystemWindow-Refresh
}

RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | -" -Color ([System.Windows.Media.Brushes]::Cyan)
SystemWindow-Refresh
try {
   $AutologonExeCheckReturn = AutologonExeCheck $PSScriptRoot
   if ($AutologonExeCheckReturn -eq 1) {
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ✔" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen)
      SystemWindow-Refresh
   } else {
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "" -RemoveLast
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 ""
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ✖" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM could not find AutologonExe at $AutologonExeCheckReturn" -Color ([System.Windows.Media.Brushes]::Red)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM Download at - https://learn.microsoft.com/en-us/sysinternals/downloads/autologon" -Color ([System.Windows.Media.Brushes]::Red)
      SystemWindow-Refresh
      RichTextBox-Write $SystemWindowsControlsRichTextBox0 ""
      SystemWindow-Refresh
   }
   
}
catch {
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> SYSTEM               | AutologonExe   | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
   SystemWindow-Refresh
}
                                                                    
RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | preScan        | -" -Color ([System.Windows.Media.Brushes]::Cyan)
SystemWindow-Refresh
try {
   $WindowsUpdateOutput = WindowsUpdate-Get
   RichTextBox-Write $SystemWindowsControlsRichTextBox1 $WindowsUpdateOutput -Clear
   SystemWindow-Refresh
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | preScan        | ✔" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen)
   SystemWindow-Refresh
}
catch {
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE WindowsUpdate | preScan        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
   SystemWindow-Refresh
}
RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | preScan        | -" -Color ([System.Windows.Media.Brushes]::Cyan)
SystemWindow-Refresh
try {
   $WingetOutput, $AppList = Winget-Get
   RichTextBox-Write $SystemWindowsControlsRichTextBox2 $WingetOutput -Clear
   SystemWindow-Refresh
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | preScan        | ✔" -RemoveLast -Color ([System.Windows.Media.Brushes]::LightGreen)
   SystemWindow-Refresh
}
catch {
   RichTextBox-Write $SystemWindowsControlsRichTextBox0 "> MODULE Winget        | preScan        | ERROR" -RemoveLast -Color ([System.Windows.Media.Brushes]::Red)
   SystemWindow-Refresh
}




SystemWindow-Hide $SystemWindowsWindow
SystemWindow-ShowDialog $SystemWindowsWindow