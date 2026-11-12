---
name: external-agent-review-general
description: "Use when a plan or document needs a second opinion."
---

# External Agent Review (non-interactive, results to file)

A plan, a documentation rewrite, an architecture decision — and you want one or two **independent opinions** on it: fault-finding, not a rewrite. The reader is waiting for a conclusion and will not open a terminal or sit in on the run.

Coding-delegation skills cover handing implementation work out. This skill covers **one-shot counsel**: send a self-contained briefing, receive a structured opinion, verify every item yourself.

## Workflow

1. **Stage one directory.** Briefing, copies of the real files, and both outputs live in the same directory; `cd` into it before launching. What the reviewer cannot reach does not exist for it.
2. **Launch both reviewers in parallel** — first in the foreground, second in the background. Nothing blocks, and the minutes the background one needs are exactly the time to read the first answer and start verifying it.
3. **Write the instruction as one sentence** carrying three things: the reviewer reads the briefing file itself (the long text never goes into argv); it reviews and does not rewrite (otherwise you get a new plan instead of a judgment); the output format and its line limit (otherwise you get an essay nobody reads).
4. **Make `briefing.md` self-contained.** The reviewer knows no context; one missing block and the answer drifts to the wrong problem. Seven sections:
   - **Environment** — what the system is, where the truth lives, which carriers exist (database, documents, scripts), who maintains it.
   - **Symptom, with numbers** — why this is being discussed now. Measured numbers ("one change touched 13 categories across 20-odd places"), never "it feels easy to miss".
   - **Failures that already happened** — which spot, how it was found. A real incident persuades; a hypothetical does not.
   - **Root cause**, folded into a few classes: the same fact in several copies, isomorphic copies, scattered references, manual page-pasting.
   - **Candidate options with the cost and the limit of each**, plus your own ranking.
   - **Your checklist**, numbered item by item, with the request to look at this section hardest — it is where the increment is.
   - **What to do** — four fixed questions: which checks did I miss, what is the trap in each option, if only one can be chosen which, and is there a simpler route I overlooked. Then one sentence that **explicitly allows "send less / send nothing / leave this slot empty"**: without that exit it fills the quota, and the single most valuable line ever received was "leave the third slot empty, spend it on a section for what already shipped".
5. **Object is rules or prompt text, not a plan?** The question becomes "which sentence makes it fail in a live chat", not "which option". Four adjustments: sections 2–4 above become a real-incident list with identifiers and counts (an invented case number, raw JSON pasted into a chat, a confident wrong answer, one deletion that cleared eight more rows) — a clause with no incident behind it will be recommended for deletion, often rightly; the platform constraints go into the briefing (markdown renders literally so no tables or code blocks, the prompt is pasted into a third-party console and gets truncated and diluted, the bot reads but cannot write, no scripting); your own doubts get a section headed "you may refute me directly"; and the last paragraph must answer "if only three changes, which three", which forces a ranking instead of fifteen unordered items.
   - Keep the fact snapshot **minimal**: for each table named in the document under review, only the header row (table id, record count, field count) plus the field table, dated, in one small file. Hundreds of KB of schema text cannot be read to the end and gets read wrong.
6. **Object is a candidate list** (fields to drop, entries to merge, assets to retire)? The briefing needs three things: a numbered candidate table with an inheritance or reference lineage column, the full lineage or reference export (JSON is fine — say that only the named numbers matter), and the positions you cannot check yourself. Ask for a three-tier verdict **by number** (confirmed safe / recommend keeping / needs a human decision) plus a closing "if only ten items, which ten first". Unnumbered opinions cannot be executed or refused one at a time.
7. **Object is a live repository or a published artifact?** It reads the live content, never your copy or your paraphrase: only the real read shows the gap between "I changed it" and "live is still the old version". Allow the network tools (`--allowedTools "Read,WebFetch,Bash(curl *)"`); read access alone leaves it blind and it reports "verified" from nothing. Put the raw URL, the API tree URL, and "live is authoritative, the local copy is reference" into the briefing, then check which paths it cited — "all good" with no path cited means it did not look.
   - Verify its comments against live too, and not through raw: the CDN cache still serves the old bytes right after a push, which is how a good push gets misjudged as failed. Use `git show origin/main:<path>` or the API blob; raw is for human eyes only.
8. **Split design from execution** when the ask is a test or a checklist. A reviewer that designs the exam and scores it is grading itself:

