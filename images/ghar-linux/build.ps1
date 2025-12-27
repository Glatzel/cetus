Set-Location $PSScriptRoot
$name =Split-Path -Path $PSScriptRoot -Leaf
$version = "0.0.1"
docker buildx build -f ./Dockerfile `
    --platform linux/amd64,linux/arm64 `
    --build-arg RUNNER_VERSION=$version `
    -t $name `
    .
"version=$version" >> $env:GITHUB_OUTPUT
