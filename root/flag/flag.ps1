function ChecklastautomatedrunFlag($PSScriptRoot) {
   try {
      $Today = Get-Date -Format 'yyyy-MM-dd'
      $FlagFile = Join-Path $PSScriptRoot "flag\flags\lastautomatedrun"
      if ((Test-Path $FlagFile) -and (Get-Content $FlagFile) -eq $Today) {
         return 1
      } else {
         New-Item -Path $FlagFile -ItemType File -Force | Out-Null
         Set-Content -Path $FlagFile -Value $Today -Encoding utf8BOM
         return 0
      }
   } catch {
      <#SOON#>
   }
}