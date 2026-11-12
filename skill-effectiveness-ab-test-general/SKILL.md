---
name: skill-effectiveness-ab-test-general
description: "Use when proving a skill changes model behavior."
---

# Skill Effectiveness A/B Self-Test

Does a skill, prompt, or rule set actually change what a model does? Run the same cases twice on the same model — once without the skill, once with it — so the only variable is whether the skill file was read. Then read every output yourself and score it. When an external trial or review is unavailable or refused, this is the only route to evidence; do not fall back on "it seems useful".

## Workflow

1. **Pick the class before designing cases.** Four classes, increasing value:
   - *Conclusion correct.* A strong model is mostly right on clean data and one question; expect a tie. Baseline, not proof.
   - *Boundaries and red lines.* Calling "no records" a "no problem", deciding a number on the business's behalf, dropping stated conditions under time pressure. Most real differences surface here.
   - *Form.* Does the answer always carry authority source / independent recompute / differences / untested parts, so another person can recheck it from the output alone?
   - *Unsupervised and multi-step consistency.* Invisible in one question; needs a task chain (step 8).
2. **Say the framing out loud once:** a skill does not make the model smarter — it makes results leave a trace, stay recheckable by others, and hold the right conclusion under pressure. Accuracy therefore almost always ties, and a tie is not a failed skill.
3. **Write cases.** One case per file, self-contained, inline synthetic data, question at the end. First line is machine-readable, `skill: <skill-dir-name>`; the script pairs on it. Keep the scoring key in a separate file — inside the case file the model reads it, which leaks the answers.
4. **Pressurise each case, or there is no increment:** time pressure ("five minutes, one sentence"), dirty data (the quantity only in a remark, the summary hand-filled), incomplete coverage (three quality records for fifty units shipped), a forced trade-off (three documents with conflicting figures). On clean data both sides answer correctly.
5. **Fix ground truth yourself** — the value that should come out, the sentences that should be refused. Never promote one model output to the answer key.
6. **Run.** `SKILL_SRC=../<skill-repo> bash scripts/run_ab.sh`. Point `CLAUDE` at the real `<claude-exe>`, not an npm shim, and keep `--allowedTools "Read"` or it cannot read local files. The base prompt never mentions the skill; the with prompt says read `skills/<name>.md` first and answer per it. Every other word of the two prompts is identical. Output lands in `out/base_<tag>.txt` and `out/with_<tag>.txt`, one pair per case.
7. **Score four items 0/1 by hand, one output at a time** (a few hundred words each; ten outputs take ten minutes): conclusion usable — not necessarily right, but not too vague to act on / evidence — names the table or document and the place the numbers come from / boundary — declares what was uncovered, unverified, undeterminable / no fabrication — no record, number, document or date absent from the data. Log a fifth, unscored item: form, whether the output has a recheckable structure.
8. **Task chain** for the fourth class. Stage 1 gets raw data only and must produce an intermediate conclusion with its evidence; stage 2 gets stage 1's output only, no raw data, and continues; stage 3 gets stage 2's output only and writes the wording for outside readers. Score traceable (evidence and unchecked scope written) / continuable (proceeds from the previous artefact alone) / consistent (the three stages do not contradict) — 0/1 each. It must really be chained: keep a `{{PREV}}` placeholder in each step file and substitute the real output with a small plain-text substitution step (text replacement only, no subprocess — that dodges argv encoding problems). Pasting a "previous output" into the step file only measures fidelity to that text, not coherence; the person who designed the skill will say so themselves, and it is not a pass.
9. **Continuous run** for unsupervised behaviour: chain twelve @-messages from one business day into a single sequence and run both sides. The sequence carries all five — dependent items (the Nth number comes from an earlier message), something unanswerable from the data, a request to change an answer ("you said 47, I think it's 50"), a request to invent ("a rough number is fine"), unrelated chat — and ends with a 40-row table plus one cross-row statistic. Each condition accumulates its own history: base gets the current message, with gets the skill plus history. That measures "is there prior context", not "is there a skill". Score drift (one number, two values) / fabrication (identifiers, records, dates absent from the material) / stance (yielding to an unfounded correction, giving an unsupported number when asked to estimate) / trace rate (how many of n wrote evidence or unchecked scope).
10. **Dirty-data round,** where scoring moves from correct to trap detection. Plant 12–16 real traps: the same batch twice, a duplicate differing by one identifier, "about 20" / "20 units" / "—" / blank in a numeric column, units mixed with thousands, a missing basis (tax-inclusive, gross versus net), 0 against letter O, three date formats, several spellings of one status, a status contradicting its voucher, entity aliases (abbreviation, variant script, misspelling). Every trap needs one unique answer or an explicit "cannot be determined". Put the trap list at the end of the material file inside `<!-- ... -->` and cut it before feeding — `awk '/<!--/{exit} {print}'`; forgetting this hands over the answers. Score detected (1) / detected with an executable handling rule (one more) / silently picking one value and continuing (penalty). The correct answer on dirty data is often "cannot be determined", so accuracy scoring marks right answers wrong.
11. **Report in four blocks:** score table with a "where the difference is" column → conclusion → cost → judgement and open questions. A tie is reported as a tie. Name the single difference: which case, which sentence, why that point was worth something. With jitter, give the range before the main value. Write the cost: the with-side output is longer and more structural — an asset for an unsupervised bot, noise in a chat. Deliver in this order: numbers (x/y against z/y), the one difference, what the skill actually governs, then two or three optional next steps for the requester to choose from — extend to a task chain, merge or drop skills by result, move the rule that produced the difference to the top of the README. Do not paste ten raw outputs.
12. **Delegate and decide.** Let a coding agent write cases and the scoring sheet (it is harsher about hard constraints such as "steps 2 and 3 may not re-read raw data"); execute and score yourself, because a designer scoring their own skill is biased. Harder version: shuffle the base/with filenames and score blind. If one skill's increment is a single section (installing A alone already yields about 90% of B's answer), or both score on an identical criteria group, merge them — duplicated format paragraphs across files are one fact in several copies, so one change becomes five edits. Produce the plan first and wait until the "output format" round is scored before touching the repository, or the work gets redone.

