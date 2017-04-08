param(
    [switch]$pushImages = $false
)

$ErrorActionPreference = "Stop"
$whalecoreModulePath = "..\scripts\Whalecore.psm1"
$registryAddress = "whalecore.azurecr.io"
$dockerfilesPath = "..\dockerfiles"

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
}

function Invoke-BuildTagPush {
    param(
        [Parameter(Mandatory = $true)]
        [string]$imageName
    )

    $path = (Join-Path $dockerfilesPath $imageName)
    $version = Get-CurrentSemVer
    $tag = "${registryAddress}/${imageName}:${version}"

    Write-WhalecoreLog "Build & tag $path ($tag)"
    docker build --pull -t $tag $path

    if ($pushImages -eq $true) {
        Write-WhalecoreLog "Pushing $tag"
        docker push $tag
    }
    else{
        Write-WhalecoreLog "Not pushing image. Use -pushImages switch to push images to registry."
    }
}

Invoke-WhalecoreBuild