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
    Describe 'Search-XMLDataSet' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $ProgressPreference = 'SilentlyContinue'
        } #before_all
        BeforeEach {
            $cleanQuery = [PSCustomObject]@{
                Verbs = @(
                    'write'
                )
                Terms = @(
                    'object',
                    'bucket'
                )
            }
            $xmlObj = [PSCustomObject]@{
                PSChildName         = 'AWS.Tools.S3.xml'
                PSDrive             = 'C'
                PSProvider          = 'Microsoft.PowerShell.Core\FileSystem'
                PSIsContainer       = 'False'
                Mode                = '-a---'
                ModeWithoutHardLink = '-a---'
                BaseName            = 'AWS.Tools.S3'
                Length              = '255850'
                DirectoryName       = '{0}\Users\user\Documents\PowerShell\pwshCloudCommands\pwshcloudcommandsXML' -f $env:HOME
                Directory           = '{0}Users\user\Documents\PowerShell\pwshCloudCommands\pwshcloudcommandsXML' -f $env:HOME
                IsReadOnly          = 'False'
                FullName            = '{0}Users\user\Documents\PowerShell\pwshCloudCommands\pwshcloudcommandsXML\AWS.Tools.S3.xml' -f $env:HOME
                Extension           = '.xml'
                Name                = 'AWS.Tools.S3.xml'
                Exists              = 'True'
                CreationTime        = '03/13/22 23:08:29'
                CreationTimeUtc     = '03/14/22 04:08:29'
                LastAccessTime      = '03/15/22 09:04:02'
                LastAccessTimeUtc   = '03/15/22 14:04:02'
                LastWriteTime       = '03/09/22 22:10:26'
                LastWriteTimeUtc    = '03/10/22 04:10:26'
                Attributes          = 'Archive'
            }
            $objData = [PSCustomObject]@{
                Name             = 'AWS.Tools.S3'
                Description      = @'
The S3 module of AWS Tools for PowerShell lets developers and administrators manage Amazon Simple Storage Service (S3) from the PowerShell scripting environment. In
order to manage each AWS service, install the corresponding module (e.g. AWS.Tools.EC2, AWS.Tools.S3...).
The module AWS.Tools.Installer (https://www.powershellgallery.com/packages/AWS.Tools.Installer/) makes it easier to install, update and uninstall the AWS.Tools modules.
This version of AWS Tools for PowerShell is compatible with Windows PowerShell 5.1+ and PowerShell Core 6+ on Windows, Linux and macOS. When running on Windows
PowerShell, .NET Framework 4.7.2 or newer is required. Alternative modules AWSPowerShell.NetCore and AWSPowerShell, provide support for all AWS services from a
single module and also support older versions of Windows PowerShell and .NET Framework.
'@
                Tags             = @(
                    'AWS',
                    'cloud',
                    'Windows',
                    'PSEdition_Desktop',
                    'PSEdition_Core',
                    'Linux',
                    'MacOS',
                    'Mac',
                    'AWS',
                    'cloud',
                    'Windows',
                    'PSEdition_Desktop',
                    'PSEdition_Core',
                    'Linux',
                    'MacOS',
                    'Mac'
                )
                Version          = '4.1.40.0'
                ExportedCommands = @{
                    'Write-S3Object'            = 'Write-S3Object'
                    'Get-S3Bucket'              = 'Get-S3Bucket'
                    'Remove-S3MultipartUploads' = 'Remove-S3MultipartUploads'
                }
                Functions        = @(
                    [PSCustomObject]@{
                        Name        = 'Write-S3Object'
                        Synopsis    = 'Uploads one or more files from the local file system to an S3 bucket.'
                        Description = @'
Uploads a local file, text content or a folder hierarchy of files to Amazon S3, placing them into the specified bucket using the specified key (single object) or
key prefix (multiple objects). If you are uploading large files, Write-S3Object cmdlet will use multipart upload to fulfill the request.  If a multipart upload is interrupted, Write-S3Object cmdlet
will attempt to abort the multipart upload. Under certain circumstances (network outage, power failure, etc.), Write-S3Object cmdlet will not be able to abort the multipart upload.  In this case,
in order to stop getting charged for the storage of uploaded parts,  you should manually invoke the Remove-S3MultipartUploads to abort the incomplete multipart uploads.
'@
                        CommandType = 'Cmdlet'
                        Verb        = 'Write'
                        Noun        = 'S3Object'
                    },
                    [PSCustomObject]@{
                        Name        = 'Get-S3Bucket'
                        Synopsis    = 'Calls the Amazon Simple Storage Service (S3) ListBuckets API operation.'
                        Description = 'Returns a list of all buckets owned by the authenticated sender of the request. To use this operation, you must have the s3:ListAllMyBuckets permission.'
                        CommandType = 'Cmdlet'
                        Verb        = 'Get'
                        Noun        = 'S3Bucket'
                    },
                    [PSCustomObject]@{
                        DisplayName     = 'Remove-S3MultipartUploads'
                        CommandType     = @{
                            Value = 'Alias'
                        }
                        ResolvedCommand = 'Remove-S3MultipartUpload'
                    }
                )
            } #objData
            Mock -CommandName Get-ChildItem -MockWith {
                $xmlObj
            } #endMock
            Mock -CommandName Get-Content -MockWith {
                'This content contains information about the AWS.Tools.S3 module.
                It also contains information about how to write and object to
                a S3 bucket using Write-S3Object.'
            } #endMock
            Mock -CommandName ConvertFrom-Clixml -MockWith {
                $objData
            } #endMock
        } #before_each
        Context 'Error' {

            It 'should throw if an error is encountered getting xml files' {
                Mock -CommandName Get-ChildItem -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Search-XMLDataSet -Query $cleanQuery } | Should -Throw
            } #it

            It 'should throw if an error is encountered getting xml file content' {
                Mock -CommandName Get-Content -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Search-XMLDataSet -Query $cleanQuery } | Should -Throw
                { Search-XMLDataSet -FunctionQuery 'Write-S3Object' } | Should -Throw
                { Search-XMLDataSet -WildCardQuery 'write-s3*' } | Should -Throw
                { Search-XMLDataSet -AllInfo } | Should -Throw
            } #it

        } #context_Error
        Context 'Filter' {

            It 'should filter properly for AWS based on user input' {
                Mock -CommandName Get-ChildItem {
                    $Filter | Should -BeExactly 'AWS.Tools.*'
                    # $ErrorAction | Should -BeExactly 'Stop'
                    $xmlObj
                } -Verifiable
                Search-XMLDataSet -Query $cleanQuery -Filter AWS

                Assert-VerifiableMock
                Should -Invoke -CommandName Get-ChildItem -Times 1 -Exactly
            } #it

            It 'should filter properly for Azure based on user input' {
                $script:mockCalled = 0
                Mock -CommandName Get-ChildItem -MockWith {
                    $script:mockCalled++
                    if ($script:mockCalled -eq 1) {
                        $Filter | Should -BeExactly 'Az.*'
                    }
                    elseif ($script:mockCalled -eq 2) {
                        $Filter | Should -BeExactly 'Microsoft.Graph.*'
                    }
                    # Return a mock XML object or similar to simulate the command's output
                    return $mockXmlObj
                }

                Search-XMLDataSet -Query $cleanQuery -Filter Azure

                Should -Invoke -CommandName Get-ChildItem -Times 2 -Exactly
            } #it

            It 'should filter properly for Oracle based on user input' {
                Mock -CommandName Get-ChildItem {
                    $Filter | Should -BeExactly 'OCI.*'
                    # $ErrorAction | Should -BeExactly 'Stop'
                    $xmlObj
                } -Verifiable
                Search-XMLDataSet -Query $cleanQuery -Filter Oracle

                Assert-VerifiableMock
                Should -Invoke -CommandName Get-ChildItem -Times 1 -Exactly
            } #it

            It 'should filter properly for free form query based on user input' {
                Mock -CommandName Get-ChildItem {
                    $Filter | Should -BeExactly '*'
                    # $ErrorAction | Should -BeExactly 'Stop'
                    $xmlObj
                } -Verifiable
                Search-XMLDataSet -Query $cleanQuery

                Assert-VerifiableMock
                Should -Invoke -CommandName Get-ChildItem -Times 1 -Exactly
            } #it

        } #context_Filter
        Context 'Success' {

            It 'should return null if raw file info does not contain search params' {
                Mock -CommandName Get-Content -MockWith {
                    'This content contains absolutely nothing about what we are searching for.'
                } #endMock
                $eval1 = Search-XMLDataSet -Query $cleanQuery
                $eval2 = Search-XMLDataSet -FunctionQuery 'Write-S3Object'
                $eval3 = Search-XMLDataSet -WildCardQuery 'write-s3*'
                $eval1 | Should -BeNullOrEmpty
                $eval2 | Should -BeNullOrEmpty
                $eval3 | Should -BeNullOrEmpty
            } #it

            It 'should return null if an alias match is found' {
                Mock -CommandName Get-Content -MockWith {
                    'This content contains info about Remove-S3MultipartUploads'
                } #endMock
                $eval1 = Search-XMLDataSet -FunctionQuery 'Remove-S3MultipartUploads'
                $eval2 = Search-XMLDataSet -WildCardQuery 'Remove-S3MultipartUp*s'
                $eval1 | Should -BeNullOrEmpty
                $eval2 | Should -BeNullOrEmpty
            } #it

            It 'should return expected results for a query' {
                $eval = Search-XMLDataSet -Query $cleanQuery
                $eval.Count | Should -BeGreaterThan 1
            } #it

            It 'should return null if no result is found for a query' {
                $cleanQuery2 = @(
                    'azure',
                    'stuff'
                )
                Search-XMLDataSet -Query $cleanQuery2 | Should -BeNullOrEmpty
            } #it

            It 'should return expected results for a Function query' {
                $eval = Search-XMLDataSet -FunctionQuery 'Write-S3Object'
                $eval.Name | Should -BeExactly 'Write-S3Object'
                $eval.Verb | Should -BeExactly 'Write'
                $eval.Noun | Should -BeExactly 'S3Object'
            } #it

            It 'should return null if no result is found for a Function query' {
                Search-XMLDataSet -FunctionQuery 'Write-S3NotReal' | Should -BeNullOrEmpty
            } #it

            It 'should return expected results for a Wildcard query' {
                $eval = Search-XMLDataSet -WildcardQuery '*S3*'
                $eval.Count | Should -BeGreaterThan 1
            } #it

            It 'should return null if no result is found for a Wildcard query' {
                Search-XMLDataSet -WildcardQuery 'Get-Az*' | Should -BeNullOrEmpty
            } #it

            It 'should return expected results when retrieving all commands' {
                $eval = Search-XMLDataSet -AllInfo
                $eval.Count | Should -BeGreaterThan 1
            } #it

            It 'should return null if no result is found for a Wildcard query' {
                Search-XMLDataSet -WildcardQuery 'Get-Az*' | Should -BeNullOrEmpty
            } #it

        } #context_Success
    } #describe_Search-XMLDataSet
} #inModule
