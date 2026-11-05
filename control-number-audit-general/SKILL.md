---
name: control-number-audit-general
description: "Use when proving a change did not corrupt records."
---

# Business Control-Number Audit

Recompute control values for a defined set of records through independent paths. Keep "the arithmetic matches" separate from "the definitions and source data are right".

## Workflow

1. **Set the boundary:** sample or period, records included and excluded, the question to answer. Never expand a sample into a whole-system claim.
2. **Identify sources.** Per control: source field, owner, unit, time basis, stored or derived.
3. **Pick controls by risk** (counts, quantities, amounts, dates, identifiers, status transitions), only those relevant to this scope.
4. **Plan an independent path:** header quantity against the sum of detail rows, a total against transaction entries. Never use one formula as both answer and proof.
5. **Capture a dated, read-only baseline** of inputs and formulas so others can reproduce it.
6. **Recalculate and compare:** expected, observed, difference, unit, source path, verdict. Explain rounding (at the business's precision) and timing differences.
7. **Classify exceptions:** data error, definition question, timing gap, out of scope. Assign follow-up only where an owner or next step is known.
8. **Conclude narrowly:** what passed, what failed, what was not tested. Matching totals do not prove definitions or untested records.

| Control | Source | Independent recalculation | Expected | Observed | Diff | Note |
|---|---|---|---:|---:|---:|---|
| Parent quantity | Header record | Sum of linked detail rows | 24 | 24 | 0 | Pass for this sample |

## Must-check items

Run these before reporting any total. Generic rules; bracketed examples are from one domain only.

- **Duplicates.** Report the total with and without them; never delete or merge without the owner. [trade: the same batch twice, one row differing only by waybill number]
- **Text in numeric cells.** Summing them as zero hides missing data behind a clean total. ["about 20", "20 units", "—", blank]
- **Mixed units or basis.** Unify and state the basis, or mark the total non-comparable. [some amounts in yuan, others in 10k yuan; tax basis stated on two rows only]
- **Ambiguous identifiers and mixed date formats.** They break matching and period cut-offs; normalize and list what changed. [0 vs letter O in one ID position; "2026/3/5" beside "03-05"]

## Pitfalls

- Two paths reading the same source field are not independent.
- Filters, exports, and pagination change the row set. Record filter and row count on both sides; date boundaries and timezones cause false differences.
- A total built on a wrong definition is still wrong. Write the definition beside the number.

## Self-check

- Every control was recomputed by a path independent of the original.
- Every non-zero difference is explained or listed as unresolved.
- Untested rows and unverified definitions are labeled.
