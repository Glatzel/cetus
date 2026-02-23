$matrix = @()
foreach ($item in (Get-Content $PSScriptRoot/../image.csv | ConvertFrom-Csv)) {
    ForEach ($name in $item.name) {
        $matrix += [PSCustomObject]@{
            name    = $name
            machine = $item.machine
            cross   = $item.cross
        }
    }
}
$matrix = @{ include = $matrix } | ConvertTo-Json -Depth 10 -Compress | jq '.'
# Clean CHANGED_KEYS
$env:CHANGED_KEYS = "${env:CHANGED_KEYS}".Replace("\", "")
switch ($env:GITHUB_EVENT_NAME) {
    "push" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.name as $p | $images | index($p)))}'
    }
    "pull_request" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.name as $p | $images | index($p)))}'
    }
    default {
        $matrix = $matrix
    }
}
if ($($matrix | jq '.include | length == 0') -eq 'true') {
    $matrix = $null
}
# Output matrix to GitHub Actions
"matrix=$matrix" >> $env:GITHUB_OUTPUT

Write-Output "::group::json"
$matrix | jq .
Write-Output "::endgroup::"
