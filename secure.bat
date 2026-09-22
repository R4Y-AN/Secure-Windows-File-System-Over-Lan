@echo off
set "OK=1"

netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound >nul 2>&1
if errorlevel 1 set "OK=0"

netsh advfirewall firewall set rule group="Network Discovery" new enable=No >nul 2>&1
if errorlevel 1 set "OK=0"

netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No >nul 2>&1
if errorlevel 1 set "OK=0"

sc config WinRM start= disabled >nul 2>&1
if errorlevel 1 set "OK=0"
sc stop WinRM >nul 2>&1

sc config RemoteRegistry start= disabled >nul 2>&1
if errorlevel 1 set "OK=0"
sc stop RemoteRegistry >nul 2>&1

sc config LanmanServer start= disabled >nul 2>&1
if errorlevel 1 set "OK=0"
sc stop LanmanServer >nul 2>&1

cls

if "%OK%"=="1" (
    echo.
    echo Done
    echo.
) else (
    echo.
    echo Please run it as administrator. 
    echo.
)

pause