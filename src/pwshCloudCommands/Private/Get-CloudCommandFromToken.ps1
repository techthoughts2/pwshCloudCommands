<#
.SYNOPSIS
    Initiates FunctionQuery against XML dataset for each discovered PowerShell function token.
.DESCRIPTION
    Takes in a collection of discovered tokens from file.
    Parses tokens for PowerShell function names.
    Initiates FunctionQuery against XML dataset for each discovered PowerShell function token.
    Returns search results.
.EXAMPLE
    Get-CloudCommandFromToken -Tokens $tokens

    Initiates FunctionQuery search for each discovered PowerShell function token.
.PARAMETER Tokens
    A collection of discovered tokens from file.
.OUTPUTS
    Deserialized.System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Get-CloudCommandFromToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'A collection of discovered tokens from file')]
        [psobject]
        $Tokens
    )

    $results = [System.Collections.ArrayList]::new()

    foreach ($token in $Tokens) {
        if ($token.Type -ne 'Command' -or $token.Content -notlike '*-*') {
            continue
        }
        # -----------------------
        # resets
        $search = $null
        # -----------------------
        $search = Search-XMLDataSet -FunctionQuery $token.Content
        if ($null -ne $search) {
            [void]$results.Add($search)
        }
    } #foreach_token

    return $results

} #Get-CloudCommandFromToken
