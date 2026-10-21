---
name: control-number-audit-general
description: "Use when proving a change did not corrupt records."
---

# Business Control-Number Audit

Check whether a defined set of records reconciles by recomputing control values through independent paths. Separating arithmetic agreement from correctness of definitions and source data is the whole point.

## Workflow

1. **Set the audit boundary.** Sample or period, records included, exclusions, and the question the audit must answer. Never silently expand a sample into a whole-system claim.
2. **Identify authoritative sources.** For each control: source field or record, owner, unit, time basis, and whether it is a stored fact or a derived value.
3. **Choose controls by risk.** Counts, quantities, amounts, dates, identifiers, status transitions, traceability. Include only controls meaningful to this scope.
4. **Plan an independent path.** Recalculate each control from a different route or source subset: header quantity against the sum of detail rows, a total against transaction-level entries. Never use the same formula as both the answer and the proof.
5. **Capture a read-only baseline.** Preserve the inputs and formulas, dated, with the method recorded so the result can be reproduced.
6. **Recalculate and compare.** Show expected value, observed value, difference, unit, source path, and result. Explain rounding and timing differences instead of hiding them.
7. **Classify exceptions.** Separate confirmed data errors, definition questions, timing gaps, and items outside the boundary. Assign follow-up only where an owner or next step is known.
8. **State the conclusion narrowly.** Say which sample and which controls passed, which failed, and what was not tested. Matching totals do not prove the model, the policy, or all records are correct.

## Control matrix

| Control | Authoritative source | Independent recalculation | Expected | Observed | Difference | Result / note |
|---|---|---|---:|---:|---:|---|
| Parent quantity | Header record | Sum of linked detail rows | 24 units | 24 units | 0 | Pass for this sample |

Use neutral synthetic examples in public documentation. Never include confidential records, customer identifiers, private links, or credentials.

## Pitfalls

- Two paths that share the same source field are not independent. Same formula, same answer, zero proof.
- Filters, exports, and pagination silently change the row set. Record the filter and the row count on both sides.
- Date-boundary and timezone choices produce classic false differences on period totals.
- Money rounding: compare at the precision the business actually uses, and state that precision.
- Blank versus zero: a total that sums blanks as zero can hide missing data behind a clean number.
- A green control total built on a wrong definition is still wrong. Write the definition down next to the number.

## Acceptance checks

- The boundary, the sample, and the excluded rows are written down.
- Every control row has: source, independent path, expected, observed, difference, verdict.
- Every non-zero difference has an explanation, or is listed as unresolved.
- Untested rows and unverified definitions are labeled as such, never implied.
