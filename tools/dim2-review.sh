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

# 🔴 分母钉死（**2026-08-01 CGM 自捕·委托人特批之标的系「91 件」而非「跑表时凡未签收者」**）：
#   首跑读 91，改锚后重跑读 94 —— **三件之增系本席当日结案动作自身撑大待结之集合**
#   （审查员 2026-08-01 已指此形态）。若听其漂移，则**每一次结案都在制造新的待结**，
#   且封存预测之分母（91）与实测之分母（94）不同基，**对表即失效**。
#   故：名册取自 `docs/internal-audit/2026-08-01-91-roster.txt`（自维一批量之 carry-register 定格），
#   **逾名册者单列，不并入本批，亦不静默丢弃**。名册缺失则**失败关闭**，不得回落至「当前未签收集合」。
ROSTER='docs/internal-audit/2026-08-01-91-roster.txt'
if not os.path.exists(ROSTER):
    sys.stderr.write('🔴 名册缺失：%s —— 失败关闭，拒绝回落至「当前未签收集合」\n'%ROSTER); sys.exit(3)
roster=[x.strip() for x in io.open(ROSTER,encoding='utf-8') if x.strip()]

files=[f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]
uns_now=[f for f in files if not is_signed(f)]
base_of=lambda f: os.path.basename(f).replace('-receipt.md','')
uns=[f for f in uns_now if base_of(f) in roster]
extra=sorted(base_of(f) for f in uns_now if base_of(f) not in roster)
gone=[b for b in roster if b not in {base_of(f) for f in uns_now}]
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
    # 改⑦（**校准所捕·2026-08-01·CGM 自捕，非审查员所指**）：
    #   以 `ADJ-0801-16-receipt.md` 校准——该件本席亲书、十项皆有专节、有直接记忆，
    #   同行锚却读 6/10，**四红全系伪影**，两种成因：
    #   (a) 结构——节题作 `### ⑤ 三项须人核`，**圈码在题、处置词在题下正文**，同行锚结构上看不见；
    #   (b) 词表——`已办|已改|…` 系**闭合枚举**，而中文「已X」系开集：
    #       `已成就／已出／已结／已核／已解除` 一概漏（⑧⑨ 即此）。
    #   故**并出两读**：**同行锚（严）** 与 **块锚（宽·节题开块，块内见处置词即计）**；
    #   **两读之差 ＝ 本锚之不确定带，不择一充作真值**，取舍留予审查员。
    #   DISPOSE2 系开放式「已X」，**只用于标「词表外」以令词表之限度可见，不用于判绿**。
    DISPOSE2=re.compile(r'已[^\s，。：；、）】]')
    body=[l for l in t.split('\n')
          if not re.match(r'^\|\s*[①-⑳]?\s*(pull|读 inbox|四字段|三要素|逐项|receipt)', l)
          and not l.lstrip().startswith('>')]
    HDR=re.compile(r'^\s*#{2,6}\s*(['+CIRC+r'])')
    ANY_HDR=re.compile(r'^\s*#{1,6}\s')
    def marks_of(block_mode):
        marks=set(); cur=None
        for l in body:
            h=HDR.match(l)
            if h: cur=h.group(1)
            elif ANY_HDR.match(l): cur=None
            if DISPOSE.search(l):
                for ch in re.findall(r'['+CIRC+r']', l): marks.add(ch)
                if block_mode and cur: marks.add(cur)
        return marks
    blocks={}; cur=None
    for l in body:
        h=HDR.match(l)
        if h: cur=h.group(1); blocks.setdefault(cur,[])
        elif ANY_HDR.match(l): cur=None
        if cur: blocks[cur].append(l)
    if N==0: c1=c1b='n/a'
    elif N>len(CIRC): c1=c1b='⚠️ N=%d 超圈码域'%N
    else:
        need=set(CIRC[:N])
        miss_s=need-marks_of(False); miss_b=need-marks_of(True)
        oov={ch for ch in miss_b if ch in blocks and DISPOSE2.search('\n'.join(blocks[ch]))}
        c1='✅' if not miss_s else '🔴 缺'+''.join(sorted(miss_s,key=CIRC.index))
        if not miss_b: c1b='✅'
        else:
            c1b='🔴 缺'+''.join(sorted(miss_b,key=CIRC.index))
            if oov: c1b+=' 〔%s 系词表外「已X」〕'%''.join(sorted(oov,key=CIRC.index))
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
    rows.append((base,N,c1,c1b,c2,c3))

