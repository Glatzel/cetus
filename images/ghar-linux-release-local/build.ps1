Set-Location $PSScriptRoot/../ghar-linux
$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$runner_version = $json.tagName.Replace("v", "")

docker buildx build `
    $pushFlag `
    --platform 'linux/amd64,linux/arm64' `
    --target release-local `
    -t glatzel/ghar/linux/release/local:latest `
    -t glatzel/ghar/linux/release/local:$runner_version `
    -t ghcr.io/glatzel/ghar/linux/release/local:latest `
    -t ghcr.io/glatzel/ghar/linux/release/local:$runner_version `
    .
