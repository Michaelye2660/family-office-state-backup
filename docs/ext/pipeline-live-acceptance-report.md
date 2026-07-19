# 段二 live 联调工单（task#46·ADJ-0719-17①(b)·真金审计线 API 硬净室管道）

> 状态跟踪件：段二=live 联调+首跑验收（金丝雀程序确认+成本实测首账替换估算）。
> 本件逐轮如实记录联调实况·验收通过后由验收数据定稿·GM 验收签字后 T1/T4 现役。

## 联调第一轮（2026-07-19·CGM·新容器实测）

**结论：live 阻塞·双前置未就位·均须委托人环境侧动作（各约1-2分钟）。**

| # | 检查项 | 实测结果 | 判定 |
|---|---|---|---|
| A | `OPENAI_API_KEY` 环境变量 | 本容器环境**未注入**（仅 RESEND_API_KEY 在位·env 全表核过） | ❌ 阻塞 |
| B | openai 包（段二依赖） | 已装 v2.46.0（requirements.txt·import 通过） | ✅ |
| C | 出网连通 api.openai.com | **出网网关拒绝 CONNECT（403 Forbidden）**=环境网络策略未放行该域名（代理状态页留有 `connect_rejected api.openai.com:443` 记录） | ❌ 阻塞·**新发现** |
| D | key 有效性 | 跳过（前置 A/C 未过） | ⏸️ |

**旁证（非阻塞·环境完好性）**：
- 段一干跑自测复跑 **23/23 全过**（装 openai 包后回归·管道本体无恙）。
- 段二工具链新增两件并 mock 验证通过：`live_preflight.py`（四项预检·N8 合规不打印秘钥）+ `live_acceptance.py`（一键首跑验收 runner·出包检查器内置·tier=CANARY 归档不占 T1-T4 档位）。runner 干跑归档三件 base=`20260719T193249Z-dryrun_CANARY_3cad6f327c0e`（mock 占位·非 live 档）。

**委托人两步（做完回一句即可·不贴任何值）**：
1. **配 key**：环境变量 `OPENAI_API_KEY`（见 setup-guide §一/二·严禁入库）。
2. **放行域名**：同环境设置页网络白名单加 `api.openai.com`（见 setup-guide §二之补·本轮新发现）。
- 注意：两者都只对**新容器**生效（会话≠容器·SECRETS-INVENTORY 备忘）——改完后新开会话或等本容器自然回收。

**就绪后联调序（CGM 一键）**：
```
python3 tools/ext-pipeline/live_preflight.py     # 四项全 ✅
python3 tools/ext-pipeline/live_acceptance.py --stamp $(date -u +%Y%m%dT%H%M%SZ)
```
产出=金丝雀 live 答卷归档（sha1 锚定）+ 真实 token 用量与单次成本实测点 → 验收报告定稿 → **GM 验收签字**（钢印：真金 T1 首用前须签）→ T1/T4 现役·日落钟起算。

---
*编制=CGM·2026-07-19·核实纪律=全部读数系当轮实测·无编造｜秘钥纪律=本件不含任何秘密值（N8）*
