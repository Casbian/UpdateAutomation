function AppGetStatus() {
   try {
      winget source add --name "winget" --arg "https://cdn.winget.microsoft.com/cache" --type "Microsoft.PreIndexed.Package" | Out-Null
      winget source add --name "msstore" --arg "https://storeedgefd.dsx.mp.microsoft.com/v9.0" --type "Microsoft.Rest" | Out-Null
      winget source update | Out-Null
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
function AppGetApplist() {
   try {
      winget source add --name "winget" --arg "https://cdn.winget.microsoft.com/cache" --type "Microsoft.PreIndexed.Package" | Out-Null
      winget source add --name "msstore" --arg "https://storeedgefd.dsx.mp.microsoft.com/v9.0" --type "Microsoft.Rest" | Out-Null
      winget source update | Out-Null
      $Output = winget list --upgrade-available --include-unknown --accept-source-agreements
      $Output = $Output -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
      $AppList = @()
      foreach ($Line in $Output) {
         if ($Line -match '^(.+?)\s+([A-Za-z0-9][\w.-]+\.[A-Za-z0-9][\w.-]+)\s+[\d]') {
            $AppList += @{
            name = $matches[1].Trim()
            id   = $matches[2].Trim()
            }
         }
      }
      return $AppList
   } catch {
      <#Do this if a terminating exception happens#>
   }
}