Import-Module (Resolve-Path('Whalecore.psm1'))

function BuildTagPush($fullTag, $dockerfilePath)
{
    Write-WhalecoreLog "Build & tag $fullTag ..."
    docker build --pull -t $fullTag $dockerfilePath
    Write-WhalecoreLog "Pushing $fullTag ..."
    docker push $fullTag
}

function InitBuild
{
    $registryAddress = "whalecore.azurecr.io"
    $dockerfilesPath = "..\dockerfiles"

    # Build & tag base Windows Server image
    $baseWindowsServerRepoName = "whalecore-base-windows-server"
    $baseWindowsServerTag = "latest"
    $baseWindowsServerFullTag = "$registryAddress/${baseWindowsServerRepoName}:${baseWindowsServerTag}"
    BuildTagPush $baseWindowsServerFullTag (Join-Path $dockerfilesPath $baseWindowsServerRepoName)

    # Build & tag base IIS image
    $baseIisRepoName = "whalecore-base-iis"
    $baseIisTag = "latest"
    $baseIisFullTag = "$registryAddress/${baseIisRepoName}:${baseIisTag}"
    BuildTagPush $baseIisFullTag (Join-Path $dockerfilesPath $baseIisRepoName)
}

InitBuild