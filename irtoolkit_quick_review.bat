:: Incident Response Toolkit (IR Toolkit) Quick Log Review v1.1
:: Author: g4xyk00
:: Tested on Windows 10, Internet Explorer

echo off
cls

echo IR Toolkit Quick Log Review Reporting System
echo Created by: Gary Kong (g4xyk00)
echo Version: 1.1
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
:: Start of HTML
echo ^<html^> >> %report%
echo ^<head^> >> %report%
echo ^<style^>  >> %report%
echo body {  >> %report%
echo 	font-family: Arial, Helvetica, sans-serif;  >> %report%
echo }  >> %report%
echo h3 { >> %report%
echo 	background-color: black; >> %report%
echo 	color: white; >> %report%
echo 	padding: 6px; >> %report%
echo } >> %report%
echo .result tr:nth-child(even) { >> %report%
echo   background-color: #dddddd; >> %report%
echo } >> %report%
echo ^</style^> >> %report%
echo ^</head^> >> %report%
echo ^<body^> >> %report%
echo ^<h1^>IR Toolkit Quick Log Review Reporting System^</h1^>  >> %report%
echo ^<script^>  >> %report%
echo var fileHTML = window.location.pathname;  >> %report%
echo var fileName = fileHTML.substring(fileHTML.lastIndexOf('/')+1);  >> %report%
echo var rDatetime = fileName.split('_');  >> %report%
echo var rDate = rDatetime[0];  >> %report%
echo var rYear = rDate.substring(0,4);  >> %report%
echo var rMonth = rDate.substring(4,6);  >> %report%
echo var rDay = rDate.substring(6);  >> %report%
echo var rHour = rDatetime[2].substring(0,2);   >> %report%
echo var rMinutes = rDatetime[2].substring(2);   >> %report%
echo document.write('Report generated at '+rDay+'-'+rMonth+'-'+rYear+', '+rHour+':'+rMinutes+' '+rDatetime[1]);   >> %report%
echo var sDateYear = rYear;  >> %report%
echo var sDateMonth = rMonth;  >> %report%
echo var sDateDay = rMonth;  >> %report%
echo var eDateYear = rYear;  >> %report%
echo var eDateMonth = rDay;  >> %report%
echo var eDateDay = rDay; >> %report%
echo function getStartDate(){ >> %report%
echo 	var pos = document.URL.indexOf("sdate=")+6; >> %report%
echo 	return document.URL.substring(pos,pos+8); >> %report%
echo } >> %report%
echo function getStartYear(){ >> %report%
echo 	return getStartDate().substring(0,4); >> %report%
echo } >> %report%
echo function getStartMonth(){ >> %report%
echo 	return getStartDate().substring(4,6); >> %report%
echo } >> %report%
echo function getStartDay(){ >> %report%
echo 	return getStartDate().substring(6); >> %report%
echo } >> %report%
echo function getEndDate(){ >> %report%
echo 	var pos = document.URL.indexOf("edate=")+6; >> %report%
echo 	return document.URL.substring(pos,document.URL.length); >> %report%
echo } >> %report%
echo function getEndYear(){ >> %report%
echo 	return getEndDate().substring(0,4); >> %report%
echo } >> %report%
echo function getEndMonth(){ >> %report%
echo 	return getEndDate().substring(4,6); >> %report%
echo } >> %report%
echo function getEndDay(){ >> %report%
echo 	return getEndDate().substring(6); >> %report%
echo } >> %report%
echo ^</script^>  >> %report%
echo ^<h2^>Filter Result^</h2^>  >> %report%
echo ^<div style='background-color: #a4eb34;border-radius: 15px;padding: 10px;'^>  >> %report%
echo ^<table^>  >> %report%
echo ^<tr^>  >> %report%
echo ^<td width='2%%'^>^</td^>  >> %report%
echo ^<td^>^<b^>Start Date^</b^>^</td^>   >> %report%
echo ^<td^>^<input type="text" id="sdate" name="sdate" maxlength="8" placeholder="e.g. 20190723"^>^</td^>  >> %report%
echo ^<td width='5%%'^>^</td^>  >> %report%
echo ^<td^>^<b^>End Date^</b^>^</td^>  >> %report%
echo ^<td^>^<input type="text" id="edate" name="edate" maxlength="8" placeholder="e.g. 20190723"^>^</td^>  >> %report%
echo ^<td width='5%%'^>^</td^>  >> %report%
echo ^<td^>^<input type="submit" value="Filter" onclick="return filter()"^>^</td^>  >> %report%
echo ^</tr^>  >> %report%
echo ^<tr^>  >> %report%
echo ^<td width='2%%'^>^</td^>  >> %report%
echo ^<td colspan="7"^>  >> %report%
echo ^<script^>  >> %report%
echo function filter(){  >> %report%
echo 	var inputStartDate = document.getElementById("sdate").value;    >> %report%
echo 	var inputEndDate = document.getElementById("edate").value;  >> %report%
echo 	sDateYear = parseInt(inputStartDate.substring(0,4));  >> %report%
echo 	eDateYear = parseInt(inputEndDate.substring(0,4));  >> %report%
echo 	sDateMonth = parseInt(inputStartDate.substring(4,6));  >> %report%
echo 	eDateMonth = parseInt(inputEndDate.substring(4,6));  >> %report%
echo 	sDateDay = parseInt(inputStartDate.substring(6));  >> %report%
echo 	eDateDay = parseInt(inputEndDate.substring(6));  >> %report%
echo 	var validSMonth = false;   >> %report%
echo 	var validEMonth = false;  >> %report%
echo 	var validSDay = false;  >> %report%
echo 	var validEDay = false;  >> %report%
echo 	var validDate = false;  >> %report%
echo 	if(sDateMonth ^< 13 ){  >> %report%
echo 		validSMonth = true;  >> %report%
echo 	}  >> %report%
echo 	if(eDateMonth ^< 13 ){  >> %report%
echo 		validEMonth = true;  >> %report%
echo 	}  >> %report%
echo 	if(sDateDay ^< 32 ){  >> %report%
echo 		validSDay = true;  >> %report%
echo 		if((sDateMonth == 2 ^|^| sDateMonth == 4 ^|^| sDateMonth == 6 ^|^| sDateMonth == 9 ^|^| sDateMonth == 12) ^&^& sDateDay ^> 30){  >> %report%
echo 			validSDay = false;  >> %report%
echo 		}  >> %report%
echo 		if(sDateYear %% 4 ^> 0 ^&^& eDateMonth == 2 ^&^& sDateDay ^> 28){  >> %report%
echo 			validSDay = false;  >> %report%
echo 		}  >> %report%
echo 	}  >> %report%
echo 	if(eDateDay ^< 32 ){  >> %report%
echo 		validEDay = true;  >> %report%
echo 		if((eDateMonth == 2 ^|^| eDateMonth == 4 ^|^| eDateMonth == 6 ^|^| eDateMonth == 9 ^|^| eDateMonth == 12) ^&^& eDateDay ^> 30){  >> %report%
echo 			validEDay = false;  >> %report%
echo 		}  >> %report%
echo 		if(eDateYear %% 4 ^> 0 ^&^& eDateMonth == 2 ^&^& eDateDay ^> 28){  >> %report%
echo 			validEDay = false;  >> %report%
echo 		}  >> %report%
echo 	}  >> %report%
echo 	if(parseInt(inputEndDate) ^>= parseInt(inputStartDate)){  >> %report%
echo 		validDate = true;  >> %report%
echo 	}  >> %report%
echo 	if(parseInt(inputEndDate) ^> parseInt(rDatetime)){  >> %report%
echo 		validDate = false;  >> %report%
echo 	}  >> %report%
echo 	if(inputStartDate.length ^> 7 ^&^& inputEndDate.length ^> 7 ^&^& validSMonth ^&^& validEMonth ^&^& validSDay ^&^& validEDay ^&^& validDate){  >> %report%
echo 		document.getElementById("filterMsg").innerHTML = '^<br/^>^<small^>Filter log results between ^<b^>'+sDateDay+'-'+sDateMonth+'-'+sDateYear+'^</b^> and ^<b^>'+eDateDay+'-'+eDateMonth+'-'+eDateYear+'^</b^>.^</small^>';  >> %report%
echo 		parent.location.search = 'sdate='+inputStartDate+'^&edate='+inputEndDate; >> %report%
echo 	}else{  >> %report%
echo 		document.getElementById("filterMsg").innerHTML = '^<br/^>^<b^>^<small style="color: red;"^>Incorrect Date entered.^</small^>^</b^>';  >> %report%
echo 	}  >> %report%
echo }  >> %report%
echo if(isNaN(getStartDate())){ >> %report%
echo 	document.getElementById("sdate").value = ''; >> %report%
echo }else{ >> %report%
echo 	document.getElementById("sdate").value = getStartDate(); >> %report%
echo } >> %report%
echo if(isNaN(getEndDate())){ >> %report%
echo 	document.getElementById("edate").value = ''; >> %report%
echo }else{ >> %report%
echo 	document.getElementById("edate").value = getEndDate(); >> %report%
echo } >> %report%
echo ^</script^>  >> %report%
echo ^<div id="filterMsg"^>^</div^>  >> %report%
echo ^</td^>  >> %report%
echo ^</tr^>  >> %report%
echo ^</table^>  >> %report%
echo ^</div^>  >> %report%
echo [*] Logon Session
echo     [*] No Unauthorized Login (Success)
echo ^<h3^>No Unauthorized Login (Success) ^</h3^> >> %report%
echo ^<textarea id="logon_success" style="background-color: #EBECE4;display:none;" ^> >> %report%
wevtutil qe security /f:text /q:*[System[(EventID=4624)]] > le_logon_session_4624.txt
type le_logon_session_4624.txt | findstr /C:"Date" /C:"Logon Type" /C:"Source Network Address" >> %report%
echo ^</textarea^> >> %report%
:: Javascript for Unauthorized Login (Success)
echo ^<div class="result"^> >> %report%
echo ^<script^>   >> %report%
echo var textArea = document.getElementById('logon_success');   >> %report%
echo var lines  = textArea.value.split("\n");   >> %report%
echo var datetime;  >> %report%
echo var date;  >> %report%
echo var time;  >> %report%
echo var remoteDesktop = false; >> %report%
echo document.write('^<table border=0^>'); >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Date^</th^>'); >> %report%
echo document.write('^<th^>Time^</th^>'); >> %report%
echo document.write('^<th^>Source Network Address^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) {   >> %report%
echo 	if(lines[i].indexOf("Date") ^>=0 ){   >> %report%
echo 		datetime = lines[i].split('T');   >> %report%
echo 		date = datetime[0].split(':')[1];  >> %report%
echo 		dateArray = date.split('-');  >> %report%
echo 		dateFormatted = parseInt(dateArray[0]+dateArray[1]+dateArray[2])  >> %report%
echo 		time = datetime[1].split(':');  >> %report%
echo 		time = time[0]+':'+time[1];  >> %report%
echo 	}else{   >> %report%
echo 		if(lines[i].indexOf("10") ^>= 0){ >> %report%
echo 			remoteDesktop=true; >> %report%
echo 		} >> %report%
echo 		if(lines[i].indexOf("Source Network Address") ^>= 0 ^&^& remoteDesktop){ >> %report%
echo 			if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){  >> %report%
echo 				document.write('^<tr^>');   >> %report%
echo 				document.write('^<td width="120"^>' + date + '^</td^>');   >> %report%
echo 				document.write('^<td width="120"^>' + time + '^</td^>');   >> %report%
echo 				document.write('^<td^>' + lines[i].split(':')[1] + '^</td^>');   >> %report%
echo 				document.write('^</tr^>');   >> %report%
echo 			}  >> %report%
echo 			remoteDesktop = false; >> %report%
echo 		} >> %report%
echo 	}   >> %report%
echo }   >> %report%
echo document.write('^</table^>')   >> %report%
echo ^</script^>  >> %report%
del le_logon_session_4624.txt
echo     [*] No Unauthorized Login (Failure)
echo ^<h3^>No Unauthorized Login (Failure) ^</h3^> >> %report%
wevtutil qe security /f:text /q:*[System[(EventID=4625)]] > le_logon_session_4625.txt
echo ^<textarea id="logon_failure" style="background-color: #EBECE4;display:none;"^> >> %report%
type le_logon_session_4625.txt | findstr /C:"Date" /C:"Source Network Address" >> %report%
echo ^</textarea^> >> %report%
:: Javascript for Login Failure 
echo ^<script^>   >> %report%
echo var textArea = document.getElementById('logon_failure');   >> %report%
echo var lines  = textArea.value.split("\n");   >> %report%
echo var datetime;  >> %report%
echo var date;  >> %report%
echo var time;  >> %report%
echo document.write('^<table border=0^>'); >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Date^</th^>'); >> %report%
echo document.write('^<th^>Time^</th^>'); >> %report%
echo document.write('^<th^>Source Network Address^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) {   >> %report%
echo 	if(lines[i].indexOf("Date") ^>= 0 ){   >> %report%
echo 		datetime = lines[i].split('T');   >> %report%
echo 		date = datetime[0].split(':')[1];  >> %report%
echo 		dateArray = date.split('-');  >> %report%
echo 		dateFormatted = parseInt(dateArray[0]+dateArray[1]+dateArray[2])  >> %report%
echo 		time = datetime[1].split(':');  >> %report%
echo 		time = time[0]+':'+time[1];  >> %report%
echo 	}else{   >> %report%
echo 		if(lines[i].indexOf("Source Network Address") ^>= 0){ >> %report%
echo 			if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){  >> %report%
echo 				document.write('^<tr^>');   >> %report%
echo 				document.write('^<td width="120"^>' + date + '^</td^>');   >> %report%
echo 				document.write('^<td width="120"^>' + time + '^</td^>');   >> %report%
echo 				document.write('^<td^>' + lines[i].split(':')[1] + '^</td^>');   >> %report%
echo 				document.write('^</tr^>');   >> %report%
echo 			}  >> %report%
echo 			remoteDesktop = false; >> %report%
echo 		} >> %report%
echo 	}   >> %report%
echo }   >> %report%
echo document.write('^</table^>')   >> %report%
echo ^</script^>  >> %report%
del le_logon_session_4625.txt 
echo [*] Schedule Tasks
echo ^<h3^>Schedule Tasks ^</h3^> >> %report%
schtasks > st_schtasks.txt
echo ^<textarea id="schedule_task" style="background-color: #EBECE4;display:none;"^> >> %report%
type st_schtasks.txt | findstr /C:"/20" >> %report%
echo ^</textarea^> >> %report%
del st_schtasks.txt
:: Javascript for Schedule Tasks
echo ^<script^> >> %report%
echo var textArea = document.getElementById('schedule_task'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo var date; >> %report%
echo document.write('^<table border=0^>');>> %report%
echo document.write('^<tr^>');>> %report%
echo document.write('^<th^>TaskName^</th^>');>> %report%
echo document.write('^<th^>Next Run Time ^& Status^</th^>');>> %report%
echo document.write('^</tr^>');>> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split('/'); >> %report%
echo 	var task = strArray[0].substring(0,strArray[0].length-1);>> %report%
echo 	var detail = strArray[0].substring(strArray[0].length-1)+'/'+strArray[1]+'/'+strArray[2];>> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 		document.write('^<tr^>'); >> %report%
echo 		document.write('^<td^>^<b^>' + task + '^</b^>^</td^>'); >> %report%
echo 		document.write('^<td style="color: grey;"^>' + detail + '^</td^>'); >> %report%
echo 		document.write('^</tr^>'); >> %report%
echo 	} >> %report%
echo } >> %report%
echo document.write('^</table^>') >> %report%
echo ^</script^> >> %report%
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
:: Javascript for Schedule Task (Startup)
echo ^<script^> >> %report%
echo var textArea = document.getElementById('schedule_startup'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo var date; >> %report%
echo document.write('^<table border=0^>') >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Name^</th^>'); >> %report%
echo document.write('^<th^>Data^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split('^"='); >> %report%
echo 	var apps = strArray[0].slice(1); >> %report%
echo 	var path = strArray[1]; >> %report% 	
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 		document.write('^<tr^>'); >> %report%
echo 		document.write('^<td^>^<b^>' + apps + '^</b^>^</td^>'); >> %report%
echo 		document.write('^<td style="color: grey;"^>' + path + '^</td^>'); >> %report%
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
:: Javascript for User Account Changes
echo ^<script^> >> %report%
echo var textArea = document.getElementById('user_account'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=0^>') >> %report%
echo for (var i = 0; i ^< lines.length; i++) { 	>> %report%
echo 	if(lines[i].length ^> 0){>> %report%
echo 		if(lines[i].indexOf('User accounts for') ^>= 0 ^|^| lines[i].indexOf('The command completed') ^>= 0 ^|^| lines[i].indexOf('-----------------') ^>= 0 ){>> %report%
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
:: Javascript for Process and Services (EXE)
echo ^<script^> >> %report%
echo var textArea = document.getElementById('processes_exe'); >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=0 style="table-layout:fixed"^>') >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Action Date^</th^>'); >> %report%
echo document.write('^<th^>Action Time^</th^>'); >> %report%
echo document.write('^<th^>Filename^</th^>'); >> %report%
echo document.write('^<th^>Full Path^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split(','); >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 	var datetime = strArray[0]; >> %report%
echo 	var dateTimeArray = datetime.split(' ');>> %report%
echo 	var date = dateTimeArray[0]; >> %report%
echo 		if(dateTimeArray[1].split(':')[0].length ^< 2){ >> %report%
echo 			var time = '0'+dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 		}else{ >> %report%
echo 			var time = dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 		} >> %report%
echo 		var dateArray = date.split('/');>> %report%
echo 		if(dateArray != ''){>> %report%
echo 			var dateArrayYear = dateArray[2];>> %report%
echo 			var dateArrayMonth = dateArray[0];>> %report%
echo 			var dateArrayDay = dateArray[1];>> %report%
echo 			if(dateArrayDay.length ^< 2){>> %report%
echo 				dateArrayDay = '0'+dateArrayDay;>> %report%
echo 			}>> %report%
echo 			if(dateArrayMonth.length ^< 2){>> %report%
echo 				dateArrayMonth = '0'+dateArrayMonth;>> %report%
echo 			}>> %report%
echo 			var dateFormatted = parseInt(dateArrayYear+dateArrayMonth+dateArrayDay);>> %report%
echo 		}>> %report%
echo 		if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){>> %report%
echo 			document.write('^<tr^>');  >> %report%
echo 			document.write('^<td width="120"^>' + dateArrayYear+'-'+dateArrayMonth+'-'+dateArrayDay+'^</td^>');  >> %report%
echo 			document.write('^<td width="120" align="center"^>' + time + '^</td^>');  >> %report%
echo 			document.write('^<td width="400" style="overflow: hidden; word-wrap: break-word;max-width: 400"^>' + strArray[2] + '^</td^>');  >> %report%
echo 			document.write('^<td style="overflow: hidden; word-wrap: break-word;color: grey;"^>^<small^>' + strArray[3] + '^</small^>^</td^>');  >> %report%
echo 			document.write('^</tr^>'); >> %report%
echo 		}>> %report%
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
:: Javascript for Process and Services (USB)
echo ^<script^>  >> %report%
echo var textArea = document.getElementById('processes_usb');  >> %report%
echo var lines  = textArea.value.split("\n"); >> %report%
echo document.write('^<table border=0^>') >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Last Plug/Unplug Date^</th^>'); >> %report%
echo document.write('^<th^>Last Plug/Unplug Time^</th^>'); >> %report%
echo document.write('^<th^>Description^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) { >> %report%
echo 	var strArray = lines[i].split(','); >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){>> %report%
echo 		var datetime = strArray[1];>> %report%
echo 		var dateTimeArray = datetime.split(' ');>> %report%
echo 		var date = dateTimeArray[0];>> %report%
echo 		var dateArray = date.split('/');>> %report%
echo 		if(dateArray != ''){>> %report%
echo 			var dateArrayYear = dateArray[2];>> %report%
echo 			var dateArrayMonth = dateArray[0];>> %report%
echo 			var dateArrayDay = dateArray[1];>> %report%
echo 			if(dateArrayDay.length ^< 2){>> %report%
echo 				dateArrayDay = '0'+dateArrayDay;>> %report%
echo 			}>> %report%
echo 			if(dateArrayMonth.length ^< 2){>> %report%
echo 				dateArrayMonth = '0'+dateArrayMonth;>> %report%
echo 			}>> %report%
echo 			var dateFormatted = parseInt(dateArrayYear+dateArrayMonth+dateArrayDay);>> %report%
echo 		}>> %report%
echo 	if(dateTimeArray[1].split(':')[0].length ^< 2){ >> %report%
echo 		var time = '0'+dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 	}else{ >> %report%
echo 		var time = dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 	} >> %report%
echo 		if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){>> %report%
echo 			document.write('^<tr^>'); >> %report%
echo 			document.write('^<td width="120"^>' + dateArrayYear+'-'+dateArrayMonth+'-'+dateArrayDay+ '^</td^>'); >> %report%
echo 			document.write('^<td width="120"^>' + time + '^</td^>'); >> %report%
echo 			document.write('^<td style="overflow: hidden; word-wrap: break-word;"^>' + strArray[3] + '^</td^>'); >> %report%
echo 			document.write('^</tr^>');>> %report%
echo 		}>> %report%
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
:: Javascript for File and Registry Key
echo ^<script^>  >> %report%
echo var textArea = document.getElementById('file_folder');  >> %report%
echo var lines  = textArea.value.split("\n");  >> %report%
echo document.write('^<table border=0 style="table-layout:fixed"^>')  >> %report%
echo document.write('^<tr^>'); >> %report%
echo document.write('^<th^>Action Date^</th^>'); >> %report%
echo document.write('^<th^>Action Time^</th^>'); >> %report%
echo document.write('^<th^>Full Path^</th^>'); >> %report%
echo document.write('^</tr^>'); >> %report%
echo for (var i = 0; i ^< lines.length; i++) {  >> %report%
echo 	var strArray = lines[i].split(',');  >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){  >> %report%
echo 	var datetime = strArray[0]; >> %report%
echo 	var dateTimeArray = datetime.split(' '); >> %report%
echo 	var date = dateTimeArray[0];  >> %report%
echo 	var dateArray = date.split('/'); >> %report%
echo 		if(dateArray != ''){ >> %report%
echo 			var dateArrayYear = dateArray[2]; >> %report%
echo 			var dateArrayMonth = dateArray[0]; >> %report%
echo 			var dateArrayDay = dateArray[1]; >> %report%
echo 			if(dateArrayDay.length ^< 2){ >> %report%
echo 				dateArrayDay = '0'+dateArrayDay; >> %report%
echo 			} >> %report%
echo 			if(dateArrayMonth.length ^< 2){ >> %report%
echo 				dateArrayMonth = '0'+dateArrayMonth; >> %report%
echo 			} >> %report%
echo 			var dateFormatted = parseInt(dateArrayYear+dateArrayMonth+dateArrayDay); >> %report%
echo 		} >> %report%
echo 		if(dateTimeArray[1].split(':')[0].length ^< 2){ >> %report%
echo 			var time = '0'+dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 		}else{ >> %report%
echo 			var time = dateTimeArray[1] + ' ' + dateTimeArray[2]; >> %report%
echo 		} >> %report%
echo 		if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){ >> %report%
echo 			document.write('^<tr^>');   >> %report%
echo 			document.write('^<td width="120"^>' + dateArrayYear+'-'+dateArrayMonth+'-'+dateArrayDay+'^</td^>');  >> %report%
echo 			document.write('^<td width="120" align="center"^>' + time + '^</td^>');  >> %report%
echo 			document.write('^<td style="overflow: hidden; word-wrap: break-word;"^>' + strArray[3] + '^</td^>');  >> %report%
echo 			document.write('^</tr^>'); >> %report%
echo 		} >> %report%
echo 	}  >> %report%
echo }  >> %report%
echo document.write('^</table^>')  >> %report%
echo ^</script^>  >> %report%
del lastactivityview.txt
echo ^</div^> >> %report%
:: Network Usage
echo ^<h3^>Network Usage ^</h3^> >> %report%
echo ^<textarea id="network_usage" style="background-color: #EBECE4;display:none;"^> >> %report%
type "07_Network_CurrPorts\cports\cports.log" | findstr /C:"Added" >> %report%
echo ^</textarea^> >> %report%
echo ^<script^> >> %report%
echo var textArea = document.getElementById('network_usage');   >> %report%
echo var lines  = textArea.value.split("\n");  >> %report%
echo document.write('^<table border=0 ^>')  >> %report%
echo document.write('^<tr^>');  >> %report%
echo document.write('^<th^>Added Date^</th^>');  >> %report%
echo document.write('^<th^>Added Time^</th^>');  >> %report%
echo document.write('^<th^>Remote Address^</th^>');  >> %report%
echo document.write('^<th^>Process Path^</th^>');  >> %report%
echo document.write('^</tr^>');  >> %report%
echo var remoteAddrArray = []; >> %report%
echo for (var i = 0; i ^< lines.length; i++) {  >> %report%
echo 	var strArray = lines[i].split(';');  >> %report%
echo 	if(lines[i].length ^> 0 ^&^& strArray[1] !== undefined){ >> %report%
echo 		var datetime = strArray[0]; >> %report%
echo 		var dateTimeArray = datetime.split('Added'); >> %report%
echo 		var date = dateTimeArray[0].split(' ')[0]; >> %report%
echo 		var dateArray = date.split('/'); >> %report%
echo 		if(dateArray != ''){ >> %report%
echo 			var dateArrayYear = dateArray[2]; >> %report%
echo 			var dateArrayMonth = dateArray[0]; >> %report%
echo 			var dateArrayDay = dateArray[1]; >> %report%
echo 			if(dateArrayDay.length ^< 2){ >> %report%
echo 				dateArrayDay = '0'+dateArrayDay; >> %report%
echo 			} >> %report%
echo 			if(dateArrayMonth.length ^< 2){ >> %report%
echo 				dateArrayMonth = '0'+dateArrayMonth; >> %report%
echo 			} >> %report%
echo 			var dateFormatted = parseInt(dateArrayYear+dateArrayMonth+dateArrayDay); >> %report%
echo 		} >> %report%
echo 		var time = dateTimeArray[0].split(' ')[1] + ' '+ dateTimeArray[0].split(' ')[2]; >> %report%
echo 		if(time.split(':')[0].length ^< 2){  >> %report%
echo 			time = '0'+time;  >> %report%
echo 		} >> %report%
echo 		var remoteAddr = strArray[4]; >> %report%
echo 		if(remoteAddrArray.indexOf(remoteAddr) ^< 0 ^&^& remoteAddr.trim().length ^> 0){ >> %report%
echo 			remoteAddrArray.push(remoteAddr); >> %report%
echo 		} >> %report%
echo 		var processPath = strArray[6]; >> %report%
echo 		if(dateFormatted ^>= getStartDate() ^&^& dateFormatted ^<= getEndDate()){ >> %report%
echo 			document.write('^<tr^>');  >> %report%
echo 			document.write('^<td width="120"^>' + dateArrayYear+'-'+dateArrayMonth+'-'+dateArrayDay+ '^</td^>');  >> %report%
echo 			document.write('^<td width="120" align="center"^>' + time + '^</td^>');  >> %report%
echo 			document.write('^<td width="120"^>' + remoteAddr + '^</td^>');  >> %report%
echo 			document.write('^<td style="overflow: hidden; word-wrap: break-word;"^>' + processPath + '^</td^>');  >> %report%
echo 			document.write('^</tr^>'); >> %report%
echo 		} >> %report%
echo 	}  >> %report%
echo }  >> %report%
echo document.write('^<div style="background-color: #dedede;border-radius: 15px;padding: 10px;"^>'); >> %report%
echo document.write('^<b^>Remote Addresses:^</b^>^<br/^>'); >> %report%
echo document.write('^<ul^>'); >> %report%
echo for (var i = 0; i ^< remoteAddrArray.length; i++) {  >> %report%
echo 	document.write('^<li^>'+remoteAddrArray[i]+'^</li^>'); >> %report%
echo } >> %report%
echo document.write('^</ul^>'); >> %report%
echo document.write('^</div^>'); >> %report%
echo document.write('^<hr/^>'); >> %report%
echo ^</script^>   >> %report%
echo ^</body^> >> %report%
echo ^</html^> >> %report%
@echo:
@echo:
echo [+] Reports are generated at %~dp0%report%
pause