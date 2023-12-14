# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<<<<<<< HEAD
## [Not Released]

- Build Updates:
    - GitHub Actions CI/CD changes:
        - Build will now ignore `docs` folder and all `.md` file updates. Builds will not be triggered if only these are updated.
        - Updated `checkout@v2` to `checkout@v3`
        - Updated `upload-artifact@v2` to `upload-artifact@v3`
    - Moved `CHANGELOG.md` from `.github` directory to `docs` directory
    - Updated VSCode `tasks.json`
    - Added a `SECURITY.md` file for the project
    - Updated buildspec files to dotnet 6.0
    - Updated `install_modules.ps1` - removed modules not used and bumped module versions
    - CodeBuild now uses PSGallery for module installs
    - Updated CloudFront Distribution from OriginAccessIdentity to OriginAccessControl
    - Removed un-used SSM Hybrid role
    - Updated tags on infra
    - Updated CodeBuild Linux image from `aws/codebuild/standard:5.0` to `aws/codebuild/standard:6.0`
    - Added log retention groups to all CodeBuild projects
=======
## [1.0.0]

- Module Changes
    - Updated module requirement for `Convert` from `0.6.0` to `1.5.0`
    - Minor updates to `Invoke-XMLDataCheck` for code readability
    - `Confirm-XMLDataSet` now evaluates `LastWriteTime` instead of `CreationTime` to determine cache freshness requirements
    - `Find-CloudCommand` - updated help
    - `Get-AllCloudCommandInfo` - updated help
    - `Get-CloudCommandFromFile` - updated help
- Build Updates
    - Updated all Github action files to:
        - support ignore certain files for Readthedocs implementation
        - updated actions from `v2` to `v3`
    - Moved CHANGELOG from `.github` to `docs`
    - `actions_bootstrap.ps1` - bumped module versions to latest
    - All Infra/Infrastructure references changed to Integration
    - Removed all test case uses of `Assert-MockCalled`
    - Added additional unit tests for `Invoke-XMLDataCheck`
    - AWS Deployment Updates
        - Added Lambda function to metric age of data cache
        - Updated CodeBuild Integration tests
        - Changed alarm for cache data to reference correct SNS topic for alerts
        - Added CloudWatch dashboard for data cache age metric
- Misc
    - Updated README to reference new badge urls for Github actions
    - Updated `settings.json` for tab requirements to support Readthedocs
    - Added `SECURITY.md`
    - Updated `tasks.json` for cleaner references and additional tasks
    - Updated `LICENSE` year
    - Added metric dashboards to docs section
>>>>>>> Enhancements

## [0.8.0]

- Initial release.
