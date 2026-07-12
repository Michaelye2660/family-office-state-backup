# CGM commit签名装配指引（〔M〕19c复议·委托人终裁选项(b),2026-07-12 · 严格遵N8:密钥零经对话）

## 分工申报（先说清边界）
- **本方案覆盖**：CGM侧全部commit（本会话+早/晚/周日routine班次）——装配后均带SSH签名,GitHub显示Verified。
- **本方案不覆盖（诚实局限,如实入册）**：GM侧connector commit——claude.ai连接器写入路径产品层无签名能力,GM身份锚仍=approvals.md亲笔登记+去手隔离+L7检测。选项(b)修复的是CGM侧身份链与"Unverified常态"的整体证伪面,不是GM侧指纹。
- **N8合规设计**：私钥由委托人本地生成→亲手存入claude.ai/code环境变量（产品级秘密管理）→容器内由setup脚本装配。全程不经任何AI对话、不入仓库。〔M〕19b/19c历史失败（密钥曾过对话）之教训即此。

## 委托人操作（一次性,约5分钟,全部在您本地/浏览器完成）

**第1步·本地生成签名密钥**（终端执行,Mac/Linux/WSL均可）:
```
ssh-keygen -t ed25519 -f fo-signing -N "" -C "fo-cgm-signing"
```
生成两个文件:`fo-signing`（私钥）与 `fo-signing.pub`（公钥）。

**第2步·公钥登记到GitHub**：
GitHub → 右上头像 → Settings → SSH and GPG keys → **New SSH key** → Key type 选 **Signing Key**（不是默认的Authentication Key!）→ Title填 `fo-cgm-signing` → 粘贴 `fo-signing.pub` 内容 → Add。

**第3步·私钥存入环境变量**（与RESEND_API_KEY同一个地方）:
终端执行 `base64 -w0 fo-signing`（Mac用 `base64 -i fo-signing`）,复制输出的单行字符串;
claude.ai/code → 云图标 → 环境 → gear → 环境变量 → 新增 `GIT_SIGNING_KEY_B64` = 该字符串。

**第4步·setup脚本加装配段**（同一环境设置页的 setup script 栏,末尾追加）:
```
if [ -n "$GIT_SIGNING_KEY_B64" ]; then
  mkdir -p ~/.ssh
  echo "$GIT_SIGNING_KEY_B64" | base64 -d > ~/.ssh/fo-signing
  chmod 600 ~/.ssh/fo-signing
  git config --global gpg.format ssh
  git config --global user.signingkey ~/.ssh/fo-signing
  git config --global commit.gpgsign true
fi
```

**第5步·本地清理**：`fo-signing` 私钥文件在完成第3步后即可从本地删除（或妥存离线备份）;公钥无所谓。

## 生效机制
环境变量与setup脚本只作用于**新容器**（会话≠容器,见SECRETS-INVENTORY备忘）——routine班次每次运行即新容器,立即生效;本CGM长期会话在下一次容器自然更换后生效。CGM在每次发现容器更换时自检 `git config commit.gpgsign` 并向委托人报一句签名状态。

## 验证与轮换
- 验证：装配后任一新commit在GitHub页面应显示 **Verified** 徽章。
- 轮换：重复第1-3步生成新钥替换;GitHub侧删旧Signing Key。登记于 docs/SECRETS-INVENTORY.md。
