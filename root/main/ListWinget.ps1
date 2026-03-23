function ListWinget() {
   try {
      $MaxChars = 80
      $Lines = "Y" | winget list --upgrade-available --include-unknown
      $Lines = $Lines -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
      $StringBuilder = New-Object System.Text.StringBuilder
      $AppList = @()
      $OutputStart = $false
      foreach ($Line in $Lines) {
         if (-not $OutputStart -and $Line -like 'Name*') { $OutputStart = $true }
         if ($OutputStart) {
            $TrimmedLine = if ($Line.Length -gt $MaxChars) { $Line.Substring(0, $MaxChars) } else { $Line }
            $StringBuilder.AppendLine($TrimmedLine)
         }
         if ($Line -match '^(.+?)\s+([A-Za-z][\w.-]+\.[A-Za-z][\w.-]+)\s+[\d]') {
            $AppList += @{
               name = $matches[1].Trim()
               id   = $matches[2].Trim()
            }
         }
      }
      return $StringBuilder.ToString().Trim()
   } catch {
      <#Do this if a terminating exception happens#>
   }
}