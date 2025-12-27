$matrix = @()
$machine_map = @{
    "github-action-runner" = "ubuntu-latest"
}
ForEach ($img in Get-ChildItem $PSScriptRoot/../images) {
    $img = $img.Name
    $matrix += [PSCustomObject]@{
        image   = $img
        machine = $machine_map[$img]
    }
}


$matrix = $matrix |
ConvertTo-Json -Depth 10 -Compress |
jq '{include: [.]}'

# Clean CHANGED_KEYS
$env:CHANGED_KEYS = "${env:CHANGED_KEYS}".Replace("\", "")

switch ($env:GITHUB_EVENT_NAME) {
    "push" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.image as $p | $images | index($p)))}'
    }
    "pull_request" {
        $matrix = $matrix | jq -c --argjson images "${env:CHANGED_KEYS}" '{include: .include | map(select(.image as $p | $images | index($p)))}'
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
