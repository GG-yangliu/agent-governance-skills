---
name: window-table-governance-general
description: "Use when write entry and reporting views get confused."
---

# Write-Surface and Verification-View Governance

Clarify where each business action is recorded and where its completion is verified, especially when detail tables, summaries, and role views overlap.

## Workflow

1. **List the actions** as observable events: submit, record a result, approve, hand off.
2. **Trace each action to its write surface:** the exact form, table, page, or endpoint that stores it, and the field or event proving it happened. A summary counts only if it accepts and persists the action.
3. **Map the reporting surfaces:** which summaries and views show the result, how fresh, what they omit.
4. **Check access per role.** A preparer's access does not prove a reviewer's.
5. **Publish an action map:** who performs it, where it is entered, what evidence is written, where others verify it, what to do when evidence is missing or inconsistent.
6. **Walk one real or safe sample** from entry to readback and confirm the summaries point at the same record. A stale or partial view is not proof of completion.

## Must-check items

Generic rules; bracketed example from one domain.

- **A summary view that accepts edits.** If it saves an edit, it is a write surface, whatever its name says. [retail: a stock dashboard where someone added a SKU that never reached the receiving table]
- **The same record entered through two surfaces.** [a shipment entered in the batch table, then again in the dashboard]
- **Status spelled several ways in the verification view.** State which spellings it counts. ["shipped" / "dispatched" / "sent"]
- **Status contradicting its evidence.** Report the conflict; do not pick a side.

## Pitfalls

- A summary that looks read-only may be hand-edited, which makes it a second write surface that will drift.
- Rollups lag minutes to hours. A blank cell may mean "not refreshed", not "not done".
- View permission and table permission are separate grants; check the actual grant, not the role label.
- Chat approval is not a record. If nothing persists the handoff, report the evidence gap and propose a recording point.
- Anything not verified is marked unknown, never filled by assumption.

## Self-check

- Each action has a write surface, an evidence field, a verification view, and per-role access.
- One sample action was traced end to end with readback evidence.
- Each summary's refresh behavior is documented or marked unknown.
