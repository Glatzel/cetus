# Output YAML
$yamlFile = "$PSScriptRoot/../images.yaml"
Set-Content -Path $yamlFile -Value ""
ForEach ($img in Get-ChildItem $PSScriptRoot/../images) {
    $img=$img.Name
    "${img}:">>$yamlFile
    "  - ./images/$img/**">>$yamlFile
}

# Print the exact contents of the YAML file
Write-Output "::group::yaml"
Get-Content $yamlFile | ForEach-Object { Write-Host $_ }
Write-Output "::endgroup::"
