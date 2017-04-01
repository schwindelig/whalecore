Import-Module (Resolve-Path('../scripts/Whalecore.psm1'))

function Invoke-WhalecoreBuild
{
    $registryAddress = "whalecore.azurecr.io"
    $dockerfilesPath = "..\dockerfiles"

    # Build & tag base Windows Server image
    $baseWindowsServerRepoName = "whalecore-base-windows-server"
    $baseWindowsServerTag = "latest"
    $baseWindowsServerFullTag = "$registryAddress/${baseWindowsServerRepoName}:${baseWindowsServerTag}"
    Invoke-BuildTagPush $baseWindowsServerFullTag (Join-Path $dockerfilesPath $baseWindowsServerRepoName)

    # Build & tag base IIS image
    $baseIisRepoName = "whalecore-base-iis"
    $baseIisTag = "latest"
    $baseIisFullTag = "$registryAddress/${baseIisRepoName}:${baseIisTag}"
    Invoke-BuildTagPush $baseIisFullTag (Join-Path $dockerfilesPath $baseIisRepoName)
}

function Invoke-BuildTagPush
{
    param(
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]$fullTag,
        [Parameter(Mandatory=$true)]
        [string]$dockerfilePath
    )

    Write-WhalecoreLog "Build & tag $fullTag ..."
    docker build --pull -t $fullTag $dockerfilePath
    Write-WhalecoreLog "Pushing $fullTag ..."
    docker push $fullTag
}

Invoke-WhalecoreBuild