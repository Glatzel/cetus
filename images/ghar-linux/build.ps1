Set-Location $PSScriptRoot
$name =Split-Path -Path $PSScriptRoot -Leaf
$version = "0.0.1"
docker build -f ./Dockerfile `
    --build-arg RUNNER_VERSION=$version `
    -t $name `
    .
"version=$version" >> $env:GITHUB_OUTPUT
