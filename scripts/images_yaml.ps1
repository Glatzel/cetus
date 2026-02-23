$yamlFile = "$PSScriptRoot/../images.yaml"
Set-Content -Path $yamlFile -Value ""
ForEach ($item in (Get-Content $PSScriptRoot/../image.csv | ConvertFrom-Csv)) {
    ForEach ($name in $item.name) {
        "$name`:">>$yamlFile
        "  - ./images/$name/**">>$yamlFile
    }
}

# Print the exact contents of the YAML file
Write-Output "::group::yaml"
Get-Content $yamlFile | ForEach-Object { Write-Host $_ }
Write-Output "::endgroup::"
