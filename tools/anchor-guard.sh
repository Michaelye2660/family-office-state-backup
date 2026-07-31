#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# 锚存续核 anchor-guard —— ADJ-0801-01④ 立｜**检测点与主责见文末 §主责栏**
#
# 🔴 本器所防之事故（`c40c6ecc`·CGM 自陈·GM 判读「同型第五次·首次毁及历史」）：
#   轮换权威状态块时**索引差一位**，覆盖了承载 E8／E7／E6／E5 锚之历史行，
#   E5 指纹在全文件**一度归零**。
#   **当时一切自检皆绿** —— 因为所有检查问的都是「**新内容是否写对**」，
#   而没有一个问「**旧内容是否还在**」。
#
# 🔴 GM 之加严（-01④ 逐字）：
#   「CGM 所立之『**按位置改写多行结构时，须验旧内容是否仍在，不只验新内容是否对**』，
#     **须落进工具（写入相应脚本之前置检查），不得仅存于知识库条文**。」
#   其理由：「一条只写在文档里、依赖执行者当时记得的规则……**定上限不立检测，等于没定**。」
#
# 判据（机械·零裁量）：
#   取 `git show HEAD:<file>` 之**已提交版**为基准，抽出其全部「锚形串」并计数；
#   再于**工作树版**计数。**凡计数下降者即报 🔴**。
#   本库台账系**追加不覆写**（铁律），故任何锚之计数下降**在定义上就是事故**，无正当情形。
#
# 🔴 本器之盲区（先列·免「未报」被读作「已核无事」）：
#   (i)  只核**锚形串**（40/32 位十六进制、〔M〕N、E<n>=、v16.N）——散文被覆写它看不见；
#   (ii) 只核**已提交版 → 工作树**这一跨度；**同一轮内先坏后 commit 再改**，基准即已带伤；
#   (iii) 拦不住手工 Edit 之当场覆写——它系**事后核**，作用是「**在 push 前必然被发现**」，
#        不是「让覆写不可能发生」。**此为如实申报，不得读作本器已消除该风险。**
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

