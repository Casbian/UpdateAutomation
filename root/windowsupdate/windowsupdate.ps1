function WindowsUpdateGetStatus() {
   try {
      if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
         Remove-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
         Install-Module PSWindowsUpdate -Force -Scope AllUsers -ErrorAction SilentlyContinue
      }
      Import-Module PSWindowsUpdate;
      $Services = @('wuauserv', 'bits', 'cryptsvc')
      foreach ($ServiceName in $Services) {
         $ServiceRunning = $false;
         while ($ServiceRunning -eq $false) {
            $Service = Get-Service -Name $ServiceName;
            if ($null -eq $Service) {
                  break;
            }
            if ($Service.Status -ne 'Running') {
                  Start-Service $ServiceName;
            } else {
                  $ServiceRunning = $true;
                  break;
            }
         }
      }
      $Output = Get-WindowsUpdate -IgnoreReboot
      if ($Output | Where-Object { $_.RebootRequired -eq $true }) {
         return 1
      }
      if ($Output.Count -eq 0) {
         return 0
      } else {
         $StringBuilder = New-Object System.Text.StringBuilder
         $Output = Get-WindowsUpdate -Verbose -IgnoreReboot 4>&1
         foreach ($Line in $Output) {
            $TrimmedLine = $Line.Message -replace 'Please wait\.\.\.', ''
            $StringBuilder.AppendLine($TrimmedLine) | Out-Null
         }
      }
      return $StringBuilder.ToString()
   } catch {
      <#SOON#>
   }
}