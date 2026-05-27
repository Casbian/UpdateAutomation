function CPUGetAdapterValues() {
   $CPUAdapterValues = @()
   Get-CimInstance Win32_Processor | ForEach-Object {
   $CPUAdapterValues += $_.Name.Trim()
   $CPUAdapterValues += @{0='x86';1='MIPS';2='Alpha';3='PowerPC';5='ARM';6='ia64';9='x64'}[[int]$_.Architecture]
   }
   return $CPUAdapterValues
} 