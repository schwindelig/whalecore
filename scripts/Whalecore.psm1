$ErrorActionPreference = "Stop" 

function Write-WhalecoreLog
{
    param(
        [string]$message
    )

    Write-Host "[whalecore] $message" -ForegroundColor ([ConsoleColor]::Cyan)
}