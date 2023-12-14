---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Get-AllCloudCommandInfo

## SYNOPSIS
Returns detailed module and function information on all available PowerShell cloud commands.

## SYNTAX

```
Get-AllCloudCommandInfo [[-Filter] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function provides comprehensive details on modules and functions from the entire catalog
of PowerShell cloud commands.
To manage the volume of data returned, it's advisable to use the
'Filter' parameter to focus on a specific cloud provider's commands.

## EXAMPLES

### EXAMPLE 1
```
Get-AllCloudCommandInfo -Filter AWS
```

Retrieves a complete list of modules and functions for AWS-specific PowerShell cloud commands.

### EXAMPLE 2
```
Get-AllCloudCommandInfo
```

Returns information on all available PowerShell cloud commands across various cloud platforms.

## PARAMETERS

### -Filter
Filters the search to a specific cloud platform (AWS/Azure/Oracle).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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
