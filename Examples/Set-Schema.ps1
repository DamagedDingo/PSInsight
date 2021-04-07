function Set-Schema {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [object]$inputObject,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$InsightApiKey
    )

    # Build Object Schema
    if ($inputObject.ObjectSchema) {
        #$inputObject
        try {
            $HashArguments = @{
                InsightApiKey = $InsightApiKey
            }
            $ObjectSchema = Get-InsightObjectSchema @HashArguments | Where-Object { $_.name -like $inputObject.ObjectSchema.ObjectSchemaName }
            if (!($ObjectSchema)) {
                throw 'Object Schema not found'
            }
            
        }
        catch {
            $HashArguments = @{
                Name            = $inputObject.ObjectSchema.ObjectSchemaName
                ObjectSchemaKey = $inputObject.ObjectSchema.ObjectSchemaKey
                Description     = $inputObject.ObjectSchema.ObjectSchemaDescription
                InsightApiKey   = $InsightApiKey
            }
            $ObjectSchema = New-InsightObjectSchema @HashArguments
            Write-Verbose 'Object Schema has been created'
        }
    }
    
    #build object types
    if ($inputObject.ObjectTypes) {

        foreach ($ObjectType in $inputObject.ObjectTypes) {
            
            try {
                $HashArguments = @{
                    objectschemaID = $ObjectSchema.id
                    InsightApiKey  = $InsightApiKey
                }
                $ObjectTypeParameters = Get-InsightObjectTypes @HashArguments | Where-Object { $_.Name -like $ObjectType.Name }
                if ($ObjectTypeParameters -eq $null) {
                    throw "$($ObjectType.Name) - Object not found"
                    Write-Verbose 'Object Type not found'
                }
            }
            catch {
                $HashArguments = @{
                    Name           = $ObjectType.Name
                    IconID         = (Get-InsightIcons -InsightApiKey $InsightApiKey | Where-Object { $_.name -like $ObjectType.Icon }).id
                    objectSchemaId = $($ObjectSchema.id).ToString()
                    InsightApiKey  = $InsightApiKey
                }
                switch ($ObjectType) {
                    { $ObjectType.description } {
                        $HashArguments.Add('description', $ObjectType.Description) 
                    }
                    { $ObjectType.inherited } {
                        $HashArguments.Add('inherited', $ObjectType.inherited) 
                    }
                    { $ObjectType.abstractObjectType } {
                        $HashArguments.Add('abstractObjectType', $ObjectType.abstractObjectType) 
                    }
                    { $ObjectType.parentObjectTypeId } {
                        $HashArguments.Add('parentObjectTypeId', $ObjectType.parentObjectTypeId) 
                    }
                }
                $HashArguments
                    
                $ObjectTypeParameters = New-InsightObjectTypes @HashArguments
                Write-Verbose 'Object Type has been created'
            }

            if ($ObjectType.Attributes) {
                $HashArguments = @{
                    ID            = $ObjectTypeParameters.id
                    InsightApiKey = $InsightApiKey
                }
                $ObjectTypeAttributes = Get-InsightObjectTypeAttributes @HashArguments
                
                # Find missing Attributes
                $MissingObjectTypeAttributes = $ObjectType.Attributes | Where-Object { $ObjectTypeAttributes.name -notcontains $_.name }
            
                # Create any missing attributes
                foreach ($Attribute in $MissingObjectTypeAttributes) {
                    $HashArguments = @{
                        Name          = $Attribute.name
                        Type          = $Attribute.Type
                        ObjectType    = $ObjectTypeParameters.id
                        InsightApiKey = $InsightApiKey
                    }
                    switch ($Attribute) {
                        { $Attribute.DefaultType } {
                            $HashArguments.Add('DefaultType', $Attribute.DefaultType) 
                        }
                        { $Attribute.ParentObjectTypeId } {
                            $HashArguments.Add('ParentObjectTypeId', $Attribute.ParentObjectTypeId) 
                        }
                        { $Attribute.typeValue } {
                            $HashArguments.Add('typeValue', $Attribute.typeValue) 
                        }
                        { $Attribute.typeValueMulti } {
                            $HashArguments.Add('typeValueMulti', $Attribute.typeValueMulti) 
                        }
                        { $Attribute.additionalValue } {
                            $HashArguments.Add('additionalValue', $Attribute.additionalValue) 
                        }
                        { $Attribute.minimumCardinality } {
                            $HashArguments.Add('minimumCardinality', $Attribute.minimumCardinality) 
                        }
                        { $Attribute.maximumCardinality } {
                            $HashArguments.Add('maximumCardinality', $Attribute.maximumCardinality) 
                        }
                        { $Attribute.suffix } {
                            $HashArguments.Add('suffix', $Attribute.suffix) 
                        }
                        { $Attribute.includeChildObjectTypes } {
                            $HashArguments.Add('includeChildObjectTypes', $Attribute.includeChildObjectTypes) 
                        }
                        { $Attribute.iql } {
                            $HashArguments.Add('iql', $Attribute.iql) 
                        }
                        { $Attribute.uniqueAttribute } {
                            $HashArguments.Add('uniqueAttribute', $Attribute.uniqueAttribute) 
                        }
                        { $Attribute.summable } {
                            $HashArguments.Add('summable', $Attribute.summable) 
                        }
                        { $Attribute.regexValidation } {
                            $HashArguments.Add('regexValidation', $Attribute.regexValidation) 
                        }
                        { $Attribute.options } {
                            $HashArguments.Add('options', $Attribute.options) 
                        }
                    }
            
                    New-InsightObjectTypeAttributes @HashArguments
                    Write-Verbose "$($Attribute.name): Created"
                }
        
            } 

            if ($ObjectType.Links) {
                #add links later when i know how to add users..
            }

            if ($ObjectType.ObjectTypes) {
                # add the parent object type id so that next loop is for a child
                foreach ($child in $ObjectType.ObjectTypes.PSObject.Properties) {
                    $child.value | Add-Member -NotePropertyName 'parentObjectTypeId' -NotePropertyValue $ObjectTypeParameters.id
                }
                #call itself for recursion 
                Set-Schema -inputObject $ObjectType.ObjectTypes -InsightApiKey $InsightApiKey
            }

        } # End foreach object type
        
    } # End if Object Types
    
}