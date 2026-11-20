---
name: business-rule-registry-general
description: "Use when a rule drifts or a live model must change."
---

# Business Rule Registry and Live-Model Changes

For a long-running business system — database, spreadsheets, instruction sheets — where the same rule has been re-decided
several times and old documents contradict each other. Use it for a rule decision to record, a live table or cost model to
change, an instruction sheet handed to another executor, and the moment before a rule change lands in a live artifact.

## Workflow

1. **A rule change lands in the registry, or it did not happen.**

   | Artifact | Carries | Never carries |
   |---|---|---|
   | Work log, per day | what was done, what is open, next start point, control numbers | the current rule (it drifts) |
   | Lessons doc | one reusable lesson: cause, correction, how to avoid | running commentary |
   | Rule registry | the single authoritative list of current rules; superseded entries stay, marked | reasoning and dead ends |
   | Task order | executable instructions for one executor, citing registry entry ids | rules invented inside it |

2. **Build one registry file**, entries numbered per domain (`<PREFIX><n>`): governance, product, contract, logistics,
   funds, cost. Prefixes must not be confusable with entity names — `F4` in a system whose table is `F04` gets misread — so use
   domain-word prefixes (`FD`, `CT`, `LG`) or `R-<domain>-<n>`.
3. **Write each entry as `id | rule | status | landed | source`.** No `date`, no `decided by`: the registry records what is
   confirmed, not who said it when, and a per-row name turns a decision into history. Dates belong in a separate source-trail
   appendix, not in the entry prose either.
   - Wording states the confirmed practice only — no decision-maker's remark, no oral note, no sign-off, no suggestion; an
     unconfirmed rule stays out until it is confirmed.
   - `source` must locate something: `ledger YYYY-MM-DD / <entry id>`, or a same-directory relative link. "as agreed in the meeting"
     or "session 10-11" locates nothing a year later, and the fix is a same-day ledger line, never a retrospective
     reconstruction; keep that trail in the appendix with its build, verify and link steps. The body id set must equal the
     appendix id set. A `source` naming the registry itself, or only a version label (`v1.1 added`), locates a *when* and never a
     *why*: target zero such rows.
   - `status`: effective / superseded / pending. Never rewrite an entry in place — add the new one and mark the old
     `superseded → <new id>`, so the evolution stays visible. A rejected proposal stays `status: closed` with its reason. Each
     pending decision records the default that applies until it is settled.
   - `landed`: built / partial / not built / needs read-back, filled by reading the live system rather than the plan, so a
     decided rule is never mistaken for an implemented one.
4. **Keep stale text visibly stale.** Each new work log opens with a short "current only" summary, and a superseded section
   inside a long document is marked in place (`this section is superseded by <id>`). A read-back audit lands as one dated
   section declaring it overrides `landed` for every entry, instead of editing dozens of cells.
5. **Task orders cite a rule, never define one.** Header: the registry entry ids it depends on, the executor, preconditions,
   an expiry, the revocation condition (which rule change voids it). The issuer revokes and reissues when a cited rule changes;
   the executor stops and reports on a conflict instead of improvising a variant that happens to run. Deliverables belong in
   the order: read back after each change, quote the acceptance control numbers, paste errors verbatim, list the fallbacks
   used.
6. **Verify the input before you implement it.** A rule change often rests on a secondhand number — a verbally reported
   loading figure, a legacy spreadsheet cell — so test it against master data first: unit volume × units-per-container against
   container capacity (agree within a few percent); shares totalling 100%, denominator equal to Σ(quantity ÷ per-unit
   capacity). If the coefficients work out only because of the number under suspicion, the tidy result is the tell. When it
   fails, do not implement and do not average: report the implied conflict with both numbers and ask for a written source,
   since an unverified multiplier propagates silently into every downstream price.
   - A failing value is often not an error but an estimate — a supplier's pre-production guess never validated by a real run.
     Report it as "physically impossible ⇒ at least one of the two fields is unverified", let the owner classify it, and expect
     the durable fix to be a rule (only measured inputs may be used in costing and quoting), not an edit to the number.
   - When two repairs are both internally consistent, choose the one that matches how the owner reasons, apply it to every
     pool, and keep the other as a check cell. Two mechanisms can each total 100% and still split the same amount a few
     points differently, so a workbook built on one and a share table built on the other disagree with nothing to point at.
   - To localize "the shares don't match", compute the implied per-model share under each candidate mechanism and compare it
     with the registry shares: that names the stale side without re-deriving the model.
   - Make the denominator cell's label match its meaning. An auto-summed slot total and a hand-filled real container count are
     different numbers, and a "slot total" label over a cell hinting "number of containers" is the most common reason the owner
     asks what to type in the box.
