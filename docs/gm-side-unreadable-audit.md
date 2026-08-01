# GM 侧可读范围超限之现役操作依据 · 普查表（ADJ-0801-08⑦ 第二令）

> **令**（`-08⑦` 逐字）：「**并核全库尚有多少份被指定为操作依据而超出 GM 侧可读范围之文件，列表呈裁** —— **一次修一处，就会一直有下一处。**」

> **本表只出证据与实数，不裁任何一件该不该抽档** —— 抽哪几件、按什么次序，**属判断类，呈 GM**。

## 🔴 先报一处：**「GM 侧可读范围」之阈值从未定义**

本令以「超出 GM 侧可读范围」为判据，**而该范围之数值从未有裁定**。故本席**不自拟阈值**（自拟即是代裁），改出**实证边界**：

| 实证 | 件 | 字节 | 出处 |
|---|---|---:|---|
| **已实际读毕全文者之最大件** | `docs/succession/gm-succession.md` | 37,382 | E12 就位声明「载入集七项全文」 |
| **明确申报读不到／未读者之最小件** | `docs/moat/sell-trigger-spec-draft-v0.md` | 56,145 | `ADJ-0801-08` 未读申报 |

**故经验边界落在 37 KB（读过）与 56 KB（未读）之间；此系观测，不是阈值。** 立不立阈值、立在哪，**属判断类，呈 GM**。

**并附一条本仓已有之同型教训**：`-54⑥-b` 四 —— **「定上限不立检测，等于没定」**；**其反面同样成立：立了检测而无上限，测出来的数没有判读依据。**

---

## 候选表（现役·≥20,000 B·按字节降序）

| 件 | 字节 | 全库被引 | 何以系操作依据 | 状态 |
|---|---:|---:|---|---|
| `portfolio-state.md` | 1,704,239 | 283 | 台账正本·章程§二第③项指定 | 已解：`docs/state-core.md`（`-07⑦`） |
| `docs/moat/sell-trigger-spec-draft-v0.md` | 56,145 | 22 | 卖出触发器基底·§五／§5-A 系执行判据 | **本轮已解**：`docs/moat/sell-trigger-sec5.md`（`-08⑦`） |
| `docs/moat/moat-researcher-knowledge.md` | 59,458 | 41 | 护城河席操作手册 | **未解** |
| `docs/cc-knowledge.md` | 54,849 | 91 | 执行侧知识库·-58② 已移出载入集改按需 | **未解**（按需回读之路径同样受限） |
| `docs/predictions-ledger.md` | 0 | 44 | 预测台账·复盘与校准之依据 | **未解** |
| `docs/moat/mispricing-band-spec.md` | 31,826 | 14 | 错杀带规范·带值作业之判据 | **未解** |
| `docs/data-source-fallback-map.md` | 26,799 | 22 | 取数降级图·数据链之执行依据 | **未解**（本轮 `-08④` 又令写入此件） |
| `docs/moat/tech-mdg-framework.md` | 21,786 | 16 | 科技域 MDG 尺 | **未解** |
| `docs/ledger-archive-M001-M200.md` | 335,633 | 8 | 台账归档卷 | **未解** |
| `docs/tracking-table-2026-07-31.md` | 21,441 | 12 | 追踪表·销项依据 | **未解** |

**已解 2 件／未解 8 件**（本表只列「被指定为操作依据」者；纯报告、纯归档、EXT 回程件不入表——**其不入表系因不构成执行依据，不是因为小**）。

## 全库 ≥20,000 B 之现役 md 档（**不筛选·供 GM 自核本表有无漏列**）

