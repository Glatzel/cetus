param(
    [ValidateSet("pwsh", "bash")]
    $Shell = "pwsh"
)
Set-Location $PSScriptRoot
$current_dir = "$PSScriptRoot".Replace("\", "/")
$exists = docker ps -a --filter "name=playground" --format "{{.Names}}"
if (-not $exists) {
    docker run -it -w /root/share -v $current_dir/share:/root/share --name playground glatzel/dev-container:latest $shell
}
else {
    docker start playground
    docker exec -it -w /root/share playground $Shell
}
