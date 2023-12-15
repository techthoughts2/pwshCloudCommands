# pwshCloudCommands

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/pwshCloudCommands?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/pwshCloudCommands
[license-badge]:   https://img.shields.io/github/license/techthoughts2/pwshCloudCommands

Branch | Windows - PowerShell | Windows - pwsh | Linux | MacOS
--- | --- | --- | --- | --- |
main | [![Build status Windows PowerShell main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml) | [![Build Status Windows pwsh main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml) | [![Build Status Linux main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml) | [![Build Status MacOS main](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml/badge.svg?branch=main)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml)
Enhancements | [![pwshCloudCommands-Windows](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows.yml) | [![pwshCloudCommands-Windows-pwsh](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Windows_Core.yml) | [![pwshCloudCommands-Linux](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_Linux.yml) | [![pwshCloudCommands-MacOS](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml/badge.svg?branch=Enhancements)](https://github.com/techthoughts2/pwshCloudCommands/actions/workflows/wf_MacOS.yml)

## Synopsis

Search, discover, and identify PowerShell cloud commands across multiple cloud providers.

## Description

pwshCloudCommands is a PowerShell module that simplifies the search and analysis of cloud-specific PowerShell commands, without the need to install cloud modules locally. It provides a dual discovery method: querying cloud commands across AWS, Azure, and Oracle, and scanning local project files to identify which cloud commands and modules are being utilized.

### Features

- Fully cross-platform and can be run on Windows, Linux, and macOS
- Module-Free Command Search: Discover PowerShell commands without the need for local module installations.
    - Exact Function Name Search: Find specific functions, like Write-S3Object.
    - Wildcard Search: Use patterns, such as New*VM*, to locate commands.
    - Free-Form Search: Enter natural language queries like 'I want to create a new compute instance' for intuitive searching.
- Complete Cache Data Dump: Access a comprehensive dump containing all known PowerShell cloud commands for detailed analysis.
- Project File Analysis: Scan files and folders in your projects to identify used cloud functions and modules, crucial for project setup, discovery, and CI/CD pipeline integration.

## Getting Started

### Documentation

Documentation for pwshCloudCommands is available at: [https://pwshCloudCommands.readthedocs.io](https://pwshCloudCommands.readthedocs.io)

### Installation

```powershell
# Install pwshCloudCommands from the PowerShell Gallery
Install-Module -Name 'pwshCloudCommands' -Scope CurrentUser
```

### Quick start

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

## Notes

This PowerShell project was created with [Catesta](https://github.com/techthoughts2/Catesta).

## Contributing

If you'd like to contribute to pwshCloudCommands, please see the [contribution guidelines](.github/CONTRIBUTING.md).

## License

This project is [licensed under the MIT License](LICENSE).
