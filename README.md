# PSInsight
- - - - 
PSInsight is a Powershell wrapper to interface with Jira Insight's [API](https://documentation.mindville.com/display/INSCLOUD/REST+API).

PSInsight can be used to build or modify the [Jira Insight](https://marketplace.atlassian.com/apps/1212137/insight-asset-management?hosting=cloud&tab=overview) schema or to add or modify assets within the asset management database.

Links to Insight API information for each function can be found under links via Get-Help

```
Get-Help Get-InsightObjectSchema
```

# Getting Started #
## Using PowershellGallery ##
```
Install-Module PSInsight
Import-Module PSInsight
```

## Using Git ##
Clone the repository.
```
git clone "https://github.com/DamagedDingo/PSInsight.git"
```
Place directory into a module directory (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules).
```
Move-Item -path ".\psinsight\psinsight" -Destination "$env:USERPROFILE\Documents\WindowsPowerShell\Modules"
```
Import the module.
```
Import-Module PSInsight
```

# Using your API Key #
Almost all commands require an API key.
  
For ease of use, each command looks for the variable automatically in the following order:  
    In the global scope for InsightApiKey  
    As passed as parameters to the command  
    As an AutomationVariable  
    A prompt to host to enter Key manually  

# Example Script #
```
The Examples folder contains samples on how to build the schema as well as object types.
The corrisponding JSON file will show how to structure the data for the builder scripts.
```

![Schema](https://i.imgur.com/NByWKhl.png)
![Attributes](https://i.imgur.com/GzvExXL.png)

# Available Functions #
Use get-help for more information about each function.

## Icons ##
```
Get-InsightIcons  
```
## Object Schema ##
```
Get-InsightObjectSchema
New-InsightObjectSchema
Remove-InsightObjectSchema
Set-InsightObjectSchema
```
## Object Type Attributes ##
```
Get-InsightObjectTypeAttributes
New-InsightObjectTypeAttributes
Remove-InsightObjectTypeAttributes
Set-InsightObjectTypeAttributes
```
## Object Types ##
```
Get-InsightObjectTypes
New-InsightObjectTypes
Remove-InsightObjectTypes
Set-InsightObjectTypes
```
## Objects ##
```
Get-InsightObject
New-InsightObject
New-InsightObjectAttribute
Remove-InsightObject
Set-InsightObject
```
## Statuses ##
```
Get-InsightStatuses
New-InsightStatuses
Remove-InsightStatuses
Set-InsightStatuses
```
## Build ##
These are custom functions to build out your Schema and ObjectTypes as per the example scripts.
```
Build-Schema
Build-ObjectTypes
```
## Private ##
```
New-InsightHeaders
Test-Module
```