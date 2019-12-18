# Incident Response Toolkit (IR Toolkit) Quick Windows Log Review (Powershell)
# Author: g4xyk00
# Tested on Windows 7

cls

#*************************************
# System Information
#*************************************
$ErrorActionPreference = 'SilentlyContinue'
$hostname = hostname
$date = Get-Date
$week = $(Get-Date).AddDays(-1) #-1 equal to 1 day


#*************************************
# Whitelist
#*************************************

if($hostname -eq "IEUser"){ 
	$trusted_host = "IEUser2"
	$trusted_usr = "Administrator","Guest"
	$trusted_schtasks = "KernelCeipTask","UsbCeip","ScheduledDefrag","Scheduled"
	$trusted_startup = "RTHDVCPL","IgfxTray"
	$trusted_exe = "MMC","NETSTAT","LASTACTIVITYVIEW","WMIC","REG","FINDSTR","SCHTASKS","HOSTNAME","CMD"
	$trusted_root_dir = "C:","D:"
	$trusted_second_dir = "","",""
	$trusted_third_dir = ""
	$trusted_usb = "Kingston DT 101 II USB Device","WD My Passport 25E2 USB Device"
	$trusted_ip = "192.168.0.1","192.168.0.2"
}else{ #Test
	$trusted_host = ""
	$trusted_usr = ""
	$trusted_schtasks = ""
	$trusted_startup = ""
	$trusted_exe = ""
	$trusted_root_dir = ""
	$trusted_second_dir = ""
	$trusted_third_dir = ""
	$trusted_usb = ""
	$trusted_ip = ""
}

#*************************************
# Log Review Status
#*************************************
$status_login_success,$status_user_account,$status_schtasks,$status_startup,$status_exe,$status_path,$status_usb,$status_ip = 1
$untrusted_login_success, $untrusted_usr,$untrusted_schtasks,$untrusted_startup,$untrusted_exe,$untrusted_path,$untrusted_usb,$untrusted_ip, $untrusted_conn = @()

#*************************************
# No Unauthorized Login
#*************************************

$securityLog = Get-EventLog "Security" -After $week | where {$_.EventID -eq 4624}
 
ForEach ($log in $securityLog) {
	$log_generated_time = ($log.TimeGenerated).tostring()
	$workstation_name = "-"
	$LogonTypeString = "Logon Type:"
	$idx = $log.Message.IndexOf($LogonTypeString)
	$LogonType = -1
	
	if( $idx -gt 0 ){
		$LogonType = $log.Message.Substring( $idx + $LogonTypeString.length, 7).trim()
	}
       
	If ($LogonType -eq 3 -or $LogonType -eq 10) {
		$logArray = $log.message.split("`n")
        
		if($LogonType -eq 10){
			$workstation_name = ""
			$source_network_address = $logArray[23].Split("`t")[2]
		}else{
			$workstation_name = $logArray[22].Split("`t")[2]
			
			if($workstation_name.Trim() -eq ""){
				$workstation_name = ""
			}
			$source_network_address = ""
		}

		$curr_log = "$log_generated_time;$source_network_address;$workstation_name`n"
		
		if($source_network_address -ne "" -or $workstation_name -ne ""){
			if($trusted_host -notContains $workstation_name.Trim()){
				$status_login_success = 0
				$untrusted_login_success += $curr_log
			}
		}
	}
}

#*************************************
# Schedule Tasks
#*************************************

$schtasks = schtasks | findstr /C:"/20"
$schtasks = $schtasks -replace '\s','*'

For ($i=0; $i -lt $schtasks.Length; $i++){
    $curr_task = $schtasks[$i] | %{ $_.Split('*');} 
    $space_found = 0
    $curr_task_name = ""
    
    For ($j=0; $j -lt $curr_task.Length -and $space_found -eq 0; $j++){
        if($curr_task[$j] -eq "" -or $curr_task[$j] -match "/" ){
            $space_found = 1
        }else{
            if($j -gt 0){
                $curr_task_name += " " + $curr_task[$j]
            }else{
                $curr_task_name += $curr_task[$j]
            }
        }
    }
    
    if($trusted_schtasks -notContains $curr_task_name){
        $status_schtasks = 0
        $untrusted_schtasks += $curr_task_name + "`n"
    }else{
    }
}

