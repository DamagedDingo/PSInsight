function New-InsightObject {
    <#

.SYNOPSIS
Resource to create object in Insight.

.DESCRIPTION
Resource to create object in Insight.

.PARAMETER objectTypeId
The Object Type ID

.PARAMETER attributes
An Array of parameters built via 'New-InsightObjectAttribute'

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id         : 5
label      : Test name
objectKey  : ABC-5
avatar     : @{url16=/rest/insight/1.0/objecttype/2/icon.png?size=16&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOi
             JIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6d
             HJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdod
             CIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDMxNDk2MywiZXhwIjoxNjAwMzE1MTQzLCJpYXQiOjE2MDAzMTQ5NjN9.vzQiy3zF1cgjWFBeymAv1Q6lU0dk-Ewv6kuE
             7Gh0ins; url48=/rest/insight/1.0/objecttype/2/icon.png?size=48&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJ
             hbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaW
             dodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiw...; objectId=5}
objectType : @{id=2; name=My Object Type; type=0; description=A Sample Object Type; icon=; position=0; created=2020-09-16T07:14:02.118Z; 
             updated=2020-09-16T07:14:02.118Z; objectCount=0; objectSchemaId=3; inherited=False; abstractObjectType=False; 
             parentObjectTypeInherited=False}
created    : 2020-09-17T03:56:04.262Z
updated    : 2020-09-17T03:56:04.262Z
hasAvatar  : False
timestamp  : 1600314964262
_links     : @{self=/secure/ShowObject.jspa?id=5}
name       : Test name

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Objects

.EXAMPLE
New-InsightObject -objectTypeId 2 -attributes $array -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$objectTypeId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true,valuefrompipelinebypropertyname = $true)]
        [array]$attributes,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/object/create"

        $RequestBody = @{
            'objectTypeId' = $objectTypeId
            'attributes'   = @($attributes)
            }
            
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 20
        $RequestBody
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

