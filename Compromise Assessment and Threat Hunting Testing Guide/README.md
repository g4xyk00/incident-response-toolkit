*Compromise Assessment and Threat Hunting Testing Guide* compile the techniques and Indicator of Compromise (IoC) to perform the testing.  
# EndPoint


# Web Server
## Apache
###  Log Analysis
```bash
cat access.log | grep "<apache_keyword>"
tail -n 1 access.log 
less access.log
```

### PHP Webshell
```bash
find . -type f -name "*.php" | xargs egrep -i "(fsockopen|pfsockopen|exec|shell|eval|rot13|base64|passthru|system)"
```

### File System Integrity
```bash
for f in $(ls); do echo $(md5sum $f); done > baseline.txt
diff baseline.txt compare.txt
```
### Web Directory Integrity
```bash
cd /var/www/html && find . -mtime -1
```

# Network
## Wireshark

Wireshark > Statistics > Conversations > TCP
Wireshark > Statistics > Protocol Hierarchy

### Tunneling
> tcp contains <apache_keyword>

## Tunneling
SSH
> tcp contains SSH-2

ICMP
> data.len > 63 and icmp

DNS
> dns.qry.name.len > 15 and !mdns

# Mail Server
## Outlook 365

