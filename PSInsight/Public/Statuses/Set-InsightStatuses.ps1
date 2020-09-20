<#

.SYNOPSIS
Resource to update a status in Insight.

.DESCRIPTION
Resource to update a status in Insight.

.PARAMETER ID
The status ID.

.PARAMETER Name
The status name.

.PARAMETER Description
The status description

.PARAMETER Category
The status category.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id name          description             category
-- ----          -----------             --------
 8 My New Status Sample Status - Updated        1

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Statuses

.EXAMPLE
Set-InsightStatuses -ID 8 -Name "My New Status" -Description "Sample Status - Updated" -category Active -InsightApiKey $InsightApiKey

#>

function Set-InsightStatuses {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [Validateset("Inactive","Active","Pending")]
        [String]$Category,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey

        switch ($category) {
            "Inactive" { $CategoryID = 0 }
            "Active" { $CategoryID = 1 }
            "Pending" { $CategoryID = 2 }
}
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/config/statustype/$($ID)"

        $RequestBody = @{
            'name'           = $Name
            'description'    = $Description
            'category'       = $CategoryID
        }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 1
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method PUT
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        } 

        $response
    }
}
