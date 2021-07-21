:: Inventory of Windows information for System Hardening

echo off
cls
pushd %~dp0

echo Inventory of Windows information for System Hardening

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1 delims=\" %%a in ('hostname') do (set hostName=%%a)
set folder=%sysdate%_%hostName%
mkdir %folder%
cd %folder%

copy C:\Windows\System32\wbem\en-US\htable.xsl C:\Windows\system32\wbem /Y

echo [+] Generating report for User Account (1/5)
wmic /output:acc_all.html useraccount get AccountType,Caption,Description,FullName,Disabled /format:htable

echo [+] Generating report for All Services (2/5)
wmic /output:service_all.html service get DisplayName,Description,PathName,State,StartName /format:htable

echo [+] Generating report for Running Services (3/5)
wmic /output:service_run.html service where state="Running" get DisplayName,Description,PathName,StartName /format:htable

echo [+] Generating report for Software (4/5)
wmic /output:software_all.html product get name,version,Installsource,InstallDate,InstallDate2,LocalPackage /format:htable

echo [+] Generating report for System (5/5)
systeminfo > system.txt

del C:\Windows\system32\wbem\htable.xsl

echo [+] Reports are generated at %~dp0%report%
pause
