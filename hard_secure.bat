@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Secure Windows Over LAN! Created by _raayyyaaaannnnn_

fltmc >nul 2>&1
if errorlevel 1 (
    echo.
    echo Please run it as administrator.
    echo.
    pause
    exit /b 1
)

set "FW=0"
set "DISC=0"
set "SHARE=0"
set "RDP=0"
set "RA=0"
set "WINRM=0"
set "PSR=0"
set "RR=0"
set "SMB=0"
set "SMB1=0"
set "LLMNR=0"
set "NBT=0"
set "PROFILE=0"
set "LOG=0"
set "RULES=0"
set "SMB445=0"

set "WARN139=0"

echo.
echo Secure Windows Over LAN
echo.
echo Applying security settings...
echo.

netsh advfirewall set allprofiles state on >nul 2>&1
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$f=@(Get-NetFirewallProfile); if($f.Count -eq 3 -and @($f | Where-Object {$_.Enabled -eq $true -and $_.DefaultInboundAction -eq 'Block' -and $_.DefaultOutboundAction -eq 'Allow'}).Count -eq 3){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "FW=0"
) else (
    set "FW=1"
)

netsh advfirewall firewall set rule group="Network Discovery" new enable=No >nul 2>&1

netsh advfirewall firewall show rule group="Network Discovery" | findstr /I "Enabled:.*Yes" >nul 2>&1

if errorlevel 1 (
    set "DISC=1"
)

netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No >nul 2>&1

netsh advfirewall firewall show rule group="File and Printer Sharing" | findstr /I "Enabled:.*Yes" >nul 2>&1

