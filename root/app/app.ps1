function AppGetStatus() {
    winget source add --name "winget" --arg "https://cdn.winget.microsoft.com/cache" --type "Microsoft.PreIndexed.Package" | Out-Null
    winget source add --name "msstore" --arg "https://storeedgefd.dsx.mp.microsoft.com/v9.0" --type "Microsoft.Rest" | Out-Null
    winget source update | Out-Null
    $Output = winget list --upgrade-available --include-unknown --accept-source-agreements
    $Output = $Output -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
    $AppList = @()
    foreach ($Line in $Output) {
        if ($Line -match '^(.+?)\s+([\w][\w.-]+\.[\w][\w.-]+)\s+(\d[\d.a-zA-Z]*)\s+(\d[\d.a-zA-Z]*)\s+\S+\s*$') {
            $AppList += @{
                name      = $matches[1].Trim()
                id        = $matches[2].Trim()
                current   = $matches[3].Trim()
                available = $matches[4].Trim()
            }
        }
    }
    $WindowFunction = $Parameter.WindowFunction
    $RichTextBoxFunction = $Parameter.RichTextBoxFunction
    $RichTextBox = $Parameter.SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2
    $Count = $Applist.Count
    $RichTextBox.Dispatcher.Invoke([action]{
        & $RichTextBoxFunction $RichTextBox "Found [$Count] Updates in post search criteria" | Out-Null
        & $WindowFunction | Out-Null
    })
    return $AppList
}

