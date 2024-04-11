#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'pwshCloudCommands'
#-------------------------------------------------------------------------
#if the module is already in memory, remove it
Get-Module $ModuleName | Remove-Module -Force
$PathToManifest = [System.IO.Path]::Combine('..', '..', 'Artifacts', "$ModuleName.psd1")
#-------------------------------------------------------------------------
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
InModuleScope 'pwshCloudCommands' {
    Describe 'Infrastructure Tests' -Tag Infrastructure {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $ProgressPreference = 'SilentlyContinue'
            $PathToAssets = [System.IO.Path]::Combine('..', 'asset')
        } #beforeAll
        Context 'Find-CloudCommand' {

            It 'should return expected results for a function query' {
                $eval = Find-CloudCommand -Query Write-S3Object -Filter AWS
                $eval.Name | Should -BeExactly 'Write-S3Object'
                $eval.ModuleName | Should -BeExactly 'AWS.Tools.S3'
            } #it

            It 'should return expected results from a wildcard query' {
                $eval = Find-CloudCommand -Query 'Conn*Az*' -Filter Azure
                $eval.Count | Should -BeGreaterThan 1
            } #it

            It 'should return expected results from a freeform query' {
                $eval = Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS
                $eval.Count | Should -Not -BeGreaterThan 30
            } #it

            It 'should return expected results from a freeform query with allresults' {
                $eval = Find-CloudCommand -Query 'download an object from a S3 bucket' -Filter AWS -AllResults
                $eval.Count | Should -BeGreaterThan 20
            } #it

            It 'should return expected results for graph module query' {
                $eval = Find-CloudCommand -Query 'Get-MgUser' -Filter Azure
                $eval.ModuleName | Should -BeExactly 'Microsoft.Graph.Users'
            } #it

            It 'should return expected results for oracle module query' {
                $eval = Find-CloudCommand -Query 'New-OCIComputeInstance' -Filter Oracle
                $eval.ModuleName | Should -BeExactly 'OCI.PSModules.Core'
            } #it

        } #context_Find-CloudCommand
        Context 'Get-CloudCommandFromFile' {

            It 'should return expected results' {
                $eval = Get-CloudCommandFromFile -Path $PathToAssets
                $eval.Count | Should -BeExactly 2
                $eval.CloudCommands.Count | Should -BeGreaterThan 10
            } #it

        } #context_Get-CloudCommandFromFile
        Context 'Get-AllCloudCommandInfo' {

            It 'should return expected results' {
                $eval = Get-AllCloudCommandInfo -Filter AWS
                $eval.Count | Should -BeGreaterThan 500
            } #it

        } #context_Get-CloudCommandFromFile
    } #describe
} #inModule
