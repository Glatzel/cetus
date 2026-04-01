$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$name = "ci-win"
$images = @(
    "glatzel/$name",
    "ghcr.io/glatzel/$name"
)
$tags = @(
    "latest",
    "v0.0.1",
    "$(Get-Date -Format 'yyyy-MM-dd')"
    "ltsc2025"
)
$buildArgs = @()
foreach ($image in $images)
{
    foreach ($tag in $tags)
    {
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
