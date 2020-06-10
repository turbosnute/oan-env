#
# File urls
#
$psOanProfileUri = "https://raw.githubusercontent.com/turbosnute/oan-env/master/psprofile/oan-profile.ps1"


#
# Downloading
#
$tempOanProfile = New-TemporaryFile
Invoke-WebRequest -uri $psOanProfileUri -OutFile $tempOanProfile.FullName
$oanProfileBlock = Get-Content $tempOanProfile.FullName

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

$startIndicator = "#<OAN-ENV START>"
$stopIndicator = "#<OAN-ENV STOP>"

Write-Host -ForegroundColor $gf "Current Profile: $PROFILE"
Write-Host -ForegroundColor $fg "- Looking for oan-env..."

[bool]$psEnvEagleHasLanded = $false
[bool]$startIndicatorReached = $false
[bool]$stopIndicatorReached = $false
$currentProfileText = Get-Content $PROFILE
$newProfileText = @()

$currentProfileText | % {
    if ($_ -eq $startIndicator) {
        $newProfileText += $_
        $startIndicatorReached = $true
        write-host -ForegroundColor cyan $_
    } elseif ($_ -eq $stopIndicator) {
        $newProfileText += $_
        $stopIndicatorReached = $true
        $startIndicatorReached = $false
        write-host -ForegroundColor cyan $_
    } elseif ($startIndicatorReached -eq $false) {
        $newProfileText += $_
        Write-Host $_
    } else {
        #Dette bør være inni blokken
        if(-not $psEnvEagleHasLanded) {
            Write-Host -ForegroundColor Green "  [Found oan-env...]"
            $newProfileText += $oanProfileBlock
            Write-Host -ForegroundColor Green "  [Updated]"
            $psEnvEagleHasLanded = $true
        }
    }
}

Write-Host -ForegroundColor $fg "- Checking if $psOanProfile included in PROFILE"