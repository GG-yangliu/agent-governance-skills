# 体检填空表 · Baseline input sheet

用之前只填这五格。填不出来的一格就写「不知道 + 为什么」，不要留空、不要猜。
Fill only these five. If you cannot fill one, write "unknown + why" — never leave it blank, never guess.

---

## 1. 库与范围 / Store and scope

- 库名称与位置 / Store:
- 表清单（表名 × 记录数）/ Tables and record counts:
- 谁负责 / Owner:
- 这次是只读吗 / Read-only this run: 是 / yes

## 2. 核心事实与权威字段 / Core facts and their authoritative field

一行一个事实。一个事实只许一个权威字段。

| 事实 / Fact | 权威 表.字段 / Authoritative table.field | 还有哪里手打 / Other hand-typed locations | 谁在写 / Who writes it |
|---|---|---|---|
| 例：合同数量 | 例：C01.合同数量 | 例：C02.约定数量、H01.计划台数 | 例：业务A |
| | | | |

## 3. 控制数定义 / Control numbers

每条必须两侧独立、容差写明、差不为零意味着什么写清楚。**只写一侧的不算控制数。**

| # | 名称 / Name | 来源 A（权威）/ Source A | 来源 B（独立复算）/ Source B | 容差 / Tolerance | 差不为零说明什么 / What a difference means |
|---|---|---|---|---|---|
| 1 | 例：合同数量 vs 实发 | C01.合同数量 | 明细行逐行加总 | 0 | 少发、超发或漏录，必须逐条解释 |
| 2 | | | | | |

## 4. 唯一键 / Business keys

哪几个字段组合起来必须唯一（合同号、批次号、单号……）：

- 
- 

## 5. 谁去确认 / Who must confirm

| 事项 / Issue | 找谁 / Owner to ask |
|---|---|
| 例：数量口径冲突 | 例：业务负责人 |
| | |

---

## 交回之前自检 / Self-check before returning

- 第 2 节每个事实只有一个权威字段；有两个的都标出来了。
- 第 3 节每条都有两侧来源，没有一条是同源。
- 每格都填了字：要么是内容，要么是「不知道 + 为什么」。
