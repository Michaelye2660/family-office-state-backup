#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 申报 sha1 之新鲜度核（`ADJ-0801-18⑥` 立 · 2026-08-01）
#
# 🔴 为哪个缺口而立 —— **它开了整整一天**：
#   内审官首日 **R2**：「申报 sha1 与库中实物不符·2 处·现行」。**实例当轮已修。**
#   此后 CGM 于 `-16` 回执**明书「🔴 规则仍未立·本席不称此项已解决」**；
#   审查员于第二轮代核**证成其为制度性缺口而非个案**：
#     「**库内无任何机制重核『一处申报之 sha1 是否仍与其所申报之物相符』；实例已修，规则仍无。**」
#   GM-13 据以立条文（`-18⑥`）：
#     「**一个只在写下时为真的哈希，其后每一次被引用都是在赌它没变。**」
#
# 🔴 它核什么：**全库 tracked `*.md` 内形如「<路径> … <40hex>」之申报**，
#   于**当前 tip** 重算该路径之内容 sha1 并比对；**不符即 🔴**。
#
# 🔴 它不核什么（先列不覆盖处）：
#   - **不核 blob SHA 之申报** —— `git hash-object` 与 `sha1sum` 系两个不同函数，**本器只管后者**；
#   - **不核「该申报当初对不对」** —— 只管**它现在还对不对**；
#   - **不核申报所指之物是否应当被改** —— 改动之正当性属判断；
#   - **不核未落库之申报**；**不核非 `*.md` 之档**。
#
# 🔴 已知假阳性面（如实标·不掩饰）：
#   凡**引用他人之 sha1 作历史锚**者（如台账之「前纪元历史锚」、回执之「原版已作废」），
#   **其值本就指向一个旧版本，重算必不符** —— **本器无法区分「过期申报」与「历史锚」**。
#   **故本器之 🔴 一律标「须人核」，不自动作废任何申报。**
#
# 🔴 死法与检出法：
#   **退役条件**：当申报改为「路径＋commit」双锚（可机械定位其时点）→ 本器失去存在理由。
#     **「一直无不符」不构成退役理由。**
#   **检出法（落本器之外）**：`internal-audit.sh` §二 乙4-f —— **当日缺本器之产出即 🔴**。
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "申报 sha1 新鲜度核"; exit 3; fi

python3 - <<'PYEOF'
import re, io, os, subprocess, hashlib
tip=subprocess.run(['git','log','-1','--format=%H'],capture_output=True,text=True).stdout.strip()
files=subprocess.run(['git','ls-files','*.md'],capture_output=True,text=True).stdout.split()
PAT=re.compile(r'`([A-Za-z0-9_./-]+\.md)`[^\n`]{0,80}?`([0-9a-f]{40})`')
rows=[]
for f in files:
    try: t=io.open(f,encoding='utf-8',errors='replace').read()
    except Exception: continue
    for m in PAT.finditer(t):
        path,declared=m.group(1),m.group(2)
        if not os.path.exists(path): rows.append((f,path,declared,'—','⚠️ 所指之档不在')); continue
        actual=hashlib.sha1(io.open(path,'rb').read()).hexdigest()
        if actual!=declared:
            rows.append((f,path,declared[:12],actual[:12],'🔴 不符'))
L=[];A=L.append
A('# 申报 sha1 · 新鲜度核（`ADJ-0801-18⑥`）· '+subprocess.run(['date','+%F'],capture_output=True,text=True).stdout.strip())
A('')
A(f'> **读取 tip**：`{tip}`｜**扫描面**：tracked `*.md` **{len(files)}** 件')
A('> **判据**：形如「\\`<路径.md>\\` … \\`<40hex>\\`」之申报，于**当前 tip** 重算该路径之内容 sha1 并比对。')
A('>')
A('> **🔴 本器之 🔴 一律「须人核」，不自动作废任何申报** —— **本器无法区分「过期申报」与「历史锚」**')
A('> （凡引用他人之 sha1 作历史锚者，其值本就指向旧版本，重算必不符）。')
A('>')
A('> **由（GM-13 `-18⑥`）**：**「一个只在写下时为真的哈希，其后每一次被引用都是在赌它没变。」**')
A('')
if not rows:
    A('**🟢 本轮未见不符。**（**「本轮未见」不等于「无事」** —— 本器只扫已落库之 `*.md`，且只认上列形态。）')
else:
    A(f'**⚠️ 不符 {len(rows)} 处 · 逐条须人核**')
    A('')
    A('| 申报所在 | 所指之档 | 申报值 | 现算值 | 判 |')
    A('|---|---|---|---|---|')
    for r in rows[:40]: A('| `%s` | `%s` | `%s…` | `%s…` | %s |'%r)
    if len(rows)>40: A(f'| … | **另 {len(rows)-40} 处** | | | **见本器复跑** |')
io.open('docs/internal-audit/sha1-declare-check.md','w',encoding='utf-8').write('\n'.join(L)+'\n')
print(f'→ 扫 {len(files)} 件｜不符 {len(rows)} 处')
PYEOF
