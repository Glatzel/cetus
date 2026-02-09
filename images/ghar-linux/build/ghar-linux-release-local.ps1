Set-Location $PSScriptRoot/..
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$local_version = "0.0.5"
$runner_version = "2.331.0"
$date = "2026-02-08"

docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    --target release-local `
    -t glatzel/ghar-linux-release-local:latest `
    -t "glatzel/ghar-linux-release-local`:v${local_version}-runner-${runner_version}" `
    -t "glatzel/ghar-linux-release-local`:${date}" `
    -t ghcr.io/glatzel/ghar-linux-release-local:latest `
    -t "ghcr.io/glatzel/ghar-linux-release-local`:v${local_version}-runner-${runner_version}" `
    -t "ghcr.io/glatzel/ghar-linux-release-local`:${date}" `
    .
