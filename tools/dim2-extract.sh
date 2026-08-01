#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 维二逐件亲判之取材器（**不出判，只出料**·2026-08-01）
#
# 🔴 本器与 `dim2-review.sh` 之别：后者出机械锚（红绿），本器**只把 ADJ 之令与回执之处置
#   并排摆出来，供 CGM 亲眼看、亲手判**。**本器不含任何判据、不出任何红绿。**
#
# 🔴 立此器之由：91 件逐件全文对读，一轮读不完；而**只看锚就下判 ＝ 让锚代替判断**，
#   恰是审查员所警之事。折中＝**把两侧之要害并排压缩，判仍由人下**，
#   并**显书压缩之损失**：压缩即取舍，取舍即可能漏掉正是要害的那一句。
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

python3 - "$@" <<'PYEOF'
import io, os, re, sys

ROSTER = 'docs/internal-audit/2026-08-01-91-roster.txt'
roster = [x.strip() for x in io.open(ROSTER, encoding='utf-8') if x.strip()]
lo = int(sys.argv[1]) if len(sys.argv) > 1 else 1
hi = int(sys.argv[2]) if len(sys.argv) > 2 else len(roster)

CIRC = '①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳'
ORDER = re.compile(r'令\s*CGM|令其|着\s?CGM|令\s*其|须\s?CGM|应\s?CGM|CGM\s*须|不得')


def squash(s, n=150):
    s = re.sub(r'\*\*|`', '', s).strip()
    return s[:n] + ('…' if len(s) > n else '')


out = []
for i, base in enumerate(roster[lo - 1:hi], lo):
    adjp = 'adj-archive/%s.md' % base
    rcp = 'adj-archive/%s-receipt.md' % base
    at = io.open(adjp, encoding='utf-8', errors='replace').read() if os.path.exists(adjp) else ''
    rt = io.open(rcp, encoding='utf-8', errors='replace').read() if os.path.exists(rcp) else ''
    out.append('=' * 78)
    out.append('[%d/%d] %s   ADJ正本:%s  回执:%d B' %
               (i, len(roster), base, ('%d B' % len(at)) if at else '🔴无', len(rt)))
    # ADJ 之令：取含祈使词之句，去重
    orders, seen = [], set()
    for l in at.split('\n'):
        if ORDER.search(l) and not l.lstrip().startswith('>'):
            k = squash(l, 60)
            if k and k not in seen:
                seen.add(k)
                orders.append(squash(l))
    out.append('  ── ADJ 之令 (%d 句) ──' % len(orders))
    for o in orders[:8]:
        out.append('   · ' + o)
    if len(orders) > 8:
        out.append('   · …另 %d 句（**压缩之损失在此·须判时可回原档**）' % (len(orders) - 8))
    # 回执之逐节处置：节题 + 其块内首句实质
    lines = rt.split('\n')
    HDR = re.compile(r'^\s*#{2,6}\s*(['+CIRC+r'])')
    ANY = re.compile(r'^\s*#{1,6}\s')
    cur, blocks = None, []
    for l in lines:
        h = HDR.match(l)
        if h:
            cur = h.group(1)
            blocks.append([l, []])
        elif ANY.match(l):
            cur = None
        elif cur and l.strip():
            blocks[-1][1].append(l)
    out.append('  ── 回执之逐节 (%d 节) ──' % len(blocks))
    for hdr, body in blocks:
        first = squash(body[0], 110) if body else '〔节内空〕'
        out.append('   ' + squash(hdr, 60))
        out.append('     → ' + first)
    if not blocks:
        # 无圈码节者：取回执之粗体断言行
        strong = [squash(l, 110) for l in lines if l.count('**') >= 2 and len(l.strip()) > 20][:6]
        out.append('   〔无圈码分节·取粗体断言行〕')
        for s in strong:
            out.append('     · ' + s)
    out.append('')

io.open('/tmp/claude-0/-home-user-family-office-state/'
        '3013fa6a-e999-54d5-8cf7-03ebde1c0541/scratchpad/dim2-material-%d-%d.txt' % (lo, hi),
        'w', encoding='utf-8').write('\n'.join(out) + '\n')
print('→ 取材 %d–%d 共 %d 件已出' % (lo, hi, hi - lo + 1))
PYEOF
