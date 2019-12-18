# Incident Response Toolkit (IRT): irtoolkit.bat
*Incident Response Toolkit (IRT)* is designed for cybersecurity incident handling and forensic.


## Usage
Right click *irtoolkit.bat* and *Run as administrator*.

# Incident Response Toolkit (IRT) Quick Review: irtoolkit_quick_review.bat
*Incident Response Toolkit (IRT) Quick Review* is designed to shorten the time for log review for specific range of dates. 

## Screenshot

![Screenshot](https://1.bp.blogspot.com/-A3ucfFspIqw/XfmfvaTEe7I/AAAAAAAACII/2eSCseEyK_0ba1zLse2HT51ojpKPszvSgCLcBGAsYHQ/s1600/Picture1.png)

![Screenshot](https://1.bp.blogspot.com/-gy_I7Xq1PVM/Xfmf0ioqQYI/AAAAAAAACIM/MZ_V9ai4upAzCdWD74MePs-gFdwObQ4owCLcBGAsYHQ/s1600/Picture2.png)

## CurrPorts
### Custom Log Line
> %Process_ID.5%;%Process_Name.20%;%Protocol.5%;%Local_Address.25%;%Remote_Address.35%;%User_Name.40%;%Process_Path.50%;%Remote_Host_Name.25%


## Report Filtering
### To list Windows logon information
> type le_logon_session_4624.txt | findstr "Date Type Name Workstation Source" | findstr -v "Log Package originated Microsoft-Windows-Security-Auditing User"
