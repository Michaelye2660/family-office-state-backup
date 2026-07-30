# 取数能力图 · 逐端点实测（ADJ-0730-17④·2026-07-30·**新会话**）

> **本件性质**：A 类机械实测记录。**零判断零建议零解读**。
> **实测环境**：2026-07-30 ~16:20–16:30 UTC，**本会话系新会话**（ADJ-0730-16⑤令1「FMP 端点须于新会话中试」之执行；亦系〔M〕399④「新会话首动作重试」之验证路径）。
> **标注法**：✅=本轮亲测可用｜⛔=本轮亲测被拒（附报文关键句）｜⏸=本轮未测（非结论）。

---

## 一、🔴 档位结论：**所购档位即 Starter**（GM 三因中 (b) 得证，(a)(c) 排除）

ADJ-0730-17① 列三因候核：(a) 购买未传导至连接器·须刷新；(b) 所购档位即 Starter；(c) 计费生效延迟。

**本轮实测据以判别（机械推理，非本席裁量）**：

1. **本会话系全新会话**——连接器于会话建立时重新授权。若成因为 (a)，新会话应已取得新权限；
2. **新会话下大量端点由「未知」转为「实测可用」**（见下表：statements／company／analyst／calendar／secFilings／search／directory／news／commodity／forex／economics／etfAndMutualFunds／marketPerformance 全部✅），**证明连接器确已带付费权限**——委托人所报「已购买」**属实**；
3. **然报文仍逐字明示 "The user is currently on the **Starter** plan"**——档位字符串在新会话中**未变**；
4. 距委托人报「已购」已逾一日且付费权限已实际生效，(c) 计费延迟**不成立**。

→ **结论：委托人确已付费，但所购层级为 FMP 之 Starter 档，低于 `quote` 批量端点所需之 Premium+。** 三因中 **(b) 成立**。
→ **委托人侧动作（一次列示·不催）**：若需 `quote/batch-quote`、非美市场行情等 Premium+ 能力，须于 FMP 账户升档；**若不升档，本图所载 Starter 能力已足以支撑台账現值法与证据包结构化构建**（见§四）。

---

## 二、FMP 端点逐一实测（Starter 档）

### 2.1 ADJ-0730-17④ 指定之**优先确认**八项 —— **全部 ✅**

| 工具 | 实测端点 | 结果 | 实测凭据（本轮返回之可核字段） |
|---|---|:--:|---|
| `statements` | `income-statement`(TMO·annual) | ✅ | FY2025 revenue 44,556,000,000／EPS 17.77／filingDate 2026-02-26／CIK 0000097745 |
| `statements` | `key-metrics-ttm`(TMO) | ✅ | ROE TTM 0.13351／EV/EBITDA TTM 22.849／FCF yield TTM 0.034621 |
| `company` | `profile-symbol`(TMO) | ✅ | ISIN US8835561023／CUSIP 883556102／CEO Marc N. Casper／员工 125,000／IPO 1980-03-17 |
| `analyst` | `price-target-consensus`(TMO) | ✅ | high 650／low 520／consensus 592.11／median 600 |
| `calendar` | `earnings-company`(TMO) | ✅ | 下期 **2026-10-28**(est EPS 6.40)；2026-07-23 实际 EPS **6.03** vs est 5.72、营收 11,994,000,000 |
| `secFilings` | `search-by-symbol`(TMO·7/01–7/30) | ✅ | 8-K accession **0000097745-26-000138**(2026-07-23·Q2 earnings)＋Form 4(07-28)·**含 SEC 直链** |
| `search` | `search-symbol`(IWDA) | ✅ | IWDA.L(LSE·USD)／IWDA.AS(AMS·EUR) |
| `directory` | `available-exchanges` | ✅ | 全 64 交易所表（含 HKSE/LSE/SHZ 之代码后缀与延迟口径） |
| `news` | `search-stock-news`(MSFT) | ✅ | 5 条·含 2026-07-30 12:01 UTC 之 capex 指引报道（**须注：新闻系二手，照 ADJ-0730-14⑥ 不得单独作 MDG-5 依据**） |

### 2.2 其余已测端点

