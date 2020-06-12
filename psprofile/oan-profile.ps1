#<OAN-ENV START>
# -----------------------------------------------------
# - FUNCTIONS -----------------------------------------
# -----------------------------------------------------

<#
.SYNOPSIS
    Super simple function to grep from text.
.DESCRIPTION
    Super simple function to grep from text.
.LINK
    https://github.com/turbosnute
.EXAMPLE
    PS> Get-Content .\logfile.txt | grep "EVENT"
    03/22 08:52:50 TRACE  :......rsvp_event_mapSession: Session=9.67.116.99:1047:6 does not exist
    03/22 08:52:50 EVENT  :.....api_reader: api request SESSION
    03/22 08:52:50 TRACE  :......rsvp_event_establishSession: local node will send
    03/22 08:52:50 TRACE  :.......event_establishSessionSend: found outgoing if=9.67.116.98 through
    03/22 08:52:50 TRACE  :......rsvp_event_mapSession: Session=9.67.116.99:1047:6 exists
    03/22 08:52:50 EVENT  :.....api_reader: api request SENDER
.EXAMPLE
    # For Case Sensitive match use -c (or -CaseSensitive).
    PS> Get-Content .\logfile.txt | grep "EVENT"
    3/22 08:52:50 EVENT  :.....api_reader: api request SESSION
    03/22 08:52:50 EVENT  :.....api_reader: api request SENDER
.EXAMPLE
    PS> ps | grep "explorer"
    System.Diagnostics.Process (explorer)
#>
function Get-Grep {
    [CmdletBinding()]
    [OutputType([string])]
    [alias("grep")]
    param(
        [Parameter(ValueFromPipeline=$true)][string]$Haystack,
        [Parameter(Mandatory=$true,Position=0)][string]$Needle,
        [Parameter()][switch][Alias('c')]$CaseSensitive
    )
    
    process {
        if($null -ne $Haystack) {
            if($CaseSensitive) {
                $Haystack | Where-Object { $_ -cmatch $Needle }
            } else {
                $Haystack | Where-Object { $_ -match $Needle }
            }
        }

    } 
}

<#
.SYNOPSIS
    Returns your wan IP.
.DESCRIPTION
    Returns your wan IP.
.EXAMPLE
    PS> Get-WanIp
    123.123.123.123

#>
function Get-WanIp {
    [CmdletBinding()]
    [OutputType([string])]
    [alias("wanip")]
    param()
    
    begin {
    }
    
    process {
        Invoke-RestMethod http://ifconfig.me/ip
    }
    
    end {
    }
}
#<OAN-ENV STOP>