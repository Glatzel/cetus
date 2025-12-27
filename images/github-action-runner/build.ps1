Set-Location $PSScriptRoot
$name =Split-Path -Path $PSScriptRoot -Leaf
$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$version = $json.tagName.Replace("v", "")
$tag="glatzel/${name}"
docker build -f ./Dockerfile `
    --build-arg RUNNER_VERSION=$version `
    -t $tag `
    .
"version=$version" >> $env:GITHUB_OUTPUT
