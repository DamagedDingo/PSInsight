Test-Module PSInsight

$SchemaName = 'CompanyName'
$Global:InsightApiKey = Get-Secret -Name 'Insight_API' -AsPlainText
$SchemaID = $(Get-InsightObjectSchema -InsightApiKey $InsightApiKey | Where { $_.name -eq $SchemaName}).id
$JSONpath = '.\PSInsight\Examples\ObjectTypes'
$Objects = Get-Content -Path "$JSONpath\ObjectTypes.json" -Raw | ConvertFrom-Json
Build-ObjectType -ObjectArray $Objects -SchemaID $SchemaID -InsightApiKey $InsightApiKey