# CLAUDE.MD - D365 F&O Customer Extensions Permanent Memory
**Last Updated**: 2026-02-12
**Project Status**: Active Development
**Current Version**: 1.0.0
**AI Assistant**: Claude (Anthropic)

================================================================================
## PROJECT IDENTITY
================================================================================
**Repository**: https://github.com/Abdojk/AK_F-O_CreateNewFieldinCusttable
**Model Name**: AKCustTableExtensions
**Primary Purpose**: Extend Dynamics 365 F&O Customer master (CustTable) with custom fields
**Development Model**: Extension-only (No overlayering)
**Target D365 Version**: 10.0.x
**Owner**: Abdojk
**Created**: 2026-02-12

================================================================================
## CURRENT STATE SNAPSHOT
================================================================================
### Active Work
- [x] AK_Nasa field implementation (Complete)
- [x] Data entity extension for CustCustomerV3Entity (Complete)
- [ ] Security role updates (Not Started)
- [ ] Deploy to development environment (Not Started)

### Last Deployment
- **Date**: Not yet deployed
- **Environment**: Development
- **Status**: Initial setup - metadata created

### Known Issues
- None currently

### Technical Debt
- None currently

================================================================================
## ARCHITECTURE DECISIONS
================================================================================
### Decision Log
| Date       | Decision | Rationale | Status |
|------------|----------|-----------|--------|
| 2026-02-12 | Use String (60 chars) for AK_Nasa | Free-text field provides maximum flexibility for Nasa data entry | Approved |
| 2026-02-12 | Extend CustCustomerV3Entity | Enable data import/export via Data Management Framework | Approved |
| 2026-02-12 | Place field on General tab | Most visible location, aligns with standard customer data fields | Approved |
| 2026-02-12 | Extension-only approach | Upgrade-safe, no overlayering, Microsoft best practice | Approved |

### Multi-Path Analysis Results
**Requirement**: Add AK_Nasa field to Customer form

| Approach | Pros | Cons | Selected? |
|----------|------|------|-----------|
| Standard Config | N/A - No OOB field exists | Cannot meet requirement | No |
| Power Platform | Could use Dataverse virtual table | Adds complexity, latency | No |
| X++ Extension | Full control, upgrade-safe, performant | Requires dev skills | Yes |

**Final Recommendation**: X++ Table/Form extension (Selected)

================================================================================
## TECHNICAL METADATA
================================================================================
### Custom Objects Created
| Object Type | Name | Purpose | File Path |
|-------------|------|---------|-----------|
| EDT | AKNasa | Extended data type for Nasa field (String 60) | src/CustomCustomerFieldExtension/AKCustTableExtensions/AxEdt/AKNasa.xml |
| Table Ext | CustTable.AKCustTableExtensions | Adds AK_Nasa field to CustTable | src/CustomCustomerFieldExtension/AKCustTableExtensions/AxTable/CustTable.AKCustTableExtensions.xml |
| Form Ext | CustTable.AKCustTableExtensions | Displays AK_Nasa on General tab | src/CustomCustomerFieldExtension/AKCustTableExtensions/AxForm/CustTable.AKCustTableExtensions.xml |
| Entity Ext | CustCustomerV3Entity.AKCustTableExtensions | Data import/export support | src/CustomCustomerFieldExtension/AKCustTableExtensions/AxDataEntityView/CustCustomerV3Entity.AKCustTableExtensions.xml |

### Database Impact
- **Tables Modified**: CustTable (1 field added: AK_Nasa)
- **Sync Required**: Yes (after deployment)
- **Data Migration**: Not required (new field, nullable initially)

### Dependencies
- **D365 Modules**: Customer Master (AR), Data Management
- **External Systems**: None
- **ISV Solutions**: None

================================================================================
## DEVELOPMENT CONTEXT
================================================================================
### Naming Conventions
- **Prefix**: AK (for all custom objects)
- **Extension Suffix**: .AKCustTableExtensions
- **Label Convention**: @AKCustTableExtensions:Label_ID

### Field Specifications
#### AK_Nasa
- **Type**: String (60 characters)
- **EDT**: AKNasa
- **Label**: "Nasa"
- **Help Text**: "Nasa field for customer record"
- **Mandatory**: No
- **Default**: (empty)
- **Form Location**: CustTable > General tab > AKCustomFields group
- **Editable**: Yes
- **Visible**: Yes
- **Data Entity Mapped**: Yes (CustCustomerV3Entity)

### UI Navigation Paths
- **Customer Form**: Accounts receivable > Customers > All customers > Select customer > General tab > AKCustomFields group
- **Data Management**: System administration > Data management > Data entities > Search "CustCustomerV3Entity"

================================================================================
## LESSONS LEARNED & GOTCHAS
================================================================================
### What Worked Well
- [To be filled after implementation]

