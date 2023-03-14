$ntpServer = "time.windows.com"
$syncintervalSecond = 300

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name NtpServer -Value "$($ntpServer),0x8" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" -Name SpecialPollInterval -Value $($syncintervalSecond)
Set-Service -Name w32time -StartupType Automatic
Restart-Service w32time