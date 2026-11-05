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

These check the answer, not the data model. Each rule is generic; the example in brackets is from one domain — substitute your own.

- **Unstated unit or basis.** An amount without unit, scale, or gross/net basis is not comparable; if the source is silent, write "basis not stated". [trade: a contract amount "2,150,000" with no currency and no tax basis]
- **Approximation presented as a figure.** Carry it separately, never into the total as if exact. [logistics: a quantity cell reading "~20"]
- **Status claiming completion while its evidence is missing.** Show both, label it a conflict. [a row marked shipped with an empty dispatch reference]
- **One entity, several spellings.** Say which rows matched and which did not. [CRM: "Acme Ltd" / "Acme" / "ACME Limited" counted as three accounts]

## Pitfalls

- **"No record found" and "the lookup failed" are different answers.** Reporting a tool error as an empty result claims a check that never happened.
- **Pagination and rate limits** can leave the first N rows presented as the full set. State rows retrieved and the total if known.
- **Silent fallbacks** (defaults, inferred categories, assumptions) must be labeled as inference. Check timestamps on caches and summaries when freshness matters.

## Self-check

- Each material claim traces to a record, or is labeled inference.
- A failed lookup is reported as a failure, not as "no data".
- Row counts and limits are stated wherever completeness matters.
