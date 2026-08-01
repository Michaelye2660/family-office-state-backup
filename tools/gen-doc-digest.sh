#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 大档 DIGEST 抽取件生成器（`CR-20260801-36` 之补办 · 2026-08-02）
#
# 🔴 为哪条缺口而立：`ADJ-0801-12⑤` 立抽取件制之理由系 GM 原话
#   「**GM 侧无范围读，只能整档取回——要本席『只读其中 4 KB』，物理上做不到。**」
#   **而该制度自 2026-08-01 立起，只在 CGM 自己那一份审计报告上执行过一次**；
#   GM 真正须读之三大档（`adjudication-lanes` 100.8 KB／`state-core` 70.0 KB／
#   `cc-knowledge` 54.8 KB·各为该阈值之 3.6／2.5／1.9 倍）**一件未建**。
#   **CGM 判决录 `CR-20260801-36` 与 GM-13 摘要「只在一条路上执行的规则等于没有规则」
#   同日独立撞在同一句上。本器即其补办。**
#
# 🔴 抽取之取法（写死·免日后各自演化）：
#   ①标题树（全部 `#`–`####`·带各节字节数）——**使 GM 可指名要哪一节，而非整档取回**；
#   ②全部 🔴 行——本仓以 🔴 标承重条文，**故 🔴 行即该档之硬约束集**。
#
# 🔴 它不核什么（先列不覆盖处·免「未报」被读作「已核无事」）：
#   - **不判抽取得够不够** —— 属判断类，归 GM；
#   - **🔴 抽取件不是正本之替代** —— 凡引条文须回正本；本器只解决「不知该读哪一段」；
#   - **非 🔴 之承重条文会被漏掉** —— 本仓并非每条硬约束都带 🔴，**此系本器之已知漏检面**。
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

python3 - "$@" <<'PYEOF'
import io, os, re, subprocess, sys

TARGETS = sys.argv[1:] or ['docs/adjudication-lanes.md', 'docs/state-core.md', 'docs/cc-knowledge.md']
CAP = 12000   # 抽取件硬上限；超限即截并于尾报「截掉何项」——不静默截断
tip = subprocess.run(['git', 'log', '-1', '--format=%H'], capture_output=True, text=True).stdout.strip()

for src in TARGETS:
    if not os.path.exists(src):
        print('⚠️ 缺：%s' % src); continue
    t = io.open(src, encoding='utf-8', errors='replace').read()
    lines = t.split('\n')
    # 节边界与各节字节
    heads = [(i, l) for i, l in enumerate(lines) if re.match(r'^#{1,4}\s', l)]
    sizes = []
    for n, (i, l) in enumerate(heads):
        j = heads[n + 1][0] if n + 1 < len(heads) else len(lines)
        sizes.append(len('\n'.join(lines[i:j]).encode()))
    reds = [l.strip() for l in lines if '🔴' in l and not re.match(r'^#{1,4}\s', l)]

    L = []; A = L.append
    A('# DIGEST · `%s`' % src)
    A('')
    A('> **本档系抽取件，不是正本之替代。** 凡引条文**须回正本**；本件只解决「**不知该读哪一段**」。')
    A('> **立此件之由**（`ADJ-0801-12⑤`·GM 原话）：「**GM 侧无范围读，只能整档取回**」——')
    A('> 而该制度自 2026-08-01 立起**只在 CGM 自己那份审计报告上跑过一次**，三大档一件未建（`CR-20260801-36`）。')
    A('>')
    A('> **🔴 已知漏检面**：本件只抽①标题树 ②🔴 行。**本仓并非每条硬约束都带 🔴 ——**')
    A('> **非 🔴 之承重条文会被本件漏掉，故本件之「未见」不等于「无」。**')
    A('')
    A('**正本** `%s` ＝ **%d B**｜**节 %d 个**｜**🔴 行 %d 条**｜**读取 tip ＝ `%s`**'
      % (src, len(t.encode()), len(heads), len(reds), tip))
    A('')
    A('## 一 · 标题树（**带各节字节·可据以指名取节**）')
    A('')
    A('| 行 | 层 | 标题 | 该节 B |')
    A('|---:|:--:|---|---:|')
    for (i, l), b in zip(heads, sizes):
        lv = len(l) - len(l.lstrip('#'))
        A('| %d | %s | %s | %d |' % (i + 1, 'H%d' % lv, l.lstrip('# ').strip()[:78].replace('|', '｜'), b))
    A('')
    A('## 二 · 🔴 行全录（**本仓以 🔴 标承重条文，故此即该档之硬约束集**）')
    A('')
    # 🔴 超限即**分卷，不截断**（照本仓先例：审计报告曾分卷而非截断）。
    #   **理由**：截断丢掉之条与留下之条，其别只是「在表里排第几」——**与重要性无关**；
    #   而一份丢了 80 条硬约束的抽取件，对最要紧那一档**等于没抽全**。
    base = 'docs/digests/%s-DIGEST' % os.path.basename(src).replace('.md', '')
    os.makedirs('docs/digests', exist_ok=True)
    vols = []; cur = list(L)
    for r in reds:
        if sum(len(x.encode()) for x in cur) > CAP:
            vols.append(cur)
            cur = ['# DIGEST · `%s` · 第 %d 卷（承前·🔴 行续）' % (src, len(vols) + 1), '',
                   '> **本卷系分卷，非截断** —— 前卷未尽之 🔴 行全数在此，**一条不丢**。', '']
        cur.append('- ' + r[:300].replace('|', '｜'))
    vols.append(cur)
    n = len(vols)
    for k, v in enumerate(vols, 1):
        if n > 1:
            v.append('')
            v.append('**本件共 %d 卷** —— 第 1 卷 `%s.md`%s。**分卷非截断，🔴 行一条不丢。**'
                     % (n, os.path.basename(base),
                        ''.join('／第 %d 卷 `%s-%d.md`' % (i, os.path.basename(base), i)
                                for i in range(2, n + 1))))
        out = '%s.md' % base if k == 1 else '%s-%d.md' % (base, k)
        io.open(out, 'w', encoding='utf-8').write('\n'.join(v) + '\n')
        vols[k - 1] = out
    print('→ %s（%d B）→ %d 卷：%s'
          % (src, len(t.encode()), n, '／'.join('%s %d B' % (os.path.basename(o), os.path.getsize(o)) for o in vols)))
PYEOF
