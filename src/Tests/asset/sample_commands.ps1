#region aws

Set-AWSCredentials -AccessKey key-name -SecretKey key-name
Get-SSMDocumentList
Get-SSMDocumentList
Start-EC2Instance -InstanceId i-12345678
Get-S3Bucket -BucketName testbucket
Write-Output 'Done'

# aws cli
aws s3 ls
aws ec2 describe-instances
aws ssm get-parameters --names my-parameter-name

#endregion

#region azure

# azure pwsh
Connect-AzAccount
Set-AzContext
Select-AzSubscription -SubscriptionName my-subscription
Get-AzResourceGroup -Name my-resource-group

# azure cli
az account list
az group list
az vm list

#endregion
