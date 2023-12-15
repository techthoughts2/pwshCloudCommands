# pwshCloudCommands - FAQ

## FAQs

### Why would I use this vs Get-Command?

While `Get-Command` is a powerful tool, pwshCloudCommands offers unique advantages for working with cloud-specific PowerShell commands. The key benefit is the ability to search for and identify cloud commands across multiple cloud platforms without the need to install their respective modules locally. Additionally, it allows you to scan directories and accurately detect the usage of cloud commands, regardless of whether those modules are present on your local system.

### How current is the PowerShell cloud command cache data?

Given the rapid pace of change in cloud services, pwshCloudCommands is designed to keep up with the latest PowerShell cloud commands. The [cache](pwshCloudCommands_cache_workflow.md) is systematically updated to reflect the most recent commands, with a standard latency of about one week.
