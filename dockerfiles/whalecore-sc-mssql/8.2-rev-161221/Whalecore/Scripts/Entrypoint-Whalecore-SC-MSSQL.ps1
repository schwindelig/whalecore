$ErrorActionPreference = "Stop"
Import-Module (Resolve-Path "C:\Whalecore\scripts\Whalecore.psm1")

# Original Microsoft entrypoint
Write-WhalecoreLog "Prepare MSSQL DB ..."
C:\Whalecore\Scripts\MSSQL-Start.ps1 -sa_password $env:sa_password -ACCEPT_EULA $env:ACCEPT_EULA -attach_dbs \"$env:attach_dbs\" -Verbose

# Ensure logins and permissions
Write-WhalecoreLog "Setting Sitecore permissions ..."
C:\Whalecore\Scripts\DSC-Whalecore-SC-MSSQL.ps1

# Monitor
Write-WhalecoreLog "Waiting for connections ..."
C:\Whalecore\Scripts\MSSQL-Monitor.ps1