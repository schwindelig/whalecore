$ErrorActionPreference = "Stop"
Import-Module (Resolve-Path "C:\Whalecore\scripts\Whalecore.psm1")

# Whalecore DB user credentials
$credentials = New-Credentials -username $env:whalecore_db_user_username -password (New-SecureString $env:whalecore_db_user_password)

$sqlServer = "localhost"
$sqlInstanceName = "MSSQLSERVER"

Configuration DSC-Whalecore-SC-MSSQL
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSqlServer

    node localhost 
    {
        # Ensure Whalecore DB User Login
        xSQLServerLogin WhalecoreDbUser
        {
            Ensure = "Present"
            Name = $credentials.UserName
            LoginType = "SqlLogin"
            SQLServer = $sqlServer
            SQLInstanceName = $sqlInstanceName
            LoginCredential = $credentials
            LoginMustChangePassword = $false
            LoginPasswordExpirationEnabled = $false
            LoginPasswordPolicyEnforced = $false
        }

        # Please note that we will not assign the "public" role, as this seems
        # to be added automatically causing xSqlServer to throw some exceptions.

        if($env:whalecore_db_host_analytics -eq $true)
        {
            Write-WhalecoreLog "Hosting analytics DB: $env:whalecore_db_name_analytics"
            xSQLServerDatabaseRole Add_Database_Roles_Analytics
            {
                Ensure = "Present"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                Name = $credentials.UserName
                Role = "db_datareader","db_datawriter"
                Database = $env:whalecore_db_name_analytics
                DependsOn = "[xSQLServerLogin]WhalecoreDbUser"
            }
            xSQLServerDatabasePermission Grant_Execute_Permission_Analytics
            {
                Ensure = "Present"
                Name = $credentials.UserName
                Database = $env:whalecore_db_name_analytics
                PermissionState = "Grant"
                Permissions = "Execute"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                DependsOn = '[xSQLServerLogin]WhalecoreDbUser','[xSQLServerDatabaseRole]Add_Database_Roles_Analytics'
            }
        }
        if($env:whalecore_db_host_core -eq $true)
        {
            Write-WhalecoreLog "Hosting core DB: $env:whalecore_db_name_core"
            xSQLServerDatabaseRole Add_Database_Roles_Core
            {
                Ensure = "Present"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                Name = $credentials.UserName
                Role =  "db_datareader", "db_datawriter",
                        "aspnet_Membership_BasicAccess", "aspnet_Membership_FullAccess", "aspnet_Membership_ReportingAccess",
                        "aspnet_Profile_BasicAccess", "aspnet_Profile_FullAccess", "aspnet_Profile_ReportingAccess",
                        "aspnet_Roles_BasicAccess", "aspnet_Roles_FullAccess", "aspnet_Roles_ReportingAccess"
                Database = $env:whalecore_db_name_core
                DependsOn = "[xSQLServerLogin]WhalecoreDbUser"
            }
            xSQLServerDatabasePermission Grant_Execute_Permission_Core
            {
                Ensure = "Present"
                Name = $credentials.UserName
                Database = $env:whalecore_db_name_core
                PermissionState = "Grant"
                Permissions = "Execute"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                DependsOn = '[xSQLServerLogin]WhalecoreDbUser','[xSQLServerDatabaseRole]Add_Database_Roles_Core'
            }
        }
        if($env:whalecore_db_host_master -eq $true)
        {
            Write-WhalecoreLog "Hosting master DB: $env:whalecore_db_name_master"
            xSQLServerDatabaseRole Add_Database_Roles_Master
            {
                Ensure = "Present"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                Name = $credentials.UserName
                Role = "db_datareader", "db_datawriter"
                Database = $env:whalecore_db_name_master
                DependsOn = "[xSQLServerLogin]WhalecoreDbUser"
            }
            xSQLServerDatabasePermission Grant_Execute_Permission_Master
            {
                Ensure = "Present"
                Name = $credentials.UserName
                Database = $env:whalecore_db_name_master
                PermissionState = "Grant"
                Permissions = "Execute"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                DependsOn = '[xSQLServerLogin]WhalecoreDbUser','[xSQLServerDatabaseRole]Add_Database_Roles_Master'
            }
        }
        if($env:whalecore_db_host_sessions -eq $true)
        {
            Write-WhalecoreLog "Hosting sessions DB: $env:whalecore_db_name_sessions"
            xSQLServerDatabaseRole Add_Database_Roles_Sessions
            {
                Ensure = "Present"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                Name = $credentials.UserName
                Role = "db_datareader", "db_datawriter"
                Database = $env:whalecore_db_name_sessions
                DependsOn = "[xSQLServerLogin]WhalecoreDbUser"
            }
            xSQLServerDatabasePermission Grant_Execute_Permission_Sessions
            {
                Ensure = "Present"
                Name = $credentials.UserName
                Database = $env:whalecore_db_name_sessions
                PermissionState = "Grant"
                Permissions = "Execute"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                DependsOn = '[xSQLServerLogin]WhalecoreDbUser','[xSQLServerDatabaseRole]Add_Database_Roles_Sessions'
            }
        }
        if($env:whalecore_db_host_web -eq $true)
        {
            Write-WhalecoreLog "Hosting web DB: $env:whalecore_db_name_web"
            xSQLServerDatabaseRole Add_Database_Roles_Web
            {
                Ensure = "Present"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                Name = $credentials.UserName
                Role = "db_datareader", "db_datawriter"
                Database = $env:whalecore_db_name_web
                DependsOn = "[xSQLServerLogin]WhalecoreDbUser"
            }
            xSQLServerDatabasePermission Grant_Execute_Permission_Web
            {
                Ensure = "Present"
                Name = $credentials.UserName
                Database = $env:whalecore_db_name_web
                PermissionState = "Grant"
                Permissions = "Execute"
                SQLServer = $sqlServer
                SQLInstanceName = $sqlInstanceName
                DependsOn = '[xSQLServerLogin]WhalecoreDbUser','[xSQLServerDatabaseRole]Add_Database_Roles_Web'
            }
        }
    }
}

$configurationData =
@{
    AllNodes = 
    @(
        @{
            NodeName = 'localhost';
            PSDscAllowPlainTextPassword = $true
        }
    )
}

DSC-Whalecore-SC-MSSQL -ConfigurationData $configurationData
Start-DscConfiguration .\DSC-Whalecore-SC-MSSQL -Wait -Force -Verbose