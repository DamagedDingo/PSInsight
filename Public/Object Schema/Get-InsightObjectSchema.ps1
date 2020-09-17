<#

.SYNOPSIS
Resource to find object schemas in Insight for a specific object schema. The object schemas are responded in a list.

.DESCRIPTION
Resource to find object schemas in Insight for a specific object schema. The object schemas are responded in a list.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id              : 3
name            : MyObjectSchema
objectSchemaKey : MOS
status          : Ok
description     : Object Schema
created         : 2020-09-16T00:50:30.919Z
updated         : 2020-09-16T01:56:33.430Z
objectCount     : 0
objectTypeCount : 1

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+schema

.EXAMPLE
Get-InsightObjectSchema -InsightApiKey $InsightApiKey

#>

function Get-InsightObjectSchema {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objectschema/list"
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }        

        If (!($response.objectschemas)) {
            Write-Verbose "No object schemas found"
        }
        Else {
            If($response.objectschemas){
            $response.objectschemas
            }
            else{
            $response
            }
        }
    }
}