| 工具 | 实测端点 | 结果 | 备注 |
|---|---|:--:|---|
| `chart` | `historical-price-eod-light`（**美国上市标的**） | ✅ | 19 只逐一取得·**含当日** |
| `chart` | `historical-price-eod-light`（**非美标的**） | ⛔ | 见 §三 |
| `quote` | `quote`（**单标的**） | ✅ | TMO 568.97·含 timestamp 1785428614·**仅成功调用一次即遭同工具批量端点拒绝，此后照禁试令未再试**（本项可用性系基于该单次成功） |
| `quote` | `batch-quote`（**批量**） | ⛔ | "requires the Premium, Ultimate, or Enterprise plan…**currently on the Starter plan**" |
| `commodity` | `commodities-historical-price-eod-light`(GCUSD) | ✅ | 黄金 2026-07-30 **4,170.0**·7-29 4,036.3·7-28 4,038.7 |
| `forex` | `forex-historical-price-eod-light` | ✅ | USDHKD 7.84266／GBPHKD 10.56434／USDCNY 6.7413（皆 2026-07-30） |
| `economics` | `treasury-rates` | ✅ | 2026-07-29：10Y **4.67**／30Y **5.20**／2Y 4.22（**只登不解读**） |
| `etfAndMutualFunds` | `information`(SMH) | ✅ | ISIN US92189F6768／domicile **US**／TER 0.35%／AUM 64.745B／NAV 529／持仓 26（**与 -16 之 ETF 件同源可交叉自核**） |
| `marketPerformance` | `sector-performance-snapshot`(2026-07-30) | ✅ | NASDAQ 板块日均涨跌 11 行 |

### 2.3 本轮未测（⏸·如实申报·非「不可用」）

`technicalIndicators`／`insiderTrades`／`form13F`／`earningsTranscript`／`discountedCashFlow`／`tipranks`／`ESG`／`senate`／`crypto`／`indexes`／`marketHours`／`commitmentOfTraders`／`Fundraisers`／`directory` 其余端点／`statements` 其余 25 端点。
**未测原因**：本轮以 ADJ-0730-17④ 指定之八项优先件＋現值法所需为范围，未作全端点穷举。**须用时逐一实测再登记，不得据本图推定。**

---

## 三、🔴 **Starter 档之覆盖边界＝仅美国上市标的**（本轮新发现·GM 未及）

`chart / historical-price-eod-light` 对以下代码**在参数层被拒**（报文：「A parameter you passed to this tool requires a higher plan…currently on the **Starter** plan」）：

| 被拒代码 | 市场 | 对应本户持仓 |
|---|---|---|
| `0700.HK` | 港交所 | **腾讯**（口袋最大单一持仓之一·首批造卡标的） |
| `0005.HK` | 港交所 | **汇丰**（U 域存量） |
| `IWDA.L` | 伦交所 | **IWDA**（核心 80% 之主载体） |
| `SGLN.L`／`IGLN.L` | 伦交所 | **黄金 ETC**（9% 黄金腿之 3% ETC 部分） |
| `159516.SZ`／`159819.SZ`／`159142.SZ` | 深交所 | **A 股三腿**（含〔J〕4 触发器标的） |

**边界结论（机械事实·非建议）**：**FMP Starter 不覆盖本组合之港股／伦交所／A 股腿**。按标的数计，〔L-1〕＋〔L-1b〕共 23 项中 **8 项** 落在 FMP Starter 覆盖之外。
**处置（照**委托人本轮改裁**之新链，见 §五）**：非美腿**优先走网页**（腾讯自选股／官方 IR），Bigdata 仅作最后兜底；本轮 8 项非美标的中 **7 项已由网页直取**，1 项（PIMCO）标的未定另候。见 §四、§五。

---

## 四、非 FMP 源实测（**按委托人新链排序：网页在前·Bigdata 兜底**）

### 4.1 第②层 · 网页源（委托人指定优先）

