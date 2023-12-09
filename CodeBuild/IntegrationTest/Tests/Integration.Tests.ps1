# $env:ARTIFACT_S3_BUCKET = the artifact bucket used by CB
# $env:S3_PREFIX = the artifact prefix used by CB
# $env:GIT_REPO = the git repo name
# $env:AWS_ACCOUNTID = the AWS Account hosting the service under test
# $env:SERVICE_NAME = name of the project

Describe -Name 'Infrastructure Tests' -Fixture {
    BeforeAll {
        try {
            $cfnExports = Get-CFNExport -ErrorAction Stop
        }
        catch {
            throw
        }
        $script:ServiceName = $env:SERVICE_NAME
        $script:AWSRegion = $env:AWS_REGION
        $script:AWSAccountID = $env:AWS_ACCOUNTID
    } #before_all

    Context -Name 'pscc.yml' -Fixture {

        It -Name 'Should create a PSCCFinalXMLBucketARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSCCFinalXMLBucketARN" }).Value
            $expected = 'arn:aws:s3::*'
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a PSCCCloudFrontLogBucketARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSCCCloudFrontLogBucketARN" }).Value
            $expected = 'arn:aws:s3::*'
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a CloudFront distribution' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSCCCloudFrontDistributionDomain" }).Value
            $expected = '*.cloudfront.net'
            $assertion | Should -BeLike $expected
        } #it

    } #context_pscc.yml

    Context -Name 'pscc_ssm.yml' -Fixture {

        It -Name 'Should create a SSM Maintenance Window' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-PSCCMaintWindowID" }).Value
            $expected = 'mw-*'
            $assertion | Should -BeLike $expected
        } #it

    } #context_pscc_ssm.yml

    Context -Name 'pscc_alarms.yml' -Fixture {

        It -Name 'Should create a pwshCCPubXMLMonitorAlarmARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-pwshCCPubXMLMonitorAlarmARN" }).Value
            $expected = 'arn:aws:cloudwatch:{0}:{1}:*' -f $env:AWSRegion, $env:AWSAccountId
            $assertion | Should -BeLike $expected
        } #it

        It -Name 'Should create a pwshCCPubXMLMonitorARN' -Test {
            $assertion = ($cfnExports | Where-Object { $_.Name -eq "$ServiceName-pwshCCPubXMLMonitorARN" }).Value
            $expected = 'arn:aws:lambda:{0}:{1}:*' -f $env:AWSRegion, $env:AWSAccountId
            $assertion | Should -BeLike $expected
        } #it

    } #context_pscc_alarms.yml

} #describe_infra_tests
