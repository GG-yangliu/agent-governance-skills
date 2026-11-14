# Changelog

## 2026-11-13 — v9

- **`knowledge-base-governance`: added a four-row table that maps each failure mode to its check.** The skill already carried two of the four checks inside its must-check lines (three-way comparison with a set difference; parsing both sides and comparing row by row). The two that were missing are the ones that fail silently: asserting on known positions instead of regexing "N items" out of the whole text, and reading the version line together with the change-log table so that a collision or a missing entry shows up.
- **Why a table and not two more must-check lines.** The four checks pair off against four distinct failures; as prose bullets the pairing disappears and a run has to work out which check covers which leak.
- **No new skills; still eleven.** One skill file pair changed, plus two README corrections found while checking the repository against itself: it said two skills ship an extra file where only one does, and the Chinese mnemonic counted the baseline twice (the chain is 2–9; skill 1 runs before and after any step).

## 2026-11-13 — v8

- **`skill-effectiveness-ab-test-general`: two fixes, both found by re-running it against its own rewritten text.** Four pressurised cases, base against with, scored 12/16 against 13/16 — three ties and one case won by a single item — so the rewrite had not removed the red lines. Both fixes come from what that run exposed, not from review.
- **"Do not fall back on 'it seems useful'" was read as "must pick a side".** Asked for one line the same evening, both conditions pronounced the whole library useless. The sentence now says plainly that it forbids inventing a verdict and does not demand one, and that with no comparison data the correct delivery is "cannot tell yet" plus the smallest test that would settle it.
- **The two run-validity checks moved out of Must-check into Workflow step 6.** Under a one-line demand both conditions dropped them: an empty `skills/` directory (wrong copy level) and unscanned read failures are the only things that catch a run which silently became a second baseline. They now sit on the step where the run happens; Must-check keeps the remaining items.
- **No new skills, no README change.** Nine of the eleven skill files are untouched.

## 2026-11-12 — v7

- **Added two skills: `windows-doubleclick-deliverables-general` and `external-agent-review-general`.** The first covers handing a result to someone who will never open a terminal: `.bat` encoding and line endings, results written to a file rather than the console, what a zero-basis readme must contain, and how to explain a tool the user cannot see. The second covers buying an independent second opinion: how to write a self-contained brief, two CLI forms that work non-interactively, the seven-section brief skeleton, and judging the returning points as accepted / discounted / rejected with the evidence.
- **Why these two and not the other three drafts:** the remaining candidates (container cost allocation, Chinese formal document typesetting, template-driven document generation) are industry procedures first and methods second; publishing them would widen the repository's scope without adding a transferable rule.
- **README: nine → eleven**, table and both diagrams updated, install section now names the extra helper script and states that it uses one product's print-mode flags.
- **Same constraints as v6:** every rule from the source drafts survives, measured numbers live in Examples, no local paths, no private skill names, no vendor lock-in beyond one clearly-labelled example command.

## 2026-11-12 — v6

