---
name: automation-diagnosis-general
description: "Use when a deployed automation stops doing its job."
---

# Diagnosing a Deployed Automation That Misbehaves

For an automation the user already built on a no-code or agent platform that is not doing what they expect: "my automation doesn't work", "it's deployed but I don't know how to use it", "it feels wrong every time", "the bot answers with the wrong content", "the flow never triggers", "it's too heavy". The fault may be in the trigger, the deployment, the output, or the data. Finding out which comes before changing anything.

Not for a bug in code you can run and test; that is ordinary debugging.

## Workflow

Neither the user's account nor the configuration is evidence. The user reports a symptom ("it doesn't work") and separately asserts state ("I already configured that", "it isn't connected"), and the assertion is routinely wrong in both directions. Configuration cannot tell you whether anything ever *ran*; only runtime artifacts can. Gather evidence in the order below and form the hypothesis only after step 3.

1. **The destination's runtime record.** If the automation posts anywhere, read the destination itself — every message, oldest first, with sender, timestamp and full body. This single read settles both "did it ever run" and "is the output usable", and it can overturn the user's own account. The count of messages since setup is itself the diagnosis: silence in a channel where a trigger should have fired is proof the trigger never fired.
2. **The trigger object**, as a live object on the data side: the table's automation list, the schedule entry, the webhook registration. No trace of it firing in the destination means the trigger is the fault, not the action.
3. **The deployment state of every candidate version.** A project the user has been iterating that reports no deployment history means the thing they are fixing is not the thing that runs — the most common cause of "I changed it and nothing happened". List the deployment state of all versions before reading any code.
4. **The authoring history and the requirement.** The build conversation holds the original ask and every revision. Mine it for intent that was requested but never implemented.
5. **The data the automation reads.** Only now: are those fields actually structured? See baseline hygiene under Must-check items.
6. **Write the diagnosis to a file** in the user's own work-log location, in their language, in this order: the cause in one sentence; the facts you actually verified, each with the artifact it came from; root causes numbered by severity; the fix, cheapest and most independent step first; the decisions only the user can make; and an appendix of reproducible commands plus every object id touched, so a later session resumes without re-discovery.
7. **In chat**, lead with the conclusion, say which of your own earlier guesses the evidence overturned, hand over the file path, and end with the single decision you need. A firm diagnosis on artifacts is the deliverable — do not drift into rebuilding before the user has picked a direction.

### When a configured integration silently disappears

The user says a working integration is suddenly gone: the assistant is missing from `<app>`, the panel is empty, the plugin never reaches the menu. Do not start by checking whether the configuration was lost, and do not guess that an upgrade overwrote it.

1. **Prove nothing was lost first.** Name the config file, the CLI version, the history record and the credential one by one, and actually exercise one of them with a minimal request, reading what comes back. Clear the "everything I set up is gone" panic before discussing any defect.
2. **Put the startup logs of the last working run and this run side by side.** Logs are normally split per launch into timestamped folders; grep the same feature name in both. The working one shows the component activating and a non-zero count; the broken one shows only `Count: 0` or `not downloaded yet`. That difference is the diagnosis, and it is faster than reading code.
3. **Separate "configuration missing" from "runtime component never landed".** `not downloaded`, `Count: 0`, or a provider registered with zero capabilities mean missing runtime artifacts, not user error. Find its cache directory — usually under the app's user data, layered `<component>/<version>/<platform-triple>` — and look for a completion marker such as `.complete`. No marker means it never installed successfully.
4. **After repairing by hand, restart only the subprocess that hosts it.** Unpack the official artifact into the cache directory, add the completion marker, then kill only that subprocess and let the main program relaunch it. Do not restart the whole app and interrupt the user's work. Re-read the logs afterwards: the count should be back and the history entries re-registered.
5. **A version upgrade invalidates the cache key.** The artifact path contains the version, so old artifacts stop matching after an upgrade. On delivery, write one line: a major upgrade may bring this back, call me to replay it.

Report this case in this order: first "none of what you set up is lost" plus one piece of tested evidence, then the mechanism of the defect — which layer fails to deliver — and last a single action the user can decide in one sentence. Do not close on speculation such as "maybe the upgrade caused it": an unproven mechanism is worse than saying nothing.

## Must-check items

Run these before reporting a diagnosis. Examples elsewhere illustrate them; they do not limit what you check.

