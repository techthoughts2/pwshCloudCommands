# pwshCloudCommands

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/pwshCloudCommands?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/pwshCloudCommands
[license-badge]:   https://img.shields.io/github/license/techthoughts2/pwshCloudCommands

Branch | Windows - PowerShell | Windows - pwsh | Linux | MacOS
--- | --- | --- | --- | --- |
main | [![Build status Windows PowerShell main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml) | [![Build Status Windows pwsh main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml) | [![Build Status Linux main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml) | [![Build Status MacOS main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml)
Enhancements | [![Build status Windows PowerShell Enhancements](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml) | [![Build Status Windows pwsh Enhancements](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml) | [![Build Status Linux Enhancements](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml) | [![Build Status MacOS Enhancements](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml)

## Synopsis

Search, discover, and identify PowerShell cloud commands across multiple cloud providers.

## Description

pwshCloudCommands enables you to search for and discover PowerShell cloud commands and functions without the need to save or install modules locally.
It uses a cloud-based, event driven workflow to generate a dynamic cache of known PowerShell cloud commands.
This cache can be searched, queried, and leveraged to identify what functions and modules are being used inside your project.
You can use pwshCloudCommands to:

* Search for and discover PowerShell cloud commands across multiple cloud providers.
* Scan your existing project files to identify all used PowerShell cloud commands and their corresponding module.

[pwshCloudCommands](docs/pwshCloudCommands.md) provides the following functions:

* [Find-CloudCommand](docs/Find-CloudCommand.md)
* [Get-AllCloudCommandInfo](docs/Get-AllCloudCommandInfo.md)
* [Get-CloudCommandFromFile](docs/Get-CloudCommandFromFile.md)

## Why

Enable easier discoverability of PowerShell cloud commands.

## Installation

### Prerequisites

* [PowerShell 5.1](https://github.com/PowerShell/PowerShell) *(or higher version)*

### Installing pwshCloudCommands via PowerShell Gallery

```powershell
#from a 5.1+ PowerShell session
Install-Module -Name 'pwshCloudCommands' -Scope CurrentUser
```

## Quick start

```powershell
#------------------------------------------------------------------------------------------------
# import the pwshCloudCommands module
Import-Module -Name "pwshCloudCommands"
#------------------------------------------------------------------------------------------------
# identify all PowerShell commands and modules used in the specified path
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud
#------------------------------------------------------------------------------------------------
# identify all unique modules used in the specified path - useful for CI/CD bootstrapping
$psCloud = Get-CloudCommandFromFile -Path "$env:HOME\pathToEvaluate"
$psCloud.CloudCommands.ModuleName | Select-Object -Unique
#------------------------------------------------------------------------------------------------
# search for a specific cloud command on a specific cloud platform
Find-CloudCommand -Query Write-S3Object -Filter AWS
#------------------------------------------------------------------------------------------------
# search for a specific cloud command on any cloud platform
Find-CloudCommand -Query New-OCIComputeInstance
#------------------------------------------------------------------------------------------------
# wildcard search for a cloud command
Find-CloudCommand -Query New*VM* -Filter Azure
#------------------------------------------------------------------------------------------------
# free-form search for a cloud command
$commands = Find-CloudCommand -Query 'I want to create a new compute instance in Oracle Cloud'
$commands
#------------------------------------------------------------------------------------------------
# I want to get all cloud functions and modules that belong to a specific cloud platform
Get-AllCloudCommandInfo -Filter AWS
Get-AllCloudCommandInfo -Filter Azure
Get-AllCloudCommandInfo -Filter Oracle
#------------------------------------------------------------------------------------------------
```

## Author

[Jake Morrison](https://twitter.com/JakeMorrison) - [https://www.techthoughts.info/](https://www.techthoughts.info/)

## Notes

PowerShell cloud information is provided via a [Cache creation component](docs/pwshCloudCommands_cache_workflow.md)

This PowerShell project was created with [Catesta](https://github.com/techthoughts2/Catesta).

## FAQ

[pwshCloudCommands - FAQ](docs/pwshCloudCommands-FAQ.md)

## License

This project is [licensed under the MIT License](LICENSE).

## Changelog

Reference the [Changelog](.github/CHANGELOG.md)
