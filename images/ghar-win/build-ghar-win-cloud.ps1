$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$cloud_version = "0.0.1"
$date = "2026-02-08"
docker build `
    -f ghar-win-cloud.Dockerfile `
    -t glatzel/ghar-win-cloud:latest `
    -t glatzel/ghar-win-cloud:v$cloud_version `
    -t glatzel/ghar-win-cloud:$date `
    -t glatzel/ghar-win-cloud:ltsc2025 `
    -t ghcr.io/glatzel/ghar-win-cloud:latest `
    -t ghcr.io/glatzel/ghar-win-cloud:v$cloud_version `
    -t ghcr.io/glatzel/ghar-win-cloud:$date `
    -t ghcr.io/glatzel/ghar-win-cloud:ltsc2025 `
    .

docker image ls
docker history glatzel/ghar-win-cloud:latest
if ($env:PUBLISH -eq "true") {
    docker push glatzel/ghar-win-cloud:latest
    docker push glatzel/ghar-win-cloud:v$cloud_version
    docker push glatzel/ghar-win-cloud:$date
    docker push ghcr.io/glatzel/ghar-win-cloud:latest
    docker push ghcr.io/glatzel/ghar-win-cloud:v$cloud_version
    docker push ghcr.io/glatzel/ghar-win-cloud:$date
    
}