| 源 | 路径 | 结果 | 本轮取得 |
|---|---|:--:|---|
| **🟢 腾讯自选股 `qt.gtimg.cn`** | `?q=sz159516,sz159819,sz159142` | ✅ | A 股三只·**收盘后终值**（16:14–16:15 北京时间） |
| **🟢 腾讯自选股 `qt.gtimg.cn`** | `?q=r_hk00700,r_hk00005` | ✅ | **腾讯 HKD 471.800／汇丰 HKD 164.500**·**收盘后终值**（16:08 HKT）·附 PE／52 周区间 |
| **🟢 新浪财经 `hq.sinajs.cn`** | `list=hf_GC` | ✅ | 纽约黄金 **4,175.416**（07-31 00:30 北京时间）·**用作 FMP GCUSD 之独立交叉源** |
| **🟢 iShares 官网**（官方一手） | 基金页 IE00B4L5Y983 | ✅ | IWDA **NAV USD 140.6952 @2026-07-29**·当日 −1.16% |
| 新浪财经 `gb_iwda` | — | ⛔ | 无此代码（新浪美股接口不覆盖伦交所） |
| 腾讯自选股 `ukIWDA`／`lseIWDA`／`gbIWDA` | — | ⛔ | `pv_none_match`（腾讯行情不覆盖伦交所） |
| 伦交所官网 IWDA 页 | — | ⛔ | 页面为 JS 渲染，抓取无价格数据 |
| stooq `iwda.uk`／`iwda.l`／`sgln.uk` | — | ⛔ | 404 |

### 4.2 第③层 · Bigdata.com（**降为最后兜底·本轮实际未被采用为终值**）

| 端点 | 结果 | 备注 |
|---|:--:|---|
| `find_securities` | ✅ | 腾讯 `3F3301`／汇丰 `BC9793`／IWDA `C86312` |
| `bigdata_company_tearsheet` | ✅ | 腾讯 HKD 471.80／汇丰 **GBp 1,587（伦股线）**——**本轮已被网页直取之港股线取代，不入台账** |
| `bigdata_etf_tearsheet` | ✅ | IWDA 价 142.42／NAV 142.34——**与官方一手冲突，照冲突规则不采**，见 §5.2 |
| `find_securities`（**裸 ETF 代码**） | ⛔ | IWDA→"IWD Enterprises"；SGLN→"SurgLine International"。**须用基金全名方可解析**——本轮踩坑，入图备忘 |

### 4.3 其余

| 源 | 结果 | 备注 |
|---|:--:|---|
| **FactSet** | 🔴 | **仍无独立连接器**（照 -16⑤令1 自查结论：系 Bigdata 之内嵌授权层，非独立可调源）·**本轮无变化** |
| **GPT 取数路** | ⛔ | 不启用（-16②·委托人「没有」） |

### 4.4 🟢 独立性验证：ADJ-0730-17③ 之警示逐字成立，且新链已自带解法

**警示成立之实证**：Bigdata 三处 tearsheet 之数据段**皆自陈 `source: fmp` / "Source: FMP"** → **以 Bigdata 复核 FMP 确不构成交叉印证**，-17③ 判断准确。

**新链自带解法**：腾讯自选股／新浪财经／iShares 官网**与 FMP 无数据血缘**。委托人把网页提到 Bigdata 之前，**恰使二源交叉印证之第二源落在链内第②层**——本轮已产生两例成立之交叉印证（腾讯 0700.HK 逐位一致、黄金差 0.13%），详见 §5.1。

---

## 五、🔴 数据链＝**委托人本轮直令改裁**（2026-07-30·运行口径·宪法§六文本不动）

**委托人原文（两次，后者为完整表述）**：
> 「非美数据优先网页查询腾讯自选股和其它网页，确实查不到才走 bigdata」
> 「**所有取数优先用 fmp，fmp 查不到的例如非美数据优先通过网页查询例如腾讯自选股等其它网页，最后确实查不到才走 bigdata**」

**据此，ADJ-0730-17③ 之链序被委托人改裁**（-17③ 原定 `FMP > Bigdata > 官方一手 > web`）。**CGM 照裁执行，不代为解释**（同族先例〔M〕399：委托人自改其令，CGM 照裁不代议，已呈 GM 知悉）。

```
① FMP 可用端点                    ← 一切取数首选
      ↓ FMP 查不到（含 Starter 覆盖外之非美标的）
② 网页（腾讯自选股 qt.gtimg.cn／官方 IR／交易所／新浪财经等）  ← 委托人指定之第二顺位
      ↓ 网页确实查不到
③ Bigdata.com 连接器              ← **降为最后兜底**
```

**与 -17③ 之差异**（如实标，供 GM 核）：Bigdata 由「首选替代」**降为最后兜底**；web／官方一手**升至第二顺位**。**⚠️ 同源风险条款不因链序变更而失效，反因新链而自然缓解**——新链第②层（腾讯自选股／官方 IR）本即与 FMP 无血缘，**二源交叉印证之第二源就在链内**，无须另辟路径。

