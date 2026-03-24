function ListWinget() {
   try {
      $MaxChars = 80
      $Output = winget list --upgrade-available --include-unknown --accept-source-agreements 4>&1
      $Output = $Output -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
      $StringBuilder = New-Object System.Text.StringBuilder
      $OutputStart = $false
      foreach ($Line in $Output) {
         if (-not $OutputStart -and $Line -like 'Name*') { $OutputStart = $true }
         if ($OutputStart) {
            $TrimmedLine = if ($Line.Length -gt $MaxChars) { $Line.Substring(0, $MaxChars) } else { $Line }
            $StringBuilder.AppendLine($TrimmedLine) | Out-Null
         }
      }
      return $StringBuilder.ToString().Trim()
   } catch {
      <#SOON#>
   }
}