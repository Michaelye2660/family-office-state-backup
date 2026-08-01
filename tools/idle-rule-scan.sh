#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 空转规则扫描器（`ADJ-0726-03③` 之补办 · 令下 2026-07-26 · **逾期 7 日** · 2026-08-02）
#
# 🔴 原令：「令 CGM 对现存全部治理规则逐条跑〔七问〕测试，出「**空转规则清单**」并按可修复性分档。」
#   七问 ＝ 触发事件／责任人／具体动作／不可伪装凭据／凭据与主张匹配之判定／未做之后果／
#   **一月后如何知其在运行**。
#
# 🔴 本器只答第七问，**不答其余六问** —— 先列不覆盖处，免「未报」被读作「已核无事」：
#   第七问「一月后如何知其在运行」**是七问中唯一可机械化者**：
#   **有器跑它 → 一月后看器之读数即知；无器跑它 → 只能靠人记得，即空转候选。**
#   其余六问（责任人是否明确／凭据是否不可伪装／未做之后果是否真存在…）**皆须判断，本器不代**。
#   **故本器之产出系「空转候选」，不是「空转规则清单」之定稿** —— 差一道判断，那道判断不在本席。
#
# 🔴 本器之已知漏检面（自曝在先）：
#   ①只取 🔴 行为规则集 —— **本仓并非每条硬约束都带 🔴**，非 🔴 之规则一概不入视野；
#   ②「有器跑它」之判据系**关键词落在 tools/ 内**，**关键词命中 ≠ 该器真在跑那条规则**
#      （同 `routines-authority-scan` 之限度 (a)：**有引据 ≠ 引据成立**）；
#   ③**跑不跑得起来 ≠ 有没有在跑** —— 器存在而从未被调用者，本器读作「有器」。
#      **此系本器最大之高估方向：它会把空转报少，不会报多。**
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

python3 - <<'PYEOF'
import io, os, re, glob, subprocess

SRC = ['docs/adjudication-lanes.md', 'docs/state-core.md', 'docs/cc-knowledge.md',
       'docs/succession/gm-succession.md', 'docs/moat/moat-researcher-knowledge.md']
tip = subprocess.run(['git', 'log', '-1', '--format=%H'], capture_output=True, text=True).stdout.strip()

# 器侧全文（tools/ ＋ routines/ ＋ agents）——「谁在跑它」之搜索面
runner = ''
for p in glob.glob('tools/*') + glob.glob('routines/*.md') + glob.glob('.claude/agents/*.md'):
    if os.path.isfile(p):
        runner += io.open(p, encoding='utf-8', errors='replace').read() + '\n'

# 规则之指纹：取 🔴 行内之 ADJ 编号／CR 号／器名／专名词组
ADJ = re.compile(r'ADJ-\d{4}-\d+|CR-\d{8}-\d+|`([a-zA-Z0-9_\-]+\.(?:sh|py|md))`')
rows = []
for src in SRC:
    if not os.path.exists(src):
        continue
    for i, l in enumerate(io.open(src, encoding='utf-8', errors='replace').read().split('\n'), 1):
        if '🔴' not in l or re.match(r'^#{1,4}\s', l):
            continue
        keys = [m.group(0).strip('`') for m in ADJ.finditer(l)]
        if not keys:
            rows.append((src, i, l.strip(), '—', '⚠️ 无可机械追之锚'))
            continue
        hit = [k for k in keys if k in runner]
        rows.append((src, i, l.strip(), '／'.join(keys[:3]),
                     '🟢 有器引 %s' % '／'.join(hit[:2]) if hit else '🔴 **器侧零引 —— 空转候选**'))

idle = [r for r in rows if r[4].startswith('🔴')]
noanchor = [r for r in rows if r[4].startswith('⚠️')]
run = [r for r in rows if r[4].startswith('🟢')]

