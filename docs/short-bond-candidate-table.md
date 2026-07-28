# 短债腿「换」· 候选对照表（**呈核件 · 终选权在委托人 · CGM 不自决**）

- **依据**：ADJ-0728-13①（委托人「换」终裁——短债腿改用第二发行人之等价爱尔兰 UCITS；工具遴选由 CGM 出候选对照表〔费率／规模／复制方式／证券借贷政策／存管人〕呈核后执行）
- **数据源**：`DR-20260728-02`（DR 轨盲取·答卷 sha1 `864ad5c2ab01c0d3489abd59727cfd7d278f4faa`·relay `88963a1`）——**全部发行人一手源**（官方产品页／factsheet／Prospectus／Fund Supplement），未用数据商、未用 FMP 及其转发者
- **档位**：CGM **claude-opus-5**（A 类·编表不选择）
- **纪律**：本表**只列事实与其含义，不作选择建议**；「换」之目的（降单一发行人家族集中）之达成与否系事实判断，照报

---

## 一、三候选对照（八栏 · 全部一手凭据）

| 栏 | **候选一 · SPDR 1-3M T-Bill** | **候选二 · Vanguard 0-1Y** | **候选三 · Vanguard 1-3Y** |
|---|---|---|---|
| **1 发行人** | State Street SPDR（SSGA SPDR ETFs Europe I Plc） | Vanguard（Vanguard Funds plc） | Vanguard（同左） |
| **2 ISIN** | `IE00BJXRT698` | `IE00BLRPPV00` | `IE000H3Q3AF6` |
| **3 主要美元线** | Deutsche Börse（**Primary**）·USD·`ZPR1`；SIX·`TBIL` | LSE·USD·`VDST`；SIX·`VDST` | LSE·USD·`VUDS`；SIX·`VUDS` |
| **4 费率** | **TER 0.05%** | **OCF 0.05%**〔发行人未另列「TER」字段〕 | **OCF 0.05%**〔同左〕 |
| **5 规模** | 总 **$864M**／份额 $859M | 总 **$7,331M**／份额 $2,400M | 总 **$56M**／份额 $53M |
| **6 复制方式** | 实物**分层抽样** | 实物**抽样**（representative sample） | 实物**抽样** |
| **7 证券借贷** | **YES（明确在做）**·上限 **70% NAV**·代理保留至多 **25%** 收入·**代理＝State Street Bank and Trust（自家关联方）** | **当前是否实际出借＝取不到**（仅 "may"）·上限 **50% NAV**／单一对手 20%·成本 5%／基金得 95%·**代理＝J.P. Morgan SE Luxembourg，Prospectus 明写「not a related party to the Manager」** | 同候选二 |
| **8 存管人（法人全称）** | 🔴 **State Street Custodial Services (Ireland) Limited** | **Brown Brothers Harriman Trustee Services (Ireland) Limited** | 同候选二 |
| **久期** | Eff. Duration **0.10**／均到期 0.10y | 均久期 **0.4y**／均到期 0.4y·Under 1Y 100% | 均久期 **1.9y**／均到期 2.0y |
| **Acc/Dist** | Acc | Acc | Acc |

---

## 二、🔴 三项对「换」之目的具有决定性之事实（**照报·不作选择**）

### (甲) 候选一之存管人与我方现状**同一法人**

**IWDA 之存管人 ＝ `State Street Custodial Services (Ireland) Limited`**（段一外审答卷所载·`docs/ext/core-allocation-review-report.md`）。
**候选一之存管人 ＝ 同一法人，逐字相同。**

**含义**：「换」之目的系降**单一发行人家族集中**（满配约 71pp→41pp）。选候选一**确可换掉发行人**（BlackRock→State Street），**但托管链一端不动**。
**且须并读一层**：候选一之**发行人与存管人同属 State Street 集团**，而我方现状（BlackRock 发行 ＋ State Street 存管）系**两个不同集团**——**就「发行人与存管人是否同集团」这一维度而言，候选一较现状更集中，非更分散。**

**候选二／三之存管人 ＝ Brown Brothers Harriman Trustee Services (Ireland) Limited**，与发行人 Vanguard **分属不同集团**，亦与我方现有之 BlackRock／State Street 两方皆无重叠。

### (乙) 证券借贷之实况差异

- **候选一：明确在做**（产品页 `Securities Lending: Yes`），上限 **70% NAV**（较高），**且借贷代理系其自家关联方**（State Street Bank and Trust, London branch）；
- **候选二／三：当前实际状态「取不到」**——答者明确拒绝把 Prospectus 之 "A Fund **may** lend" 改写成「正在出借」；制度上限 50%，**代理 J.P. Morgan SE Luxembourg 并经 Prospectus 明写非关联方**。

**含义**：短债腿系**第 1 层流动性生存**之唯一承担者（L1≥25% 红线）。证券借贷在危机中之召回时效属该层之直接风险面；**上限 70% 与 50% 之别、代理是否关联方之别，皆落在此层。**
**⚠️ 惟须同时记一处反向事实**：候选二／三之借贷代理系 **J.P. Morgan**，而我方主私行与黄金 ETC 托管**亦为 JPM**——就 JPM 集中而言，此系新增一处接触面（**惟借贷代理 ≠ 存管人，风险层级不同；且其当前是否实际出借「取不到」**）。

### (丙) 候选三之规模不足以承接本腿

短债腿目标 **30% NAV ≈ $3,030 万**。候选三总规模仅 **$56M** → 我方一家将占其 **约 54%**。
候选二占比约 **0.4%**（$7,331M）、候选一约 **3.5%**（$864M）。

**含义**：候选三在规模维度上不具可行性；此系算术，非偏好。

---

## 三、久期匹配（现状对照）

现状 IB01 ＝ iShares $ Treasury Bond **0-1yr** UCITS ETF。
- **候选二（0-1Y·久期 0.4y）＝ 久期区间之直接等价**；
- 候选一（1-3M·久期 0.10y）**更短**；
- 候选三（1-3Y·久期 1.9y）**显著更长**——久期拉长会改变该腿之利率敏感度，**与「第 1 层流动性生存」之定位须另行权衡**。

---

## 四、CGM 处置边界（明示）

1. **本表不含选择建议**——ADJ-0728-13① 定「呈核后执行」，**终选权在委托人**；
2. 第二节三项系**事实及其直接含义**，非偏好陈述；**(甲) 若不报即为失职**——「换」之目的能否达成，取决于该事实；
3. **执行方式照既定**：新增短债批次导向新工具，**存量 IB01 不强制转换，零卖出**；
4. **一处未及**：本轮未查各候选之**做市商深度／买卖价差／二级流动性**——对 L1 腿而言该维度亦重要，**如实标为未查，候委托人示下是否补取**。

---

## 五、答卷侧值得记正之三处（凭据纪律）

1. **拒绝把 OCF 改称 TER**——Vanguard 官方文件只列 OCF，答者明写「不把 OCF 无保留改称 TER」，保留口径差异；
2. **拒绝把 "may lend" 编成 "yes"**——并说明已查 factsheet／Supplement／Prospectus／年报四路径，年报时点（2025-12-31）不能证明当期状态，故标「取不到」；
3. **主动披露自身工具之不可靠**——Vanguard factsheet URL 系可变最新版链接，其视觉缓存曾返回旧版（31 Mar／30 Apr），答者只采最终文本端结果，**旧缓存数值一律未采用**。

---

——[执行侧·CGM-G3]（claude-opus-5·A 类编表），2026-07-28；**呈核件·候委托人一字**
