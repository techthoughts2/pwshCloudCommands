<#
.SYNOPSIS
    Retrieves all PowerShell files from specified path
.DESCRIPTION
    Retrieves all Get-ChildItem information with a ps1 filter from the specified path.
.EXAMPLE
    Get-AllPowerShellFile -Path "$env:HOME\pathToEvaluate"

    Retrieves all PowerShell files from specified path
.PARAMETER Path
    Path to search for PowerShell files
.OUTPUTS
    System.IO.FileInfo
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Get-AllPowerShellFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'Path to search for PowerShell files')]
        [string]$Path
    )

    Write-Verbose -Message ('Retrieving PowerShell files from {0} ' -f $Path)
    $getChildItemSplat = @{
        Path        = $Path
        Filter      = '*.ps1'
        Recurse     = $true
        Force       = $true
        ErrorAction = 'SilentlyContinue'
    }
    $psFiles = Get-ChildItem @getChildItemSplat

    return $psFiles

} #Get-AllPowerShellFile