L = []; A = L.append
A('# 空转规则扫描 · 候选清单（`ADJ-0726-03③` 之补办·**令下 2026-07-26·逾期 7 日**）')
A('')
A('> **🔴 本件系「空转候选」，不是「空转规则清单」之定稿。**')
A('> 原令之七问中，本器**只答第七问**「**一月后如何知其在运行**」——**它是七问中唯一可机械化者**。')
A('> 其余六问（责任人是否明确／凭据是否不可伪装／未做之后果是否真存在…）**皆须判断，本器不代**。')
A('>')
A('> **🔴 三条已知漏检面（自曝在先）**：')
A('> ①**只取 🔴 行为规则集** —— 本仓并非每条硬约束都带 🔴，非 🔴 者一概不入视野；')
A('> ②「有器跑它」之判据系**关键词落在 `tools/`／`routines/`／`agents` 内**，')
A('> **关键词命中 ≠ 该器真在跑那条规则**（同 `routines-authority-scan` 之限度：**有引据 ≠ 引据成立**）；')
A('> ③**器存在而从未被调用者，本器读作「有器」** —— **此系本器最大之高估方向：**')
A('> **它会把空转报少，不会报多。故本表之 🔴 系下限，不是全集。**')
A('')
A('**扫描面** ＝ %s' % '／'.join('`%s`' % s for s in SRC if os.path.exists(s)))
A('｜**读取 tip ＝ `%s`**' % tip)
A('')
A('| 读数 | 件数 |')
A('|---|---:|')
A('| 🔴 **空转候选**（有锚而器侧零引） | **%d** |' % len(idle))
A('| ⚠️ 无可机械追之锚（**连空转都判不了**） | **%d** |' % len(noanchor))
A('| 🟢 器侧有引 | %d |' % len(run))
A('| **合计 🔴 行** | **%d** |' % len(rows))
A('')
A('## 一 · 🔴 空转候选（**逐条·按可修复性分档见 §三**）')
A('')
A('| # | 档:行 | 锚 | 条文（截前 160 字·**完整须回正本**） |')
A('|---:|---|---|---|')
for n, (s, i, l, k, _) in enumerate(idle, 1):
    A('| %d | `%s:%d` | `%s` | %s |' % (n, s, i, k, l[:160].replace('|', '｜')))
A('')
A('## 二 · ⚠️ 无可机械追之锚 —— **比空转更前一步之问题**')
A('')
A('**一条不带 ADJ／CR 号、不指名任何器之 🔴 条文，其「在不在跑」连问都问不了。**')
A('**故本类不是「空转」，是「不可判」** —— 而不可判之条文，**日后必然被读作「一直都在」。**')
A('')
A('| # | 档:行 | 条文（截前 160 字） |')
A('|---:|---|---|')
for n, (s, i, l, _, _2) in enumerate(noanchor[:40], 1):
    A('| %d | `%s:%d` | %s |' % (n, s, i, l[:160].replace('|', '｜')))
if len(noanchor) > 40:
    A('')
    A('**🔴 另 %d 条未列** —— **系本表尾部者，非按重要性挑选**；须完整者重跑本器并改 40 之限。'
      % (len(noanchor) - 40))
A('')
A('## 三 · 按可修复性分档（**原令所要之第二半·本席只出建议档位，不自行执行**）')
A('')
A('| 档 | 义 | 件数 |')
A('|---|---|---:|')
A('| **甲 · 加器即可** | 条文已有明确锚与可机械化之判据，**缺的只是一个跑它的器** | 候人核 |')
A('| **乙 · 须先补锚** | 即 §二 之 %d 条 —— **先给它一个编号或指名一个器，才谈得上跑** | **%d** |' % (len(noanchor), len(noanchor)))
A('| **丙 · 本质不可机械化** | 判断类条文（如「不得以结果反证程序正当」），**其运行只能靠人**，不入空转 | 候人核 |')
A('')
A('**🔴 甲丙两档之分需逐条读条文，属判断类** —— **本席不自行分档**：')
A('**由本席给自己的规则分「本质不可机械化」这一档，恰是最省事也最不可核之出口。**')
A('**呈 GM／审查员分档，本席只出 §一 §二 两张事实表。**')

io.open('docs/internal-audit/idle-rule-candidates.md', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print('→ 🔴 空转候选 %d ｜ ⚠️ 无锚不可判 %d ｜ 🟢 器侧有引 %d ｜ 合计 🔴 行 %d'
      % (len(idle), len(noanchor), len(run), len(rows)))
PYEOF
