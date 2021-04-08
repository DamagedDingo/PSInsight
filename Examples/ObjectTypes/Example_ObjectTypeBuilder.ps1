$SchemaID = $(Get-InsightObjectSchema | Where { $_.name -eq 'CompanyName'}).id
$JSONpath = '.\PSInsight\Examples'
$Objects = Get-Content "$JSONpath\ObjectTypes.json" -Raw | ConvertFrom-Json
Build-ObjectType -ObjectArray $Objects -SchemaID $SchemaID -InsightApiKey ''