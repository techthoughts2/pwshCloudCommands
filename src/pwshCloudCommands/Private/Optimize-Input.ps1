<#
.SYNOPSIS
    Takes in free form query and optimizes for use in a verb / term bases search.
.DESCRIPTION
    Takes in free form query and removes all stop words, special characters, and white space.
    Identifies verb and terms and forms an object to be used in a search.
.EXAMPLE
    Optimize-Input -SearchInput 'write an object to a s3 bucket'

    Takes in free form query and optimizes for use in a verb / term bases search.
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.COMPONENT
    pwshCloudCommands
#>
function Optimize-Input {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'TBD')]
        [string[]]$SearchInput
    )

    # $SearchInput = 'write write *OBJECT* to bucket $&*@(*@'
    $splitInput = $SearchInput.Split(' ')
    $noSpecialCharInput = $splitInput -replace '\W', ''
    $lowerInput = $noSpecialCharInput.ToLower()
    $noDupInput = $lowerInput | Select-Object -Unique
    $noEmptyArray = $noDupInput.Split('', [System.StringSplitOptions]::RemoveEmptyEntries)
    if ([string]::IsNullOrWhiteSpace($noEmptyArray)) {
        return $null
    }
    $cleanInput = Remove-StopWord -SearchInput $noEmptyArray

    $verbs = [System.Collections.ArrayList]::new()
    $terms = [System.Collections.ArrayList]::new()
    $psVerbs = Get-Verb | Select-Object -ExpandProperty Verb

    $cleanInput | ForEach-Object {
        if ($psVerbs -contains $_) {
            [void]$verbs.Add($_)
        }
        else {
            [void]$terms.Add($_)
        }
    }
    $obj = [PSCustomObject]@{
        Verbs = $verbs
        Terms = $terms
    }
    return $obj
} #Optimize-Input
