$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$version = "0.0.3"
$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$runner_version = $json.tagName.Replace("v", "")

# Write-Output "::group::release-cloud"
# docker buildx build `
#     $pushFlag `
#     --platform 'linux/amd64,linux/arm64' `
#     --target release-cloud `
#     -t glatzel/ghar-linux-release-cloud:latest `
#     -t glatzel/ghar-linux-release-cloud:$version `
#     -t ghcr.io/glatzel/ghar-linux-release-cloud:latest `
#     -t ghcr.io/glatzel/ghar-linux-release-cloud:$version `
#     .
# Write-Output "::endgroup::"
# Write-Output "::group::release-local"
# docker buildx build `
#     $pushFlag `
#     --platform 'linux/amd64,linux/arm64' `
#     --build-arg RUNNER_VERSION=$runner_version `
#     --build-arg RUNNER_VERSION=$runner_version `
#     --target release-local `
#     -t glatzel/ghar-linux-release-local:latest `
#     -t glatzel/ghar-linux-release-local:$version `
#     -t ghcr.io/glatzel/ghar-linux-release-local:latest `
#     -t ghcr.io/glatzel/ghar-linux-release-local:$version `
#     .
# Write-Output "::endgroup::"

Write-Output "::group::dev-local"
docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --build-arg RUNNER_VERSION=$runner_version `
    --target dev-local `
    -t glatzel/ghar-linux-dev-local:latest `
    -t glatzel/ghar-linux-dev-local:$runner_version `
    -t ghcr.io/glatzel/ghar-linux-dev-local:latest `
    -t ghcr.io/glatzel/ghar-linux-dev-local:$runner_version `
    .
Write-Output "::endgroup::"
