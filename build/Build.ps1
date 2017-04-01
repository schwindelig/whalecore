param(
    [switch]$pushImages = $false
)

Import-Module (Resolve-Path('../scripts/Whalecore.psm1'))

$registryAddress = "whalecore.azurecr.io"
$dockerfilesPath = "..\dockerfiles"

function Invoke-WhalecoreBuild {
    Invoke-BuildTagPush "whalecore-base-windows-server"
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