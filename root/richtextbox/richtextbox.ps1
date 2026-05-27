function RichTextBox([System.Windows.Controls.RichTextBox]$SystemWindowsControlsRichTextBox, [string]$Text, [System.Windows.Media.Brush]$Color = [System.Windows.Media.Brushes]::White, [string]$Tag = '', [string]$TagBack = '', [string]$TagBackUpdateSize = '', [string]$TagBig = '', [string]$Indicator = '', [int]$IndicatorSize = 10, [switch]$BottomToTop, [switch]$NoNewLine, [switch]$ScrollUP, [switch]$RightAlign, [switch]$NoWrap, [switch]$TagBackReboot) {
    $TextBlock = New-Object System.Windows.Controls.TextBlock
    $TextBlock.Margin = [System.Windows.Thickness]::new(0, 2, 0, 2)
    if ($NoWrap) {
        $TextBlock.TextWrapping = [System.Windows.TextWrapping]::NoWrap
    } else {
        $TextBlock.TextWrapping = [System.Windows.TextWrapping]::Wrap
    }
    if ($BottomToTop) {
        $TextBlock.LayoutTransform = New-Object System.Windows.Media.ScaleTransform(1, -1)
    }
    if ($Tag) {
        $tagColors = @{ 'OK' = '#05BE9B'; 'WARNING' = '#FF5541'; 'INFO' = '#3791EB'; 'ERROR' = '#FF4141'}
        $tagBg     = @{ 'OK' = '#0F2828'; 'WARNING' = '#281E1E'; 'INFO' = '#142332'; 'ERROR' = '#3C1E1E'}
        $tb = New-Object System.Windows.Controls.TextBlock
        $tb.Text = $Tag
        $tb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$Tag])
        $tb.FontWeight = [System.Windows.FontWeights]::Bold
        $tb.FontSize = 12
        $tb.Padding = [System.Windows.Thickness]::new(8, 2, 8, 2)
        $Border = New-Object System.Windows.Controls.Border
        $Border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBg[$Tag])
        $Border.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$Tag])
        $Border.BorderThickness = [System.Windows.Thickness]::new(1)
        $Border.CornerRadius = [System.Windows.CornerRadius]::new(2)
        $Border.Child = $tb
        $Container = New-Object System.Windows.Documents.InlineUIContainer $Border
        $Container.BaselineAlignment = [System.Windows.BaselineAlignment]::Center
        $TextBlock.Inlines.Add($Container)
        $TextBlock.Inlines.Add((New-Object System.Windows.Documents.Run '  '))
    }
    if ($TagBig) {
        $tagFg = @{ 'W' = '#ffffff'; '🗗' = '#ffffff'; '🖭' = '#ffffff'; '🕔' = '#3791EB'; '⚠' = '#FF5541'; '⤓' = '#000000'; '🛡' = '#F0A500'; '✔' = '#05BE9B' }
        $tagBg = @{ 'W' = '#141414'; '🗗' = '#141414'; '🖭' = '#141414'; '🕔' = '#142332'; '⚠' = '#281E1E'; '⤓' = '#ffffff'; '🛡' = '#2D2A10'; '✔' = '#0F2828' }
        $tagBb = @{ 'W' = '#141414'; '🗗' = '#141414'; '🖭' = '#141414'; '🕔' = '#3791EB'; '⚠' = '#FF5541'; '⤓' = '#000000'; '🛡' = '#F0A500'; '✔' = '#05BE9B' }
        $tb = New-Object System.Windows.Controls.TextBlock
        $tb.Text                = $TagBig
        $tb.FontSize            = 18
        $tb.Foreground          = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagFg[$TagBig])
        $tb.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
        $tb.VerticalAlignment   = [System.Windows.VerticalAlignment]::Center
        if ($TagBig -eq "W") {
            $tb.FontFamily = [System.Windows.Media.FontFamily]::new("Marlett")
        }
        $Border = New-Object System.Windows.Controls.Border
        $Border.Width           = 40
        $Border.Height          = 40
        $Border.CornerRadius    = [System.Windows.CornerRadius]::new(8)
        $Border.Background      = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBg[$TagBig])
        $Border.BorderBrush     = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBb[$TagBig])
        $Border.BorderThickness = [System.Windows.Thickness]::new(1)
        $Border.Child           = $tb
        $Container = New-Object System.Windows.Documents.InlineUIContainer $Border
        $Container.BaselineAlignment = [System.Windows.BaselineAlignment]::Center
        $TextBlock.Inlines.Add($Container)
        $TextBlock.Inlines.Add((New-Object System.Windows.Documents.Run '  '))
    }
    if ($Indicator) {
        $indicatorMap = @{
            'DOTBLUE'   = @{ Char = '●'; Color = '#3791EB' }
            'DOTGREEN'  = @{ Char = '●'; Color = '#05BE9B' }
            'DOTORANGE' = @{ Char = '●'; Color = '#FF5541' }
            'DOTRED'    = @{ Char = '●'; Color = '#FF4141' }
            'UP'        = @{ Char = '▲'; Color = '#05BE9B' }
            'DOWN'      = @{ Char = '▼'; Color = '#FF4141' }
        }
        if ($indicatorMap.ContainsKey($Indicator)) {
            $map = $indicatorMap[$Indicator]
            if ($RightAlign) {
                $IndicatorRun = New-Object System.Windows.Documents.Run "$($map.Char)"
            } else {
                $IndicatorRun = New-Object System.Windows.Documents.Run "$($map.Char) "
            }
            $IndicatorRun.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($map.Color)
            $IndicatorRun.FontSize = $IndicatorSize
            $TextBlock.Inlines.Add($IndicatorRun)
        }
    }
    if ($NoNewLine) {
        $Run = New-Object System.Windows.Documents.Run $Text
    } else {
        $Run = New-Object System.Windows.Documents.Run $Text.Trim()
    }
    $Run.Foreground = $Color
    $TextBlock.Inlines.Add($Run)
    if ($NoNewLine) {
        $ExistingBlock = if ($BottomToTop) {
            $SystemWindowsControlsRichTextBox.Document.Blocks.FirstBlock
        } else {
            $SystemWindowsControlsRichTextBox.Document.Blocks.LastBlock
        }
        if ($ExistingBlock -and $ExistingBlock -is [System.Windows.Documents.BlockUIContainer]) {
            foreach ($Inline in @($TextBlock.Inlines)) {
                $ExistingBlock.Child.Inlines.Add($Inline)
            }
            if ($BottomToTop) {
                $SystemWindowsControlsRichTextBox.ScrollToHome()
            } else {
                $SystemWindowsControlsRichTextBox.ScrollToEnd()
            }
            return
        }
    }
    $Block = New-Object System.Windows.Documents.BlockUIContainer $TextBlock
    if ($RightAlign) {
        $Block.TextAlignment = [System.Windows.TextAlignment]::Right
    }
    if ($BottomToTop) {
        $First = $SystemWindowsControlsRichTextBox.Document.Blocks.FirstBlock
        if ($First) {
            $SystemWindowsControlsRichTextBox.Document.Blocks.InsertBefore($First, $Block)
        } else {
            $SystemWindowsControlsRichTextBox.Document.Blocks.Add($Block)
        }
        $SystemWindowsControlsRichTextBox.ScrollToHome()
    } else {
        $SystemWindowsControlsRichTextBox.Document.Blocks.Add($Block)
        if ($TagBackUpdateSize) {
            $tagColors = @{ "$TagBackUpdateSize" = '#ffffff'}
            $tagBg     = @{ "$TagBackUpdateSize" = '#141414'}
            $tb = New-Object System.Windows.Controls.TextBlock
            $tb.Text = $TagBackUpdateSize
            $tb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$TagBackUpdateSize])
            $tb.FontWeight = [System.Windows.FontWeights]::Bold
            $tb.FontSize = 12
            $tb.Padding = [System.Windows.Thickness]::new(8, 2, 8, 2)
            $Border = New-Object System.Windows.Controls.Border
            $Border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBg[$TagBackUpdateSize])
            $Border.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$TagBackUpdateSize])
            $Border.BorderThickness = [System.Windows.Thickness]::new(1)
            $Border.CornerRadius = [System.Windows.CornerRadius]::new(2)
            $Border.Child = $tb
            $Container = New-Object System.Windows.Documents.InlineUIContainer $Border
            $Container.BaselineAlignment = [System.Windows.BaselineAlignment]::Center
            $TextBlock.Inlines.Add((New-Object System.Windows.Documents.Run '  '))
            $TextBlock.Inlines.Add($Container)
        }
        if ($TagBack) {
            $tagColors = @{ 'OPTIONAL' = '#3791EB'; 'IMPORTANT' = '#05BE9B'; 'CRITICAL' = '#FF5541'; 'SECURITY' = '#F0A500'; '⚠REBOOT' = '#FF7D41'; 'DRIVER' = '#ffffff'}
            $tagBg     = @{ 'OPTIONAL' = '#142332'; 'IMPORTANT' = '#0F2828'; 'CRITICAL' = '#281E1E'; 'SECURITY' = '#2D2A10'; '⚠REBOOT' = '#281E1E'; 'DRIVER' = '#141414'}
            $tb = New-Object System.Windows.Controls.TextBlock
            $tb.Text = $TagBack
            $tb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$TagBack])
            $tb.FontWeight = [System.Windows.FontWeights]::Bold
            $tb.FontSize = 12
            $tb.Padding = [System.Windows.Thickness]::new(8, 2, 8, 2)
            $Border = New-Object System.Windows.Controls.Border
            $Border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBg[$TagBack])
            $Border.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors[$TagBack])
            $Border.BorderThickness = [System.Windows.Thickness]::new(1)
            $Border.CornerRadius = [System.Windows.CornerRadius]::new(2)
            $Border.Child = $tb
            $Container = New-Object System.Windows.Documents.InlineUIContainer $Border
            $Container.BaselineAlignment = [System.Windows.BaselineAlignment]::Center
            $TextBlock.Inlines.Add((New-Object System.Windows.Documents.Run '  '))
            $TextBlock.Inlines.Add($Container)
        }
        if ($TagBackReboot) {
            $tagColors = @{ '⚠REBOOT' = '#FF5541'}
            $tagBg     = @{ '⚠REBOOT' = '#281E1E'}
            $tb = New-Object System.Windows.Controls.TextBlock
            $tb.Text = "⚠REBOOT"
            $tb.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors["⚠REBOOT"])
            $tb.FontWeight = [System.Windows.FontWeights]::Bold
            $tb.FontSize = 12
            $tb.Padding = [System.Windows.Thickness]::new(8, 2, 8, 2)
            $Border = New-Object System.Windows.Controls.Border
            $Border.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagBg["⚠REBOOT"])
            $Border.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString($tagColors["⚠REBOOT"])
            $Border.BorderThickness = [System.Windows.Thickness]::new(1)
            $Border.CornerRadius = [System.Windows.CornerRadius]::new(2)
            $Border.Child = $tb
            $Container = New-Object System.Windows.Documents.InlineUIContainer $Border
            $Container.BaselineAlignment = [System.Windows.BaselineAlignment]::Center
            $TextBlock.Inlines.Add((New-Object System.Windows.Documents.Run '  '))
            $TextBlock.Inlines.Add($Container)
        } 
        if ($ScrollUP) {
            $SystemWindowsControlsRichTextBox.ScrollToHome()
        } else {
            $SystemWindowsControlsRichTextBox.ScrollToEnd()
        }
    }
}
function RichTextBoxDeleteLine([System.Windows.Controls.RichTextBox]$SystemWindowsControlsRichTextBox) {
    $SystemWindowsControlsRichTextBox.Document.Blocks.Remove($SystemWindowsControlsRichTextBox.Document.Blocks.LastBlock)
}
function RichTextBoxClear([System.Windows.Controls.RichTextBox]$SystemWindowsControlsRichTextBox) {
    $SystemWindowsControlsRichTextBox.Document.Blocks.Clear()
}