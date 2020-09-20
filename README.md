# PSInsight
- - - - 
PSInsight is a Powershell wrapper to interface with Jira's Insight API..


# Getting Started #
## Using PowershellGallery ##
```
Install-Module PSZoom
Import-Module PSZoom
```

## Using Git ##
Clone the repository.
```
git clone "https://github.com/AllElbows/PSInsight.git"
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
import-module PSInsight
$Global:InsightApiKey    = 'API_Key_Goes_Here'  
New-InsightObjectSchema -Name "MyObjSch" -ObjectSchemaKey "MOS" -Description "New Obj Sch"
```

# Available Functions #
Use get-help for more information about each function.

## Icons ##
Get-InsightIcons  

## Object Schema ##
Get-InsightObjectSchema
New-InsightObjectSchema
Remove-InsightObjectSchema
Set-InsightObjectSchema

## Object Type Attributes ##
Get-InsightObjectTypeAttributes
New-InsightObjectTypeAttributes
Remove-InsightObjectTypeAttributes
Set-InsightObjectTypeAttributes

## Object Types ##
Get-InsightObjectTypes
New-InsightObjectTypes
Remove-InsightObjectTypes
Set-InsightObjectTypes

## Objects ##
Get-InsightObject
New-InsightObject
New-InsightObjectAttribute
Remove-InsightObject
Set-InsightObject

## Statuses ##
Get-InsightStatuses
New-InsightStatuses
Remove-InsightStatuses
Set-InsightStatuses

## Private ##
New-InsightHeaders