# Original Microsoft entrypoint
C:\Whalecore\Scripts\MSSQL-Start.ps1 -sa_password $env:sa_password -ACCEPT_EULA $env:ACCEPT_EULA -attach_dbs \"$env:attach_dbs\" -Verbose

# Monitor
C:\Whalecore\Scripts\MSSQL-Monitor.ps1