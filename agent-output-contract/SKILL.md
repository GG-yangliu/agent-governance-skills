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

- Report data-quality findings with row identifiers instead of cleaning silently: duplicates (exact, or identical except one identifier), "about 20" / "20 units" / "—" / blank in numeric columns, 0 vs letter O in identifiers.
- Put unit and tax basis beside every amount (yuan / 10k yuan, tax-inclusive or not); if the source is silent, write "basis not stated".
- Mixed date formats, or one entity or status spelled several ways: say which rows matched and which did not.
- Status contradicting its evidence (shipped, no waybill number): show both and label it a conflict.

## Pitfalls

- **"No record found" and "the lookup failed" are different answers.** Reporting a tool error as an empty result claims a check that never happened.
- **Pagination and rate limits** can leave the first N rows presented as the full set. State rows retrieved and the total if known.
- **Silent fallbacks** (defaults, inferred categories, assumptions) must be labeled as inference. Check timestamps on caches and summaries when freshness matters.

## Self-check

- Each material claim traces to a record, or is labeled inference.
- A failed lookup is reported as a failure, not as "no data".
- Row counts and limits are stated wherever completeness matters.
