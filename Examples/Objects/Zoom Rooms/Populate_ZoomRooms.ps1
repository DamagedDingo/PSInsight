#region Required-Modules
    Test-Module PSZoom
    Test-Module PSInsight
    Test-Module Join-Object
#endregion Required-Modules

#region Global Vars
    # Name of Schema to use 
    $SchemaName = "CompanyName"

    #Name of the Zoom Rooms ObjectType to add objects to
    $ObjectTypeName = 'Zoom Room'

    #Get Global Scope API Key for Insight (Can skip adding ApiKey\ApiSecret to every command as it will find the info in the script scope)
    $Global:InsightApiKey = Get-Secret -Name 'Insight_API' -AsPlainText

    # Get API Key and Secret for Zoom
    $Global:ZoomApiKey = Get-Secret -Name 'ZoomRooms_API' -AsPlainText
    $Global:ZoomApiSecret = Get-Secret -Name 'ZoomRooms_API_Secret' -AsPlainText
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
            Else {
                $Locations = Get-ZoomRoomLocations -PageSize 300
            }
        }
        
        process {

            $FloorObj = $Locations | Where-Object { $_.id -like $location_id }
            $CampusObj = $Locations | Where-Object { $_.id -like $FloorObj.parent_location_id }
            $CityObj = $Locations | Where-Object { $_.id -like $CampusObj.parent_location_id }
            $StateObj = $Locations | Where-Object { $_.id -like $CityObj.parent_location_id }
            $CountryObj = $Locations | Where-Object { $_.id -like $StateObj.parent_location_id }

            $hierarchy = @{
                Floor   = $FloorObj.name
                Campus  = $CampusObj.name
                City    = $CityObj.name
                State   = $StateObj.name
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
    $ZRoom = Join-Object -Left $Room -Right $DashboardZoomRooms -LeftJoinProperty 'name' -RightJoinProperty 'room_name' -ExcludeRightProperties id, status
    
    # Add Devices with unique custom name for use in CMDB
    $Devices = foreach ($device in $(Get-ZoomRoomDevices -RoomID $Room.id)) {
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

    $ObjectTypes = Get-InsightObjectTypes -ID 55 -InsightApiKey $InsightApiKey

    $ZoomRoomObjectType =  $ObjectTypes | Where { $_.Name -like $ObjectTypename }
    $ZoomRoomAttributes = Get-InsightObjectTypeAttributes -ID $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey

    $ZoomServerAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "Zoom Server" } ).id -InsightApiKey $InsightApiKey
    $AndroidAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "Android Controller" } ).id -InsightApiKey $InsightApiKey
    $iOSAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where { $_.name -like "iOS Controller" } ).id -InsightApiKey $InsightApiKey


    foreach ($Room in $ZoomRooms) {
        
        $AttributeArray = @()

            switch ($Room) {
                { $room.name } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "name" } ).id -objectAttributeValues $room.name)
                }
                { $room.room_id } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "zoom_id" } ).id -objectAttributeValues $room.room_id)
                }
                { $room.zoom_room_id } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "zoom_room_id" } ).id -objectAttributeValues $room.zoom_room_id)
                }
                { $room.location_id } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "location_id" } ).id -objectAttributeValues $room.location_id)
                }
                { $room.status } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "status" } ).id -objectAttributeValues $room.status)
                }
                { $room.calendar_name } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "calendar_name" } ).id -objectAttributeValues $room.calendar_name)
                }
                { $room.email } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "email" } ).id -objectAttributeValues $room.email)
                }
                { $room.account_type } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "account_type" } ).id -objectAttributeValues $room.account_type)
                }
                { $room.device_ip } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "device_ip" } ).id -objectAttributeValues $room.device_ip)
                }
                { $room.camera } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "camera" } ).id -objectAttributeValues $room.camera)
                }
                { $room.microphone } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "microphone" } ).id -objectAttributeValues $room.microphone)
                }
                { $room.speaker } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "speaker" } ).id -objectAttributeValues $room.speaker)
                }
                { $room.last_start_time } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "last_start_time" } ).id -objectAttributeValues $room.last_start_time)
                }
                { $room.issues } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "issues" } ).id -objectAttributeValues $([string]$room.issues))
                }
                { $room.health } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "health" } ).id -objectAttributeValues $room.health)
                }
                { $room.floor } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "floor" } ).id -objectAttributeValues $room.floor)
                }
                { $room.campus } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "campus" } ).id -objectAttributeValues $room.campus)
                }
                { $room.city } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "city" } ).id -objectAttributeValues $room.city)
                }
                { $room.state } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "state" } ).id -objectAttributeValues $room.state)
                }
                { $room.country } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where { $_.name -like "country" } ).id -objectAttributeValues $room.country)
                }
            }

            $RoomObject = New-InsightObject -objectTypeId $ZoomRoomObjectType.id -attributes $AttributeArray -InsightApiKey $InsightApiKey
        
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

            $AttributeArray = @()

            switch ($device) {
                { $device.device_name } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "name" } ).id -objectAttributeValues $device.device_name)
                }
                { $device.device_type } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "device_type" } ).id -objectAttributeValues $device.device_type)
                }
                { $device.app_version } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "app_version" } ).id -objectAttributeValues $device.app_version)
                }
                { $device.app_target_version } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "app_target_version" } ).id -objectAttributeValues $device.app_target_version)
                }
                { $device.device_system } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "device_system" } ).id -objectAttributeValues $device.device_system)
                }
                { $device.status } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "status" } ).id -objectAttributeValues $device.status)
                }
                { $device.parent_room } {
                    $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where { $_.name -like "parent_room" } ).id -objectAttributeValues $RoomObject.objectKey)
                }
            }
    
            New-InsightObject -objectTypeId $objectTypeID -attributes $AttributeArray -InsightApiKey $InsightApiKey

        }

    } 
#endregion Insight
