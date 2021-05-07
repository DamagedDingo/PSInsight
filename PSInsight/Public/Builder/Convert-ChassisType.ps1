function Convert-ChassisType {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ChassisID
    )

    class Chassis {
        [string]$Type
        [int]$ID
        [string]$Category
    }
    
    $Chassis = [Chassis]::new()
    
    switch ($ChassisID) {
        1 { 
            $Chassis.Type = 'Other'
            $Chassis.ID = $_
            $Chassis.Category = 'Unknown'
        }
        2 {  
            $Chassis.Type = 'Unknown'
            $Chassis.ID = $_
            $Chassis.Category = 'Unknown'
        }
        3 {
            $Chassis.Type = 'Desktop'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        4 { 
            $Chassis.Type = 'Low Profile Desktop'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        5 { 
            $Chassis.Type = 'Pizza Box'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        6 { 
            $Chassis.Type = 'Mini Tower'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        7 { 
            $Chassis.Type = 'Tower'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        8 { 
            $Chassis.Type = 'Portable'
            $Chassis.ID = $_
            $Chassis.Category = 'Laptop'
        }
        9 { 
            $Chassis.Type = 'Laptop'
            $Chassis.ID = $_
            $Chassis.Category = 'Laptop'
        }
        10 { 
            $Chassis.Type = 'Notebook'
            $Chassis.ID = $_
            $Chassis.Category = 'Laptop'
        }
        11 { 
            $Chassis.Type = 'Hand Held'
            $Chassis.ID = $_
            $Chassis.Category = 'Tablet'
        }
        12 { 
            $Chassis.Type = 'Docking Station'
            $Chassis.ID = $_
            $Chassis.Category = 'Dock'
        }
        13 { 
            $Chassis.Type = 'All in One'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        14 { 
            $Chassis.Type = 'Sub Notebook'
            $Chassis.ID = $_
            $Chassis.Category = 'Laptop'
        }
        15 { 
            $Chassis.Type = 'Space-Saving'
            $Chassis.ID = $_
            $Chassis.Category = 'Server'
        }
        16 { 
            $Chassis.Type = 'Lunch Box'
            $Chassis.ID = $_
            $Chassis.Category = 'Server'
        }
        17 { 
            $Chassis.Type = 'Main System Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Server'
        }
        18 { 
            $Chassis.Type = 'Expansion Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        19 { 
            $Chassis.Type = 'SubChassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Unknown'
        }
        20 { 
            $Chassis.Type = 'Bus Expansion Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Server'
        }
        21 { 
            $Chassis.Type = 'Peripheral Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Unknown'
        }
        22 { 
            $Chassis.Type = 'Storage Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Unknown'
        }
        23 { 
            $Chassis.Type = 'Rack Mount Chassis'
            $Chassis.ID = $_
            $Chassis.Category = 'Server'
        }
        24 { 
            $Chassis.Type = 'Sealed-Case PC'
            $Chassis.ID = $_
            $Chassis.Category = 'Desktop'
        }
        30 { 
            $Chassis.Type = 'Tablet'
            $Chassis.ID = $_
            $Chassis.Category = 'Tablet'
        }
        31 { 
            $Chassis.Type = 'Convertible'
            $Chassis.ID = $_
            $Chassis.Category = 'Tablet'
        }
        32 { 
            $Chassis.Type = 'Detachable'
            $Chassis.ID = $_
            $Chassis.Category = 'Tablet'
        }
    }
    return $Chassis
}