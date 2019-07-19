echo off
cls
echo [*] Logon Session
echo [*] Logon (Success)
type le_logon_session_4624.txt | findstr /C:"Date" /C:"Logon Type" 
@echo:
echo [*] Logon (Failure)
type le_logon_session_4625.txt | findstr /C:"Date" /C:"Source Network Address" 
@echo: 
@echo: 
echo [*] Schedule Tasks
type st_schtasks.txt | findstr /C:"/20"
@echo: 
@echo: 
echo [*]  User Account Changes
type ac_net_user.txt
@echo: 
@echo: 
pause
