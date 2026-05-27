function WindowsUpdateGetStatus() {
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Remove-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
        Install-Module PSWindowsUpdate -Force -Scope AllUsers -ErrorAction SilentlyContinue
    }
    Import-Module PSWindowsUpdate;
    $Services = @('wuauserv', 'bits', 'cryptsvc')
    foreach ($ServiceName in $Services) {
        $ServiceRunning = $false;
        while ($ServiceRunning -eq $false) {
            $Service = Get-Service -Name $ServiceName;
            if ($null -eq $Service) {
                break;
            }
            if ($Service.Status -ne 'Running') {
                Start-Service $ServiceName;
            } else {
                $ServiceRunning = $true;
                break;
            }
        }
    }
    $WindowFunction = $Parameter.WindowFunction
    $RichTextBoxFunction = $Parameter.RichTextBoxFunction
    $RichTextBox = $Parameter.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2
    $WindowsUpdateInfo = [System.Collections.Generic.List[object]]::new()
    (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
    Start-Process -FilePath "usoclient.exe" -ArgumentList "StartScan" -NoNewWindow
    Get-WindowsUpdate -Verbose 4>&1 | ForEach-Object {
        $i = $_
        if ($i -is [System.Management.Automation.VerboseRecord]) {
            if ($i.Message -notlike '*Please wait*') {
                $RichTextBox.Dispatcher.Invoke([action]{
                    & $RichTextBoxFunction $RichTextBox $i.Message | Out-Null
                    & $WindowFunction | Out-Null
                })
            }
        } else {
            foreach ($x in $i) {
                $WindowsUpdateInfo.Add($x)
            }
        }
    }
    if ($WindowsUpdateInfo.Count -eq 0) {
        Start-Process -FilePath "usoclient.exe" -ArgumentList "StartInteractiveScan" -NoNewWindow
    }
    return $WindowsUpdateInfo
}
function WindowsUpdateCreateUpdateBar($WindowsUpdateInfo) {
    if ($WindowsUpdateInfo.Count -eq 0) {
        $PageUpdateStackPanelWindowsUpdate.Children.Clear()
    }
    foreach ($i in $WindowsUpdateInfo) {
        $Severity = if ($i.MsrcSeverity) { $i.MsrcSeverity.ToUpper() } else {'Optional'}
        $Size     = if ($i.Size) { $i.Size } else {''}
        $Category = if ($i.Categories) { ($i.Categories | ForEach-Object { $_.Name }) -join ', '} else {''}
        $KB       = if ($i.KBArticleIDs.Count -gt 0) { $i.KBArticleIDs | ForEach-Object { "KB$_" } } else {"KBC$CustomKB";$CustomKB++}
        $Reboot   = if ($i.RebootRequired) { $i.RebootRequired} else { $false }
        if ($KB -in $WindowsUpdateInfoSave) {
            continue
        }
        $WindowsUpdateInfoSave.Add($KB)

        $UpdateCanvas = New-Object System.Windows.Controls.Canvas
        $UpdateCanvas.Width = 790
        $UpdateCanvas.Height = 60
        $UpdateCanvas.Visibility = "Visible"
        $UpdateCanvas.Background = [System.Windows.Media.Brushes]::Transparent
        $UpdateCanvas.Margin = [System.Windows.Thickness]::new(0, 0, 0, 5)

        $UpdateDivider = New-Object System.Windows.Controls.Border
        $UpdateDivider.Width           = 790
        $UpdateDivider.Height          = 60
        $UpdateDivider.BorderThickness = [System.Windows.Thickness]::new(1, 1, 1, 1)
        $UpdateDivider.CornerRadius = New-Object System.Windows.CornerRadius(5, 5, 5, 5)
        $UpdateDivider.BorderBrush     = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
        $UpdateDivider.Background      = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#1E1E1E")
        [System.Windows.Controls.Canvas]::SetLeft($UpdateDivider, 0)
        [System.Windows.Controls.Canvas]::SetTop($UpdateDivider, 0)
        $UpdateCanvas.Children.Add($UpdateDivider) | Out-Null

        $UpdateIcon = New-Object System.Windows.Controls.Image
        if ($Category -like "*Security*") {
            $UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconWindowsSecurity.png")))
        } else {
            if ($Severity -eq "OPTIONAL") {
                if ($KB -like "KBC*") {
                    $UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconWindowsDriver.png")))
                } else {
                    $UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconWindowsOptional.png")))
                }
            } elseif ($Severity -eq "CRITICAL") {
                $UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconWindowsCritical.png")))
            } 
        }
        $UpdateIcon.Width = 40
        $UpdateIcon.Height = 40
        [System.Windows.Controls.Canvas]::SetLeft($UpdateIcon, 10)
        [System.Windows.Controls.Canvas]::SetTop($UpdateIcon, 7.5)
        $UpdateCanvas.Children.Add($UpdateIcon) | Out-Null

        $UpdateSystemWindowsControlsRichTextBox1 = New-Object System.Windows.Controls.RichTextBox
        $UpdateSystemWindowsControlsRichTextBox1.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
        [System.Windows.Media.TextOptions]::SetTextFormattingMode($UpdateSystemWindowsControlsRichTextBox1, [System.Windows.Media.TextFormattingMode]::Display)
        [System.Windows.Media.TextOptions]::SetTextRenderingMode($UpdateSystemWindowsControlsRichTextBox1, [System.Windows.Media.TextRenderingMode]::ClearType)
        $UpdateSystemWindowsControlsRichTextBox1.FontSize = 12
        $UpdateSystemWindowsControlsRichTextBox1.Width = 350
        $UpdateSystemWindowsControlsRichTextBox1.Height = 60
        $UpdateSystemWindowsControlsRichTextBox1.BorderThickness = 0
        $UpdateSystemWindowsControlsRichTextBox1.Document.PagePadding = [System.Windows.Thickness]::new(0)
        $UpdateSystemWindowsControlsRichTextBox1.Background = [System.Windows.Media.Brushes]::Transparent
        $UpdateSystemWindowsControlsRichTextBox1.Foreground = [System.Windows.Media.Brushes]::White
        $UpdateSystemWindowsControlsRichTextBox1.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
        $UpdateSystemWindowsControlsRichTextBox1.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
        $UpdateSystemWindowsControlsRichTextBox1.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
        [System.Windows.Controls.Canvas]::SetLeft($UpdateSystemWindowsControlsRichTextBox1, 60)
        [System.Windows.Controls.Canvas]::SetTop($UpdateSystemWindowsControlsRichTextBox1, 7.5)
        $UpdateCanvas.Children.Add($UpdateSystemWindowsControlsRichTextBox1) | Out-Null

        $UpdateSystemWindowsControlsRichTextBox2 = New-Object System.Windows.Controls.RichTextBox
        $UpdateSystemWindowsControlsRichTextBox2.FontFamily = New-Object System.Windows.Media.FontFamily($FontPathIBMPlexMono)
        [System.Windows.Media.TextOptions]::SetTextFormattingMode($UpdateSystemWindowsControlsRichTextBox2, [System.Windows.Media.TextFormattingMode]::Display)
        [System.Windows.Media.TextOptions]::SetTextRenderingMode($UpdateSystemWindowsControlsRichTextBox2, [System.Windows.Media.TextRenderingMode]::ClearType)
        $UpdateSystemWindowsControlsRichTextBox2.FontSize = 12
        $UpdateSystemWindowsControlsRichTextBox2.Width = 300
        $UpdateSystemWindowsControlsRichTextBox2.Height = 60
        $UpdateSystemWindowsControlsRichTextBox2.BorderThickness = 0
        $UpdateSystemWindowsControlsRichTextBox2.Document.PagePadding = [System.Windows.Thickness]::new(0)
        $UpdateSystemWindowsControlsRichTextBox2.Background = [System.Windows.Media.Brushes]::Transparent
        $UpdateSystemWindowsControlsRichTextBox2.Foreground = [System.Windows.Media.Brushes]::White
        $UpdateSystemWindowsControlsRichTextBox2.SetValue([System.Windows.Controls.RichTextBox]::IsReadOnlyProperty, $true)
        $UpdateSystemWindowsControlsRichTextBox2.SetValue([System.Windows.UIElement]::IsHitTestVisibleProperty, $false)
        $UpdateSystemWindowsControlsRichTextBox2.SetValue([System.Windows.UIElement]::FocusableProperty, $false)
        [System.Windows.Controls.Canvas]::SetLeft($UpdateSystemWindowsControlsRichTextBox2, 370)
        [System.Windows.Controls.Canvas]::SetTop($UpdateSystemWindowsControlsRichTextBox2, 17.5)
        $UpdateCanvas.Children.Add($UpdateSystemWindowsControlsRichTextBox2) | Out-Null

        $UpdateButton = @{
            ButtonMain = New-Object System.Windows.Controls.Button
            Done  = $false
            KB = $KB
            Severity = $Severity
            Size = $Size
            Category = $Category
            Title = $i.Title
            Reboot = $Reboot
            UpdateCanvas = $UpdateCanvas
            UpdateIcon = $UpdateIcon
            SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2
        }
        $UpdateButton.ButtonMain.Content = "Install"
        $UpdateButton.ButtonMain.Width = 100
        $UpdateButton.ButtonMain.Height = 30
        $UpdateButton.ButtonMain.FontSize = 12
        $UpdateButton.ButtonMain.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
        $UpdateButton.ButtonMain.HorizontalContentAlignment = "Center"
        $UpdateButton.ButtonMain.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
        $UpdateButton.ButtonMain.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
        $UpdateButton.ButtonMain.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
        $UpdateButton.ButtonMain.BorderThickness = New-Object System.Windows.Thickness(1, 1, 1, 1)
        $UpdateButton.ButtonMain.Cursor = [System.Windows.Input.Cursors]::Arrow
        $UpdateButton.ButtonMain.Tag = $UpdateButton
        [System.Windows.Controls.Canvas]::SetLeft($UpdateButton.ButtonMain, 680)
        [System.Windows.Controls.Canvas]::SetTop($UpdateButton.ButtonMain, 15)
        $UpdateCanvas.Children.Add($UpdateButton.ButtonMain) | Out-Null
        $UpdateButton.ButtonMain.Add_Click({
            if (-not $WindowsUpdateRunning) {
                $WindowsUpdateRunning = $true
                if (-not $this.Tag.Done) {
                    $this.Tag.Done = $true
                    if ($this.Tag.Reboot) {
                        $ResultQuestion = [System.Windows.MessageBox]::Show(
                        "After this Update,`nyour System will need a Reboot`nIt will be triggered on application exit.",
                        "Queue Reboot ?",
                        "YesNo",
                        "Question"
                        )
                        if ($ResultQuestion -eq "No") {
                            return
                        }
                    }
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:WindowsUpdateUpdateRun} -Parameter @{Title = $this.Tag.Title; KB = $this.Tag.KB; RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2}))
                    $TaskName = @("$($this.Tag.KB)")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        $LinestoDeleteTask = 0
                        $LinestoDeleteWindowsUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteWindowsUpdate++
                                $this.Tag.UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconDownload.png")))
                                $this.Content = "Installing..."
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
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                                $this.Tag.UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconInstall.png")))
                                $this.Content = "Done"
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time]" -BottomToTop -Tag "INFO" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "Windows-Update $($this.Tag.KB) successfully installed " -BottomToTop | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
                                
                            }
                        }
                    }
                    Window | Out-Null
                    $ThreadList.Clear()
                    $PageUpdateStackPanelWindowsUpdate.Children.Remove($this.Tag.UpdateCanvas)
                    RichTextBoxClear $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 | Out-Null
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:WindowsUpdateGetStatus} -Parameter @{RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2}))
                    $TaskName = @("Windows-Update Status")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        $LinestoDeleteTask = 0
                        $LinestoDeleteWindowsUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                if ($i -eq 0) {
                                    $Time = Get-Date -Format "HH:mm:ss"
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 "$Frame" | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " Status" -NoNewLine | Out-Null
                                    $LinestoDeleteWindowsUpdate++
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
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        }
                    }
                    Window | Out-Null
                    $ThreadList.Clear()
                    $WindowsUpdateRunning = $false
                }
            }
        })
         
        $PageUpdateStackPanelWindowsUpdate.Children.Add($UpdateCanvas) | Out-Null

        RichTextBoxClear $UpdateSystemWindowsControlsRichTextBox1 | Out-Null
        RichTextBoxClear $UpdateSystemWindowsControlsRichTextBox2 | Out-Null
        if ($Category -like "*Security*") {
            RichTextBox $UpdateSystemWindowsControlsRichTextBox1 "$($i.Title)" | Out-Null
            if ($Reboot) {
                RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "SECURITY" -TagBackReboot -RightAlign | Out-Null
            } else {
                RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "SECURITY" -RightAlign | Out-Null
            }
        } else {
            if ($Severity -eq "OPTIONAL") {
                RichTextBox $UpdateSystemWindowsControlsRichTextBox1 "$($i.Title)" | Out-Null
                if ($KB -like "KBC*") {
                    if ($Reboot) {
                        RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "DRIVER" -TagBackReboot -RightAlign | Out-Null
                    } else {
                        RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "DRIVER" -RightAlign | Out-Null
                    }
                } else {
                    if ($Reboot) {
                        RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "OPTIONAL" -TagBackReboot -RightAlign | Out-Null
                    } else {
                        RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "OPTIONAL" -RightAlign | Out-Null
                    }
                }
            } elseif ($Severity -eq "IMPORTANT") {
                RichTextBox $UpdateSystemWindowsControlsRichTextBox1 "$($i.Title)" | Out-Null
                if ($Reboot) {
                    RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "IMPORTANT" -TagBackReboot -RightAlign | Out-Null
                } else {
                    RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "IMPORTANT" -RightAlign | Out-Null
                }
            } elseif ($Severity -eq "CRITICAL") {
                RichTextBox $UpdateSystemWindowsControlsRichTextBox1 "$($i.Title)" | Out-Null
                if ($Reboot) {
                    RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "CRITICAL" -TagBackReboot -RightAlign | Out-Null
                } else {
                    RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "$Size" -TagBack "CRITICAL" -RightAlign | Out-Null
                }
            }
        }
        Window | Out-Null
    }

    if ($WindowsUpdateInfo.Count -gt 0 -and -not ("KBC0" -in $WindowsUpdateInfoSave)) {
        $WindowsUpdateInfoSave.Add("KBC0")
        $UpdateAllButton = @{
            ButtonMain = New-Object System.Windows.Controls.Button
            Done  = $false
            WindowsUpdateInfoSave = $WindowsUpdateInfoSave
            SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2
        }
        $UpdateAllButton.ButtonMain.Content = "Install All"
        $UpdateAllButton.ButtonMain.Width = 150
        $UpdateAllButton.ButtonMain.Height = 30
        $UpdateAllButton.ButtonMain.FontSize = 12
        $UpdateAllButton.ButtonMain.FontFamily = New-Object System.Windows.Media.FontFamily("Consolas")
        $UpdateAllButton.ButtonMain.HorizontalContentAlignment = "Center"
        $UpdateAllButton.ButtonMain.Background = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#141414")
        $UpdateAllButton.ButtonMain.Foreground = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#ffffff")
        $UpdateAllButton.ButtonMain.BorderBrush = [System.Windows.Media.SolidColorBrush][System.Windows.Media.ColorConverter]::ConvertFromString("#80ffffff")
        $UpdateAllButton.ButtonMain.BorderThickness = New-Object System.Windows.Thickness(1, 1, 1, 1)
        $UpdateAllButton.ButtonMain.Cursor = [System.Windows.Input.Cursors]::Arrow
        $UpdateAllButton.ButtonMain.Tag = $UpdateAllButton
        $UpdateAllButton.ButtonMain.Add_Click({
            if (-not $WindowsUpdateRunning) {
                $WindowsUpdateRunning = $true
                if (-not $this.Tag.Done) {
                    $this.Tag.Done = $true
                    $ResultQuestion = [System.Windows.MessageBox]::Show(
                    "After All Updates,`nyour System could need a Reboot`nIf so it will be triggered on application exit.",
                    "Queue Reboot ?",
                    "YesNo",
                    "Question"
                    )
                    if ($ResultQuestion -eq "No") {
                        return
                    }
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:WindowsUpdateUpdateRun} -Parameter @{WindowsUpdateInfoSave = $this.Tag.WindowsUpdateInfoSave; RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2}))
                    $TaskName = @("All Updates")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        $LinestoDeleteTask = 0
                        $LinestoDeleteWindowsUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteWindowsUpdate++
                                $this.Content = "Installing All..."
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
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                                $this.Content = "Done"
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "[$Time]" -BottomToTop -Tag "INFO" -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "All Windows-Update's successfully installed " -BottomToTop | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardLog "" -BottomToTop | Out-Null
                                
                            }
                        }
                    }
                    Window | Out-Null
                    $ThreadList.Clear()
                    $PageUpdateStackPanelWindowsUpdate.Children.Clear()
                    RichTextBoxClear $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 | Out-Null
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:WindowsUpdateGetStatus} -Parameter @{RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2}))
                    $TaskName = @("Windows-Update Status")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        $LinestoDeleteTask = 0
                        $LinestoDeleteWindowsUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                if ($i -eq 0) {
                                    $Time = Get-Date -Format "HH:mm:ss"
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 "$Frame" | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate1 " Status" -NoNewLine | Out-Null
                                    $LinestoDeleteWindowsUpdate++
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
                    $LinestoDeleteTask = 0
                    $LinestoDeleteWindowsUpdate = 0
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
                        }
                    }
                    Window | Out-Null
                    $ThreadList.Clear()
                    $WindowsUpdateRunning = $false
                }
            }
        })

        $PageUpdateStackPanelWindowsUpdate.Children.Add($UpdateAllButton.ButtonMain) | Out-Null
    }
}
function WindowsUpdateUpdateRun() {
    $KB = $Parameter.KB
    $Title = $Parameter.Title
    $WindowsUpdateInfoSave = $Parameter.WindowsUpdateInfoSave
    $RichTextBoxFunction = $Parameter.RichTextBoxFunction
    $WindowFunction = $Parameter.WindowFunction
    $RichTextBox = $Parameter.SystemWindowsControlsRichTextBoxPageUpdateWindowsUpdate2
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Remove-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
        Install-Module PSWindowsUpdate -Force -Scope AllUsers -ErrorAction SilentlyContinue
    }
    Import-Module PSWindowsUpdate;
    $Services = @('wuauserv', 'bits', 'cryptsvc')
    foreach ($ServiceName in $Services) {
        $ServiceRunning = $false;
        while ($ServiceRunning -eq $false) {
            $Service = Get-Service -Name $ServiceName;
            if ($null -eq $Service) {
                break;
            }
            if ($Service.Status -ne 'Running') {
                Start-Service $ServiceName;
            } else {
                $ServiceRunning = $true;
                break;
            }
        }
    }
    if ($WindowsUpdateInfoSave.Count -gt 0) {
        Get-WindowsUpdate -AcceptAll -Install -Verbose -IgnoreReboot 4>&1 | ForEach-Object {
            $i = $_
            if ($i -is [System.Management.Automation.VerboseRecord]) {
                if ($i.Message -notlike '*Please wait*') {
                    $RichTextBox.Dispatcher.Invoke([action]{
                        & $RichTextBoxFunction $RichTextBox $i.Message | Out-Null
                        & $WindowFunction | Out-Null
                    })
                }
            }
        }
    }
    if ($KB -like "KBC*") {
        Get-WindowsUpdate -Title $([regex]::Escape($Title)) -AcceptAll -Install -Verbose -IgnoreReboot 4>&1 | ForEach-Object {
            $i = $_
            if ($i -is [System.Management.Automation.VerboseRecord]) {
                if ($i.Message -notlike '*Please wait*') {
                    $RichTextBox.Dispatcher.Invoke([action]{
                        & $RichTextBoxFunction $RichTextBox $i.Message | Out-Null
                        & $WindowFunction | Out-Null
                    })
                }
            }
        }
    } else {
        Get-WindowsUpdate -KBArticleID $KB -AcceptAll -Install -Verbose -IgnoreReboot 4>&1 | ForEach-Object {
            $i = $_
            if ($i -is [System.Management.Automation.VerboseRecord]) {
                if ($i.Message -notlike '*Please wait*') {
                    $RichTextBox.Dispatcher.Invoke([action]{
                        & $RichTextBoxFunction $RichTextBox $i.Message | Out-Null
                        & $WindowFunction | Out-Null
                    })
                }
            }
        }
    }
}