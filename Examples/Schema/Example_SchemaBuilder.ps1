Test-Module PSInsight

$Global:InsightApiKey = Get-Secret -Name 'Insight_API' -AsPlainText
$JSONpath = '.\PSInsight\Examples\Schema'
$Schema = Get-Content "$JSONpath\Schema.json" -Raw | ConvertFrom-Json
Build-Schema -ObjectArray $Schema -InsightApiKey $InsightApiKey