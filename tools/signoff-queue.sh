#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# 签收队列与时限核 —— ADJ-0801-05③④⑤ 立｜主责 CGM 出数·GM 签收
#
# 🔴 本器之立项理由（-05④ 逐字）：
#   「欠账**不是存量，是无时限之队列**」——「**把 77 签成 0，不改变任何结构性事实**，次日照涨」；
#   「**存量清零只会让下一任在一个新数字前重新问同一个问题，而它看起来像是被解决过。**」
#   故本器**不报单一存量数**，报**队列**：逐件之入队时点、龄、是否逾时限。
#
# 🔴 两义分立（-05①·不得混用·本器逐件分列）：
#   **签收**＝「本席已阅该回执，并认可其所载之执行与判读」——**须能复述该件之核心裁项**；
#   **纪元结转登记**＝「本届知悉其存在，不追认其内容」——**只登记件号与纪元，不构成任何认可**。
#   `-0731-35` 加严三已写死「**仅验是否读过即退化为打勾**」；
#   **批量签一份未读之回执，比不签更坏——它把「未核」变成了「已核」之留痕，而留痕比空白更难被后人怀疑。**
#
# 🔴 时限（-05③·**孰后者为准**）：
#   (a) 回执落库后 **3 个 SGT 日**内；**或** (b) 其后**第 1 个委托人驱动之 GM 会话结束时**。
#   **(b) 之所以并列**：纯按日计会在纪元交接空窗期自动生出假逾期，
#   而「**一条会把无人当值的日子算成有人失职的规则，会训练出对红旗的麻木**」。
#
# 🔴 本器之盲区（先列·免「未报」被读作「已核无事」）：
#   (i)  **(b) 不可直接观测**——本器以「回执落库后是否出现过 `[裁决侧·GM-*]` 之提交」作**代理**。
#        代理≠实测：GM 会话可能未留提交，亦可能一次会话留多次提交。**凡以代理判逾期者一律出 🟡 不出 🔴**，
#        并在同行注明系代理判读，**使「未实测」在表面上永远可见**。
#   (ii) 「签收」与「纪元结转登记」之别，本器**只能按标记串分**；**标记写错者本器分不出**。
#   (iii) 本器**不判任何一件该不该签**——**签收属 GM 专权，本器一字不涉。**
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
LIMIT_DAYS="${1:-3}"

# ── 🔴 前置核：仓库历史深度（CGM-G5 补 · 2026-08-01 · SGT）───────────────
#   本器之「入队时点」取自 `git log --diff-filter=A -- <回执>`；**浅克隆下该读数会静默失真**
#   （一切早于浅边界之文件皆解析为边界提交 → 龄全部 ≤3 日 → 逾时限 48 变 0）。
#   立案实证与波及面见 `tools/_repo-depth-guard.sh` 文件头。**fail-closed：不出表，不出假绿。**
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "签收队列与时限核"; exit 3; fi

python3 - "$LIMIT_DAYS" <<'PY'
import glob, io, os, re, subprocess, sys, datetime, collections

LIMIT = int(sys.argv[1])
SGT = datetime.timezone(datetime.timedelta(hours=8))

def sh(*a):
    return subprocess.run(a, capture_output=True, text=True).stdout.strip()

COMMIT = sh('git', 'log', '-1', '--format=%H')
NOW_SRC = sh('git', 'log', '-1', '--format=%aI')          # 以 HEAD 之作者时点为「本刻」下界
now = datetime.datetime.fromisoformat(NOW_SRC).astimezone(SGT)

# ── 🔴 签收判据：**只从单一正本 import，本器不自持一份正则** ─────────
#   本器初版自抄了一份四判据并顺手把 `GM-\d` 放宽为 `GM-\d+`，
#   结果与 `receipt-signoff-scan.py` **当场对不上（80 vs 79）**，
#   且该放宽把一句「零发令**零签收**零投递」判成了「已签」——
#   **一句声明「什么都没签」的话，被判成了「已签」。**
#   病史与否定闸见 `tools/_signoff_predicate.py` 之文件头。
sys.path.insert(0, 'tools')
from _signoff_predicate import is_signed, is_carried

files = [f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]

rows = []
for f in files:
    b = os.path.basename(f).replace('-receipt.md', '').replace('.md', '')
    t = io.open(f, encoding='utf-8', errors='replace').read()
    signed = is_signed(f, t)
    carried = is_carried(f, t)
    land = sh('git', 'log', '--diff-filter=A', '--format=%aI', '--', f).split('\n')[-1]
    if land:
        d = datetime.datetime.fromisoformat(land).astimezone(SGT)
        age = (now.date() - d.date()).days
    else:
        d, age = None, None
    # (b) 之代理：落库后是否出现过裁决侧提交
    gm_after = 0
    if land:
        out = sh('git', 'log', '--format=%s', f'--since={land}')
        gm_after = sum(1 for ln in out.split('\n') if ln.startswith('[裁决侧·GM'))
    rows.append(dict(b=b, f=f, signed=signed, carried=carried,
                     land=d, age=age, gm_after=gm_after))

unsigned = [r for r in rows if not r['signed']]
carry_only = [r for r in unsigned if r['carried']]
queue = [r for r in unsigned if not r['carried']]

