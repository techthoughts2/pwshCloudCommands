<#
.SYNOPSIS
    Searches for PowerShell cloud commands matching a given query.
.DESCRIPTION
    This function searches a dynamically updated cache of PowerShell cloud commands,
    returning results that match specific criteria. The nature of the search depends on the type of query:
        - Function Name Query: Directly uses the function name format (Verb-Noun).
        - Wildcard Query: Utilizes wildcards (e.g., Ve*-Noun) for broader searches.
        - Free-form Query: Handles any other text as a general search term.
    The efficiency of queries follows this order: function name, wildcard, then free-form.
    Specifying a cloud platform (AWS/Azure/Oracle) enhances performance, especially for free-form queries.
    By default, free-form queries return the top 30 results; use the -AllResults parameter to retrieve all matches.
.EXAMPLE
    Find-CloudCommand -Query Write-S3Object -Filter AWS

    Searches for the 'Write-S3Object' function specifically within AWS services.
.EXAMPLE
    Find-CloudCommand -Query New-OCIComputeInstance -Filter Oracle

    Looks for the 'New-OCIComputeInstance' function within Oracle cloud services.
.EXAMPLE
    Find-CloudCommand -Query New-MLDataSourceFromRedshift

    Searches for 'New-MLDataSourceFromRedshift' across all cloud platforms.
.EXAMPLE
    Find-CloudCommand -Query New*VM* -Filter Azure

    Performs a wildcard search for VM-related functions within Azure.
.EXAMPLE
    Find-CloudCommand -Query Get*WAF*

    Uses a wildcard search for WAF-related functions across all platforms.
.EXAMPLE
    Find-CloudCommand -Query 'I want to create a new compute instance' -Filter Oracle

    Conducts a free-form search related to compute instances in Oracle cloud.
.EXAMPLE
    Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS -AllResults

    Executes a comprehensive free-form search for downloading objects from S3 in AWS.
.PARAMETER Query
    Search input for PowerShell cloud commands.
.PARAMETER Filter
    Filters the search to a specific cloud platform (AWS/Azure/Oracle).
.PARAMETER AllResults
    Retrieves all search results without limiting the number.
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
            HelpMessage = 'Search input for PowerShell cloud commands.')]
        [ValidateLength(3, 60)]
        [string]
        $Query,

        [Parameter(Mandatory = $false,
            Position = 1,
            HelpMessage = 'Filters the search to a specific cloud platform')]
        [ValidateSet('AWS', 'Azure', 'Oracle')]
        [string]
        $Filter,

        [Parameter(Mandatory = $false,
            Position = 2,
            HelpMessage = 'Retrieves all search results without limiting the number')]
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
