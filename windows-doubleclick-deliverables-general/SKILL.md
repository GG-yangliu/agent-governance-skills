---
name: windows-doubleclick-deliverables-general
description: "Use when a non-CLI user needs a double-click tool."
---

# Double-Click Deliverables for Non-CLI Users (Windows)

For a user who will not read a command line but needs "I double-click it and it runs": a read-only reconciliation, a refresh, a report.
The deliverable is **script + template/config + result file + a plain-language guide**, finished only after you have run it live.

## Workflow

1. **Settle three decisions before building.** (a) Location: a business folder the user can find and back up, never a system temp directory — script, template, result file and guide in one folder. (b) Reach: read-only by default; a real write is a separate entry that states what it changes. (c) Schedule: the user's call. "You always have to remind me" is a complaint, not approval — ship manual double-click plus a result file, then propose scheduling and wait for a yes. A scheduled run that must notify has to deliver to a channel the gateway reaches; a local session never receives it.
2. **Keep the .bat at one job per line:** find python → call python → `pause`. All prompts, masked input and conclusions live in Python (3.6+ writes through `WriteConsoleW`, so they render under any code page).
3. **Locate by the file, not by the caller.** `pushd "%~dp0"` sets the directory and `"%~dp0tool.py"` names the script, so the folder can be moved anywhere. Resolve python to an absolute path with a three-level fallback — `<venv-python>`, then the office suite's bundled interpreter (`<office-suite>\program\python.exe`), then `python` on PATH. Never assume PATH has python: in a plain cmd `where python` returns nothing, the bat exits on line one and the window only flashes.
4. **Tee results to a file from inside Python** — real stdout plus the result file, appending, with a timestamp and the command as each run's first line — and **make exit codes honest**: a run that ends "not writable" returns 1 so the bat can branch.
5. **Write the guide, check the bat, read the result back, then teach the first open** (below). Verification is part of delivery; leave the user a read-only entry for whenever they doubt a number.

## Must-check items

Run these before calling anything delivered. Examples illustrate; they do not limit what you check.

`.bat`, byte level:

- **Pre-flight with a machine, not your eyes:** no byte above 127, every line ends CRLF, no multi-line parenthesized block, and the interpreter it names really exists — fail loudly (exit 1) if any check fails.
- **CRLF on every line.** A pure-LF file makes cmd split a Chinese `echo` and report "is not recognized as an internal or external command", then run the tail as a command; it also makes `cd /d "<dir>"` fail silently, so the child runs from the caller's cwd and python reports it cannot open the file. Count `data.count(b"\r\n")` against the line count before suspecting anything else: `p.write_bytes(text.replace("\n","\r\n").encode("utf-8"))`.
- **No byte above 127** in a bat you call "English-only": assert `sum(1 for b in open(p,'rb').read() if b>127) == 0`. cmd reads a batch file by byte offset, so one multibyte character shifts everything after it into fragments like `fined`, `defined`, `]`, and python receives half an argument (`setpass` arrives as `set`).
- **Prefer zero Chinese in the .bat** — three lines are enough, and keep every `echo` line free of full-width brackets or stacked colons (explain in short sentences). The observed failure: double-click, type the password, press Enter, the window disappears; the user says "it crashed" while the script simply reached its end. Anything vanishing before the "press any key" line is a bat encoding or layout problem, not business logic. Never assemble Chinese arguments on the command line either — pass them through a UTF-8 file with `@./args.json` or `@./args.md`.
- **If Chinese must stay in the .bat**, on a Chinese Windows (cp936) write GBK — `text.encode("cp936")` with `chcp 936` — and read output back with `iconv -f cp936 -t utf-8`. UTF-8 with `chcp 65001` splits one Chinese `echo` line and reports `'xx' is not recognized` while the rest look fine. Chinese `echo` + `chcp 936` + CRLF + all single lines (including `for /f` picking the newest file and `start "" notepad`) works; the cost is a console pinned to 936, so the python child needs `PYTHONIOENCODING=gbk` or its screen output is mojibake while the file itself is correct.
- **No parenthesized blocks.** `if not defined X ( ... )` or `if errorlevel 1 ( ... pause ... )` plus any other defect makes cmd read the block out of position and execute later lines as commands. Use consecutive single-line assignments; two extra lines beat the bug.

```bat
@echo off
cd /d "%~dp0"
set "PYEXE=<venv-python>"
if not exist "%PYEXE%" set "PYEXE=<office-suite>\program\python.exe"
if not exist "%PYEXE%" set "PYEXE=python"
"%PYEXE%" "%~dp0tool.py"
pause
```

