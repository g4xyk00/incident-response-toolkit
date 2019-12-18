:: Incident Response Toolkit (IR Toolkit) Quick Windows Log Review (Powershell)
:: Author: g4xyk00
:: Tested on Windows 7

echo off
set IS_MINIMIZED=1
MODE 100,1
cls
@echo:
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set sysdate=%%c%%a%%b)
For /f "tokens=1-2 delims=: " %%a in ('time /t') do (set systime=%%a%%b)
For /f "tokens=2 delims= " %%a in ('time /t') do (set sysampm=%%a)
For /f "tokens=3 delims=: " %%a in ('echo %time%') do (set syssecond=%%a)
set scandate=%sysdate%_%sysampm%_%systime%_%syssecond%
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set /a currentmonth=%%a)
For /f "tokens=1 delims=: " %%a in ('hostname') do (set hostname=%%a)
pushd %~dp0
IF NOT EXIST review_report mkdir review_report
set report=review_report\%hostname%_%scandate%_report.txt
:: Start of reporting
powershell.exe -file "%~dp0\logreview.ps1" > %report%
move %~dp0%report% \\IEUser\d\review_report