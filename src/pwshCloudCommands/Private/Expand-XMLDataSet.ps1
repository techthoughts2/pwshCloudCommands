<#
.SYNOPSIS
    Unzips the XML data set.
.DESCRIPTION
    Evaluates for previous version of XML data set and removes if required. Expands the XML data set for use.
.EXAMPLE
    Expand-XMLDataSet

    Unzips and expands the XML data set.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Expand-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    $dataFolder = '{0}/{1}' -f $script:dataPath, $script:dataFolder

    Write-Verbose -Message 'Testing if data set folder already exists...'
    try {
        $pathEval = Test-Path -Path $dataFolder -ErrorAction Stop
        Write-Verbose -Message "EVAL: $true"
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if ($pathEval) {
        Write-Verbose -Message 'Removing existing data set folder...'
        try {
            $removeItemSplat = @{
                Force       = $true
                Path        = $dataFolder
                Recurse     = $true
                ErrorAction = 'Stop'
            }
            Remove-Item @removeItemSplat
        } #try
        catch {
            $result = $false
            Write-Error $_
            return $result
        } #catch
    } #if_pathEval

    Write-Verbose -Message 'Expanding data set archive...'
    try {
        $expandArchiveSplat = @{
            DestinationPath = '{0}/{1}' -f $script:dataPath, $script:dataFolder
            Force           = $true
            ErrorAction     = 'Stop'
            Path            = '{0}/{1}' -f $script:dataPath, $script:dataFolderZip
        }
        $null = Expand-Archive @expandArchiveSplat
        Write-Verbose -Message 'Expand completed.'
    } #try
    catch {
        $result = $false
        Write-Error $_
    } #catch

    return $result
} #Expand-XMLDataSet
