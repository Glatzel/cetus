$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
Get-Content "./pixi-base.Dockerfile" > Dockerfile
Get-Content "./dev-local.Dockerfile" >> Dockerfile
$runnerVersion = "2.331.0"
$tags = @(
    "latest"
    "ubuntu-24.04"
    "v0.0.5"
    "runner-${runnerVersion}"
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
    "--build-arg", "RUNNER_VERSION=$runnerVersion",
    "--target", "dev-local"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker @buildArgs .
