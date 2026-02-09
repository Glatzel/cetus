$yamlFile = "$PSScriptRoot/../images.yaml"
Set-Content -Path $yamlFile -Value ""
ForEach ($item in (Get-Content $PSScriptRoot/../image.json | ConvertFrom-Json)) {
    ForEach ($name in $item.name) {
        $folder = $item.folder
        "$name`:">>$yamlFile
        "  - ./images/$folder/**">>$yamlFile
        ForEach ($n in $item.name) {
            if ($n -ne $name) {
                "  - '!./images/$folder/**/build-$n.ps1'">>$yamlFile
                "  - '!./images/$folder/**/$n.Dockerfile'">>$yamlFile
            }
        }
    }
}

# Print the exact contents of the YAML file
Write-Output "::group::yaml"
Get-Content $yamlFile | ForEach-Object { Write-Host $_ }
Write-Output "::endgroup::"
