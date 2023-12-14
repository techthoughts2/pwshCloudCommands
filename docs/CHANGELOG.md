# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

- Module Changes
    - Updated module requirement for `Convert` from `0.6.0` to `1.5.0`
    - Minor updates to `Invoke-XMLDataCheck` for code readability
    - `Confirm-XMLDataSet` now evaluates `LastWriteTime` instead of `CreationTime` to determine cache freshness requirements
    - `Find-CloudCommand` - updated help
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

## [0.8.0]

- Initial release.