**二源交叉印证之硬约束（照旧全额有效）**：Bigdata 全部行情段自陈 `source: fmp`，故 **FMP↔Bigdata 之一致不构成任何印证**；动钱前之现价、红线权重、门槛边界值，第二源须取第②层。

### 5.1 新链首日实测战果（本轮即验，三项）

1. **🟢 汇丰**：先前经 Bigdata 取伦交所线 GBp 1,587 再以 GBPHKD 折算得 HKD **167.66**；改走网页后腾讯自选股**直取港股线 HKD 164.500**——**两者差 1.9%**。**直取优于折算，委托人此令即刻产生精度收益。**
2. **🟢 腾讯 0700.HK**：网页直取 HKD **471.800**（07-30 16:08 HKT 收盘）与 Bigdata 之 471.80 **逐位一致**——因两源真正独立（腾讯自选股非 FMP 血缘），**此系本组合迄今第一例成立之二源交叉印证**。
3. **🟢 黄金**：FMP `GCUSD` **4,170.0** 与新浪财经 `hf_GC` **4,175.416**（07-31 00:30 北京时间）交叉，**差 0.13%**，两源独立 → 金价读数**已达可动钱之印证标准**（〔J〕1 台账口径仍以 FMP GCUSD 为尺，不改）。

### 5.2 新链下之未决项（如实登记）

- **IWDA**：FMP ⛔（.L 非美）→ 网页 iShares 官网 ✅ **NAV USD 140.6952 @2026-07-29（官方一手）**；伦交所官网页与 stooq 皆未取到实时价。
  **🔴 冲突登记**：Bigdata（FMP 源）报 07-30 价 142.42／NAV 142.34；官方 07-29 NAV 140.6952＋官方标注当日 −1.16%。以官方 7-29 NAV 推 7-30 之 Bigdata 日涨 +0.69% 应得 ≈141.67，与 142.34 **仍差约 0.47% 无法由日期解释**。**照「冲突以官方一手为准」，台账采 140.6952（标 T-1·官方）**；差异只登不裁，呈 GM。
- **SGLN／IGLN 单位价**：未取。**非缺口**——台账明定黄金現值法＝盎司当量×现货金价，不经 ETC 单位价。
- **PIMCO Income**：**标的未能唯一确定**。Bigdata 检索返回 PDI／PHK／PML／RCS／PFL 五只封闭式基金，**无一与委托人所报买入均价 $15.66 相符**；疑为爱尔兰注册之 PIMCO GIS Income Fund 某份额类别。**照禁造纪律不猜不填**，**候委托人报 ISIN 或份额类别一字**（不催）。

---

## 六、旧 §五 之作废声明

本件初稿曾按 ADJ-0730-17③ 写 `FMP > Bigdata > 官方一手 > web` 之链序；**该链序已于同一工作时段内被委托人直令改裁**，以上 §五 为现行版本，初稿链序作废。**如实留痕，不掩改动。**

---

## 七、对 SWEEP-01 证据包之影响（ADJ-0730-17④ 明问）

**机械事实**：`statements`／`company`／`analyst`／`calendar`／`secFilings` 五项**在 Starter 下全部可用**，且 `secFilings` **直接返回 SEC accession 号与原文直链**。

→ 首批四卡中 **MSFT／META／TMO 三卡之证据包可自「二手知识库级」升为「一手结构化数据＋SEC 原文可溯」**（ADJ-0730-14⑥ 证据分级之最高一档路径已通）。
→ **腾讯卡例外**：0700.HK 在 FMP Starter 覆盖外，其证据包仍须走 Bigdata＋港交所/公司 IR 一手，**分级须单独标注，不得随三卡一并宣称已升级**。
→ **本节只报能力，不改任何造卡纪律**：压测材料禁令、blindtest 路径禁访、TMO 禁见旧 MDG-4，一律照旧。

---

---

## 九、ADJ-0730-18⑤ 增测三项（2026-07-30·收件时补测·本节系 -18 之专办）

### (a) 非美被拦边界之普适性 —— **已证实：Starter ＝ 美股专用**

`chart/historical-price-eod-light` 逐符号实测，**跨 5 个市场 10 个非美符号，无一例外全部在参数层被拒**（报文皆为 "A parameter you passed to this tool requires a higher plan…currently on the **Starter** plan"）：

