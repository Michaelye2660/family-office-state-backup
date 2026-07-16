# VENDORED · ai-berkshire 子集（moat弹药持久化·ADJ-0716-06①）

> **本目录=上游 ai-berkshire 之 vendored 子集**（纯文件层·moat研究方法论弹药）。落库依据=CC-0713-02终裁（委托人"准"·2026-07-16·ADJ-0716-06）。

## 上游与锁定
- **上游 URL**：https://github.com/xbtlin/ai-berkshire
- **锁定 hash**：`e7a912a55f32`（〔M〕62锁定HEAD·2026-07-13;本次vendor自容器内 `/home/user/ai-berkshire` 该hash副本直取,源 `git rev-parse HEAD`=e7a912a55f32核对一致）
- **许可**：MIT（见本目录 `LICENSE` 原文·上游 12,958★@2026-07-13）

## vendored 内容（子集·非全仓）
- `skills/` — 19 个方法论 skill（md）：bottleneck-hunter / deep-company-series / dyp-ask / earnings-review / earnings-team / financial-data / industry-funnel / industry-research / investment-checklist / investment-research / investment-team / management-deep-dive / news-pulse / portfolio-review / private-company-research / quality-screen / thesis-drift / thesis-tracker / wechat-article
- `tools/` — 9 个脚本（含 **financial_rigor.py**=财务严谨性检查主件;余：ashare_data / log-command.sh / momentum_backtest[_v2] / morningstar_fair_value / report_audit / stock_screener / xueqiu_scraper）
- `LICENSE` — MIT 原文
- **不 vendored**：edgartools（pip包·走 venv 隔离装配,见 `tools/setup-moat-env.sh`·ADJ-0716-06②）;上游其余目录（reports/research/codex-*/等·非moat弹药）

## 供应链纪律（两条·写死）
1. **勿直改上游文件**——本目录内文件系上游只读镜像;需改进方法论走 moat 团队自研文件（docs/moat/），不改 vendored 原件。
2. **升级须走 ADJ、不自动拉新**——升级 vendored 版本（换锁定hash）须经 ADJ 授权+委托人裁,不得自动 `git pull` 上游新提交;升级时更新本文件锁定hash并核对。

## 用法
- **skills**：moat 研究直接读 `vendor/ai-berkshire/skills/*.md`（方法论蒸馏血统·见 moat-researcher-knowledge.md §四），无需安装。
- **tools/financial_rigor.py**：财务严谨性检查,调用见 moat 工作指引 §五工具链。
- **edgartools**（美股财报法证 EDGAR 工具）：不在此目录,走 `tools/setup-moat-env.sh` venv 隔离装配（防污染系统 httpx）。
