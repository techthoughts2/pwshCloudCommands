<#
.SYNOPSIS
    Returns module and function information for all known PowerShell cloud commands.
.DESCRIPTION
    Returns results from the entire PowerShell cloud command catalog.
    It is recommended to use the Filter parameter to reduce the size of the result set.
.EXAMPLE
    Get-AllCloudCommandInfo -Filter AWS

    Returns module and function information of all known AWS PowerShell cloud commands.
.EXAMPLE
    Get-AllCloudCommandInfo

    Returns module and function information of all known PowerShell cloud commands.
.PARAMETER Filter
    Filter results to specific cloud platform (AWS/Azure/Oracle)
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
            HelpMessage = 'Filter results to specific cloud platform')]
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
