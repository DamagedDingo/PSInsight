<#

.SYNOPSIS
Creates a new object schema
.EXAMPLE
New-InsightObjectSchema -Name "MyObjectSchema" -ObjectSchemaKey "NAS" -Description "My New Object Schema" -InsightApiKey $InsightApiKey
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


function New-InsightObjectSchema {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ObjectSchemaKey,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objectschema/create"

        $RequestBody = @{
            'name'              = $Name
            'objectSchemaKey'   = $ObjectSchemaKey
            }
            $RequestBody.Add('description',$Description)
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 1
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method POST
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }
        
        Write-Output $response
        }
}