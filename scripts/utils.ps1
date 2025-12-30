$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true
$pushFlag = if ($env:PUBLISH -eq "true") { "--push" } else { $null }
