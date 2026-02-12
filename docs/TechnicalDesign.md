# Technical Design: AK_Nasa Customer Field Extension

## Document Information
| Property | Value |
|----------|-------|
| Author | Claude Code + Abdojk |
| Date | 2026-02-12 |
| Version | 1.0.0 |
| Status | Approved |

## 1. Overview

This document describes the technical design for adding the **AK_Nasa** custom field to the Customer master table (CustTable) in Dynamics 365 Finance & Operations using the extension-based development model.

## 2. Field Specification

| Property | Value |
|----------|-------|
| Field Name | AK_Nasa |
| EDT | AKNasa |
| Data Type | String |
| Length | 60 characters |
| Label | Nasa |
| Help Text | Nasa field for customer record |
| Mandatory | No |
| Default Value | (empty) |
| Searchable | No (initially) |
| Indexed | No (initially; add if needed after performance monitoring) |

## 3. Model Configuration

| Property | Value |
|----------|-------|
| Model Name | AKCustTableExtensions |
| Publisher | Abdojk |
| Layer | ISV |
| Referenced Models | ApplicationPlatform, ApplicationFoundation, ApplicationSuite |
| Version | 1.0.0.0 |

## 4. Objects Created

### 4.1 Extended Data Type (EDT)
- **Name**: AKNasa
- **Base Type**: String
- **String Size**: 60
- **Label**: Nasa
- **Help Text**: Nasa field for customer record

### 4.2 Table Extension
- **Name**: CustTable.AKCustTableExtensions
- **Base Table**: CustTable
- **Fields Added**:
  - AK_Nasa (type: AKNasa EDT)
- **Field Groups Modified**:
  - New group: AKCustomFields (contains AK_Nasa)

### 4.3 Form Extension
- **Name**: CustTable.AKCustTableExtensions
- **Base Form**: CustTable
- **Modifications**:
  - General tab: Added AKCustomFields group
  - AKCustomFields group contains AK_Nasa field control
  - Field bound to CustTable.AK_Nasa data source field

### 4.4 Data Entity Extension
- **Name**: CustCustomerV3Entity.AKCustTableExtensions
- **Base Entity**: CustCustomerV3Entity
- **Fields Added**:
  - AK_Nasa (mapped from CustTable.AK_Nasa)

## 5. Database Impact

| Aspect | Detail |
|--------|--------|
| Table | CustTable |
| Column Added | AK_NASA (nvarchar(60), NULL) |
| Index Changes | None |
| Data Migration | Not required |
| Sync Required | Yes |

## 6. Security

The field inherits the existing CustTable security permissions. No additional security privileges are required. Users with access to the Customer form will automatically have access to this field based on their existing role assignments.

## 7. Performance Considerations

- Nullable string field: No impact on existing queries
- No computed columns or calculated fields
- No additional indexes initially
- Monitor query performance post-deployment; add index if AK_Nasa is used in frequent filtering

## 8. Upgrade Considerations

- Extension-only approach: No overlayering, fully upgrade-safe
- Field uses custom EDT: No conflict with standard D365 updates
- Prefix (AK) prevents naming collisions with Microsoft updates