- **Diff deployed reality against edited intent, never against the plan.** Two versions of one intent commonly coexist: a heavyweight one that is live and being patched, and a lightweight rewrite that was never deployed. Report the deployment state of each and name which one to retire; never debug the version that is not running.
- **Establish whether the platform's workflow can even own the trigger.** Most workflow and agent products are pull-invoked: the workflow runs only when something calls it and has no native trigger watching a database row or a chat message. A design shaped "row changes, so the workflow runs" is missing a trigger source entirely — it must come from the platform-native automation on the data side, a schedule, or an explicit HTTP call from whatever does know about the change. Treat that as an architecture error and check it before debugging anything inside the flow.
- **An empty API result is not evidence of absence.** Some features are served by more than one API generation, and a list endpoint returning zero rows may simply not see objects created in the UI. Never conclude "you never configured it" from that. Report the raw result, name the uncertainty, and hand the user a one-glance manual check instead.
- **Fix the baseline before fixing the comparison.** Where the automation compares fresh data against a stored baseline, check the baseline's field hygiene first. An unstructured baseline — one paragraph pasted into a single text field while the structured fields sit empty — makes every parse and compare step fail forever, however many times the workflow is rewritten. Recurring JSON-decode errors are a symptom of the data, not of the code.
- **Fabricated values identify the ungrounded step.** An identifier that exists nowhere in the source table, an empty section where the rule says to cite rows, duplicated blocks, raw JSON in a prose field: each means that step is generating instead of reading. Each gets a hard constraint (no invented ids, cite the real source row id, no raw JSON, dedupe, lock the output template) — not a retry, and not a re-deploy of the same prompt.
- **List requirement drift as a table.** The user's latest spoken requirement frequently contradicts what is coded — silence on "no change" versus a positive "nothing new this week" message. Show old against new and make them choose; never silently pick one.
- **"Too heavy" is a diagnosis, not a feeling.** A version carrying auth layers, dry-run switches and gate flags for a business this size is over-built. Say so and propose the smaller shape instead of making the big one work.

## Examples

Illustrations only — replace them with your own platform, field names and ids.

- Deployment status before code: enumerate every candidate build and read each one's deploy status — a build reporting no deployment history was never deployed, while a succeeded build with a live endpoint is the one actually being hit. The never-deployed build is not the one to debug.
- Scheduler on this machine: `<agent-home>/scheduler/runs.db` has no rows for the job and the last-success marker has not advanced since <date> — that rules out this host only.
- Log diff, two launches: working `activate <component>`, `<feature> refreshed Count: 42`; broken `Count: 0`, `not downloaded yet`.
- Ungrounded output: an id that matches no row in the source, an empty cited-rows section, the same paragraph twice, raw JSON left in the prose field.
- Requirement drift: earlier "stay silent when nothing changed", now "post nothing new this week" on every run.

## Pitfalls

- **Locate the scheduler before assuming the trigger exists.** A recurring job the user remembers ("every Monday at 9") may live on a different host than the one you are on — an agent host's own timer, a platform-side workflow trigger, or nowhere at all. Check the local scheduler first and report it as evidence: the job list, the row count in the local timer and execution store, and whether its last-success marker advances. An empty local schedule rules out one whole explanation; it is not proof the job was never built, so say which host you checked instead of concluding.
- **Never-deployed is not never-ran.** An empty local schedule plus a candidate project reporting no deployment history together prove only that neither of those two runs the job. The same job may be owned by the platform's own scheduler, by a peer agent, or by another account. Phrase it as "I checked host X and project Y; neither owns this schedule", then ask the user who runs it before writing "it never ran" — a wrong negative here discredits every other finding in the report. Corroborate against the destination: the record the job would touch (a table column such as last-checked-at or last-updated) or the message in the channel carries the real trace, and its timestamp is what separates "ran" from "never ran".
- **Do not stop at "the link is broken".** When the artifact runs but produces bad output, the deliverable is the constraint list that fixes the output, which the user then approves — not a rebuild.
- **A staging copy of the schema is often in play alongside the production one**, and the automation may point at either. Confirm which object is authoritative before reading records, and say which one your findings came from.
- **Do not read only the most recent runtime messages.** The earliest messages after setup carry the original failure; the latest may be a hand-run test that hides it.
- **Do not report the user's own out-of-date spec as their current intent.** Legacy object and field codes in an old design document drift behind the live schema; check the mapping before concluding the automation points at the wrong object.

## Self-check

- Every finding names the artifact it came from — a message id, a record read, a deployment-status field — not an inference from configuration.
- The deployed version the user is actually running is identified by its deployment status, not assumed.
- Anything you could not verify is labelled unverified in the report.
- No fix was proposed before evidence at step 3 named which candidate version runs.
