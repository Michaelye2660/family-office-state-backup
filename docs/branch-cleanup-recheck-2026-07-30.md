# 远端分支清理·复核件（2026-07-30·委托人「如果之前没做过就做一遍」）

**判断前提**：全量两级取证**7-21 已做过**（〔M〕221·ADJ-0721-09／20 支 claude/* 逐支判定）→ 故本轮**不重做取证**，改做「复核＋增量取证」（既有结论之有效性验证＋新增对象补做）。删除自 7-21 起**始终未执行**（环境层 403），故清单仍待执行。

## 一、复核结果

| 项 | 结果 |
|---|---|
| 19 支白名单 tip sha 复核 | **18/19 与 7-21 定格值一致** → 7-21 两级取证结论仍有效 |
| tip 变动 1 支 | `claude/daily-briefing-branch-fix-nx47r5`：定格 `85c5faa` → 现 `9bd6075`（7-21 后又有提交·原结论失效） |
| 新增 1 支（7-21 后产生·未经取证） | `claude/modest-johnson-tr8noa` |
| shim | `claude/cgm-succession-handover-6f3vjr` tip `1df4c2e` **未变·护栏在位** |
| 现状 | 远端 22 支＝master ＋ 21 支 claude/* |

## 二、两支之增量两级取证（本轮新做）

| 分支 | 第一级 ancestry | 第二级文件核 | 判 |
|---|---|---|---|
| `claude/daily-briefing-branch-fix-nx47r5` @`9bd6075` | **tip 是 master 祖先** | `git diff master...` 零差异·`git log master..` 零提交 | **纯已合并·删＝零损失（git 数学保证）** |
| `claude/modest-johnson-tr8noa` | **tip 是 master 祖先** | 同上零差异零提交 | **纯已合并·删＝零损失** |

注：nx47r5 于 7-21 时属「图上未合并但内容等同」类，本轮已升格为「纯已合并」——比当时更安全。

## 三、可删清单（20 支·全部经取证零内容损失）

7-21 白名单 19 支（tip 未变 18 支照 7-21 结论·nx47r5 按本轮新证）＋ 新增 1 支：

| # | 分支 | tip（现值） | 依据 |
|---|---|---|---|
| 1 | claude/daily-briefing-branch-fix-nx47r5 | 9bd6075 | 本轮取证·纯已合并 |
| 2 | claude/dazzling-planck-k1byoz | a585542 | 7-21〔M〕221 |
| 3 | claude/focused-galileo-qgjsz0 | b030cee | 同上 |
| 4 | claude/focused-galileo-xj9nn8 | f576999 | 同上（**语言规则已于 7-21 恢复入 master**·内容已抢救） |
| 5 | claude/focused-galileo-z21i33 | 57a214a | 同上（master 版系有意替代） |
| 6 | claude/gracious-dirac-ob44jm | dafe284 | 同上 |
| 7 | claude/gracious-galileo-wbfjr6 | 6f91438 | 同上（retro 补记已于〔M〕57 并入·master 为超集） |
| 8 | claude/keen-heisenberg-t5i73q | d88b388 | 同上 |
| 9 | claude/laughing-mendel-5holr3 | c217b9f | 同上 |
| 10 | claude/laughing-mendel-j6hi1m | 57c6a25 | 同上 |
| 11 | claude/laughing-mendel-zshfe8 | 2823ce0 | 同上 |
| 12 | claude/modest-johnson-12qbef | 7284469 | 同上 |
| 13 | **claude/modest-johnson-tr8noa** | 77d4f08 | **本轮取证·纯已合并·新增件** |
| 14 | claude/pensive-pasteur-fva0cf | 47f7f73 | 7-21〔M〕221 |
| 15 | claude/pensive-pasteur-o5yemy | 29e12a1 | 同上 |
| 16 | claude/segment-two-live-testing-4nzrm9 | 2b7dfee | 同上 |
| 17 | claude/segment-two-live-testing-ohdbs5 | 3649a83 | 同上 |
| 18 | claude/segment-two-live-testing-swvnd2 | 1cf20c6 | 同上（master 版为后续定稿） |
| 19 | claude/setup-data-verifier-risk-devil-tjldo7 | b2e58d4 | 同上 |
| 20 | claude/vigilant-bohr-tnocb5 | 9105e37 | 同上 |

**防错三层保险照旧**：tip sha 已定格（任一支可原样重建）／两级取证钉死内容／master 与 shim 不在清单。

## 四、执行受阻（如实报·与 7-21 同族）

- `git push origin --delete` 实测 → **HTTP 403**（写入类 push 正常·删除类一律拒；本轮环境与 7-21 为不同容器，结论重现＝非偶发）；
- GitHub MCP 工具集复查 → 有 `create_branch`，**无删分支端点**（与 7-21 结论一致）；
- 结论：删除须**委托人 GitHub 网页端 branches 页执行**（https://github.com/Michaelye2660/family-office-state/branches），照上表逐支删。

## 五、shim 删除条件之现状取证（附带发现·候委托人确认）

`claude/cgm-succession-handover-6f3vjr` 之删除条件（ADJ-0721-09②·自验证无需另令）＝**委托人改环境源分支为 master 后，首次新会话成功从 master 供给**。

本会话取证：①工作区 `HEAD` ＝ `refs/heads/master`，与 `origin/master` 完全同步；②本会话全部工作（〔M〕386–392）直推 master 成功；③本会话指定分支 `claude/cgm-execution-setup-r2v2ye` **在远端不存在**（从未被用作供给源）。

→ **现象层面「从 master 供给成功」已成立**。但「环境源分支是否已改为 master」属委托人侧配置，CGM 无从核验，故**不自行判定条件满足、不动 shim**。**请委托人确认**：若环境源已改 master，则 shim 删除条件已满足，可与上表 20 支一并删（届时远端仅余 master）；若未改，shim 继续保留。

——复核与取证：[执行侧·CGM-G3]（claude-opus-5·临时档位），2026-07-30
