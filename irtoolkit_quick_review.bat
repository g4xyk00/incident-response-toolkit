:: Incident Response Toolkit (IR Toolkit) Quick Log Review v1.0
:: Author: g4xyk00
:: Tested on Windows 10

echo off
cls

echo IR Toolkit Quick Log Review
echo Created by: Gary Kong (g4xyk00)
echo Version: 1.0
echo Homepage: www.axcelsec.com
@echo:

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1-2 delims=: " %%a in ('time /t') do (set systime=%%a%%b)
For /f "tokens=2 delims= " %%a in ('time /t') do (set sysampm=%%a)
For /f "tokens=3 delims=: " %%a in ('echo %time%') do (set syssecond=%%a)
set scandate=%sysdate%_%sysampm%_%systime%_%syssecond%
set report=%scandate%_report.html
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set /a currentmonth=%%a)
pushd %~dp0
echo ^<html^> >> %report%
echo ^<head^> >> %report%
echo ^</head^> >> %report%
echo ^<body^> >> %report%
echo ^<h1^>Incident Response Toolkit (IRTookit) Quick Log Review ^</h1^> >> %report%
echo [*] Logon Session
echo     [*] No Unauthorized Login (Success)
echo ^<h3^>No Unauthorized Login (Success) ^</h3^> >> %report%
echo ^<textarea id="logon_success" style="background-color: #EBECE4;display:none;" ^> >> %report%
wevtutil qe security /f:text /q:*[System[(EventID=4624)]] > le_logon_session_4624.txt
type le_logon_session_4624.txt | findstr /C:"Date" /C:"Logon Type" >> %report%
echo ^</textarea^> >> %report%
echo ^<script^> >> %report%
echo var textArea = document.getElementById('logon_success'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo var date; >> %report% 
echo document.write('^<table border=1^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	if(lines[i].includes("Date")){ >> %report%
echo 		date = lines[i]; >> %report%
echo 	}else{ >> %report%
echo 		if(lines[i].includes("10")){ >> %report%
echo 			document.write('^<tr^>'); >> %report%
echo 			document.write('^<td^>' + date + '^</td^>'); >> %report%
echo 			document.write('^<td^>' + lines[i] + '^</td^>'); >> %report%
echo 			document.write('^</tr^>'); >> %report%
echo 		} >> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
del le_logon_session_4624.txt
echo     [*] No Unauthorized Login (Failure)
echo ^<h3^>No Unauthorized Login (Failure) ^</h3^> >> %report%
wevtutil qe security /f:text /q:*[System[(EventID=4625)]] > le_logon_session_4625.txt
echo ^<textarea id="logon_failure" style="background-color: #EBECE4;display:none;"^> >> %report%
type le_logon_session_4625.txt | findstr /C:"Date" /C:"Source Network Address" >> %report%
echo ^</textarea^> >> %report%
del le_logon_session_4625.txt 
echo [*] Schedule Tasks
echo ^<h3^>Schedule Tasks ^</h3^> >> %report%
schtasks > st_schtasks.txt
echo ^<textarea id="schedule_task" style="background-color: #EBECE4;display:none;"^> >> %report%
type st_schtasks.txt | findstr /C:"/20" >> %report%
echo ^</textarea^> >> %report%
del st_schtasks.txt
echo [*] Startup Folder
echo ^<h3^>Schedule Tasks (Startup) ^</h3^> >> %report%
echo ^<textarea id="schedule_startup" style="background-color: #EBECE4;display:none;"^> >> %report%
reg export HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run fr_reg_query_HKLM_run.reg 2>nul 1>nul 
type fr_reg_query_HKLM_run.reg | findstr /C:"=" >> %report%
reg export HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run fr_reg_query_HKCU_run.reg 2>nul 1>nul
type fr_reg_query_HKCU_run.reg | findstr /C:"=" >> %report%
reg export HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce fr_reg_query_HKLM_RunOnce.reg 2>nul 1>nul
type fr_reg_query_HKLM_RunOnce.reg | findstr /C:"=" >> %report%
reg export HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce fr_reg_query_HKCU_RunOnce.reg 2>nul 1>nul
type fr_reg_query_HKCU_RunOnce.reg | findstr /C:"=" >> %report%
echo ^</textarea^> >> %report%
echo ^<script^> >> %report%
echo var textArea = document.getElementById('schedule_startup'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo var date; >> %report%
echo document.write('^<table border=1^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split('^"='); >> %report%
echo 	var apps = strArray[0].slice(1); >> %report%
echo 	var path = strArray[1]; >> %report% 	
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 		document.write('^<tr^>'); >> %report%
echo 		document.write('^<td^>' + apps + '^</td^>'); >> %report%
echo 		document.write('^<td^>' + path + '^</td^>'); >> %report%
echo 		document.write('^</tr^>'); >> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
del fr_reg_query_HKLM_run.reg
del fr_reg_query_HKCU_run.reg
del fr_reg_query_HKLM_RunOnce.reg
del fr_reg_query_HKCU_RunOnce.reg
echo [*] User Account Changes
echo ^<h3^>User Account Changes ^</h3^> >> %report%
echo ^<textarea id="user_account" style="background-color: #EBECE4;display:none;"^> >> %report%
net user >> %report%
echo ^</textarea^> >> %report%

echo ^<script^> >> %report%
echo var textArea = document.getElementById('user_account'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=1^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { 	>> %report%
echo 	if(lines[i].length ^> 0){>> %report%
echo 		if(lines[i].includes('User accounts for') ^|^| lines[i].includes('The command completed') ^|^| lines[i].includes('-----------------')){>> %report%
echo 		}else{ >> %report%
echo 			document.write('^<tr^>'); >> %report%
echo 			document.write('^<td^>' + lines[i] + '^</td^>'); >> %report%
echo 			document.write('^</tr^>');>> %report%
echo 		}>> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
echo [*] Processes and Services
:: Processes and Services (EXE)
echo ^<h3^>Processes and Services (EXE) ^</h3^> >> %report%
"02 Endpoint_LastActivityView\lastactivityview\LastActivityView.exe" /scomma lastactivityview.txt
echo ^<textarea id="processes_exe" style="background-color: #EBECE4;display:none;"^> >> %report%
type lastactivityview.txt | findstr /C:"Run .EXE file" >> %report%
echo ^</textarea^> >> %report%

echo ^<script^> >> %report%
echo var textArea = document.getElementById('processes_exe'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=1 style="table-layout:fixed"^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split(','); >> %report%
echo 	var datetime = strArray[0]; >> %report%
echo 	var dateTimeArray = datetime.split(' ');>> %report%
echo 	var date = dateTimeArray[0]; >> %report%
echo 	var time = dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 			document.write('^<tr^>'); >> %report% 
echo 			document.write('^<td^>' + date + '^</td^>');  >> %report%
echo 			document.write('^<td^>' + time + '^</td^>');  >> %report%
echo 			document.write('^<td style="overflow: hidden; max-width: 200px; word-wrap: break-word;"^>' + strArray[2] + '^</td^>');  >> %report%
echo 			document.write('^<td style="overflow: hidden; max-width: 600px; word-wrap: break-word;"^>' + strArray[3] + '^</td^>');  >> %report%
echo 			document.write('^</tr^>'); >> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
:: Processes and Services (USB)
echo ^<h3^>Processes and Services (USB) ^</h3^> >> %report%
"04_Endpoint_USBDeview\usbdeview\USBDeview.exe" /scomma usbdeview.txt /sort "Last Plug/Unplug Date"
echo ^<textarea id="processes_usb" style="background-color: #EBECE4;display:none;"^> >> %report%
type usbdeview.txt | findstr /C:"Mass Storage" >> %report%
echo ^</textarea^> >> %report%
del usbdeview.txt >> %report%
echo ^<script^> >> %report% 
echo var textArea = document.getElementById('processes_usb'); >> %report% 
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=1 style="table-layout:fixed"^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split(','); >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){>> %report%
echo 		var datetime = strArray[1];>> %report%
echo 		var dateTimeArray = datetime.split(' ');>> %report%
echo 		var date = dateTimeArray[0];>> %report%
echo 		var time = dateTimeArray[1] + ' ' + dateTimeArray[2];;>> %report%
echo 		document.write('^<tr^>'); >> %report%
echo 		document.write('^<td^>' + date + '^</td^>'); >> %report%
echo 		document.write('^<td^>' + time + '^</td^>'); >> %report%
echo 		document.write('^<td style="overflow: hidden; max-width: 600px; word-wrap: break-word;"^>' + strArray[3] + '^</td^>'); >> %report%
echo 		document.write('^</tr^>');>> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
echo [*] File and Registry Key
:: File and Registry Key
echo ^<h3^>File and Registry Key ^</h3^> >> %report%
echo ^<textarea id="file_folder" style="background-color: #EBECE4;display:none;"^> >> %report%
type lastactivityview.txt | findstr /C:"View Folder in Explorer" /C:"Open file or folder" >> %report%
echo ^</textarea^> >> %report%
echo ^<script^> >> %report%
echo var textArea = document.getElementById('file_folder'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=1 style="table-layout:fixed"^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split(','); >> %report%
echo 	var datetime = strArray[0];>> %report%
echo 	var dateTimeArray = datetime.split(' ');>> %report%
echo 	var date = dateTimeArray[0]; >> %report%
echo 	var time = dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report% 	
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 			document.write('^<tr^>');  >> %report%
echo 			document.write('^<td^>' + date + '^</td^>'); >> %report%
echo 			document.write('^<td^>' + time + '^</td^>'); >> %report%
echo 			document.write('^<td style="overflow: hidden; max-width: 600px; word-wrap: break-word;"^>' + strArray[3] + '^</td^>'); >> %report%
echo 			document.write('^</tr^>');>> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
del lastactivityview.txt
echo ^</body^> >> %report%
echo ^</html^> >> %report%
@echo:
@echo:
echo [+] Reports are generated at %~dp0%report%
pause
