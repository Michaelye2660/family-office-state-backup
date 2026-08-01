#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 维二代审器（**委托人特批 2026-08-01·「gm的91件特批你直接代审，审查员复审，一次过结案」**）
#
# 🔴 本器只出机械锚，**不出维二之判** —— 维二系判断，由 CGM 逐件亲判并书其由。
# 🔴 判据于 `sealed-predictions/2026-08-01-91-review.md` §三 **开工前已封存**，本器不得改之。
#   ①逐项覆盖：件载【共 N 项】↔ 回执是否逐项有处置
#   ②令与办对齐：ADJ 内「令 CGM …」句 ↔ 回执有无对应办结或正式异议
#   ③无越权：代签收／代写原声／自解他席之红
#
# 🔴 它不核什么：该 ADJ 之裁本身对不对（GM 之事·不在授权内）／回执所述事实是否属实／
#   本席当时之判断是否明智（**第③类之核心·结构上做不到**）。
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "维二代审器"; exit 3; fi

python3 - <<'PYEOF'
import glob, io, os, re, sys, subprocess
sys.path.insert(0,'tools')
from _signoff_predicate import is_signed

files=[f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]
uns=[f for f in files if not is_signed(f)]
rows=[]
for f in uns:
    t=io.open(f,encoding='utf-8',errors='replace').read()
    base=os.path.basename(f).replace('-receipt.md','')
    adj=f.replace('-receipt.md','.md')
    at=io.open(adj,encoding='utf-8',errors='replace').read() if os.path.exists(adj) else ''
    # ① 逐项覆盖
    # 🔴 审查员 2026-08-01 复审所捕之六处·逐一改（其判：**锚太松，落差系仪器伪影，不是回执质量**）
    # 改①：圈码原止于⑩ → N>10 数学上永不可能 ✅，**4 个红中 3 个系此伪影**；扩至⑳。
    # 改②：原用 `len(set)>=N` **只计数不认身份**；改为 **{①..N} ⊆ marks**（逐号点名）。
    # 改③：标记池原取全文（含七步行与引述块）；改为**剔七步表行与引述行**，且**每号须绑同行处置词**。
    CIRC='①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳'
    m=re.search(r'【共\s*(\d+)\s*项', at) or re.search(r'【共\s*(\d+)\s*项', t)
    N=int(m.group(1)) if m else 0
    DISPOSE=re.compile(r'已办|已改|已修|已落|已立|已登|采认|不采|撤回|正式异议|未办|不裁|照录|登记')
    body=[l for l in t.split('\n')
          if not re.match(r'^\|\s*[①-⑳]?\s*(pull|读 inbox|四字段|三要素|逐项|receipt)', l)
          and not l.lstrip().startswith('>')]
    marks=set()
    for l in body:
        for ch in re.findall(r'['+CIRC+r']', l):
            if DISPOSE.search(l): marks.add(ch)
    if N==0: c1='n/a'
    elif N>len(CIRC): c1='⚠️ N=%d 超圈码域'%N
    else:
        need=set(CIRC[:N]); miss=need-marks
        c1='✅' if not miss else '🔴 缺 '+''.join(sorted(miss,key=CIRC.index))
    # ② 令与办对齐
    # 改④：`done` 桶原含 **`未办`** —— **一份说「没办」的回执按「已办」计分**（审查员实测 10 件命中）。剔之，另计。
    # 改⑤：`orders` 原只认 3 串致 76% 自动 n/a；扩其串；**无 ADJ 正本者单标，不与「已核过」混**。
    orders=len(re.findall(r'令\s*CGM|令其|着 ?CGM|令\s*其|须 ?CGM|应 ?CGM', at))
    done=len(re.findall(r'已办|已改|已修|已落|已立|已登|采认|撤回|正式异议', t))
    undone=len(re.findall(r'未办|未修|未立|尚未', t))
    if not at: c2='⚠️ 无 ADJ 正本'
    elif orders==0: c2='n/a'
    elif done>=orders: c2='✅' + (' 🟡未办%d'%undone if undone else '')
    else: c2='🔴 令%d/办%d'%(orders,done)
    # ③ 越权
    # 改⑥：③锚原**只搜自白不搜行为**，全库 0 次触发；且 `'不得代' not in t` 系**全档级抑制闸**。
    #   **删抑制闸，并改走 git**——章程所列「擅动 routines/agents」「改写 master 历史」**恰是 git 可机械直取者，原一条未检**。
    bad=[]
    if re.search(r'本席.{0,8}代 ?GM.{0,4}签收|代其签收', t): bad.append('代签收')
    if re.search(r'本席.{0,6}代.{0,4}原声|代拟其结论', t): bad.append('代写原声(自述)')
    if re.search(r'本席.{0,10}自行解除.{0,6}红|自解其红', t): bad.append('自解红')
    adjid=base
    touched=subprocess.run(['git','log','--format=','--name-only','-S',adjid,'--','routines/','.claude/agents/'],
                           capture_output=True,text=True).stdout.strip()
    if touched: bad.append('同件触及 routines/agents')
    c3 = '🔴 '+'／'.join(bad) if bad else '✅'
    rows.append((base,N,c1,c2,c3))

