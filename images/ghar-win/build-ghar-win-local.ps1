$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$local_version = "0.0.1"
$runner_version = "2.331.0"
$date = "2026-02-08"
docker build `
    -f ./ghar-win-cloud.Dockerfile `
    -t cloud

docker build `
    --build-arg RUNNER_VERSION=$runner_version `
    -f ./ghar-win-local.Dockerfile
-t glatzel/ghar-win-local:latest `
    -t "glatzel/ghar-win-local`:v${local_version}-runner-${runner_version}" `
    -t glatzel/ghar-win-local:$date `
    -t glatzel/ghar-win-local:ltsc2025 `
    -t ghcr.io/glatzel/ghar-win-local:latest `
    -t "ghcr.io/glatzel/ghar-win-local`:v${local_version}-runner-${runner_version}" `
    -t ghcr.io/glatzel/ghar-win-local:$date `
    -t ghcr.io/glatzel/ghar-win-local:ltsc2025 `
    .
docker image ls
docker history glatzel/ghar-win-local:latest
if ($env:PUBLISH -eq "true") {
    docker push glatzel/ghar-win-local:latest
    docker push "glatzel/ghar-win-local`:v${local_version}-runner-${runner_version}"
    docker push glatzel/ghar-win-local:$date
    docker push ghcr.io/glatzel/ghar-win-local:latest
    docker push "ghcr.io/glatzel/ghar-win-local:v${local_version}-runner-${runner_version}"
    docker push ghcr.io/glatzel/ghar-win-local:$date
}
