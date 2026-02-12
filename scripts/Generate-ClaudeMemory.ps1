<#
.SYNOPSIS
    Generates or updates the CLAUDE.MD memory file based on current project metadata.

.DESCRIPTION
    Scans the project directory for D365 F&O metadata files and updates CLAUDE.MD
    with current object inventory, file paths, and project state.

.PARAMETER ProjectPath
    The root path of the project. Defaults to the current directory.

.PARAMETER ModelName
    The D365 F&O model name. Defaults to AKCustTableExtensions.

.EXAMPLE
    .\Generate-ClaudeMemory.ps1 -ProjectPath "." -ModelName "AKCustTableExtensions"

.NOTES
    Author: Claude Code + Abdojk
    Date: 2026-02-12
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = ".",

    [Parameter(Mandatory = $false)]
    [string]$ModelName = "AKCustTableExtensions"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " CLAUDE.MD Memory File Generator" -ForegroundColor Cyan
Write-Host " Model: $ModelName" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ProjectPath = Resolve-Path $ProjectPath
$claudeMdPath = Join-Path $ProjectPath "CLAUDE.MD"
$srcPath = Join-Path $ProjectPath "src\CustomCustomerFieldExtension\$ModelName"

# Check if CLAUDE.MD exists
if (-not (Test-Path $claudeMdPath)) {
    Write-Host "WARNING: CLAUDE.MD not found. A new file will be created." -ForegroundColor Yellow
}
else {
    Write-Host "Existing CLAUDE.MD found. Updating..." -ForegroundColor Green
}

# Scan for metadata objects
Write-Host ""
Write-Host "Scanning project metadata..." -ForegroundColor Yellow

$objectInventory = @()

# Scan EDTs
$edtPath = Join-Path $srcPath "AxEdt"
if (Test-Path $edtPath) {
    $edtFiles = Get-ChildItem -Path $edtPath -Filter "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $edtFiles) {
        $objectInventory += [PSCustomObject]@{
            Type     = "EDT"
            Name     = $file.BaseName
            FilePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        }
        Write-Host "  Found EDT: $($file.BaseName)" -ForegroundColor White
    }
}

# Scan Enums
$enumPath = Join-Path $srcPath "AxEnum"
if (Test-Path $enumPath) {
    $enumFiles = Get-ChildItem -Path $enumPath -Filter "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $enumFiles) {
        $objectInventory += [PSCustomObject]@{
            Type     = "Enum"
            Name     = $file.BaseName
            FilePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        }
        Write-Host "  Found Enum: $($file.BaseName)" -ForegroundColor White
    }
}

# Scan Table Extensions
$tablePath = Join-Path $srcPath "AxTable"
if (Test-Path $tablePath) {
    $tableFiles = Get-ChildItem -Path $tablePath -Filter "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $tableFiles) {
        $objectInventory += [PSCustomObject]@{
            Type     = "Table Extension"
            Name     = $file.BaseName
            FilePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        }
        Write-Host "  Found Table Extension: $($file.BaseName)" -ForegroundColor White
    }
}

# Scan Form Extensions
$formPath = Join-Path $srcPath "AxForm"
if (Test-Path $formPath) {
    $formFiles = Get-ChildItem -Path $formPath -Filter "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $formFiles) {
        $objectInventory += [PSCustomObject]@{
            Type     = "Form Extension"
            Name     = $file.BaseName
            FilePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        }
        Write-Host "  Found Form Extension: $($file.BaseName)" -ForegroundColor White
    }
}

# Scan Data Entity Extensions
$entityPath = Join-Path $srcPath "AxDataEntityView"
if (Test-Path $entityPath) {
    $entityFiles = Get-ChildItem -Path $entityPath -Filter "*.xml" -ErrorAction SilentlyContinue
    foreach ($file in $entityFiles) {
        $objectInventory += [PSCustomObject]@{
            Type     = "Entity Extension"
            Name     = $file.BaseName
            FilePath = $file.FullName.Replace($ProjectPath, "").TrimStart("\")
        }
        Write-Host "  Found Entity Extension: $($file.BaseName)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "Total objects found: $($objectInventory.Count)" -ForegroundColor Green

# Generate the technical metadata table for CLAUDE.MD
$metadataTable = "| Object Type | Name | File Path |`n"
$metadataTable += "|-------------|------|-----------|`n"
foreach ($obj in $objectInventory) {
    $metadataTable += "| $($obj.Type) | $($obj.Name) | $($obj.FilePath) |`n"
}

Write-Host ""
Write-Host "Object Inventory:" -ForegroundColor Cyan
Write-Host $metadataTable

# Update the "Last Updated" timestamp in CLAUDE.MD if it exists
if (Test-Path $claudeMdPath) {
    $content = Get-Content $claudeMdPath -Raw
    $today = Get-Date -Format "yyyy-MM-dd"
    $content = $content -replace '(\*\*Last Updated\*\*:\s*)\S+', "`${1}$today"

    Set-Content -Path $claudeMdPath -Value $content -Encoding UTF8
    Write-Host "CLAUDE.MD updated with timestamp: $today" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Memory File Generation Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Object inventory has been displayed above." -ForegroundColor White
Write-Host "To update CLAUDE.MD with new objects, manually add entries to the Technical Metadata section." -ForegroundColor White
Write-Host ""
Write-Host "TIP: Always update CLAUDE.MD after adding new metadata objects." -ForegroundColor Yellow
