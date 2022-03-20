# pwshCloudCommands - FAQ

## FAQs

### Why would I use this vs Get-Command?

pwshCloudCommands is not a replacement for ```Get-Command```. The primary difference is that you do not have to have a module installed on your local device in order to use pwshCloudCommands. This enables you search for and identify PowerShell cloud commands across multiple cloud platforms without having to install any modules. This also enables you to scan directories and identify cloud commands used without necessarily having those modules on your local device.

### How current is the PowerShell cloud command cache data?

Cloud changes frequently, and so do PowerShell cloud commands. The [Cache creation component](pwshCloudCommands_cache_workflow.md) ensures that the data cache is kept current. There is approximately a 1 week delay in the project cache data for all supported cloud platforms.