| 市场 | 实测符号 | 结果 |
|---|---|:--:|
| 港交所 | `0700.HK`／`0005.HK` | ⛔ ⛔ |
| 深交所 | `159516.SZ`／**`159819.SZ`**（GM 点名件）／`159142.SZ` | ⛔ ⛔ ⛔ |
| 伦交所 | `IWDA.L`／`SGLN.L`／`IGLN.L` | ⛔ ⛔ ⛔ |
| **东京**（本轮新测） | `7203.T`（丰田） | ⛔ |
| **德国**（本轮新测） | `SAP.DE` | ⛔ |

**对照组**：同端点传 `TMO`／`MSFT` 等 19 只美国标的**全部成功**。
→ **结论：边界系「上市地是否为美国」，非「某几个交易所」；-18② 之「Starter ≈ 美股专用」判断普适成立。**

### (b) 美股端点清单 —— **已逐一实测完毕**（见 §2.1）

`statements`／`company`／`analyst`／`calendar`／`secFilings`／`search`／`news` **七项全 ✅**，另加 `directory`／`chart`／`commodity`／`forex`／`economics`／`etfAndMutualFunds`／`marketPerformance` 亦 ✅。**本项无缺口。**

### (c) 非美门户可用取数路径与证据等级

| 市场 | 路径 | 结果 | 证据等级（-18③） |
|---|---|:--:|---|
| **A股** | 腾讯自选股 `qt.gtimg.cn/q=sz159516,...` | ✅ 收盘终值 | **二手**·门户聚合 |
| **A股** | **东方财富 `push2delay.eastmoney.com/api/qt/stock/get?secid=0.159516&fields=...`** | ✅ **本轮新测通** | **二手**·门户聚合 |
| **A股** | 中证官网 `www.csindex.com.cn`（标的指数 PE） | ✅ 在册 | **一手**·官方日度序列 |
| **港股** | 腾讯自选股 `qt.gtimg.cn/q=r_hk00700,r_hk00005` | ✅ 收盘终值 | **二手**·门户聚合 |
| **港股** | **披露易 `hkexnews.hk`（一手）** | 🔴 **未通** | — |

**🟢 A股二源交叉即刻成立**：腾讯自选股与东财**系两个独立门户**，本轮读数**逐位一致**（159516 现价 0.650／昨收 0.706／涨跌 −0.056／涨跌幅 −7.93%）→ **恰满足 -18③(iii)「两个独立门户」之要求**。

**⚠️ 东财操作坑（写入四处落文备忘）**：`push2.eastmoney.com` 直连返 **502 Bad Gateway**；**须走海外 IP 重定向域 `push2delay.eastmoney.com`**（README 白名单章节已载此域，本轮实测确认必要性）。字段口径：`f43`＝现价×1000、`f60`＝昨收×1000、`f169`＝涨跌×1000、`f170`＝涨跌幅×100。

**🔴 披露易未通之如实申报（三条路径全试·非未试）**：
1. `titleSearchServlet.do`（stockId=142·2026-07-01→07-30）→ `recordCnt: 0`；
2. `titleSearchServlet.do`（stockId=-1·全市场·07-28→07-30）→ `recordCnt: 0`；
3. 每日公告索引页 `listedco/listconews/sehk/2026/0730/ltn20260730.htm` 与 `…/0729/ltn20260729.htm` → **皆 HTTP 404**。
**主站本身可达**（`hkexnews.hk` HTTP 200·`hkex.com.hk` HTTP 200）→ **系接口路径/参数问题，非网络封锁**。
**→ 港股「一手」路径 ⏸ 未落实。** 影响界定：**腾讯卡（0700.HK）之证据包按 -18 执行注须走非美路径且一手优先，本项未通即构成该卡之实质卡点**——**呈 GM**：或（甲）另定披露易接口/改走 WebFetch 网页检索、或（乙）改以公司 IR（tencent.com/investors）为一手载体、或（丙）该卡证据分级下调并显式标注。**CGM 不自裁，候 GM 一字。**

**未测项（如实）**：日股／欧股之门户路径未测（本户无该两市场持仓，-18⑤(c) 亦仅点名港股与 A股）。

---

## 八、本图之效期与复核

- **档位一变即全图作废**（Starter→Premium+ 会改变 §二 之 ⛔ 行与 §三 之整节边界）；
- ⏸ 项须用时逐一实测，**不得据本图推定为可用**；
- 本图**不含任何行动含义**，不构成买卖建议。

——机械实测汇整：[执行侧·CGM-G3]（claude-opus-5·A 类·零判断零建议），2026-07-30
