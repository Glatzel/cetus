Set-Location $PSScriptRoot
$name =Split-Path -Path $PSScriptRoot -Leaf
$json = gh release view -R actions/runner --json tagName | ConvertFrom-Json
$version = $json.tagName.Replace("v", "")
docker build -f github-action-runner/Dockerfile `
    --build-arg RUNNER_VERSION=$version `
    -t Glatzel/cetus:${name}-${version} `
    .
