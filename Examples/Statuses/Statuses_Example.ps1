$Global:InsightApiKey = Get-Secret -Name 'Insight_API' -AsPlainText

$Statuses = Get-Content -Raw -Path "PSInsight\Examples\Statuses\Statuses.Json" | ConvertFrom-Json

foreach ($Status in $Statuses) {
    New-InsightStatuses -Name $Status.name -Category $Status.category -Description $Status.description -InsightApiKey $InsightApiKey
}
