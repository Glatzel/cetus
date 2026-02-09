$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

& ./build-pixi-base.ps1

$localVersion  = "0.0.5"
$runnerVersion = "2.331.0"
$date          = "2026-02-08"

$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }

$images = @(
    "glatzel/ghar-linux-dev-local",
    "ghcr.io/glatzel/ghar-linux-dev-local"
)

$versionTag = "v${localVersion}-runner-${runnerVersion}"

$tags = @(
    "latest",
    "ubuntu-24.04",
    $versionTag,
    $date
)

$buildArgs = @(
    "buildx", "build",
    $pushFlag,
    "--platform", "linux/amd64,linux/arm64",
    "--build-arg", "RUNNER_VERSION=$runnerVersion",
    "-f", "./ghar-linux-dev-local.Dockerfile"
)

foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}

docker @buildArgs .
