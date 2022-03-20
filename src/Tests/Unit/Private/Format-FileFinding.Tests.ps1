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
    Describe 'Format-FileFinding' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            $cloudCommandObj = @(
                [PSCustomObject]@{
                    Name        = 'Get-SSMDocumentList'
                    Synopsis    = 'Calls the AWS Systems Manager ListDocuments API operation.'
                    Description = 'Returns all Systems Manager (SSM) documents in the current Amazon Web Services account and Amazon Web Services Region. You can limit the results of this request by using a filter.This cmdlet automatically pages all available results to the pipeline - parameters related to iteration are only needed if you want to manually control the paginated output. To disable autopagination, use -NoAutoIteration.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Get'
                    Noun        = 'SSMDocumentList'
                    ModuleName  = 'AWS.Tools.SimpleSystemsManagement'
                },
                [PSCustomObject]@{
                    Name        = 'Get-SSMDocumentList'
                    Synopsis    = 'Calls the AWS Systems Manager ListDocuments API operation.'
                    Description = 'Returns all Systems Manager (SSM) documents in the current Amazon Web Services account and Amazon Web Services Region. You can limit the results of this request by using a filter.This cmdlet automatically pages all available results to the pipeline - parameters related to iteration are only needed if you want to manually control the paginated output. To disable autopagination, use -NoAutoIteration.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Get'
                    Noun        = 'SSMDocumentList'
                    ModuleName  = 'AWS.Tools.SimpleSystemsManagement'
                },
                [PSCustomObject]@{
                    Name        = 'Start-EC2Instance'
                    Synopsis    = 'Calls the Amazon Elastic Compute Cloud (EC2) StartInstances API operation.'
                    Description = 'Starts an Amazon EBS-backed instance that you&#39;ve previously stopped.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Start'
                    Noun        = 'EC2Instance'
                    ModuleName  = 'AWS.Tools.EC2'
                },
                [PSCustomObject]@{
                    Name        = 'Get-AzResource'
                    Synopsis    = 'Gets resources.'
                    Description = 'The Get-AzResource cmdlet gets Azure resources.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Get'
                    Noun        = 'AzResource'
                    ModuleName  = 'Az.Resources'
                },
                [PSCustomObject]@{
                    Name        = 'Get-AzResourceGroup'
                    Synopsis    = 'Gets resource groups.'
                    Description = 'The Get-AzResourceGroup cmdlet gets Azure resource groups in the current subscription. You can get all resource groups, or specify a resource group by name or by other properties. By default, this cmdlet gets all resource groups in the current subscription. For more information about Azure resources and Azure resource groups, see the New-AzResourceGroup cmdlet.'
                    CommandType = 'Cmdlet'
                    Verb        = 'Get'
                    Noun        = 'AzResourceGroup'
                    ModuleName  = 'Az.Resources'
                }
            )
            $fileInfo = [PSCustomObject]@{
                Name     = 'example_commands.ps1'
                FullName = '{0}\example_commands.ps1' -f $env:TEMP
            }
        } #beforeEach
        Context 'Success' {

            It 'should return the expected results' {
                $eval = Format-FileFinding -CloudCommandObj $cloudCommandObj -FileInfo $fileInfo
                $eval.count       | Should -BeExactly 3
                $eval.FileName    | Should -Contain 'example_commands.ps1'
                $eval.ModuleName  | Should -Contain 'Az.Resources'
                $eval.ModuleName  | Should -Contain 'AWS.Tools.EC2'
                $eval.ModuleName  | Should -Contain 'AWS.Tools.SimpleSystemsManagement'
            } #it

        } #context_Success
    } #describe_Format-FileFinding
} #inModule
