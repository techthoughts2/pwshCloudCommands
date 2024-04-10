<#
.SYNOPSIS
    Queries XML data set to discover PowerShell cloud commands based on provided inputs.
.DESCRIPTION
    Primary private function that performs the appropriate query against the XML data set.

.EXAMPLE
    Search-XMLDataSet -Query $cleanQuery

    Performs a general search against the XML data set.

.EXAMPLE
    Search-XMLDataSet -FunctionQuery 'Write-S3Object'

    Performs a function query against the XML data set.
.EXAMPLE
    Search-XMLDataSet -WildCardQuery 'write-s3*'

    Performs a wildcard query against the XML data set.
.PARAMETER Query
    Clean input query in Verb Term Format.
.PARAMETER FunctionQuery
    PowerShell function name to query against the XML data set.
.PARAMETER WildCardQuery
    PowerShell function name with wildcard to query against the XML data set.
.PARAMETER AllInfo
    Return all info from the XML data set.
.PARAMETER Filter
    Cloud filter to apply to the query. This drastically improves the performance of the query.
.OUTPUTS
    Deserialized.System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

    If using a generic query this function expects a clean query input
    that is currently being provided by Optimize-Input
.COMPONENT
    pwshCloudCommands
#>
function Search-XMLDataSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'Clean input query in Verb Term Format',
            ParameterSetName = 'Input')]
        [psobject]$Query,

        [Parameter(Mandatory = $true,
            Position = 1,
            HelpMessage = 'PowerShell function name to query against the XML data set',
            ParameterSetName = 'Function')]
        [string]$FunctionQuery,

        [Parameter(Mandatory = $true,
            Position = 2,
            HelpMessage = 'PowerShell function name with wildcard to query against the XML data set',
            ParameterSetName = 'WildCard')]
        [string]$WildCardQuery,

        [Parameter(Mandatory = $true,
            Position = 3,
            HelpMessage = 'Return all info from the XML data set',
            ParameterSetName = 'All')]
        [switch]$AllInfo,

        [Parameter(Mandatory = $false,
            Position = 4,
            HelpMessage = 'Cloud filter to apply to the query')]
        [ValidateSet('AWS', 'Azure', 'Oracle')]
        [string]
        $Filter
    )

    Write-Debug -Message ('Parameter set: {0}' -f $PSCmdlet.ParameterSetName)

    switch ($Filter) {
        'AWS' {
            $searchFilter = 'AWS.Tools.*'
        }
        'Azure' {
            $searchFilter = 'Az.*'
        }
        'Oracle' {
            $searchFilter = 'OCI.*'
        }
        Default {
            $searchFilter = '*'
        }
    } #switch_filter
    Write-Debug -Message ('Search filter: {0}' -f $searchFilter)

    Write-Verbose -Message 'Retrieving xml file info...'
    $xmlDataPath = '{0}\{1}' -f $script:dataPath, $script:dataFolder
    $getChildItemSplat = @{
        Path        = $xmlDataPath
        Filter      = $searchFilter
        ErrorAction = 'Stop'
    }
    try {
        $xmlDataFiles = Get-ChildItem @getChildItemSplat
    }
    catch {
        Write-Warning -Message 'An error was encountered getting xml file info.'
        Write-Error $_
        throw
    }

    # special case for Azure selection where we will also retrieve Graph Modules
    if ($Filter -eq 'Azure') {
        Write-Debug -Message 'Retrieving Azure Graph xml file info...'
        $getChildItemSplat = @{
            Path        = $xmlDataPath
            Filter      = 'Microsoft.Graph.*'
            ErrorAction = 'Stop'
        }
        try {
            $graphFiles = Get-ChildItem @getChildItemSplat
        }
        catch {
            Write-Warning -Message 'An error was encountered getting xml file info.'
            Write-Error $_
            throw
        }
        $xmlDataFiles += $graphFiles
    }

    Write-Verbose -Message 'Running query...'
    if ($PSCmdlet.ParameterSetName -eq 'Function') {
        #------------------------------
        $xmlCount = ($xmlDataFiles | Measure-Object).Count
        $i = 0
        #------------------------------
        foreach ($xml in $xmlDataFiles) {
            # ------------------------------
            # resets
            $rawData = $null
            $xmlData = $null
            $function = $null
            # ------------------------------
            $i++
            Write-Progress -Activity 'Searching...' -PercentComplete ($i / $xmlCount * 100)

            Write-Debug -Message ('Processing {0}' -f $xml.Name)
            try {
                $rawData = Get-Content $xml.FullName -Raw -ErrorAction 'Stop'
            }
            catch {
                Write-Warning -Message ('An error was encountered reading xml data file {0}...' -f $xml.Name)
                Write-Error $_
                throw
            }

            if ($rawData -match $FunctionQuery) {
                Write-Debug -Message ('Function query match found in {0}' -f $xml.Name)
                $xmlData = $rawData | ConvertFrom-Clixml
            }
            else {
                continue
            }

            if ($xmlData.ExportedCommands.Keys -contains $FunctionQuery) {
                $function = $xmlData.Functions | Where-Object {
                    $_.Name -eq $FunctionQuery -or $_.DisplayName -eq $FunctionQuery
                }
                if ($null -ne $function) {

                    if ($function.CommandType.Value -eq 'Alias') {
                        Write-Debug -Message ('Alias located in: {0}' -f $xml.Name)
                        Write-Warning -Message ('Aliases not supported - {0} is an alias for {1}' -f $function.DisplayName, $function.ResolvedCommand)
                        continue
                    }
                    else {
                        Write-Debug -Message ('Function command found: {0}' -f $function.Name)
                    }

                    Add-Member -InputObject $function -MemberType NoteProperty -Name 'ModuleName' -Value $xmlData.Name -Force
                    $function.PSObject.TypeNames.Insert(0, 'pFindCCFormat')
                    return $function
                }
            }

        } #foreach_xml

        return $null

    } #if_function_query
    elseif ($PSCmdlet.ParameterSetName -eq 'WildCard') {
        #------------------------------
        $xmlCount = ($xmlDataFiles | Measure-Object).Count
        $i = 0
        $matchResults = [System.Collections.ArrayList]::new()
        $words = $WildCardQuery.Split('*')
        $wordsArray = $words | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        #------------------------------
        foreach ($xml in $xmlDataFiles) {
            # ------------------------------
            # resets
            $rawData = $null
            $xmlData = $null
            $function = $null
            $fileParse = $false
            # ------------------------------
            $i++
            Write-Progress -Activity 'Searching...' -PercentComplete ($i / $xmlCount * 100)

            Write-Debug -Message ('Processing {0}' -f $xml.Name)
            try {
                $rawData = Get-Content $xml.FullName -Raw -ErrorAction 'Stop'
            }
            catch {
                Write-Warning -Message ('An error was encountered reading cloud data file {0}...' -f $xml.Name)
                Write-Error $_
                throw
            }

            foreach ($word in $wordsArray) {
                if ($rawData -match $word) {
                    Write-Debug -Message ('Match found in {0}' -f $xml.Name)
                    $fileParse = $true
                }
            }

            if ($fileParse -eq $true) {
                $xmlData = $rawData | ConvertFrom-Clixml
            }
            else {
                continue
            }

            foreach ($function in $xmlData.Functions) {
                Write-Debug -Message ('....Processing {0}' -f $function.Name)
                if ($function.Name -like $WildCardQuery -or $function.DisplayName -like $WildCardQuery) {
                    Write-Debug -Message ('Function query matched: {0}' -f $function.Name)

                    if ($function.CommandType.Value -eq 'Alias') {
                        Write-Debug -Message ('Alias located in: {0}' -f $xml.Name)
                        Write-Warning -Message ('Aliases not supported - {0} is an alias for {1}' -f $function.DisplayName, $function.ResolvedCommand)
                        continue
                    }

                    Add-Member -InputObject $function -MemberType NoteProperty -Name 'ModuleName' -Value $xmlData.Name -Force
                    $function.PSObject.TypeNames.Insert(0, 'pFindCCFormat')
                    [void]$matchResults.Add($function)
                }
            } #foreach_function

        } #foreach_xml

        return $matchResults

    } #elseif_wildcard
    elseif ($AllInfo -eq $true) {
        #------------------------------
        $xmlCount = ($xmlDataFiles | Measure-Object).Count
        $i = 0
        $matchResults = [System.Collections.ArrayList]::new()
        #------------------------------
        foreach ($xml in $xmlDataFiles) {
            # ------------------------------
            # resets
            $rawData = $null
            $xmlData = $null
            $function = $null
            $fileParse = $false
            # ------------------------------
            $i++
            Write-Progress -Activity 'Searching...' -PercentComplete ($i / $xmlCount * 100)

            Write-Debug -Message ('Processing {0}' -f $xml.Name)
            try {
                $rawData = Get-Content $xml.FullName -Raw -ErrorAction 'Stop'
                $xmlData = $rawData | ConvertFrom-Clixml
            }
            catch {
                Write-Warning -Message ('An error was encountered reading cloud data file {0}...' -f $xml.Name)
                Write-Error $_
                throw
            }

            foreach ($function in $xmlData.Functions) {
                Write-Debug -Message ('....Processing {0}' -f $function.Name)
                if ($function.Name -like $WildCardQuery -or $function.DisplayName -like $WildCardQuery) {
                    Write-Debug -Message ('Function query matched: {0}' -f $function.Name)

                    if ($function.CommandType.Value -eq 'Alias') {
                        # skip aliases
                        continue
                    }

                    Add-Member -InputObject $function -MemberType NoteProperty -Name 'ModuleName' -Value $xmlData.Name -Force
                    $function.PSObject.TypeNames.Insert(0, 'pFindCCFormat')
                    [void]$matchResults.Add($function)
                }
            } #foreach_function

        } #foreach_xml

        return $matchResults

    } #elseif_all
    else {
        #------------------------------
        $xmlCount = ($xmlDataFiles | Measure-Object).Count
        $i = 0
        $matchResults = [System.Collections.ArrayList]::new()
        #------------------------------
        foreach ($xml in $xmlDataFiles) {
            # ---------------------------
            # resets
            $rawData = $null
            $xmlData = $null
            $fileParse = $false
            # ---------------------------
            $i++
            Write-Progress -Activity 'Searching...' -PercentComplete ($i / $xmlCount * 100)

            Write-Debug -Message ('Processing {0}' -f $xml.Name)
            try {
                $rawData = Get-Content $xml.FullName -Raw -ErrorAction 'Stop'
            }
            catch {
                Write-Warning -Message ('An error was encountered reading cloud data file {0}...' -f $xml.Name)
                Write-Error $_
                throw
            }

            #--------------------------------
            # raw string match checks
            foreach ($verb in $Query.Verbs) {
                if ($rawData -match $verb) {
                    $fileParse = $true
                }
            }
            foreach ($term in $Query.Terms) {
                if ($rawData -match $term) {
                    $fileParse = $true
                }
            }
            #--------------------------------

            if ($fileParse -eq $true) {
                $xmlData = $rawData | ConvertFrom-Clixml
            }
            else {
                continue
            }

            foreach ($function in $xmlData.Functions) {
                # ---------------------------
                # resets
                $verbMatch = $false
                [int]$matchScore = 0
                # ---------------------------

                foreach ($verb in $Query.Verbs) {
                    if ($function.Verb -match $verb) {
                        Write-Debug -Message ('{0} matched verb: {1}' -f $function.Name, $verb)
                        $matchScore += 20
                        $verbMatch = $true
                    }
                } #foreach_verb

                foreach ($term in $Query.Terms) {
                    if ($function.Noun -match $term) {
                        Write-Debug -Message ('{0} matched noun: {1}' -f $function.Name, $term)
                        $matchScore += 10
                    }
                    if ($function.Synopsis -match $term) {
                        Write-Debug -Message ('{0} Synopsis matched: {1}' -f $function.Name, $term)
                        $matchScore += ($function.Synopsis | Select-String $term -AllMatches).Matches.Value.count
                    }
                    if ($function.Description -match $term) {
                        Write-Debug -Message ('{0} Description matched: {1}' -f $function.Name, $term)
                        $matchScore += ($function.Description | Select-String $term -AllMatches).Matches.Value.count
                    }

                } #foreach_term

                if ($verbMatch -eq $true ) {
                    [int]$cutOff = 20
                }
                else {
                    [int]$cutOff = 0
                }
                Write-Debug -Message ('Match score: {0}' -f $matchScore)
                Write-Debug -Message ('Cutoff: {0}' -f $matchScore)

                if ($matchScore -gt $cutOff) {
                    Add-Member -InputObject $function -MemberType NoteProperty -Name 'MatchScore' -Value $matchScore -Force
                    Add-Member -InputObject $function -MemberType NoteProperty -Name 'ModuleName' -Value $xmlData.Name -Force
                    $function.PSObject.TypeNames.Insert(0, 'pFindCCFormat')
                    [void]$matchResults.Add($function)
                }

            } #foreach_function

        } #foreach_xmldatafiles

        return $matchResults | Where-Object { $_.MatchScore -gt 0 }

    } #else_input

} #Search-XMLDataSet
