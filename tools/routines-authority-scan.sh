#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# routines/ 与 .claude/agents/ 之授权链扫描（**CGM 自捕·2026-08-01·CR-20260801-29**）
#
# 🔴 立此器之由 —— **原 ③ 锚方向是反的，须整条换掉，不是调参**：
#   `dim2-review.sh` 之 ③「无越权」原以 `git log -S<ADJ编号> -- routines/ .claude/agents/`
#   判某回执是否越权，实测 13 件命中。**逐一验其引文，13 件全系伪影**：
#     routines/weekly-retro-sunday-prompt.md → 「ADJ-0726-02⑧立·**GM授权routines变更**」
#     routines/evening-2100sgt-prompt.md     → 「晚场固定动作（**ADJ-0721-12②**）」
#   即：routine 内出现 ADJ 编号，**其最常见成因恰是该 ADJ 授权了这次改动**。
#   该谓词测的是「引用」，与「擅动」之相关性**为负**——
#   **它把授权链留痕最完整的那些件挑出来当嫌犯，而真越权（改了却不引任何授权）一件不检。**
#
# 🔴 故真谓词在 **commit 层**，不在回执层：**凡改 routines/ 或 .claude/agents/ 之 commit，
#   其 commit message ∨ 同 commit 之改动文本内，须见授权引据**（ADJ 编号／委托人直令／〔M〕号）。
#   **引据不在者 ＝ 越权候选**。R8（GM 2026-08-01 裁「特别不为一般所吸收」）之真载体在此。
#
# 🔴 本器之限度（**须与读数同引**）：
#   (a) 它只核**引据之在否**，不核该引据**是否真授权了这一处改动**——
#       引一个不相干的 ADJ 编号即可骗过本器。**「有引据」≠「引据成立」。**
#   (b) 委托人口头直令**不必在库内留痕**，故「无引据」不等于「无授权」，
#       只等于**该次改动之授权不可由库面复核**——这本身即是须报之事实。
#   (c) 本器不判罚、不销项，只出候选表。判在人。
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "routines 授权链扫描"; exit 3; fi

python3 - <<'PYEOF'
import io, re, subprocess, sys

PATHS = ['routines/', '.claude/agents/']
# 授权引据之形态：ADJ 编号／委托人直令／台账〔M〕号／GM 明示授权
AUTH = re.compile(r'ADJ-\d{4}-\d+|委托人(直令|指令|令|「)|〔M〕\s*\d+|GM\s*(授权|令|裁)|用户指令')

log = subprocess.run(
    ['git', 'log', '--format=%H%x1f%ad%x1f%s%x1f%b%x1e', '--date=short', '--', *PATHS],
    capture_output=True, text=True).stdout

recs = []
for blk in log.split('\x1e'):
    blk = blk.strip('\n')
    if not blk:
        continue
    parts = blk.split('\x1f')
    if len(parts) < 4:
        continue
    sha, date, subj, body = parts[0], parts[1], parts[2], parts[3]
    files = subprocess.run(['git', 'show', '--format=', '--name-only', sha, '--', *PATHS],
                           capture_output=True, text=True).stdout.split()
    if not files:
        continue
    # 授权引据两处找：commit message，与本次 diff 之新增行
    diff = subprocess.run(['git', 'show', '--format=', '-U0', sha, '--', *PATHS],
                          capture_output=True, text=True).stdout
    added = '\n'.join(l for l in diff.split('\n') if l.startswith('+') and not l.startswith('+++'))
    in_msg = bool(AUTH.search(subj + '\n' + body))
    in_diff = bool(AUTH.search(added))
    recs.append((sha, date, subj, files, in_msg, in_diff))

recs.reverse()  # 依时序
naked = [r for r in recs if not r[4] and not r[5]]
msg_only = [r for r in recs if r[4] and not r[5]]