7. **Land the change in one class at a time.** Back up first (archive folder, `_pre-edit` suffix) and report the path. After
   each class, verify against control numbers and report before/after per row for every value that moved. Supersede, never
   overwrite: the old entry gets `superseded → <id>`, the new one records the evidence that overturned it. When an instruction
   contradicts a documented rule, surface the conflict with evidence, implement what the owner decides, register the outcome —
   reversing your own earlier change is normal, so say so plainly with the arithmetic instead of quietly flipping a value.
   - Inserting an entry into a markdown registry: anchor the edit on the whole existing line. A head-fragment replacement
     leaves the tail of the old line glued to the new text and the two entries merge into one row; read the returned diff after
     every insert-style edit, and if they merged, patch once more on the unique glued text.
   - Table-structure edits (drop or insert a column, renumber sections) are script jobs: loosen the entry-id regex so
     superseded variants (`T-3-old`, `T-10R`) are not skipped and left with the old column count; renumber every `§N`
     cross-reference in the same pass, largest N first (`§10→§11` before `§9→§10`); and prove the body survived by stripping the
     new appendix and diffing against the pre-edit backup, where the only legal difference is the separator line you added.
8. **Sweep a re-decided rule across every carrier.** The rule text is the smallest part of the job — the same rule is
   duplicated in a registry entry, role manuals, a spec sheet, navigation pages, a checklist table, local knowledge files,
   trial-run sheets and agent skills. List the carriers from the live tree before editing: the registry entry (authoritative
   and cloud copies), role manuals, the spec document, the navigation page, the pointer doc, the checklist table, the local
   knowledge index, the trial-run plan, the executor sheet, the executing skill(s), the local mirror of the cloud pages, and
   the log and ledger rows. Then:
   - Leave a supersede trail, never a deletion: the old entry keeps its text with `superseded → <new id>`, the new one says
     what was overturned, the registry's change appendix gets one row. Historical change-log rows in other documents keep the old
     wording — they are history, not instructions.
   - Sweep table columns, not only prose. A checklist row that leaves the boundary must move in every column that encodes
     ownership — who provides it, who follows up, requiredness, trigger timing, stage name — and a stage value is a select
     option, renamed with the same controlled discipline as any other.
   - Verify by counting the superseded term per carrier, not by re-reading: every remaining hit must be a supersede note or a
     historical row, and any other hit is a miss.
   - Write the rule where humans and other agents read it: the registry and the shared pages are the source, your own skill is
     an execution aid that cites them, and a rule that lives only in a skill gets re-invented.
   - Prefer a written rule plus an on-demand check over a scheduled sweep — recurring polling is not the way to keep things
     correct, while a read-only checker anyone can run when needed is welcome as a double-clickable manual tool, not as a timer.
   - In-place edits leave no visible trace, so report node → section paths and ask for a page refresh; "I changed it" without a
     path reads as "nothing happened".
