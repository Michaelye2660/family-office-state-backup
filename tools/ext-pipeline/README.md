# EXT 自动摆渡管道（API 制·真金审计线·ADJ-0719-17·task#46）

硬净室审计管道：真金 T1-T4 走 OpenAI API·**每次全新无状态调用=结构性硬净室**（无账户/无记忆/无历史）。
与半自动中转仓线分工：**规则复审走中转仓（软净室·金丝雀兜底）；真金 T1-T4 + EXT-R 走本线（硬净室）**。

## 模块
| 文件 | 职责 |
|---|---|
| `config.py` | 配置：模型/秘钥（只从环境读·严禁入库）/禁词正则 v2/路由阈值 |
| `checker.py` | **出包检查器**（验收必备）：sha1 恒等 + 禁词扫描 v2·任一命中拒发上呈 GM |
| `router.py` | **四档路由** T1 事前必审/T2 事后周审/T3 预授权豁免/T4 委托人「审」点审 |
| `netroom.py` | 净室线（无状态 API）+ EXT-R 受控重放 + 金丝雀首问 + 环境证明表自动生成 |
| `archive.py` | 全程留痕：request+response 全文归档主仓 + sha1 锚定 |
| `pipeline.py` | 编排器：路由→组装→出包检查→（过则）调净室→归档 |
| `verify.py` | 三层核验制层2：月度抽验（sha1+禁词复扫）+ EXT-R 注入清单对表 |
| `selftest.py` | 段一干跑自测（mock 回环·无 key·23 用例） |
| `live_preflight.py` | **段二预检**：key存在/openai包/出网连通/key有效 四项（N8·不打印秘钥值） |
| `live_acceptance.py` | **段二首跑验收 runner**：预检→金丝雀 live 往返→成本实测（`--dry` 可 mock 验证 runner） |

## 两段推进（-17①(b)）
- **段一（已建·无 key）**：全体建成 + 干跑自测（`python3 selftest.py` → 23/23）。**mock 回环·不触 OpenAI。**
- **段二（候委托人「key 已配好」）**：live 联调 + 首跑验收（金丝雀程序确认 + 成本实测首账替换估算）。
  - 配 key：见 `docs/ext/pipeline-setup-guide.md`（平台生成→CC 环境变量 `OPENAI_API_KEY`·**严禁入库**）。
  - **出网白名单**：环境网络策略须放行 `api.openai.com`（2026-07-19 联调实测新发现·setup-guide §二之补）。
  - live 需 `pip install openai`（段一 mock 不需要）。
  - **联调实况**：第一轮 2026-07-19 双阻塞（key 未注入+域名未放行）·工单见 `docs/ext/pipeline-live-acceptance-report.md`。
  - 就绪后一键：`python3 live_preflight.py`（四项全✅）→ `python3 live_acceptance.py --stamp $(date -u +%Y%m%dT%H%M%SZ)`。

## 验收钢印
- **无出包检查器不上线**（-11②·checker.py 内置于每次往返·拒发即 raise `OutboundRejected`）。
- **真金 T1 首用前须 GM 验收签字**（-17①(c)）·验收过→ T1/T4 现役。
- **秘钥纪律**：`OPENAI_API_KEY` 只从环境读·永不硬编码/打印/入库。
- **材料边界（-12④）**：仓位百分比/组合权重/估值倍数放行·绝对金额/身份/托管行拒发。

## 用法（段二·示意）
```python
import pipeline
rt = pipeline.run_review(
    brief_body="<匿名化审计简报·%/权重/倍数·无绝对额>",
    kind="trade", nav_fraction=0.008,   # ≥0.5% → T1
    line="netroom", mode="live", stamp="<外部注入时间戳>",
)
# 出包检查拒发 → raise OutboundRejected（上呈 GM·不调净室）
```

## 日落复议钩（-13(3)）
中转仓存废复议钟自**段二建成日**起算满月（届时复盘半自动中转仓存废/降级）。
