# 数据源替代链地图 v1.0(2026-07-26)

> **缘起**:2026-07-26 早间简报 run-log 授权项C(FMP 套餐是否升级)→ **委托人裁「c 找其他取数方式取代」**(不升级套餐)。本文件系据此实测勘测之产物,**供简报 routine、data-verifier 席、各深查席复用**,免于每次重新试错。
> **效力**:本文件为**操作性口径文件**,不含任何投资判断。所列样本值系 2026-07-26 实测取回之真实值,**仅为证明该路径可用**,不构成价格锚——价格锚一律以 `portfolio-state.md` 〔L〕节为准。
> **纪律**:表中任一路径**未实际取回样本值者一律记「无可用源」**;「文档说支持」「看起来可达」不作数。
> **档位**:勘测席与整理席同处 claude-opus-5(降档申报)。本文件属机械勘测与登记,不含判断类产出。

---

## 〇、两个解锁项(本次最大收获)

### 解锁一 · SEC 此前的 403 不是策略拒绝,是**缺 User-Agent**

`data.sec.gov` 与 `www.sec.gov` 在**加上含联系方式的 UA 后全部 200**。此前多次记录的"SEC 受阻"实为请求头不合规(SEC 官方要求 UA 含名称与邮箱)。

**今后所有 SEC 调用一律带 UA**:

```
curl -H "User-Agent: <名称> <邮箱>" --compressed <url>
```

### 解锁二 · Bigdata.com MCP 底层走 FMP,但**用的是更高档套餐**

我方 FMP 直连被拒的 `indexes` / `quote` / `calendar` 数据,**经 Bigdata MCP 转手可取回**。这是绕开套餐限制的**合法路径,且不额外付费**。

> 已知我方 FMP 直连可用档:`analyst`、`economics`、`commodity`、`secFilings/company-search-by-symbol`。
> 被拒档(套餐层级 ACCESS DENIED):`quote`、`chart`、`calendar`、`statements`、`forex`、`indexes`、`technicalIndicators`(与 chart 同档,后门尝试已失败)、**`earningsTranscript`(2026-07-26 实测·4端点全拒)**。

---

## 一、本环境出口白名单(2026-07-26 实测)

curl 出口经组织策略过滤,绝大多数域名 `CONNECT tunnel failed 403`。**实测可达主机仅 6 个**:

| 主机 | 用途 |
|---|---|
| `qt.gtimg.cn` | 腾讯快照:港股／A股／美股／LSE(uk前缀) |
| `hq.sinajs.cn` | 新浪快照:汇率(fx_s*)／美股指数(gb_$*)／A股／现货金(hf_XAU) |
| `finance.pae.baidu.com` | 百度:5日分钟序列(个股历史EOD唯一途径) |
| `www.csindex.com.cn` | 中证官网:中国指数官方逐日EOD与估值(PE/分位) |
| `data.sec.gov` | SEC XBRL companyfacts／submissions(**须带UA**) |
| `www.sec.gov` | SEC Archives 原文(**须带UA**) |

外加 MCP 通道:**FMP**(受限档)、**Bigdata.com**(高档)。

---

## 二、替代源对照表

