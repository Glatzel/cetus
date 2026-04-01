$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$name = "ci-linux-release"
$tags = @(
    "latest",
    "alma8",
    "v0.3.0",
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
    "--target", "release-cloud"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
