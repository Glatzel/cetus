Set-Location $PSScriptRoot/../ghar-linux
$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$version = "0.0.2"

docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --target release-cloud `
    -t glatzel/ghar-linux-release-cloud:latest `
    -t glatzel/ghar-linux-release-cloud:$version `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:latest `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:$version `
    .
