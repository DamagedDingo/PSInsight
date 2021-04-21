function Find-InsightObjectsAdvanced {
    <#

.SYNOPSIS
Resource to load an object in Insight.

.DESCRIPTION
Resource to load an object in Insight.

.PARAMETER page
The page to fetch. (1..N).

.PARAMETER asc
Ascending or descending, asc = 1, desc = 0.

.PARAMETER objectTypeId
The id of the Object Type to search objects from.

.PARAMETER objectId
Set the page to the page where this object is shown

.PARAMETER objectSchemaId
The id of the Object Schema to search from.

.PARAMETER iql
An valid IQL string to filter the returned objects.

.PARAMETER resultsPerPage
The number of objects to fetch.

.PARAMETER orderByTypeAttrId
The id of the attribute to sort the Objects from.

.PARAMETER includeAttributes
If object attributes should be included.

.PARAMETER attributesToDisplay
List of objectTypeAttributes ids to return.

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS

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
        [int]$ObjectTypeID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$objectSchemaId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$objectId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$resultsPerPage,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$page,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$asc,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string]$iql,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int]$orderByTypeAttrId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [bool]$includeAttributes,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [int[]]$attributesToDisplay,

        [Parameter(Mandatory = $false)]
        [switch]$ShowJSON,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {

        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/object/navlist/iql"

        $RequestBody = @{
            'objectTypeId' = $objectTypeId
            'objectSchemaId' = $objectSchemaId
            'resultsPerPage' = $resultsPerPage
            }
        if ($page) {
            $RequestBody.Add("page",$page )
        }
        if ($asc) {
            $RequestBody.Add("asc",$asc )
        }
        if ($objectId) {
            $RequestBody.Add("objectId",$objectId )
        }
        if ($iql) {
            $RequestBody.Add("iql",$iql )
        }
        if ($orderByTypeAttrId) {
            $RequestBody.Add("orderByTypeAttrId",$orderByTypeAttrId )
        }
        if ($includeAttributes) {
            $RequestBody.Add("includeAttributes",$includeAttributes )
        }
        if ($attributesToDisplay) {
            $list = @{"attributesToDisplayIds" = @($attributesToDisplay)}
            $RequestBody.Add("attributesToDisplay",$list )
        }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 20

        if ($ShowJSON -eq $true) {
            Write-Output $RequestBody
            break
        }

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