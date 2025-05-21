Set-Location $PSScriptRoot
docker-compose `
-f ./docker-compose.ftp.yml `
up -d
