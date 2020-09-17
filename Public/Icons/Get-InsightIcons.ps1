<#

.SYNOPSIS
Resource to find global Icons in Insight.

.DESCRIPTION
Resource to find global Icons in Insight.

.PARAMETER Full
If full switch is used then property url16 is returned

.PARAMETER InsightApiKey
The Api key.

.OUTPUTS
If switch 'Full' is used 
id name                 url16                                                                                                               
 -- ----                 -----                                                                                                               
  1 3D Printer           /rest/insight/1.0/icon/1/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLm...
  2 AV Receiver          /rest/insight/1.0/icon/2/icon.png?size=16&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjb20ucmlhZGFsYWJzLm...

if switch 'Full' is not used
id name                
 -- ----                
  1 3D Printer          
  2 AV Receiver         
  3 Active Directory    
  4 Administrative Tools
  5 Agreement

.LINK
https://documentation.mindville.com/display/ICV811/Icons+-+REST

.EXAMPLE
Get-InsightIcons -InsightApiKey $InsightApiKey

#>

function Get-InsightIcons {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Alias('ApiKey')]
        [string]$InsightApiKey,

        [switch]$Full = $False
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/icon/global"
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }

        if ($Full) {
            Write-Output $response
        }
        else {
            Write-Output $response | Select id,name
        }
    }
}