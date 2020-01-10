*Compromise Assessment and Threat Hunting Testing Guide* compile the techniques and Indicator of Compromise (IoC) to perform the testing.  
# EndPoint



# Web Server
## Apache
###  Log Analysis
> cat access.log | grep "<apache_keyword>"

> tail -n 1 access.log 

> less access.log

### File System Integrity
> for f in $(ls); do echo $(md5sum $f); done > baseline.txt

> diff baseline.txt compare.txt

### Web Directory Integrity
> cd /var/www/html && find . -mtime -1

# Network
### Wireshark
> tcp contains fsock

## Tunneling
SSH
> tcp contains SSH-2

ICMP
> data.len > 63 and icmp

DNS
> dns.qry.name.len > 15 and !mdns

# Mail Server
## Outlook 365