9. **Edit a live spreadsheet model without breaking it.**
   - Set only cell values, so existing formulas, number formats and merges survive, and copy the neighbouring style when
     writing into an empty cell. Set the full-recalculation flag before saving: the editor never computes and saving drops cached
     results, so the file looks hollow until reopened. Then recalculate headlessly
     (`soffice --headless --norestore -env:UserInstallation=file:///<tmp-profile> --convert-to xlsx --outdir <tmp> <file>`), read
     the converted copy with cached values enabled, and check the control numbers. If the interpreter lacks `openpyxl`,
     build a throwaway env (`uv venv -p <explicit python path> <tmpdir>` — without `-p`, `uv` latches onto the first
     interpreter it finds — then `uv pip install --python <tmpdir>/Scripts/python.exe openpyxl pillow pypdfium2`).
     A helper script that shells out to a spreadsheet binary may die decoding its localised stdout on a non-UTF-8
     console; call the binary directly instead.
   - Any value in more than one table is one authoritative field plus lookups; when auditing, diff the copies and report the
     drift, because hand-typed duplicates diverge quietly. When you change what a subtotal column contains, re-derive every
     column that consumes it — a total that already added the components adds them again, so check per row that the final column
     equals the subtotal plus only the items it no longer owns.
   - Give the model two cost columns: "known cost so far", treating a not-yet-filled fee pool as 0 so it can be quoted from
     while the other party still owes numbers, and "final cost", blank unless every input is present — one column either hides
     partial results or dresses them up as complete. Wire sections that share an input to each other (`=B21`) so one number is
     maintained in one place, and say so: an override is then just typing over the formula.
   - Diff the backup against the edited file cell by cell, values and formulas, before reporting — it produces the change list
     third parties need and it is the only way to catch both your own unintended edits and a co-editor's changes between turns.
     That co-editor edits the workbook between rounds: re-read the live file and re-diff before each round, work from the cells
     just read rather than the remembered layout (rows get inserted, cells deleted, the file renamed — report it, then use the
     current name), and if the file may be open in a desktop app, say so instead of a one-cell cosmetic fix that the next save
     overwrites.
   - Ship an in-file reader's guide whenever someone other than the author will open the model: a compact block at the bottom
     (section | which cells are inputs | what to fill | the algorithm), one rewritten explanation row per section, a per-row note
     naming the basis that row uses (own container vs mixed, measured vs estimated). A cell map kept only in the transcript
     guarantees the next reader asks again, and every long explanation cell needs an explicit row height with wrap-text — a
     merged full-width row is one row tall, clipped on screen and sheared at the printed page edge however fine the sheet looks.
   - Verify legibility by rendering, not by assuming: convert to PDF headlessly, rasterize a page and look at it. Text hidden
     behind the next row is invisible to every text-based check, so a clean value diff can pass a workbook nobody can read.
10. **Write the rule so a human and a machine can both judge it.**
    - Two layers share one numbering and one criterion: the human checklist and the machine rule page use the same node ids,
      names and completion criteria, and a machine page with its own status names becomes two vocabularies at once. Write the
      whole content layer first, then structure it.
    - Each node carries nine elements: id · entry condition · when to remind · what must be complete · when it must be complete
      · what to check · who to ask when missing · completion evidence/criteria/next node · basis. Omitting "when it must be
      complete" produces false alarms, since material that only exists at a later node is marked "requested in advance" earlier;
      completion criteria must not read "complete → pass" but "check passed; where a human gate applies, proceed after the
      confirmer confirms" — a passed check is not a release.
    - Never write quantities from different record groups as one equation: main contract quantity, supplementary contract
      quantity (with a suffix) and execution adjustment are three record groups, and "A = B = C" necessarily false-alarms on any
      order with a supplement or an adjustment. Reconcile group by group and state the aggregation basis (whether the summary
      includes supplementary contracts, which quantity field it uses).
    - Detail calibers follow the current specification, and one change syncs several places: which photos a licence needs, a
      performance parameter, how a model is written are each often stated in the checklist, the data sheet and the role manual at
      once, so fixing only the named one returns as "two places disagree" at the next review.
    - A problem raised by someone else — another agent, a reviewer — usually exists elsewhere in the same shape: fix the one
      that holds, then grep the whole library for the same pattern and fix them together, stating the reason for each that does
      not hold. Multi-round review items accumulate, numbered, under the same ledger entry.
    - A full rewrite silently drops content: paragraphs vanish and nobody notices until review. Grep the old version's key items
      into a list before rewriting, then read back and count hits — whatever fell to 0 was lost.
    - State publication status as published or pending implementation. A rule page written is not a rule running: while an
      interface is unconnected, a workflow disabled or a permission unverified, write "rule ready, running pending
      implementation", or everyone including the owner assumes it already runs.
11. **Archive, and keep a legacy map.** Superseded documents move to an archive folder, never deleted: the registry's
    `source` column points at them, so deletion breaks the audit trail. Before deleting anything at the owner's request, extract
    and confirm the raw facts and control numbers that exist nowhere else, the field-id technical evidence a rebuild would
    otherwise rediscover, and the lessons worth keeping. Keep a legacy identifier map in the registry — old table and sheet
    codes to current names, plus what each archived document held and which entry absorbed it. Archived logs, older task orders
    and executor configs still cite the old codes, and a workflow configured from a legacy name queries something that no longer
    exists — surfacing as "table not found", not as a stale rule.
