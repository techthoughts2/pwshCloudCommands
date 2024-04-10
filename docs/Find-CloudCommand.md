---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Find-CloudCommand

## SYNOPSIS
Searches for PowerShell cloud commands matching a given query.

## SYNTAX

```
Find-CloudCommand [-Query] <String> [[-Filter] <String>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
This function searches a dynamically updated cache of PowerShell cloud commands,
returning results that match specific criteria.
The nature of the search depends on the type of query:
    - Function Name Query: Directly uses the function name format (Verb-Noun).
    - Wildcard Query: Utilizes wildcards (e.g., Ve*-Noun) for broader searches.
    - Free-form Query: Handles any other text as a general search term.
The efficiency of queries follows this order: function name, wildcard, then free-form.
Specifying a cloud platform (AWS/Azure/Oracle) enhances performance, especially for free-form queries.
By default, free-form queries return the top 30 results; use the -AllResults parameter to retrieve all matches.

## EXAMPLES

### EXAMPLE 1
```
Find-CloudCommand -Query Write-S3Object -Filter AWS
```

Searches for the 'Write-S3Object' function specifically within AWS services.

### EXAMPLE 2
```
Find-CloudCommand -Query New-OCIComputeInstance -Filter Oracle
```

Looks for the 'New-OCIComputeInstance' function within Oracle cloud services.

### EXAMPLE 3
```
Find-CloudCommand -Query New-MLDataSourceFromRedshift
```

Searches for 'New-MLDataSourceFromRedshift' across all cloud platforms.

### EXAMPLE 4
```
Find-CloudCommand -Query New*VM* -Filter Azure
```

Performs a wildcard search for VM-related functions within Azure.

### EXAMPLE 5
```
Find-CloudCommand -Query Get*WAF*
```

Uses a wildcard search for WAF-related functions across all platforms.

### EXAMPLE 6
```
Find-CloudCommand -Query 'I want to create a new compute instance' -Filter Oracle
```

Conducts a free-form search related to compute instances in Oracle cloud.

### EXAMPLE 7
```
Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS -AllResults
```

Executes a comprehensive free-form search for downloading objects from S3 in AWS.

## PARAMETERS

### -Query
Search input for PowerShell cloud commands.

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
Filters the search to a specific cloud platform (AWS/Azure/Oracle).

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
Retrieves all search results without limiting the number.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS

[https://docs.aws.amazon.com/powershell/latest/reference/](https://docs.aws.amazon.com/powershell/latest/reference/)

[https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md](https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md)

[https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershell.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/powershell.htm)
