$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$cloud_version = "0.1.2"
$local_version = "0.0.5"
$runner_version = "2.331.0"
$date = "2026-02-08"

Write-Output "::group::release-cloud"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --target release-cloud `
    -t glatzel/ghar-linux-release-cloud:latest `
    -t glatzel/ghar-linux-release-cloud:v$cloud_version `
    -t glatzel/ghar-linux-release-cloud:$date `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:latest `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:v$cloud_version `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:$date `
    .
Write-Output "::endgroup::"
Write-Output "::group::release-local"
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
Write-Output "::endgroup::"
Write-Output "::group::dev-local"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    --target dev-local `
    -t glatzel/ghar-linux-dev-local:latest `
    -t "glatzel/ghar-linux-dev-local`:v${local_version}-runner-${runner_version}" `
    -t "glatzel/ghar-linux-dev-local`:${date}" `
    -t ghcr.io/glatzel/ghar-linux-dev-local:latest `
    -t "ghcr.io/glatzel/ghar-linux-dev-local`:v${local_version}-runner-${runner_version}" `
    -t "ghcr.io/glatzel/ghar-linux-dev-local`:${date}" `
    .
Write-Output "::endgroup::"