- **Rebuild a .bat, never patch it byte-wise.** Paths containing `\02`, `\10`, `\0` are read as octal escapes: `<drive>\02-project` lands as `<drive>\x02-project`, `backup_all.py` as `\x08ackup_all.py`; the file exists, the script is missing, and the next patch "finds and replaces" again, making it worse. Rewrite the whole file (`"\r\n".join(lines).encode("utf-8")` + `write_bytes`), assert a sentinel (`b"backup_all.py" in data`), decode it back. Path literals are raw strings — in normal strings `\releases`, `\0_tools`, `\AI` become escapes, so `releases` lands as `eleases` or the line breaks in two; the patch tool interprets `\r` too, so read the line back after every edit.

Secrets the user types once — never asked for in chat, never stored in plaintext:

- **Preferred:** `ctypes` calling Windows DPAPI (`CryptProtectData` / `CryptUnprotectData`) plus `getpass` — no PowerShell quoting, no Chinese arguments, no code-page traps. Only if PowerShell is unavoidable: `Read-Host -AsSecureString` (no echo) then `ConvertFrom-SecureString` to a file — DPAPI, decryptable only by that user on that machine; the prompt must say "nothing shows while you type — that is normal" or the user thinks the keyboard died.
- **Keep the PowerShell fragment pure ASCII.** Chinese through cmd → powershell breaks at the code page (even `ConvertFrom-SecureString` fails argument binding). Chinese belongs in the bat's `echo` lines; the `Read-Host` prompt is `Password (hidden): `. A `.ps1` holding Chinese must be saved UTF-8 with BOM and run with `-File`; without the BOM it is read as ANSI and fails like a type error.
- **Round-trip test, then `.Trim()` before decrypting.** `ConvertFrom-SecureString` accepts only a SecureString, so a plain string gives `InputObjectNotBound`: use `ConvertTo-SecureString 'x' -AsPlainText -Force | ConvertFrom-SecureString | Set-Content $f -Encoding ASCII`. Read with `(Get-Content -Raw $f).Trim() | ConvertFrom-SecureString` — the trailing newline otherwise reports "the input string is not in the correct format"; plaintext via `[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s))`.
- **Read the child with `subprocess.run(..., capture_output=True)`** and `decode('utf-8','replace')`, falling back to `mbcs`; `text=True` raises `UnicodeDecodeError` on a Chinese Windows because stderr is cp936. **`ConvertFrom-SecureString` writes UTF-16LE hex** — decoded as UTF-8 it yields double length with `\x00` (a 17-character password reads back as "34"); try utf-8 then utf-16-le and keep the one without `\x00`, and since one file may hold either a binary DPAPI block or hex, try binary first, then `bytes.fromhex()`.
- **`getpass` only behaves in a real console**; with stdin redirected (pipe, test harness) it blocks and looks like a hang. Keep a stdin hook behind an env flag for tests; a real double-click uses `getpass`.
- **No credential yet → give the next step, not an error:** "No password set yet. Double-click: <set-password.bat>." **Changed account or user → delete the old credential first**: the same file never expires, the new account authenticates with the old password, the error reads exactly like "wrong password" and you circle it for rounds. Sequence: edit account/address → delete credential → double-click set-password → double-click verify.
- **Layer an auth failure before touching the password.** Does the web login work? Web yes, every protocol refused on its own port, password shape normal → the block is client credentials (app password, domain policy) and a reset changes nothing; the fast route is a new account or an app-specific password. **Verify on a ladder that needs no real password:** port reachable → fake value round-trip → one real auth with a fake password, where "authentication failed" proves the whole chain and only the password is missing; delete the fake credential afterwards.

Write-capable entries, always two steps:

1. **Step one only rehearses:** every validation runs, "will write N rows / M exist / K batches" plus one verdict line (`[WRITABLE]` / `[NOT WRITABLE]`).
2. **Step two stops and requires the user to type a word** (e.g. `CONFIRM`) before `--commit`; anything else aborts with zero rows written. Stronger than `y/n`: a stray Enter writes nothing, and the step visibly means "this writes".
3. **Exit codes stay honest:** "not writable" returns 1, the bat branches with `if errorlevel 1 goto notok`. A script that always returns 0 leaves the bat unable to tell "finished" from "blocked", and the user is told "it wrote" when nothing was written.
4. **Every run writes a report; the real-write one carries every record_id** — the rollback basis and the proof of what changed. record_ids printed only to the window do not exist.
5. **Two or three entries, uniform names** (`doubleclick_<action>.bat`): check (read-only) / batch write (two steps) / single record. Past three, the user starts guessing.