bad1s=sum(1 for r in rows if r[2].startswith('🔴'))
bad1=sum(1 for r in rows if r[3].startswith('🔴'))
bad2=sum(1 for r in rows if r[4].startswith('🔴'))
bad3=sum(1 for r in rows if r[5].startswith('🔴'))
anybad=sum(1 for r in rows if any(str(x).startswith('🔴') for x in r[3:]))
anybad_s=sum(1 for r in rows if any(str(x).startswith('🔴') for x in r[2:]))
band=sum(1 for r in rows if r[2].startswith('🔴') and not r[3].startswith('🔴'))

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
A('**🔴 分母钉死·非钉时点**：首跑读 91、改锚后重跑读 94 —— **三件之增系本席当日结案动作**')
A('**自身撑大待结之集合**（审查员所捕之形态）。听其漂移则每次结案都在制造新的待结，')
A('且封存预测之分母（91）与实测之分母不同基，**对表即失效**。')
A(f'故本表之名册取自 `{ROSTER}`（sha1 见库），**分母 ＝ {len(rows)}**，**读取 commit ＝ `{tip}`**。')
if extra: A('**🔴 逾名册 %d 件（单列·不并入本批·不静默丢弃）**：%s。'%(len(extra),'／'.join('`%s`'%x for x in extra)))
if gone: A('**⚠️ 名册内已不在未签收集合者 %d 件**：%s —— **须查其系已签收抑或件已失踪**。'%(len(gone),'／'.join('`%s`'%x for x in gone)))
A('')
A('## 〇 · 🔴 锚之校准（**CGM 自捕·2026-08-01·须与逐件结果同呈审查员**）')
A('')
A('**校准件 ＝ `ADJ-0801-16-receipt.md`** —— 本席数小时前亲书、十项皆有专节、**有直接记忆**。')
A('**同行锚读 6/10，缺 ⑤⑥⑧⑨；逐一验其原文，四红全系伪影**，两种成因：')
A('')
A('| 缺号 | 该节原文 | 成因 |')
A('|---|---|---|')
A('| ⑤ | `### ⑤ 三项须人核` → 节内「**采认「不等于」**」 | **(a) 结构**：圈码在节题、处置词在题下正文，同行锚看不见 |')
A('| ⑥ | `### ⑥ R2–R7 之当轮回应` → 节内 5 处「接受·已修」 | 同 (a) |')
A('| ⑧ | `### ⑧ 维一批量之前置 —— **已成就**` | **(b) 词表**：`已办\\|已改\\|…` 系闭合枚举，「已成就」在其外 |')
A('| ⑨ | `### ⑨ 六件解封 —— **分流表已出**` | 同 (b)：「已出」「已结」皆在词表外 |')
A('')
A('**故本表并出两读**：**①a 同行锚（严）** 与 **①b 块锚（宽·节题开块，块内见处置词即计）**。')
A(f'**两读之差 ＝ 本锚之不确定带 ＝ {band} 件**（同行判红而块判绿者）。**本席不择一充作真值。**')
A('**🔴 取哪一读为准，系审查员之事，不系本席之事** —— 宽读降低本席之缺陷计数，')
A('**本席系被审方，无资格择那个对自己有利之锚**。')
A('')
A('**🔴 校准另捕一实缺（非伪影）**：该件之〔校验和自核〕书「【共10项】↔ ①–⑩ ＝ **10 项**·相符 ✅」，')
A('而其节题实为 ②(a)／②(b)／③–⑩ —— **①无专节，②裂为两节，数目凑够而身份不合**。')
A('**此即审查员所指「改②：只计数不认身份」之同一病，出现在本席自己的回执里**（`CR-20260801-28`）。')
A('')
A('## 一 · 汇总 vs 🔴 封存预测（**对表·不得事后调预测**）')
A('')
A('| 预测 | 封存值 | **实测（同行锚·严）** | **实测（块锚·宽）** | 判 |')
A('|---|---|---|---|---|')
A(f'| **P1** 有维二缺陷之件数 | ≥15/91 | **{anybad_s}/{len(rows)}** | **{anybad}/{len(rows)}** | {"🟢 两读皆达预期" if anybad>=15 else ("🔴 **宽读低于预期——照封存件 §二须疑；严读达标，两读分歧待审查员定锚**" if anybad_s>=15 else "🔴 **两读皆显著优于预期——本席之审须被疑为走过场**")} |')
A(f'| **P2** 逐项覆盖不全 | ≥8/91 | **{bad1s}/{len(rows)}** | **{bad1}/{len(rows)}** | {"🟢 两读皆达" if bad1>=8 else ("⚠️ **两读分歧·待定锚**" if bad1s>=8 else "🔴 **优于预期·须疑**")} |')
A(f'| **P3** 承重两步俱缺 | ≈45/91 | 见 `carry-register` 之 ③④ 栏 | 同左 | ⚠️ 另表 |')
A(f'| **P4** 改判自己原结论 | ≥2 件 | **候 CGM 亲判后填** | 同左 | ⚠️ **若为 0，即「自审从不推翻自己」之直接证据** |')
A('')
A('## 二 · 逐件机械锚')
A('')
A('| # | 件 | 件载项数 | ①a 同行锚（严） | ①b 块锚（宽） | ②令与办对齐 | ③无越权 |')
A('|---:|---|---:|---|---|---|---|')
for i,(b,N,c1,c1b,c2,c3) in enumerate(rows,1):
    A(f'| {i} | `{b}` | {N or "—"} | {c1} | {c1b} | {c2} | {c3} |')
A('')
A('**🔴 本表之限度**：①之两读只数圈码之在否，**不核那一项是否真被处置**——')
A('**块锚尤宽：块内任一处置词即可为该号记绿，纵其所处置者系别事**；')
A('②之「令与办对齐」系词频比，**不核办得对不对**；③只挡三种已知形态加一条 git 实检。')
A('**四者皆系粗筛，其漏检面由审查员复审承担。**')
io.open('docs/internal-audit/2026-08-01-dim2-review.md','w',encoding='utf-8').write('\n'.join(L)+'\n')
print(f'→ 91 件已扫｜①不全 {bad1}｜②不齐 {bad2}｜③越权 {bad3}｜**任一缺陷 {anybad}**')
PYEOF
