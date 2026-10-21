---
name: agent-output-contract
description: "Use when an agent must answer from data with evidence."
---

# Agent Output Contract

Define a reliable contract for an agent that reads data and returns an answer. The contract must make source coverage, uncertainty, and failure behavior visible.

## Workflow

1. **Name the task and audience.** What question does the agent answer, who reads the result, what decision does it support.
2. **List the permitted sources.** For each: role, the identifiers needed to retrieve records, relevant fields, freshness and access limits. Distinguish the authoritative source from a summary or cache.
3. **Define evidence requirements.** Every material claim needs a record identifier, link, timestamp, field, or other traceable reference. Do not fabricate identifiers or fill gaps from plausible context.
4. **Specify failure states.** What to say when a source cannot be read, no record matches, records conflict, data is stale, or a required field is blank. Ask for clarification when ambiguity changes the answer.
5. **Choose the output contract.** Human-facing: sections and language. Machine-facing: schema, types, required fields, error representation. Do not mix conversational prose into a strict payload unless the consumer allows it.
6. **Set action boundaries.** Read-only, or may perform a named action. Any action that changes records, sends messages, or affects external systems requires explicit authorization.
7. **Check representative cases.** Normal result, no result, missing field, conflicting records, source read failure, ambiguous request. Verify content and failure behavior separately.

## Contract template

- Purpose and audience
- Authoritative sources
- Lookup keys and required fields
- Freshness requirements
- Evidence format
- Response schema or sections
- No-result behavior
- Missing or conflicting data behavior
- Read / write boundary
- Acceptance examples

## Pitfalls

- **"No record found" and "the lookup failed" are different answers.** An agent that reports a tool error as an empty result has lied about checking.
- **Pagination and rate limits** can leave an agent holding the first N rows while presenting them as the full set. State the row count retrieved and the total if known.
- **Fabricated identifiers** are the most damaging failure, because they look checkable. Copy identifiers from source data only.
- **Silent fallbacks**: a default value, an inferred category, or a "reasonable" assumption must be labeled as inference, never presented as data.
- **Stale caches and summaries** answer faster and are wrong more often. Check the timestamp when freshness matters.
- **Ambiguity that changes the answer must become a question**, not a guess with a confident tone.

## Acceptance checks

- Each material claim resolves to a traceable reference, or is explicitly labeled inference.
- All six representative cases were exercised and produced the specified behavior.
- A source or permission failure is reported as a failure, never as an absence of data.
- Retrieved row counts and any limits are stated when the result depends on completeness.
- Read-only versus write authorization is stated in the output, not inferred by the reader.