| Hand to the reviewer | Keep for yourself |
|---|---|
| Design exam-style cases with hard constraints ("steps 2 and 3 may not re-read the raw data, only the previous step's output") | Execution: run the CLI, watch the log, collect artifacts |
| Criteria judgeable against the source text ("what counts as a violation") rather than "quality is good" | Scoring: read every output yourself, the designer does not score |
| Its own numbers recomputed before it reports them | Priority, and what to do next |
| Flaws in its own method reported unasked ("base without history is unfair", plus a switch to fix it) | External documents and the report |
| Script skeletons, blind protocol, shuffling | External side effects: publishing, uploading, changing a repo |

9. **Run the blind protocol** when comparing two versions: generate artifacts as `out/<condition>_<n>.txt`, rename to `S01…S24` before scoring with the mapping kept apart, restore afterwards. The designer sees numbers only.
10. **Close out per item, never by copying.** Rule every comment **holds / holds with a discount / does not hold**: holds → change the plan or add the check now and say "X was raised and adopted"; discount → say why (pulling numbers out with a regex over the whole text floods the alert list, so it becomes a structured assertion at known positions); does not hold → say so with the evidence, the measured behaviour. A point **both reviewers reach independently is the most credible**. A "simpler route" from either side is usually worth more than its criticism of the plan: report it separately.
11. **Rule on conflicts.** One says the enumeration moves out, the other that it defines the scope: delete that spot — can the step still be executed? Boundary gone → keep; only an example lost → move. Write the ruling and its reason into the closeout table; the next comment on the same line cites it instead of re-judging.
12. **Let your own doubts be judged too.** Suspicions listed in the briefing get refuted: "too concrete an example makes the model fixate on those categories" came back from both sides as not the cause — the example was already in the original text and was still misused, so the rule was not being executed. Mark each suspicion holds / partly holds / no evidence; a refuted one is conceded on the spot, which is what makes the next one credible.
13. **Write the closeout table** as `review_closeout.md` in the review directory, one row per comment: `# | who raised | comment (one line) | adopted / discounted / does not hold | which page, which sentence`. Every "does not hold" carries its basis — measured output, snapshot line, platform limit — because that column is what the reader re-checks. Add one line of arithmetic ("N total, x adopted, y discounted, z rejected") **to the reviewed document's own change log**, so "this version was reviewed" is provable from the document without opening megabytes of raw output. Items not adopted but worth a decision stay as one line with their cost, undecided. Raw outputs are archived as they came; the report to the reader is conclusion first (which option, why), then the pitfalls each side found, one line each, then the corrected action list — never the opinions pasted back.

## Must-check items

Before sending:

- **Can the reviewer see the facts?** Local files are copied in and readable; a question about a database or a cloud document gets an **exported read-only snapshot (schema plus records)** in the review directory. Only your own summary and it can test your narrative instead of the facts, which is not a review. The report states which raw files and snapshots it read.
- **Is the real file listing there?** `git ls-files` or `find . -type f`, so names and paths quoted in the text can be checked. The highest-value comment of this class is "the name in your text does not match the actual directory" — a missing suffix, and the reader cannot find what you described.
- **Are file and line numbers required?** One line in the briefing ("point to the specific line") turns comments into `doc.zh-CN.md:24-27`, which is checkable. A comment without a line number is reference, not basis.
- **Is every candidate named?** Past ten candidates the reviewer reads the ones the briefing names, infers the rest, and then says so. Give each one a line — filename, line count, what it covers — and require "read all of them before answering". Afterwards check which files it cited (`grep -oE '[A-Za-z0-9._-]+\.md:[0-9-]+' review_a.txt | cut -d: -f1 | sort -u`): uncited means unread. Then either ask again or mark it **not reviewed** and check it yourself.
- **Is its coverage boundary copied verbatim?** "These two unread, the rest inferred" goes into the table as "not reviewed (inferred)", never softened into "recommended not sending". Treating "not reviewed" as "reviewed" and cutting something that should have shipped is the worst outcome available here.
- **Is the difference measurable at all?** One question and one answer separates nothing, since a strong model gets short material right anyway; use a task chain of three real steps. Each scoring item is 0/1 and judgeable against the source text, never "quality is good". Record **shape difference** (length, structure) and **accuracy difference** separately: a one-point gap does not make something useless, and longer output does not make it good.

After receiving:

