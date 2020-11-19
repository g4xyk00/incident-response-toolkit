function Get-NetstatProcess 
    { 
        $header = 'Protocol','LocalAddress','LocalPort','RemoteAddress','RemotePort','State','PID','ProcessName','Path'

        netstat -ano | Select-String -Pattern '\s+(TCP|UDP)' | ForEach-Object {

            $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries)
			$rowProto = $item[0]
			$rowLocalAddr = $item[1]
			$rowRemoteAddr = $item[2]
			$rowState = $item[3]
			$rowPID = $item[-1]
			
            if($rowLocalAddr -notmatch '^\[::') {            
                if (($la = $rowLocalAddr -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') { 
                   $localAddress = $la.IPAddressToString 
                   $localPort = $rowLocalAddr.split('\]:')[-1] 
                } else { 
                    $localAddress = $rowLocalAddr.split(':')[0] 
                    $localPort = $rowLocalAddr.split(':')[-1] 
                } 

                if (($ra = $rowRemoteAddr -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') { 
                   $remoteAddress = $ra.IPAddressToString 
                   $remotePort = $rowRemoteAddr.split('\]:')[-1] 
                } else { 
                   $remoteAddress = $rowRemoteAddr.split(':')[0] 
                   $remotePort = $rowRemoteAddr.split(':')[-1] 
                } 

                New-Object PSObject -Property @{
                    Protocol = $rowProto 
                    LocalAddress = $localAddress 
                    LocalPort = [int]$localPort 
                    RemoteAddress =$remoteAddress 
                    RemotePort = $remotePort 
                    State = if($rowProto -eq 'tcp') {$rowState} else {$null} 
					PID = $rowPID 
                    ProcessName = (Get-Process -Id $rowPID -ErrorAction SilentlyContinue).Name 
                    Path = (Get-Process -Id $rowPID) | Select-Object Path
                } | Select-Object -Property $header
            } 
        } 
    }

Get-NetstatProcess | Sort-Object -Property State | Format-Table -AutoSize 
