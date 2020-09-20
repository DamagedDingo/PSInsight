<#

.SYNOPSIS
Resource to delete an object type attribute in Insight.

.DESCRIPTION
Resource to delete an object type attribute in Insight.

.PARAMETER ID
The Object Type Attribute ID.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
No output from API

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+type+attributes

.EXAMPLE
Remove-InsightObjectTypeAttributes -ID 11 -InsightApiKey $InsightApiKey

#>

function Remove-InsightObjectTypeAttributes {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
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

