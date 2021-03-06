function New-InsightObjectTypes {
    <#

.SYNOPSIS
Resource to create an object type in Insight.

.DESCRIPTION
Resource to create an object type in Insight.

.PARAMETER Name
The object type name.

.PARAMETER Description
The object type description.

.PARAMETER IconID
The object type icon ID.

.PARAMETER ParentObjectTypeID
The parent object type id that new child object will be placed in

.PARAMETER objectSchemaId
The object schema id

.PARAMETER inherited
The object schema id

.PARAMETER abstractObjectType
Set to true to stop CI's from being created at this level (parent)

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id                        : 1
name                      : My Object Type
type                      : 0
description               : A Sample Object Type
icon                      : @{id=1; name=3D Printer; url16=/rest/insight/1.0/objecttype/1/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2
                            lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29t
                            LnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTAxMiwiZXhwIjoxNjAwMjMxMTkyLCJpYXQiOjE2MDAyMzEwMTJ9.oHQ6uHuginJCihoHT2YdSqPMBzgWD
                            KpwZmVoBtlPqY0; url48=/rest/insight/1.0/objecttype/1/icon.png?size=48&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnN
                            pZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhb
                            GFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTAxMiwiZXhwIjoxNjAwMjMxMTkyLCJpYXQiOjE2MDAyMzEwMTJ9.oHQ6uHuginJCihoHT2YdSqPMBzgWDKpwZmVoBt
                            lPqY0}
position                  : 0
created                   : 2020-09-16T04:36:52.885Z
updated                   : 2020-09-16T04:36:52.885Z
objectCount               : 0
objectSchemaId            : 3
inherited                 : False
abstractObjectType        : False
parentObjectTypeInherited : False

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+types

.EXAMPLE
New-InsightObjectTypes -Name "My Object Type" -Description "A Sample Object Type" -IconID 1 -objectSchemaId 3 -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        $IconID,

        [Parameter(Mandatory = $false)]
        $parentObjectTypeId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        $objectSchemaId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('true','false')]
        $inherited,

        [Parameter(Mandatory = $false)]
        [ValidateSet('true','false')]
        $abstractObjectType,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttype/create"

        $RequestBody = @{
            'name'           = $Name
            'iconId'         = $iconId
            'objectSchemaId' = $objectSchemaId
        }
        If ($Description) {
            $RequestBody.Add('description', $Description)
        }
        If ($parentObjectTypeId) {
            $RequestBody.Add('parentObjectTypeId', $parentObjectTypeId)
        }
        If ($inherited) {
            $RequestBody.Add('inherited', $inherited)
        }
        If ($abstractObjectType) {
            $RequestBody.Add('abstractObjectType', $abstractObjectType)
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
