$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$name = "ghar-houdini"
$env:HOUDINI_VERSION="22.0.368"
$tags = @(
    "latest"
    "ubuntu-26.04"
    "v$env:HOUDINI_VERSION"
    "$(Get-Date -Format 'yyyy-MM-dd')"
)
$images = @(
    "glatzel/$name",
    "ghcr.io/glatzel/$name"
)
$buildArgs = @(
    "--target", "dev-local"
    "--build-arg", "HOUDINI_VERSION=$env:HOUDINI_VERSION"
    "--build-arg", "SIDEFX_CLIENT_ID=$env:SIDEFX_CLIENT_ID"
    "--build-arg", "SIDEFX_CLIENT_SECRET=$env:SIDEFX_CLIENT_SECRET"
)
foreach ($image in $images) {
    foreach ($tag in $tags) {
        $buildArgs += "-t"
        $buildArgs += "$image`:$tag"
    }
}
docker build @buildArgs .
docker image ls
docker history "glatzel/$name`:latest"
if ($env:PUBLISH -eq "true")
{
    foreach ($image in $images)
    {
        foreach ($tag in $tags)
        {
            docker push "$image`:$tag"
        }
    }
}
