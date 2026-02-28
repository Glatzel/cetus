$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$tags = @(
    "latest"
    "alma8"
    "v0.0.7"
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$images = @(
    "glatzel/ghar-linux-release-local",
    "ghcr.io/glatzel/ghar-linux-release-local"
)
$buildArgs = @(
    "buildx", "build",
    $pushFlag,
    "--platform", "linux/amd64,linux/arm64",
    "--target", "release-local"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
