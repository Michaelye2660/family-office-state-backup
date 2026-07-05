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

## 待办

白名单放行并实测 159516 通过后，再把两个每日简报 routine 的 prompt 中
A 股数据来源改为「优先 a-stock-data 技能、web 搜索兜底」
（在 claude.ai/code/routines 编辑，或让 Claude 重建 trigger）。