FILES=("$@")
if [ ${#FILES[@]} -eq 0 ]; then
  # 默认核**多行结构且系追加不覆写**之三件
  FILES=(portfolio-state.md docs/constitution.md docs/succession/gm-succession.md)
fi

RC=0
echo "# 锚存续核 · anchor-guard（ADJ-0801-01④）"
echo
echo "- **基准**：\`git show HEAD:<file>\`（HEAD=\`$(git log -1 --format=%h)\`）｜**被核**：工作树版"
echo "- **判据**：锚形串计数**只许持平或上升；下降即 🔴**（本库追加不覆写，无正当下降情形）"
echo

for f in "${FILES[@]}"; do
  echo "## \`$f\`"
  echo
  if [ ! -f "$f" ]; then echo "  🔴 工作树无此文件"; RC=1; echo; continue; fi
  if ! git cat-file -e "HEAD:$f" 2>/dev/null; then
    echo "  ⚪ HEAD 无此文件（新增件·**无基准可比·本器对其不作保证**）"; echo; continue
  fi
  git show "HEAD:$f" > /tmp/_ag_base.$$ 2>/dev/null
  python3 - "$f" /tmp/_ag_base.$$ <<'PY'
import re, sys, collections
cur = open(sys.argv[1], encoding='utf-8', errors='replace').read()
base = open(sys.argv[2], encoding='utf-8', errors='replace').read()

# 锚形串之类别（**只加不减地列**；每类各自计数）
#
# 🔴 「版本行号」一类之收窄申报（**本器立起当轮自捕·CGM 2026-08-01·此系放宽，故须逐条说明**）：
#   原式 `\bv1[0-9]\.\d+` 把**文件头 H1 之版本号**也算作锚，遂在 v16.411→v16.412 之常规换版上
#   报出「v16.411 计数 2→1」之 🔴。**该 🔴 系误报**：文件头之版本号**设计上就是一个每轮被覆写之当前值**，
#   不是历史锚；台账之追加不覆写铁律管的是**正文条目与版本沿革行**，从来不管那一个字段。
#
#   **🔴 但「收窄一处正好挡住自己的检查」，与 `activate-epoch.sh` §② 所警戒者同型**，故不许只删不补：
#   收窄之同时**加一条更强的正向核**（见下 `header_check`）——
#   原检查只能说「那个数字还在」，新检查说的是「**那个数字必须等于沿革之最大版本、等于末条条目之版本，且不得倒退**」。
#   **减一个弱检查，须以一个强检查抵之；否则就是借修误报之名把闸拆了。**
PATS = [
    ('40位哈希',   r'(?<![0-9a-fA-F])[0-9a-f]{40}(?![0-9a-fA-F])'),
    ('32位指纹',   r'(?<![0-9a-fA-F])[0-9a-f]{32}(?![0-9a-fA-F])'),
    ('〔M〕条目号', r'〔M〕\d+'),
    ('纪元标签',   r'\bE\d+='),
    ('版本沿革行', r'(?m)^\*(v1[0-9]\.\d+)（'),   # 🔴 只认沿革行·**不认文件头**（头由 header_check 另核）
]
bad = 0
for name, pat in PATS:
    cb = collections.Counter(re.findall(pat, base))
    cc = collections.Counter(re.findall(pat, cur))
    drops = [(k, cb[k], cc.get(k, 0)) for k in cb if cc.get(k, 0) < cb[k]]
    if drops:
        bad += len(drops)
        print(f"  🔴 **{name}：{len(drops)} 个锚计数下降**")
        print()
        print("  | 锚 | HEAD 计数 | 工作树计数 | 判读 |")
        print("  |---|---:|---:|---|")
        for k, a, b in sorted(drops):
            v = '**归零·锚已灭**' if b == 0 else '计数减少'
            print(f"  | `{k}` | {a} | {b} | {v} |")
        print()
    else:
        print(f"  🟢 {name}：{len(cb)} 个锚全部存续（无下降）")
# ── 版本头三处一致核（**抵「版本行号」收窄之强检查**·只对台账主档生效）────────────
def header_check(cur, base):
    if '项目档案 · Portfolio State' not in cur.split('\n', 1)[0]:
        return None                      # 非台账主档·本核不适用
    def parse(t):
        h  = re.search(r'^#\s*项目档案 · Portfolio State（(v1[0-9]\.\d+)', t)
        vh = re.findall(r'(?m)^\*(v1[0-9]\.\d+)（', t)
        seg = t[t.index('\n## 〔M〕'):t.index('\n## 〔N〕')]
        le = re.findall(r'版本(v1[0-9]\.\d+)。', seg)
        key = lambda v: tuple(int(x) for x in v[1:].split('.'))
        return (h.group(1) if h else None,
                max(vh, key=key) if vh else None,
                le[-1] if le else None)
    ch, cv, cl = parse(cur)
    bh, _,  _  = parse(base)
    key = lambda v: tuple(int(x) for x in v[1:].split('.'))
    rows, ok = [], True
    rows.append(('文件头 H1', ch)); rows.append(('版本沿革之最大值', cv)); rows.append(('末条〔M〕之版本', cl))
    print("  ### 版本头三处一致核（**收窄「版本行号」类之抵偿检查**）")
    print()
    print("  | 处 | 值 |"); print("  |---|---|")
    for k, v in rows: print(f"  | {k} | `{v}` |")
    print()
    if not (ch and cv and cl):
        print("  🔴 三处之中有取不到者 —— **取数器失效即不合格，不得读作「无异常」**"); ok = False
    elif not (ch == cv == cl):
        print("  🔴 **三处不一致** —— 文件头／沿革最大值／末条条目须完全相同"); ok = False
    elif bh and key(ch) < key(bh):
        print(f"  🔴 **版本倒退**：HEAD 为 `{bh}`，工作树为 `{ch}`"); ok = False
    else:
        print(f"  🟢 三处一致且未倒退（HEAD `{bh}` → 工作树 `{ch}`）")
    print()
    return ok

hc = header_check(cur, base)
if hc is False:
    bad += 1

print()
if bad:
    print("  🔴 **本件不合格。照 -01④，须先复原被覆之旧内容，再谈新内容是否写对。**")
    print("  复原路径：`git show HEAD:<file>` 取原文，**以追加行方式还原**（不得 force-push，不得改写历史）。")
sys.exit(1 if bad else 0)
PY
  [ $? -ne 0 ] && RC=1
  rm -f /tmp/_ag_base.$$
  echo
done

echo "---"
echo
echo "## §主责栏（**-01④ 令「检测点与主责须于落实件内同书」·此处即其常驻副本**）"
echo
echo "| 检测点 | 触发时机 | 主责 |"
echo "|---|---|---|"
echo "| \`tools/anchor-guard.sh\` | **每轮收件对账**（\`daily-recon.sh\` 内置调用·自动） | **CGM** |"
echo "| 同上 | **纪元激活前**（\`activate-epoch.sh\` §0 前置·自动） | **CGM** |"
echo "| 同上 | **凡手工按位置改写台账／宪法／章程之多行结构后·push 前**（手动跑） | **CGM** |"
echo "| 本器**盲区**之复核（散文覆写、基准已带伤） | 签收时 | **GM**（可读本器源码并复跑推翻） |"
echo
if [ $RC -ne 0 ]; then echo "**🔴 总判：有锚下降，不合格。**"; else echo "**🟢 总判：全部锚存续。**"; fi
exit $RC
