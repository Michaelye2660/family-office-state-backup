#!/bin/bash
# ══════════════════════════════════════════════════════════════════
# a-stock-data 技能安装片段
# 用途：粘贴到 Claude Code 云环境 "personal"（env_0113VSKPrc8R7rY4KaapqLzB）
#       的 Setup script 里（追加到现有内容末尾即可）。
# 位置：claude.ai/code → Settings → Environments → personal → Setup script
# 说明：云容器是临时的，每次会话/routine 启动都会重新执行本脚本，
#       所以技能文件和 pip 依赖都要在这里装，才能被每日简报 routine 用到。
# ══════════════════════════════════════════════════════════════════

# 1) 安装 a-stock-data 技能（优先用仓库内副本，取不到再从 GitHub 拉）
mkdir -p ~/.claude/skills/a-stock-data
if [ -f "$(pwd)/.claude/skills/a-stock-data/SKILL.md" ]; then
  cp "$(pwd)/.claude/skills/a-stock-data/SKILL.md" ~/.claude/skills/a-stock-data/SKILL.md
else
  curl -sS --retry 3 https://raw.githubusercontent.com/simonlin1212/a-stock-data/main/SKILL.md \
    -o ~/.claude/skills/a-stock-data/SKILL.md || true
fi

# 2) 安装 Python 依赖（mootdx 在云环境不可用——TCP 7709 出不了代理，
#    但装上无害；实际行情/PE 走腾讯 HTTP 接口 qt.gtimg.cn）
pip install --quiet mootdx requests pandas stockstats || true

# 3) commit归属配置(2026-07-11,〔M〕19c):签名徽章议题已终局放弃——Unverified为本仓库
#    commit永久常态;审计链依赖ADJ编号/[裁决侧]前缀/author归属/diff复核,不依赖GitHub徽章。
#    仅保留author归属对齐(签名密钥装配逻辑已按用户终裁移除):
git config --global user.email "Michaelye2660@users.noreply.github.com" || true
git config --global user.name "Claude (CC执行侧)" || true
