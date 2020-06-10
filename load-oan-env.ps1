#
# File urls
#
$psOanProfileUri = ""

$fg = "Yellow"
$success = "Green"
$fail = "Red"

#
# Powershell Profile
#

$trustedDirectory = "C:\run\code\"

$psOanProfileFile = "oan-profile.ps1"
$psProfileDir = Split-Path $PROFILE
$psOanProfilePath = Join-Path -Path $psProfileDir -ChildPath $psOanProfileFile
[bool]$dotsourcingFail = $false

Write-Host -ForegroundColor $gf "Current Profile: $PROFILE"
Write-Host -ForegroundColor $fg "- Checking if dotsourcing is ok."

try {
. $PROFILE
} catch [System.Management.Automation.RuntimeException] {
  Write-Host -ForegroundColor $fail "  [DotSourcing not ok]"
}

if ($dotsourcingFail) {
    Write-Host -ForegroundColor $fg "  Using trusted directory istead ($dotsourcingFail)"
    $psOanProfilePath = Join-Path -Path $trustedDirectory -ChildPath $psOanProfileFile
} else {
    Write-Host -ForegroundColor $success "  [DotSourcing ok]"
}
Write-Host -ForegroundColor $fg "- Looking for oan-env..."

if (Test-Path $psOanProfilePath) {
    Write-Host -ForegroundColor $success "  [$psOanProfileFile Exists. Will ble updated]"
}
Write-Host -ForegroundColor $fg "  Downloading $($psOanProfileFile)..."
Invoke-WebRequest -Uri -OutFile $psOanProfilePath

Write-Host -ForegroundColor $fg "- Checking if $psOanProfile included in PROFILE"