Import-Module (Resolve-Path('../scripts/Whalecore.psm1'))

$registryAddress = "whalecore.azurecr.io"
$dockerfilesPath = "..\dockerfiles"

function Invoke-WhalecoreBuild
{
    # Build & tag base Windows Server image
    Invoke-BuildTagPush "whalecore-base-windows-server"

    # Build & tag base IIS image
    Invoke-BuildTagPush "whalecore-base-iis"
}

function Invoke-BuildTagPush
{
    param(
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]$imageName
    )

    $path = (Join-Path $dockerfilesPath $imageName)
    $version = Get-CurrentSemVer
    $tag = "${registryAddress}/${imageName}:${version}"

    Write-WhalecoreLog "Build & tag $path ($tag)"
    docker build --pull -t $tag $path

    Write-WhalecoreLog "Pushing $tag"
    docker push $tag
}

Invoke-WhalecoreBuild