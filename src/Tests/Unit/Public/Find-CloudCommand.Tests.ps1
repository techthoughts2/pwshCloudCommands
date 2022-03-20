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
    Describe 'Find-CloudCommand' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            Mock -CommandName Invoke-XMLDataCheck {
                $true
            } #endMock
            Mock -CommandName Search-XMLDataSet {
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
            Mock -CommandName Optimize-Input {
                [PSCustomObject]@{
                    Verbs = @(
                        'Write'
                    )
                    Terms = @(
                        'object',
                        'oracle',
                        'cloud'
                    )
                }
            } #endMock
        } #beforeEach
        Context 'Error' {

            It 'should return null if the xml data set can not be sourced' {
                Mock -CommandName Invoke-XMLDataCheck {
                    $false
                } #endMock
                Find-CloudCommand -Query 'Connect-Az*' | Should -BeNullOrEmpty
            } #it

        } #context_Error
        Context 'Parameters' {

            It 'parameters should be correct for function query' {
                Mock -CommandName Search-XMLDataSet {
                    $FunctionQuery | Should -BeExactly 'Write-S3Object'
                    $Filter | Should -BeExactly 'AWS'
                } -Verifiable
                Find-CloudCommand -Query 'Write-S3Object' -Filter 'AWS'
                Assert-VerifiableMock
            } #it

            It 'parameters should be correct for wildcard query' {
                Mock -CommandName Search-XMLDataSet {
                    $WildCardQuery | Should -BeExactly 'Connect-Az*'
                    $Filter | Should -BeExactly 'Azure'
                } -Verifiable
                Find-CloudCommand -Query 'Connect-Az*' -Filter 'Azure'
                Assert-VerifiableMock
            } #it

            It 'parameters should be correct for free-form query' {
                Mock -CommandName Search-XMLDataSet {
                    $Query | Should -Not -BeNullOrEmpty
                    $Filter | Should -BeExactly 'Oracle'
                } -Verifiable
                Find-CloudCommand -Query 'Write an object to Oracle Cloud' -Filter 'Oracle'
                Assert-VerifiableMock
            } #it

        } #context_Parameters
        Context 'Success' {

            It 'should return null if no results are found' {
                Mock -CommandName Search-XMLDataSet {
                    $null
                } #endMock
                Find-CloudCommand -Query 'Not-ACommand' | Should -BeNullOrEmpty
            } #it

            It 'should return the expected results' {
                $eval = Find-CloudCommand -Query 'Write an object to Oracle Cloud' -Filter 'Oracle'
                $eval.Name = 'Get-SSMDocumentList'
                $eval.ModuleName = 'AWS.Tools.SimpleSystemsManagement'
            } #it

        } #context_Success
    } #describe_Find-CloudCommand
} #inModule
