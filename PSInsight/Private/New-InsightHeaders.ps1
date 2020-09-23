

function New-InsightHeaders {
    <#

.SYNOPSIS
Generate Insight headers.
.EXAMPLE
$Headers = New-InsightHeaders -ApiKey $InsightApiKey
.OUTPUTS
Generic dictionary.

#>
    param (
        [Parameter(Mandatory = $true)]
        [string]$InsightApiKey
    )

    Write-Verbose 'Generating Headers'
    $Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Headers.Add('content-type' , 'application/json')
    $Headers.Add('authorization', 'bearer ' + $InsightApiKey)

    Write-Output $Headers
}
