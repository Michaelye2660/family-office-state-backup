# 秘密资产清单（SECRETS INVENTORY）

> 遵〔N〕N8 秘密传输禁令：本清单仅登记名称/用途/再生成路径，**绝不含任何秘密值**。

| 名称 | 用途 | 存放位置 | 再生成/轮换路径 |
|---|---|---|---|
| RESEND_API_KEY | 每日简报邮件发送（settings.json 白名单流程） | claude.ai/code 环境变量（personal） | resend.com 后台轮换 → 更新环境变量 |
| GIT_SIGNING_KEY_B64 | CGM commit SSH签名（〔M〕19c复议选项b,2026-07-12) | claude.ai/code 环境变量（base64单行） | 本地重新ssh-keygen→GitHub Signing Key替换→更新环境变量（流程见docs/signing-setup.md） |
| GitHub官方MCP连接器（OAuth） | 裁决侧直连读写私库 + CC 侧 github MCP | claude.ai 连接器配置 | GitHub侧Revoke + claude.ai重连（流程详见〔M〕15修订注"存档备后来者"） |

- 环境签名密钥：已作废，不再登记（ADJ-0711-10R②）
- 新增秘密时在此登记一行；值永不入库、永不入对话记录（N8）

## 环境变量注入机制备忘（2026-07-12·实测）

- **会话≠容器**：claude.ai/code 的对话（session）可长期存续；其执行容器（container）为临时环境，闲置后自动回收，下次消息自动新建容器（仓库重新clone+**环境变量重新注入**）。
- 因此**轮换任何环境变量后，正在活跃的旧容器不会热更新**——旧容器里仍是旧值，直至该容器自然回收。routine 班次每次运行均为新容器，轮换即时生效；长期CC对话则在下一次容器更换时自动跟上，无需任何操作。
- **有效性检测协议**（不打印值，遵N8）：`curl -sS -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $RESEND_API_KEY" https://api.resend.com/domains` → 200=新key生效，401=容器仍持旧key。
- 判例：2026-07-12 key轮换后，长期CC对话所在旧容器实测401（预期行为，非故障）；简报邮件由routine新容器发送，不受影响。
