# 取证报告 · scratchpad 脚本完整性事件（2026-07-18）· ADJ-0718-03⑤b

> **性质**：CGM 一页取证报告·**证据说话不臆断**（ADJ-0718-03⑤b）。结论=**并发 worker 共用 scratchpad·同名脚本互相覆盖**（namespace collision），**非外部/恶意入侵**。被篡改文件已隔离存证（本目录 `evidence/`·勿删）。

## 一、事件缘起
批①滚扫（ADJ-0718-02·〔M〕140）由三个 SEC XBRL five-dim worker 并发执行（Healthcare／Staples／Discretionary）。**Staples worker** 在其完成回报中申报：其 scratchpad 中间脚本 `compute.py` **任务中途被外部篡改**为读取"一个不存在的 `data.pkl`"并"注入预设标签"；worker 识破后**弃用该脚本·改用自身 `final2.py` 对原始缓存 SEC JSON 重算**——未采信被注入值。此申报触发本取证（GM 立案·ADJ-0718-03⑤）。

## 二、证据（scratchpad 直接观测·2026-07-18）
1. **文件时间线**（scratchpad 内·同一目录）：`fetch.py`(09:25)→`data.pkl`(09:27)→`compute.py`(09:28)→`compute2.py`(09:30)→`data2.pkl`(09:30)→`compute3.py`(09:32)→`final.py`(09:36)→`final2.py`(09:37)→`final3.py`(09:40)→`final4.py`(09:44)。系一条**迭代自调试脚本链**之典型形态（fetch→compute→final 逐版修正）。
2. **`final2.py`（存证 hash `ebf90fef…`）读取的公司集 = 22 名 Consumer Discretionary**（CMG/ORLY/AZO/TJX/ROST/NKE/LULU/BKNG/CPRT/ROL/MAR/HLT/YUM/DPZ/ULTA/DECK/RL/TPR/SBUX/DRI/ABNB/EXPE），直接读 `edgar/{cik}_{tag}.json` 原始 companyconcept 缓存。
3. **但 Staples worker 申报"我用了 final2.py"**——而其公司集为 13 名 Consumer Staples（MKC/MDLZ/HSY/MNST/KDP/CLX/CHD/KMB/KVUE/PM/MO/EL/STZ），与现存 `final2.py` 内容**不符**。→ **现存 `final2.py` 系被后写者（Discretionary worker）覆盖之结果**；Staples worker 当时写入的同名 `final2.py` 已被覆盖。
4. **`compute.py`（存证 hash `4522e8ae…`）读取 `data.pkl`**（pickle·非 raw JSON），结构 `data[tk]=(tag,ent)`——与 `final2.py`（读 raw edgar/ 缓存）路径不同，系**另一版本/另一 worker 之脚本**。
5. **Staples 自有 raw 缓存独立存在**：scratchpad 内 `cf_MKC.json`/`cf_MO.json`/`cf_MDLZ.json`/`cf_KMB.json`/… (09:28–09:31·companyfacts 全量)——正是 Staples worker 重算所依之一手源，**未被污染**（各 3–5MB·独立文件名·无碰撞）。

## 三、根因判定（证据支撑·非臆断）
- **三 worker 并发共用同一 scratchpad 目录**（`/tmp/…/scratchpad`），且**均使用通用脚本名**（`compute.py`/`data.pkl`/`final2.py`/`final.py`）。并发写入 → **同名文件互相覆盖**（last-writer-wins）。
- Staples worker 运行其 `compute.py` 时，该文件（或其依赖 `data.pkl`）已被**另一并发 worker（Discretionary）重写为不同公司集/不同结构**——从 Staples worker 视角看，即"脚本被外部改动、data.pkl 结构不对、出现非我预期的标签"。**worker 将并发碰撞误判为"外部篡改/注入预设标签"**。
- **无任何证据指向外部或恶意入侵**：所有涉事文件均系本会话三 worker 自身产物；无外部进程、无网络注入痕迹、无 vendored 文件被动（见四）。**"预设标签"= 另一 worker 之分类/中间输出**，非攻击载荷。

## 四、vendored 供应链未受影响
- 被碰撞者=**会话内生成之 scratchpad 临时脚本**（无锁定 hash）；**非 vendored 文件**。
- `vendor/ai-berkshire/`（`financial_rigor.py` 等·锁定 repo hash `e7a912a55f32`·VENDORED.md）**未被触碰**（本事件不涉 vendored 目录）。供应链纪律（勿直改上游/升级走 ADJ）无破口。

## 五、数据完整性结论
- **Staples worker 之防线正确起效**：识破异常→弃用被覆盖脚本→回退自身 raw companyfacts 缓存重算。其回报之五维读数系**干净重算值**（非被注入值）。
- **〔M〕140／batch1 报告已发布数据无污染**：三 worker 各自回报之读数均源自其自身 raw SEC JSON 重算（非共享 pickle）；已发布值与各 worker 回报一致。**无需更正 batch1 数据**。

## 六、真实修复方向（对症）
- **本事件对症解=worker 隔离命名空间**：并发 worker 各自独立 scratchpad 子目录（或脚本/中间文件名带 worker 前缀），杜绝同名覆盖。→ 收敛为 CGM 编排纪律（见 `hardening-rules.md`）。
- GM ADJ-0718-03⑤c 之 **sha256 对表硬化规则**（vendored 脚本运行前对锁定 hash）系**另一威胁模型**（vendored 文件被动）之防御·正当且予采纳登记（见 `hardening-rules.md`），但**非本次事件之根因对症**——本次根因是并发命名空间碰撞·非 hash 校验能捕获之类别（scratchpad 生成脚本无锁定 hash 基准）。
- **净室加固深案**：候本报告 GM 评估（ADJ-0718-03⑤d·不预立重制度）。

## 七、存证清单（本目录 `evidence/`·勿删）
| 文件 | 存证名 | sha256 | 说明 |
|---|---|---|---|
| compute.py | `evidence/compute.py.captured` | `4522e8ae87741938919b2c2f5506cd16cbf23ffb3570eac0eaf08236eb22dd62` | 读 data.pkl 版·被碰撞脚本之一 |
| compute2.py | `evidence/compute2.py.captured` | `a939801c8f53a776634245e40e14faec6c602667092b7589e9e8a1bf6080212f` | 迭代版 |
| final2.py | `evidence/final2.py.captured` | `ebf90fef062968d32b6a802d3c7c9259012ac2e06436006134543fba44857cf4` | 现存=Discretionary 22 名·覆盖后之末写版 |
| data.pkl | （未拷贝·1.4MB 二进制·hash 存录） | `ec26228a538c1c40f9b447e7f5726acc524ee2d257c8291a641ebe1db71e8943` | pickle·并发写入对象 |

---
*编制=CGM·2026-07-18·ADJ-0718-03⑤b｜证据基于 scratchpad 直接观测｜结论=并发命名空间碰撞非入侵·不臆断·呈 GM 评估净室加固*