- **Judge its defect claims before believing them.** "Field does not exist" is grepped against the snapshot first; "not verified" is checked once with the command or API (`git log`, `git grep`, the endpoint); "file is mojibake" is decoded as UTF-8 on both sides and searched for `\ufffd` — a reviewer reading CJK through a console garbles it there and then reports that as a defect of the object under review. Any **platform-capability assertion is treated as not holding** unless you verified it ("this field can be undone within N days", "this API cannot read X"): such claims are usually inferred from a different product. Unverifiable means designing the operation as worst case — full backup, small batches, read back each batch — and "does not hold, basis: mechanism not found" in the table. Copying such a claim is how someone drops their guard on an irreversible step.
- **External facts stay yours to confirm.** When it answers "not sure" about whether a list is still active or what a platform allows, that honesty is accepted and you verify; if it invents a specific name or number, the whole item is void and does not enter the report.
- **Numbers are recomputed before they are argued.** "You wrote 50 characters, it is 53" is usually right and the error is in your own script or hand count. If it holds: fix the file, fix the number in the document's own claim, and admit it in the change log — fixing only the file gets caught again next round.
- **Evidence suggestions get a minimal experiment first.** When it says "add evidence" or "add a demo", run the smallest version yourself. A difference appears → write it up; none → say plainly why it is not being done. A comparison built to satisfy the suggestion gets torn apart in public.
- **Nothing is written by the reviewer.** It is counsel; writes are yours, each followed by a read-back.
- **Sensitive values stay out.** No real amounts, customer names or contract numbers; the briefing describes structure and number shape, values become placeholders.
- **Its "done" is not a fact.** "File written" is `ls -la`; "numbers checked" is your own recomputation; which files it read is what you actually read.

## Examples

Illustrations only — the commands are two shapes that work, other similar CLIs change their flags.

```bash
# reviewer A: foreground, clean return, 1-3 min, file read access allowed
claude -p '<instruction>' --allowedTools "Read"

# reviewer B: background + PTY, inside a git repo, read-only sandbox
cd <dir> && git init -q 2>/dev/null; codex exec -s read-only '<instruction>' > review_b.txt 2>&1

# instruction shape — one sentence, three requirements
Read briefing.md in full first, then answer strictly in the format of section 7:
four short paragraphs, eight lines maximum each. Do not rewrite the plan; find faults only.
```

A briefing's symptom section, across domains — measured, not felt:

- Trade: "One price change had to be entered in 4 places; 2 of the 9 orders quoted last week carried the old price."
- Logistics: "A delivery note and the warehouse sheet disagree on 12 of 340 cartons; the difference was found by hand, by nobody's check."
- CRM: "One account rename left 3 stale references, and the monthly report still groups by the old name."
- Retail: "The same item exists under 2 codes; 7 of 51 stock rows use the code the picker app does not know."

Closeout rows, including what a discount and a rejection look like:

| # | Raised by | Comment | Verdict | Where it landed |
|---|---|---|---|---|
| 3 | A | Extract every number by regex as a control total | Discounted: floods the alert list with matches from prose | Audit page §2; assertion limited to 4 known fields |
| 7 | A + B | Run the consistency check before any automation | Holds: both reviewers reached it independently | Ordered first in the action list |
| 9 | B | This field can be restored within 7 days | Does not hold: no such mechanism in the docs or the API | Deletion treated as irreversible; full backup first |

## Pitfalls

- **Startup red text is not a failure.** A missing shell completion file, `ERROR: Reconnecting... 2/5 … 5/5`, `warning: Falling back from WebSockets to HTTPS transport`, and then a normal answer. Do not declare it dead and do not restart it.
- **The answer is printed twice** (body, then a summary at the end). Take the last copy from the file; it did not answer twice.
- **CJK read through a Windows shell arrives as mojibake** (`20+ ?` fragments). The reviewer still understands it: do not conclude the briefing is broken, and do not re-encode it for the tool.
- **Never pipe the output through `tail -N`.** Buffering holds everything until exit, so the log shows only startup noise and looks stuck. Redirect to a file and poll the process state instead.
- **The background reviewer hangs in the foreground** with `pty requires background=true`; it only works inside a git repo, and the read-only sandbox is what keeps it from writing.
- **A launcher shim can swallow the instruction.** Ask the binary for a one-line reply first; if the reply is not that line, the positional argument was dropped and a canned answer came back. Fall back to piping the instruction on stdin.
- **Long non-ASCII instructions go straight into the shell.** Do not assemble them in a Python subprocess: on Windows the `.cmd` shim plus the encoding is a double hazard.
- **Its script cites flags it never ran** (`--tools ""`, `--system-prompt`). Check the help output, then run one case before the batch.
- **Its relative paths are routinely one level off** — five inputs missing, half the run reporting "cannot read file" while pretending otherwise. `ls` the artifacts before believing the run.

## Self-check

- Every comment in the closeout table has a verdict, and every "does not hold" has a basis the reader can reproduce.
- Cited paths and line numbers were checked; unreviewed candidates are labelled, not silent.
- The three-tier count is written into the reviewed document's own change log.
- No raw opinion text went into the report — conclusion, pitfalls, action list.
- Nothing was written by the reviewer, and every write of mine was read back.
