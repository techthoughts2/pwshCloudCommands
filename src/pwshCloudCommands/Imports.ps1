# This is a locally sourced Imports file for local development.
# It can be imported by the psm1 in local development to add script level variables.
# It will merged in the build process. This is for local development only.

# region script variables
# $script:resourcePath = "$PSScriptRoot\Resources"

function Get-DataLocation {
    $folderName = 'pwshCloudCommands'
    if ($PROFILE) {
        $script:dataPath = (Join-Path (Split-Path -Parent $PROFILE) $folderName)
    }
    else {
        $script:dataPath = "~\${$folderName}"
    }
}

$domain = 'cloudfront.net'
$target = 'd42gqkczylm43'
Get-DataLocation
$script:dataFolderZip = 'pwshcloudcommands.zip'
$script:dataFolder = 'pwshcloudcommandsXML'
$script:dlURI = '{0}.{1}' -f $target, $domain
