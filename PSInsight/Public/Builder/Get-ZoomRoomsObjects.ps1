function Get-ZoomRoomsObjects {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$SchemaName,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ObjectTypeName,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ZoomApiKey,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ZoomApiSecret
    )
    
    begin {
    Test-Module "PSZoom"
    Test-Module "PSInsight"
    Test-Module "Join-Object"

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
    }
    
    process {
        foreach ($Room in $ZoomRoomIDs) {

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
    }
    
    end {
        
    }
}