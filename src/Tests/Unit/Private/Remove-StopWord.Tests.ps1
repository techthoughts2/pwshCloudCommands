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
    Describe 'Remove-StopWord' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #before_all
        BeforeEach {
            $searchInput = @(
                'write',
                'object',
                'to',
                'bucket'
            )
        } #before_each
        Context 'Success' {

            It 'should return expected results' {
                $eval = Remove-StopWord -SearchInput $searchInput
                $eval | Should -Not -Contain 'to'
                $eval | Should -Contain 'write'
                $eval | Should -Contain 'object'
                $eval | Should -Contain 'bucket'

            } #it

        } #context_Success
    } #describe_Remove-StopWord
} #inModule
