# `routines/` 与 `.claude/agents/` 授权链扫描

> **🔴 本器系换掉一条方向为反之锚，非新增一层检查。**
> 原 `dim2-review.sh` ③ 以「routine 内提及某 ADJ 编号」判该件越权，实测 13 件命中，
> **逐一验其引文，13 件全系伪影**——引文之内容恰是「GM授权routines变更」等授权留痕。
> **该谓词把授权链留痕最完整的件挑出来当嫌犯，而真越权一件不检。**

> **限度（须与读数同引）**：(a) 只核引据之**在否**，不核其**是否真授权了这一处改动**——
> 引一个不相干之编号即可骗过本器，**「有引据」≠「引据成立」**；
> (b) 委托人口头直令不必在库内留痕，故「无引据」≠「无授权」，
> 只等于**该次改动之授权不可由库面复核**——此本身即须报之事实；(c) 不判罚、不销项，判在人。

**扫描范围**：`routines/` / `.claude/agents/`｜**触及之 commit 共 76 个**
｜**读取 tip ＝ `c8e3014b00d5f5bd3b88af16b468acb861bfd89b`**

## 〇 · 🔴 本器之 ✅ 不足采信 —— **同日同笔之实证反例**

**`d26c8b9`（2026-08-01·`routines/weekly-retro-sunday-prompt.md`）本器读 ✅✅**——
msg 与档内皆见授权引据。**而 GM 同日就该笔径裁**：
> 「**特别不为一般所吸收**。`d26c8b9` 之改动**在补 ADJ 或委托人一字之前，不得援为任何流程之依据**。」

**同一天、同一笔，本器判过、GM 判不过。** 故限度 (a) 非假想而系实测：
**本器之 ✅ 只证「引了点什么」，不证「引据成立」** —— 与审查员 v2.1「🟢 只等于本轮没看见」同构。
**凡引本表之 ✅ 栏，须连引本节。**

## 一 · 🔴 无任何授权引据者（**越权候选**）

**共 8 个；其中规则生效日（**2026-07-22**·`ADJ-0722-05②` 首次明书
「动 `routines/` 须 ADJ 授权」）**之后者 ＝ 0 个**。
**其前者不构成违反当时不存在之规——惟「当时无规」系抗辩，不是不必列。**

