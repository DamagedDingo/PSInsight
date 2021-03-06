function Find-InsightObjects {
    <#

.SYNOPSIS
Resource to load an object in Insight.

.DESCRIPTION
Resource to load an object in Insight.

.PARAMETER ObjectTypeID
The objects ID.

.PARAMETER query
The query string is a simple text match against the start of the name string.

.PARAMETER start
The start index (0..N).

.PARAMETER limit
The number of objects to fetch.

.PARAMETER includeChildren
If children objects should be included.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id           : 3
label        : MyObject
objectKey    : ABC-3
avatar       : @{url16=/rest/insight/1.0/objecttype/2/icon.png?size=16&uuid=3269b6c6-10cc-41de-88ba-99efae71f8...IjoxNjAwMzA3MDc4LCJpYXQiOjE2MDAzMDY4OTh9._CaSkX-QvW1BlK7-4XJB9UikOvegJS-YSjCrCtYUl7A; objectId=3}
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
https://documentation.mindville.com/display/ICV8/Objects+-+REST

.EXAMPLE
Find-InsightObjects -ObjectTypeID "286" -limit 5000 -includeChildren $true -InsightApiKey $InsightApiKey 
Find-InsightObjects -ObjectTypeID "295" -limit 100 -InsightApiKey $InsightApiKey 

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [String]$ObjectTypeID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [String]$query,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$start,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$limit,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [bool]$includeChildren,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {

        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttype/$($ObjectTypeID)/objects"

        $RequestBody = @{
            'objectTypeId' = $objectTypeId
            }
        if ($query) {
            $RequestBody.Add("query",$query )
        }
        if ($start) {
            $RequestBody.Add("start",$start )
        }
        if ($limit) {
            $RequestBody.Add("limit",$limit )
        }
        if ($includeChildren) {
            $RequestBody.Add("includeChildren",$includeChildren )
        }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 20

    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method Post
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }

        $response
    }
}