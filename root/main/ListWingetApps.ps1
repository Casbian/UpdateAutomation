function ListWingetApps {
   try {
      $MaxChars = 80
      $Lines = "Y" | winget list --upgrade-available --include-unknown
      $Lines = $Lines -replace 'Verf├╝gbar','verfügbar' -replace 'ÔÇ…','…' -replace '├ñ','ä' -replace '├Ñ','Ä' -replace '├╝','ü' -replace '├┐','Ö' -replace '├╢','ß' -replace 'ÔÇª','…' -replace '├ü','ü' -replace '├Ä','ä' -replace '├Ö','ö' -replace '├Ü','Ü'
      $AppList = @()
      foreach ($Line in $Lines) {
         if ($Line -match '^(.+?)\s+([A-Za-z][\w.-]+\.[A-Za-z][\w.-]+)\s+[\d]') {
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
