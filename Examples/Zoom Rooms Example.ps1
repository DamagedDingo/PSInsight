# Example Script to build all required prperties to support Zoom Rooms within Jira Insight

#Turn on script wide verbose for testing
$VerbosePreference = "continue"

#region Variables
$Global:InsightApiKey = "Place-Your-API-Key-Here"
$ObjectSchemaName = "My PSInsight Example"
$ObjectSchemaKey = "MPE"
$ObjectSchemaDescription = "Example CMDB Schema built with PSInsight"
$ObjectTypeName = "ZoomRooms"
$ObjectTypeDescription = "ZoomRooms"
$ObjectTypeIcon = "AV Receiver"

#Path to CSV containing the list of attributes
$RequiredZoomRoomAttributes = Import-Csv ".\Examples\Attributes_ZoomRoom.csv"
#endregion Variables

#region Required-Modules
function Test-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {

            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
            else {

                # If module is not imported, not available and not in online gallery then abort
                write-host "Module $m not imported, not available and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}

Test-Module PSInsight
#endregion Required-Modules

# Schema setup
try {
    $InsightObjectSchema = Get-InsightObjectSchema -InsightApiKey $InsightApiKey | Where { $_.name -like $ObjectSchemaName }
    Write-Verbose 'Object Schema not found'
}
catch {
    $InsightObjectSchema = New-InsightObjectSchema -Name $ObjectSchemaName -ObjectSchemaKey $ObjectSchemaKey -Description $ObjectSchemaDescription -InsightApiKey $InsightApiKey
    Write-Verbose 'Object Schema has been created'
}

# Create Zoom Room Object Type
try {
    $ZoomRoomObjectType = Get-InsightObjectTypes -objectschemaID $InsightObjectSchema.id -InsightApiKey $InsightApiKey | Where { $_.Name -like $ObjectTypename }
    if (!($ZoomRoomObjectType)) {
        throw "$ObjectTypename - Object not found"
        Write-Verbose 'Object Type not found'
    }
}
catch {
    $IconID = (Get-InsightIcons -InsightApiKey $InsightApiKey | Where { $_.name -like $ObjectTypeIcon }).id
    $SchemaID = $($InsightObjectSchema.id).ToString()
    $ZoomRoomObjectType = New-InsightObjectTypes -Name $ObjectTypeName -Description $ObjectTypeDescription -IconID $IconID -objectSchemaId $SchemaID -InsightApiKey $InsightApiKey
    Write-Verbose 'Object Type has been created'
}

# Build a list of existing attributes on the object (used to catch and rebuild if failures occur).
$ExistingZoomRoomAttributes = Get-InsightObjectTypeAttributes -ID $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey
# Import list of attributes from CSV and find any missing from host
$MissingZoomRoomAttributes = $RequiredZoomRoomAttributes | Where-Object { $ExistingZoomRoomAttributes.name -notcontains $_.name }

#Create any missing attributes
foreach ($Attribute in $MissingZoomRoomAttributes) {
    New-InsightObjectTypeAttributes -Name $Attribute.name -Type $Attribute.Type -DefaultType $Attribute.DefaultType -ParentObjectTypeId $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey
    Write-Verbose "$Attribute.name: Created"
}

# Get the full list of attributes from the host again with all properties to be used elsewhere if needed. 
$ZoomRoomAttributes = Get-InsightObjectTypeAttributes -ID $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey

#Turn off verbose after script runs. 
$VerbosePreference = "silentlycontinue"