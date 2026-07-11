# 秘密资产清单（SECRETS INVENTORY）

> 遵〔N〕N8 秘密传输禁令：本清单仅登记名称/用途/再生成路径，**绝不含任何秘密值**。

| 名称 | 用途 | 存放位置 | 再生成/轮换路径 |
|---|---|---|---|
| RESEND_API_KEY | 每日简报邮件发送（settings.json 白名单流程） | claude.ai/code 环境变量（personal） | resend.com 后台轮换 → 更新环境变量 |
| GitHub官方MCP连接器（OAuth） | 裁决侧直连读写私库 + CC 侧 github MCP | claude.ai 连接器配置 | GitHub侧Revoke + claude.ai重连（流程详见〔M〕15修订注"存档备后来者"） |

- 环境签名密钥：已作废，不再登记（ADJ-0711-10R②）
- 新增秘密时在此登记一行；值永不入库、永不入对话记录（N8）
