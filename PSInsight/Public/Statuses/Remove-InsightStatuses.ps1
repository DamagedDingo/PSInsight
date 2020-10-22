function Remove-InsightObjectTypes {
    <#

.SYNOPSIS
Resource to delete a status in Insight.

.DESCRIPTION
Resource to delete a status in Insight.

.PARAMETER ID
The status ID.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
No output from API

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Statuses

.EXAMPLE
Remove-InsightObjectTypes -ID 8 -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/config/statustype/$($ID)"
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

