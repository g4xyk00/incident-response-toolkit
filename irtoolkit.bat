:: Incident Response Toolkit (IR Toolkit) v1.0
:: Author: g4xyk00
:: Tested on Windows 10

echo off
cls
cd %~dp0

echo Incident Response Toolkit (IR Toolkit) v1.0
@echo:

:: To Create Folder
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1-2 delims=: " %%a in ('time /t') do (set systime=%%a%%b)
For /f "tokens=2 delims= " %%a in ('time /t') do (set sysampm=%%a)
set folder=%sysdate%_%sysampm%_%systime%
mkdir %folder%
cd %folder%

:: [PS] Processes and Services 
echo [+] Generating report for processes and services
tasklist > ps_tasklist.txt
wmic process list full > ps_wmic_process_list_full.txt 
net start > ps_net_start.txt
sc query > ps_sc_query.txt

:: [FR] Files and Registry Keys
echo [+] Generating report for files and registry keys
dir c:\ > fr_dir_c.txt
dir %SystemRoot%\system32 > fr_dir_systemroot.txt
reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run > fr_reg_query_HKLM_run.txt
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run > fr_reg_query_HKCU_run.txt
reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce > fr_reg_query_HKLM_RunOnce.txt
reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce > fr_reg_query_HKCU_RunOnce.txt


:: [NU] Network Usage 
echo [+] Generating report for network usage
net view \\127.0.0.1 > nu_net_view.txt
net session > nu_net_session.txt
net use > nu_net_use.txt
nbtstat -S > nu_nbtstat.txt
netstat -ano > nu_netstat_ano.txt
netsh firewall show config > nu_netsh_firewall.txt

:: [ST] Scheduled Tasks
echo [+] Generating report for scheduled tasks
schtasks > st_schtasks.txt
wmic startup list full > st_wmic_startup_list_full.txt

:: [AC] Accounts
echo [+] Generating report for accounts
net user > ac_net_user.txt
net localgroup administrators > ac_localgroup.txt


:: [LE] Log Entries
:: User Account Changes
echo [+] Generating report for user account changes
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
echo [+] Generating report for domain controller authentication
wevtutil qe security /f:text /q:*[System[(EventID=4768)]] > le_domain_controller_4768.txt
wevtutil qe security /f:text /q:*[System[(EventID=4771)]] > le_domain_controller_4771.txt
wevtutil qe security /f:text /q:*[System[(EventID=4772)]] > le_domain_controller_4772.txt

:: Group changes
:: Created
echo [+] Generating report for group changes
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
echo [+] Generating report for logon session
wevtutil qe security /f:text /q:*[System[(EventID=4624)]] > le_logon_session_4624.txt
wevtutil qe security /f:text /q:*[System[(EventID=4647)]] > le_logon_session_4647.txt
wevtutil qe security /f:text /q:*[System[(EventID=4625)]] > le_logon_session_4625.txt
wevtutil qe security /f:text /q:*[System[(EventID=4778)]] > le_logon_session_4778.txt
wevtutil qe security /f:text /q:*[System[(EventID=4779)]] > le_logon_session_4779.txt
wevtutil qe security /f:text /q:*[System[(EventID=4800)]] > le_logon_session_4800.txt
wevtutil qe security /f:text /q:*[System[(EventID=4801)]] > le_logon_session_4801.txt
wevtutil qe security /f:text /q:*[System[(EventID=4802)]] > le_logon_session_4802.txt
wevtutil qe security /f:text /q:*[System[(EventID=4803)]] > le_logon_session_4803.txt

echo [+] Reports are generated 