param(
    [switch]$publish
)

Set-Location $PSScriptRoot
$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$runner_version = $json.tagName.Replace("v", "")

docker buildx build -f ./Dockerfile `
    --platform linux/amd64, linux/arm64 `
    --build-arg RUNNER_VERSION=$runner_version `
    --target local `
    -t glatzel/ghar-linux-local:latest `
    -t glatzel/ghar-linux-local:$runner_version `
    -t ghcr.io/glatzel/ghar-linux-local:latest `
    -t ghcr.io/glatzel/ghar-linux-local:$runner_version `
    .
$version = "0.0.1"
docker buildx build -f ./Dockerfile `
    --platform linux/amd64, linux/arm64 `
    --target cloud `
    -t glatzel/ghar-linux:latest `
    -t glatzel/ghar-linux:$version `
    -t ghcr.io/glatzel/ghar-linux:latest `
    -t ghcr.io/glatzel/ghar-linux:$version `
    .

docker images
docker history --human --no-trunc glatzel/ghar-linux-local:latest
docker history --human --no-trunc glatzel/ghar-linux:latest

if ($publish) {
    Write-Host "Publishing all images..."

    $tags = @(
        "glatzel/ghar-linux-local:latest",
        "glatzel/ghar-linux-local:$runner_version",
        "glatzel/ghar-linux:latest",
        "glatzel/ghar-linux:$version",
        "ghcr.io/glatzel/ghar-linux-local:latest",
        "ghcr.io/glatzel/ghar-linux-local:$runner_version",
        "ghcr.io/glatzel/ghar-linux:latest",
        "ghcr.io/glatzel/ghar-linux:$version"
    )

    foreach ($tag in $tags) {
        docker push $tag
    }
}
