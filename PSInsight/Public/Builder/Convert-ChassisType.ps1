function Convert-ChassisType {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ChassisID
    )
    switch ($ChassisID) {

        1 { $ChassisName = "Other" }
        2 { $ChassisName = "Unknown" }
        3 { $ChassisName = "Desktop" }
        4 { $ChassisName = "Low Profile Desktop" }
        5 { $ChassisName = "Pizza Box" }
        6 { $ChassisName = "Mini Tower" }
        7 { $ChassisName = "Tower" }
        8 { $ChassisName = "Portable" }
        9 { $ChassisName = "Laptop" }
        10 { $ChassisName = "Notebook" }
        11 { $ChassisName = "Hand Held" }
        12 { $ChassisName = "Docking Station" }
        13 { $ChassisName = "All in One" }
        14 { $ChassisName = "Sub Notebook" }
        15 { $ChassisName = "Space-Saving" }
        16 { $ChassisName = "Lunch Box" }
        17 { $ChassisName = "Main System Chassis" }
        18 { $ChassisName = "Expansion Chassis" }
        19 { $ChassisName = "SubChassis" }
        20 { $ChassisName = "Bus Expansion Chassis" }
        21 { $ChassisName = "Peripheral Chassis" }
        22 { $ChassisName = "Storage Chassis" }
        23 { $ChassisName = "Rack Mount Chassis" }
        24 { $ChassisName = "Sealed-Case PC" }
        30 { $ChassisName = "Tablet" }
        31 { $ChassisName = "Convertible" }
        32 { $ChassisName = "Detachable" }
    }
    return $ChassisName
}