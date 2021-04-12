function Connect-MEMCM {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Server,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$SiteCode
    )

    $initParams = @{}

    # Import the ConfigurationManager.psd1 module 
    if((Get-Module ConfigurationManager) -eq $null) {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
    }

    # Connect to the site's drive if it is not already present
    if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $Server @initParams
    }

    # Set the current location to be the site 
    Set-Location "$($SiteCode):\" @initParams
}
