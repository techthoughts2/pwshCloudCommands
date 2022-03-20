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
    Describe 'Get-CloudCommandFromFile' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            $path = '{0}\pathToEvaluate' -f $env:HOME
            Mock -CommandName Invoke-XMLDataCheck {
                $true
            } #endMock
            Mock -CommandName Get-Item {
                [PSCustomObject]@{
                    PSChildName         = 'asset'
                    PSDrive             = 'C'
                    PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                    PSIsContainer       = $true
                    Mode                = 'd----'
                    ModeWithoutHardLink = 'd----'
                    BaseName            = 'asset'
                    Parent              = '{0}\pwshCloudCommands\src\Tests' -f $env:HOME
                    Root                = '{0}\' -f $env:HOME
                    FullName            = '{0}\pwshCloudCommands\src\Tests\asset' -f $env:HOME
                    Name                = 'asset'
                    Exists              = 'True'
                    CreationTime        = '03 / 04 / 22 07:53:04'
                    CreationTimeUtc     = '03 / 04 / 22 13:53:04'
                    LastAccessTime      = '03 / 18 / 22 14:16:38'
                    LastAccessTimeUtc   = '03 / 18 / 22 19:16:38'
                    LastWriteTime       = '03 / 17 / 22 18:41:30'
                    LastWriteTimeUtc    = '03 / 17 / 22 23:41:30'
                    Attributes          = 'Directory'
                }
            } #endMock
            Mock -CommandName Get-AllPowerShellFile {
                [PSCustomObject]@{
                    PSChildName         = 'example_commands.ps1'
                    PSDrive             = 'C'
                    PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                    PSIsContainer       = 'False'
                    Mode                = '-a-- -'
                    ModeWithoutHardLink = '-a-- -'
                    BaseName            = 'example_commands'
                    Length              = '1513'
                    DirectoryName       = '{0}\pwshCloudCommands\src\Tests\asset' -f $env:HOME
                    Directory           = '{0}\pwshCloudCommands\src\Tests\asset' -f $env:HOME
                    IsReadOnly          = 'False'
                    FullName            = '{0}\pwshCloudCommands\src\Tests\asset\example_commands.ps1' -f $env:HOME
                    Extension           = '.ps1'
                    Name                = 'example_commands.ps1'
                    Exists              = 'True'
                    CreationTime        = '03 / 17 / 22 18:41:30'
                    CreationTimeUtc     = '03 / 17 / 22 23:41:30'
                    LastAccessTime      = '03 / 18 / 22 14:17:53'
                    LastAccessTimeUtc   = '03 / 18 / 22 19:17:53'
                    LastWriteTime       = '03 / 17 / 22 18:47:10'
                    LastWriteTimeUtc    = '03 / 17 / 22 23:47:10'
                    Attributes          = 'Archive'
                }
            } #endMock
            Mock -CommandName Get-ChildItem {
                [PSCustomObject]@{
                    PSChildName         = 'example_commands.ps1'
                    PSDrive             = 'C'
                    PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                    PSIsContainer       = 'False'
                    Mode                = '-a-- -'
                    ModeWithoutHardLink = '-a-- -'
                    BaseName            = 'example_commands'
                    Length              = '1513'
                    DirectoryName       = '{0}\pwshCloudCommands\src\Tests\asset' -f $env:HOME
                    Directory           = '{0}\pwshCloudCommands\src\Tests\asset' -f $env:HOME
                    IsReadOnly          = 'False'
                    FullName            = '{0}\pwshCloudCommands\src\Tests\asset\example_commands.ps1' -f $env:HOME
                    Extension           = '.ps1'
                    Name                = 'example_commands.ps1'
                    Exists              = 'True'
                    CreationTime        = '03 / 17 / 22 18:41:30'
                    CreationTimeUtc     = '03 / 17 / 22 23:41:30'
                    LastAccessTime      = '03 / 18 / 22 14:17:53'
                    LastAccessTimeUtc   = '03 / 18 / 22 19:17:53'
                    LastWriteTime       = '03 / 17 / 22 18:47:10'
                    LastWriteTimeUtc    = '03 / 17 / 22 23:47:10'
                    Attributes          = 'Archive'
                }
            } #endMock
            Mock -CommandName Read-TokenCommandsFromFile {
                $tokens = @(
                    [PSCustomObject]@{
                        Content     = 'Write-Host'
                        Type        = 'Command'
                        Start       = '12'
                        Length      = '10'
                        StartLine   = '2'
                        StartColumn = '1'
                        EndLine     = '2'
                        EndColumn   = '11'
                    },
                    [PSCustomObject]@{
                        Content     = 'Set-AWSCredentials'
                        Type        = 'Command'
                        Start       = '52'
                        Length      = '18'
                        StartLine   = '3'
                        StartColumn = '1'
                        EndLine     = '3'
                        EndColumn   = '19'
                    },
                    [PSCustomObject]@{
                        Content     = 'key-name'
                        Type        = 'CommandArgument'
                        Start       = '82'
                        Length      = '8'
                        StartLine   = '3'
                        StartColumn = '31'
                        EndLine     = '3'
                        EndColumn   = '39'
                    },
                    [PSCustomObject]@{
                        Content     = 'key-name'
                        Type        = 'CommandArgument'
                        Start       = '102'
                        Length      = '8'
                        StartLine   = '3'
                        StartColumn = '51'
                        EndLine     = '3'
                        EndColumn   = '59'
                    },
                    [PSCustomObject]@{
                        Content     = 'Get-SSMDocumentList'
                        Type        = 'Command'
                        Start       = '112'
                        Length      = '19'
                        StartLine   = '4'
                        StartColumn = '1'
                        EndLine     = '4'
                        EndColumn   = '20'
                    },
                    [PSCustomObject]@{
                        Content     = 'Get-SSMDocumentList'
                        Type        = 'Command'
                        Start       = '133'
                        Length      = '19'
                        StartLine   = '5'
                        StartColumn = '1'
                        EndLine     = '5'
                        EndColumn   = '20'
                    },
                    [PSCustomObject]@{
                        Content     = 'Start-EC2Instance'
                        Type        = 'Command'
                        Start       = '154'
                        Length      = '17'
                        StartLine   = '6'
                        StartColumn = '1'
                        EndLine     = '6'
                        EndColumn   = '18'
                    },
                    [PSCustomObject]@{
                        Content     = 'i-12345678'
                        Type        = 'CommandArgument'
                        Start       = '184'
                        Length      = '10'
                        StartLine   = '6'
                        StartColumn = '31'
                        EndLine     = '6'
                        EndColumn   = '41'
                    },
                    [PSCustomObject]@{
                        Content     = 'Get-S3Bucket'
                        Type        = 'Command'
                        Start       = '196'
                        Length      = '12'
                        StartLine   = '7'
                        StartColumn = '1'
                        EndLine     = '7'
                        EndColumn   = '13'
                    },
                    [PSCustomObject]@{
                        Content     = 'testbucket'
                        Type        = 'CommandArgument'
                        Start       = '221'
                        Length      = '10'
                        StartLine   = '7'
                        StartColumn = '26'
                        EndLine     = '7'
                        EndColumn   = '36'
                    },
                    [PSCustomObject]@{
                        Content     = 'Write-Output'
                        Type        = 'Command'
                        Start       = '233'
                        Length      = '12'
                        StartLine   = '8'
                        StartColumn = '1'
                        EndLine     = '8'
                        EndColumn   = '13'
                    },
                    [PSCustomObject]@{
                        Content     = 'aws'
                        Type        = 'Command'
                        Start       = '267'
                        Length      = '3'
                        StartLine   = '11'
                        StartColumn = '1'
                        EndLine     = '11'
                        EndColumn   = '4'
                    },
                    [PSCustomObject]@{
                        Content     = 's3'
                        Type        = 'CommandArgument'
                        Start       = '271'
                        Length      = '2'
                        StartLine   = '11'
                        StartColumn = '5'
                        EndLine     = '11'
                        EndColumn   = '7'
                    },
                    [PSCustomObject]@{
                        Content     = 'ls'
                        Type        = 'CommandArgument'
                        Start       = '274'
                        Length      = '2'
                        StartLine   = '11'
                        StartColumn = '8'
                        EndLine     = '11'
                        EndColumn   = '10'
                    },
                    [PSCustomObject]@{
                        Content     = 'aws'
                        Type        = 'Command'
                        Start       = '278'
                        Length      = '3'
                        StartLine   = '12'
                        StartColumn = '1'
                        EndLine     = '12'
                        EndColumn   = '4'
                    },
                    [PSCustomObject]@{
                        Content     = 'ec2'
                        Type        = 'CommandArgument'
                        Start       = '282'
                        Length      = '3'
                        StartLine   = '12'
                        StartColumn = '5'
                        EndLine     = '12'
                        EndColumn   = '8'
                    },
                    [PSCustomObject]@{
                        Content     = 'describe-instances'
                        Type        = 'CommandArgument'
                        Start       = '286'
                        Length      = '18'
                        StartLine   = '12'
                        StartColumn = '9'
                        EndLine     = '12'
                        EndColumn   = '27'
                    },
                    [PSCustomObject]@{
                        Content     = 'aws'
                        Type        = 'Command'
                        Start       = '306'
                        Length      = '3'
                        StartLine   = '13'
                        StartColumn = '1'
                        EndLine     = '13'
                        EndColumn   = '4'
                    },
                    [PSCustomObject]@{
                        Content     = 'ssm'
                        Type        = 'CommandArgument'
                        Start       = '310'
                        Length      = '3'
                        StartLine   = '13'
                        StartColumn = '5'
                        EndLine     = '13'
                        EndColumn   = '8'
                    },
                    [PSCustomObject]@{
                        Content     = 'get-parameters'
                        Type        = 'CommandArgument'
                        Start       = '314'
                        Length      = '14'
                        StartLine   = '13'
                        StartColumn = '9'
                        EndLine     = '13'
                        EndColumn   = '23'
                    },
                    [PSCustomObject]@{
                        Content     = '--names'
                        Type        = 'CommandArgument'
                        Start       = '329'
                        Length      = '7'
                        StartLine   = '13'
                        StartColumn = '24'
                        EndLine     = '13'
                        EndColumn   = '31'
                    },
                    [PSCustomObject]@{
                        Content     = 'my-parameter-name'
                        Type        = 'CommandArgument'
                        Start       = '337'
                        Length      = '17'
                        StartLine   = '13'
                        StartColumn = '32'
                        EndLine     = '13'
                        EndColumn   = '49'
                    },
                    [PSCustomObject]@{
                        Content     = 'Write-Host'
                        Type        = 'Command'
                        Start       = '372'
                        Length      = '10'
                        StartLine   = '16'
                        StartColumn = '1'
                        EndLine     = '16'
                        EndColumn   = '11'
                    },
                    [PSCustomObject]@{
                        Content     = 'Connect-AzAccount'
                        Type        = 'Command'
                        Start       = '414'
                        Length      = '17'
                        StartLine   = '17'
                        StartColumn = '1'
                        EndLine     = '17'
                        EndColumn   = '18'
                    },
                    [PSCustomObject]@{
                        Content     = 'Set-AzContext'
                        Type        = 'Command'
                        Start       = '433'
                        Length      = '13'
                        StartLine   = '18'
                        StartColumn = '1'
                        EndLine     = '18'
                        EndColumn   = '14'
                    },
                    [PSCustomObject]@{
                        Content     = 'Select-AzSubscription'
                        Type        = 'Command'
                        Start       = '448'
                        Length      = '21'
                        StartLine   = '19'
                        StartColumn = '1'
                        EndLine     = '19'
                        EndColumn   = '22'
                    },
                    [PSCustomObject]@{
                        Content     = 'my-subscription'
                        Type        = 'CommandArgument'
                        Start       = '488'
                        Length      = '15'
                        StartLine   = '19'
                        StartColumn = '41'
                        EndLine     = '19'
                        EndColumn   = '56'
                    },
                    [PSCustomObject]@{
                        Content     = 'Get-AzResourceGroup'
                        Type        = 'Command'
                        Start       = '505'
                        Length      = '19'
                        StartLine   = '20'
                        StartColumn = '1'
                        EndLine     = '20'
                        EndColumn   = '20'
                    },
                    [PSCustomObject]@{
                        Content     = 'my-resource-group'
                        Type        = 'CommandArgument'
                        Start       = '531'
                        Length      = '17'
                        StartLine   = '20'
                        StartColumn = '27'
                        EndLine     = '20'
                        EndColumn   = '44'
                    },
                    [PSCustomObject]@{
                        Content     = 'az'
                        Type        = 'Command'
                        Start       = '565'
                        Length      = '2'
                        StartLine   = '23'
                        StartColumn = '1'
                        EndLine     = '23'
                        EndColumn   = '3'
                    },
                    [PSCustomObject]@{
                        Content     = 'account'
                        Type        = 'CommandArgument'
                        Start       = '568'
                        Length      = '7'
                        StartLine   = '23'
                        StartColumn = '4'
                        EndLine     = '23'
                        EndColumn   = '11'
                    },
                    [PSCustomObject]@{
                        Content     = 'list'
                        Type        = 'CommandArgument'
                        Start       = '576'
                        Length      = '4'
                        StartLine   = '23'
                        StartColumn = '12'
                        EndLine     = '23'
                        EndColumn   = '16'
                    },
                    [PSCustomObject]@{
                        Content     = 'az'
                        Type        = 'Command'
                        Start       = '582'
                        Length      = '2'
                        StartLine   = '24'
                        StartColumn = '1'
                        EndLine     = '24'
                        EndColumn   = '3'
                    },
                    [PSCustomObject]@{
                        Content     = 'group'
                        Type        = 'CommandArgument'
                        Start       = '585'
                        Length      = '5'
                        StartLine   = '24'
                        StartColumn = '4'
                        EndLine     = '24'
                        EndColumn   = '9'
                    },
                    [PSCustomObject]@{
                        Content     = 'list'
                        Type        = 'CommandArgument'
                        Start       = '591'
                        Length      = '4'
                        StartLine   = '24'
                        StartColumn = '10'
                        EndLine     = '24'
                        EndColumn   = '14'
                    },
                    [PSCustomObject]@{
                        Content     = 'az'
                        Type        = 'Command'
                        Start       = '597'
                        Length      = '2'
                        StartLine   = '25'
                        StartColumn = '1'
                        EndLine     = '25'
                        EndColumn   = '3'
                    },
                    [PSCustomObject]@{
                        Content     = 'vm'
                        Type        = 'CommandArgument'
                        Start       = '600'
                        Length      = '2'
                        StartLine   = '25'
                        StartColumn = '4'
                        EndLine     = '25'
                        EndColumn   = '6'
                    },
                    [PSCustomObject]@{
                        Content     = 'list'
                        Type        = 'CommandArgument'
                        Start       = '603'
                        Length      = '4'
                        StartLine   = '25'
                        StartColumn = '7'
                        EndLine     = '25'
                        EndColumn   = '11'
                    }
                )
                return $tokens
            } #endMock
            Mock -CommandName Get-CloudCommandFromToken {
                [PSCustomObject]@{
                    Name        = 'Get-SSMDocumentList'
                    Synopsis    = 'Calls the AWS Systems Manager ListDocuments API operation.'
                    Description = 'Returns all Systems Manager (SSM) documents in the current Amazon Web Services account and Amazon Web Services Region. You can limit the results of this request by using a filter.This cmdlet automatically pages all available results to the pipeline - parameters related to iteration are only needed if you want to manually control the paginated output. To disable autopagination, use -NoAutoIteration.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Get'
                    Noun        = 'SSMDocumentList'
                    ModuleName  = 'AWS.Tools.SimpleSystemsManagement'
                }
            } #endMock
            Mock -CommandName Format-FileFinding {
                [PSCustomObject]@{
                    ModuleName = 'AWS.Tools.SimpleSystemsManagement'
                    Functions  = 'Get-SSMDocumentList'
                    FileName   = 'sample_commands.ps1'
                    FilePath   = '{0}\pwshCloudCommands\src\Tests\asset\sample_commands.ps1' -f $env:HOME
                }
            } #endMock
        } #beforeEach
        Context 'Error' {

            It 'should return null if the xml data set can not be sourced' {
                Mock -CommandName Invoke-XMLDataCheck {
                    $false
                } #endMock
                Get-CloudCommandFromFile -Path $path | Should -BeNullOrEmpty
            } #it

            It 'should throw if an error is encountered getting item info' {
                Mock -CommandName Get-Item {
                    throw 'Fake Error'
                } #endMock
                { Get-CloudCommandFromFile -Path $path } | Should -Throw
            } #it

            It 'should return null if no PowerShell files are found' {
                Mock -CommandName Get-AllPowerShellFile {
                    $null
                } #endMock
                Get-CloudCommandFromFile -Path $path | Should -BeNullOrEmpty
            } #it

            It 'should throw if an error is encountered getting file info' {
                Mock -CommandName Get-Item {
                    [PSCustomObject]@{
                        PSIsContainer = $false
                    }
                } #endMock
                Mock -CommandName Get-ChildItem {
                    throw 'Fake Error'
                } #endMock
                { Get-CloudCommandFromFile -Path $path } | Should -Throw
            } #it

            It 'should return null if single file is not a PowerShell file' {
                Mock -CommandName Get-Item {
                    [PSCustomObject]@{
                        PSIsContainer = $false
                    }
                } #endMock
                Mock -CommandName Get-ChildItem {
                    [PSCustomObject]@{
                        Extension = '.txt'
                    }
                } #endMock
                Get-CloudCommandFromFile -Path $path | Should -BeNullOrEmpty
            } #it

        } #context_Error
        Context 'Success' {

            It 'should return the expected results' {
                $eval = Get-CloudCommandFromFile -Path $path
                $eval.FileName | Should -BeExactly 'example_commands.ps1'
                ($eval | Measure-Object).Count                  | Should -BeExactly 1
                ($eval.CloudCommands | Measure-Object).Count    | Should -BeExactly 1
                $eval.CloudCommands.ModuleName                  | Should -Contain 'AWS.Tools.SimpleSystemsManagement'
            } #it

        } #context_Success
    } #describe_Get-CloudCommandFromFile
} #inModule
