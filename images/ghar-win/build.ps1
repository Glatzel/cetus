$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$cloud_version = "0.0.1"
$local_version = "0.0.1"
$runner_version = "2.331.0"
$date = "2026-02-08"

Write-Output "::group::cloud"
docker build `
    $pushFlag `
    --target cloud `
    -t glatzel/ghar-win-cloud:latest `
    -t glatzel/ghar-win-cloud:v$cloud_version `
    -t glatzel/ghar-win-cloud:$date `
    -t ghcr.io/glatzel/ghar-win-cloud:latest `
    -t ghcr.io/glatzel/ghar-win-cloud:v$cloud_version `
    -t ghcr.io/glatzel/ghar-win-cloud:$date `
    .
Write-Output "::endgroup::"
Write-Output "::group::local"
docker build `
    $pushFlag `
    --build-arg RUNNER_VERSION=$runner_version `
    --build-arg RUNNER_VERSION=$runner_version `
    --target local `
    -t glatzel/ghar-win-local:latest `
    -t "glatzel/ghar-win-local`:v${version}-runner-${runner_version}" `
    -t "glatzel/ghar-win-local`:${date}" `
    -t ghcr.io/glatzel/ghar-win-local:latest `
    -t "ghcr.io/glatzel/ghar-win-local`:v${local_version}-runner-${runner_version}" `
    -t "ghcr.io/glatzel/ghar-win-local`:${date}" `
    .
Write-Output "::endgroup::"
