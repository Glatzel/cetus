$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Get-Content "./pixi-base.Dockerfile" > Dockerfile
Get-Content "./ghar-linux-release-local.Dockerfile" >> Dockerfile
$runnerVersion = "2.331.0"
$tags = @(
    "latest"
    "alma8"
    "v0.0.6"
    "runner-${runnerVersion}"
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
    "--build-arg", "RUNNER_VERSION=$runnerVersion",
    "--target", "release-local"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
