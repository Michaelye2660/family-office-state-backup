【每周复盘 · pm-retro · 自动任务（周日约 18:00 SGT）】

⚠️ 本任务共4步，第3步=报告归档进仓库 retro/。无邮件步骤（复盘报告不在 settings.json 邮件白名单内，仅归档，裁决侧经 GitHub 直连自取）。

【环境同步 · 每次必做第一步】本任务每次在全新会话中运行。开始前先执行:`git fetch origin master && git reset --hard origin/master`，把工作区强制对齐 master 最新内容。

第0.5步 收件（与每日简报 routine 同协议）：读取 adj-inbox/ 全部文件（README除外），三要素齐备者按台账〔N〕N6 执行并写回执归档；缺要素移 quarantine/ 记〔M〕异常。

第1步 调用 pm-retro 子agent 做本周复盘。输入范围=上次复盘报告以来（首次运行=2026-07-05 建库起）的全部记录：git log（全分支）、portfolio-state.md〔M〕决策日志与〔N〕架构、briefings/ 全部归档、adj-archive/ 回执与 quarantine/、routines/ 存档 prompt、.claude/agents/ 配置。要求其严格按固定四节输出：
① 各角色调用统计与失败事故（data-verifier/bull/bear/risk-devil/scout〔若启用〕各被调用几次，以裁决附录、〔M〕、回执为证据；应调未调、退回、失败逐条列）
② Breach 检查（无裁决来源的判断类条目；绕过裁决前置的🔴建议；未归档的简报；违反三要素的收件处理；[裁决侧]直写是否越出预授权范围）
③ 存档与线上 prompt 一致性核对（无法直读线上时如实标注"待用户提供比对"，不得推定一致）
④ 改进建议清单（按优先级，每条注明依据）

第1.5步 监察官双周审计（ADJ-0711-12R②，2026-07-12增补）：检查 audits/ 内最新报告日期，距今≥13天（或 audits/ 为空）则本班并行调用 constitutional-auditor 子agent 出具本期审计报告，写入 audits/YYYY-MM-DD.md；未满13天则跳过，本班输出末尾注明"监察官：未到双周窗口，本班跳过"。日后如需调整为月度频率，须经ADJ授权变更本步骤，不得自行放宽。
首跑特例：2026-07-12复盘首跑时无条件执行一次基线审计（不受13天窗口限制）——届时若 docs/conversation-archive/ 已有对话档案则一并纳入首审加餐输入；若未落库，首审仅用仓库输入完成，对话加餐部分留待档案落库后的下一班次补审，或由用户口令即时触发补审。

第2步 交叉核对：pm-retro 报告中的每个统计数字抽查至少 2 项原始出处（某份 briefing 的裁决附录/某个 commit），不符处在报告中标注。

第3步 归档：报告全文写入 retro/YYYY-MM-DD-retro.md（当日SGT日期），git add + commit（message形如 "retro: YYYY-MM-DD"）并 push 到 master；失败按 2s/4s/8s/16s 退避重试。

第4步 运行输出末尾固定三行：本周事故数/breach数/动议数；改进建议一律标注"动议·待裁决侧与用户批复"——pm-retro 只读+建议权，任何变更仍走辩论庭+用户批准（元规则），本 routine 不得直接实施任何改进建议。

第5步 周备份（ADJ-0711-10R③授权·N9合规）：执行 `git push https://github.com/Michaelye2660/family-office-state-backup.git master:master`（同账号备份仓，用户已建）；远端异常则在复盘报告中报错提醒，禁止经 API 自建仓（遵N7）；推送结果（成功哈希/失败原因）一行写入当周复盘报告。

══════ 纪律 ══════
① 复盘基于记录，不重跑市场分析；无记录处写"无记录"，不推测。② 报告如实：无事故写"本周无事故"，不为显得有用而制造问题。③ 收件执行仍受 settings.json 白名单、裁决前置规则与台账红线约束。④ 用中文输出。
