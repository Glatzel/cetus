$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$runnerVersion = "2.331.0"
$images = @(
    "glatzel/ghar-win-local",
    "ghcr.io/glatzel/ghar-win-local"
)
$tags = @(
    "latest"
    "v0.0.1"
    "runner-${runnerVersion}"
    "$(Get-Date -Format 'yyyy-MM-dd')"
    "ltsc2025"
)

docker build `
    -f ./ghar-win-cloud.Dockerfile `
    .

$buildArgs = @(
    "--build-arg", "RUNNER_VERSION=$runnerVersion",
    "-f", "./ghar-win-local.Dockerfile"
)

foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}

docker build @buildArgs .

docker image ls
docker history glatzel/ghar-win-local:latest

if ($env:PUBLISH -eq "true") {
    foreach ($image in $images) {
        foreach ($tag in $tags) {
            docker push "$image`:$tag"
        }
    }
}
