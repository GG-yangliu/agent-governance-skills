---
name: window-table-governance-general
description: "Use when write entry and reporting views get confused."
---

# Write-Surface and Verification-View Governance

Clarify where each business action is recorded and where its completion can be verified, especially when detail tables, summaries, and role-specific views expose overlapping information.

## Workflow

1. **List the actions.** Translate the process into observable actions: submitting a request, recording a result, approving a change, handing off a case.
2. **Trace each action to its write surface.** Name the exact form, table, page, or endpoint that stores the action, plus the field or event that proves it happened. A summary counts as a write surface only if it actually accepts and persists the action.
3. **Map the reporting surfaces.** Record which summaries, dashboards, and views display the result, how fresh they are, and what they omit.
4. **Map roles and access separately.** For each role, verify it can open and use the relevant surface. A preparer's access does not prove that another role has access.
5. **Publish a compact action map.** For each action: who performs it, where it is entered, what evidence is written, where others verify it, and what to do when evidence is missing or inconsistent.
6. **Validate with one real or safe sample.** Follow one representative action through entry and readback. Confirm the summaries point at the same underlying record, and do not claim completion from a stale or partial view.

## Pitfalls

- A summary that looks read-only may in fact be hand-edited. That makes it a second write surface, and the two will drift.
- Dashboard or rollup refresh can lag from minutes to hours. A blank cell may mean "not refreshed yet", not "not done".
- View permission and table permission are separate grants. Seeing a view does not imply being able to write the table behind it.
- Role names lie. Check the actual permission grant for the intended user, not the role label.
- Chat approval is not a record. If nothing persists the handoff, report the evidence gap and propose a recording point instead of treating chat history as a register.

## Acceptance checks

- Every action has all four pieces: write surface, evidence field or event, verification view, and access status per role.
- At least one sample action was followed end to end, with readback evidence quoted.
- Each summary's refresh behavior is documented, or explicitly marked unknown.
- Anything not verified is marked unknown, never filled in by assumption.
