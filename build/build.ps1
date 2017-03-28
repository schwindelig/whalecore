$registryAddress = "cloud.canister.io:5000"
$registryUsername = "schwindelig"
$dockerfilesPath = "..\dockerfiles"

# Build & tag base Windows Server image
$baseWindowsServerFolder = "whalecore-base-windows-server"
$baseWindowsServerRepoName = "whalecore-base-windows-server"
$baseWindowsServerTag = "latest"
$baseWindowsServerFullTag = "$registryAddress/$registryUsername/${baseWindowsServerRepoName}:${baseWindowsServerTag}"
docker build --pull -t $baseWindowsServerFullTag (Join-Path $dockerfilesPath $baseWindowsServerFolder)
docker push $baseWindowsServerFullTag

# Build & tag base IIS image