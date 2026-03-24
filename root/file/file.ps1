function FileCheckAutologon($PSScriptRoot) {
   try {
      $AutologonExePath = Join-Path $PSScriptRoot "file\files\AutoLogon.exe"
      if (Test-Path $AutologonExePath) {
         return 1
      } else {
         return $AutologonExePath
      }
   }
   catch {
      <#SOON#>
   }
}
function FileCheckSettings($PSScriptRoot) {
   try {
      $SettingsFilePath = Join-Path $PSScriptRoot "file\files\settings"
      if (Test-Path $SettingsFilePath) {
         return 1
      } else {
         $Default = @"
Network =
LogEmail =
"@
         New-Item -Path $SettingsFilePath -ItemType File -Force | Out-Null
         Set-Content -Path $SettingsFilePath -Value $Default -Encoding utf8BOM
         return $SettingsFilePath
      }
   } catch {
      <#SOON#>
   }
}