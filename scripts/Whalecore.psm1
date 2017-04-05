$ErrorActionPreference = "Stop" 

function New-SecureString
{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$message
    )

    return ConvertTo-SecureString $message -AsPlainText -Force
}

function New-LocalAdmin
{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$username,
        [Parameter(Mandatory=$true)]
        [SecureString]$password
    )

    $existingUser = Get-LocalUser $username -ErrorAction Ignore
    if($existingUser -ne $null){
        Write-WhalecoreLog "Local user $username already exists."
    }
    else{
        Write-WhalecoreLog "Local user $username was not found. Creating local user."
        New-LocalUser -Name $username -password $password | Out-Null
    }

    $adminGroupName = "Administrators"
    $existingGroupMember = Get-LocalGroupMember -Group $adminGroupName -Member $username -ErrorAction Ignore
    if($existingGroupMember -ne $null)
    {
        Write-WhalecoreLog "$username is already member of group $adminGroupName"
    }
    else{
        Write-WhalecoreLog "Adding $username to group $adminGroupName"
        Add-LocalGroupMember -Group $adminGroupName -Member $username
    }
}

function Get-CurrentSemVer
{
    return (gitversion | ConvertFrom-Json).SemVer
}

function Write-WhalecoreLog
{
    param(
        [string]$message
    )

    Write-Host "[whalecore] $message" -ForegroundColor ([ConsoleColor]::Cyan)
}