12. **Report so the arithmetic is visible.** On "the two sides don't match", name the two numbers and which table summarized
    what, expand the multiplication row by row (quantity × unit price = amount), then add the source document item by item —
    "how is this computed, I don't follow" means the arithmetic was not shown, not that the number is wrong. Lead with the
    conclusion and the decisive numbers, plain text with tables where they help; answer numbered points in order and act on
    whatever was authorized in the same turn; flag an unrequested finding when it matters, since "this number contradicts your
    own master data" beats a clean summary; end with the single decision you need, phrased so one sentence settles it. Asked
    whether a section uses basis A or B, read the live formulas out of the file, show them per row side by side, then name the
    few places using the other basis — the confusion usually traces to two columns holding the same number in one section (a
    per-container quantity typed into a quantity column), so explain why they look alike. An estimate reusing a past batch's
    per-container fee ships with its assumptions (fee proportional to container count, unit price unchanged, container
    homogeneous) plus which rows fit them and which they distort, since customers are quoted off that number. Prefer the
    simplest structure that works: when extra fields or a new table are declined as complexity, accept it in one line, register
    the rejection, and fall back to the lightest option — a distinction that cannot be violated in the path that matters is a
    written discipline, not a schema change.

## Must-check items

Before reporting, confirm each of these. Examples illustrate; they do not limit the check.

- **Superseded numbers still on screen:** after editing an entry that quotes numbers, grep the registry and every live
  artifact for the old value and recompute each derived table.
- **Body and appendix id sets equal**, zero `source` rows naming the registry itself or only a version label, and `landed`
  read from the live system rather than from the plan.
- **Every table-structure edit proved:** superseded id variants matched, `§N` references renumbered largest first, body
  diffed against the pre-edit backup.
- **Every insert-style edit read back** with a cell-level diff before reporting a workbook change: old line intact,
  new entry on its own line, values and formulas both compared.
- **Superseded term counted per carrier**, each remaining hit classified as a supersede note or history.
- **Legibility rendered**, not inferred from a clean value diff.
- **Publication state written**: published, or ready with running pending implementation.
- **Every rule names where it is enforced.** A rule that lives only in a document is advisory, however precise it reads. Record the enforcement point — script check, field description, prompt clause, or pre-write gate — and whether a machine check actually exists. Rules with no enforcement point are the risk list; publishing a rule without one is an unfinished change, not a completed one.

## Examples

Illustrations only — replace them with your own domain's cases.

- A freight rule that lived in a chat message and was restated in a later rate sheet with the opposite threshold.
- `GRP-4 | demurrage starts on the fourth free day | effective | built | ledger 2026-03-02 / GRP-4`.
- `T-3-old` skipped by a strict regex, so one row still has four columns in a five-column table.
- Two allocation mechanisms that both total 100% and split the same fee a few points differently: a per-container
  denominator (each row multiplied by 1 ÷ the slots in its container) against a global Σ(quantity ÷ per-unit capacity)
  that exceeds the real container count. Every row reconciles; the two artefacts still disagree.
- `§10→§11` applied before `§9→§10`, so both sections end up numbered 11.
- A CRM stage renamed while the follow-up column still names the previous owner.
- An allocation whose denominator reaches 100% only once an unverified container count is included.
- A model with one cost column, so a quote is either incomplete or padded.
- A rule page marked published while its workflow is still disabled.

## Pitfalls

- A rule that lives only in a work log or a chat message is contradicted by the next document written from memory; a rule
  phrased as a suggestion reads as optional.
- A strict entry-id regex skips superseded variants silently, so exactly the uninspected rows render broken; renumbering
  in the wrong order cascades onto text another edit already moved.
- A head-fragment insert glues the old line's tail onto the new entry, merging two rows into one.
- Mixing allocation mechanisms across pools: both total 100%, split the fee differently, and neither document explains the
  gap. A label that does not match its cell invites the wrong number in the right box.
- Counting superseded terms by re-reading misses carriers; a scheduled sweep runs forever and misses one too.
- Deleting an archived document breaks the `source` trail; a missing legacy map surfaces as "table not found".
- A full rewrite drops paragraphs silently; an unstated publication state is read as "already running"; an in-place edit
  reported as "changed" reads as "nothing happened".
- A workbook edited while open in a desktop app loses the change at the next save; a cell map kept only in the transcript,
  or an explanation row without height, leaves the model unreadable to all but its author.

## Self-check

- The rule exists as an entry with a locatable source, a status, and a `landed` value read from the live system.
- No artifact still carries the superseded wording outside a supersede note or a historical row.
- Every changed value has a before/after pair and a control-number check behind it.
- What was not verified, not swept, or not yet running is stated in those words.
