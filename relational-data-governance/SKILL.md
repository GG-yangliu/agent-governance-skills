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

Generic rules; the bracketed example is one domain.

- **Duplicated facts.** One fact hand-typed in several places drifts the moment one copy is edited. [orders: the customer phone stored on every order row]
- **Derived values typed by hand.** If the inputs exist, the value must be computed. [an amount column filled manually beside unit price and quantity]
- **One entity, several spellings.** Count variants before counting rows. ["Acme Ltd" / "Acme" / "ACME"]
- **Status wording not unified, or status contradicting its evidence.** [marked complete while the reference field is blank]

## Pitfalls

- **Renaming a field** can silently break formulas, lookups, automations, and saved views. Recount control totals afterwards.
- **Bulk writes** may skip formula fields, fire automations per row, or fail part-way. Write a small batch, read it back, then continue.
- **Reverse-relation counts** are only as good as the links: one missing link makes a wrong number look right.
- **Empty, zero, not-applicable, and unknown** are four states. Collapsing them is data loss. Unknown stays unknown.

## Self-check

- Each fact has exactly one write location.
- Control totals match before and after, or every difference is explained.
- Rows outside the sample are marked untested; unknown stays unknown.
