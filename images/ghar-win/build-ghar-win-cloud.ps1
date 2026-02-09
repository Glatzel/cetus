$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$cloudVersion = "0.0.1"
$date         = "2026-02-08"

$images = @(
    "glatzel/ghar-win-cloud",
    "ghcr.io/glatzel/ghar-win-cloud"
)

$tags = @(
    "latest",
    "v$cloudVersion",
    $date,
    "ltsc2025"
)

# build args
$buildArgs = @("-f", "ghar-win-cloud.Dockerfile")

foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}

docker build @buildArgs .

docker image ls
docker history glatzel/ghar-win-cloud:latest

if ($env:PUBLISH -eq "true") {
    foreach ($image in $images) {
        foreach ($tag in $tags | Where-Object { $_ -ne "ltsc2025" }) {
            docker push "$image`:$tag"
        }
    }
}
