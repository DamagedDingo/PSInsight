<#

.SYNOPSIS
Removes a status.
.EXAMPLE
Remove-InsightObjectTypes -ID 8 -InsightApiKey $InsightApiKey
.OUTPUTS
.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Statuses

#>


function Remove-InsightObjectTypes {
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

