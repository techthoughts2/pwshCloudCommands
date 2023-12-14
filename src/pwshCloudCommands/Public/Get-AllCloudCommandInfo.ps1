<#
.SYNOPSIS
    Returns detailed module and function information on all available PowerShell cloud commands.
.DESCRIPTION
    This function provides comprehensive details on modules and functions from the entire catalog
    of PowerShell cloud commands. To manage the volume of data returned, it's advisable to use the
    'Filter' parameter to focus on a specific cloud provider's commands.
.EXAMPLE
    Get-AllCloudCommandInfo -Filter AWS

    Retrieves a complete list of modules and functions for AWS-specific PowerShell cloud commands.
.EXAMPLE
    Get-AllCloudCommandInfo

    Returns information on all available PowerShell cloud commands across various cloud platforms.
.PARAMETER Filter
    Filters the search to a specific cloud platform (AWS/Azure/Oracle).
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Get-AllCloudCommandInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            Position = 0,
            HelpMessage = 'Filters the search to a specific cloud platform')]
        [ValidateSet('AWS', 'Azure', 'Oracle')]
        [string]
        $Filter
    )

    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    $dataSet = Invoke-XMLDataCheck
    if ($dataSet -ne $true) {
        Write-Warning -Message 'pwshCloudCommands was unable to source the required data set files.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    }

    $searchXMLDataSetSplat = @{
        AllInfo = $true
    }
    if ($Filter) {
        $searchXMLDataSetSplat.Add('Filter', $Filter)
    }

    Write-Verbose ($searchXMLDataSetSplat | Out-String)

    $results = Search-XMLDataSet @searchXMLDataSetSplat

    return $results

} #Get-AllCloudCommandInfo
