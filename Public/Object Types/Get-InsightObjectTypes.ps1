<#

.SYNOPSIS
Get object types.
.EXAMPLE
Get-InsightObjectTypes -ID 3 -InsightApiKey $InsightApiKey
.OUTPUTS
id                        : 1
name                      : My Object Type
type                      : 0
description               : A Sample Object Type
icon                      : @{id=1; name=3D Printer; url16=/rest/insight/1.0/objecttype/1/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2
                            lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29t
                            LnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTE0MiwiZXhwIjoxNjAwMjMxMzIyLCJpYXQiOjE2MDAyMzExNDJ9.ZSNwmE7YTLck4rePYy_eovn5c6PsG
                            _5S8PsXOQ7KjJ0; url48=/rest/insight/1.0/objecttype/1/icon.png?size=48&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnN
                            pZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhb
                            GFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDIzMTE0MiwiZXhwIjoxNjAwMjMxMzIyLCJpYXQiOjE2MDAyMzExNDJ9.ZSNwmE7YTLck4rePYy_eovn5c6PsG_5S8PsXOQ
                            7KjJ0}
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

#>

function Get-InsightObjectTypes {
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
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objectschema/$($ID)/objecttypes/flat"
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