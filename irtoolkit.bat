:: Incident Response Toolkit (IR Toolkit) v2.0.1
:: Author: g4xyk00
:: Tested on Windows 10

echo off
cls
pushd %~dp0

echo Incident Response Toolkit (IR Toolkit)
echo Created by: Gary Kong (g4xyk00)
echo Version: 2.0.1
echo Homepage: www.axcelsec.com
@echo:

set reportCount=10

:: To Create Folder
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1-2 delims=: " %%a in ('time /t') do (set systime=%%a%%b)
For /f "tokens=2 delims= " %%a in ('time /t') do (set sysampm=%%a)
For /f "tokens=3 delims=: " %%a in ('echo %time%') do (set syssecond=%%a)
set folder=%sysdate%_%sysampm%_%systime%_%syssecond%
mkdir %folder%
cd %folder%

:: To Obtain Current SID
For /f "tokens=2 delims=\" %%a in ('whoami') do (set currentUser=%%a)
wmic useraccount where name="%currentUser%" get sid | findstr "S-" > currentsid
set /P currentSID=<currentsid
For /f "tokens=1 delims= " %%a in ('echo %currentSID%') do (set currentSID=%%a)


:: [SI] System information
echo [+] Generating report for system information (1/%reportCount%)
systeminfo > si_systeminfo.txt
ipconfig /all > si_ipconfig.txt

:: [SI-1] Basic System Configuration
echo     [*] Basic System Configuration
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" si_01_computername.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" si_01_computerinfo.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" si_01_timezone.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USBSTOR" si_01_usbconnect.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices" si_01_driveletter.reg 2>nul 1>nul 

:: [SI-2] Network Information
echo     [*] Network Information
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" si_02_networkAdaptor.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" si_02_networkConnected.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares" si_02_localShare.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy" si_02_firewallSetting.reg 2>nul 1>nul 

:: [SI-3] User and Security Information
echo     [*] User and Security Information
reg export "HKEY_LOCAL_MACHINE\SECURITY\Policy" si_03_securityPolicy.reg 2>nul 1>nul 
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" si_03_userSID.reg 2>nul 1>nul  
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy" si_03_groupMembership.reg 2>nul 1>nul


:: [PS] Processes and Services 
echo [+] Generating report for processes and services (2/%reportCount%)
tasklist > ps_tasklist.txt
tasklist /svc > ps_tasklist_svc.txt
wmic process list full > ps_wmic_process_list_full.txt 
net start > ps_net_start.txt
sc query > ps_sc_query.txt

:: Application launched through Windows Explorer Shell
echo     [*] Application launched through Windows Explorer Shell
reg export "HKEY_USERS\%currentSID%\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist" ps_userAssist.reg 2>nul 1>nul 

:: Programs executed
echo     [*] Programs executed
reg export "HKEY_USERS\%currentSID%_Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" ps_MUICache.reg 2>nul 1>nul 


:: [FR] Files and Registry Keys
echo [+] Generating report for files and registry keys (3/%reportCount%)
dir /A /Q c:\ > fr_dir_c.txt
dir %SystemRoot%\system32 /Q > fr_dir_systemroot.txt
dir %SystemRoot%\Prefetch /Q > fr_dir_prefetch.txt
dir %USERPROFILE%\Recent /Q  >  fr_dir_recent.txt 2>nul 1>nul

:: Startup Folder
echo     [*] Startup Folder
reg export HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run fr_reg_query_HKLM_run.reg 2>nul 1>nul 
reg export HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run fr_reg_query_HKCU_run.reg 2>nul 1>nul
reg export HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce fr_reg_query_HKLM_RunOnce.reg 2>nul 1>nul
reg export HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce fr_reg_query_HKCU_RunOnce.reg 2>nul 1>nul

:: Folder viewed
echo     [*] Folder Viewed
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" fr_reg_query_explorer_typedpaths.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" fr_reg_query_local_shell.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU" fr_reg_query_win_shell_bagmru.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Bags" fr_reg_query_win_shell.reg 2>nul 1>nul

