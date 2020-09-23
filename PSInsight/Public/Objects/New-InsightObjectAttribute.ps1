function New-InsightObjectAttribute {
    <#

.SYNOPSIS
Resource to create an attribute array to send to New-InsightObject.

.DESCRIPTION
Resource to create an attribute array to send to New-InsightObject.

.PARAMETER objectTypeAttributeId
The object type attribute ID to populate.

.PARAMETER objectAttributeValues
The object attribute value.

.OUTPUTS
Name                           Value                                                                                                         
----                           -----                                                                                                         
objectTypeAttributeId          8                                                                                                             
objectAttributeValues          {System.Collections.Hashtable}

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+type+attributes

.EXAMPLE
$1 = New-InsightObjectAttribute -objectTypeAttributeId 8 -objectAttributeValues "Test name"
$2 = New-InsightObjectAttribute -objectTypeAttributeId 12 -objectAttributeValues "test ID"

$array = @($1,$2) # For use with New-InsightObject

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true,valuefrompipelinebypropertyname = $true)]
        [int]$objectTypeAttributeId,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true,valuefrompipelinebypropertyname = $true)]
        [String]$objectAttributeValues
    )
    
    begin {
       
    }
    
    process {

        $Attribute = @{
            'objectTypeAttributeId' = $objectTypeAttributeId
            'objectAttributeValues'   = @(@{
                'value' = $objectAttributeValues
                })
            }

    }
    
    end {
                
        Write-Output $Attribute

        }
}


