param(
    [string]$buildMode = "local"
)

$ErrorActionPreference = "Stop"
$whalecoreModulePath = "..\scripts\Whalecore.psm1"
$registryAddress = "whalecore.azurecr.io"
$dockerfilesPath = "..\dockerfiles"
$buildModeLocal = "local"
$buildModeNighty = "nightly"
$buildModeRelease = "release"

Import-Module (Resolve-Path($whalecoreModulePath))

function Invoke-WhalecoreBuild {
    # Base Windows Server
    ## Copy Whalecore Module to build context
    $baseWindowsServerImageName = "whalecore-base-windows-server"
    $whalecoreModuleDestinationPath = "$dockerfilesPath\$baseWindowsServerImageName\Whalecore\Scripts\Whalecore.psm1"
    New-Item $whalecoreModuleDestinationPath -Force | Out-Null
    Copy-Item $whalecoreModulePath $whalecoreModuleDestinationPath
    Invoke-BuildTagPush $baseWindowsServerImageName

    # Base IIS
    Invoke-BuildTagPush "whalecore-base-iis"

    # Base MSSQL
    Invoke-BuildTagPush "whalecore-base-mssql"

    # Sitecore MSSQL (8.2-rev-161221)
    Invoke-BuildTagPush -imageName "whalecore-sc-mssql" -sitecoreVersionLabel "8.2-rev-161221"
}

function Invoke-BuildTagPush {
    param(
        [Parameter(Mandatory = $true)]
        [string]$imageName,
        [string]$sitecoreVersionLabel
    )

    Write-WhalecoreLog "Building $imageName"

    $tags = Get-BuildTags -imageName $imageName -version (Get-CurrentSemVer) -sitecoreVersionLabel $sitecoreVersionLabel
    $buildArguments = Get-BuildArguments -imageName $imageName -tags $tags -sitecoreVersionLabel $sitecoreVersionLabel

    Invoke-Expression "docker $buildArguments" -ErrorAction "Stop"

    # TODO for other buildModes: add --no-cache, --pull, etc
    # TODO for other buildModes: push every tag
    # --> docker push $tag
}

function Get-BuildTags
{
    [OutputType([String[]])]
    param(
        [string]$imageName,
        [string]$version,
        [string]$sitecoreVersionLabel
    )

    $result = New-Object System.Collections.Generic.List[System.String]
    $base = "${registryAddress}/${imageName}"
    $result.Add("${base}:${version}")

    if($buildMode -like $buildModeLocal -and !$sitecoreVersionLabel)
    {
        $result.Add("${base}:latest")
    }

    if($sitecoreVersionLabel)
    {
        $result.Add("${base}:${sitecoreVersionLabel}")
    }

    return $result.ToArray()
}

function Get-BuildArguments
{
    param(
        [string]$imageName,
        [string[]]$tags,
        [string]$sitecoreVersionLabel
    )

    $path = Join-Path $dockerfilesPath $imageName
    $path = (Join-Path $path $sitecoreVersionLabel)
    Write-WhalecoreLog "Path is $path"
    $tagsArgs = $tags | ForEach-Object { "-t $_" }
    $pullArgs = $null #if($buildMode -like $buildModeLocal){ "--pull" }

    return "build $pullArgs $tagsArgs $path"
}

Invoke-WhalecoreBuild