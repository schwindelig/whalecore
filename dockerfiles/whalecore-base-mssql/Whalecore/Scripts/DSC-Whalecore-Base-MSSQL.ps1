Configuration DSC-Whalecore-Base-MSSQL
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration' 

    node localhost 
    {
        Script NugetPackageProvider   
        {
            SetScript = {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
            TestScript =  {if ((Get-PackageProvider -listavailable -name nuget -erroraction SilentlyContinue).Count -eq 0) {return $false} else {return $true}}
            GetScript = {@{Result = "true"}}       
        }
        Script XSqlServer
        { 
            SetScript = {Install-Module xSQLServer }
            TestScript =  {if ((get-module xSQLServer -ListAvailable).Count -eq 0){return $false}else {return $true}}
            GetScript = {@{Result = "true"}}
            DependsOn = "[Script]NugetPackageProvider"
        }
    }
}

DSC-Whalecore-Base-MSSQL
Start-DscConfiguration .\DSC-Whalecore-Base-MSSQL -Wait -Force