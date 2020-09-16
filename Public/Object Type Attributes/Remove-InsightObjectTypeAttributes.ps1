<#

.SYNOPSIS
Removes a new object type attribute.
.EXAMPLE
Remove-InsightObjectTypeAttributes -ID 11 -InsightApiKey $InsightApiKey
.OUTPUTS

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+type+attributes

#>


function Remove-InsightObjectTypeAttributes {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttypeattribute/$($ID)"
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method DELETE
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        } 

        $response
    }
}

