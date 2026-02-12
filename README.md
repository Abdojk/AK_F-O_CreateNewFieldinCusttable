# D365 F&O Customer Field Extensions

## Overview
Custom field extensions for the Customer master (CustTable) in Dynamics 365 Finance & Operations.

This project adds the **AK_Nasa** field to the CustTable using the extension-based development model (no overlayering).

## AI Memory System
This project uses **CLAUDE.MD** as a permanent memory file for AI-assisted development.
- **For AI assistants**: Read CLAUDE.MD first for full project context
- **For humans**: CLAUDE.MD contains comprehensive technical metadata and decisions

## Fields Added
- **AK_Nasa**: String (60 chars) field on the General tab of the Customer form

## Prerequisites
- D365 F&O Development Environment (10.0.x)
- Visual Studio with D365 F&O Tools
- Access to target model: AKCustTableExtensions
- PowerShell 5.1 or higher

## Quick Start
```bash
# Clone repository
git clone https://github.com/Abdojk/AK_F-O_CreateNewFieldinCusttable
cd AK_F-O_CreateNewFieldinCusttable

# Read project memory
cat CLAUDE.MD

# Generate/update memory file
.\scripts\Generate-ClaudeMemory.ps1 -ProjectPath "." -ModelName "AKCustTableExtensions"

# Validate memory file
.\scripts\Validate-ClaudeMemory.ps1 -ProjectPath "."
```

## Project Structure
```
├── CLAUDE.MD              # Permanent AI memory and project metadata
├── README.md              # This file
├── CHANGELOG.md           # Version history
├── docs/                  # Technical documentation
│   ├── TechnicalDesign.md
│   ├── DeploymentGuide.md
│   └── DecisionLog.md
├── src/                   # D365 F&O metadata (XML files)
│   └── CustomCustomerFieldExtension/
│       ├── Descriptor/
│       │   └── AKCustTableExtensionsDescriptor.xml
│       ├── AKCustTableExtensions/
│       │   ├── AxDataEntityView/
│       │   ├── AxEdt/
│       │   ├── AxEnum/
│       │   ├── AxForm/
│       │   ├── AxTable/
│       │   └── AxTableExtension/
│       └── AKCustTableExtensions.rnrproj
├── scripts/               # PowerShell automation scripts
└── .github/workflows/     # CI/CD pipelines
```

## Deployment
See [docs/DeploymentGuide.md](docs/DeploymentGuide.md) for full deployment instructions.

### Quick Deployment Steps
1. Import model to target environment
2. Build solution in Visual Studio
3. Synchronise database
4. Verify field on Customer form (General tab)

## Technical Design
See [docs/TechnicalDesign.md](docs/TechnicalDesign.md) for full specifications.

## Contributing
1. Create a feature branch from `main`
2. Make changes following the AK prefix naming convention
3. Update CLAUDE.MD with any new metadata
4. Submit a pull request

## Licence
Proprietary - Internal use only.
