#Used to check if modle is already installed and import if it is, else install.
function Test-Module ($Module) {

    # If the module is already imported, notify and then do nothing
    if (Get-Module | Where-Object {$_.Name -eq $Module}) {
        write-host "Module $Module is already imported."
    }
    else {

        # If the module is not imported but is available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $Module}) {
            Import-Module $Module -Verbose
        }
        else {

            # If the module is not imported\available on the disk but is in online gallery then install and then import
            if (Find-Module -Name $Module | Where-Object {$_.Name -eq $Module}) {
                Install-Module -Name $Module -Force -Verbose -Scope CurrentUser
                Import-Module $Module -Verbose
            }
            else {

                # If the module is not imported\available or found in the online gallery then notify and abort
                write-host "Module $Module not imported, not available and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}