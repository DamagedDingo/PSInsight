<#

.SYNOPSIS
Resource to find Object Type Attributes for a specified Object Type in Insight.

.DESCRIPTION
Resource to find Object Type Attributes for a specified Object Type in Insight.

.PARAMETER ID
The Object Type ID.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id                      : 7
objectType              : @{id=2; name=My Object Type; type=0; description=A Sample Object Type; icon=; position=0; created=2020-09-16T07:14:02.118Z; updated=2020-09-16T07:14:02.118Z; objectCount=0; objectSchemaId=3; inherited=False; 
                          abstractObjectType=False; parentObjectTypeInherited=False}
name                    : Key
label                   : False
type                    : 0
defaultType             : @{id=0; name=Text}
editable                : False
system                  : True
sortable                : True
summable                : False
indexed                 : True
minimumCardinality      : 1
maximumCardinality      : 1
removable               : False
hidden                  : False
includeChildObjectTypes : False
uniqueAttribute         : False
options                 : 
position                : 0

id                      : 8
objectType              : @{id=2; name=My Object Type; type=0; description=A Sample Object Type; icon=; position=0; created=2020-09-16T07:14:02.118Z; updated=2020-09-16T07:14:02.118Z; objectCount=0; objectSchemaId=3; inherited=False; 
                          abstractObjectType=False; parentObjectTypeInherited=False}
name                    : Name
label                   : True
type                    : 0
description             : The name of the object
defaultType             : @{id=0; name=Text}
editable                : True
system                  : False
sortable                : True
summable                : False
indexed                 : True
minimumCardinality      : 1
maximumCardinality      : 1
removable               : False
hidden                  : False
includeChildObjectTypes : False
uniqueAttribute         : False
options                 : 
position                : 1

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+type+attributes

.EXAMPLE
Get-InsightObjectTypeAttributes -ID 2 -InsightApiKey $InsightApiKey

#>

function Get-InsightObjectTypeAttributes {
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
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttype/$($ID)/attributes"
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

