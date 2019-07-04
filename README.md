# incident-response-toolkit
Incident Response Toolkit (IRT) is designed for cybersecurity incident handling. 


## Usage
Right click *irtoolkit.bat* and *Run as administrator*.


## Screenshot
![Screenshot](https://lh3.googleusercontent.com/ZLLeQM0TmhIJyZzHGA7oQNVOGWOAYWaHoNcot2rUV0tifib4Qzf2T3XaqyXDysmWsRc3tMms4tmI7jVYBDCd16psYBGit2DPkZyeteW8sCd3NBAOGA5GW6Ds9_VPQQvYvhpU0C7Jn2QWKg0VzzcQLOqqGxY5cQRKPu_9-5j7WzD8Rpkc7D4W-o2XaPDTsAVbTJd0zElIlUKbs9_qKq13lt_qF0zcn2Ptt8P2Q5zuBIb1-TE6UMuMgSJZfMBDjj2XhoQQmCl55t7NsgsZSNCKrGyz1VOE3w2m-d1-PQrQ44GHbawgdWc4Ztzebu2wmu8UGrHuWlLQZ-B1JZ-zkl7pW_YTdK9NOan0_DkYw-bySv4gNakvnkkSqzrNud0oWql0DIBsF4XRZZgWDLnM94WOT6YK-XjbvKfuaQ-3dS_9CgPzwX-aDeKnyYQm18xi6xMx456HG432qFl983Mj8elMfNu2ByzHBvLkOSNTRq7wpvA9tDBrUVt_kXR3_jluVhaFpFi-bnzfLiZltEp7F_zOLSWVL4wLd-hlU2IBbsm5aozwr7VXmB4pLpr6UF4yfP6v5SsuDfsq9X7GYncedErDWCQd2lE2108_5MYn-4cNhCh0JtK7kT1x0JpHdfi44IfQoMpKhwxS0Eq6k_J7tpHP_hBS-aiYSlo=w881-h394-no)


## Report Filtering
### To list Windows logon information
> type le_logon_session_4624.txt | findstr "Date Type Name Workstation Source" | findstr -v "Log Package originated Microsoft-Windows-Security-Auditing User"
