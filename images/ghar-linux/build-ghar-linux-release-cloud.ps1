$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
& ./build-pixi-base.ps1
$tags = @(
    "latest",
    "alma8",
    "v0.1.2",
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$images = @(
    "glatzel/ghar-linux-release-cloud",
    "ghcr.io/glatzel/ghar-linux-release-cloud"
)
$buildArgs = @(
    "build",
    "--platform", "linux/amd64,linux/arm64",
    "-f", "./ghar-linux-release-cloud.Dockerfile"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
