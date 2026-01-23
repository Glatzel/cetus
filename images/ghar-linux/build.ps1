$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$version = "0.0.3"
$runner_version = "2.331.0"

Write-Output "::group::release-cloud"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --target release-cloud `
    -t glatzel/ghar-linux-release-cloud:latest `
    -t glatzel/ghar-linux-release-cloud:v$version `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:latest `
    -t ghcr.io/glatzel/ghar-linux-release-cloud:v$version `
    .
Write-Output "::endgroup::"
Write-Output "::group::release-local"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    --build-arg RUNNER_VERSION=$runner_version `
    --target release-local `
    -t glatzel/ghar-linux-release-local:latest `
    -t "glatzel/ghar-linux-release-local`:v${version}-${version-runner}" `
    -t ghcr.io/glatzel/ghar-linux-release-local:latest `
    -t "ghcr.io/glatzel/ghar-linux-release-local`:v${version}-${version-runner}" `
    .
Write-Output "::endgroup::"
Write-Output "::group::dev-local"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    --target dev-local `
    -t glatzel/ghar-linux-dev-local:latest `
    -t "glatzel/ghar-linux-dev-local`:v${version}-${version-runner}" `
    -t ghcr.io/glatzel/ghar-linux-dev-local:latest `
    -t "ghcr.io/glatzel/ghar-linux-dev-local`:v${version}-${version-runner}" `
    .
Write-Output "::endgroup::"
