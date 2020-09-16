<#

.SYNOPSIS
Get Insight statuses.
.EXAMPLE
Get-InsightObjectTypes -InsightApiKey $InsightApiKey
.OUTPUTS
id name              description category
-- ----              ----------- --------
 1 Action Needed                        2
 2 Active                               1
 3 Closed                               0
 4 In Service                           2
 5 Running                              1
 6 Stopped                              0
 7 Support Requested                    2
.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Statuses

#>

function Get-InsightObjectTypes {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/config/statustype"
    }
    
    end {
        try {
                $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
            }
            catch {
                Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
            } 

            $response
    }
}