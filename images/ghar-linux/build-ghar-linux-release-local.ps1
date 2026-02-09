$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

& ./build-pixi-base.ps1
$runnerVersion = "2.331.0"
$tags = @(
    "latest"
    "alma8"
    "v0.0.5"
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
    "-f", "./ghar-linux-release-local.Dockerfile"
)

foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}

docker @buildArgs .
