# Sunburst IOC Scanner
# Author: g4xyk00

$ver = "0.3"
Write-Host "Sunburst IOC Scanner" $ver "`n"

$date = Get-Date -Format yyyyMMdd
$hostname = hostname

$eventId = "4624","4648","4627","4732","6144","4698","4697","1102","4719"

# [4624] Check for suspicious successful logon to server
# [4648,4627] Check for suspicious logon to servers via RunAs
# [4732] Check for existing account added to built-in administrator group
# [6144] Validate changes to security policy 
# [4698] Check for new scheduled task being created
# [4697] Check for new services added
# [1102] Verify if audit logs was cleared
# [4719] Verify if audit policy was edited

$pathRoot = "C:\sunburst_scan\"
$folderName = $date + "_" + $hostname
$pathFolder = $pathRoot + $folderName

New-Item -Path $pathFolder -ItemType "directory" -ErrorAction SilentlyContinue
cd $pathFolder

$hitNumber = 0

function checkEventHit($evtid, $report, $string){

    if ((Get-Content $report) -ne $Null) {
        if($evtid -eq 4624){
            foreach($l in Get-Content $report) {
                if($l -like $string){
                    Write-Host "[-] Successful RDP authentication`n" -ForegroundColor red
                    $hitNumber += 1
                }
            }
        }elseif($evtid -eq 4648){
            Write-Host "[-] Suspicious logon to servers via RunAs`n" -ForegroundColor red 
            $hitNumber += 1
        }elseif($evtid -eq 4732){
            Write-Host "[-] Existing account added to built-in administrator group`n" -ForegroundColor red 
            $hitNumber += 1
        }elseif($evtid -eq 6144){
            Write-Host "[-] Changes to security policy`n" -ForegroundColor red 
            $hitNumber += 1
        }elseif($evtid -eq 4698){
            Write-Host "[-] New scheduled task being created`n" -ForegroundColor red
            $hitNumber += 1 
        }elseif($evtid -eq 4697){
            Write-Host "[-] New services added`n" -ForegroundColor red 
            $hitNumber += 1
        }elseif($evtid -eq 1102){
            Write-Host "[-] Audit logs was cleared`n" -ForegroundColor red 
            $hitNumber += 1
        }elseif($evtid -eq 4719){
            Write-Host "[-] Audit policy was edited`n" -ForegroundColor red 
            $hitNumber += 1
        }
    }
}


function checkPrivilegeHit($option, $report){
    if ((Get-Content $report) -ne $Null) {
        if($option -eq 1){ #Ensure interactive and remote interactive sessions for service accounts are disabled
            foreach($l in Get-Content $report) {
                #SeDenyInteractiveLogonRight = Deny log on locally
                if($l -like 'SeDenyInteractiveLogonRight*'){ 
                    Write-Host "[*]" $l -ForegroundColor yellow
                }
                #SeDenyRemoteInteractiveLogonRight = Deny log on through Terminal Services
                elseif($l -like 'SeDenyRemoteInteractiveLogonRight*'){ 
                    Write-Host "[*]" $l "`n" -ForegroundColor yellow
                }
            }
        }else{ #Check for dormant privileged accounts
            foreach($l in Get-Content $report) {
                if($l -like "Name*" -or $l -like "SID*"){
                    Write-Host "[*]" $l -ForegroundColor yellow
                }
            } 
        }
    }
}

Write-Host "[INFO] Collecting evidences..."

ForEach ($id in $eventId) {
    $report = $pathFolder + "\" + $id + ".txt"
    Get-WinEvent -FilterHashtable @{logname=’security’; id=$id; StartTime=(Get-Date).date} -ErrorAction SilentlyContinue | Format-List | Out-File $report

    if ((Get-Content $report) -ne $Null) {
        if ($id -eq 4624){
            $filter = "Logon Type:","Account Name:","Workstation Name:","Source Network Address:","Source Port:"
        } elseif ($id -eq 4648){
            $filter = "Account Name:","Account Domain:","Process Name:"
        } elseif ($id -eq 4627){
            $filter = "Account Name:","Group Membership:"
        } elseif ($id -eq 4732){
            $filter = "MemberSID:","SubjectUserName:","TargetUserName:","TargetSID:","Keywords:"
        } elseif ($id -eq 6144){
            $filter = "Return Code:"
        } elseif ($id -eq 4698){
            $filter = "Security ID:","Account Name:","Task Name:","Task Content:"
        } elseif ($id -eq 4697){
            $filter = "Security ID:","Account Name:","Service Name:","Service File Name:"
        } elseif ($id -eq 1102){
            $filter = "Security ID:","Security ID:","Domain Name:"
        } elseif ($id -eq 4719){
            $filter = "Account Name:","Account Domain:","Category:","Subcategory:","Changes:"
        } else {
            $filter = ""
        }

        ForEach ($f in $filter) {
                $analysedReport = $pathFolder + "\" + $id + "_" + $f.Replace(":","") + ".txt"
                Get-Content $report | ? { $_ -match $f } | Out-File $analysedReport
        }
    }

}

$report = $pathFolder + "\localuser.txt"
Get-WmiObject Win32_UserAccount | Out-File $report
secedit /export /cfg cfg.ini

Write-Host "[INFO] Reports are generated at $pathFolder`n" -ForegroundColor green

#####################################################

echo "[INFO] Check for suspicious successful logon to server (1/10)"
$analysedReport = $pathFolder + "\4624_Logon Type.txt"
checkEventHit 4624 $analysedReport "*10*"

echo "[INFO] Check for suspicious logon to servers via RunAs (2/10)"
$analysedReport = $pathFolder + "\4648.txt"
checkEventHit 4648 $analysedReport ""
$analysedReport = $pathFolder + "\4627.txt"
checkEventHit 4627 $analysedReport ""

echo "[INFO] Check for existing account added to built-in administrator group (3/10) "
$analysedReport = $pathFolder + "\4732.txt"
checkEventHit 4732 $analysedReport ""

echo "[INFO] Ensure interactive and remote interactive sessions for service accounts are disabled (4/10)"
$analysedReport = $pathFolder + "\cfg.ini"
checkPrivilegeHit 1 $analysedReport

echo "[INFO] Validate changes to security policy (5/10)"
$analysedReport = $pathFolder + "\6144.txt"
checkEventHit 6144 $analysedReport ""

echo "[INFO] Check for new scheduled task being created (6/10)"
$analysedReport = $pathFolder + "\4698.txt"
checkEventHit 4698 $analysedReport ""

echo "[INFO] Check for new services added (7/10)"
$analysedReport = $pathFolder + "\4697.txt"
checkEventHit 4697 $analysedReport ""

echo "[INFO] Check for dormant privileged accounts (8/10)"
$analysedReport = $pathFolder + "\localuser.txt"
checkPrivilegeHit 2 $analysedReport

echo "[INFO] Verify if audit logs was cleared (9/10)"
$analysedReport = $pathFolder + "\1102.txt"
checkEventHit 1102 $analysedReport ""

echo "[INFO] Verify if audit policy was edited (10/10)"
$analysedReport = $pathFolder + "\4719.txt"
checkEventHit 4719 $analysedReport ""

#####################################################

echo "`n====================="
echo "SUMMARY REPORT"
echo "====================="

if($hitNumber -gt 0){
    Write-Host "HIT (Event ID): " $hitNumber -ForegroundColor red
}else{
    Write-Host "HIT (Event ID): " $hitNumber -ForegroundColor green
}