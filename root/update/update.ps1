function Update($MyInvocation) {
   try {
      $LocalVersion = "1.0.7"
      $InstallDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
      $ScriptPath = $MyInvocation.MyCommand.Path
      $Release = Invoke-RestMethod "https://api.github.com/repos/Casbian/CoreForge/releases/latest"
      $OnlineVersion = $Release.tag_name.TrimStart("v")
      if ([version]$OnlineVersion -gt [version]$LocalVersion) {
         $ZipUrl = $Release.zipball_url
            if ($ZipUrl) {
               $TempZip = "$env:TEMP\CoreForge_update.zip"
               $TempExtract = "$env:TEMP\CoreForge_update"
               Start-Process pwsh.exe -ArgumentList "-Command Invoke-WebRequest -Uri '$ZipUrl' -OutFile '$TempZip'" -Wait -WindowStyle Hidden
               if (Test-Path $TempExtract) {
                  Remove-Item $TempExtract -Recurse -Force
               }
               Start-Process pwsh.exe -ArgumentList "-Command Expand-Archive -Path '$TempZip' -DestinationPath '$TempExtract' -Force" -Wait -WindowStyle Hidden
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
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" -WindowStyle Hidden
"@
               $UpdateScriptPath = "$env:TEMP\CoreForge_apply_update.ps1"
               $UpdateScript | Out-File -FilePath $UpdateScriptPath -Encoding utf8BOM
               Start-Process pwsh.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$UpdateScriptPath`"" -WindowStyle Hidden
               exit
            } else {
               return $LocalVersion
            }
         } else {
            return $LocalVersion
         }
   } catch {
      Write-Error "Update check failed: $_"
      return $LocalVersion
   }
}