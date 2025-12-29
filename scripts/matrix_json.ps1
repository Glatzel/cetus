$matrix = @()
$csvData = Import-Csv "$PSScriptRoot/../images.csv"
foreach ($row in $csvData) {
    $matrix += [PSCustomObject]@{
        img     = $row.img
        machine = $row.machine
        cross   = $row.cross
    }
}
$matrix = @{ include = $matrix } | ConvertTo-Json -Depth 10 -Compress | jq '{include: .}'
# Clean CHANGED_KEYS
$env:CHANGED_KEYS = "${env:CHANGED_KEYS}".Replace("\", "")
Write-Output ${env:CHANGED_KEYS}
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
