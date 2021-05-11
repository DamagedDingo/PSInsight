function New-InsightObjectTypeAttributes {
    <#

.SYNOPSIS
Resource to create an object type attribute in Insight.

.DESCRIPTION
Resource to create an object type attribute in Insight.

.PARAMETER Name
The name.

.PARAMETER Description
The Description for the Attribute.

.PARAMETER Type
The type. ["Default", "Object", "User", "Confluence", "Group", "Status"]

.PARAMETER ParentObjectTypeId
The Object type ID of the Parent

.PARAMETER defaultType
The default type id. Dynamic Parameter if 'Type' is 'Default' ["Text", "Integer", "Boolean", "Double", "Date", "Time", "Date_Time", "URL", "Email", "TextArea", "Select", "IP_Address"]

.PARAMETER typeValue
The referenced object type id. Dynamic Parameter if 'Type' is 'Object'

.PARAMETER typeValueMulti
The JIRA groups to restrict selection. Dynamic Parameter if 'Type' is 'User'

.PARAMETER additionalValue. Dynamic Parameter if 'Type' is 'Object','URL' or 'Confluence'
URL: DISABLED, ENABLED
OBJECT: Reference Type Id
User: SHOW_PROFILE, HIDE_PROFILE
Confluence: Confluence Space Id

.PARAMETER minimumCardinality. Dynamic Parameter if 'Type' is 'Email','Select','Object','User','Group','Version','Project'
The minimum cardinality (default 0)

.PARAMETER maximumCardinality. Dynamic Parameter if 'Type' is 'Email','Select','Object','User','Group','Version','Project'
The maximum cardinality (default 1)

.PARAMETER suffix
If suffix on value types (Integer, Float). Dynamic Parameter if 'Default Type' is 'Integer' or 'Float'

.PARAMETER includeChildObjectTypes
If objects should be valid for object type children. Dynamic Parameter if 'Type' is 'Object'

.PARAMETER iql
If objects should be filtered by IQL. Dynamic Parameter if 'Type' is 'Object'

.PARAMETER uniqueAttribute
If the attribute should be unique (true, false)

.PARAMETER summable
If a sum should be shown in list view (true, false). Dynamic Parameter if 'Default Type' is 'Integer' or 'Float'

.PARAMETER regexValidation. Dynamic Parameter if 'Type' is 'Text' or 'Email'
If a regex validation should apply

.PARAMETER options. Dynamic Parameter if 'Type' is 'Options'
The options for the attribute in comma separate list

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
id                      : 6
name                    : Test Attribute
label                   : False
type                    : 0
defaultType             : @{id=0; name=Text}
editable                : True
system                  : False
sortable                : True
summable                : False
indexed                 : True
minimumCardinality      : 0
maximumCardinality      : 1
removable               : True
hidden                  : False
includeChildObjectTypes : False
uniqueAttribute         : False
options                 : 
position                : 4

.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+type+attributes

.EXAMPLE
New-InsightObjectTypeAttributes -Name "Test Attribute" -Type Default -DefaultType Text -ObjectTypeId 1 -InsightApiKey $InsightApiKey
New-InsightObjectTypeAttributes -Name "Email Address" -Type Default -DefaultType Email -ParentObjectTypeId 1 -InsightApiKey $InsightApiKey
New-InsightObjectTypeAttributes -Name "Link to Parent" -Type Object -typeValue 2 -ParentObjectTypeId 1 -InsightApiKey $InsightApiKey

#>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Default", "Object", "User", "Confluence", "Group", "Status")]
        [string]$Type,

        [Parameter(Mandatory = $false)]
        [Alias('ObjectTypeId')]
        [int]$ParentObjectTypeId,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey = $InsightApiKey
    )
    DynamicParam {
        # Create a new dictionary to contain all the dynamic parameters
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

        if ($Type -like "Default") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'DefaultType',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $true; Position = 1 }
                            [ValidateSet]::new("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date_Time", "URL", "Email", "TextArea", "Select", "IP_Address")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($DefaultType -in "Integer","Float") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'suffix',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $true; Position = 1 }
                            #[ValidateSet]::new("Start", "Stop", "Create", "Delete")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'summable',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $true; Position = 1 }
                            [ValidateSet]::new("True", "False")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -in "Object") {

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'typeValue',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $true; Position = 1 }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'includeChildObjectTypes',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                            #[ValidateSet]::new("Start", "Stop", "Create", "Delete")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'iql',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                            #[ValidateSet]::new("Start", "Stop", "Create", "Delete")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -in "User","Status") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'typeValueMulti',
                        [array],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -in "Object","URL","Confluence","User") {

            if ($Type -like "Object") {
                $Mandatory =  $true
            }
            else {
                $Mandatory = $false
            }

            if ($Type -like "URL") {
                $ValidatedSet = "DISABLED","ENABLED"
            }
            if ($Type -like "User") {
                $ValidatedSet = "SHOW_PROFILE","HIDE_PROFILE"
            }

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'additionalValue',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $Mandatory; Position = 1 }
                                if ($type -in "URL","User") {
                                    [ValidateSet]::new($ValidatedSet)
                                }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -in "Email","Select","Object","User","Group","Version","Project") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'minimumCardinality',
                        [int],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'maximumCardinality',
                        [int],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -in "Text","Email") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'regexValidation',
                        [string],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }

        if ($Type -like "Options") {
            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new(
                        'options',
                        [array],
                        [Attribute[]]@(
                            [Parameter]@{ Mandatory = $false; Position = 1 }
                            #[ValidateSet]::new("Start", "Stop", "Create", "Delete")
                        )
                    )
                    $paramDictionary.Add($parameter.Name, $parameter)
        }
        
        $paramDictionary
    }

    begin {
        
        # Translate the Object Type Name to the Object Type ID
        switch ($Type) {
            "Default" { $objectTypeID = "0" }
            "Object" { $objectTypeID = "1" }
            "User" { $objectTypeID = "2" }
            "Confluence" { $objectTypeID = "3" }
            "Group" { $objectTypeID = "4" }
            "Status" { $objectTypeID = "7" }
        }

        # Translate the Default Object Type Name to the Default Object Type ID
        switch ($PSBoundParameters["DefaultType"]) {
            "Text" { $DefaultTypeID = 0 }
            "Integer" { $DefaultTypeID = "1" }
            "Boolean" { $DefaultTypeID = "2" }
            "Double" { $DefaultTypeID = "3" }
            "Date" { $DefaultTypeID = "4" }
            "Time" { $DefaultTypeID = "5" }
            "Date Time" { $DefaultTypeID = "6" }
            "URL" { $DefaultTypeID = "7" }
            "Email" { $DefaultTypeID = "8" }
            "Textarea" { $DefaultTypeID = "9" }
            "Select" { $DefaultTypeID = "10" }
            "IP Address" { $DefaultTypeID = "11" }
        } 
        #Generate Headers
        $headers = New-InsightHeaders -InsightApiKey $InsightApiKey
    }
    
    process {

        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objecttypeattribute/$($ParentObjectTypeId)"

        #Create default Hash
        $RequestBody = @{
            name = $Name
        }

        #Add required attributes to the hash for all Object Types except Default
        switch ($Type) {
            { @("Object", "Confluence") -contains $_ } {
                $RequestBody.Add("type", $objectTypeID)
                $RequestBody.Add("typeValue", $PSBoundParameters["typeValue"])
                $RequestBody.Add("additionalValue", $PSBoundParameters["additionalValue"])
            }
            "User" { 
                $RequestBody.Add("type", $objectTypeID)
                $RequestBody.Add("typeValue", $PSBoundParameters["typeValue"])
                $RequestBody.Add("typeValueMulti", $PSBoundParameters["typeValueMulti"])
                $RequestBody.Add("additionalValue", $PSBoundParameters["additionalValue"])
            }
            "Group" { 
                $RequestBody.Add("type", $objectTypeID)
                $RequestBody.Add("additionalValue", $PSBoundParameters["additionalValue"])
            }
            "Status" { 
                $RequestBody.Add("type", $objectTypeID)
                $RequestBody.Add("typeValueMulti", $PSBoundParameters["typeValueMulti"])
            }
        }

        #Add required attributes to the hash for all Object Type "Default"
        switch ($PSBoundParameters["DefaultType"]) {
            { @("Text", "Integer", "Boolean", "Double", "Date", "Date_Time", "Email", "TextArea", "IP_Address") -contains $_ } {
                $RequestBody.Add("type", 0)
                $RequestBody.Add("defaultTypeId", $DefaultTypeID)
            }
            "URL" { 
                $RequestBody.Add("type", 0)
                $RequestBody.Add("defaultTypeId", $DefaultTypeID)
                $RequestBody.Add("additionalValue", $PSBoundParameters["additionalValue"])
            }
            "Select" { 
                $RequestBody.Add("type", 0)
                $RequestBody.Add("defaultTypeId", $DefaultTypeID)
                $RequestBody.Add("options", $PSBoundParameters["options"])
            }
        }

        # Add all the aditional Attributes. 
        if ($uniqueAttribute) {
            $RequestBody.Add("uniqueAttribute", $UniqueAttribute)
        }
        if ($Description) {
            $RequestBody.Add("Description", $Description)
        }
        if ($PSBoundParameters["minimumCardinality"]) {
            $RequestBody.Add("minimumCardinality", $PSBoundParameters["minimumCardinality"])
        }
        if ($PSBoundParameters["maximumCardinality"]) {
            $RequestBody.Add("maximumCardinality", $PSBoundParameters["maximumCardinality"])
        }
        if ($PSBoundParameters["suffix"]) {
            $RequestBody.Add("suffix", $PSBoundParameters["suffix"])
        }
        if ($PSBoundParameters["includeChildObjectTypes"]) {
            $RequestBody.Add("includeChildObjectTypes", $PSBoundParameters["includeChildObjectTypes"])
        }
        if ($PSBoundParameters["iql"]) {
            $RequestBody.Add("iql", $PSBoundParameters["iql"])
        }
        if ($PSBoundParameters["summable"]) {
            $RequestBody.Add("summable", $PSBoundParameters["summable"])
        }
        if ($PSBoundParameters["regexValidation"]) {
            $RequestBody.Add("regexValidation", $PSBoundParameters["regexValidation"])
        }
        if ($PSBoundParameters["options"]) {
            $RequestBody.Add("options", $PSBoundParameters["options"])
        }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 10
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
