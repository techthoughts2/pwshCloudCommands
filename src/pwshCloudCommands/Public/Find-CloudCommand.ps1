<#
.SYNOPSIS
    Finds PowerShell cloud command(s) that match the provided query.
.DESCRIPTION
    Performs query search on a dynamically updated cache of known PowerShell cloud commands.
    Results are returned based on provided criteria.
    Based on the query provided, a different form of search is performed.
    If a function name is provided (Verb-Noun), a function name query is performed.
    If a wildcard is provided (Ve*-Noun), a wildcard query is performed.
    Anything else is treated as a free-form query.
    Order of query efficiency is:
    1. Function name query
    2. Wildcard query
    3. Free-form query
    Query performance will also be greatly increased if you filter to the specific cloud platform you are using (AWS/Azure/Oracle).
    Free-form queries can generate many results and by default only the top 30 results are returned.
    Use the -AllResults parameter with free-form queries to return all results.
.EXAMPLE
    Find-CloudCommand -Query Write-S3Object -Filter AWS

    Search for a specific function name (Verb-Noun) and filter to AWS.
.EXAMPLE
    Find-CloudCommand -Query New-OCIComputeInstance -Filter Oracle

    Search for a specific function name (Verb-Noun) and filter to Oracle.
.EXAMPLE
    Find-CloudCommand -Query New-MLDataSourceFromRedshift

    Search for a specific function name (Verb-Noun) against all cloud platforms.
.EXAMPLE
    Find-CloudCommand -Query New*VM* -Filter Azure

    Wildcard function search that is filtered to Azure.
.EXAMPLE
    Find-CloudCommand -Query Get*WAF*

    Wildcard function search against all cloud platforms.
.EXAMPLE
    Find-CloudCommand -Query 'I want to create a new compute instance' -Filter Oracle

    Free-form query that is filtered to Oracle.
.EXAMPLE
    Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS -AllResults

    Free-form query that is filtered to AWS and returns all results.
.PARAMETER Query
    PowerShell cloud command search input
.PARAMETER Filter
    Filter results to specific cloud platform (AWS/Azure/Oracle)
.PARAMETER AllResults
    Return all results, regardless of the number of results returned
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
.LINK
    https://docs.aws.amazon.com/powershell/latest/reference/
.LINK
    https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md
.LINK
    https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershell.htm
#>
function Find-CloudCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'PowerShell cloud command search input')]
        [ValidateLength(3, 60)]
        [string]
        $Query,

        [Parameter(Mandatory = $false,
            Position = 1,
            HelpMessage = 'Filter results to specific cloud platform')]
        [ValidateSet('AWS', 'Azure', 'Oracle')]
        [string]
        $Filter,

        [Parameter(Mandatory = $false,
            Position = 2,
            HelpMessage = 'Return all results')]
        [switch]
        $AllResults
    )

    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    $dataSet = Invoke-XMLDataCheck
    if ($dataSet -ne $true) {
        Write-Warning -Message 'pwshCloudCommands was unable to source the required data set files.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    }

    Write-Verbose 'Determining query type...'
    if ($Query -match '^(\w+-\w+)$') {
        Write-Verbose -Message 'Query is a valid function name.'
        $queryType = 'function'
        $searchXMLDataSetSplat = @{
            FunctionQuery = $Query
        }
    }
    elseif ($Query -match '^\w.*\*.*$' -or $Query -match '^\*.*\w.*$') {
        Write-Verbose -Message 'Query is a wildcard function search.'
        $queryType = 'wildcard'
        $searchXMLDataSetSplat = @{
            WildCardQuery = $Query
        }
    }
    else {
        Write-Verbose -Message 'Free form query. Optimizing query input'
        $queryType = 'freeform'
        $cleanInput = Optimize-Input -SearchInput $Query
        $searchXMLDataSetSplat = @{
            Query = $cleanInput
        }
    }
    if ($Filter) {
        $searchXMLDataSetSplat.Add('Filter', $Filter)
    }

    Write-Verbose ($searchXMLDataSetSplat | Out-String)

    $results = Search-XMLDataSet @searchXMLDataSetSplat
    if ($queryType -eq 'freeform' -and $AllResults -eq $false) {
        $results = $results | Sort-Object MatchScore -Descending | Select-Object -First 30
    }

    return $results | Sort-Object MatchScore -Descending

} #Find-CloudCommand
