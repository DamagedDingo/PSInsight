#Required Modules
Test-Module "PSInsight"
Test-Module "SQLServer"
Test-Module "Join-Object"

$CollectionName = "All Desktops"

# Site configuration and database
$Server = "" # SMS Provider machine name
$SCCMDB = "CM_001" # Database name
$SiteCode = "001" # Site code 

if(($host.Name -match 'consolehost')) {$true}

# Connect to SCCM
$initParams = @{}
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $Server @initParams
}
Set-Location "$($SiteCode):\" @initParams

# Get list of computers
$Desktops = Get-CMCollectionMember -CollectionName $CollectionName | Select Name,ResourceID,CoManaged,DeviceOS,DeviceOSBuild,Domain,IsVirtualMachine,LastHardwareScan,LastLogonUser,MACAddress,PrimaryUser

# Get computer information from SCCM SQL
$v_GS_COMPUTER_SYSTEM = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_COMPUTER_SYSTEM"
$v_GS_PHYSICAL_MEMORY = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_PHYSICAL_MEMORY"
$v_GS_MAPPEDDRIVES640 = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_MAPPEDDRIVES640"
$v_GS_DISK = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_DISK"
$v_GS_OPERATING_SYSTEM = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_OPERATING_SYSTEM"
$v_GS_LOGICAL_DISK = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select ResourceID,Size0,FreeSpace0 From v_GS_LOGICAL_DISK"
$v_GS_SYSTEM_ENCLOSURE = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select ResourceID,ChassisTypes0 From v_GS_SYSTEM_ENCLOSURE"
$v_GS_X86_PC_MEMORY = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select ResourceID,TotalPhysicalMemory0 From v_GS_X86_PC_MEMORY"
$v_GS_VIRTUAL_MACHINE = Invoke-Sqlcmd -ServerInstance $Server -Database $SCCMDB -Query "Select * From v_GS_VIRTUAL_MACHINE"

if ([Environment]::UserInteractive -eq $true) {
    $DesktopCount = $Desktops.count
    $i = 0
}


$Assets = ForEach ($Desktop in $Desktops) {

    if ($DesktopCount) {
        $Percentage = [math]::Round($(($i / $DesktopCount)*100),2)

        $Progress = @{
            Activity = "Building Computer Objects"
            Status = "$Percentage% Complete:"
            PercentComplete = $Percentage
        }
        # add SecondsRemaining
        Write-Progress @Progress
        $i++
    }
    

    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_COMPUTER_SYSTEM' -Value $($v_GS_COMPUTER_SYSTEM | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_PHYSICAL_MEMORY' -Value $($v_GS_PHYSICAL_MEMORY | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_OPERATING_SYSTEM' -Value $($v_GS_OPERATING_SYSTEM | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_MAPPEDDRIVES640' -Value $($v_GS_MAPPEDDRIVES640 | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_DISK' -Value $($v_GS_DISK | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force

    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_LOGICAL_DISK' -Value $($v_GS_LOGICAL_DISK | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_SYSTEM_ENCLOSURE' -Value $($v_GS_SYSTEM_ENCLOSURE | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force
    $desktop | Add-Member -MemberType NoteProperty -Name 'v_GS_X86_PC_MEMORY' -Value $($v_GS_X86_PC_MEMORY | Where { $_.ResourceID -like $Desktop.ResourceID }) -Force


    switch ($Desktop.v_GS_SYSTEM_ENCLOSURE.ChassisTypes0) {

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
        Default { $ChassisName = "" }
    }

    $Asset = [PSCustomObject]@{
        "Hostname" = $desktop.Name
        "ResourceID" = $desktop.ResourceID
        "Domain" = $desktop.Domain
        "IsVirtualMachine" = $desktop.IsVirtualMachine
        "LastHardwareScan" = $desktop.LastHardwareScan
        "LastLogonUser" = $desktop.LastLogonUser
        "PrimaryUser" = $desktop.PrimaryUser
        "MACAddress" = $desktop.MACAddress
        
        # v_GS_COMPUTER_SYSTEM
        "Manufacturer" = $Desktop.v_GS_COMPUTER_SYSTEM.Manufacturer0
        "Model" = $Desktop.v_GS_COMPUTER_SYSTEM.Model0
        "TotalPhysicalMemory" = $Desktop.v_GS_COMPUTER_SYSTEM.TotalPhysicalMemory0

        # v_GS_SYSTEM_ENCLOSURE
        "ChassisTypes" = $ChassisName
        "ChassisTypesCode" = $Desktop.v_GS_SYSTEM_ENCLOSURE.ChassisTypes0

        # v_GS_OPERATING_SYSTEM  
        "Caption" = $Desktop.v_GS_OPERATING_SYSTEM.Caption0
        "CSDVersion" = $Desktop.v_GS_OPERATING_SYSTEM.CSDVersion0
        "InstallDate" = $Desktop.v_GS_OPERATING_SYSTEM.InstallDate0
        "OSArchitecture" = $Desktop.v_GS_OPERATING_SYSTEM.OSArchitecture0
        "Version" = $Desktop.v_GS_OPERATING_SYSTEM.Version0

        # v_GS_PHYSICAL_MEMORY - Physical Memory (Desktop?)
        "DeviceLocator" = $Desktop.v_GS_PHYSICAL_MEMORY.DeviceLocator0
        "FormFactor" = $Desktop.v_GS_PHYSICAL_MEMORY.FormFactor0
        "Capacity" = $Desktop.v_GS_PHYSICAL_MEMORY.Capacity0
        "Speed" = $Desktop.v_GS_PHYSICAL_MEMORY.Speed0

        # $v_GS_X86_PC_MEMORY
        "TotalPhysicalMemory0" = $Desktop.v_GS_X86_PC_MEMORY.TotalPhysicalMemory0

        # v_GS_DISK - Disk (Desktop?)
        "Disk_Caption" = $desktop.v_GS_DISK.Caption0
        "Disk_DeviceID" = $desktop.v_GS_DISK.DeviceID0
        "Disk_InterfaceType" = $desktop.v_GS_DISK.InterfaceType0
        "Disk_Manufacturer" = $desktop.v_GS_DISK.Manufacturer0
        "Disk_MediaType" = $desktop.v_GS_DISK.MediaType0
        "Disk_Model" = $desktop.v_GS_DISK.Model0

        # v_GS_LOGICAL_DISK
        "Disk_Size" = $desktop.v_GS_LOGICAL_DISK.Size0
        "Disk_FreeSpace" = $desktop.v_GS_LOGICAL_DISK.FreeSpace0

        # v_GS_MAPPEDDRIVES640ISK - Mapped Drives
        "DriveLetter" = $desktop.v_GS_MAPPEDDRIVES640.DriveLetter0
        "ShareName" = $desktop.v_GS_MAPPEDDRIVES640.ShareName0
        "UserDomain" = $desktop.v_GS_MAPPEDDRIVES640.UserDomain0
        "UserName" = $desktop.v_GS_MAPPEDDRIVES640.UserName0

    }
    $Asset
    }

    