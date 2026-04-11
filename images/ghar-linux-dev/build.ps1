$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$name = "ghar-linux-dev"
$tags = @(
    "latest"
    "ubuntu-24.04"
    "v0.1.1"
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
$images = @(
    "glatzel/$name",
    "ghcr.io/glatzel/$name"
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
