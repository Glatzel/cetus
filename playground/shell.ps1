param(
    [ValidateSet("pwsh", "bash")]
    $Shell = "pwsh"
)

Set-Location $PSScriptRoot

# Ensure share directory exists
if (-not (Test-Path "$PSScriptRoot/share")) {
    New-Item -ItemType Directory -Path "$PSScriptRoot/share" | Out-Null
}

$exists = docker ps -a --filter "name=playground" --format "{{.Names}}"

if (-not $exists) {
    docker compose up -d
    docker exec -it -w /root/share playground $Shell
} else {
    $running = docker ps --filter "name=playground" --format "{{.Names}}"
    if (-not $running) {
        docker start playground | Out-Null
    }
    docker exec -it -w /root/share playground $Shell
}