Result must land in a file:

- **One Enter closes the window and everything on screen is gone** — the most common complaint. Tee in Python; a bat `> file` redirect is worse because it also swallows the masked-input prompt and leaves the user facing a blank window. A log that ends with a timestamp header and no conclusion line means the child's output was never connected: `type` the log at the end and require the conclusion line (counts, verdict), a bare header being a failure — fix it with the tee, not `>>file 2>&1` in the bat.
- **Append, never overwrite**, with a timestamp and the command at the top of each run, so a later session can tell which run produced what. **Put the result directory in `.gitignore`**: one report per double-click turns `git status` in a business repo into noise and buries the list of what actually changed — the reports stay on disk, just out of version control.
- **The failure branch needs the real stderr.** `echo Failed: maybe offline` with no traceback leaves the user nothing to report and you nothing to debug. Write `"%PY%" tool.py 2>"%TEMP%\tool_err.txt"`, and on `errorlevel 1` `type` it and append it to the result log. Watch the `if not exist "%PY%" set "PY=python"` fallback: it can land on the WindowsApps stub python, which exits non-zero with no output at all.
- **Two lines of console text, both mandatory:** at the start, "the final 'press any key to continue' is there so you can read; pressing Enter closes it and that is a normal finish"; at the end, "closing the window does not affect the result — next time just double-click the latest result file". Then **write the result as a small human table plus one sentence** ("all 4 orders complete, none missing"), not `TODO_COUNT=0`.

Guide required sections (`usage*.md`): what this is / which file to double-click / what you will see / what it will **not** do (red lines) / what to do on an error and who gets the screenshot / **where commands are typed** (which folder, and the exact right-click entry that opens a terminal there) / where this folder lives / change log. "Where do I type a command" is mandatory even if the user never types one. Add **"how it prevents mistakes"** in 3–5 plain sentences: the scope of a change (one block replaced, or read-only), what is checked before and after (occurrence counts, read-back, line-by-line compare), where the trail is (log, report folder) — that question weeks later means the handover never explained the mechanism.

Explaining a tool the user cannot see (commits, background jobs, schedulers) — three things, not theory:

