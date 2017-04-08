$ErrorActionPreference = "Stop"
Import-Module (Resolve-Path "C:\Whalecore\scripts\Whalecore.psm1")

# Environment variables for this container
if($env:whalecore_local_admin_create -eq $null)
{
    $env:whalecore_local_admin_create = $false;
}
if($env:whalecore_local_admin_username -eq $null)
{
    $env:whalecore_local_admin_username = "whalecore_admin"
}
if($env:whalecore_local_admin_password -eq $null)
{
    $env:whalecore_local_admin_password = "-#w@l3s&B4c0n!-"
}

# Check if local admin should be created
if($env:whalecore_local_admin_create -eq $true)
{
    Write-WhalecoreLog "Ensuring local admin exists"
    New-LocalAdmin -username $env:whalecore_local_admin_username -password (New-SecureString $env:whalecore_local_admin_password)
}
else
{
    Write-WhalecoreLog "Skipping admin creation check"
}

# Original Microsoft IIS entrypoint
C:\Whalecore\Bin\ServiceMonitor.exe w3svc