#*************************************
# Schedule Tasks (Startup)
#*************************************

$startup = reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
$startup += reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
$startup += reg query HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce
$startup += reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce

$startup_replaced = @()


For ($i=0; $i -lt $startup.Length; $i++){
    $curr_startup = $startup[$i]

    if($curr_startup -match "REG_"){ 
        $startup_replaced += $curr_startup -replace '\s','*'
        
    }
}

For ($i=0; $i -lt $startup_replaced.Length; $i++){
    $curr_startup = $startup_replaced[$i] | %{ $_.Split('*');} 
    $space_found = 0
    $curr_startup_name = ""
    
    For ($j=4; $j -lt $curr_startup.Length -and $space_found -eq 0; $j++){
    
        if($curr_startup[$j] -eq ""){
            $space_found = 1
        }else{
            if($j -gt 4){
                $curr_startup_name += " " + $curr_startup[$j].Trim()
            }else{
                $curr_startup_name += $curr_startup[$j].Trim()
            }
        }
    }
    
    if($trusted_startup -notContains $curr_startup_name){
        $status_startup = 0
        $untrusted_startup += $curr_startup_name + "`n"
    }
}

#*************************************
# User Account Changes
#*************************************

$usr = wmic UserAccount get Name

For ($i=1; $i -lt $usr.Length; $i++){
   $curr_usr = $usr[$i].Trim()
   
   if($i%2 -eq 0 -and $curr_usr -ne ""){
      if($trusted_usr -notContains $curr_usr){
         $status_user_account = 0
         $untrusted_usr += $curr_usr + "`n"
      }
   }  
}

#*************************************
# Processes and Services (EXE)
#*************************************

$filter_date = $week.Date
$prefetch = ls C:\Windows\Prefetch\ | Where-Object {$_.LastWriteTime -ge $filter_date} | sort LastWriteTime -Descending | select Name,LastWriteTime 

For ($i=0; $i -lt $prefetch.Length; $i++){
    $curr_prefetch_name = $prefetch[$i].Name
    
    If($curr_prefetch_name -match ".EXE"){
        $curr_prefetch_name = $curr_prefetch_name -split ".EXE"
        $curr_prefetch_name = $curr_prefetch_name[0]
    
        if($trusted_exe -notContains $curr_prefetch_name){
            $status_exe = 0
            $untrusted_exe += $curr_prefetch_name + "`n"
        }
    }
}

#*************************************
# Processes and Services (USB)
#*************************************

$usb = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* 

for($i=0; $i -lt $usb.Length; $i++){
    $curr_usb = $usb[$i].FriendlyName.Trim()
	
	if($trusted_usb -notContains $curr_usb -and $curr_usb -ne ""){
        $status_usb = 0
		$untrusted_usb += $curr_usb	+ "`n"
    }
}

#*************************************
# File and Registry Key
#*************************************

$WScript = New-Object -ComObject WScript.Shell
$current_usr = $env:UserName
$recent = Get-ChildItem -Path "C:\Users\$current_usr\AppData\Roaming\Microsoft\Windows\Recent\*.lnk" | sort LastWriteTime -Descending | where { $_.LastWriteTime -gt $week.Date } 
$recent_path = $recent | ForEach-Object {$WScript.CreateShortcut($_.FullName).TargetPath}

$r = $recent_path

For ($i=0; $i -lt $r.Length; $i++){
	$curr_path = $r[$i]
	$failed = 0
		
	if($curr_path.Trim() -ne ""){
		$file = $curr_path -split "\\"
		$root_dir = $file[0]
		$file_len = $file.Length
		
		if($file_len -gt 2){
			$third_dir = $file[2].Trim()
			$second_dir = $file[1].Trim()
		}elseif($file_len -gt 1){
			$second_dir = $file[1].Trim()
			
			if($second_dir -eq ""){
				$second_dir = $null
			}
			
			$third_dir = $null	
		}else{
			$second_dir = $null	
			$third_dir = $null
		}
		
		if($trusted_root_dir -notContains $root_dir){
			$status_path = 0
			$untrusted_path += $curr_path + "`n"
			$failed = 1
		}
		
		if($failed -lt 1){
			if($second_dir -ne $null){
				if($second_dir -NotMatch "\."){
					if($trusted_second_dir -notContains $second_dir){
						$status_path = 0
						$untrusted_path += $curr_path + "`n"
						$failed = 1
					}
				}
			}
		}
		
		if($failed -lt 1){
			if($third_dir -ne $null){
				if($third_dir -NotMatch "\."){
					if($trusted_third_dir -notContains $third_dir){
						$status_path = 0
						$untrusted_path += $curr_path + "`n"
					}
				}
			}
		}			
	}
}


