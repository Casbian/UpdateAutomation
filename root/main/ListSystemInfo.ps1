function ListSystemInfo() {
    $Environment = @('COMPUTERNAME','USERDOMAIN','LOGONSERVER', 'USERNAME')
    $EnvironmentValues = @()
    foreach ($Variable in $Environment) {
        $EnvironmentValues += [System.Environment]::GetEnvironmentVariable($Variable)
    }
    $UserID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $UserPrincipal = New-Object System.Security.Principal.WindowsPrincipal($UserID)
    $UserPrincipal = $UserPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    $EnvironmentValues += $UserPrincipal
    $OS = Get-CimInstance Win32_OperatingSystem
    $EnvironmentValues += $OS.Caption
    $EnvironmentValues += $OS.OSArchitecture
    $EnvironmentValues += @{1='Workstation';2='Domain Controller';3='Server'}[[int]$OS.ProductType]
    $EnvironmentValues += ((Get-Date) - $OS.LastBootUpTime).ToString("d'd 'h'h 'm'm'")
    $NetworkValues = @()
    Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
    $NetworkValues += $_.Description
    $NetworkValues += $_.MACAddress
    $NetworkValues += ($_.IPAddress | Where-Object { $_ -notmatch ':' }) -join ', '
    }
    $CPUValues = @()
    Get-CimInstance Win32_Processor | ForEach-Object {
    $CPUValues += $_.Name.Trim()
    $CPUValues += @{0='x86';1='MIPS';2='Alpha';3='PowerPC';5='ARM';6='ia64';9='x64'}[[int]$_.Architecture]
    $CPUValues += $_.NumberOfCores
    $CPUValues += $_.NumberOfLogicalProcessors
    }
    $GPUValues = @()
    Get-CimInstance Win32_VideoController | ForEach-Object {
    $GPUValues += $_.Name
    $GPUValues += $_.DriverVersion
    }
    # check GPU DRIVER HERE 
    $RAMValues = @()
    Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
    $RAMValues += $_.DeviceLocator
    $RAMValues += [math]::Round($_.Capacity / 1GB, 1)
    $RAMValues += $_.Speed
    }
    return $EnvironmentValues, $NetworkValues, $CPUValues, $GPUValues, $RAMValues
}