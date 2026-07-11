# 秘密资产清单（SECRETS INVENTORY）

> 遵〔N〕N8 秘密传输禁令：本清单仅登记名称/用途/再生成路径，**绝不含任何秘密值**。

| 名称 | 用途 | 存放位置 | 再生成/轮换路径 |
|---|---|---|---|
| RESEND_API_KEY | 每日简报邮件发送（settings.json 白名单流程） | claude.ai/code 环境变量（personal） | resend.com 后台轮换 → 更新环境变量 |
| GitHub 连接器授权（OAuth） | 裁决侧直连读写私库 + CC 侧 github MCP | claude.ai 连接器配置 | GitHub 侧 Revoke → claude.ai 重新连接强制重授权（流程详见〔M〕15 修订注"存档备后来者"） |

- 已作废条目：COMMIT_SIGNING_KEY_B64（签名密钥方案，ADJ v15.34 整体作废，若环境变量残留可删）
- 新增秘密时在此登记一行；值永不入库、永不入对话记录（N8）
