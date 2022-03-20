---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Find-CloudCommand

## SYNOPSIS
Finds PowerShell cloud command(s) that match the provided query.

## SYNTAX

```
Find-CloudCommand [-Query] <String> [[-Filter] <String>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
Performs query search on a dynamically updated cache of known PowerShell cloud commands.
Results are returned based on provided criteria.
Based on the query provided, a different form of search is performed.
If a function name is provided (Verb-Noun), a function name query is performed.
If a wildcard is provided (Ve*-Noun), a wildcard query is performed.
Anything else is treated as a free-form query.
Order of query efficiency is:
1.
Function name query
2.
Wildcard query
3.
Free-form query
Query performance will also be greatly increased if you filter to the specific cloud platform you are using (AWS/Azure/Oracle).
Free-form queries can generate many results and by default only the top 30 results are returned.
Use the -AllResults parameter with free-form queries to return all results.

## EXAMPLES

### EXAMPLE 1
```
Find-CloudCommand -Query Write-S3Object -Filter AWS
```

Search for a specific function name (Verb-Noun) and filter to AWS.

### EXAMPLE 2
```
Find-CloudCommand -Query New-OCIComputeInstance -Filter Oracle
```

Search for a specific function name (Verb-Noun) and filter to Oracle.

### EXAMPLE 3
```
Find-CloudCommand -Query New-MLDataSourceFromRedshift
```

Search for a specific function name (Verb-Noun) against all cloud platforms.

### EXAMPLE 4
```
Find-CloudCommand -Query New*VM* -Filter Azure
```

Wildcard function search that is filtered to Azure.

### EXAMPLE 5
```
Find-CloudCommand -Query Get*WAF*
```

Wildcard function search against all cloud platforms.

### EXAMPLE 6
```
Find-CloudCommand -Query 'I want to create a new compute instance' -Filter Oracle
```

Free-form query that is filtered to Oracle.

### EXAMPLE 7
```
Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS -AllResults
```

Free-form query that is filtered to AWS and returns all results.

## PARAMETERS

### -Query
PowerShell cloud command search input

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Filter results to specific cloud platform (AWS/Azure/Oracle)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Return all results, regardless of the number of results returned

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS

[https://docs.aws.amazon.com/powershell/latest/reference/](https://docs.aws.amazon.com/powershell/latest/reference/)

[https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md](https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md)

[https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershell.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershell.htm)

