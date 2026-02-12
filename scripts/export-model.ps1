<#
.SYNOPSIS
    Exports the AKCustTableExtensions model as an .axmodel file.

.DESCRIPTION
    This script exports the D365 F&O model for deployment to other environments.
    The exported .axmodel file can be imported into UAT/Production environments.

.PARAMETER OutputPath
    The directory where the .axmodel file will be saved. Defaults to the current directory.

.PARAMETER ModelName
    The model name to export. Defaults to AKCustTableExtensions.

.EXAMPLE
    .\export-model.ps1
    .\export-model.ps1 -OutputPath "C:\Models" -ModelName "AKCustTableExtensions"

.NOTES
    Must be run on a D365 F&O development VM with administrator privileges.
    Author: Claude Code + Abdojk
    Date: 2026-02-12
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [string]$ModelName = "AKCustTableExtensions"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " D365 F&O Model Export" -ForegroundColor Cyan
Write-Host " Model: $ModelName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify output path exists
if (-not (Test-Path $OutputPath)) {
    Write-Host "Creating output directory: $OutputPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# Locate ModelUtil.exe
$modelUtilPath = "K:\AosService\PackagesLocalDirectory\bin\ModelUtil.exe"
if (-not (Test-Path $modelUtilPath)) {
    $modelUtilPath = "C:\AosService\PackagesLocalDirectory\bin\ModelUtil.exe"
}

if (-not (Test-Path $modelUtilPath)) {
    Write-Host "ERROR: ModelUtil.exe not found. This script must be run on a D365 F&O development VM." -ForegroundColor Red
    exit 1
}

# Determine packages path
$packagesPath = Split-Path $modelUtilPath -Parent | Split-Path -Parent

# Build output file name with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = Join-Path $OutputPath "${ModelName}_${timestamp}.axmodel"

Write-Host "ModelUtil found at: $modelUtilPath" -ForegroundColor Green
Write-Host "Packages path: $packagesPath" -ForegroundColor White
Write-Host "Output file: $outputFile" -ForegroundColor White
Write-Host ""

# Export the model
$exportArgs = @(
    "-export",
    "-metadatastorepath=$packagesPath",
    "-modelname=$ModelName",
    "-outputpath=$outputFile"
)

Write-Host "Exporting model..." -ForegroundColor Yellow
Write-Host ""

try {
    $process = Start-Process -FilePath $modelUtilPath -ArgumentList $exportArgs -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "Model exported successfully." -ForegroundColor Green
        Write-Host "Output: $outputFile" -ForegroundColor Green

        $fileInfo = Get-Item $outputFile
        Write-Host "Size: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor White
    }
    else {
        Write-Host ""
        Write-Host "Model export failed with exit code: $($process.ExitCode)" -ForegroundColor Red
        exit $process.ExitCode
    }
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Export Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