:: Windows "Open/Save as" dialog
echo     [*] Windows "Open/Save as" dialog
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" fr_reg_query_OpenSavePidlMRU.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" fr_reg_query_LastVisitedPidlMRU.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\CIDSizeMRU" fr_reg_query_CIDSizeMRU.reg 2>nul 1>nul

:: Programs lauched from Run box
echo     [*] Programs lauched from Run box
reg export "HKEY_USERS\%currentSID%\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" fr_reg_query_RunMRU.reg 2>nul 1>nul

:: Recently opened document
echo     [*] Recently opened document
reg export "HKEY_USERS\%currentSID%\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" fr_reg_query_RecentDocs.reg 2>nul 1>nul

:: Internet Explorer
echo     [*] Internet Explorer
reg export "HKEY_USERS\S-1-5-21-1672240292-986862362-1165397131-3900\Software\Microsoft\Internet Explorer\TypedURLs" fr_iexplorer.reg 2>nul 1>nul


:: Foxit Reader 9.0
echo     [*] Foxit Reader
reg export "HKEY_CURRENT_USER\Software\Foxit Software\Foxit Reader 9.0\MRU" fr_od_mru_pdf.reg 2>nul 1>nul 

echo     [*] Office
:: Office 2016: 16.0
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\Trusted Documents\TrustRecords" fr_fr_od_16_trust_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\Security\Trusted Documents\TrustRecords" fr_fr_od_16_trust_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint\Security\Trusted Documents\TrustRecords"  fr_fr_od_16_trust_ppt.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\User MRU" fr_fr_od_16_mru_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Excel\User MRU" fr_fr_od_16_mru_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\PowerPoint\User MRU" fr_fr_od_16_mru_ppt.reg 2>nul 1>nul

:: Office 2013: 15.0
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Word\Security\Trusted Documents\TrustRecords" fr_od_15_trust_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Excel\Security\Trusted Documents\TrustRecords" fr_od_15_trust_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\PowerPoint\Security\Trusted Documents\TrustRecords" fr_od_15_trust_ppt.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Word\User MRU" fr_od_15_mru_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Excel\User MRU" fr_od_15_mru_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\PowerPoint\User MRU" fr_od_15_mru_ppt.reg 2>nul 1>nul

:: Office 2010: 14.0
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Word\Security\Trusted Documents\TrustRecords" fr_od_14_trust_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Excel\Security\Trusted Documents\TrustRecords" fr_od_14_trust_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\PowerPoint\Security\Trusted Documents\TrustRecords" fr_od_14_trust_ppt.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Word\User MRU" fr_od_14_mru_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\Excel\User MRU" fr_od_14_mru_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\14.0\PowerPoint\User MRU" fr_od_14_mru_ppt.reg 2>nul 1>nul

:: Office 2007: 12.0
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\Security\Trusted Documents\TrustRecords" fr_od_12_trust_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\Security\Trusted Documents\TrustRecords" fr_od_12_trust_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\Security\Trusted Documents\TrustRecords" fr_od_12_trust_ppt.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Word\User MRU" fr_od_12_mru_doc.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\Excel\User MRU" fr_od_12_mru_xls.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Office\12.0\PowerPoint\User MRU" fr_od_12_mru_ppt.reg 2>nul 1>nul

:: Uninstall
echo     [*] Uninstall
reg export "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall" fr_uninstall_local.reg 2>nul 1>nul
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall" fr_uninstall_current.reg 2>nul 1>nul

:: Shim Cache (Application Compatibility Cache)
echo     [*] Shim Cache
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" fr_shimCache.reg 2>nul 1>nul  

:: Services
echo     [*] Services
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services" fr_services.reg 2>nul 1>nul  

:: Active Setup (StubPath)
echo     [*] StubPath
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components" fr_activeSetup.reg 2>nul 1>nul

:: DLL loaded when app linked to user32.dll is launched (AppInit_DLLs)
echo     [*] AppInit_DLLs
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" fr_appInit.reg 2>nul 1>nul

