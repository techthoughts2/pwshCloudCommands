<#
.SYNOPSIS
    Evaluates PowerShell files in specified path and identifies a list of PowerShell cloud functions and their associated modules.
.DESCRIPTION
    Discovers all PowerShell files in the specified path.
    Parses each file and identifies all PowerShell cloud functions and their associated modules.
.EXAMPLE
    $psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
    $psCloud

    Returns a list of PowerShell cloud functions and their associated modules found in files in the specified path.
.EXAMPLE
    $psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
    $psCloud.CloudCommands.ModuleName | Select-Object -Unique

    Returns a list of unique module names found in use in files in the specified path.
.PARAMETER Path
    File or Folder Path to evaluate.
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Get-CloudCommandFromFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'File or Folder Path to evaluate')]
        [string]
        $Path
    )

    Write-Verbose -Message 'Verifying XML Data Set Availability...'
    $dataSet = Invoke-XMLDataCheck
    if ($dataSet -ne $true) {
        Write-Warning -Message 'pwshCloudCommands was unable to source the required data set files.'
        Write-Warning -Message 'Ensure you have an active internet connection'
        return
    }

    try {
        $target = Get-Item -Path $Path -ErrorAction 'Stop'
    }
    catch {
        Write-Error $_
        throw
    }

    if ($target.PSIsContainer -eq $true) {
        $pwshFileInfo = Get-AllPowerShellFile -Path $Path
        if (-not ($pwshFileInfo)) {
            Write-Warning -Message ('No PowerShell files found at {0}' -f $Path)
            return
        }
    }
    else {
        try {
            $pwshFileInfo = Get-ChildItem -Path $Path -ErrorAction 'Stop'
        }
        catch {
            Write-Error $_
            throw
        }
        if ($pwshFileInfo.Extension -ne '.ps1') {
            Write-Warning -Message ('{0} is not a PowerShell file.' -f $pwshFileInfo.Name)
            return
        }
    }

    $results = [System.Collections.ArrayList]::new()

    foreach ($file in $pwshFileInfo) {
        # ----------------------------
        # resets
        $tokens = $null
        $cloudCommands = $null
        $fileResults = $null
        # ----------------------------
        $tokens = Read-TokenCommandsFromFile -FilePath $file.FullName
        $cloudCommands = Get-CloudCommandFromToken -Tokens $tokens
        if ($cloudCommands) {
            $fileResults = Format-FileFinding -CloudCommandObj $cloudCommands -FileInfo $file

            $obj = New-Object PSObject -Property ([ordered]@{
                    FileName      = $file.Name
                    CloudCommands = $fileResults
                })#psobject
            [void]$results.Add($obj)
        }
    } #foreach_file

    return $results

} #Get-CloudCommandFromFile
