# Changelog

## 2026-11-05 — v4

- **Trimmed by 19% (total 29,251 → 23,944 bytes).** Prose that four rounds of A/B testing never changed behaviour was cut; the judgments that did matter were kept verbatim (no fabrication, state what you did not check, never decide for the business owner, independent recount, one authoritative source / one write path, read back after writing).
- **Added "Must-check items"** to every skill: the dirt actually seen in production exports, written as a generic rule followed by one bracketed example from a single domain (trade, logistics, CRM, retail) — so the rule transfers and the example stays concrete. Replace the example with your own.
- **Added a three-line "Self-check"** so a run can be ticked off without re-reading the workflow.
- **Why:** in the tests, loaded vs not loaded scored the same on correctness (19/20 vs 20/20, 13/14 vs 14/14, 15/16 vs 16/16 dirty-point recall). The one reproducible difference was traceability: citing the source, stating what was not checked, saying who must confirm. So the skills are now written for that, and shortened so the traceability rules are not buried.

## 2026-11-05 — v3

- **License changed to MIT.** Replaced CC BY-NC 4.0. The skills can now be used, copied, modified, and redistributed without restriction, including in commercial work; only the copyright notice must stay.
- **Repository address changed.** Now published at `GG-yangliu/agent-governance-skills`. Old links redirect automatically.

## 2026-10-21 — v2

- **Bilingual editions.** Every skill now ships `SKILL.md` (English, for the agent) and `SKILL.zh-CN.md` (Chinese, for humans).
- **Shorter descriptions.** All five are now a single trigger sentence, so they stay readable when an agent platform truncates the list.
- **Pitfalls and acceptance checks added.** Each skill gained a "Pitfalls" section and an "Acceptance checks" section. Platform-specific behaviour is written conditionally ("verify on your platform"), never as a universal rule.
- **Two skills renamed.** `control-number-audit` → `control-number-audit-general`, `window-table-governance` → `window-table-governance-general`, so they can coexist with same-named business-specific editions without colliding.
- **README.** Now bilingual, with a Mermaid relationship diagram showing how the five skills connect.
- **License.** Added CC BY-NC 4.0 (Attribution–NonCommercial).

## v1

- Five English-only skills, workflow sections only.

---

# 修订记录

## 2026-11-05 — 第四版

- **按实测精简 19%**（合计 29,251 → 23,944 字节）。四轮对照测试里从没改变过行为的论述删掉；真正起作用的那几条原样保留（不许编造、声明未查范围、不替业务方拍板、独立复算、唯一权威源/唯一写入口、改后读回）。
- **每份新增「必查项」**：都是生产导出里真见过的脏点——重复行（完全重复、只差一个标识）、数字列里的「约20」「20台」「—」和空、单位和含税口径混用、0 与字母 O 撞号、日期多种格式、状态多种写法、状态与凭证矛盾。
- **每份新增三行「自检」**，跑完可以直接打勾，不必回头再读流程。
- **为什么**：测试里装与不装在正确率上打平（19/20 对 20/20、13/14 对 14/14、脏点识别 15/16 对 16/16），唯一稳定复现的差异是「可追溯性」——写清依据、写清没查什么、写清谁去确认。所以技能改成服务于这件事，并压短，免得这几条被埋掉。

## 2026-11-05 — 第三版

- **许可证改为 MIT。** 从 CC BY-NC 4.0 换过来：可以自由使用、复制、修改、再分发，包括商业用途，只需保留版权声明。
- **仓库地址变更。** 现在在 `GG-yangliu/agent-governance-skills`，旧链接会自动跳转。

## 2026-10-21 — 第二版

- **中英双语。** 每份技能现在有两个文件：`SKILL.md`（英文，给 AI 读）和 `SKILL.zh-CN.md`（中文，给人读）。
- **描述压短。** 五份都改成一句触发语，这样在会截断列表的平台上也能看清什么时候该用。
- **新增「坑」和「验收标准」。** 涉及平台行为的坑一律写成带条件的（"在你自己的平台上先验证"），不写成所有系统通用的硬规则。
- **两个技能改名。** `control-number-audit` → `control-number-audit-general`，`window-table-governance` → `window-table-governance-general`，避免与同名的业务专用版冲突。
- **README。** 改为中英双语，加了一张 Mermaid 关系图，说明五个技能怎么串起来。
- **许可证。** 加入 CC BY-NC 4.0（署名—非商业性使用）。

## 第一版

- 五份纯英文技能，只有流程部分。