- **Added three skills: `automation-diagnosis-general`, `business-rule-registry-general`, `skill-effectiveness-ab-test-general`.** The first six covered building, recording, verifying, speaking, preserving and measuring. They did not cover: what to do when a deployed automation stops matching reality (diagnose the layer before changing anything), how a rule lives across a registry, a text and a live model (change all of them together), and whether a skill changes model behaviour at all (A/B the skill itself).
- **Nothing was added to the documentation-governance family.** Five local drafts cover multi-copy consistency; only two of their points were not already in `knowledge-base-governance`, so those two went in as must-check lines — an independent second source, and a checker that had itself been tested. Publishing a sixth overlapping document skill would have restated one method five times, and the drafts disagreed with each other on how many classes of derivation exist (four in one, five in another) — a contradiction that merging would have carried into the public version.
- **`knowledge-base-governance`: two must-check items and two self-check items added** (three-way comparison; row-by-row instead of count-based; the checker's own self-test; agreements labelled as agreements, not as correctness).
- **README: six → nine**, table and both diagrams updated. `db-quality-baseline`'s description shortened from 75 to 53 characters so the trigger sentence is complete before an agent platform truncates it.
- **How the rewrites were constrained:** every rule sentence from the source drafts survives; measured numbers moved out of rule text into Examples; local paths, private skill names and helper-script references were removed or generalized; `scripts/run_ab.sh` ships with the A/B skill and takes the model CLI from `CLAUDE`.
- **Not published, deliberately:** two local skills are Windows/one-vendor operating manuals (hard-coded interpreter paths, credential handling for one mail host, one product's UI). They are procedures, not methods; publishing them would move the repository from "general governance" to "how one machine is set up".
- **Second pass, reviewing the live repository:** the 75→53 figure in this entry was wrong by three characters; a container-allocation worked example had leaked into the Workflow rules of `business-rule-registry-general` (now a rule plus one Examples line); three identifiers read like real business codes and were replaced; the A/B helper was described as vendor-neutral when it calls a model CLI in one product's print-mode flags — now stated plainly.

## 2026-11-05 — v5

- **Added a sixth skill: `db-quality-baseline`.** The existing five govern how work is done; none of them answers "how good is this store, really". This one measures it with reproducible read-only checks and produces a baseline to compare against later. It encodes the one thing the tests made obvious: control numbers prove two sources agree, not that either is right.
- **Added `templates/db-baseline-input.md`**, a five-field fill-in sheet (scope, core facts and their authoritative field, control numbers with both sides, business keys, who confirms). Without it the skill degrades into a questionnaire.
- **README (EN and ZH): five → six**, with the diagram gaining a measurement node that runs before the build and after every change.

## 2026-11-05 — v4

- **Trimmed prose, then rebalanced.** The trim took it to 23,944 bytes; the new Examples sections bring it to 28,983 — about the original size, but the padding is gone and what remains is rules, examples, pitfalls and a self-check.
- **Added "Must-check items"** to every skill: the dirt actually seen in production exports, written as generic rules with no embedded examples.
- **Added an "Examples" section** under each: illustrations only, drawn from several different domains (trade, CRM, retail, document stores), with an explicit note that examples do not bound the check.
- **Cross-file duplication removed.** The same check previously appeared verbatim in four files (status vs evidence, one entity spelled several ways). Each skill now states it from its own viewpoint — write surfaces, verification, output, document store — so loading a single file still gets the check.
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

## 2026-11-13 — 第九版

- **`knowledge-base-governance`：加了一张四行表，把四种漏法各配一种验法。** 其中两种原来已散在必查项里（三方比＋编号集合双向差集、解析成结构后逐行逐格比）；缺的是会静默失效的那两种——**对已知位置做断言，而不是全文正则抽「N 条」**；**页首版本行与变更记录表同时读**（撞号或漏记只有这样才看得见）。
- **为什么用表，而不是再加两条必查项。** 四种验法对应四种不同的漏法，写成散句时这个对应关系会丢，跑的时候还得自己判断「这条管的是哪种漏」。
- **不新增技能，仍是十一个。** 一对技能文件，外加两处 README 更正——都是拿仓库自己对着自己查出的事实错误：一是写着「有两份技能额外带文件」，实际只有一份；二是中文口诀把基线算了两遍（②到⑨才是链，①在两头横着用）。

## 2026-11-13 — 第八版

- **`skill-effectiveness-ab-test-general`：拿它自己的改写版做复跑，改出两处。** 四个加压案例、base 对 with，12/16 对 13/16——三平一胜、只差一项，说明改写没删掉红线；两处修订都来自这次复跑暴露的东西，不是来自评审。
- **「不要退化成『我觉得有用』」被读成了「必须选一边」。** 被要求「今晚给一句话」时，两种条件都直接判了技能库「没用」。现在写明：这句禁的是编结论，不是要结论；没有对照数据时，正确交付是「现在还判不了」＋一个能判出来的最小测法。
- **两条「这次跑到底有没有跑成」的检查，从必查项挪进工作流第 6 步。** 一旦被要一句话，两侧都把这两条丢了——`skills/` 空着（拷贝层级写错）、没扫读取失败的输出，恰恰是唯一能抓住「这次跑其实退化成了第二次基线」的两条。现在它们放在跑的那一步，必查项留其余几条。
- **不新增技能，README 不动。** 十一份技能文件里九份未改。

## 2026-11-12 — 第七版

- **新增两个技能：`windows-doubleclick-deliverables-general`、`external-agent-review-general`。** 前者管「把结果交给一个永远不开终端的人」：`.bat` 的编码与行尾、结果要落到文件而不是只打在黑窗口、零基础说明必须有的节、以及怎么解释一个用户看不见的工具。后者管「买一份独立第二意见」：简报怎么写到自包含、两种可非交互跑的 CLI 写法、七节简报骨架、以及拿回来的意见怎么判成成立／打折扣／不成立。
- **为什么只加这两个**：另外三份草稿（混装柜费用分摊、中文正式文书排版、按模板生成文档）首先是行业流程，其次才是方法；发出去会摊宽仓库范围，但不增加可迁移的规则。
- **README 中英同步：九个 → 十一个**，表格与两张关系图都改；安装节里点名那个额外脚本，并写明它用的是某一个产品的打印模式参数。
- **约束与 v6 相同**：源稿每条规则句都保留；实测数字只进示例；不出现本机路径与私有技能名；厂商绑定只出现在一处明确标注的示例命令里。

## 2026-11-12 — 第六版

- **新增三个技能：`automation-diagnosis-general`、`business-rule-registry-general`、`skill-effectiveness-ab-test-general`。** 原来六个覆盖了「建、录、验、说、存、测」，没覆盖三件事：部署好的自动化不好使时先定在哪一层出错；一条规则在登记册、文字和活模型之间怎么同步改；以及技能本身到底有没有改变模型行为。
- **文档治理那一族不加新技能。** 本地有 5 份草稿都在讲「同一事实多副本」，其中只有两点是已发布的 `knowledge-base-governance` 里没有的（独立第二来源、检查器要先自检），这两点补进了它的必查项与自检。发第六份重叠的文档技能，等于把同一个方法写五遍；而且这几份草稿彼此矛盾——一份写「四类派生」下面列了五条，另一份只有四条——合并会把这个矛盾原样带进对外版。
- **README 中英同步：六个 → 九个**，表格与两张关系图都改。`db-quality-baseline` 的描述从 75 字符压到 53，保证在被平台截断之前就是一句完整触发语。
- **改写的硬约束**：源稿里每一条规则句都保留；实测数字从规则正文移进「示例」；本机路径、私有技能名、找不到的脚本引用一律删除或改成占位；`scripts/run_ab.sh` 随 A/B 那份一起发布，模型命令行从 `CLAUDE` 取。
- **特意不发两份**：本地有两份是「某台 Windows 机器 + 某个厂商产品」的操作手册（写死解释器路径、某个邮箱的密码处理、某个产品的界面步骤）。它们写成的是流程，不是方法；发出去会把仓库从「通用治理」拖成「某一台机器怎么配」。
- **第二轮线上复核修掉四处**：本条目里「75 → 50」是错的（实际 53）；`business-rule-registry-general` 的 Workflow 里漏进了一段货柜分摊的实算细节（已改成一条规则 + 示例里一行）；三个标识符读起来像真实业务代码（已换成明显合成的值）；A/B 脚本被说成不绑厂商，实际用的是某一个产品的打印模式参数——已写明。

## 2026-11-05 — 第五版

- **新增第六个技能 `db-quality-baseline`。** 前五个管「怎么做事」，没有一个回答「这个库到底有多好」。它用可复跑的只读检查把质量量出来，形成可以事后对比的基线。它写进了测试里最明显的一条：控制数证明两个来源一致，证明不了其中任何一个是对的。
- **新增 `templates/db-baseline-input.md`**，五格填空表（范围、核心事实与权威字段、两侧独立的控制数、业务键、谁去确认）。没有这张表，技能会退化成问卷。
- **README 中英同步：五个 → 六个**，图上加了测量节点（动手前跑一次，每次改动后再跑一次）。

## 2026-11-05 — 第四版

- **按实测精简，然后重新平衡**：精简后 23,944 字节；加上新的「示例」节之后是 28,983，基本回到原版大小——但废话没了，剩下的是规则、示例、坑和自检。
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
