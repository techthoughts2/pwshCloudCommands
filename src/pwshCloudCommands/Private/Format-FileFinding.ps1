<#
.SYNOPSIS
    Processes discovered cloud commands and returns formatted results in a PSCustomObject format.
.DESCRIPTION
    This function is called to process discovered cloud commands found in files.
    The function is passed a PSCustomObject that contains the discovered cloud command.
    Findings are organized by module name, function, and file found in.
    The function returns a PSCustomObject that contains the formatted results.
.EXAMPLE
    Format-FileFinding -CloudCommandObj $cloudCommands -FileInfo $fileInfo
.PARAMETER CloudCommandObj
    Object that contains the discovered cloud command(s).
.PARAMETER FileInfo
    Object containing the file information that cloud command discovery was done on.
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

    ModuleName                        Name
    ----------                        ----
    AWS.Tools.SimpleSystemsManagement Get-SSMDocumentList
    AWS.Tools.SimpleSystemsManagement Get-SSMDocumentList
    AWS.Tools.EC2                     Start-EC2Instance
    AWS.Tools.S3                      Get-S3Bucket
    Az.Accounts                       Connect-AzAccount
    Az.Accounts                       Set-AzContext
    Az.Resources                      Get-AzResourceGroup
.COMPONENT
    pwshCloudCommands
#>
function Format-FileFinding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Object that contains the discovered cloud commands')]
        [psobject]
        $CloudCommandObj,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Object containing the file information that cloud command discovery was done on')]
        [psobject]
        $FileInfo
    )

    $results = [System.Collections.ArrayList]::new()

    $uniqueModuleNames = $CloudCommandObj | Select-Object -ExpandProperty ModuleName -Unique

    foreach ($module in $uniqueModuleNames) {
        $uniqueFunctions = $cloudCommands | Where-Object {
            $_.ModuleName -eq $module
        } | Select-Object -ExpandProperty Name -Unique
        $obj = [PSCustomObject]@{
            ModuleName = $module
            Functions  = $uniqueFunctions
            FileName   = $FileInfo.Name
            FilePath   = $FileInfo.FullName
        }
        [void]$results.Add($obj)
    } #foreach_module

    return $results
} #Format-FileFinding
