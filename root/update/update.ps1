function Update($MyInvocation) {
   $CurrentVersion = "1.0.0"
   $InstallDir = Split-Path -Parent $MyInvocation.MyCommand.Path
   $ScriptPath = $MyInvocation.MyCommand.Path
   try {
      $Release = Invoke-RestMethod "https://api.github.com/repos/Casbian/CoreForge/releases/latest"
      $LatestVersion = $Release.tag_name.TrimStart("v")
      if ([version]$LatestVersion -gt [version]$CurrentVersion) {
         $ZipUrl = $Release.zipball_url
            if ($ZipUrl) {
               $TempZip = "$env:TEMP\CoreForge_update.zip"
               $TempExtract = "$env:TEMP\CoreForge_update"
               Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip
               if (Test-Path $TempExtract) {
                  Remove-Item $TempExtract -Recurse -Force
               }
               Expand-Archive -Path $TempZip -DestinationPath $TempExtract
               $UpdateScript = @"
`$ScriptPath = $ScriptPath
Get-ChildItem -Path "$InstallDir" -Recurse | Remove-Item -Recurse -Force
`$Source = Get-ChildItem "$TempExtract" | Where-Object { `$_.PSIsContainer } | Select-Object -First 1
if (`$Source) {
   Copy-Item "`$(`$Source.FullName)\*" "$InstallDir" -Recurse -Force
} else {
   Copy-Item "$TempExtract\*" "$InstallDir" -Recurse -Force
}
Remove-Item "$TempZip" -Force -ErrorAction SilentlyContinue
Remove-Item "$TempExtract" -Recurse -Force -ErrorAction SilentlyContinue
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""
"@
               $UpdateScriptPath = "$env:TEMP\CoreForge_apply_update.ps1"
               $UpdateScript | Out-File -FilePath $UpdateScriptPath -Encoding utf8BOM
               Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$UpdateScriptPath`"" 
               exit
            } else {
               return $CurrentVersion
            }
         } else {
            return $CurrentVersion
         }
   } catch {
      Write-Error "Update check failed: $_"
      return $CurrentVersion
   }
}