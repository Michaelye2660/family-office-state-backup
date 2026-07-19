# 摆渡管道配置指引（OpenAI API key·委托人操作·ADJ-0719-10②"CGM出配置指引随建设包"）

> **本件=委托人一件事之操作指引**：生成 OpenAI API key + 配置进 CC 环境。**秘钥纪律（-10②(i)/-11①）=key 严禁入库入档**——key 只进环境变量·永不进 git/台账/任何文件。本指引本身不含 key。

## 一、生成 API key（委托人·约3分钟）
1. 登录 **platform.openai.com**（你的 OpenAI 账号·与 ChatGPT 账号可同可不同·建议独立计费账号便于隔离成本）。
2. 左栏 **API keys**（或 Settings → API keys）→ **Create new secret key**。
3. 命名建议 `family-office-ext-pipeline`（便于日后审计/吊销识别）。
4. **Project 归属**：建议新建一个 project（如 `ext-audit`）·把 key 限定在该 project·便于单独看成本与设限额。
5. 点 Create → **密钥只显示一次**（`sk-...`）·**立即复制**（关掉就再也看不到·丢了只能吊销重建）。
6. （强烈建议）同页 **设 usage limit / budget**：给这个 project 设月度硬上限（如 $50）·防意外跑量——这是最省心的成本护栏。

## 二、配置进 CC 环境（委托人·约2分钟·关键=不入库）
- **不要**把 key 贴进任何仓库文件、ADJ、台账、聊天里发我（发我=入档=破秘钥纪律）。
- 在 **Claude Code on the web 的环境配置**里加一个**环境变量**：
  - 名称：`OPENAI_API_KEY`
  - 值：你刚复制的 `sk-...`
- 路径：环境设置 → Environment variables（环境变量）→ 新增。参考 https://code.claude.com/docs/en/claude-code-on-the-web （环境/env var 配置节）。
- 保存后·该 key 只在容器运行时以环境变量存在·**不落盘、不进 git**——我建管道时代码读 `os.environ["OPENAI_API_KEY"]`·永不硬编码、永不打印。

## 二之补、出网白名单（委托人·约1分钟·**2026-07-19 段二联调实测新发现·与 key 同为硬前置**）
- **实测事实**：CC 云容器出网走环境网关·默认策略**拒绝 `api.openai.com` 的 CONNECT（403）**——即使 key 配好·live 调用也出不去。段二联调第一轮（2026-07-19）即卡在此（+key 未注入·双阻塞·见 `pipeline-live-acceptance-report.md`）。
- **操作**：同一环境设置页（claude.ai/code → Settings → Environments → personal）的 **Network access / 域名白名单**里·放行域名 **`api.openai.com`**（若当前策略为受限模式）。参考同上 docs 页"网络策略"节。
- **生效方式与 env var 相同**：改完只对**新容器**生效·活跃旧容器不热更新（SECRETS-INVENTORY 备忘·会话≠容器）。
- **配好后验证（一条命令·N8 合规不打印任何秘钥值）**：
  `python3 tools/ext-pipeline/live_preflight.py` → 四项〔A key存在/B openai包/C 出网连通/D key有效〕全 ✅ 即可首跑。

## 二之再补、账户额度/计费（委托人·约2分钟·**2026-07-19 段二联调第三轮实测新发现·与 key 同为硬前置**）
- **实测事实**：key 认证有效（/v1/models 得 200）**不等于**能发生成调用——账户无可用额度时·Responses API 返回 **HTTP 429·error.code=`insufficient_quota`**。段二联调第三轮（2026-07-19）预检四绿后即卡在此（见 `pipeline-live-acceptance-report.md` 第三轮）。
- **操作**：platform.openai.com → **Settings → Billing** → 绑卡或预付充值（最低 $5 即可起步；金丝雀单次成本按下节估算 < $0.1）。若已按 §一(6) 设了 project 预算上限·确认上限 > 0 且未耗尽。
- **生效即时·无须动 key·无须动环境**（此项在 OpenAI 平台侧·与容器无关）。
- 就绪后任一会话直接跑 §二之补 的预检 + `live_acceptance.py` 即可。

## 三、配好后告诉我（一句话即可）
- 你只需回一句"**key 已配好**"（**不要贴 key 本身**）·我即启 task#46 建管道：
  - 出包检查器（sha1 恒等 + 禁词扫描·-11①层1·验收必备·无检查器不上线）；
  - 净室线（无状态调用·硬净室）+ EXT-R 线（受控上下文）；
  - 首用 = EXT-08 v2 投放（自动首跑）。
- 我建成后跑一次**自检往返**（金丝雀 + sha1 + 禁词扫描全过）·把往返档 sha1 锚定报你验收。

## 四、成本申报（CGM 实时核实·2026-07-19·非编造）
**模型**：EXT 净室审计用 **GPT-5.6**（家族 GA 2026-07-09·1M 上下文·"Thinking"=同模型 ID 提高 reasoning effort·**不改单价·改的是一次请求用多少 token**）。三档单价（每 1M token·[来源见文末]）：

| 档 | 输入 | 输出 |
|---|---|---|
| **Sol（旗舰·EXT 审计建议档）** | $5 | $30 |
| Terra（中档） | $2.50 | $15 |
| Luna（预算档） | $1 | $6 |

**单次 EXT 往返粗算**（Sol·Thinking 高 effort）：
- 输入（简报~3-5KB≈1-2K token）：≈ $0.01。
- 输出（答卷~20-27KB≈7-10K token + reasoning token·Thinking 下总输出常 ~20-40K token）：≈ **$0.6–1.2/次**。
- **单次 EXT 审计 ≈ $0.6–1.3**（输出主导·Thinking effort 越高越贵）。

**月度粗估**（按当前节奏·**估算·实际随件数/effort 浮动**）：
- EXT 复审（近期密集~每周 3-5 件·常态更低）+ 真金审计 T1/T4（价值投资者交易频率低·每月数件）→ **约 $10–50/月**（Sol）；若审计包大、Thinking effort 高、件数上升·可能 up to ~$100/月。
- **省钱杠杆**：非关键复审可用 Terra（半价）；用 project 月度硬上限兜底；批量/低频节拍本就压成本。

**诚实标注**：以上系 CGM 按公开单价 + EXT 历史件体量之**估算**·非账单实测；建成后首月我出**实际 token 账单读数**替换本估算（管道全程留痕·可精确统计）。

---
*编制=CGM·2026-07-19·ADJ-0719-10②｜秘钥纪律=key 永不入库入档·只进环境变量｜成本=实时公开单价估算·首月账单落地后替换*

## 来源（定价·2026-07 核实）
- [OpenAI API Pricing](https://developers.openai.com/api/docs/pricing)
- [GPT-5.6 Pricing July 2026 — Sol $5/$30, Terra $2.50/$15, Luna $1/$6](https://www.aipricing.guru/openai-pricing/)
- [OpenAI sets GPT-5.6 pricing $5 input/$30 output (Sol) three-tier](https://cryptobriefing.com/openai-gpt-56-pricing-tiers/)
