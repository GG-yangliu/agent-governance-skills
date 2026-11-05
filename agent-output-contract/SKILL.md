---
name: agent-output-contract
description: "Use when an agent must answer from data with evidence."
---

# Agent Output Contract

Define a contract for an agent that reads data and returns an answer, so source coverage, uncertainty, and failure behavior are visible.

## Workflow

1. **Name the task and audience:** the question, the reader, the decision it supports.
2. **List permitted sources.** Per source: role, lookup identifiers, fields, freshness and access limits. Separate the authoritative source from summaries and caches.
3. **Require evidence.** Every material claim cites a record identifier, link, timestamp, or field. Copy identifiers from source data only; never fabricate one or fill a gap with plausible content. If nothing is found, say so.
4. **Specify failure states:** source unreadable, no match, conflicting records, stale data, blank required field. When ambiguity changes the answer, ask. When the decision belongs to the business owner, stop and give a conditional answer.
5. **Choose the output format.** Human-facing: sections. Machine-facing: schema, types, required fields, error form, no conversational prose.
6. **Set action boundaries.** Read-only, or a named action. Anything that changes records, sends messages, or touches external systems needs explicit authorization, stated in the output.
7. **Test six cases:** normal, no result, missing field, conflicting records, source read failure, ambiguous request. Check content and failure behavior separately.

## Must-check items

Check the answer itself, not the data model. Rules are generic; the examples below illustrate them and do not bound them.

- **A value without its unit or basis.** Currency, scale and gross/net must be stated beside every amount; if the source is silent, write "basis not stated" rather than assuming one.
- **An approximation carried as a figure.** Keep it out of totals and label it approximate.
- **A completion status whose evidence is missing.** Do not treat "done" as verified: show the status and the missing evidence side by side and call it a conflict.
- **One entity or status in several spellings.** State which rows matched and which did not, so the reader knows what the answer covers.

## Examples

Illustrations only — replace them with your own domain's cases.

- A contract amount written as "2,150,000" with no currency and no statement of basis.
- A quantity cell reading "~20" added into a total as if exact.
- A record marked shipped while its dispatch reference is empty.
- A customer recorded as "Acme Ltd", "Acme" and "ACME Limited" and counted as three.
- A missing category defaulted to "other" and then reported as if it had been read.

## Pitfalls

- **"No record found" and "the lookup failed" are different answers.** Reporting a tool error as an empty result claims a check that never happened.
- **Pagination and rate limits** can leave the first N rows presented as the full set. State rows retrieved and the total if known.
- **Silent fallbacks** must be labeled as inference. Check timestamps on caches and summaries when freshness matters.

## Self-check

- Each material claim traces to a record, or is labeled inference.
- A failed lookup is reported as a failure, not as "no data".
- Row counts and limits are stated wherever completeness matters.
