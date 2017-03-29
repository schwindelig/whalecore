$registryAddress = "whalecore.azurecr.io"
$dockerfilesPath = "..\dockerfiles"

# Build & tag base Windows Server image
$baseWindowsServerFolder = "whalecore-base-windows-server"
$baseWindowsServerRepoName = "whalecore-base-windows-server"
$baseWindowsServerTag = "latest"
$baseWindowsServerFullTag = "$registryAddress/${baseWindowsServerRepoName}:${baseWindowsServerTag}"
docker build --pull -t $baseWindowsServerFullTag (Join-Path $dockerfilesPath $baseWindowsServerFolder)
Write-Host "Built and tagged $baseWindowsServerFullTag"
docker push $baseWindowsServerFullTag
Write-Host "Pushed $baseWindowsServerFullTag"

# Build & tag base IIS image