| 功能 | FMP原端点 | 推荐首选源 | 备用源 | 实测样本值(2026-07-26取回) | 已知限制 |
|---|---|---|---|---|---|
| 历史EOD·中国指数 | chart | **中证官网** | — | 上证综指 20260724 O3853.63 H3861.04 L3808.64 **C3814.20** | 仅中证/上证指数,无个股 |
| 历史EOD·个股5日 | chart | **百度 `quotation_fiveday_*`**(分钟序列聚合) | 腾讯/新浪(仅当日) | TMO 07-24 **C568.26** | **仅回溯5个交易日**;系分钟推导非官方EOD |
| 历史EOD·任意区间 | chart | **无可用源** | — | — | **6日以前无任何取数途径** |
| 汇率 | forex | **新浪 `fx_s*`** | Bigdata market_tearsheet | **USD/CNY 6.7702**／**USD/GBP 0.7508071177**(7/24收盘) | 做市商报价非中间价;在岸CNY |
| 指数点位 | indexes | **新浪 `gb_$*`** | Bigdata market_tearsheet | 标普500 **7411.98**(7/24收盘) | 新浪无VIX |
| VIX | indexes | **Bigdata market_tearsheet** | — | **VIX 18.58**(7/24收盘) | **仅此一源·无交叉印证** |
| 财报日历·**事前** | calendar | **Bigdata `events_calendar`** | 无 | **SPGI Q2'26:2026-07-28T12:30:00Z(08:30 ET 盘前)** | 需先 find_securities 取 rp_entity_id |
| 财报日历·事后 | calendar | SEC `submissions` | — | SPGI 最近8-K filed 2026-07-06·accn 0001104659-26-080751 | 只能事后 |
| 财务报表 | statements | **SEC XBRL `companyfacts`** | Bigdata company_tearsheet | TMO FY2025 营收 **44,556,000,000**／经营现金流 **7,818,000,000** | **标签跨年漂移·须拼接** |
| ETF NAV／场内价 | quote | **Bigdata `etf_tearsheet`** | 腾讯 `ukXXXX` | IGLN NAV **78.90** vs 场内 **79.06**·溢价 **+0.21%** | 仅USD线 |
| SGLN 便士线 | quote | **无可用源** | — | — | 见§五-3 |
| **无风险利率(美债收益率曲线)** | economics | **FMP `economics/treasury-rates`** | 无 | **10Y 4.69%／30Y 5.16%／2Y 4.33%(2026-07-24)** | ✅ **可用·带日期字段·可锁版本**;实测 2026-07-20~24 逐日全返;**卖出触发器 §3-B-1 之 rf 输入源** |
| **股权风险溢价 ERP** | economics | **FMP `economics/market-risk-premium`** | 无 | 美国 total **4.46%**(国家风险溢价 0.23／成熟市场基准 4.23) | ⚠️ **可取但端点未返回任何日期字段 → 版本不可锁定**;逐次取值无法证明是否更新过·**引用时须标「取回时刻」而非「数据日期」**(与 Bigdata「As of」同型问题·见§四) |
| 电话会转录稿(全文) | earningsTranscript | **Bigdata `bigdata_search`→`fetch`** | 无 | TMO 2026-07-23 Q2电话会全文·双源交叉(Quartr `A227C59D…`＋Motley Fool `5BC98CA4…`) | **FMP `earningsTranscript` 实测 ACCESS DENIED(4端点全拒·需Ultimate/Enterprise)**;Bigdata券商研报语料(INVESTMENT-RESEARCH)三次检索均0 chunk·疑订阅不含 |

---

## 三、可复用调用形态(逐条·可直接抄用)

### 3.1 中证官网 · 中国指数逐日EOD与估值(**唯一真正的官方逐日EOD**)

```
https://www.csindex.com.cn/csindex-home/perf/index-perf?indexCode=000001&startDate=20260720&endDate=20260724
```
- `indexCode`:`000001`=上证综指／`000300`=沪深300／`931743`=中证半导体材料设备主题
- 返回含逐日 O/H/L/C 与 **`peg` 字段=PE(TTM)**(台账 931743 锚即用此字段,口径已验证)
- 实测:上证 0720 C3796.28／0721 C3864.37／0722 C3867.03／0723 C3876.78／**0724 C3814.20**;沪深300 0724 C4649.19
- **与新浪快照逐位吻合**(3814.1978 vs 3814.2),互为印证
- ⚠️ `tradingValue` 单位为**亿元**,与 `tradingVol`(股数)不同量纲

### 3.2 百度 5日分钟序列(**个股历史EOD唯一途径**)

```
https://finance.pae.baidu.com/selfselect/getstockquotation?all=1&code=TMO&stockType=us&group=quotation_fiveday_us&finClientType=pc&newFormat=1
```
- `stockType`/`group` 后缀:`us`(美股)／`ab`(A股)／`hk`(港股)
- **`newFormat=1` 为必需参数**,缺之返回空
- **硬边界:只能回溯 5 个交易日**

### 3.3 新浪 · 汇率(需带 Referer)

