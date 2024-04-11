---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Get-CloudCommandFromFile

## SYNOPSIS
Identifies PowerShell cloud functions and modules within files at a specified path.

## SYNTAX

```
Get-CloudCommandFromFile [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
This function scans and analyzes PowerShell files in a given directory or path.
It parses each file to identify all PowerShell cloud functions and their associated modules,
providing a comprehensive overview of cloud-related commands used in the project.

## EXAMPLES

### EXAMPLE 1
```
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud
```

Examines the specified path for PowerShell files, returning a list of cloud functions and their modules found in these files.

### EXAMPLE 2
```
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud.CloudCommands.ModuleName | Select-Object -Unique
```

After analyzing files at the specified path, this returns a list of unique module names utilized in those files.

## PARAMETERS

### -Path
File or directory path to be evaluated for cloud command usage.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS
