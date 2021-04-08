# Script contains the required config for syncing Zoom with Insight

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

Test-Module PSZoom
Test-Module PSInsight
Test-Module Join-Object

#endregion Required-Modules

#region Global Vars

#Get Global Scope API Key for Insight (Can skip adding ApiKey\ApiSecret to every command as it will find the info in the script scope)
$Global:InsightApiKey = Get-Secret -Name 'InsightAPI' -AsPlainText

# Get API Key and Secret for Zoom
$Global:ZoomApiKey = Get-Secret -Name 'ZoomAPI' -AsPlainText
$Global:ZoomApiSecret = Get-Secret -Name 'ZoomAPIsecret' -AsPlainText

$ObjectTypeName = "Zoom Room"
#endregion Global Vars

#region Zoom Rooms Object
# Build custom Zoom Room object containing complete information for CMDB

$ZoomRoomIDs = Get-ZoomRooms -PageSize 300
$DashboardZoomRooms = Get-DashboardZoomRooms -PageSize 300
$ZoomRoomLocations = Get-ZoomRoomLocations -page_size 300

function Get-SingleZoomRoomLocation {
    [CmdletBinding()]
    param (
        [String]$location_id,
        [Array]$Locations
    )
    
    begin {
        if ($Locations) {
            
        }
        Else{
            $Locations = Get-ZoomRoomLocations -PageSize 300
        }
    }
    
    process {

        $FloorObj =  $Locations | Where { $_.id -like $location_id}
        $CampusObj = $Locations | Where { $_.id -like $FloorObj.parent_location_id}
        $CityObj = $Locations | Where { $_.id -like $CampusObj.parent_location_id}
        $StateObj = $Locations | Where { $_.id -like $CityObj.parent_location_id}
        $CountryObj = $Locations | Where { $_.id -like $StateObj.parent_location_id}

        $hierarchy = @{
            Floor = $FloorObj.name
            Campus = $CampusObj.name
            City = $CityObj.name
            State = $StateObj.name
            Country = $CountryObj.name
        }

    }
    
    end {
        $hierarchy
    }
}

$ZoomRooms = @()

$zoomRooms = foreach ($Room in $ZoomRoomIDs) {

    # Join Objects
    $ZRoom = Join-Object -Left $Room -Right $DashboardZoomRooms -LeftJoinProperty 'name' -RightJoinProperty 'room_name' -ExcludeRightProperties id,status
    
    # Add Devices with unique custom name for use in CMDB
    $Devices =  foreach ($device in $(Get-ZoomRoomDevices -RoomID $Room.id)) {
        Add-Member -InputObject $device -NotePropertyName 'device_name' -NotePropertyValue "$($device.room_name) - $($device.device_type)" -Force
        $device
    }
    Add-Member -InputObject $ZRoom -NotePropertyName 'Devices' -NotePropertyValue $Devices -Force

    # Add Hierarchy
    Add-Member -InputObject $ZRoom -NotePropertyName 'Location' -NotePropertyValue $(Get-SingleZoomRoomLocation -location_id $Room.location_id -Locations $ZoomRoomLocations) -Force

    $ZRoom
}
#endregion Zoom Rooms Object

#region Insight

$ZoomRoomObjectType = Get-InsightObjectTypes -objectschemaID (Get-InsightObjectSchema -ApiKey $InsightApiKey).id -InsightApiKey $InsightApiKey | Where { $_.Name -like $ObjectTypename }
$ZoomRoomAttributes = Get-InsightObjectTypeAttributes -ID $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey

$ObjectTypes = Get-InsightObjectTypes -objectschemaID 5 -InsightApiKey $InsightApiKey

$ZoomServerAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "Zoom Server" } ).id -InsightApiKey $InsightApiKey
$AndroidAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "Android Controller" } ).id -InsightApiKey $InsightApiKey
$iOSAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "iOS Controller" } ).id -InsightApiKey $InsightApiKey



foreach ($Room in $ZoomRooms) {
    
    $Array = @(
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "name" } ).id -objectAttributeValues $room.name
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "zoom_id" } ).id -objectAttributeValues $room.room_id
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "zoom_room_id" } ).id -objectAttributeValues $room.room_id
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "location_id" } ).id -objectAttributeValues $room.location_id
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "status" } ).id -objectAttributeValues $room.status
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "calendar_name" } ).id -objectAttributeValues $room.calendar_name
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "email" } ).id -objectAttributeValues $room.email
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "account_type" } ).id -objectAttributeValues $room.account_type
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "device_ip" } ).id -objectAttributeValues $room.device_ip
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "camera" } ).id -objectAttributeValues $room.camera
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "microphone" } ).id -objectAttributeValues $room.microphone
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "speaker" } ).id -objectAttributeValues $room.speaker
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "last_start_time" } ).id -objectAttributeValues $room.last_start_time
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "issues" } ).id -objectAttributeValues $([string]$room.issues)
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "health" } ).id -objectAttributeValues $room.health
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "floor" } ).id -objectAttributeValues $room.location.floor
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "campus" } ).id -objectAttributeValues $room.location.campus
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "city" } ).id -objectAttributeValues $room.location.city
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "state" } ).id -objectAttributeValues $room.location.state
    New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "country" } ).id -objectAttributeValues $room.location.country
    )

    #New-InsightObjectAttribute -objectTypeAttributeId 165 -objectAttributeValues "Test name"
    $RoomObject = New-InsightObject -objectTypeId $ZoomRoomObjectType.id -attributes $array -InsightApiKey $InsightApiKey
    
    # Create Device
    foreach ($device in $room.Devices) {

        switch ($device.device_system) {
            {$_ -like "*Win*"} { 
                $deviceAttributes = $ZoomServerAttributes
                $objectTypeID = ( $ObjectTypes | Where { $_.name -like "Zoom Server" } ).id
            }
            {$_ -like "*Android*"} { 
                $deviceAttributes = $AndroidAttributes
                $objectTypeID = ( $ObjectTypes | Where { $_.name -like "Android Controller" } ).id
            }
            {$_ -like "*iPad*"} { 
                $deviceAttributes = $iOSAttributes
                $objectTypeID = ( $ObjectTypes | Where { $_.name -like "iOS Controller" } ).id
            }
        }

        $array = @(
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "name" } ).id -objectAttributeValues $device.device_name
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "device_type" } ).id -objectAttributeValues $device.device_type
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "app_version" } ).id -objectAttributeValues $device.app_version
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "app_target_version" } ).id -objectAttributeValues $device.app_target_version
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "device_system" } ).id -objectAttributeValues $device.device_system
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "status" } ).id -objectAttributeValues $device.status
                New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "parent_room" } ).id -objectAttributeValues $RoomObject.objectKey
                )

                New-InsightObject -objectTypeId $objectTypeID -attributes $array -InsightApiKey $InsightApiKey

    }

} 

#endregion Insight
