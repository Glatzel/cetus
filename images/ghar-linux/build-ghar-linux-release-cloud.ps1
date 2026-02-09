$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
& ./build-pixi-base.ps1
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$cloud_version = "0.1.2"
$date = "2026-02-08"

docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    -f ./ghar-linux-release-cloud.Dockerfile `
    -t glatzel/ghar-linux-release-cloud:latest `
    -t glatzel/ghar-linux-release-cloud:alma8 `
    -t glatzel/ghar-linux-release-cloud:v$cloud_version `
    -t glatzel/ghar-linux-release-cloud:$date `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:latest `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:alma8 `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:v$cloud_version `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:$date `
    .
