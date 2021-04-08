function Build-Schema {
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [Array]$ObjectArray,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$InsightApiKey
    )
    
    foreach ($item in $ObjectArray) {
        try {
            $HashArguments = @{
                InsightApiKey = $InsightApiKey
            }
            $ObjectSchema = Get-InsightObjectSchema @HashArguments | Where-Object { $_.name -like $item.ObjectSchemaName }
            if (!($ObjectSchema)) {
                throw 'Object Schema not found'
            }
        }
        catch {
            $HashArguments = @{
                Name            = $item.ObjectSchemaName
                ObjectSchemaKey = $item.ObjectSchemaKey
                Description     = $item.ObjectSchemaDescription
                InsightApiKey   = $InsightApiKey
            }
            $ObjectSchema = New-InsightObjectSchema @HashArguments
            Write-Verbose 'Object Schema has been created'
        }
        $ObjectSchema
    }
    
}