# pwshCloudCommands

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/pwshcloudcommands/badge/?version=latest)](https://pwshcloudcommands.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/pwshCloudCommands?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/pwshCloudCommands
[license-badge]:   https://img.shields.io/github/license/techthoughts2/pwshCloudCommands

## What is pwshCloudCommands?

pwshCloudCommands is a PowerShell module that simplifies the search and analysis of cloud-specific PowerShell commands, without the need to install cloud modules locally. It provides a dual discovery method: querying cloud commands across AWS, Azure, and Oracle, and scanning local project files to identify which cloud commands and modules are being utilized.

## Why pwshCloudCommands?

To aid in the discovery and analysis of cloud-specific PowerShell commands, pwshCloudCommands streamlines your workflow when working with PowerShell in the cloud.

- **Find Cloud Commands Without Local Installs**: You can effortlessly search for any cloud command across AWS, Azure, and Oracle without installing the corresponding modules locally, reducing overhead and simplifying cloud command management.
- **Enjoy Advanced Search Capabilities**: Unlike the PowerShell Gallery, this module supports free-form searches. This is particularly useful when you're not sure of the exact command or syntax, offering an intuitive and flexible way to find what you need.
- **Benefit from Comprehensive Project Analysis**: The standout `Get-CloudCommandFromFile` function in `pwshCloudCommands` scans your project files to identify all necessary cloud modules. This feature is invaluable for creating dependency files or integrating into CI/CD processes, and it's extremely helpful for quickly understanding the cloud module requirements of new code or projects.

## Getting Started

### Installation

```powershell
Install-Module -Name 'pwshCloudCommands' -Repository PSGallery -Scope CurrentUser
```

### Quick Start

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

## How pwshCloudCommands Works

pwshCloudCommands utilizes a cloud-based, event-driven workflow to generate a dynamic cache of known PowerShell cloud commands. This cache is periodically updated to ensure that it reflects the latest commands available from multiple cloud providers. You can view [cache metrics](pwshCloudCommand-Metrics.md) and read more about the [cache creation component](pwshCloudCommands_cache_workflow.md).

## Features

- Fully cross-platform and can be run on Windows, Linux, and macOS
- Module-Free Command Search: Discover PowerShell commands without the need for local module installations.
    - Exact Function Name Search: Find specific functions, like Write-S3Object.
    - Wildcard Search: Use patterns, such as New\*VM\*, to locate commands.
    - Free-Form Search: Enter natural language queries like 'I want to create a new compute instance' for intuitive searching.
- Complete Cache Data Dump: Access a comprehensive dump containing all known PowerShell cloud commands for detailed analysis.
- Project File Analysis: Scan files and folders in your projects to identify used cloud functions and modules, crucial for project setup, discovery, and CI/CD pipeline integration.
