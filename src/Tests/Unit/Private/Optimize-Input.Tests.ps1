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
    Describe 'Optimize-Input' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all
        BeforeEach {
            Mock -CommandName Remove-StopWord -MockWith {
                @(
                    'write',
                    'object',
                    'bucket'
                )
            } #endMock
        } #before_each
        Context 'Error' {

            It 'should return null if the user provides just space based input' {
                Optimize-Input -SearchInput '                         ' | Should -BeNullOrEmpty
            } #it

        } #context_Error
        Context 'Success' {

            It 'should return expected results' {
                $eval = Optimize-Input -SearchInput 'write object to bucket'
                $eval.Verbs | Should -Contain 'write'
                $eval.Terms | Should -Contain 'object'
                $eval.Terms | Should -Contain 'bucket'
            } #it

        } #context_Success
    } #describe_Optimize-Input
} #inModule