#*************************************
# Network Usage
#*************************************

$connected = netstat -ano | findstr 192.168
$connected_r = $connected
$ip_target = $connected | %{ $_.Split(':')[1];}

$ip_target_third_addr = $ip_target | %{ $_.Split('.')[2];}
$ip_target_last_addr = $ip_target | %{ $_.Split('.')[3];}
$ip_target_arr = @() #Connected Remote IP

for($i=0; $i -lt $ip_target_last_addr.Length; $i++){
    $ip_4 = $ip_target_last_addr[$i].Trim()
    
    if($ip_4 -ne 0){
        $ip_3 = $ip_target_third_addr[$i].Trim()
        $ip_t = "192.168.$ip_3.$ip_4"
        
        if($ip_target_arr -notContains $ip_t -and $ip_3 -ne ""){
            $ip_target_arr += $ip_t
        }
		
    }
}

for($i=0; $i -lt $ip_target_arr.Length; $i++){
    $curr_ip = $ip_target_arr[$i].Trim()
    
    if($trusted_ip -notContains $curr_ip){
        if($untrusted_ip -notContains $curr_ip){
			$status_ip = 0
            $untrusted_ip += $curr_ip + "`n"
        }
    }
}

$untrusted_ip = $untrusted_ip | %{ $_.Split("`n");}

foreach($c in $connected_r){
    if($c -match "TCP" -or $c -notMatch "\*"){
        for($i=0; $i -lt $untrusted_ip.Length; $i++){
            $u = $untrusted_ip[$i]
            if($u -ne ""){
                if($c -match $u){
                    $untrusted_conn += $c + "`n"
                }
            }
        }
    }
}

#*************************************
# Log Review Summary
#*************************************
$num_pass,$num_fail = 0

if($status_login_success -eq 0){
	Write-Host "[-] Untrusted login(s) found!`n" -ForegroundColor Red
	$untrusted_login_success
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_schtasks -eq 0){
	Write-Host "[-] Untrusted task(s) found!`n" -ForegroundColor Red
	$untrusted_schtasks
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_startup -eq 0){
	Write-Host "[-] Untrusted startup(s) found!`n" -ForegroundColor Red
	$untrusted_startup
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_user_account -eq 0){
	Write-Host "[-] Invalid user(s) found!`n" -ForegroundColor Red
	$untrusted_usr
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_exe -eq 0){
	Write-Host "[-] Untrusted Executable(s) found!`n" -ForegroundColor Red
	$untrusted_exe
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_usb -eq 0){
	Write-Host "[-] Untrusted USB(s) found!`n" -ForegroundColor Red
	$untrusted_usb
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_path -eq 0){
	Write-Host "[-] Untrusted Path(s) found!`n" -ForegroundColor Red
	$untrusted_path
	$num_fail += 1
}else{
	$num_pass += 1
}

if($status_ip -eq 0){
	Write-Host "[-] Untrusted IP Address(es) and Connection(s) found!`n" -ForegroundColor Red
	$untrusted_ip
	$untrusted_conn
	$num_fail += 1
}else{
	$num_pass += 1
}

#Reporting
$datetime = Get-Date

if($num_pass -eq 8){ #All Pass
    $msg = "Pass: 100%"
}else{
    $msg = "Pass: $num_pass`nFailed: $num_fail" 
}

Write-Host $msg

$msg = "Log Review completed on $env:computername, $datetime`n`n$msg"
$a = new-object -comobject wscript.shell
$oReturn = $a.popup("$msg",10,"Windows Log Review",0) #Pop-up for 10 seconds