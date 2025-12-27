$matrix = @()
$csvData = Import-Csv "$PSScriptRoot/../images.csv"
foreach ($row in $csvData) {
    $img = $row.img
    foreach ($machine in "windows-latest", "macos-latest", "ubuntu-latest", "ubuntu-24.04-arm") {
        if ($row.$machine -eq "true") {
            $matrix += [PSCustomObject]@{
                img     = $img
                machine = $machine
            }
        }
    }
}


$matrix = $matrix | ConvertTo-Json -Depth 10 -Compress | jq '{include: .}'
# Clean CHANGED_KEYS
$env:CHANGED_KEYS = "${env:CHANGED_KEYS}".Replace("\", "")
switch ($env:GITHUB_EVENT_NAME) {
    "push" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.img as $p | $images | index($p)))}'
    }
    "pull_request" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.img as $p | $images | index($p)))}'
    }
    default {
        $matrix = $matrix
    }
}

# Output matrix to GitHub Actions
"matrix=$matrix" >> $env:GITHUB_OUTPUT

Write-Output "::group::json"
$matrix | jq .
Write-Output "::endgroup::"