print("# 签收队列与时限核（ADJ-0801-05③④⑤ · **只出表不裁定·签收属 GM 专权**）")
print()
print(f"- **🔴 读取 commit**：`{COMMIT}`（`-05⑤` 令「凡引用该数者须同书读取 commit 或时刻」——"
      f"**对一个动态数只标日期不标时点，即违本仓「每个数字标 as-of 时点」之明文**）")
print(f"- **本刻（下界）**：{now.strftime('%Y-%m-%d %H:%M')} SGT ＝ HEAD 之作者时点"
      f"（**容器时钟曾被委托人当面否证过一次**，故不用 `date`，用 commit 时戳作下界）")
print(f"- **时限**：{LIMIT} 个 SGT 日 **或** 其后第 1 个委托人驱动之 GM 会话结束时 —— **孰后者为准**")
print()

# ── §一 队列总览（**非存量**）────────────────────────────────────
print("## §一 · 队列总览（**-05④：欠账不是存量，是无时限之队列**）")
print()
print("| 口径 | 数 |")
print("|---|---:|")
print(f"| 回执总件（已排除签收片） | {len(files)} |")
print(f"| **已签收**（`-05①` 甲义·已阅并认可） | {len(rows)-len(unsigned)} |")
print(f"| **纪元结转登记**（`-05①` 乙义·**知悉而不追认·不计已签**） | {len(carry_only)} |")
print(f"| **🔴 在队（既未签收亦未结转）** | **{len(queue)}** |")
print()
print("**🔴 此数系单调增数列之一个切片，不是存量**：每新出一份回执即 +1，签收前恒计在队。"
      "**把它签成 0 不改变任何结构性事实——次日照涨。** 故本器之要害在下表之「龄」与「逾时限」两栏，不在上表之总数。")
print()

# ── §二 龄分布（队列之形态）───────────────────────────────────
print("## §二 · 龄分布（**队列之形态·比总数更能说明问题**）")
print()
buckets = collections.Counter()
for r in queue:
    a = r['age']
    k = '龄不可得' if a is None else ('≤3 日（未逾 (a)）' if a <= LIMIT else
        ('4–7 日' if a <= 7 else ('8–30 日' if a <= 30 else '>30 日')))
    buckets[k] += 1
print("| 龄段 | 件数 |")
print("|---|---:|")
for k in ['≤3 日（未逾 (a)）', '4–7 日', '8–30 日', '>30 日', '龄不可得']:
    if buckets.get(k):
        print(f"| {k} | {buckets[k]} |")
print()

# ── §三 逐件（逾时限者在前）──────────────────────────────────
over = [r for r in queue if r['age'] is not None and r['age'] > LIMIT]
over.sort(key=lambda r: -r['age'])
print(f"## §三 · 逐件（在队 {len(queue)} 件·**逾 (a) 者 {len(over)} 件**）")
print()
print("| 件 | 入队（SGT） | 龄(日) | (a) {}日 | (b) 代理：其后裁决侧提交数 | 判 |".format(LIMIT))
print("|---|---|---:|:--:|---:|---|")
for r in over:
    b_ok = r['gm_after'] > 0
    verdict = ('🟡 **逾时限（代理判·非实测）** —— (a) 已过且 (b) 代理满足'
               if b_ok else '⚪ (a) 已过·**(b) 未满足** —— 照「孰后为准」**尚未逾期**')
    print(f"| `{r['b']}` | {r['land'].strftime('%Y-%m-%d')} | {r['age']} | 🔴 已过 | {r['gm_after']} | {verdict} |")
if not over:
    print("| —— | —— | —— | 🟢 | —— | 无逾 (a) 者 |")
print()
n_flag = sum(1 for r in over if r['gm_after'] > 0)
print(f"**🟡 逾时限（代理判）＝{n_flag} 件**；**⚪ (a) 过而 (b) 未满足＝{len(over)-n_flag} 件**（照「孰后为准」尚未逾期）。")
print()
print("**🔴 何以一律 🟡 不出 🔴**：(b)「委托人驱动之 GM 会话结束」**不可直接观测**，"
      "本器以「落库后是否出现过 `[裁决侧·GM-*]` 提交」作**代理**。"
      "**代理≠实测**——GM 会话可能未留提交，亦可能一次会话留多次提交。**故「未实测」须在表面上永远可见。**")
print()
print("**照 `-05③`**：逾期者入周对账 🔴，**并须书不签之由**——**不签亦可，惟须具名说明，不得静默滞留。**")
print()

# ── §四 本器不做之事 ──────────────────────────────────────
print("## §四 · 本器**不做**之事（先列不覆盖处·免「未报」被读作「已核无事」）")
print()
print("| 不做之项 | 谁来做 |")
print("|---|---|")
print("| **判任何一件该不该签** | **GM 专权**（`-05①`：须能复述该件核心裁项方可签） |")
print("| **代拟任何复述** | **GM**——**代拟即代读，正是 `-05①` 所禁之「打勾」** |")
print("| 判 (b) 之真实会话边界 | **GM／委托人**（本器只出代理读数） |")
print("| 分辨标记写错之件 | **GM**（本器只能按标记串分） |")
PY
