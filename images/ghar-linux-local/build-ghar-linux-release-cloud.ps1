$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Get-Content "./pixi-base.Dockerfile" > Dockerfile
Get-Content "./ghar-linux-release-cloud.Dockerfile" >> Dockerfile
$tags = @(
    "latest",
    "alma8",
    "v0.1.2",
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$images = @(
    "glatzel/ghar-linux-release-cloud",
    "ghcr.io/glatzel/ghar-linux-release-cloud"
)
$buildArgs = @(
    "buildx", "build",
    $pushFlag,
    "--platform", "linux/amd64,linux/arm64",
    "--target", "release-cloud"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