L = []; A = L.append
A('# `routines/` 与 `.claude/agents/` 授权链扫描')
A('')
A('> **🔴 本器系换掉一条方向为反之锚，非新增一层检查。**')
A('> 原 `dim2-review.sh` ③ 以「routine 内提及某 ADJ 编号」判该件越权，实测 13 件命中，')
A('> **逐一验其引文，13 件全系伪影**——引文之内容恰是「GM授权routines变更」等授权留痕。')
A('> **该谓词把授权链留痕最完整的件挑出来当嫌犯，而真越权一件不检。**')
A('')
A('> **限度（须与读数同引）**：(a) 只核引据之**在否**，不核其**是否真授权了这一处改动**——')
A('> 引一个不相干之编号即可骗过本器，**「有引据」≠「引据成立」**；')
A('> (b) 委托人口头直令不必在库内留痕，故「无引据」≠「无授权」，')
A('> 只等于**该次改动之授权不可由库面复核**——此本身即须报之事实；(c) 不判罚、不销项，判在人。')
A('')
A(f'**扫描范围**：`{"` / `".join(PATHS)}`｜**触及之 commit 共 {len(recs)} 个**')
A(f'｜**读取 tip ＝ `{subprocess.run(["git","log","-1","--format=%H"],capture_output=True,text=True).stdout.strip()}`**')
A('')
A('## 〇 · 🔴 本器之 ✅ 不足采信 —— **同日同笔之实证反例**')
A('')
A('**`d26c8b9`（2026-08-01·`routines/weekly-retro-sunday-prompt.md`）本器读 ✅✅**——')
A('msg 与档内皆见授权引据。**而 GM 同日就该笔径裁**：')
A('> 「**特别不为一般所吸收**。`d26c8b9` 之改动**在补 ADJ 或委托人一字之前，不得援为任何流程之依据**。」')
A('')
A('**同一天、同一笔，本器判过、GM 判不过。** 故限度 (a) 非假想而系实测：')
A('**本器之 ✅ 只证「引了点什么」，不证「引据成立」** —— 与审查员 v2.1「🟢 只等于本轮没看见」同构。')
A('**凡引本表之 ✅ 栏，须连引本节。**')
A('')
A('## 一 · 🔴 无任何授权引据者（**越权候选**）')
A('')
# 规则生效日：库面最早明书「动 routines/ 须 ADJ 授权」者 ＝ ADJ-0722-05②（2026-07-22，
# 见 docs/cc-knowledge.md:250）。其前之改动**不构成违反当时不存在之规**，
# 但仍列出——**「当时无规」是抗辩，不是不必列**。
RULE_DAY = '2026-07-22'
if not naked:
    A('**0 个。** —— 惟照 §〇，此读数只证「每次改动都引了点什么」，**不证那些引据成立**。')
else:
    post = [r for r in naked if r[1] >= RULE_DAY]
    A(f'**共 {len(naked)} 个；其中规则生效日（**{RULE_DAY}**·`ADJ-0722-05②` 首次明书')
    A(f'「动 `routines/` 须 ADJ 授权」）**之后者 ＝ {len(post)} 个**。')
    A('**其前者不构成违反当时不存在之规——惟「当时无规」系抗辩，不是不必列。**')
    A('')
    A('| 日 | 规则后? | commit | 题 | 所改之档 |')
    A('|---|:--:|---|---|---|')
    for sha, date, subj, files, _, _ in naked:
        A(f'| {date} | {"🔴 是" if date >= RULE_DAY else "— 否"} | `{sha[:9]}` | {subj[:55]} '
          f'| {" / ".join("`%s`" % f for f in files[:3])} |')
A('')
A('## 二 · 仅 commit message 有引据、改动文本内无者')
A('')
A('**该形态之弱点**：commit message **不入档**——日后读 `routines/` 者见不到授权来源，')
A('**须回溯 git 方知其所据**。库面自证性弱于「引据写进档内」。')
A('')
if not msg_only:
    A('**0 个。**')
else:
    A(f'**{len(msg_only)} 个**：')
    A('')
    A('| 日 | commit | 题 |')
    A('|---|---|---|')
    for sha, date, subj, _, _, _ in msg_only:
        A(f'| {date} | `{sha[:9]}` | {subj[:70]} |')
A('')
A('## 三 · 全表')
A('')
A('| 日 | commit | msg 有据 | 档内有据 | 所改之档 |')
A('|---|---|:--:|:--:|---|')
for sha, date, subj, files, in_msg, in_diff in recs:
    A(f'| {date} | `{sha[:9]}` | {"✅" if in_msg else "—"} | {"✅" if in_diff else "—"} '
      f'| {" / ".join("`%s`" % f for f in files[:3])} |')
io.open('docs/internal-audit/routines-authority-scan.md', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print(f'→ 触及 routines/agents 之 commit {len(recs)} 个｜🔴 无引据 {len(naked)}｜仅 msg 有引据 {len(msg_only)}')
PYEOF
