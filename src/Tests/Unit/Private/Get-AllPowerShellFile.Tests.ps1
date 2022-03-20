#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshCloudCommands'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'pwshCloudCommands' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-AllPowerShellFile' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $path = '{0}\pathToEvaluate' -f $env:HOME
        } #beforeAll
        Context 'Error' {

            It 'should not throw if an error is encountered' {
                Mock -CommandName Get-ChildItem -MockWith {
                    [System.Exception]$exception = "System.Management.Automation.ItemNotFoundException: Cannot find path 'C:\nopey' because it does not exist."
                    [System.String]$errorId = 'ObjectNotFound'
                    [Management.Automation.ErrorCategory]$errorCategory = [Management.Automation.ErrorCategory]::ObjectNotFound
                    [System.Object]$target = 'Whatevs'
                    $errorRecord = New-Object Management.Automation.ErrorRecord ($exception, $errorID, $errorCategory, $target)
                    [System.Management.Automation.ErrorDetails]$errorDetails = ''
                    $errorRecord.ErrorDetails = $errorDetails
                    Write-Error $errorRecord
                } #endMock
                { Get-AllPowerShellFile -Path $path } | Should -Not -Throw
                Get-AllPowerShellFile -Path $path | Should -BeNullOrEmpty
            } #it

        } #context_Error
        Context 'Success' {

            BeforeEach {
                Mock -CommandName Get-ChildItem -MockWith {
                    [PSCustomObject]@{
                        PSPath              = 'Microsoft.PowerShell.Core\FileSystem::C:\Test\AWSCBManifestPS\configure_aws_credential.ps1'
                        PSParentPath        = 'Microsoft.PowerShell.Core\FileSystem::C:\Test\AWSCBManifestPS'
                        PSChildName         = 'configure_aws_credential.ps1'
                        PSDrive             = 'C'
                        PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                        PSIsContainer       = 'False'
                        Mode                = '-a---'
                        ModeWithoutHardLink = '-a---'
                        BaseName            = 'configure_aws_credential'
                        Target              = ''
                        LinkType            = ''
                        Length              = '1305'
                        DirectoryName       = '{0}\pathToEvaluate' -f $env:HOME
                        Directory           = '{0}\pathToEvaluate' -f $env:HOME
                        IsReadOnly          = 'False'
                        FullName            = '{0}\Test\configure_aws_credential.ps1' -f $env:HOME
                        Extension           = '.ps1'
                        Name                = 'configure_aws_credential.ps1'
                        Exists              = 'True'
                        CreationTime        = '03/03/19 22:04:58'
                        CreationTimeUtc     = '03/04/19 04:04:58'
                        LastAccessTime      = '06/13/21 18:14:17'
                        LastAccessTimeUtc   = '06/13/21 23:14:17'
                        LastWriteTime       = '02/23/19 23:55:47'
                        LastWriteTimeUtc    = '02/24/19 05:55:47'
                        LinkTarget          = ''
                        Attributes          = 'Archive'
                    }
                } #endMock
            } #beforeEach

            It 'should return the expected results' {
                $eval = Get-AllPowerShellFile -Path $path
                $eval.BaseName      | Should -BeExactly 'configure_aws_credential'
                $eval.DirectoryName | Should -BeLike '*pathToEvaluate*'
                $eval.Extension     | Should -BeExactly '.ps1'
                $eval.Name          | Should -BeExactly 'configure_aws_credential.ps1'
            } #it

            It 'should return null if no PowerShell files are found' {
                Mock -CommandName Get-ChildItem -MockWith {
                    $null
                } #endMock
                Get-AllPowerShellFile -Path $path | Should -BeNullOrEmpty
            } #it

        } #context_Success
    } #describe_Get-AllPowerShellFile
} #inModule
