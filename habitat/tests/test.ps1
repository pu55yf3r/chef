param (
    [Parameter()]
    [string]$PackageIdentifier = $(throw "Usage: test.ps1 [test_pkg_ident] e.g. test.ps1 ci/user-windows/1.0.0/20190812103929")
)

Write-Host "--- :alembic: Functional Tests"
powershell -File "./habitat/tests/spec.ps1" -PackageIdentifier $PackageIdentifier
if (-not $?) { throw "functional spec suite failed" }
