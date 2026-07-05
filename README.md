# family-office-state

家族办公室每日市场简报 routine 的配套仓库。

## a-stock-data 技能（A股行情/PE 数据源）

- `.claude/skills/a-stock-data/SKILL.md` — [simonlin1212/a-stock-data](https://github.com/simonlin1212/a-stock-data) V3.3.0 的仓库内副本。在本仓库打开的会话会自动加载；同时供环境 Setup script 复制到 `~/.claude/skills/`。
- `setup/environment-setup-snippet.sh` — 需要粘贴进云环境 **personal** 的 Setup script（claude.ai/code → Settings → Environments → personal），负责每次容器启动时安装技能文件 + pip 依赖（mootdx / requests / pandas / stockstats）。

## ⚠️ 网络白名单（2026-07-05 实测状态）

环境 personal 的网络策略为白名单制，以下 A 股数据域名当前**全部被拦截**，
需在 claude.ai/code → Settings → Environments → personal → Network access →
Allowed domains 中添加后，技能才能实际取数：

**最低必需（159516 场内价 + PE，腾讯财经）：**

```
qt.gtimg.cn
```

**PE 指标必需（159516 触发器的"PE<40"指标的指数 931743 的估值）：**

```
www.csindex.com.cn
push2delay.eastmoney.com
danjuanfunds.com
```

> 实测(2026-07-05)：ETF 本身无 PE，需查标的指数「中证半导体材料设备主题指数
> (931743)」估值。csindex 为中证官方估值源；push2delay 是东财对海外 IP 的
> 302 重定向域名——不加它，push2 全系（资金流/板块/个股信息）实际不可用；
> danjuanfunds 提供 PE 历史百分位（可选）。

**建议一并添加（技能其余数据层：东财/同花顺/新浪/巨潮/百度）：**

```
push2.eastmoney.com
push2his.eastmoney.com
push2ex.eastmoney.com
datacenter-web.eastmoney.com
reportapi.eastmoney.com
np-weblist.eastmoney.com
search-api-web.eastmoney.com
emappdata.eastmoney.com
pdf.dfcfw.com
basic.10jqka.com.cn
zx.10jqka.com.cn
data.10jqka.com.cn
dq.10jqka.com.cn
data.hexin.cn
hq.sinajs.cn
quotes.sina.cn
stock.finance.sina.com.cn
finance.pae.baidu.com
www.cninfo.com.cn
irm.cninfo.com.cn
```

**mootdx（通达信 TCP 7709）在云环境永远不可用**——代理只放行 HTTPS，
裸 TCP 出不去。技能会自动回退到腾讯 HTTP 接口，不影响行情/PE 获取。

## 组合状态：portfolio-state.md（唯一权威来源）

根目录 `portfolio-state.md` 是项目档案（持仓快照/触发器表/建仓优先级/事件
日历/价格锚/红线/观察清单/筛选卡等〔A〕–〔L〕全部状态）的 single source of
truth，当前 v14.1（2026-07-05）。两个 routine 的 prompt 已不再内嵌状态副本，
每次执行第一步即读取本文件。**持仓/触发器/事件变化只需改这个文件**，
无需再动 routine prompt。

## Routine prompt 存档

`routines/` 下是两个每日简报 routine（早间 09:00 / 晚间 21:00 SGT）当前生效的
prompt 全文备份（2026-07-05 状态迁移版：状态外置到 portfolio-state.md，
prompt 只保留 SOP——扫描步骤/输出格式/纪律；A股数据来源
「优先 a-stock-data 技能、web 搜索兜底」）。日后在 claude.ai/code/routines
改 prompt 时，请同步更新这两个文件。

## 已完成（2026-07-05）

- 白名单已放行全部所需域名，159516 实测通过：场内价走腾讯 `qt.gtimg.cn`，
  标的指数 931743 的官方 PE 走中证 `www.csindex.com.cn`
  （`/csindex-home/perf/index-perf?indexCode=931743&startDate=...&endDate=...`，
  返回字段 `peg` 即市盈率，已用沪深300≈14.5 交叉验证）。
- 状态迁移：项目档案从两个 routine prompt 迁出至 `portfolio-state.md`
  （v14.1，含人工核对6处修正），routine 每次执行先读该文件再跑 SOP。
- 两个 routine 已重建为新 trigger（旧 trigger 已删）：
  早间 `trig_01EFEY15rkCqhPzLSkhv53uz`，晚间 `trig_01N5vmjnYedKMg4Qhfa13qLM`。
