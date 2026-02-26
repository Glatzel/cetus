$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$tags = @(
    "latest"
    "ubuntu-24.04"
    "v0.0.6"
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$images = @(
    "glatzel/ghar-linux-dev-local",
    "ghcr.io/glatzel/ghar-linux-dev-local"
)
$buildArgs = @(
    "buildx", "build",
    $pushFlag,
    "--platform", "linux/amd64,linux/arm64",
    "--target", "dev-local"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