:: Local Security Authority (LSA) Packages (Authentication Packages, Notification Packages, Security Packages)
echo     [*] LSA Packages
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" fr_LSA.reg 2>nul 1>nul

:: Internet Explorer Browser Helper Objects (InprocServer32)
echo     [*] InprocServer32
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" fr_bho.reg 2>nul 1>nul

:: Shell Extensions - Windows Explorer (InprocServer32)
reg export "HKEY_CLASSES_ROOT\CLSID" fr_shellExtension.reg 2>nul 1>nul

:: Winlogon Shell (Shell, Userinit)
echo     [*] Winlogon Shell
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" fr_winlogon_local.reg 2>nul 1>nul
reg export "HKEY_USERS\%currentSID%\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" fr_winlogon_current.reg 2>nul 1>nul


:: [NU] Network Usage 
echo [+] Generating report for network usage (4/%reportCount%)
net view \\127.0.0.1 > nu_net_view.txt
net session > nu_net_session.txt
net use > nu_net_use.txt
nbtstat -S > nu_nbtstat.txt
netstat -ano > nu_netstat_ano.txt
netsh firewall show config > nu_netsh_firewall.txt

:: Remote Desktop
echo     [*] Remote Desktop
reg export "HKEY_USERS\%currentSID%\Software\Microsoft\Terminal Server Client" nu_RemoteDesktop.reg 2>nul 1>nul

:: [ST] Scheduled Tasks
echo [+] Generating report for scheduled tasks (5/%reportCount%)
schtasks > st_schtasks.txt
wmic startup list full > st_wmic_startup_list_full.txt

:: [AC] Accounts
echo [+] Generating report for accounts (6/%reportCount%)
net user > ac_net_user.txt
net localgroup administrators > ac_localgroup.txt

:: [LE] Log Entries
:: User Account Changes
echo [+] Generating report for user account changes (7/%reportCount%)
wevtutil qe security /f:text /q:*[System[(EventID=4720)]] > le_user_account_4720.txt
wevtutil qe security /f:text /q:*[System[(EventID=4722)]] > le_user_account_4722.txt
wevtutil qe security /f:text /q:*[System[(EventID=4723)]] > le_user_account_4723.txt
wevtutil qe security /f:text /q:*[System[(EventID=4724)]] > le_user_account_4724.txt
wevtutil qe security /f:text /q:*[System[(EventID=4725)]] > le_user_account_4725.txt
wevtutil qe security /f:text /q:*[System[(EventID=4726)]] > le_user_account_4726.txt
wevtutil qe security /f:text /q:*[System[(EventID=4738)]] > le_user_account_4738.txt
wevtutil qe security /f:text /q:*[System[(EventID=4740)]] > le_user_account_4740.txt
wevtutil qe security /f:text /q:*[System[(EventID=4767)]] > le_user_account_4767.txt
wevtutil qe security /f:text /q:*[System[(EventID=4781)]] > le_user_account_4781.txt

:: Domain Controller Authentication
echo [+] Generating report for domain controller authentication (8/%reportCount%)
wevtutil qe security /f:text /q:*[System[(EventID=4768)]] > le_domain_controller_4768.txt
wevtutil qe security /f:text /q:*[System[(EventID=4771)]] > le_domain_controller_4771.txt
wevtutil qe security /f:text /q:*[System[(EventID=4772)]] > le_domain_controller_4772.txt

:: Group changes
:: Created
echo [+] Generating report for group changes (9/%reportCount%)
wevtutil qe security /f:text /q:*[System[(EventID=4731)]] > le_group_changes_created_4731.txt
wevtutil qe security /f:text /q:*[System[(EventID=4727)]] > le_group_changes_created_4727.txt
wevtutil qe security /f:text /q:*[System[(EventID=4754)]] > le_group_changes_created_4754.txt
wevtutil qe security /f:text /q:*[System[(EventID=4744)]] > le_group_changes_created_4744.txt
wevtutil qe security /f:text /q:*[System[(EventID=4749)]] > le_group_changes_created_4749.txt
wevtutil qe security /f:text /q:*[System[(EventID=4759)]] > le_group_changes_created_4759.txt

