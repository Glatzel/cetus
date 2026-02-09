$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
& ./build-pixi-base.ps1
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$local_version = "0.0.5"
$runner_version = "2.331.0"
$date = "2026-02-08"

docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    -f ./ghar-linux-dev-local.Dockerfile `
    -t glatzel/ghar-linux-dev-local:latest `
    -t glatzel/ghar-linux-dev-local:ubuntu-24.04 `
    -t "glatzel/ghar-linux-dev-local`:v${local_version}-runner-${runner_version}" `
    -t "glatzel/ghar-linux-dev-local`:${date}" `
    -t ghcr.io/glatzel/ghar-linux-dev-local:latest `
    -t ghcr.io/glatzel/ghar-linux-dev-local:ubuntu-24.04 `
    -t "ghcr.io/glatzel/ghar-linux-dev-local`:v${local_version}-runner-${runner_version}" `
    -t "ghcr.io/glatzel/ghar-linux-dev-local`:${date}" `
    .
