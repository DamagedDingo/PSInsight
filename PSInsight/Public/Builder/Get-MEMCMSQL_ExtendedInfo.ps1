function Get-MEMCMSQL_ExtendedInfo {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [array]$Devices,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$SQLServer,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Database
    )
    
    begin {
        #Test-Module 'PSInsight'
        Test-Module 'SQLServer'
        #Test-Module 'Join-Object'

        # Grab SQL Data
        $Connection = @{
            ServerInstance = $SQLServer
            Database = $Database
        }
        $v_GS_COMPUTER_SYSTEM   = Invoke-Sqlcmd @Connection -Query 'Select * From v_GS_COMPUTER_SYSTEM'
        $v_GS_PHYSICAL_MEMORY   = Invoke-Sqlcmd @Connection -Query 'Select * From v_GS_PHYSICAL_MEMORY'
        $v_GS_DISK              = Invoke-Sqlcmd @Connection -Query 'Select * From v_GS_DISK'
        $v_GS_OPERATING_SYSTEM  = Invoke-Sqlcmd @Connection -Query 'Select * From v_GS_OPERATING_SYSTEM'
        $v_GS_LOGICAL_DISK      = Invoke-Sqlcmd @Connection -Query 'Select ResourceID,Size0,FreeSpace0 From v_GS_LOGICAL_DISK'
        $v_GS_SYSTEM_ENCLOSURE  = Invoke-Sqlcmd @Connection -Query 'Select ResourceID,ChassisTypes0 From v_GS_SYSTEM_ENCLOSURE'
        $v_GS_X86_PC_MEMORY     = Invoke-Sqlcmd @Connection -Query 'Select ResourceID,TotalPhysicalMemory0 From v_GS_X86_PC_MEMORY'
        $v_GS_VIRTUAL_MACHINE   = Invoke-Sqlcmd @Connection -Query 'Select * From v_GS_VIRTUAL_MACHINE'
        
        # Progress bar if running interactively 
        if ([Environment]::UserInteractive -eq $true) {
            $DeviceCount = $Devices.count
            $i = 0
        }
    }
    
    process {
        ForEach ($Device in $Devices) {

            if ($DeviceCount) {
                $Percentage = [math]::Round($(($i / $DeviceCount)*100),2)
        
                $Progress = @{
                    Activity = "Building Computer Objects"
                    Status = "$Percentage% Complete:"
                    PercentComplete = $Percentage
                }
                # add SecondsRemaining
                Write-Progress @Progress
                $i++
            }
            
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_COMPUTER_SYSTEM' -Value $($v_GS_COMPUTER_SYSTEM | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_PHYSICAL_MEMORY' -Value $($v_GS_PHYSICAL_MEMORY | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_OPERATING_SYSTEM' -Value $($v_GS_OPERATING_SYSTEM | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_MAPPEDDRIVES640' -Value $($v_GS_MAPPEDDRIVES640 | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_DISK' -Value $($v_GS_DISK | Where { $_.ResourceID -like $Device.ResourceID }) -Force
        
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_LOGICAL_DISK' -Value $($v_GS_LOGICAL_DISK | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_SYSTEM_ENCLOSURE' -Value $($v_GS_SYSTEM_ENCLOSURE | Where { $_.ResourceID -like $Device.ResourceID }) -Force
            $Device | Add-Member -MemberType NoteProperty -Name 'v_GS_X86_PC_MEMORY' -Value $($v_GS_X86_PC_MEMORY | Where { $_.ResourceID -like $Device.ResourceID }) -Force
        
            if ($Device.v_GS_SYSTEM_ENCLOSURE.ChassisTypes0) {
                $ChassisName = Convert-ChassisType $Device.v_GS_SYSTEM_ENCLOSURE.ChassisTypes0
            }
            
            $Object = [PSCustomObject]@{
                "Hostname" = $Device.Name
                "ResourceID" = $Device.ResourceID
                "Domain" = $Device.Domain
                "IsVirtualMachine" = $Device.IsVirtualMachine
                "LastHardwareScan" = $Device.LastHardwareScan
                "LastLogonUser" = $Device.LastLogonUser
                "PrimaryUser" = $Device.PrimaryUser
                "MACAddress" = $Device.MACAddress
                
                # v_GS_COMPUTER_SYSTEM
                "Manufacturer" = $Device.v_GS_COMPUTER_SYSTEM.Manufacturer0
                "Model" = $Device.v_GS_COMPUTER_SYSTEM.Model0
                "TotalPhysicalMemory" = $Device.v_GS_COMPUTER_SYSTEM.TotalPhysicalMemory0
        
                # v_GS_SYSTEM_ENCLOSURE
                "ChassisTypes" = $ChassisName
        
                # v_GS_OPERATING_SYSTEM  
                "Caption" = $Device.v_GS_OPERATING_SYSTEM.Caption0
                "CSDVersion" = $Device.v_GS_OPERATING_SYSTEM.CSDVersion0
                "InstallDate" = $Device.v_GS_OPERATING_SYSTEM.InstallDate0
                "OSArchitecture" = $Device.v_GS_OPERATING_SYSTEM.OSArchitecture0
                "Version" = $Device.v_GS_OPERATING_SYSTEM.Version0
        
                # v_GS_PHYSICAL_MEMORY - Physical Memory (Desktop?)
                "DeviceLocator" = $Device.v_GS_PHYSICAL_MEMORY.DeviceLocator0
                "FormFactor" = $Device.v_GS_PHYSICAL_MEMORY.FormFactor0
                "Capacity" = $Device.v_GS_PHYSICAL_MEMORY.Capacity0
                "Speed" = $Device.v_GS_PHYSICAL_MEMORY.Speed0
        
                # $v_GS_X86_PC_MEMORY
                "TotalPhysicalMemory0" = $Device.v_GS_X86_PC_MEMORY.TotalPhysicalMemory0
        
                # v_GS_DISK - Disk (Desktop?)
                "Disk_Caption" = $Device.v_GS_DISK.Caption0
                "Disk_DeviceID" = $Device.v_GS_DISK.DeviceID0
                "Disk_InterfaceType" = $Device.v_GS_DISK.InterfaceType0
                "Disk_Manufacturer" = $Device.v_GS_DISK.Manufacturer0
                "Disk_MediaType" = $Device.v_GS_DISK.MediaType0
                "Disk_Model" = $Device.v_GS_DISK.Model0
        
                # v_GS_LOGICAL_DISK
                "Disk_Size" = $Device.v_GS_LOGICAL_DISK.Size0
                "Disk_FreeSpace" = $Device.v_GS_LOGICAL_DISK.FreeSpace0
        
            }
            $Object
            }
    }
    
    end {
        
    }
}