:: Changed
wevtutil qe security /f:text /q:*[System[(EventID=4735)]] > le_group_changes_changed_4735.txt
wevtutil qe security /f:text /q:*[System[(EventID=4737)]] > le_group_changes_changed_4737.txt
wevtutil qe security /f:text /q:*[System[(EventID=4755)]] > le_group_changes_changed_4755.txt
wevtutil qe security /f:text /q:*[System[(EventID=4745)]] > le_group_changes_changed_4745.txt
wevtutil qe security /f:text /q:*[System[(EventID=4750)]] > le_group_changes_changed_4750.txt
wevtutil qe security /f:text /q:*[System[(EventID=4760)]] > le_group_changes_changed_4760.txt

:: Deleted
wevtutil qe security /f:text /q:*[System[(EventID=4734)]] > le_group_changes_deleted_4734.txt
wevtutil qe security /f:text /q:*[System[(EventID=4730)]] > le_group_changes_deleted_4730.txt
wevtutil qe security /f:text /q:*[System[(EventID=4758)]] > le_group_changes_deleted_4758.txt
wevtutil qe security /f:text /q:*[System[(EventID=4748)]] > le_group_changes_deleted_4748.txt
wevtutil qe security /f:text /q:*[System[(EventID=4753)]] > le_group_changes_deleted_4753.txt
wevtutil qe security /f:text /q:*[System[(EventID=4763)]] > le_group_changes_deleted_4763.txt

:: Member - Added
wevtutil qe security /f:text /q:*[System[(EventID=4732)]] > le_group_changes_added_4732.txt
wevtutil qe security /f:text /q:*[System[(EventID=4728)]] > le_group_changes_added_4728.txt
wevtutil qe security /f:text /q:*[System[(EventID=4756)]] > le_group_changes_added_4756.txt
wevtutil qe security /f:text /q:*[System[(EventID=4746)]] > le_group_changes_added_4746.txt
wevtutil qe security /f:text /q:*[System[(EventID=4751)]] > le_group_changes_added_4751.txt
wevtutil qe security /f:text /q:*[System[(EventID=4761)]] > le_group_changes_added_4761.txt

:: Member - Removed
wevtutil qe security /f:text /q:*[System[(EventID=4733)]] > le_group_changes_removed_4733.txt
wevtutil qe security /f:text /q:*[System[(EventID=4729)]] > le_group_changes_removed_4729.txt
wevtutil qe security /f:text /q:*[System[(EventID=4757)]] > le_group_changes_removed_4757.txt
wevtutil qe security /f:text /q:*[System[(EventID=4747)]] > le_group_changes_removed_4747.txt
wevtutil qe security /f:text /q:*[System[(EventID=4752)]] > le_group_changes_removed_4752.txt
wevtutil qe security /f:text /q:*[System[(EventID=4762)]] > le_group_changes_removed_4762.txt

:: Logon Session
echo [+] Generating report for logon session (10/%reportCount%)
wevtutil qe security /f:text /q:*[System[(EventID=4624)]] > le_logon_session_4624.txt
wevtutil qe security /f:text /q:*[System[(EventID=4647)]] > le_logon_session_4647.txt
wevtutil qe security /f:text /q:*[System[(EventID=4625)]] > le_logon_session_4625.txt
wevtutil qe security /f:text /q:*[System[(EventID=4778)]] > le_logon_session_4778.txt
wevtutil qe security /f:text /q:*[System[(EventID=4779)]] > le_logon_session_4779.txt
wevtutil qe security /f:text /q:*[System[(EventID=4800)]] > le_logon_session_4800.txt
wevtutil qe security /f:text /q:*[System[(EventID=4801)]] > le_logon_session_4801.txt
wevtutil qe security /f:text /q:*[System[(EventID=4802)]] > le_logon_session_4802.txt
wevtutil qe security /f:text /q:*[System[(EventID=4803)]] > le_logon_session_4803.txt

@echo:
@echo:
echo [+] Reports are generated at %~dp0%folder%
pause
