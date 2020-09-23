function Set-InsightObjectTypes {
    <#

.SYNOPSIS
Resource to create an object type in Insight.

.DESCRIPTION
Resource to create an object type in Insight.

.PARAMETER ID
The object type ID.

.PARAMETER Name
The status Name.

.PARAMETER Description
The object type Description.

.PARAMETER IconID
The object type IconID (Can be collected via Get-InsightIcons).

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id                        : 1
name                      : My Object Type
type                      : 0
description               : A Sample Object Type - Updated
icon                      : @{id=1; name=3D Printer; url16=/rest/insight/1.0/objecttype/1/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2
                            lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29t
                            LnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTg0NSwiZXhwIjoxNjAwMjMyMDI1LCJpYXQiOjE2MDAyMzE4NDV9.kOqWqYE7nswEI7WZql7i3pOPp2MM8
                            frWlgwx9fB5GNI; url48=/rest/insight/1.0/objecttype/1/icon.png?size=48&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnN
                            pZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhb
                            GFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTg0NSwiZXhwIjoxNjAwMjMyMDI1LCJpYXQiOjE2MDAyMzE4NDV9.kOqWqYE7nswEI7WZql7i3pOPp2MM8frWlgwx9f
                            B5GNI}
position                  : 0
created                   : 2020-09-16T04:36:52.885Z
updated                   : 2020-09-16T04:50:45.458Z
objectCount               : 0
objectSchemaId            : 3
inherited                 : False
abstractObjectType        : False
parentObjectTypeInherited : False

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+types

.EXAMPLE
Set-InsightObjectTypes -ID 1 -Name "My Object Type" -Description "A Sample Object Type - Updated" -IconID 1 -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $True)]
        [int]$ID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$IconID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttype/$($ID)"

        $RequestBody = @{
            'name'           = $Name
            'iconId'         = $iconId
        }
        If ($Description) {
            $RequestBody.Add('description', $Description)
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

