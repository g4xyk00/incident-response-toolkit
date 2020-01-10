*Compromise Assessment and Threat Hunting Testing Guide* compile the techniques and Indicator of Compromise (IoC) to perform the testing.  
# Web Server
## Apache Log Analysis
### 
> cat access.log | grep "<apache_keyword>"

> tail -n 1 access.log 

> less access.log

### Wireshark
> tcp contains fsock

> tcp contains SSH-2


https://github.com/fuzzdb-project/fuzzdb