### Challenges Encountered
- [To be filled during development]

### Code Review Feedback
- [To be filled during PR process]

### Performance Considerations
- String-based field: Minimal performance impact
- No calculated fields: Direct table access, no overhead
- Indexed: Consider adding index if used in frequent queries (monitor post-deployment)

================================================================================
## TESTING STRATEGY
================================================================================
### Unit Tests
- [ ] Field saves correctly to CustTable
- [ ] Values display correctly on form
- [ ] Default value applies on new customer creation
- [ ] Field accepts up to 60 characters

### Integration Tests
- [ ] Data entity import/export includes new field
- [ ] Field visible in all legal entities
- [ ] No conflicts with existing customisations

### User Acceptance Tests
- [ ] Business users can edit field on customer form
- [ ] Field appears in expected location (General tab)
- [ ] Help text displays on hover
- [ ] Security roles grant appropriate access

### Regression Tests
- [ ] Existing customer data unaffected
- [ ] Standard customer creation workflow intact
- [ ] No impact on customer search/filtering

================================================================================
## DEPLOYMENT CHECKLIST
================================================================================
### Pre-Deployment
- [ ] Code review completed
- [ ] All tests passed
- [ ] Documentation updated
- [ ] CLAUDE.MD updated
- [ ] Model exported (.axmodel file ready)

### Deployment Steps
1. [ ] Stop AOS service (if required)
2. [ ] Import model to target environment
3. [ ] Build solution in Visual Studio
4. [ ] Synchronise database
5. [ ] Restart AOS service
6. [ ] Smoke test in target environment

### Post-Deployment
- [ ] Verify field visible on customer form
- [ ] Test data import/export
- [ ] Update CHANGELOG.md
- [ ] Tag release in GitHub
- [ ] Notify stakeholders

### Rollback Plan
- Restore previous model version
- Re-sync database
- Test standard functionality

================================================================================
## AI ASSISTANT INSTRUCTIONS (FOR CLAUDE)
================================================================================
### When You Return to This Project
1. **ALWAYS read this CLAUDE.MD file first** before responding to any queries
2. **Check "Current State Snapshot"** to understand active work
3. **Review "Technical Metadata"** for object names and locations
4. **Consult "Lessons Learned"** to avoid repeating mistakes
5. **Update this file** after completing significant tasks

### How to Update This File
Run: `.\scripts\Generate-ClaudeMemory.ps1 -ProjectPath "." -ModelName "AKCustTableExtensions"`

### What to Never Forget
- **Zero Hallucination Rule**: Never invent menu paths, table names, or field names
- **Extension-Only**: This project uses NO overlayering
- **Naming Convention**: All custom objects start with AK
- **British English**: All documentation uses British spelling
- **Evidence-Based**: All recommendations must cite sources or logic

### Multi-Path Analysis Protocol
When new requirements arise:
1. Evaluate: Standard Config > Power Platform > X++ Custom
2. Document decision in "Architecture Decisions" table
3. Explain trade-offs explicitly (upgradeability, cost, performance)

================================================================================
## QUICK REFERENCE
================================================================================
### Common Commands
```bash
# Clone repo
git clone https://github.com/Abdojk/AK_F-O_CreateNewFieldinCusttable

# Regenerate this memory file
.\scripts\Generate-ClaudeMemory.ps1 -ProjectPath "." -ModelName "AKCustTableExtensions"

# Validate memory file
.\scripts\Validate-ClaudeMemory.ps1 -ProjectPath "."

# Build in VS (after making changes)
# Tools > Dynamics 365 > Build Models

# Sync database
# Dynamics 365 > Synchronise database
```

### Key File Locations
- **Table Extensions**: src/CustomCustomerFieldExtension/AKCustTableExtensions/AxTable/
- **Form Extensions**: src/CustomCustomerFieldExtension/AKCustTableExtensions/AxForm/
- **EDTs**: src/CustomCustomerFieldExtension/AKCustTableExtensions/AxEdt/
- **Enums**: src/CustomCustomerFieldExtension/AKCustTableExtensions/AxEnum/
- **Entities**: src/CustomCustomerFieldExtension/AKCustTableExtensions/AxDataEntityView/

### Support Contacts
- **D365 Architect**: [Name/Email]
- **Lead Developer**: [Name/Email]
- **Business Owner**: [Name/Email]

================================================================================
## VERSION HISTORY OF THIS MEMORY FILE
================================================================================
| Version | Date       | Changes | Author |
|---------|------------|---------|--------|
| 1.0.0   | 2026-02-12 | Initial creation with AK_Nasa field specification | Claude Code + Abdojk |

================================================================================
END OF CLAUDE.MD
Next Update Due: After first deployment to development environment
================================================================================
