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

# 3) commit签名验证配置(2026-07-11,〔M〕19/19b):
#    环境内置signer的密钥归Anthropic基础设施账号所有,无法注册到用户GitHub("already in use"),
#    改用仓库专属签名密钥:私钥base64存环境变量 COMMIT_SIGNING_KEY_B64,
#    对应公钥(cc-family-office-signing)注册为用户GitHub账号的SSH Signing Key
git config --global user.email "Michaelye2660@users.noreply.github.com" || true
git config --global user.name "Claude (CC执行侧)" || true
if [ -n "$COMMIT_SIGNING_KEY_B64" ]; then
  mkdir -p ~/.ssh
  echo "$COMMIT_SIGNING_KEY_B64" | base64 -d > ~/.ssh/cc_repo_signing
  chmod 600 ~/.ssh/cc_repo_signing
  command -v ssh-keygen >/dev/null 2>&1 || { apt-get update -q >/dev/null 2>&1; apt-get install -y -q openssh-client >/dev/null 2>&1; } || true
  if command -v ssh-keygen >/dev/null 2>&1; then
    git config --global gpg.format ssh
    git config --global gpg.ssh.program ssh-keygen
    git config --global user.signingkey ~/.ssh/cc_repo_signing
    git config --global commit.gpgsign true
  fi
fi