function AppCreateUpdateBar($AppList) {
    if ($AppList.Count -eq 0) {
        $PageUpdateStackPanelAppUpdate.Children.Clear()
    }
    foreach ($i in $AppList) {
        $ID = $i.id
        $Name = $i.name
        $Current = $i.current
        $Available = $i.available

        if ($ID -in $AppUpdateInfoSave) {
            continue
        }
        $AppUpdateInfoSave.Add($ID)

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
        $UpdateIcon.Source = New-Object System.Windows.Media.Imaging.BitmapImage (New-Object System.Uri ((Join-Path $PSScriptRoot "..\assets\UpdateIconApp.png")))
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
            ID = $ID
            Name = $Name
            Current = $Current
            Available = $Available

            UpdateCanvas = $UpdateCanvas
            UpdateIcon = $UpdateIcon
            SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 = $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2
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
            if (-not $AppUpdateRunning) {
                $AppUpdateRunning = $true
                if (-not $this.Tag.Done) {
                    $this.Tag.Done = $true
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:AppUpdateRun} -Parameter @{ID = $this.Tag.ID; RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2}))
                    $TaskName = @("$($this.Tag.Name)")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteAppUpdate = 0
                    while ($ThreadList | Where-Object { -not $_.Handle.IsCompleted }) {
                        $Frame = $Frames[$FrameIndex % $Frames.Count]
                        if ($FrameIndex -gt 0 -and $LinestoDeleteTask -gt 0) {
                            for ($i = 0; $i -lt $LinestoDeleteTask; $i++) {
                                RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageDashboardTask | Out-Null
                            }
                        }
                        if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
                            for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
                                RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
                            }
                        }
                        $LinestoDeleteTask = 0
                        $LinestoDeleteAppUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteAppUpdate++
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
                    if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
                        for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
                            RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
                        }
                    }
                    $LinestoDeleteTask = 0
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
                    $PageUpdateStackPanelAppUpdate.Children.Remove($this.Tag.UpdateCanvas)
                    RichTextBoxClear $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 | Out-Null
                    $ThreadList.Add((Thread $ThreadWrapper -ThreadPool $ThreadPool -Function ${Function:AppGetStatus} -Parameter @{RichTextBoxFunction = ${Function:RichTextBox}; WindowFunction = ${Function:Window}; SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2 = $this.Tag.SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2}))
                    $TaskName = @("App-Update Status")
                    $AlreadyLogged = @()
                    $Frames = @("⣷","⣯","⣟","⡿","⢿","⣻","⣽","⣾")
                    $FrameIndex = 0
                    $LinestoDeleteTask = 0
                    $LinestoDeleteAppUpdate = 0
                    while ($ThreadList | Where-Object { -not $_.Handle.IsCompleted }) {
                        $Frame = $Frames[$FrameIndex % $Frames.Count]
                        if ($FrameIndex -gt 0 -and $LinestoDeleteTask -gt 0) {
                            for ($i = 0; $i -lt $LinestoDeleteTask; $i++) {
                                RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageDashboardTask | Out-Null
                            }
                        }
                        if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
                            for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
                                RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
                            }
                        }
                        $LinestoDeleteTask = 0
                        $LinestoDeleteAppUpdate = 0
                        for ($i = 0; $i -lt $ThreadList.Count; $i++) {
                            if (-not $ThreadList[$i].Handle.IsCompleted) {
                                $Time = Get-Date -Format "HH:mm:ss"
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask "$Frame" | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                RichTextBox $SystemWindowsControlsRichTextBoxPageDashboardTask " $($TaskName[$i])" -NoNewLine | Out-Null
                                $LinestoDeleteTask++
                                if ($i -eq 0) {
                                    $Time = Get-Date -Format "HH:mm:ss"
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 "$Frame" | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " [$Time] |" -NoNewLine -Color ([System.Windows.Media.Brushes]::Gray) | Out-Null
                                    RichTextBox $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 " Status" -NoNewLine | Out-Null
                                    $LinestoDeleteAppUpdate++
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
                    if ($FrameIndex -gt 0 -and $LinestoDeleteAppUpdate -gt 0) {
                        for ($i = 0; $i -lt $LinestoDeleteAppUpdate; $i++) {
                            RichTextBoxDeleteLine $SystemWindowsControlsRichTextBoxPageUpdateAppUpdate1 | Out-Null
                        }
                    }
                    $LinestoDeleteTask = 0
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
                                $AppList = $Result
                                AppCreateUpdateBar $AppList
                            }
                        }
                    }
                    Window | Out-Null
                    $ThreadList.Clear()
                    $AppUpdateRunning = $false
                }
            }
        })
        $PageUpdateStackPanelAppUpdate.Children.Add($UpdateCanvas) | Out-Null

        RichTextBoxClear $UpdateSystemWindowsControlsRichTextBox1 | Out-Null
        RichTextBoxClear $UpdateSystemWindowsControlsRichTextBox2 | Out-Null

        RichTextBox $UpdateSystemWindowsControlsRichTextBox1 $Name | Out-Null
        RichTextBox $UpdateSystemWindowsControlsRichTextBox2 "" -TagBackUpdateSize "v$Available" -RightAlign | Out-Null
    }
}
function AppUpdateRun() {
    $ID = $Parameter.ID
    $RichTextBoxFunction = $Parameter.RichTextBoxFunction
    $WindowFunction = $Parameter.WindowFunction
    $RichTextBox = $Parameter.SystemWindowsControlsRichTextBoxPageUpdateAppUpdate2
    winget source add --name "winget" --arg "https://cdn.winget.microsoft.com/cache" --type "Microsoft.PreIndexed.Package" | Out-Null
    winget source add --name "msstore" --arg "https://storeedgefd.dsx.mp.microsoft.com/v9.0" --type "Microsoft.Rest" | Out-Null
    winget source update | Out-Null
    $Output = winget upgrade --id $ID --silent --accept-package-agreements --accept-source-agreements 4>&1
    if ($LASTEXITCODE -ne 0) {
        $Output = winget install --id $ID --silent --uninstall-previous --accept-package-agreements --accept-source-agreements 4>&1
    }
    if ($LASTEXITCODE -eq 0) {
        foreach ($Line in $Output) {
            $LineString = $Line.ToString().Trim()
            if ($LineString -match '^[-\\|/]$') { continue }
            if ($LineString -match 'ÔûÆ|Ôûê|Ôûæ|^\s*[\d.]+ [KMGT]?B') { continue }
            $LineString = $LineString -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
            if ($LineString -ne '') {
                $RichTextBox.Dispatcher.Invoke([action]{
                    & $RichTextBoxFunction $RichTextBox $Output | Out-Null
                    & $WindowFunction | Out-Null
                })
            }
        }
    }
}