<#
.SYNOPSIS
    Synchronises the D365 F&O database after model changes.

.DESCRIPTION
    This script triggers a database synchronisation for the AKCustTableExtensions model.
    It uses the D365 F&O SyncEngine to apply metadata changes to the database schema.

.PARAMETER ServerName
    The SQL Server instance name. Defaults to localhost.

.PARAMETER DatabaseName
    The D365 F&O database name. Defaults to AxDB.

.EXAMPLE
    .\sync-database.ps1
    .\sync-database.ps1 -ServerName "SQLDEV01" -DatabaseName "AxDB"

.NOTES
    Must be run on a D365 F&O development VM with administrator privileges.
    Author: Claude Code + Abdojk
    Date: 2026-02-12
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ServerName = "localhost",

    [Parameter(Mandatory = $false)]
    [string]$DatabaseName = "AxDB"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " D365 F&O Database Synchronisation" -ForegroundColor Cyan
Write-Host " Model: AKCustTableExtensions" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify we're running on a D365 development VM
$syncEnginePath = "K:\AosService\PackagesLocalDirectory\bin\SyncEngine.exe"
if (-not (Test-Path $syncEnginePath)) {
    # Try alternative path
    $syncEnginePath = "C:\AosService\PackagesLocalDirectory\bin\SyncEngine.exe"
}

if (-not (Test-Path $syncEnginePath)) {
    Write-Host "ERROR: SyncEngine.exe not found. This script must be run on a D365 F&O development VM." -ForegroundColor Red
    Write-Host "Expected paths:" -ForegroundColor Yellow
    Write-Host "  K:\AosService\PackagesLocalDirectory\bin\SyncEngine.exe" -ForegroundColor Yellow
    Write-Host "  C:\AosService\PackagesLocalDirectory\bin\SyncEngine.exe" -ForegroundColor Yellow
    exit 1
}

Write-Host "SyncEngine found at: $syncEnginePath" -ForegroundColor Green
Write-Host "Server: $ServerName" -ForegroundColor White
Write-Host "Database: $DatabaseName" -ForegroundColor White
Write-Host ""

# Build sync arguments
$syncArgs = @(
    "-syncmode", "fullall",
    "-metadatabinaries", (Split-Path $syncEnginePath -Parent),
    "-connect", "Data Source=$ServerName;Initial Catalog=$DatabaseName;Integrated Security=True",
    "-verbosity", "Diagnostic"
)

Write-Host "Starting database synchronisation..." -ForegroundColor Yellow
Write-Host ""

try {
    $process = Start-Process -FilePath $syncEnginePath -ArgumentList $syncArgs -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "Database synchronisation completed successfully." -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host "Database synchronisation failed with exit code: $($process.ExitCode)" -ForegroundColor Red
        exit $process.ExitCode
    }
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Synchronisation Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