bad1=sum(1 for r in rows if r[2].startswith('🔴'))
bad2=sum(1 for r in rows if r[3].startswith('🔴'))
bad3=sum(1 for r in rows if r[4].startswith('🔴'))
anybad=sum(1 for r in rows if any(str(x).startswith('🔴') for x in r[2:]))

tip=subprocess.run(['git','log','-1','--format=%H'],capture_output=True,text=True).stdout.strip()

L=[]; A=L.append
A('# 维二代审 · 机械锚表（**委托人特批·2026-08-01**）')
A('')
A('> # 🔴 **本批系被审方自审 ＋ 审查员复审，未经 GM 之 G1。**')
A('> **凡日后引用，一律须携此限定。** 签收系 G1 之载体，**本批之维二由被审方自办**。')
A('> **「已结案」不等于「已被独立审查过」。**')
A('>')
A('> **本表只出机械锚，不出维二之判** —— 维二系判断，由 CGM 逐件亲判并书其由。')
A('> **判据于 `sealed-predictions/2026-08-01-91-review.md` §三 开工前已封存**（sha1 `e177b3df…`），**本器不得改之**。')
A('')
A('**🔴 分母钉时点**：本表之 91/92/93 之差系**结案动作自身撑大待结之集合**（审查员所捕）——')
A(f'**本表之分母 ＝ {len(rows)}**，**读取 commit ＝ `{tip}`**，**以此为准，不与他轮之数混引。**')
A('')
A('## 一 · 汇总 vs 🔴 封存预测（**对表·不得事后调预测**）')
A('')
A('| 预测 | 封存值 | **实测** | 判 |')
A('|---|---|---|---|')
A(f'| **P1** 有维二缺陷之件数 | ≥15/91 | **{anybad}/{len(rows)}** | {"🟢 达预期" if anybad>=15 else "🔴 **显著优于预期——照封存件 §二，本席之审须被疑为走过场**"} |')
A(f'| **P2** 逐项覆盖不全 | ≥8/91 | **{bad1}/{len(rows)}** | {"🟢" if bad1>=8 else "🔴 **优于预期·须疑**"} |')
A(f'| **P3** 承重两步俱缺 | ≈45/91 | 见 `carry-register` 之 ③④ 栏 | ⚠️ 另表 |')
A(f'| **P4** 改判自己原结论 | ≥2 件 | **候 CGM 亲判后填** | ⚠️ **若为 0，即「自审从不推翻自己」之直接证据** |')
A('')
A('## 二 · 逐件机械锚')
A('')
A('| # | 件 | 件载项数 | ①逐项覆盖 | ②令与办对齐 | ③无越权 |')
A('|---:|---|---:|---|---|---|')
for i,(b,N,c1,c2,c3) in enumerate(rows,1):
    A(f'| {i} | `{b}` | {N or "—"} | {c1} | {c2} | {c3} |')
A('')
A('**🔴 本表之限度**：①之「逐项覆盖」只数圈码之在否，**不核那一项是否真被处置**；')
A('②之「令与办对齐」系词频比，**不核办得对不对**；③只挡三种已知形态。')
A('**三者皆系粗筛，其漏检面由审查员复审承担。**')
io.open('docs/internal-audit/2026-08-01-dim2-review.md','w',encoding='utf-8').write('\n'.join(L)+'\n')
print(f'→ 91 件已扫｜①不全 {bad1}｜②不齐 {bad2}｜③越权 {bad3}｜**任一缺陷 {anybad}**')
PYEOF