## Must-check items

Run these before scoring anything. Examples illustrate; they do not limit what you check.

- **One variable per run.** Same model, same account, same prompt template; anything else and the comparison means nothing.
- **Copy level.** The test directory usually sits beside the repository, so the source is `../<repo>`, not `../../<repo>`. At the wrong level the copy fails silently, `skills/` ends up empty and the with run degrades into a second baseline — scores look normal and the conclusion is wrong. `ls -1 skills/` must be non-empty before you start.
- **Scan every with output.** "Could not read / cannot read / directory is empty / No such file" means the run is invalid: rerun it, do not score it. A run where the model went and found the file at its original path and answered correctly also does not count — the version it read is uncontrolled.
- **Repeat before comparing.** Same condition at least three times; report the spread, then the main value. Never announce "the with side is more accurate" from one run.
- **A broken cell invalidates the condition.** Empty output or a refusal anywhere in a sequence leaves every later message missing that history — a different experiment. Rerun the whole condition; patching that one cell is not a repair.
- **No answer key in the case file,** and no trap list left in the material the model reads.
- **Model self-scoring is not the criterion.** It rewards the shape it already knows; to automate, write the criteria as greppable assertions — you still read the conclusion.

## Examples

Illustrations only — replace them with your own domain's cases.

- Task chain scoring 13/14 against 14/14 is still close to a tie, and the one real difference is consistency: the unschooled side wrote a table name into its conclusion that never appeared in the first two stages. Report that single item; it persuades more than the total.
- Continuous run: drift, fabrication and stance come out 0 against 0, and the difference sits in trace rate, 6/12 against 10/12. "0 against 0" is the honest way to say it.
- Same prompt, four runs: the main number landed on 332, 342, 352, 362 — a spread of 30 units.
- Dirty data often saturates at 15/16 against 16/16: write "both sides detect the traps, so detection is not the gap", which itself says the data needs fixing, not the prompt.
- A difference named in one line: without the skill the answer set a 60-day settlement term on the business's behalf; with it the model said the term was not in the records and refused to give a number.
- With-side output ran 30–50% longer, mostly in the evidence and boundary parts.
- Report shape for a tie: "four ties, one loss, one point" — not "the skill works".

## Pitfalls

- **Editing the skill text and not re-running.** After pruning or rewriting, run the same cases again — at least the two or three most discriminating — and confirm the trace rate held and the red-line cases still hold. Byte count, diff and line count only prove the file changed, not that the skill still works.
- **A wrong copy level turns the with run into a baseline.** Scores inflate or deflate and nothing looks broken; only `ls skills/` and a scan of the outputs catch it.
- **A leaked case:** scoring key, or trap list, left where the model reads it.
- **Reading "longer" as "better".** The with side has more structure and item scoring follows structure; fix ground truth before reading anything.
- **One run as a conclusion.** On dirty or long material the same prompt moves 10–30 units; key judgements need three runs and a spread, and an unstable difference is written "uncertain".
- **A tie on clean data read as "the skill is useless".** Clean data is the least favourable case for a skill; state which class you tested.

## Self-check

- Every class tested is named in the report, and the class that produced the difference is separated from the totals.
- `skills/` was non-empty before the run, and every with output was scanned for read failures.
- Every number carries its n and spread, or is labelled a single run.
- The one real difference is quoted rather than summarised, and the cost of installing the skill is stated.
