*Compromise Assessment and Threat Hunting Testing Guide* compile the techniques and Indicator of Compromise (IoC) to perform the testing.  
# Web Server
## Apache Log Analysis
### 
> cat access.log | grep "<apache_keyword>"

> tail -n 1 access.log 

> less access.log

### Wireshark
> tcp contains fsock


## Tunneling
SSH
> tcp contains SSH-2

ICMP
> data.len > 63 and icmp

DNS
> dns.qry.name.len > 15 and !mdns
