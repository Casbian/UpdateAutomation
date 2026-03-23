function Thread([scriptblock]$Task,[System.Management.Automation.Runspaces.RunspacePool]$ThreadPool,[scriptblock]$Function,[object]$Parameter,[string]$TaskName) {
   $PowershellRunspace = [powershell]::Create()
   $PowershellRunspace.RunspacePool = $ThreadPool
   $PowershellRunspace.AddScript($Task)                        | Out-Null
   $PowershellRunspace.AddParameter('Function',  $Function)    | Out-Null
   $PowershellRunspace.AddParameter('Parameter', $Parameter)   | Out-Null
   $Handle     = $PowershellRunspace.BeginInvoke()
   $Frames     = @("◐︎", "◓︎", "◑︎", "◒︎")
   $FrameIndex = 0
   while (-not $Handle.IsCompleted) {
      $Frame = $Frames[$FrameIndex % $Frames.Count]
      RichTextBox $SystemWindowsControlsRichTextBox0 "> SYSTEM               | $Frame $TaskName $Frame" -RemoveLast -Color ([System.Windows.Media.Brushes]::Cyan)  | Out-Null
      Window  | Out-Null
      $FrameIndex++
   }
   $Result = $PowershellRunspace.EndInvoke($Handle)
   $PowershellRunspace.Dispose()
   return $Result
}