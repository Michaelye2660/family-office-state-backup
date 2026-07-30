# 本仓库会话规则（最高优先级）

## 🈲 语言强制：一切输出必须用中文

本仓库为家族办公室投资状态库，所有者为中文用户。**在本仓库内运行的任何会话（含定时简报任务、交互会话、异常路径运行报告），面向用户的一切文字输出必须使用中文，无任何例外。**

- 覆盖范围：简报正文、运行报告、进度说明、异常/中断/重复触发说明、工具或 git 报错的转述、提问与建议——全部中文。
- 异常路径不豁免：哪怕本次运行没有产出简报（如发现重复触发、同步被拦、决定跳过），对用户的说明照样全程中文。历史教训（2026-07-10）：一次异常路径运行的报告全篇英文，用户明确要求写死本规则。
- 英文仅允许出现在：标的代码与专有名词（IWDA、Fed、Resend id 等）、引用的原文片段、命令与代码本身、git commit message（如 "briefing: YYYY-MM-DD am" 固定格式）。
- 违反本条 = 任务不合格，与漏做归档/邮件收尾同级。

## 🔴 取数数据链（委托人直令 2026-07-30·〔M〕401／402·一切取数场合适用）

**委托人原文**：「所有取数优先用 fmp，fmp 查不到的例如非美数据优先通过网页查询例如腾讯自选股等其它网页，最后确实查不到才走 bigdata」

**三层链序 —— 顺序固定，不得跳层，不得改序：**

1. **FMP 连接器 —— 一切取数之首选。**
   常用端点（2026-07-30 实测·Starter 档可用）：`chart/historical-price-eod-light`（行情）／`statements`（财报三表·key-metrics-ttm）／`company/profile-symbol`／`analyst/price-target-consensus`／`calendar/earnings-company`／`secFilings/search-by-symbol`（**直返 SEC accession 与原文链**）／`commodity`（GCUSD 黄金）／`forex`（USDHKD、USDCNY、GBPHKD）／`economics/treasury-rates`／`etfAndMutualFunds/information`／`news`。
   **⚠️ 已知边界，不必再试直接走第 2 层**：**FMP Starter 只覆盖美国上市标的**——`0700.HK`／`0005.HK`／`IWDA.L`／`SGLN.L`／`IGLN.L`／`159516.SZ`／`159819.SZ`／`159142.SZ` 一律在参数层被拒。另：`batch-quote` 需 Premium+，单标的 `quote` 可用。

2. **FMP 查不到者 → 网页（涵盖全部非美标的）。**
   - **A股/A股ETF**：腾讯自选股 `https://qt.gtimg.cn/q=sz159516,...`（**GBK，须 `| iconv -f gbk -t utf-8`**）或 a-stock-data 技能；指数 PE（931743 等）走中证官网 `www.csindex.com.cn` 官方日度序列。
   - **港股**：腾讯自选股 `https://qt.gtimg.cn/q=r_hk00700,r_hk00005`（收盘后即终值）。
   - **伦交所/爱尔兰注册 ETF（IWDA／SGLN／IGLN）**：发行人官网（iShares 基金页）取 NAV，**标 T-1 与官方口径**。**⚠️ 须用 WebFetch 工具取，勿用 curl**——2026-07-30 实测 `curl www.ishares.com` 返 **HTTP 403**、WebFetch 成功。腾讯/新浪/stooq 均不覆盖伦交所。
   - **黄金现货交叉源**：新浪财经 `https://hq.sinajs.cn/list=hf_GC`（**须带 `-H "Referer: https://finance.sina.com.cn"`**）。
   - 其余：交易所／公司 IR／监管备案 优先于一般 web 检索。

3. **确实查不到，才走 Bigdata.com —— 最后兜底**，不得作首选或第二顺位。

**二源交叉印证之硬约束**：Bigdata 之行情段自陈 `source: fmp`，故**以 Bigdata 复核 FMP 不构成任何印证**。凡关键数字（**下单前现价／红线权重／门槛边界值**），**第二源必须取第 2 层**（腾讯自选股／新浪／官方 IR／交易所）；**动钱前须重取现价**。

**取数纪律**：每个数字标注 **as-of 日期时点 ＋ 来源**；美股盘中取数须注明**系盘中值非最终收盘**（机械判据＝当日成交量显著低于前两日）；**取不到就如实报「未取到」，绝不以推断、旧值或 web 拼凑充作实测**。

## 仓库要点

- `portfolio-state.md` 是唯一权威状态来源，任何分析前先完整读取。
- `routines/` 存放早/晚简报 prompt 存档；`briefings/` 存放历史简报归档。
- 台账判断类条目落库须附裁决来源（见 portfolio-state.md 治理规则）。

---
*恢复注（2026-07-21）：本文件系2026-07-10用户指令写死之仓库级语言规则（原commit `f576999`·claude/focused-galileo-xj9nn8），因该会话分支从未归并而始终未落master；2026-07-21分支清理取证时发现，委托人「恢复」终裁后按原文恢复（〔M〕221）。*
