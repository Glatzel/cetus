$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$images = @(
    "glatzel/ghar-win-cloud",
    "ghcr.io/glatzel/ghar-win-cloud"
)
$tags = @(
    "latest",
    "v0.0.3",
     "$(Get-Date -Format 'yyyy-MM-dd')"
    "ltsc2025"
)
$buildArgs = @()
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
        foreach ($tag in $tags) {
            docker push "$image`:$tag"
        }
    }
}
