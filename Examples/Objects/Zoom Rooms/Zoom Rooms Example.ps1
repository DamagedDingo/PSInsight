$SchemaName = 'CompanyName'
$ObjectTypeName = 'Zoom Room'
$Global:InsightApiKey = Get-Secret -Name 'Insight_API' -AsPlainText
$ZoomApiKey = Get-Secret -Name 'ZoomRooms_API' -AsPlainText
$ZoomApiSecret = Get-Secret -Name 'ZoomRooms_API_Secret' -AsPlainText

$ZoomRooms = Get-ZoomRoomsObjects -SchemaName $SchemaName -ObjectTypeName $ObjectTypeName -ZoomApiKey $ZoomApiKey -ZoomApiSecret $ZoomApiSecret

#region Insight
$SchemaID = $(Get-InsightObjectSchema -InsightApiKey $InsightApiKey | Where-Object { $_.name -eq $SchemaName }).id
$ObjectTypes = Get-InsightObjectTypes -ID $SchemaID -InsightApiKey $InsightApiKey

# Build links (Can't do it in JSON as don't know what the ID's are yet)
$HashArguments = @{
    Name          = "Parent_Room"
    Type          = "Object"
    ParentObjectTypeId = $($ObjectTypes | Where-Object { $_.name -like "iOS Controller" }).id
    typeValue = $($ObjectTypes | Where-Object { $_.name -like "Zoom Room" }).id
    additionalValue = 1
    InsightApiKey = $InsightApiKey
}
New-InsightObjectTypeAttributes @HashArguments 

$HashArguments = @{
    Name          = "Parent_Room"
    Type          = "Object"
    ParentObjectTypeId = $($ObjectTypes | Where-Object { $_.name -like "Android Controller" }).id
    typeValue = $($ObjectTypes | Where-Object { $_.name -like "Zoom Room" }).id
    additionalValue = 1
    InsightApiKey = $InsightApiKey
}
New-InsightObjectTypeAttributes @HashArguments

$HashArguments = @{
    Name          = "Parent_Room"
    Type          = "Object"
    ParentObjectTypeId = $($ObjectTypes | Where-Object { $_.name -like "Zoom Server" }).id
    typeValue = $($ObjectTypes | Where-Object { $_.name -like "Zoom Room" }).id
    additionalValue = 1
    InsightApiKey = $InsightApiKey
}
New-InsightObjectTypeAttributes @HashArguments


$ZoomRoomObjectType = $ObjectTypes | Where-Object { $_.Name -like $ObjectTypename }
$ZoomRoomAttributes = Get-InsightObjectTypeAttributes -ID $ZoomRoomObjectType.id -InsightApiKey $InsightApiKey
$ZoomServerAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where-Object { $_.name -like 'Zoom Server' } ).id -InsightApiKey $InsightApiKey
$AndroidAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where-Object { $_.name -like 'Android Controller' } ).id -InsightApiKey $InsightApiKey
$iOSAttributes = Get-InsightObjectTypeAttributes -ID ( $ObjectTypes | Where-Object { $_.name -like 'iOS Controller' } ).id -InsightApiKey $InsightApiKey

# Build Insight Object
foreach ($Room in $ZoomRooms) {

    $AttributeArray = @()

    switch ($Room) {
        { $room.name } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'name' } ).id -objectAttributeValues $room.name)
        }
        { $room.room_id } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'zoom_id' } ).id -objectAttributeValues $room.room_id)
        }
        { $room.zoom_room_id } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'zoom_room_id' } ).id -objectAttributeValues $room.zoom_room_id)
        }
        { $room.location_id } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'location_id' } ).id -objectAttributeValues $room.location_id)
        }
        { $room.status } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'status' } ).id -objectAttributeValues $room.status)
        }
        { $room.calendar_name } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'calendar_name' } ).id -objectAttributeValues $room.calendar_name)
        }
        { $room.email } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'email' } ).id -objectAttributeValues $room.email)
        }
        { $room.account_type } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'account_type' } ).id -objectAttributeValues $room.account_type)
        }
        { $room.device_ip } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'device_ip' } ).id -objectAttributeValues $room.device_ip)
        }
        { $room.camera } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'camera' } ).id -objectAttributeValues $room.camera)
        }
        { $room.microphone } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'microphone' } ).id -objectAttributeValues $room.microphone)
        }
        { $room.speaker } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'speaker' } ).id -objectAttributeValues $room.speaker)
        }
        { $room.last_start_time } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'last_start_time' } ).id -objectAttributeValues $room.last_start_time)
        }
        { $room.issues } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'issues' } ).id -objectAttributeValues $([string]$room.issues))
        }
        { $room.health } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'health' } ).id -objectAttributeValues $room.health)
        }
        { $room.floor } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'floor' } ).id -objectAttributeValues $room.floor)
        }
        { $room.campus } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'campus' } ).id -objectAttributeValues $room.campus)
        }
        { $room.city } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'city' } ).id -objectAttributeValues $room.city)
        }
        { $room.state } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'state' } ).id -objectAttributeValues $room.state)
        }
        { $room.country } {
            $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $ZoomRoomAttributes | Where-Object { $_.name -like 'country' } ).id -objectAttributeValues $room.country)
        }
    }

    $RoomObject = New-InsightObject -objectTypeId $ZoomRoomObjectType.id -attributes $AttributeArray -InsightApiKey $InsightApiKey
    
    # Create Device
    foreach ($device in $room.Devices) {

        switch ($device.device_system) {
            { $_ -like '*Win*' } { 
                $deviceAttributes = $ZoomServerAttributes
                $objectTypeID = ( $ObjectTypes | Where-Object { $_.name -like 'Zoom Server' } ).id
            }
            { $_ -like '*Android*' } { 
                $deviceAttributes = $AndroidAttributes
                $objectTypeID = ( $ObjectTypes | Where-Object { $_.name -like 'Android Controller' } ).id
            }
            { $_ -like '*iPad*' } { 
                $deviceAttributes = $iOSAttributes
                $objectTypeID = ( $ObjectTypes | Where-Object { $_.name -like 'iOS Controller' } ).id
            }
        }

        $AttributeArray = @()

        switch ($device) {
            { $device.device_name } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'name' } ).id -objectAttributeValues $device.device_name)
            }
            { $device.device_type } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'device_type' } ).id -objectAttributeValues $device.device_type)
            }
            { $device.app_version } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'app_version' } ).id -objectAttributeValues $device.app_version)
            }
            { $device.app_target_version } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'app_target_version' } ).id -objectAttributeValues $device.app_target_version)
            }
            { $device.device_system } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'device_system' } ).id -objectAttributeValues $device.device_system)
            }
            { $device.status } {
                $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'status' } ).id -objectAttributeValues $device.status)
            }
        }
        $AttributeArray += $(New-InsightObjectAttribute -objectTypeAttributeId ( $deviceAttributes | Where-Object { $_.name -like 'parent_room' } ).id -objectAttributeValues $RoomObject.objectKey)

        New-InsightObject -objectTypeId $objectTypeID -attributes $AttributeArray -InsightApiKey $InsightApiKey

    }

} 
#endregion Insight