1. **Who triggers it, and when.** Never "automation is in place": that sounds like the machine notices changes by itself. Write: there is no resident watcher, I run it after editing, you do not handle this step.
2. **Where to look.** A read-only double-click entry that turns the CLI into a plain text file: `status/log/diff` → "changes not yet saved (added/modified/deleted) / last N saves with time and note / size of the change per file", also written to `output\`. Read-only entries may be clicked freely; write, revert and delete never get a button.
3. **The user's relationship to "the thing in the command line".** One sentence: the command is the manual gearbox, the double-click entry is the automatic, the engine is the same executable (give the version).
- Also mandatory: **red lines in their own section** (`reset` / `checkout` / `clean`, overwrite, delete — each "do not type this yourself, ask me", plus "unsaved changes vanish immediately"), and **it is not a backup** (a local repository is not an off-machine copy; that is a separate arrangement). Keep the file beside the other plain-language guides.

Persistent terminal UI (tmux-like) deliverables, two additions:

- Do not launch the executable directly in the bat; use `start "" wt.exe -w -1 new-tab --title "X" -d "<start-dir>" "<exe>"`. Windows Terminal keeps text, zoom and mouse rendering right; the legacy console garbles glyphs and drops mouse events.
- Add a desktop `.lnk` to the `.bat` (PowerShell `WScript.Shell.CreateShortcut`, `IconLocation` = the exe, `WorkingDirectory` = the script folder); a Chinese name goes into a UTF-8-with-BOM `.ps1` run with `-File`, never through `-Command`.
- Verify with `MSYS_NO_PATHCONV=1 cmd /c "x.bat"`, then a PowerShell `CopyFromScreen` screenshot you actually look at — a TUI cannot be judged by exit code.

Editing a tool already delivered:

- **Copy the old version before touching the file.** These folders are not git repos and a `write_file` overwrite is unrecoverable (`.pyc` will not give it back): `_backup/<script>_v<n>_<date>.py`, and state in the guide "v1 is merged into v2". **Then run it once for real** — lint is not evidence. Read the newest result file's conclusion line, then the table; when a first run shows one failure row, suspect your own filter or direction logic before the data.
- **Column names must not follow the data.** Headers built from `rows[0].keys()` raise `KeyError` the moment names vary by row (one row `total expense`, the next `total income`). Put the dimension in its own fixed column (`direction`: expense / income).
- **Anything inferred is labeled "candidate cause (unconfirmed)"** — e.g. "suspected FX difference: this contract's flows are all foreign currency; at the accounting rate the total differs from the contract value; finance must confirm it is FX, not unpaid". The verdict column still says "unexplained difference"; a tool that pronounces judgement turns an inference into a fact.

Teaching the first open — the "I don't know how to use it" moment is a fixed step, not an accident:

- **Read the real screen before speaking**: a screenshot, or the platform's own status call, and say what is on that screen. Narrating the document is useless; the user can only follow their own screen. **Three actions, plus one sentence: "this looks broken and is normal"** — an empty pane or bare prompt is the most common false alarm. **For persistent tools, say plainly that closing the window does not stop the process** — an unattended process burns quota, the fastest way to make a user angry.
- **Put onboarding at the top of the same `usage*.md`** ("three minutes to start"), not a second document, and send only a short message, never a long manual. **Demonstrate in their window** with a live instance (split a pane, start one worker) and talk over it — but never make a safety decision for them (trusted folder, authorization, login).

## Examples

Illustrations only — swap in your own domain's files, names and numbers.

- Trade: `doubleclick_check_orders.bat` writes `2026-11-12 09:14 | 18 orders | 2 short | others complete` into the latest result file, appended under a timestamp header — no field only a machine can read.
- Logistics: a read-only entry listing "containers not yet loaded (added/modified/deleted)" with an `output\` copy, and no button that writes.
- CRM: a two-step write entry printing `will write 42 / 380 existing / 3 batches` and `[WRITABLE]`, then demanding the word `CONFIRM`; the report keeps every record id.
- Retail: a bat of three lines (`pushd`, call python, `pause`) with every prompt inside Python, so nothing depends on the console code page; any domain, the simulation below — Chinese filename copied to an ASCII name, never generated with `sed`:

```python
shutil.copy("check_tool.bat", "_t.bat")
r = subprocess.run(["cmd", "/c", "_t.bat"], capture_output=True, text=True, encoding="utf-8", errors="replace", input="\n")
```

## Pitfalls

- **UTF-8 + `chcp 65001` on a Chinese Windows**: one Chinese `echo` gets split, `']' is not recognized` appears while the others print, and the tool looks flaky. GBK + CRLF instead.
- **An LF-only file**, or **a single multibyte byte** in an otherwise English bat: `cd /d` silently does nothing, the read offsets shift, and python "cannot open the file" — it reads like a wrong path, not a line-ending bug.
- **A parenthesized block plus one other defect** turns the block into commands, the same damage as a shifted byte offset. **`cmd //c` from git-bash** often opens an interactive cmd, drops the arguments and prints only the banner, and a Chinese filename may not match; drive the bat from Python with an ASCII copy, and never build that copy with `sed` (it converts CRLF to LF and reproduces the exact symptoms).
- **A bat that always exits 0, a scheduler status of "ok", a python stub on the WindowsApps path**: all three report success while nothing ran. Judge by the conclusion line in the result log, not by status.
- **Piped output as evidence**: GBK bat output and UTF-8 python output in one pipe is always garbled, and `iconv` decodes only half. Use exit code, artifact existence, and the verdict inside the artifact.
- **A tee replaced by `>`** swallows the masked prompt; **a log with only a header** looks like a record and proves nothing.
- **Credential plumbing**: `text=True` or UTF-8 decoding of PowerShell output raises or doubles the length; `ConvertFrom-SecureString` on a plain string fails binding; a credential left behind after an account change reproduces "wrong password"; `getpass` under redirected stdin hangs and a hang reaches you as "it froze".
- **Byte-level path patching** (`\02`, `\0`, `\10`) silently rewrites the path and "succeeds" on the next attempt too; **column names derived from row 0** break the day one table mixes two kinds of row.

## Self-check

- The bat was rebuilt rather than patched: CRLF throughout, no byte above 127, no parenthesized block, and the interpreter it names exists.
- I simulated the double-click by running the bat from Python, got exit 0, and saw the conclusion line and the trailing "press any key".
- The result file exists, carries today's date, appends rather than overwrites, and reads as a table plus one sentence.
- No secret appears in chat, in the bat, or in a plaintext file; the credential is DPAPI-protected and the fake one is deleted. A write entry shows a rehearsal verdict and needs a typed word, exiting non-zero when it refuses.
- The guide has every section, including "where commands are typed" and "how it prevents mistakes", red lines on their own page; after any move I grepped the old paths — including the scheduler wrapper that hard-codes the bat — and re-ran it, in script, bat, README, guide and every document that cites them.
- The first open was taught from the user's actual screen: three actions, plus "it looks broken and is normal".
