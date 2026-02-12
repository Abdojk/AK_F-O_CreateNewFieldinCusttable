# Deployment Guide: AKCustTableExtensions

## Document Information
| Property | Value |
|----------|-------|
| Author | Claude Code + Abdojk |
| Date | 2026-02-12 |
| Version | 1.0.0 |

## Prerequisites

- D365 F&O Development environment (10.0.x)
- Visual Studio 2019+ with D365 F&O development tools
- Administrator access to the target environment
- PowerShell 5.1 or higher

## Deployment Steps

### 1. Import Source Files

Copy the contents of `src/CustomCustomerFieldExtension/` to the appropriate location in your D365 development environment's metadata folder:

```
K:\AosService\PackagesLocalDirectory\AKCustTableExtensions\
```

### 2. Open in Visual Studio

1. Open Visual Studio as Administrator
2. Open the AKCustTableExtensions project (`.rnrproj` file)
3. Verify all objects are recognised in Solution Explorer

### 3. Build the Solution

1. Navigate to **Build > Build Solution** (or press Ctrl+Shift+B)
2. Verify zero errors in the Output window
3. Address any warnings if present

### 4. Synchronise Database

**Option A: Visual Studio**
1. Navigate to **Dynamics 365 > Synchronize database**
2. Wait for synchronisation to complete
3. Verify success in the Output window

**Option B: PowerShell**
```powershell
.\scripts\sync-database.ps1
```

### 5. Verify Deployment

1. Open a browser and navigate to the D365 F&O environment
2. Navigate to: **Accounts receivable > Customers > All customers**
3. Open any existing customer record
4. Go to the **General** tab
5. Verify the **AKCustomFields** group is visible
6. Verify the **Nasa** field is present and editable

### 6. Test Data Entity

1. Navigate to: **System administration > Data management > Data entities**
2. Search for **CustCustomerV3Entity**
3. Verify AK_Nasa field is available in the entity mapping
4. Test import/export with sample data

## Environment-Specific Notes

### Development Environment
- Direct file deployment via metadata folder
- No model export required
- Database sync via Visual Studio

### UAT/Production Environments
1. Export the model:
   ```powershell
   .\scripts\export-model.ps1
   ```
2. Transfer the `.axmodel` file to the target environment
3. Import using the D365 model management utility:
   ```powershell
   Install-D365Model -ModelFile "AKCustTableExtensions.axmodel"
   ```
4. Perform a full database synchronisation
5. Restart the AOS service

## Rollback Procedure

If issues are encountered after deployment:

1. Stop the AOS service
2. Remove the AKCustTableExtensions model:
   ```powershell
   Uninstall-D365Model -ModelName "AKCustTableExtensions"
   ```
3. Synchronise the database (this will drop the AK_Nasa column)
4. Restart the AOS service
5. Verify standard customer form functionality

**Note**: Rolling back will permanently delete any data stored in the AK_Nasa field.

## Troubleshooting

### Field Not Visible on Form
- Verify the form extension XML is in the correct location
- Ensure the model is built without errors
- Check that the user has appropriate security roles

### Database Sync Fails
- Check for naming conflicts with existing customisations
- Verify the EDT XML is properly formatted
- Review the sync log for specific error details

### Data Entity Not Showing Field
- Rebuild the entity after deploying the extension
- Verify the entity extension XML references the correct data source
- Run an incremental CIL build if necessary