if errorlevel 1 (
    set "SHARE=1"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul 2>&1

netsh advfirewall firewall set rule group="Remote Desktop" new enable=No >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -ErrorAction Stop; if($r.fDenyTSConnections -eq 1){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "RDP=0"
) else (
    set "RDP=1"
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f >nul 2>&1

netsh advfirewall firewall set rule group="Remote Assistance" new enable=No >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance' -ErrorAction Stop; if($r.fAllowToGetHelp -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "RA=0"
) else (
    set "RA=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; Disable-PSRemoting -Force" >nul 2>&1

if errorlevel 1 (
    set "PSR=0"
) else (
    set "PSR=1"
)


sc config WinRM start= disabled >nul 2>&1
sc stop WinRM >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=Get-CimInstance Win32_Service -Filter ""Name='WinRM'"" -ErrorAction Stop; if($s.StartMode -eq 'Disabled' -and $s.State -ne 'Running'){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "WINRM=0"
) else (
    set "WINRM=1"
)

sc config RemoteRegistry start= disabled >nul 2>&1
sc stop RemoteRegistry >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=Get-CimInstance Win32_Service -Filter ""Name='RemoteRegistry'"" -ErrorAction Stop; if($s.StartMode -eq 'Disabled' -and $s.State -ne 'Running'){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "RR=0"
) else (
    set "RR=1"
)

sc config LanmanServer start= disabled >nul 2>&1
sc stop LanmanServer >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$s=Get-CimInstance Win32_Service -Filter ""Name='LanmanServer'"" -ErrorAction Stop; if($s.StartMode -eq 'Disabled' -and $s.State -ne 'Running'){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "SMB=0"
) else (
    set "SMB=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$f=Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue; if($null -eq $f){exit 0}; if($f.State -in @('Disabled','DisabledWithPayloadRemoved','Removed')){exit 0}; Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction Stop | Out-Null" >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$f=Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue; if($null -eq $f -or $f.State -in @('Disabled','DisabledWithPayloadRemoved','Removed')){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "SMB1=0"
) else (
    set "SMB1=1"
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v EnableMulticast /t REG_DWORD /d 0 /f >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -ErrorAction Stop; if($r.EnableMulticast -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "LLMNR=0"
) else (
    set "LLMNR=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $c=@(Get-CimInstance Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE'); foreach($x in $c){$r=Invoke-CimMethod -InputObject $x -MethodName SetTcpipNetbios -Arguments @{TcpipNetbiosOptions=2}; if($r.ReturnValue -ne 0){exit 1}}" >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$c=@(Get-CimInstance Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE'); if(@($c | Where-Object {$_.TcpipNetbiosOptions -ne 2}).Count -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "NBT=0"
) else (
    set "NBT=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $p=@(Get-NetConnectionProfile); foreach($x in $p){if($x.NetworkCategory -ne 'DomainAuthenticated'){Set-NetConnectionProfile -InterfaceIndex $x.InterfaceIndex -NetworkCategory Public -ErrorAction Stop}}" >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=@(Get-NetConnectionProfile); if(@($p | Where-Object {$_.NetworkCategory -ne 'Public' -and $_.NetworkCategory -ne 'DomainAuthenticated'}).Count -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "PROFILE=0"
) else (
    set "PROFILE=1"
)

netsh advfirewall set allprofiles logging droppedconnections enable >nul 2>&1
netsh advfirewall set allprofiles logging allowedconnections disable >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$f=@(Get-NetFirewallProfile); if(@($f | Where-Object {$_.LogBlocked -ne $true -or $_.LogAllowed -eq $true}).Count -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "LOG=0"
) else (
    set "LOG=1"
)

netsh advfirewall firewall delete rule name="LAN-Securing-Block-SMB-TCP" >nul 2>&1
netsh advfirewall firewall delete rule name="LAN-Securing-Block-NetBIOS-UDP" >nul 2>&1
netsh advfirewall firewall delete rule name="LAN-Securing-Block-NetBIOS-TCP" >nul 2>&1

netsh advfirewall firewall add rule name="LAN-Securing-Block-SMB-TCP" dir=in action=block protocol=TCP localport=139,445 profile=any >nul 2>&1
netsh advfirewall firewall add rule name="LAN-Securing-Block-NetBIOS-UDP" dir=in action=block protocol=UDP localport=137,138 profile=any >nul 2>&1
netsh advfirewall firewall add rule name="LAN-Securing-Block-NetBIOS-TCP" dir=in action=block protocol=TCP localport=139 profile=any >nul 2>&1

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$names=@('LAN-Securing-Block-SMB-TCP','LAN-Securing-Block-NetBIOS-UDP','LAN-Securing-Block-NetBIOS-TCP'); foreach($n in $names){$r=@(Get-NetFirewallRule -DisplayName $n -ErrorAction SilentlyContinue); if($r.Count -ne 1){exit 1}; if($r[0].Enabled -ne $true){exit 1}; if($r[0].Direction.ToString() -ne 'Inbound'){exit 1}; if($r[0].Action.ToString() -ne 'Block'){exit 1}}; exit 0" >nul 2>&1

if errorlevel 1 (
    set "RULES=0"
) else (
    set "RULES=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=@(Get-NetTCPConnection -State Listen -LocalPort 445 -ErrorAction SilentlyContinue); if($p.Count -eq 0){exit 0}else{exit 1}" >nul 2>&1

if errorlevel 1 (
    set "SMB445=0"
) else (
    set "SMB445=1"
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$p=@(Get-NetTCPConnection -State Listen -LocalPort 139 -ErrorAction SilentlyContinue); if($p.Count -gt 0){exit 0}else{exit 1}" >nul 2>&1

if not errorlevel 1 (
    set "WARN139=1"
)

echo Successfully Secured:
echo.

if "%FW%"=="1" echo [OK] Windows Firewall - inbound blocked / outbound allowed
if "%DISC%"=="1" echo [OK] Network Discovery disabled
if "%SHARE%"=="1" echo [OK] File and Printer Sharing firewall rules disabled
if "%RDP%"=="1" echo [OK] Remote Desktop disabled
if "%RA%"=="1" echo [OK] Remote Assistance disabled
if "%WINRM%"=="1" echo [OK] WinRM service disabled and stopped
if "%PSR%"=="1" echo [OK] PowerShell Remoting configuration disabled
if "%RR%"=="1" echo [OK] Remote Registry disabled and stopped
if "%SMB%"=="1" echo [OK] Windows SMB Server disabled
if "%SMB1%"=="1" echo [OK] SMBv1 disabled
if "%LLMNR%"=="1" echo [OK] LLMNR disabled
if "%NBT%"=="1" echo [OK] NetBIOS over TCP/IP disabled
if "%PROFILE%"=="1" echo [OK] Network profiles secured as Public/Domain
if "%LOG%"=="1" echo [OK] Firewall dropped-connection logging enabled
if "%RULES%"=="1" echo [OK] SMB/NetBIOS inbound firewall block rules active
if "%SMB445%"=="1" echo [OK] No TCP 445 listener detected

echo.

echo Could Not Secure / Verify:
echo.

if "%FW%"=="0" echo [FAIL] Windows Firewall
if "%DISC%"=="0" echo [FAIL] Network Discovery
if "%SHARE%"=="0" echo [FAIL] File and Printer Sharing
if "%RDP%"=="0" echo [FAIL] Remote Desktop
if "%RA%"=="0" echo [FAIL] Remote Assistance
if "%WINRM%"=="0" echo [FAIL] WinRM service
if "%PSR%"=="0" echo [FAIL] PowerShell Remoting configuration
if "%RR%"=="0" echo [FAIL] Remote Registry
if "%SMB%"=="0" echo [FAIL] Windows SMB Server
if "%SMB1%"=="0" echo [FAIL] SMBv1
if "%LLMNR%"=="0" echo [FAIL] LLMNR
if "%NBT%"=="0" echo [FAIL] NetBIOS over TCP/IP
if "%PROFILE%"=="0" echo [FAIL] Network Profile
if "%LOG%"=="0" echo [FAIL] Firewall Logging
if "%RULES%"=="0" echo [FAIL] SMB/NetBIOS Firewall Rules
if "%SMB445%"=="0" echo [FAIL] TCP 445 still has a listener

echo.

echo Warnings:
echo.

if "%WARN139%"=="1" echo [WARN] TCP 139 is still listening. Your inbound firewall rules block TCP 139, so it is still protected by the firewall :)

if "%WARN139%"=="0" echo [OK] No TCP 139 listener detected.

echo.
echo ========================================

set "TOTALFAIL=0"

if "%FW%"=="0" set "TOTALFAIL=1"
if "%DISC%"=="0" set "TOTALFAIL=1"
if "%SHARE%"=="0" set "TOTALFAIL=1"
if "%RDP%"=="0" set "TOTALFAIL=1"
if "%RA%"=="0" set "TOTALFAIL=1"
if "%WINRM%"=="0" set "TOTALFAIL=1"
if "%PSR%"=="0" set "TOTALFAIL=1"
if "%RR%"=="0" set "TOTALFAIL=1"
if "%SMB%"=="0" set "TOTALFAIL=1"
if "%SMB1%"=="0" set "TOTALFAIL=1"
if "%LLMNR%"=="0" set "TOTALFAIL=1"
if "%NBT%"=="0" set "TOTALFAIL=1"
if "%PROFILE%"=="0" set "TOTALFAIL=1"
if "%LOG%"=="0" set "TOTALFAIL=1"
if "%RULES%"=="0" set "TOTALFAIL=1"
if "%SMB445%"=="0" set "TOTALFAIL=1"

if "%TOTALFAIL%"=="0" (
    echo.
    echo SUCCESS
    echo.
) else (
    echo.
    echo PARTIAL FAILURE
    echo.
)

echo Reboot your computer please ;)
echo.
pause

endlocal
