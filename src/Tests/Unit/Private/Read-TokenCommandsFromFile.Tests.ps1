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
    Describe 'Read-TokenCommandsFromFile' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            $path = '{0}\pathToEvaluate' -f $env:HOME
            Mock -CommandName Test-Path -MockWith {
                $true
            } #endMock
            Mock -CommandName Get-Content -MockWith {
                @'
                Write-Host 'Running some AWS commands'
                Set-AWSCredentials -AccessKey key-name -SecretKey key-name
                Get-SSMDocumentList
                Start-EC2Instance -InstanceId i-12345678
                Get-S3Bucket -BucketName testbucket
                Write-Output 'Done'
'@
            } #endMock
        } #beforeEach
        Context 'Error' {

            It 'should throw an error if the file does not exist' {
                Mock -CommandName Test-Path -MockWith {
                    $false
                } #endMock
                { Read-TokenCommandsFromFile -FilePath $path } | Should -Throw
            } #it

            It 'should throw an error if the file contents can not be retrieved' {
                Mock -CommandName Get-Content -MockWith {
                    throw 'Fake Error'
                } #endMock
                { Read-TokenCommandsFromFile -FilePath $path } | Should -Throw
            } #it

        } #context_Error
        Context 'Success' {

            It 'should return null if the file is empty' {
                Mock -CommandName Get-Content -MockWith { } #endMock
                Read-TokenCommandsFromFile -FilePath $path | Should -BeNullOrEmpty
            } #it

            It 'should identify the correct number of commands' {
                $eval = Read-TokenCommandsFromFile -FilePath $path
                $eval.count | Should -BeExactly 10
            } #it

        } #context_Success
    } #describe_Read-TokenCommandsFromFile
} #inModule
