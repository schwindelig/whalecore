$registryUsername = "schwindelig"
$dockerfilesPath = "..\dockerfiles"

# Build & tag base Windows Server image
$baseWindowsServerFolder = "whalecore-base-windows-server"
$baseWindowsServerRepoName = "whalecore-base-windows-server"
docker build --pull -t "$registryUsername/$baseWindowsServerRepoName" (Join-Path $dockerfilesPath $baseWindowsServerFolder)

# Build & tag base IIS image