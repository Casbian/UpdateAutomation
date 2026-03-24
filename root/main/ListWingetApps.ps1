function ListWingetApps() {
   try {
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