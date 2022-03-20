---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Get-AllCloudCommandInfo

## SYNOPSIS
Returns module and function information for all known PowerShell cloud commands.

## SYNTAX

```
Get-AllCloudCommandInfo [[-Filter] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns results from the entire PowerShell cloud command catalog.
It is recommended to use the Filter parameter to reduce the size of the result set.

## EXAMPLES

### EXAMPLE 1
```
Get-AllCloudCommandInfo -Filter AWS
```

Returns module and function information of all known AWS PowerShell cloud commands.

### EXAMPLE 2
```
Get-AllCloudCommandInfo
```

Returns module and function information of all known PowerShell cloud commands.

## PARAMETERS

### -Filter
Filter results to specific cloud platform (AWS/Azure/Oracle)

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