```
https://hq.sinajs.cn/list=fx_susdcny,fx_susdgbp,fx_susdhkd,fx_seurusd,fx_sgbpusd
```
- 实测:USD/CNY 6.7702／USD/GBP **0.7508071177**(10位精度)／USD/HKD 7.8417／EUR/USD 1.1367
- 交叉验算自洽:GBP/USD 1.3319 × 0.7508071177 = 1.00000

### 3.4 新浪 · 指数点位

```
https://hq.sinajs.cn/list=gb_$inx,gb_$dji,gb_$ixic,sh000001,rt_hkHSI
```
- 实测(均 7/24 收盘):标普500 7411.98／道指 51947.25／纳指 24975.8238／上证 3814.1978／恒生 24963.23
- ⚠️ **`gb_$vix` 返回空字符串** → VIX 须走 Bigdata

### 3.5 SEC XBRL · 财务报表多年序列(**完全替代 statements**)

```
curl -H "User-Agent: <名称> <邮箱>" --compressed \
  https://data.sec.gov/api/xbrl/companyfacts/CIK0000097745.json
```
- CIK 须补零至 10 位(TMO=0000097745)
- 单文件约 5.1MB,**含全部历史,一次拉取即可离线切片**
- 实测 TMO(accn 0000097745-26-000018·10-K·filed 2026-02-26):
  - `RevenueFromContractWithCustomerExcludingAssessedTax`:FY2024 42,879,000,000 ／ FY2025 **44,556,000,000**
  - `NetCashProvidedByUsedInOperatingActivities`:FY2024 8,667,000,000 ／ FY2025 **7,818,000,000**
- ⚠️ **标签跨年漂移**:TMO 的 `Revenues` 标签只到 FY2017 即终止,之后迁至 `RevenueFromContractWithCustomerExcludingAssessedTax`。**MDG 深查若只查一个标签会在 2018 年前后断档**;正确做法是按 `accn`+`frame`(如 CY2024)**拼接多标签**。

### 3.6 SEC submissions · 归档日历(事后)

```
curl -H "User-Agent: <名称> <邮箱>" \
  https://data.sec.gov/submissions/CIK0000064040.json
```

### 3.7 Bigdata MCP · 事前财报日历 / VIX / ETF NAV

- **事前日历**:先 `find_securities` 取 rp_entity_id → `bigdata_events_calendar(rp_entity_ids=["CFF97C"])`
  - 实测 SPGI:`Q2 2026 | earnings-call | 2026-07-28T12:30:00Z`(=08:30 ET 盘前,**与台账「7/28盘前」一致**)
  - **意义**:GOOGL 那类「财报日待核」长挂,今后可用此路径**事前**闭环
- **VIX 与全球指数**:`bigdata_market_tearsheet`(同时给美债全曲线,10Y 4.69% as of 2026-07-24)
- **ETF NAV/场内价与溢折价**:`bigdata_etf_tearsheet`

### 3.8 腾讯 · 快照(港股/A股/美股/LSE)

```
https://qt.gtimg.cn/q=hk00700,sh000001,usTMO,ukIGLN
```
- LSE 用 `uk` 前缀,**支持便士计价**(实测 `ukSSLN`=4193.00 **GBX**)
- ⚠️ 但 `ukSGLN` 返回 `v_pv_none_match="1"` → **SGLN 不在腾讯 universe 内**(覆盖缺失,非币种限制)

---

## 四、口径警告(十条·凡可能导致误用者)

