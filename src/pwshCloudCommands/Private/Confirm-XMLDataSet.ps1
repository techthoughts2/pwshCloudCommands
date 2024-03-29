<#
.SYNOPSIS
    Confirms the XML dataset file is available and not beyond the expiration time.
.DESCRIPTION
    Confirms the XML dataset file is present on the file system for use. Determines the age of the XML dataset file. Returns true if present and 9 days older or more.
.EXAMPLE
    Confirm-XMLDataSet

    Checks for XML dataset and determines if it is 9 days older or more.
.OUTPUTS
    System.Boolean
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Confirm-XMLDataSet {
    [CmdletBinding()]
    param (
    )
    $result = $true #assume the best
    $dataFile = '{0}/{1}' -f $script:dataPath, $script:dataFolderZip
    $dataExtract = '{0}/{1}' -f $script:dataPath, $script:dataFolder

    Write-Verbose -Message 'Confirming valid and current data set...'

    try {
        $pathEval = Test-Path -Path $dataFile -ErrorAction Stop
    }
    catch {
        $result = $false
        Write-Error $_
        return $result
    }

    if (-not ($pathEval)) {
        $result = $false
    } #if_pathEval
    else {
        Write-Verbose 'Data file found. Checking date of file...'
        try {
            $fileData = Get-ChildItem -Path $dataFile -ErrorAction Stop
        }
        catch {
            $result = $false
            Write-Error $_
            return $result
        }
        if ($fileData) {
            $creationDate = $fileData.LastWriteTime
            $now = Get-Date
            if (($now - $creationDate).Days -ge 9) {
                Write-Verbose 'Data file requires refresh.'
                $result = $false
            }
            else {
                Write-Verbose 'Data file verified'
                Write-Verbose 'Verifying extracted data set...'
                $dataSet = $null
                $dataSet = Get-ChildItem -Path $dataExtract -ErrorAction SilentlyContinue
                if ($null -eq $dataSet) {
                    Write-Verbose 'Extracted data set is missing.'
                    $result = $false
                    return $result
                }
            }
        } #if_fileData
        else {
            Write-Warning 'Unable to retrieve file information for pwshCloudCommands data set.'
            $result = $false
            return $result
        } #else_fileData
    } #else_pathEval

    return $result
} #Confirm-XMLDataSet
