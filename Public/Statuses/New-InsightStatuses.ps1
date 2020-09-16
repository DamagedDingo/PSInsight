<#

.SYNOPSIS
Creates a new status.
.EXAMPLE
New-InsightStatuses -Name "My New Status" -Description "Sample Status" -category Active -InsightApiKey $InsightApiKey
.OUTPUTS
id name          description   category
-- ----          -----------   --------
 8 My New Status Sample Status        1
.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Statuses

#>


function New-InsightStatuses {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [Validateset("Inactive","Active","Pending")]
        [String]$category,

        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey

        switch ($category) {
            "Inactive" { $CategoryID = 0 }
            "Active" { $CategoryID = 1 }
            "Pending" { $CategoryID = 2 }
}
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/config/statustype"

        $RequestBody = @{
            'name'           = $Name
            'description'    = $Description
            'category'       = $CategoryID
        }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 1
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method POST
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        } 

        $response
    }
}