1. **百度「日K行」不可信,「分钟序列」可信。** TMO 07-24 三源对照:收盘一致 568.26,但百度日K行给 O569.23／H569.92／L566.66／量1,055,054／前收569.23,而腾讯给 O570.00／H574.00／L555.91／量2,939,458。**百度日K行的量仅约1/3,且「开盘=前收」自相等,疑为残缺快照。→ 只用百度日K行的收盘价,O/H/L 与成交量一律改用腾讯。** 港股同一模式。
2. **分钟推导的开盘价有锚点失真**:百度分钟序列首点以前收价打桩,故美股推导开盘=前收(572.32),非真实开盘(570.00);且推导高低仅覆盖常规时段,不含盘前盘后。**推导序列可用于收盘价与走势,不可用于跳空缺口判定。**
3. **Bigdata tearsheet 的「As of」是抓取时刻,不是交易日。** 报头写 2026-07-26 08:21 UTC(周日休市),实际数值全是 07-24 周五收盘。**直接抄「as of」日期会把周五数据标成周日。**
4. **新浪 `fx_s*` 是做市商/银行间报价,非人民币中间价**,且 USD/CNY 为**在岸**;Bigdata 另列 USD/CNH 6.78,**两者不可混用**。
5. **Bigdata 汇率仅 2 位小数**(GBP/USD 显示 1.33),不足以做便士线换算;**换算须用新浪的 10 位精度**。
6. **IGLN(USD线)≠ SGLN(便士线)**,虽同为 ISIN IE00B4ND3602。由 IGLN 美元价乘汇率得便士价属**推导值,不是取回值**,按纪律**不得当作报价落库**。
7. **NAV 滞后于场内价**:Bigdata 给的 NAV 78.90 与场内价 79.06 时点不同源,溢价 +0.21% 含时点差成分。
8. **XBRL 标签跨年漂移**(见 3.5),多年序列必须拼接,否则 2018 年前后断档。
9. **中证官网 `tradingValue` 单位为亿元**,与 `tradingVol`(股数)不同量纲。
10. **FMP commodity 的 GCUSD 是黄金期货非现货**,与 SGLN/IGLN 所锚的 LBMA 现货定盘价不同口径。

---

## 五、仍无解清单(五项·影响面已评估)

1. **6 个交易日以前的任何逐日 EOD**(全市场全品种)。**影响面**:任何需要历史区间的**回撤计算、买入成本复盘、均线自算、波动率自算全部悬置**——只能沿用 FMP 报价字段里现成的 52 周区间与 50/200 日均线,**不能自行验算**。
2. **美股/港股个股的官方结算 EOD**。现有只能到「分钟推导」或「快照转述」,仍非交易所结算数据。**「现有收盘价均系媒体转述」这一根本问题,只被缓解未被消除。**
3. **SGLN 便士报价**(累计 20 路全败)。影响面:SGLN 便士线的成本/市值换算继续无一手源。
4. **除美国外的结构化财务报表**(港股/A股/UCITS)。SEC XBRL 只覆盖 SEC 申报人。
5. **独立汇率第二源**与 **VIX 第二源**。目前 USD/GBP、USD/CNY 仅新浪单源,VIX 仅 Bigdata 单源,**无交叉印证**。

---

## 六、新旧冲突留痕(不裁决·备后查)

**冲突1 · TMO 2026-07-24 日线 O/H/L 与成交量三源不一致(收盘无争议)**

| 来源 | 开盘 | 最高 | 最低 | 收盘 | 成交量 | 前收 |
|---|---|---|---|---|---|---|
| 腾讯 qt.gtimg.cn | 570.00 | 574.00 | 555.91 | 568.26 | 2,939,458 | 572.32 |
| 百度 日K行 | 569.23 | 569.92 | 566.66 | 568.26 | 1,055,054 | 569.23 |
| 百度 分钟推导 | 572.32 | 572.32 | 556.75 | 568.26 | 2,939,459 | — |

**冲突2 · 0700.HK 2026-07-24 开盘价**:腾讯 438.200 vs 百度日K行 434.800(收盘均 434.60)。

**冲突3 · SGLN 便士价**:WebSearch 经 Yahoo 转述「6,312.00 GBp」**未附交易日期**,且反推隐含 USD/GBP=1.2527 与实测 1.3319 不符,**疑为陈旧数据·不予采信**,列入未取到。

---

## 七、维护纪律

- 本文件**随实测更新**;新增可用源或新增被拒源,一律追加并标注实测日期。
- **样本值不是价格锚**——本文件所列样本仅证明路径可用;价格锚以 `portfolio-state.md` 〔L〕节为准。
- 出口白名单可能随环境策略变动,**每次大规模取数前若遇 403,先对照本文件§一确认是否为已知拒绝**,避免重复试错。
- 上游关联:授权项 D(出站白名单扩容)**优先级已下调**——其清单中最要害的中证一项经本次勘测确认**本就可达**(此前受阻者仅 OSS 上的估值 xls)。

---

*立卷:[执行侧·CGM-G3]·2026-07-26·运行档位 claude-opus-5(降档申报)·委托人裁「c 找其他取数方式取代」*
