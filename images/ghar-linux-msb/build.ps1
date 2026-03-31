$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$tags = @(
    "latest"
    "debian-13"
    "v0.0.1"
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$images = @(
    "glatzel/ghar-linux-msb",
    "ghcr.io/glatzel/ghar-linux-msb"
)
$buildArgs = @(
    "buildx", "build",
    $pushFlag,
    "--platform", "linux/amd64,linux/arm64",
    "--target", "msb"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
