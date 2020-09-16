<#

.SYNOPSIS
Get avalible Insight Icons and there corrisponding ID.
.EXAMPLE
$Headers = Get-InsightIcons -InsightApiKey $InsightApiKey
.OUTPUTS
Something something.
.LINK
https://documentation.mindville.com/display/ICV811/Icons+-+REST

#>


function Get-InsightIcons {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey,

        [switch]$Full = $False
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/icon/global"
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }

        if ($Full) {
            Write-Output $response
        }
        else {
            Write-Output $response | Select id,name
        }
    }
}