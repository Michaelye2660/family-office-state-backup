# 中转仓建设操作单（委托人操作·ADJ-0719-13 准建·三步）

> **本件=委托人一件事之操作指引**：建中性名私有仓 → ChatGPT connector 授权 → 授权 CGM `add_repo`。**安全命脉=第②步 GitHub 授权页务必"只选这一个仓"·切勿"All repositories"**（此为本方案最大单点风险）。GM 增补四件已并入（仓名中性化/owner 暴露如实/授权范围探针/装载留痕在主仓）。

## 第一步 · GitHub 建中性名私有仓（约 3 分钟）
1. GitHub 右上 **+ → New repository**。
2. **Owner**=你自己的账号（保持默认即可）。
3. **Repository name**=**中性名**·例 `research-review-relay`（或 `rule-review-relay` / `screen-review-inbox` 一类）。
   - **禁用敏感词**：不含 `family-office`／`portfolio`／`assets`／`audit`／`holdings`／`wealth`——仓名本身会被 GPT 看到（GM 增补(a)·防泄"family office"语境）。
4. **Visibility=Private**（务必私有·不可 Public）。
5. **Initialize this repository with**：勾 **Add a README file**（让仓一建好就有护栏文·且 connector 需仓内至少一个文件才好读）。
   - `.gitignore`/`license` 可不选。
6. **Create repository**。
7. 进仓 → 打开 `README.md` → **Edit**（铅笔）→ 写入这一行护栏后 Commit：
   > `本仓仅存放匿名化规则复审材料。禁止一切持仓明细、身份信息、绝对金额、托管行名。违反=事件立案。`
   （GM 采纳的人读护栏·中转仓是货舱不是账本。）

## 第二步 · ChatGPT connector 授权本仓（约 3 分钟·⚠️命脉步）
> ChatGPT 的 GitHub 连接入口随版本在 **Settings → Connectors**（或使用 GitHub 相关功能时弹出授权）。无论从哪进·**真正的安全闸在 GitHub 弹出的 OAuth 授权页**——所有连接器都走这一页。
1. ChatGPT → **Settings（设置）→ Connectors（连接器）→ 找 GitHub → Connect/Authorize**。
2. 跳到 **GitHub 授权页**·关键在这一屏：
   - GitHub 会问 **Repository access**：给两个选项——
     - ❌ **All repositories**（所有仓库）——**绝对不要选**（会把主仓 `family-office-state` 一并敞给 GPT=授权范围事故）。
     - ✅ **Only select repositories**（仅选定仓库）——**选这个**·然后在下拉里**只勾 `research-review-relay` 这一个**。
   - 权限尽量 **read-only（只读）**——GPT 只需读·不需写。
3. **Authorize / Install** 完成。
4. **⚠️ 授权范围探针（验收必备·GM 增补(c)）**：授权后·在 ChatGPT 里开一句问它：
   > **"列出你当前可访问的全部仓库。"**
   - ✅ 答案**只有 `research-review-relay` 一个** → 授权范围正确·可用。
   - 🔴 答案里**出现 `family-office-state` 或任何别的仓** → **授权范围事故**·立即回 GitHub → **Settings → Applications → 撤销该授权**·重做第二步（只勾一个仓）·并告诉我立案。
   - 此探针**季度复打一次**（防日后被改成 All）。

## 第三步 · 授权 CGM 读本仓（约 2 分钟）
> CGM（我·Claude Code）经 **Claude 的 GitHub App** 访问仓库·本会话现仅授权到主仓。加新仓两步：
1. 把 **Claude GitHub App 的仓库访问**扩到新仓：
   - GitHub → **Settings → Applications → Installed GitHub Apps → Claude**（或 Claude Code）→ **Configure**。
   - **Repository access** → **Only select repositories** → 勾上 `research-review-relay`（保留主仓·**加一个不是换一个**）→ Save。
   - （或到 https://claude.ai/admin-settings 的 GitHub 设置里给新仓授权。）
2. 回来**告诉我仓名一句话**（如"仓建好了·`research-review-relay`"）→ 我 `add_repo` 拉进本会话。
   - **不用**把任何 token/PAT 发我（秘钥纪律·我走 App 授权不走 PAT）。

## 我接手后（CGM 侧·你不用管）
- 搬 **出包检查器**（sha1 恒等+禁词扫描·过渡期先手动匿名化把关+逐件申报）+ **匿名化简报模板** 进新仓；
- **装载留痕在主仓 EXT 档**（每次写入何件/sha1/把关结果·中转仓是货舱不是账本·GM 增补(d)）；
- 跑一次**自检往返**：授权范围探针 + 金丝雀 + sha1 + 禁词扫描全过 → sha1 锚定报你验收；
- **首投=EXT-08 v2**（过渡期**仅此一件**·第二件起须检查器就位·GM 限量条款）。

## 用途与边界（钢印·勿越）
- 本仓**限规则复审软净室用途**——真金审计 T1-T4／EXT-R 常驻线**不走本仓**·守 API 硬净室（宪章§三）。
- 本仓**永不装**持仓明细/身份/绝对金额/托管行名/台账本体——只放匿名化规则复审简报（机制事实/百分比/估值倍数）。
- **日落复议钩**：API 管道建成满月·复盘本中转仓存废/降级（防三线并存固化增生）。

---
*编制=CGM·2026-07-19·ADJ-0719-13｜三步=建中性名私有仓→connector授权只选一个仓→授权CGM add_repo｜命脉=GitHub授权页切勿All repositories·授权范围探针验收必备季度复打｜关联=审计治理宪章§三中转仓线·〔M〕172*
