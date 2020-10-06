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

echo [+] Generating report for User Account (1/4)
wmic /output:acc_all.html useraccount get AccountType,Caption,Description,FullName,Disabled /format:htable

echo [+] Generating report for All Services (2/4)
wmic /output:service_all.html service get DisplayName,Description,PathName,State,StartName /format:htable

echo [+] Generating report for Running Services (3/4)
wmic /output:service_run.html service where state="Running" get DisplayName,Description,PathName,StartName /format:htable

echo [+] Generating report for Software (4/4)
mic /output:software_all.html product get name,version,Installsource,InstallDate,InstallDate2,LocalPackage /format:htable

echo [+] Reports are generated at %~dp0%report%
