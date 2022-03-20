---
external help file: pwshCloudCommands-help.xml
Module Name: pwshCloudCommands
online version: https://docs.aws.amazon.com/powershell/latest/reference/
schema: 2.0.0
---

# Get-CloudCommandFromFile

## SYNOPSIS
Evaluates PowerShell files in specified path and identifies a list of PowerShell cloud functions and their associated modules.

## SYNTAX

```
Get-CloudCommandFromFile [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Discovers all PowerShell files in the specified path.
Parses each file and identifies all PowerShell cloud functions and their associated modules.

## EXAMPLES

### EXAMPLE 1
```
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud
```

Returns a list of PowerShell cloud functions and their associated modules found in files in the specified path.

### EXAMPLE 2
```
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud.CloudCommands.ModuleName | Select-Object -Unique
```

Returns a list of unique module names found in use in files in the specified path.

## PARAMETERS

### -Path
File or Folder Path to evaluate.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS
