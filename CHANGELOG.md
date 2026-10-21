# Changelog

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

## 2026-10-21 — 第二版

- **中英双语。** 每份技能现在有两个文件：`SKILL.md`（英文，给 AI 读）和 `SKILL.zh-CN.md`（中文，给人读）。
- **描述压短。** 五份都改成一句触发语，这样在会截断列表的平台上也能看清什么时候该用。
- **新增「坑」和「验收标准」。** 涉及平台行为的坑一律写成带条件的（"在你自己的平台上先验证"），不写成所有系统通用的硬规则。
- **两个技能改名。** `control-number-audit` → `control-number-audit-general`，`window-table-governance` → `window-table-governance-general`，避免与同名的业务专用版冲突。
- **README。** 改为中英双语，加了一张 Mermaid 关系图，说明五个技能怎么串起来。
- **许可证。** 加入 CC BY-NC 4.0（署名—非商业性使用）。

## 第一版

- 五份纯英文技能，只有流程部分。
