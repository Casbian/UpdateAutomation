function ListWindowsUpdate() {
   try {
      if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
         Remove-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
         Install-Module PSWindowsUpdate -Force -Scope AllUsers -ErrorAction SilentlyContinue
      }
      Import-Module PSWindowsUpdate;
      $services = @('wuauserv', 'bits', 'cryptsvc')
      foreach ($serviceName in $services) {
         $serviceRunning = $false;
         while ($serviceRunning -eq $false) {
            $service = Get-Service -Name $serviceName;
            if ($null -eq $service) {
                  break;
            }
            if ($service.Status -ne 'Running') {
                  Start-Service $serviceName;
            } else {
                  $serviceRunning = $true;
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
      <#Do this if a terminating exception happens#>
   }
}
