<#

.SYNOPSIS
Generate Insight headers.
.EXAMPLE
$Headers = New-ZoomHeaders -ApiKey $ApiKey
.OUTPUTS
Generic dictionary.

#>

function New-InsightHeaders {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ApiKey
    )

    Write-Verbose 'Generating Headers'
    $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Headers.Add('content-type' , 'application/json')
    $Headers.Add('authorization', 'bearer ' + $ApiKey)

    Write-Output $Headers
}
