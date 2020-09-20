<#

.SYNOPSIS
Resource to delete an object schema in Insight.

.DESCRIPTION
Resource to delete an object schema in Insight.

.PARAMETER ID
The object schema ID.

.PARAMETER InsightApiKey
The Api key.

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

.EXAMPLE
Remove-InsightObjectSchema -ID 1 -InsightApiKey $InsightApiKey

#>

function Remove-InsightObjectSchema {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
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