#Used to check if modle is already installed and import if it is, else install.
function Test-Module {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Module
    )

    # If the module is already imported, notify and then do nothing
    if (Get-Module | Where-Object { $_.Name -eq $Module }) {
        
        if ($(Get-Module $Module).Version -notlike $((Find-Module $Module).version)) {
            try {
                Update-Module $Module -Force
                Write-Verbose "$Module was found on disk and updated to latest version"
                Remove-Module $Module
                Import-Module $Module
            }
            catch {
                Write-Verbose "Failed to update $Module"
            }
        }
        else {
            Write-Verbose "$Module already imported and latest version"
            Import-Module $Module
        }

    }
    else {
        # If the module is not imported but is available on disk then import
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $Module }) {

            if ((Get-Module -ListAvailable | Where-Object { $_.Name -eq $Module }).version -notlike $((Find-Module $Module).version)) {
                    try {
                        Update-Module $Module -Force
                        Write-Verbose "$Module was found on disk and updated to latest version"
                        Import-Module $Module
                        Write-Verbose "$Module was imported"
                    }
                    catch {
                        Write-Verbose "Failed to import $Module"
                    }
                }
                else {
                    try {
                        Import-Module $Module
                        Write-Verbose "$Module was imported"
                    }
                    catch {
                        Write-Verbose "Failed to import $Module"
                    }
                }
            }
        else {

            # If the module is not imported\available on the disk but is in online gallery then install and then import
            if (Find-Module -Name $Module | Where-Object { $_.Name -eq $Module }) {
                
                try {
                    Install-Module -Name $Module -Force -Verbose -Scope CurrentUser
                    Write-Verbose "$Module was downloaded from Repo and installed"
                    Import-Module $Module -Verbose
                }
                catch {
                    Write-Verbose "Failed to download $Module from Repo"
                }
            }
            else {
                # If the module is not imported\available or found in the online gallery then notify and abort
                Write-Verbose "Module $Module not imported, not available, and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}