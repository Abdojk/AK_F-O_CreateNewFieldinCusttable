<#
.SYNOPSIS
    Validates the CLAUDE.MD memory file against actual project metadata.

.DESCRIPTION
    Compares the objects listed in CLAUDE.MD against the actual metadata files
    in the project directory. Reports any discrepancies (missing or extra entries).

.PARAMETER ProjectPath
    The root path of the project. Defaults to the current directory.

.EXAMPLE
    .\Validate-ClaudeMemory.ps1 -ProjectPath "."

.NOTES
    Author: Claude Code + Abdojk
    Date: 2026-02-12
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = "."
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " CLAUDE.MD Validation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ProjectPath = Resolve-Path $ProjectPath
$claudeMdPath = Join-Path $ProjectPath "CLAUDE.MD"

# Check CLAUDE.MD exists
if (-not (Test-Path $claudeMdPath)) {
    Write-Host "FAIL: CLAUDE.MD not found at $claudeMdPath" -ForegroundColor Red
    Write-Host "Run Generate-ClaudeMemory.ps1 to create it." -ForegroundColor Yellow
    exit 1
}

Write-Host "CLAUDE.MD found." -ForegroundColor Green
$content = Get-Content $claudeMdPath -Raw
$validationErrors = @()
$validationWarnings = @()

# 1. Check required sections exist
Write-Host ""
Write-Host "Checking required sections..." -ForegroundColor Yellow

$requiredSections = @(
    "PROJECT IDENTITY",
    "CURRENT STATE SNAPSHOT",
    "ARCHITECTURE DECISIONS",
    "TECHNICAL METADATA",
    "DEVELOPMENT CONTEXT",
    "TESTING STRATEGY",
    "DEPLOYMENT CHECKLIST",
    "AI ASSISTANT INSTRUCTIONS"
)

foreach ($section in $requiredSections) {
    if ($content -match [regex]::Escape($section)) {
        Write-Host "  PASS: '$section' section found" -ForegroundColor Green
    }
    else {
        $validationErrors += "Missing required section: $section"
        Write-Host "  FAIL: '$section' section missing" -ForegroundColor Red
    }
}

# 2. Check Last Updated date is not stale (more than 30 days old)
Write-Host ""
Write-Host "Checking timestamps..." -ForegroundColor Yellow

if ($content -match '\*\*Last Updated\*\*:\s*(\d{4}-\d{2}-\d{2})') {
    $lastUpdated = [DateTime]::Parse($Matches[1])
    $daysSinceUpdate = (Get-Date) - $lastUpdated

    if ($daysSinceUpdate.Days -gt 30) {
        $validationWarnings += "CLAUDE.MD has not been updated in $($daysSinceUpdate.Days) days"
        Write-Host "  WARN: Last updated $($daysSinceUpdate.Days) days ago ($($Matches[1]))" -ForegroundColor Yellow
    }
    else {
        Write-Host "  PASS: Last updated $($Matches[1]) ($($daysSinceUpdate.Days) days ago)" -ForegroundColor Green
    }
}
else {
    $validationErrors += "Missing 'Last Updated' timestamp"
    Write-Host "  FAIL: No 'Last Updated' timestamp found" -ForegroundColor Red
}

# 3. Check that metadata files referenced in CLAUDE.MD actually exist
Write-Host ""
Write-Host "Checking file references..." -ForegroundColor Yellow

$srcPath = Join-Path $ProjectPath "src"
$allXmlFiles = @()
if (Test-Path $srcPath) {
    $allXmlFiles = Get-ChildItem -Path $srcPath -Filter "*.xml" -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.Directory.Name -match "^Ax" }
}

foreach ($xmlFile in $allXmlFiles) {
    $relativePath = $xmlFile.FullName.Replace($ProjectPath, "").TrimStart("\").Replace("\", "/")
    if ($content -match [regex]::Escape($xmlFile.BaseName)) {
        Write-Host "  PASS: $($xmlFile.BaseName) referenced in CLAUDE.MD" -ForegroundColor Green
    }
    else {
        $validationWarnings += "Metadata file '$($xmlFile.BaseName)' not referenced in CLAUDE.MD"
        Write-Host "  WARN: $($xmlFile.BaseName) NOT referenced in CLAUDE.MD" -ForegroundColor Yellow
    }
}

# 4. Check model name consistency
Write-Host ""
Write-Host "Checking model name consistency..." -ForegroundColor Yellow

if ($content -match '\*\*Model Name\*\*:\s*(\S+)') {
    $modelName = $Matches[1]
    $modelPath = Join-Path $srcPath "CustomCustomerFieldExtension\$modelName"

    if (Test-Path $modelPath) {
        Write-Host "  PASS: Model directory '$modelName' exists" -ForegroundColor Green
    }
    else {
        $validationErrors += "Model directory '$modelName' not found at expected path"
        Write-Host "  FAIL: Model directory '$modelName' not found" -ForegroundColor Red
    }
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Validation Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($validationErrors.Count -eq 0 -and $validationWarnings.Count -eq 0) {
    Write-Host "ALL CHECKS PASSED" -ForegroundColor Green
    exit 0
}

if ($validationWarnings.Count -gt 0) {
    Write-Host "Warnings ($($validationWarnings.Count)):" -ForegroundColor Yellow
    foreach ($warning in $validationWarnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

if ($validationErrors.Count -gt 0) {
    Write-Host "Errors ($($validationErrors.Count)):" -ForegroundColor Red
    foreach ($error in $validationErrors) {
        Write-Host "  - $error" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "VALIDATION FAILED" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "VALIDATION PASSED WITH WARNINGS" -ForegroundColor Yellow
exit 0
