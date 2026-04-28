function RichTextBox([System.Windows.Controls.RichTextBox]$SystemWindowsControlsRichTextBox, [string]$Text, [switch]$Clear, [switch]$RemoveLast, [switch]$Replace, [System.Windows.Media.Brush]$Color = [System.Windows.Media.Brushes]::White) {
    if ($Clear) { $SystemWindowsControlsRichTextBox.Document.Blocks.Clear() }
    if ($RemoveLast -and $SystemWindowsControlsRichTextBox.Document.Blocks.Count -gt 0) {
        $SystemWindowsControlsRichTextBox.Document.Blocks.Remove($SystemWindowsControlsRichTextBox.Document.Blocks.LastBlock)
    }
    if ($Replace -and $SystemWindowsControlsRichTextBox.Document.Blocks.Count -gt 0) {
        $Run = New-Object System.Windows.Documents.Run $Text.Trim()
        $Run.Foreground = $Color
        $Paragraph = New-Object System.Windows.Documents.Paragraph $Run
        $Paragraph.Margin = [System.Windows.Thickness]::new(0)
        $SystemWindowsControlsRichTextBox.Document.Blocks.Add($Paragraph)
        $SystemWindowsControlsRichTextBox.ScrollToEnd()
        $SystemWindowsControlsRichTextBox.Document.Blocks.Remove($SystemWindowsControlsRichTextBox.Document.Blocks.LastBlock)
        return
    }
    $Run = New-Object System.Windows.Documents.Run $Text.Trim()
    $Run.Foreground = $Color
    $Paragraph = New-Object System.Windows.Documents.Paragraph $Run
    $Paragraph.Margin = [System.Windows.Thickness]::new(0)
    $SystemWindowsControlsRichTextBox.Document.Blocks.Add($Paragraph)
    $SystemWindowsControlsRichTextBox.ScrollToEnd()
}