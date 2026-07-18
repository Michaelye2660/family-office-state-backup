# 脚本完整性硬化规则（即行）· ADJ-0718-03⑤c

> **【GM 结案更新·ADJ-0718-06③·2026-07-18】** 完整性事件**降级结案**：取证结论采认（并发竞争碰撞·非入侵·batch1 数据 raw 重算零污染·vendored 未受影响）。**根治令**=规则二（worker 独立 scratchpad 目录）**入扫描SOP**（已落 moat 工作指引 v1.9 §五）；规则一（vendored sha256 对表）**保留为卫生层**（成本近零·对真篡改仍有效）；隔离存证保留；**净室加固深案不再需要**（不升重制度）。以下两规则维持有效。

> 两条规则并立·**分属两个威胁模型**。规则一=GM ADJ-0718-03⑤c 即行令（vendored 文件被动）；规则二=本次事件根因对症（scratchpad 并发碰撞）。**均即行**（净室加固深案经 ADJ-0718-06③ 评估=不需要·结案）。

## 规则一（GM 令·即行）：vendored 脚本运行前 sha256 对表
- **适用对象**：一切 **vendored 计算脚本**（`vendor/ai-berkshire/tools/*.py`·尤 `financial_rigor.py`）。
- **锁定基准**：vendored 目录锁定于上游 repo hash `e7a912a55f32`（VENDORED.md·〔M〕62）。运行 vendored 脚本前，对该脚本文件 sha256 与**首次落库时记录之锁定 hash** 比对。
- **会话内生成脚本**：无上游锁定 hash 基准者，对**生成时刻自记 hash**（生成即记·运行前复核）。
- **对表失败处置**：**弃用该脚本 → 回退 raw 一手源重算 → 照实上呈**（本次 Staples worker 之行为即此处置之范例·成文化为标准动作）。
- **落点**：本规则登记入 cc-knowledge §（执行侧脚本纪律）·VENDORED.md 供应链纪律之机械化补充。

## 规则二（根因对症·即行）：并发 worker scratchpad 命名空间隔离
- **本次事件根因**=三 worker 并发共用同一 scratchpad·同名脚本（`compute.py`/`data.pkl`/`final2.py`）last-writer-wins 互相覆盖（详见 `forensics-report.md`）。sha256 对表**捕获不到此类**（碰撞发生在无锁定基准之临时脚本层）。
- **规则**：主流程编排**并发** worker（如批量 SEC XBRL 核数）时，须令各 worker：
  1. **独立 scratchpad 子目录**（`scratchpad/<worker-label>/`）或
  2. **中间文件名带 worker 前缀/唯一标识**（`compute_<sector>.py`/`data_<sector>.pkl`）。
  杜绝并发同名写入。
- **worker 侧防线保留**：即便隔离，worker 遇"脚本/数据异常"仍照规则一处置（弃用→raw 重算→上呈）——双保险。
- **落点**：主流程 subagent 编排纪律（moat 工作指引 §工具链 / cc-knowledge 执行侧）；本批②（三板块中小盘段·下周末窗）滚扫**即按规则二隔离命名空间执行**。

## 净室加固深案（候 GM 评估·⑤d）
- 本两条系**即行临时硬化**（轻量·零新制度）。**重制度（净室环境加固/沙箱隔离等）不预立**，候本取证报告呈 GM 后由 GM 评估是否升级。CGM 不自行加制度。

---
*编制=CGM·2026-07-18·ADJ-0718-03⑤c｜规则一=GM 令即行（vendored hash 对表）｜规则二=根因对症即行（并发命名空间隔离）｜重制度候 GM 评估*
