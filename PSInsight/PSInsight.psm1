$Public  = @(Get-ChildItem -Path "$PSScriptRoot\Public\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\" -include '*.ps1' -recurse -ErrorAction SilentlyContinue)

foreach ($ps1 in @($Public + $Private)) {
    try {
        . $ps1.fullname
    } catch {
        Write-Error -Message "Failed to import function $($ps1.fullname): $_"
    }
}

# Load up dependency modules
foreach($ps1 in $Private)
{
    Try
    {
        Import-Module $ps1 -ErrorAction Stop
    }
    Catch
    {
        Write-Error "Failed to import module $ps1`: $_"
    }
}

Export-ModuleMember -Function $Public.Basename