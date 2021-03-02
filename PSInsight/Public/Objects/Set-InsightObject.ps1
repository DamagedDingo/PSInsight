function Set-InsightObject {
    <#

.SYNOPSIS
Resource to update an object in Insight.

.DESCRIPTION
Resource to update an object in Insight.

.PARAMETER ID
The ID

.PARAMETER Attributes
An array of attributes. colelcted from New-InsightObjectAttributes

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+schema

.EXAMPLE

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [array]$Attributes,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/object/$($ID)"

        $RequestBody = @{
            'objectTypeId' = $objectTypeId
            'attributes'   = @($attributes)
            }
            
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 20
        $RequestBody
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method PUT
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }
        
        Write-Output $response
        }
}
