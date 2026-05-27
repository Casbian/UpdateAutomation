function RAMGetAdapterValues() {
   $RAMAdapterValues = @()
   Get-CimInstance Win32_PhysicalMemory | ForEach-Object {
   $RAMAdapterValues += $_.DeviceLocator
   $RAMAdapterValues += "$([math]::Round($_.Capacity / 1GB, 2))"
   $RAMAdapterValues += $_.Speed
   }
   return $RAMAdapterValues
} 