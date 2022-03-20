#region aws

Set-AWSCredentials -AccessKey key-name -SecretKey key-name
Set-DefaultAWSRegion -Region us-east-2

Get-SSMDocumentDescription -Name "AWS-RunPowerShellScript"

$runPSCommand = Send-SSMCommand `
    -InstanceIds @("instance-ID-1", "instance-ID-2") `
    -DocumentName "AWS-RunPowerShellScript" `
    -Comment "Demo AWS-RunPowerShellScript with two instances" `
    -Parameter @{'commands' = @('dir C:\Users', 'dir C:\') }
Get-SSMCommand `
    -CommandId $runPSCommand.CommandId

Start-EC2Instance -InstanceIds i-10a64379
Stop-EC2Instance -InstanceIds i-10a64379

#endregion

#region azure

Connect-AzAccount
Connect-AzAccount -Environment AzureChinaCloud
$tenantId = (Get-AzContext).Tenant.Id
$sp = New-AzADServicePrincipal -DisplayName ServicePrincipalName
# Retrieve the plain text password for use with `Get-Credential` in the next command.
$sp.PasswordCredentials.SecretText

$pscredential = Get-Credential -UserName $sp.AppId
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId

$context = Get-AzSubscription -SubscriptionId
Set-AzContext $context

Get-AzVM -ResourceGroupName QueryExample | Format-Table -Property Name, ResourceGroupName, Location

#endregion

#region oracle

Get-OCIObjectStorageNamespace

Get-OCIAuditConfiguration -CompartmentId $env:CompartmentId

Set-OCIClientSession -RegionId "us-ashburn-1" -Profile "Test" -Config "~/.oci/testconfig"

Get-OCIClientSession

Get-OCIComputeImagesList -CompartmentId $Env:CompartmentId -Limit 5 | Measure-Object

#endregion
