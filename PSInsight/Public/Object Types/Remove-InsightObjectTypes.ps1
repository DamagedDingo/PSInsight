function Remove-InsightObjectTypes {
    <#

.SYNOPSIS
Resource to delete an object type in Insight.

.DESCRIPTION
Resource to delete an object type in Insight.

.PARAMETER ID
The Object Type ID.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id                        : 1
name                      : My Object Type
type                      : 0
description               : A Sample Object Type
icon                      : @{id=1; name=3D Printer; url16=/rest/insight/1.0/objecttype/1/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2
                            lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29t
                            LnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDI0MDIwNiwiZXhwIjoxNjAwMjQwMzg2LCJpYXQiOjE2MDAyNDAyMDZ9.fOtVat8TB9dOkl-8EWw4z1ztqCBtD
                            LFNeKXi6PjFcW0; url48=/rest/insight/1.0/objecttype/1/icon.png?size=48&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnN
                            pZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhb
                            GFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDI0MDIwNiwiZXhwIjoxNjAwMjQwMzg2LCJpYXQiOjE2MDAyNDAyMDZ9.fOtVat8TB9dOkl-8EWw4z1ztqCBtDLFNeKXi6P
                            jFcW0}
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
Remove-InsightObjectTypes -id 1 -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttype/$($ID)"
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method DELETE
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        } 

        $response
    }
}

