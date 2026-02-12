# Architecture Decision Log

## Document Information
| Property | Value |
|----------|-------|
| Project | AKCustTableExtensions |
| Author | Claude Code + Abdojk |
| Date | 2026-02-12 |

## Decision Records

### ADR-001: Development Approach

**Date**: 2026-02-12
**Status**: Approved

**Context**: A new field (AK_Nasa) needs to be added to the Customer form in D365 F&O.

**Options Considered**:

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| Standard Configuration | Use existing OOB configurable fields | No code required | No suitable OOB field exists |
| Power Platform | Virtual table + Dataverse field | Low-code approach | Adds latency, complexity, Dataverse dependency |
| X++ Extension | Table/Form extension with custom EDT | Full control, upgrade-safe, performant | Requires X++ development skills |

**Decision**: X++ Extension approach selected.

**Rationale**: The extension model is Microsoft's recommended approach for customisations. It provides full control over the field definition, is upgrade-safe (no overlayering), and has no external dependencies.

---

### ADR-002: Data Type Selection

**Date**: 2026-02-12
**Status**: Approved

**Context**: The AK_Nasa field requires a data type definition.

**Options Considered**:

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| Base Enum | Predefined list of values | Consistent data, easy filtering | Limited flexibility |
| String (60) | Free-text entry up to 60 chars | Maximum flexibility | Requires validation for consistency |
| Integer | Numeric value | Efficient storage | Not suitable for text data |

**Decision**: String (60 characters) selected.

**Rationale**: A string field provides maximum flexibility for data entry. The 60-character limit balances usability with database efficiency.

---

### ADR-003: Form Placement

**Date**: 2026-02-12
**Status**: Approved

**Context**: The new field needs to be placed on the Customer form.

**Options Considered**:

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| General tab | Main tab, highest visibility | Easy to find, most-used tab | Tab may be crowded |
| Credit and collections | Financial classification tab | Logical for financial data | Less visible |
| New custom tab | Dedicated tab for custom fields | Clean separation | Extra navigation step |

**Decision**: General tab selected, within a new AKCustomFields group.

**Rationale**: The General tab provides the highest visibility. Creating a dedicated field group (AKCustomFields) keeps the custom field organised without cluttering existing groups.

---

### ADR-004: Data Entity Extension

**Date**: 2026-02-12
**Status**: Approved

**Context**: The AK_Nasa field should be available for data import/export.

**Decision**: Extend CustCustomerV3Entity to include the AK_Nasa field.

**Rationale**: CustCustomerV3Entity is the standard data entity for customer master data management. Extending it ensures the field is available through the Data Management Framework for bulk operations.

---

### ADR-005: Naming Convention

**Date**: 2026-02-12
**Status**: Approved

**Context**: Custom objects need a consistent naming convention to avoid conflicts.

**Decision**: Use "AK" prefix for all custom objects.

**Rationale**: The AK prefix:
- Clearly identifies custom objects
- Prevents naming collisions with Microsoft standard objects
- Prevents collisions with other ISV solutions
- Is short enough to not impact readability
