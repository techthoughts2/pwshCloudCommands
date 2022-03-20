<#
.SYNOPSIS
    Parses the given file and returns a list of all the command and command arguments tokens.
.DESCRIPTION
    Gets contents of specified file and parses it into a list of tokens.
    Command and command arguments tokens are returned.
.EXAMPLE
    Read-TokenCommandsFromFile -FilePath $file.FullName

    Returns all the command and command arguments tokens in the specified file.
.PARAMETER FilePath
    Path to file
.OUTPUTS
    System.Management.Automation.PSToken
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Read-TokenCommandsFromFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Path to file')]
        [string]
        $FilePath
    )

    if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
        Write-Warning -Message ('{0} is not a valid file path.' -f $FilePath)
        throw $_
    }

    $getContentSplat = @{
        Path        = $FilePath
        Raw         = $true
        ErrorAction = 'Stop'
    }
    try {
        $rawFileContent = Get-Content @getContentSplat
    }
    catch {
        Write-Warning -Message ('Contents of {0} could not be retrieved' -f $FilePath)
        throw $_
    }

    if ([string]::IsNullOrWhiteSpace($rawFileContent)) {
        Write-Warning -Message ('Contents of {0} is empty' -f $FilePath)
        return
    }

    $commandTokens = [System.Collections.ArrayList]::new()

    $tokens = [System.Management.Automation.PSParser]::Tokenize(($rawFileContent), [ref]$null)
    foreach ($token in $tokens) {

        if ($token.Type -ne 'Command' -and $token.Type -ne 'CommandArgument') {
            continue
        }

        [void]$commandTokens.Add($token)

    } #foreach_token

    return $commandTokens

} #Read-TokenCommandsFromFile
