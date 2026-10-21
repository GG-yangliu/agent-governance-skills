---
name: relational-data-governance
description: "Use when a data model repeats facts or hand-counts rows."
---

# Relational Data Governance

Give every fact one authoritative write location; derive everything else through explicit relationships or formulas.

## Workflow

1. **Establish scope.** Name the tables, fields, sample records, intended users, and whether the task is a review, a proposal, or an authorized live change.
2. **Classify every field.** Input fact, derived value, identifier, or display-only. Note its owner and every formula, lookup, view, and automation that depends on it.
3. **Find duplication and fragile logic.** The same fact typed in several places; counts inferred from free text; formula branches that silently return blank; names or units baked into logic.
4. **Design the source of truth.** One write location per fact. Prefer stable record links and reverse relations for child counts. Derive values with formulas or lookups where possible. Keep genuinely different facts apart even when their names look alike.
5. **Capture a baseline.** Schemas, formulas, representative outputs, and control totals, dated. Keep a recoverable snapshot before consequential changes.
6. **Change only what was asked.** Check dependencies before renaming or removing a field. Never invent a business definition. Never convert an unknown value to zero.
7. **Read back and reconcile.** Compare derived results against an independent reference across the affected records. Report mismatches and untested areas explicitly.

## Pitfalls

Platform behavior differs; verify on your platform before repeating any of these.

- **Renaming a field** can silently break formulas, lookups, automations, and saved views that reference it. This is common in no-code table and online-database tools (Airtable, Notion, and similar). Recount control totals after any rename.
- **Bulk writes** may skip formula fields, fire automations per row, or fail part-way. Write a small batch, read it back, then run the rest.
- **Whole-table replacement** destroys concurrent edits by other people. Read the revision and collaboration state first.
- **Reverse-relation counts** are only as good as the relation itself: one missing link makes a wrong number look right.
- **Counting from free text** silently absorbs typos, trailing spaces, and unit variants. Normalize only the variants actually in scope.
- **Empty, zero, not-applicable, and unknown** are four different states. Collapsing them is data loss, not cleanup.

## Acceptance checks

- A fact-ownership map exists: every field classified, one write location per fact.
- Every field being changed has a dependency list.
- Control totals before and after match, or each difference is explained (rounding, timing, or scope).
- Rows outside the sample are labeled untested, not implied to be verified.
- No value was invented to fill a gap; unknown stays unknown.
