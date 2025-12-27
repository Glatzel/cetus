$csvFile = "$PSScriptRoot/../images.csv"
$yamlFile = "$PSScriptRoot/../images.yaml"
Set-Content -Path $yamlFile -Value ""
# Read CSV
$csvData = Import-Csv $csvFile
ForEach ($Row in $csvData) {
    $img = $Row.img
    "${img}:">>$yamlFile
    "  - ./images/$img/**">>$yamlFile
}

# Print the exact contents of the YAML file
Write-Output "::group::yaml"
Get-Content $yamlFile
Write-Output "::endgroup::"
