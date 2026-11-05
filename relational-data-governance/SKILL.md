---
name: relational-data-governance
description: "Use when a data model repeats facts or hand-counts rows."
---

# Relational Data Governance

Give every fact one authoritative write location; derive everything else through relationships or formulas.

## Workflow

1. **Scope:** tables, fields, sample records, users, and whether this is a review, proposal, or authorized live change.
2. **Classify every field** (input fact, derived, identifier, display-only), its owner, and every formula, lookup, view, and automation that depends on it.
3. **Find duplication and fragile logic:** one fact typed in several places, counts inferred from free text, formulas that silently return blank, names or units baked into logic.
4. **Design the source of truth.** One write location per fact. Count child rows through record links and reverse relations; derive the rest. Keep different facts apart even when names look alike.
5. **Capture a dated baseline** (schemas, formulas, sample outputs, control totals) and a recoverable snapshot before consequential changes.
6. **Change only what was asked.** Check dependencies before renaming or removing a field. Never invent a business definition.
7. **Read back and reconcile** affected records through an independent path. Report differences and untested areas.

## Must-check items

Rules for any relational model. Examples illustrate; they do not bound the check.

- **A fact with more than one write location.** Name which location is authoritative, mark the others for cleanup, and do not delete without the owner.
- **A value that could be computed but is typed by hand.** Show the hand-typed value beside the recomputed one and state the difference.
- **One entity in several spellings.** List the variants with row counts, then count entities once.
- **Fields that contradict each other.** When two fields claim the same state, show both and label it a conflict instead of picking the friendlier one.

## Examples

Illustrations only — replace them with your own domain's cases.

- A customer phone stored on every order row.
- An amount column filled manually while unit price and quantity both exist.
- "Acme Ltd" / "Acme" / "ACME" across three rows.
- A row marked complete while its reference field is blank.

## Pitfalls

- **Renaming a field** can silently break formulas, lookups, automations, and saved views. Recount control totals afterwards.
- **Bulk writes** may skip formula fields, fire automations per row, or fail part-way. Write a small batch, read it back, then continue.
- **Reverse-relation counts** are only as good as the links: one missing link makes a wrong number look right.
- **Empty, zero, not-applicable, and unknown** are four states. Collapsing them is data loss. Unknown stays unknown.

## Self-check

- Each fact has exactly one write location.
- Control totals match before and after, or every difference is explained.
- Rows outside the sample are marked untested; unknown stays unknown.
