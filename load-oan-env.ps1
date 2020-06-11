function Update-OanEnv() {
    [alias("Import-OanEnv")]
    $fg = "Yellow"
    $success = "Green"
    $fail = "Red"

    #
    # File urls
    #
    $psOanProfileUri = "https://raw.githubusercontent.com/turbosnute/oan-env/master/psprofile/oan-profile.ps1"
    $vscodeSnippets_uri = "https://raw.githubusercontent.com/turbosnute/oan-env/master/vscode-snippets/"

    #
    # Program Paths
    #
    $appdata = $env:APPDATA
    $vscodeSnippetsDir = Join-Path -Path $env:APPDATA -ChildPath "Code - Insiders\User\snippets"
    $vscodePath = $env:Path -split ';' | ? { $_ -match "VS Code Insiders" }
    
    #
    # VSCode Snippets
    #
    $vscodeSnippets = @(
        "powershell"
    )



    #
    # Downloading
    #
    $tempOanProfile = New-TemporaryFile
    Invoke-WebRequest -uri $psOanProfileUri -OutFile $tempOanProfile.FullName
    $oanProfileBlock = Get-Content $tempOanProfile.FullName

    if(Test-Path $vscodeSnippetsDir) {
        Write-Host -ForegroundColor $fg "VSCode Insiders Detected"
        # VSCode Alias
        if (test-path $vscodePath) {
            if (-not (test-path "$vscodePath\code")) {
                Copy-Item  "$vscodePath\code-insiders.cmd" "$vscodepath\code.cmd"
                Write-Host -ForegroundColor $success " [code alias added]"
            }
        }

        Write-Host -ForegroundColor $fg "- Downloading VSCode Snippets..."
        foreach ($snippet in $vscodeSnippets) {
            $filename = "$snippet.json"
            $uri = "$vscodeSnippets_uri/$filename"
            $outfile = Join-Path -Path $vscodeSnippetsDir -ChildPath $filename
            Invoke-WebRequest -Uri $uri -OutFile $outfile
            Write-Host -ForegroundColor $success "   [$filename]"
        }


    }


    #
    # Powershell Profile
    #

    $trustedDirectory = "C:\run\code\"

    $startIndicator = "#<OAN-ENV START>"
    $stopIndicator = "#<OAN-ENV STOP>"

    Write-Host -ForegroundColor $fg "Current Profile: $PROFILE"
    Write-Host -ForegroundColor $fg "- Looking for oan-env..."

    [bool]$psEnvEagleHasLanded = $false
    [bool]$startIndicatorReached = $false
    [bool]$stopIndicatorReached = $false
    $currentProfileText = Get-Content $PROFILE
    $newProfileText = @()

    $currentProfileText | % {
        if ($_ -eq $startIndicator) {
            $startIndicatorReached = $true
        } elseif ($_ -eq $stopIndicator) {
            $stopIndicatorReached = $true
            $startIndicatorReached = $false
        } elseif ($startIndicatorReached -eq $false) {
            $newProfileText += $_
        } else {
            #Dette bør være inni blokken
            if(-not $psEnvEagleHasLanded) {
                Write-Host -ForegroundColor Green "  [Found oan-env]"
                $newProfileText += $oanProfileBlock
                $psEnvEagleHasLanded = $true
            }
        }
    }

    if (-not $psEnvEagleHasLanded) {
        # Did not find a previous version
        Write-Host -ForegroundColor $fail "  [oan-env not found]"
        $newProfileText = $currentProfileText
        $newProfileText += $oanProfileBlock
    }

    if (-not (Test-Path $PROFILE)) {
        Write-Host -ForegroundColor $success "  [Creating $PROFILE]"
        "" | Out-File $PROFILE
    }

    $newProfileText | Out-File $PROFILE
    if($psEnvEagleHasLanded) {
        $psProfStatus = "updated"
    } else {
        $psProfStatus = "installed"
    }
    Write-Host -ForegroundColor $success "  [oan-env $psProfStatus]" 
}

Update-OanEnv