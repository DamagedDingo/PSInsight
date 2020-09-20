<#

.SYNOPSIS
Resource to create an object type attribute in Insight.

.DESCRIPTION
Resource to create an object type attribute in Insight.

.PARAMETER Name
The name.

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


function New-InsightObjectTypeAttributes {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Default", "Object", "User", "Confluence", "Group", "Status")]
        [string]$Type,

        [Parameter(Mandatory = $false)]
        [Alias('ObjectTypeId')]
        [int]$ParentObjectTypeId,

        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey
    )
    DynamicParam {
        # Create a new dictionary to contain all the dynamic parameters
        $paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        if ($Type -like "Default") {
            #region DefaultType
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $true

            # Create the ValidateSet list
            $attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date_Time", "URL", "Email", "TextArea", "Select", "IP_Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            $attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $DefaultType_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("DefaultType", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("DefaultType", $DefaultType_dynParam)
            #endregion DefaultType
        }

        if ($DefaultType -like "Integer" -or $DefaultType -like "Float") {
            #region suffix
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $true

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $suffix_attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $suffix_attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $suffix_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("suffix", [STRING], $suffix_attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("suffix", $suffix_dynParam)
            #endregion suffix

            #region summable
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $true

            # Create the ValidateSet list
            $attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("True", "False")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            $attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $summable_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("summable", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("summable", $summable_dynParam)
            #endregion summable
        }

        if ($Type -like "Object") {
            #region typeValue
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $true

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $typeValue_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("typeValue", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("typeValue", $typeValue_dynParam)
            #endregion typeValue

            #region includeChildObjectTypes
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")

            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $includeChildObjectTypes_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("includeChildObjectTypes", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("includeChildObjectTypes", $includeChildObjectTypes_dynParam)
            #endregion includeChildObjectTypes

            #region iql
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")

            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $iql_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("iql", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("iql", $iql_dynParam)
            #endregion iql
        }

        if ($Type -like "User") {
            #region typeValueMulti
            #The JIRA groups to restrict selection
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $typeValueMulti_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("typeValueMulti", [ARRAY], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("typeValueMulti", $typeValueMulti_dynParam)
            #endregion typeValueMulti
        }

        if ($Type -like "Object" -or $Type -like "URL" -or $Type -like "Confluence") {
            #region additionalValue
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"

            if ($Type -like "Object") {
                $attributes.Mandatory = $true
            }
            else {
                $attributes.Mandatory = $false
            }
            
            # Create the ValidateSet list
            if ($Type -like "URL") {
                $attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("DISABLED", "ENABLED")
            }
            if ($Type -like "User") {
                $attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("SHOW_PROFILE", "HIDE_PROFILE")
            }
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $additionalValue_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("additionalValue", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("additionalValue", $additionalValue_dynParam)
            #endregion additionalValue
        }

        if ($Type -like "Email" -or $Type -like "Select" -or $Type -like "Object" -or $Type -like "User" -or $Type -like "Group" -or $Type -like "Version" -or $Type -like "Project") {
            #region minimumCardinality
            #The JIRA groups to restrict selection
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"

            $attributes.Mandatory = $false
            
            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $minimumCardinality_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("minimumCardinality", [INT], $attributeCollection)
            $PSBoundParameters["minimumCardinality_dynParam"] = 0

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("minimumCardinality", $minimumCardinality_dynParam)
            #endregion minimumCardinality

            #region maximumCardinality
            #The JIRA groups to restrict selection
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"

            $attributes.Mandatory = $false
            
            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")
        
            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $maximumCardinality_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("maximumCardinality", [INT], $attributeCollection)
            $PSBoundParameters["maximumCardinality_dynParam"] = 1

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("maximumCardinality", $maximumCardinality_dynParam)
            #endregion maximumCardinality
        }

        if ($Type -like "Text" -or $Type -like "Email") {
            #region regexValidation
            #Create the base DynamicParam attributes
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")

            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $regexValidation_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("regexValidation", [STRING], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("regexValidation", $regexValidation_dynParam)
            #endregion regexValidation
        }

        if ($Type -like "Options") {
            #region options
            #Create the base DynamicParam attributes
            #The options for the attribute in comma separate list - Might need to add script validation or use .join(",")
            $attributes = new-object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = "__AllParameterSets"
            $attributes.Mandatory = $false

            # Create the ValidateSet list
            #$attributesValidate = New-Object System.Management.Automation.ValidateSetAttribute @("Text", "Integer", "Boolean", "Double", "Date", "Time", "Date Time", "URL", "Email", "Text Area", "Select", "IP Address")

            # Add the Base Attributes and the Validated list attributes to a collection
            $attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #$attributeCollection.Add($attributesValidate)

            #Create a new object with the Name, Type, and attributes collection.
            $options_dynParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("options", [ARRAY], $attributeCollection)

            # Add Parameter to the Dictionary collection 
            $paramDictionary.Add("options", $options_dynParam)
            #endregion options
        }
        #Return all the dynamic parameters inside the dictionary
        return $paramDictionary
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
