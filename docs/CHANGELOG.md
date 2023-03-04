# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [0.8.0]

- Initial release.
