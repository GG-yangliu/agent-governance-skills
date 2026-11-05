---
name: db-quality-baseline
description: "Use when measuring how good a database actually is, before fixing anything."
---

# Database Quality Baseline

Measure a data store's quality with reproducible, read-only checks, and produce a baseline that later changes can be compared against. The output is a scorecard plus a defect list with record identifiers — never a cleanup.

## Workflow

1. **Declare scope.** Which store, which tables, the record count of each, who owns it, and that the run is read-only. Nothing is written, cleaned or merged in this pass.
2. **List the core facts and their one authoritative field.** For each fact, state where it is typed by hand, where it is derived, and which field is authoritative. More than one hand-typed location is a finding, not a detail.
3. **Define the control numbers before counting.** For each: source A, source B, tolerance, and what a non-zero difference would mean. A control number with only one named source is not a control number — it proves nothing.
4. **Check structure, not just values.** Field types of numeric fields; values that could be computed but are typed by hand; uniqueness of business keys; required fields actually filled; links pointing at deleted or non-existent records.
5. **Scan for the dirt that structure checks cannot catch.** Duplicates; text inside numeric cells; mixed units, scale or basis; identifiers where characters collide; mixed date formats; one status or one entity written several ways.
6. **Record the baseline, do not judge it.** Report measured counts per check. Set thresholds only after a first baseline exists, and set them per check rather than copying someone else's numbers.
7. **Report into two columns.** What could be computed, with its source; and what could not, with the reason and who must confirm. Anything not examined is listed as not examined.
8. **Re-run after any structural change** (field type, formula, link, permission) and compare against the baseline. A check that got worse blocks the change.

## Must-check items

Rules are generic; the examples below illustrate them and do not bound them.

- **Zero means measured zero.** Every "0" states whether the check ran and found nothing, or did not run at all. These are different results and must not share a number.
- **A zero denominator is "not applicable".** Never report a percentage over an empty set, and never report 100% for it.
- **Read-only means read-only.** Report defects with row identifiers; do not merge, delete, coerce or backfill during measurement. Cleaning destroys the evidence you are measuring.
- **Both sides of a control number must be independent.** If source A and source B derive from the same typed value, agreement proves nothing — say so in the report.
- **Agreement is not correctness.** A control number proves two sources match; it cannot prove either is right, because a shared error matches itself.
- **Every check maps to a table and a field.** A check that cannot be mapped is marked "not applicable" with the reason, not silently dropped.
- **Thresholds come from a baseline, not from convention.** First run records; later runs compare.

## Examples

Illustrations only — replace them with your own domain's cases. They show the shape of the output, not the rule again.

- A scorecard line reading "duplicates: 0 (412 rows scanned)", not "duplicates: 0" — the second cannot be told apart from "not checked".
- A completeness row reading "not applicable (field empty in every row)", never "100%".
- A defect entry shaped "table.field | record id | finding", for example "batch table.quantity | row 18 | duplicate of row 17, identical except the secondary reference".
- The baseline pass changes nothing; a re-run reproduces the same numbers — that is what makes it a baseline.

## Pitfalls

- **Reporting a rate without its denominator.** "12% dirty" is meaningless without rows scanned; give counts first.
- **Treating "no record" as "no problem".** Missing evidence is a finding about coverage, not a clean bill of health.
- **Fixing while measuring.** A run that edits records cannot be re-run and compared, and its numbers can no longer be reproduced.
- **Inventing a threshold.** A pass line copied from another domain hides the checks that matter here.
- **Silently dropping a check** that the current schema cannot support — say "not applicable" and say why.

## Self-check

- Every reported number carries a row identifier or a count of rows scanned.
- Every zero states measured or not applicable; no percentage stands without its denominator.
- Nothing was written: re-running the same pass reproduces the same numbers.