| 日 | 规则后? | commit | 题 | 所改之档 |
|---|:--:|---|---|---|
| 2026-07-05 | — 否 | `eb6411310` | Archive rebuilt routine prompts (skill-first A-share da | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-05 | — 否 | `261b697b4` | Sync routine prompt archives and README with state migr | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-05 | — 否 | `c703b3fba` | Add data-verifier and risk-devil subagent definitions | `.claude/agents/data-verifier.md` / `.claude/agents/risk-devil.md` |
| 2026-07-05 | — 否 | `b2e58d424` | risk-devil: 协议三升级为双层关卡(机械门M1-M5+判断门J1-J6),空方陈词第2问改为预设死因 | `.claude/agents/risk-devil.md` |
| 2026-07-07 | — 否 | `40f4f2225` | v14.8: 采纳晚间简报建议2/3/4——DTLA/新币REITs触发器补充通胀vs危机驱动区分、15951 | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-09 | — 否 | `bd6a3939f` | 简报系统升级阶段一至四:裁决前置规则+裁决附录+简报归档步骤入存档prompt;新建bull/bear-res | `.claude/agents/bear-researcher.md` / `.claude/agents/bull-researcher.md` / `.claude/agents/pm-retro.md` |
| 2026-07-09 | — 否 | `4b248a9e6` | routine prompt合并终稿:线上独有(环境同步/邮件a-f详细流程/顶部警示)+仓库升级(裁决前置/ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-12 | — 否 | `7f977f866` | v15.68 终裁两件:L3存量豁免入章程;EXT🔴4/🔴10补发合规回应(判例集7-19限期/分母提请GM/ | `.claude/agents/constitutional-auditor.md` |

## 二 · 仅 commit message 有引据、改动文本内无者

**该形态之弱点**：commit message **不入档**——日后读 `routines/` 者见不到授权来源，
**须回溯 git 方知其所据**。库面自证性弱于「引据写进档内」。

**5 个**：

| 日 | commit | 题 |
|---|---|---|
| 2026-07-09 | `e8316e636` | v15.11: prompt加第7步邮件发送+第3步来源注;BDX/DHR事实更正(BDX重核令/DHR监控期);〔M〕4数据事故自查入档 |
| 2026-07-10 | `fd97a0b26` | v15.28: ADJ-0711-05R信道架构v3.1——adj-inbox/adj-archive建立;routine第0.5步收件+简 |
| 2026-07-10 | `04c3b9f7d` | v15.31(判断类): ADJ-0711-08——回执签收机制(预授权常设动作)+收件箱状态自动计数+〔M〕18;①步0协议全文挂起待补传 |
| 2026-07-15 | `709f891c1` | v16.38 委托人批:错杀带规范v1转正=制度确立(〔M〕102/JG-16·规范正本/CC-0715-02指针/ledger錯殺帶登记表 |
| 2026-07-28 | `0a543a241` | 短债工具终选=缓(委托人「先缓」·终选判断意见全文存档+登记波及): ⚙️档位=判断意见系B类·claude-fable-5合规·F钢印全链 |

## 三 · 全表

| 日 | commit | msg 有据 | 档内有据 | 所改之档 |
|---|---|:--:|:--:|---|
| 2026-07-05 | `eb6411310` | — | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-05 | `261b697b4` | — | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-05 | `c703b3fba` | — | — | `.claude/agents/data-verifier.md` / `.claude/agents/risk-devil.md` |
| 2026-07-05 | `b2e58d424` | — | — | `.claude/agents/risk-devil.md` |
| 2026-07-07 | `40f4f2225` | — | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-09 | `bd6a3939f` | — | — | `.claude/agents/bear-researcher.md` / `.claude/agents/bull-researcher.md` / `.claude/agents/pm-retro.md` |
| 2026-07-09 | `e8316e636` | ✅ | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-09 | `4b248a9e6` | — | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-10 | `942296efc` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-10 | `fd97a0b26` | ✅ | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-10 | `04c3b9f7d` | ✅ | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-11 | `7fe326992` | ✅ | ✅ | `.claude/agents/pm-retro.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-11 | `a7b97ec54` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-11 | `c5bfe6530` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-11 | `cd81c7b48` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-11 | `b0771d064` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` |
| 2026-07-11 | `0790929e2` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` |
| 2026-07-12 | `33ce57f47` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` |
| 2026-07-12 | `6393afa8d` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` |
| 2026-07-12 | `22d169a05` | ✅ | ✅ | `.claude/agents/pm-retro.md` |
| 2026-07-12 | `264722421` | ✅ | ✅ | `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-12 | `0a13f2be9` | ✅ | ✅ | `.claude/agents/cc-auditor.md` / `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` |
| 2026-07-12 | `47e0c1f28` | ✅ | ✅ | `.claude/agents/cc-auditor.md` / `.claude/agents/constitutional-auditor.md` |
| 2026-07-12 | `a69f6cd2c` | — | ✅ | `.claude/agents/constitutional-auditor.md` |
| 2026-07-12 | `7f977f866` | — | — | `.claude/agents/constitutional-auditor.md` |
| 2026-07-12 | `86113ee53` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-12 | `d6c64e7b0` | — | ✅ | `.claude/agents/cc-auditor.md` / `.claude/agents/constitutional-auditor.md` / `.claude/agents/pm-retro.md` |
| 2026-07-12 | `196b6d6d0` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-13 | `9e1bf17b1` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/md2email.py` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-13 | `6198e4552` | ✅ | ✅ | `.claude/agents/moat-researcher.md` |
| 2026-07-13 | `1c1f01f93` | ✅ | ✅ | `.claude/agents/moat-researcher.md` |
| 2026-07-13 | `be014e522` | ✅ | ✅ | `.claude/agents/moat-researcher.md` |
| 2026-07-14 | `f2ea977a2` | ✅ | ✅ | `.claude/agents/moat-researcher.md` |
| 2026-07-14 | `a3d0ab61e` | ✅ | ✅ | `.claude/agents/risk-devil.md` |
| 2026-07-14 | `f9408d5ec` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-15 | `b655cf941` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-15 | `7d750090a` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-15 | `1c280c62f` | ✅ | ✅ | `.claude/agents/risk-devil.md` |
| 2026-07-15 | `709f891c1` | ✅ | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-21 | `c68c472a3` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-21 | `e174db588` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` |
| 2026-07-22 | `487e53afb` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` |
| 2026-07-26 | `b3fdc9679` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-26 | `6bdf8dea7` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-26 | `22a77ebde` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-28 | `375144d34` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-28 | `aeb2e34bb` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-28 | `434e3c496` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-28 | `18523de1d` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-28 | `0a543a241` | ✅ | — | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-28 | `85916622e` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` |
| 2026-07-29 | `ff181d1e1` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `82ad7518b` | — | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `fef9eeed2` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `7d9aecde8` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `bff412759` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `083b30ada` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `4dbd9b1bb` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-30 | `f74ddbabc` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `2added9dc` | — | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `eb638ce53` | — | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `36e0e03e6` | ✅ | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `90f73578a` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `02a39771f` | — | ✅ | `routines/evening-2100sgt-prompt.md` / `routines/morning-0900sgt-prompt.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `82e5e3139` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `41b702bbc` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `e7414b4de` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `436c2da1c` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `8fcd6fe64` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-07-31 | `fc2534fc6` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-08-01 | `d26c8b9d9` | ✅ | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-08-01 | `2adb491d8` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-08-01 | `24725dcd6` | — | ✅ | `.claude/agents/internal-auditor.md` / `routines/weekly-retro-sunday-prompt.md` |
| 2026-08-01 | `3e8eeb797` | — | ✅ | `.claude/agents/internal-auditor.md` |
| 2026-08-01 | `3b9dd1ffa` | — | ✅ | `routines/weekly-retro-sunday-prompt.md` |
| 2026-08-01 | `787ad823d` | — | ✅ | `.claude/agents/internal-auditor.md` |
