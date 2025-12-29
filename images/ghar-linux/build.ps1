Set-Location $PSScriptRoot
$ROOT = git rev-parse --show-toplevel
. $ROOT/scripts/utils.ps1

$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$runner_version = $json.tagName.Replace("v", "")
$version = "0.0.1"
if ($env:PUBLISH -eq "true") {
    docker buildx build `
        --push `
        --platform linux/amd64, linux/arm64 `
        --build-arg RUNNER_VERSION=$runner_version `
        --target local `
        -t glatzel/ghar-linux-local:latest `
        -t glatzel/ghar-linux-local:$runner_version `
        -t ghcr.io/glatzel/ghar-linux-local:latest `
        -t ghcr.io/glatzel/ghar-linux-local:$runner_version `
        .

    docker buildx build `
        --push `
        --platform linux/amd64, linux/arm64 `
        --target cloud `
        -t glatzel/ghar-linux:latest `
        -t glatzel/ghar-linux:$version `
        -t ghcr.io/glatzel/ghar-linux:latest `
        -t ghcr.io/glatzel/ghar-linux:$version `
        .
}
else {
    docker buildx build `
        --platform linux/amd64, linux/arm64 `
        --build-arg RUNNER_VERSION=$runner_version `
        --target local `
        -t glatzel/ghar-linux-local:latest `
        -t glatzel/ghar-linux-local:$runner_version `
        -t ghcr.io/glatzel/ghar-linux-local:latest `
        -t ghcr.io/glatzel/ghar-linux-local:$runner_version `
        .

    docker buildx build `
        --platform linux/amd64, linux/arm64 `
        --target cloud `
        -t glatzel/ghar-linux:latest `
        -t glatzel/ghar-linux:$version `
        -t ghcr.io/glatzel/ghar-linux:latest `
        -t ghcr.io/glatzel/ghar-linux:$version `
        .

}
