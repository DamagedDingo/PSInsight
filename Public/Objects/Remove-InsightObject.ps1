<#

.SYNOPSIS
Resource to delete an object in Insight.

.DESCRIPTION
Resource to delete an object in Insight.

.PARAMETER ID
The object ID. Takes a string of the ID or objectKey

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id           : 3
label        : MyObject
objectKey    : ABC-3
avatar       : @{url16=/rest/insight/1.0/objecttype/2/icon.png?size=16&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiw
               iaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDMwNjg5OCwiZXhwIjoxNjAwMzA3MDc4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-Q
               vW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; url48=/rest/insight/1.0/objecttype/2/icon.png?size=48&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoi
               NWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDMwNjg5OCwiZXhwIjoxNjAwMzA3MD
               c4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-QvW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; url72=/rest/insight/1.0/objecttype/2/icon.png?size=72&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppc
               mEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI
               6MTYwMDMwNjg5OCwiZXhwIjoxNjAwMzA3MDc4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-QvW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; url144=/rest/insight/1.0/objecttype/2/icon.png?size=144&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1N
               iJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW
               5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDMwNjg5OCwiZXhwIjoxNjAwMzA3MDc4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-QvW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; url288=/rest/insight/1.0/objecttype/2/icon.png?size=288&uuid=3269b6c6-10cc-41de-88ba-99efae71f889&
               jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLmppcmEucGx1Z2lucy5pbnNpZ2h0Iiwic3ViIjoiNWVkZjBhNDNlMzFmNjIwYWJhNjYyZjAyIiwiaW5zaWdodCI6dHJ1ZSwiY2xpZW50S2V5IjoiN2VmZmExZGQtYzNiMS0zMjQ4LWFjZDUtNjdjNDcxZWFkOGQzIiwiaXNzIjoiY
               29tLnJpYWRhbGFicy5qaXJhLnBsdWdpbnMuaW5zaWdodCIsIm9yaWdpbmFsbHlJc3N1ZWRBdCI6MTYwMDMwNjg5OCwiZXhwIjoxNjAwMzA3MDc4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-QvW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; objectId=3}
objectType   : @{id=2; name=My Object Type; type=0; description=A Sample Object Type; icon=; position=0; created=2020-09-16T07:14:02.118Z; updated=2020-09-16T07:14:02.118Z; objectCount=0; objectSchemaId=3; inherited=False; abstractObjectType=False; 
               parentObjectTypeInherited=False}
created      : 2020-09-17T01:11:02.596Z
updated      : 2020-09-17T01:11:02.596Z
hasAvatar    : False
timestamp    : 1600305062596
attributes   : {@{id=9; objectTypeAttribute=; objectTypeAttributeId=7; objectAttributeValues=System.Object[]; objectId=3}, @{id=12; objectTypeAttribute=; objectTypeAttributeId=8; objectAttributeValues=System.Object[]; objectId=3}, @{id=10; 
               objectTypeAttribute=; objectTypeAttributeId=9; objectAttributeValues=System.Object[]; objectId=3}, @{id=11; objectTypeAttribute=; objectTypeAttributeId=10; objectAttributeValues=System.Object[]; objectId=3}...}
extendedInfo : @{openIssuesExists=False; attachmentsExists=False}
_links       : @{self=/secure/ShowObject.jspa?id=3}
name         : MyObject

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Objects

.EXAMPLE
Remove-InsightObject -ID "3" -InsightApiKey $InsightApiKey
Remove-InsightObject -ID "ABC-3" -InsightApiKey $InsightApiKey

#>

function Remove-InsightObject {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/object/$($ID)"

    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method DELETE
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }
        
        Write-Output $response
        }
}