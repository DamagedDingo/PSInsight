<#

.SYNOPSIS
Removes a object schema
.EXAMPLE
Remove-InsightObjectSchema -ID 1 -InsightApiKey $InsightApiKey
.OUTPUTS
id              : 1
name            : CMDB
objectSchemaKey : ABC
status          : Ok
description     : My Object Schema
created         : 2020-09-16T00:22:31.948Z
updated         : 2020-09-16T00:22:31.963Z
objectCount     : 0
objectTypeCount : 0
.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+schema

#>


function Remove-InsightObjectSchema {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ID,

        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objectschema/$($ID)"

    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method Delete
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }
        
        Write-Output $response
        }
}