| 件 | 字节 | 全库被引 |
|---|---:|---:|
| `portfolio-state.md` | 1,704,239 | 283 |
| `docs/ledger-archive-M001-M200.md` | 335,633 | 8 |
| `docs/moat-reports/GOOGL-2026-07-23-seats.md` | 125,451 | 1 |
| `predictions-ledger.md` | 120,751 | 44 |
| `docs/moat-reports/ISRG-2026-07-23-seats.md` | 105,458 | 2 |
| `docs/moat-reports/IDXX-2026-07-24-seats.md` | 73,259 | 0 |
| `docs/moat-reports/CPRT-2026-07-20-deepdive.md` | 72,777 | 8 |
| `docs/state-core.md` | 63,514 | 12 |
| `docs/moat/moat-researcher-knowledge.md` | 59,458 | 41 |
| `docs/moat/sell-trigger-spec-draft-v0.md` | 56,145 | 22 |
| `docs/cc-knowledge.md` | 54,849 | 91 |
| `docs/ext/DR-20260728-02-report.md` | 54,479 | 1 |
| `docs/ext/relay-manifest.md` | 49,320 | 4 |
| `docs/moat-reports/watchlist-2026-07-19-scan-batch3.md` | 48,579 | 6 |
| `docs/moat-reports/GOOGL-2026-07-24-band-adversarial.md` | 46,528 | 3 |
| `docs/moat-reports/watchlist-2026-07-19-scan-batch4.md` | 45,401 | 2 |
| `docs/moat-reports/MDT-2026-07-15-seats.md` | 43,344 | 2 |
| `docs/ext/DR-20260728-05-report.md` | 40,364 | 3 |
| `docs/ext/core-equity-instrument-review-report.md` | 38,916 | 3 |
| `docs/succession/gm-succession.md` | 37,382 | 179 |
| `docs/ext/liquidity-sleeve-instrument-review-report.md` | 36,957 | 6 |
| `docs/ext/core-allocation-review-report.md` | 36,916 | 3 |
| `docs/ext/DR-20260728-03-report.md` | 36,216 | 2 |
| `routines/evening-2100sgt-prompt.md` | 34,408 | 13 |
| `docs/moat-reports/TMO-2026-07-26-band-rewrite-step1-bear.md` | 34,013 | 4 |
| `docs/external-audits/2026-07-12-EXT-02.md` | 32,970 | 3 |
| `docs/ext/EXT-12a-crossmodel-replication.md` | 32,352 | 1 |
| `docs/moat/mispricing-band-spec.md` | 31,826 | 14 |
| `routines/morning-0900sgt-prompt.md` | 31,779 | 10 |
| `docs/external-audits/2026-07-14-EXT-03.md` | 31,777 | 4 |
| `docs/ext/core-allocation-redteam-report.md` | 31,400 | 6 |
| `docs/ext/blindtest-design-review-report.md` | 30,892 | 4 |
| `docs/moat-reports/MCD-2026-07-18-deepdive.md` | 30,749 | 6 |
| `docs/constitution.md` | 30,046 | 145 |
| `docs/adjudicator-knowledge.md` | 29,944 | 117 |
| `docs/moat-reports/TMO-2026-07-15-seats.md` | 29,029 | 1 |
| `docs/moat-reports/DHR-2026-07-21-seats.md` | 28,429 | 5 |
| `routines/weekly-retro-sunday-prompt.md` | 28,116 | 36 |
| `docs/ext/EXT-08-report.md` | 27,598 | 7 |
| `docs/ext/DR-20260728-04-report.md` | 27,118 | 3 |
| `docs/ext/EXT-07-report.md` | 26,921 | 7 |
| `docs/moat/sweep-01/mechanical-leg-2026-07-30.md` | 26,845 | 2 |
| `docs/data-source-fallback-map.md` | 26,799 | 22 |
| `docs/ext/EXT-04-report.md` | 25,989 | 15 |
| `docs/ext/DR-20260728-01-report.md` | 25,314 | 3 |
| `docs/ext/gate-drift-review-report.md` | 24,777 | 3 |
| `docs/project-instructions-PASTE-2026-07-30.md` | 24,466 | 3 |
| `docs/ext/EXT-10-report-stage2.md` | 24,260 | 1 |
| `docs/ext/tech-mdg-ruler-review-report.md` | 23,860 | 4 |
| `docs/moat-reports/CPRT-2026-07-20-supplement-a.md` | 23,562 | 4 |
| `docs/moat-reports/watchlist-2026-07-18-scan-batch2.md` | 23,447 | 9 |
| `docs/ext/EXT-11-report-stage1.md` | 21,951 | 2 |
| `docs/moat/tech-mdg-framework.md` | 21,786 | 16 |
| `docs/ext/sell-discipline-review-report.md` | 21,767 | 6 |
| `docs/tracking-table-2026-07-31.md` | 21,441 | 12 |
| `docs/extraction-table-2026-07-31.md` | 21,289 | 4 |
| `docs/external-audits/2026-07-12-EXT-01.md` | 21,180 | 5 |
| `docs/ext/defensive-sleeve-review-report.md` | 21,003 | 2 |
| `docs/moat-reports/CPRT-2026-07-21-jury-v3.md` | 20,524 | 4 |
| `docs/succession/E10-declaration.md` | 20,496 | 5 |
| `docs/moat-reports/CPRT-2026-07-21-jury-v2.md` | 20,355 | 5 |
| `docs/gm-snapshot.md` | 20,225 | 76 |
| `docs/moat-reports/NVO-2026-07-15-seats.md` | 20,207 | 0 |
| `docs/succession/E12-declaration.md` | 20,187 | 6 |

**共 64 件。** 本表系机械枚举，**未加任何筛选**——**列在这里不等于它是操作依据，不列在候选表也不等于它不是**；**上表之归类系本席之判读，可被推翻。**

——`[执行侧·CGM]`，2026-08-01·SGT，依 `ADJ-0801-08⑦` 第二令
