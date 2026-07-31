#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁·2026-08-01·委托人「发」）
#   本体系一切「日／龄／截止日／当日摘要之当日／件号日期」之日界一律以 SGT 计。
#   依据非新造：委托人系港／新双重税务居民；早晚简报早已按 09:00／21:00 SGT 立并以 SGT 命名归档。
#   🔴 例外（-0801-01②）：**市场事件日不受本裁管**——财报日、财报后 N 交易日窗口、经济数据发布时点
#      一律按各该市场本地日历计，**援引须标市场**（如「SPGI 窗口 8-04·美东」）。
#      其由：SGT 与美东差 12–13 小时，三日以内之窗口会被算错整整一日。
export TZ=Asia/Singapore
# 日对账 · 五源机械扫描（委托人直令 2026-07-31「最重要内容改成日对账制度」·〔M〕446）
#
# 设计取舍（写在这里，免得后人以为是随手挑的）：
#   周对账八源中，本脚本只跑 ①②③⑦⑧ 五源——判据＝**该源之义务本身是日频的，或一天的滞后即是失效本身**。
#   ⑦「记忆摘要每日入库」系宪法§六之二最高原则，**日频义务原本却配周频检测，本身即结构缺陷**——此系本制度最强之立项理由。
#   ⑧ 系 CGM 自罚项（2026-07-31 落后 68 版，经委托人质询方查出）。
#   ①②③ 皆有实际失管前科（inbox 六件隔离／112 件签收被结构性掩盖／TMO 强制重画逾期 3 日）。
#   ④⑤⑥（全档 grep 待补候裁／回执内候 GM／复裁与 EXT 在途）**留周频**——重且一天滞后无害。
#   **并入不减项**：周对账八源一条不减、照跑；日对账系**加一层高频闸**，不是把周对账拆掉。
#
# 用法： bash tools/daily-recon.sh [YYYY-MM-DD]
#   不给日期则用系统日期。**⚠️ 本容器时钟曾被委托人当面否证过一次（〔M〕433①）**，
#   故脚本**总是打印所用日期**，使异常可见；对账日有疑义时由人给日期参数，不由脚本猜。

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
D="${1:-$(date +%F)}"
OUT="docs/daily-recon/${D}.md"
mkdir -p docs/daily-recon

RED=0   # 标红计数
say() { printf '%s\n' "$*"; }

{
say "# 日对账 · ${D}"
say ""
say "> 生成：\`bash tools/daily-recon.sh ${D}\`｜**所用日期＝${D}**（系统日期为 \`$(date +%F)\`）"
say "> **边界（照周对账 (D) 之同一纪律）**：本表**只出证据、只标红，不作裁定**；**CGM 不得自行销项**（销项须有裁决或委托人一字为据）；定时会话之治理只读纪律照旧。"
say ""
say "| 源 | 项 | 计数 | 结果 | 主责 |"
say "|---|---|---:|---|---|"

# ── 源① 两 inbox 在途包裹 ───────────────────────────────────────────
A=$(ls adj-inbox/*.md 2>/dev/null | grep -v 'README' | wc -l | tr -d ' ')
G=$(ls gm-inbox/*.md 2>/dev/null | grep -v 'README' | wc -l | tr -d ' ')
S1=$((A+G))
if [ "$S1" -gt 0 ]; then R="🔴 在途"; RED=$((RED+1)); else R="🟢 清空"; fi
say "| ① | adj-inbox／gm-inbox 在途包裹 | ${S1}（adj ${A}／gm ${G}） | ${R} | CGM |"

# ── 源② 未签收回执（四判据·复用既有脚本，不另造一把尺）──────────────
U=$(python3 tools/receipt-signoff-scan.py 2>/dev/null | grep -o '未签 [0-9]*' | grep -o '[0-9]*' | tail -1)
U="${U:-ERR}"
if [ "$U" = "ERR" ]; then R="⚠️ 扫描未返回计数——**默认先疑扫描坏了**（照反退化闸①）"; RED=$((RED+1));
elif [ "$U" -gt 0 ]; then R="🔴 Breach 候选"; RED=$((RED+1)); else R="🟢 零未签"; fi
say "| ② | 未签收回执（裁决侧·四判据） | ${U} | ${R} | GM |"

# ── 源③ 〔K-0〕逾期制度动作 ─────────────────────────────────────────
OV=$(python3 - "$D" <<'PY'
import re,sys
d=sys.argv[1]
rows=[l for l in open('portfolio-state.md',encoding='utf-8') if l.startswith('|') and '待执行' in l]
for l in rows:
    f=l.split('|')
    if len(f)<3: continue
    cell=f[1]
    # 「自YYYY-MM-DD 起算」系起算日非触发日——先剔除，免把起算日误报为逾期
    cell=re.sub(r'自\s*20\d\d-\d\d-\d\d[^）)]*[）)]?', '', cell)
    cell=re.sub(r'自\s*20\d\d-\d\d-\d\d', '', cell)
    ds=re.findall(r'20\d\d-\d\d-\d\d', cell)
    obj=f[2].strip().replace('*','')
    if not ds:
        continue   # 非日期型触发条件（如「第2个财报季结束后30日内」）→ 本脚本不判，留周频人核
    t=ds[0]
    if t <= d: print(f"{t}|{obj}")
PY
)
N3=$(printf '%s' "$OV" | grep -c . || true)
if [ "$N3" -gt 0 ]; then R="🔴 逾期 $(printf '%s' "$OV" | tr '\n' ';')"; RED=$((RED+1)); else R="🟢 无逾期"; fi
NDATE=$(grep -c '待执行' portfolio-state.md || true)
say "| ③ | 〔K-0〕触发日≤${D} 而仍「待执行」 | ${N3} | ${R} | 逐项按表 |"
say "| ③b | 〔K-0〕**非日期型触发条件**之「待执行」行（如「第2个财报季结束后30日内」「Q3电话会时」）——**本脚本不判、留周频人核**·不得因未标红而当作无事 | $((NDATE-N3)) | ⚠️ 须人核 | GM |"

# ── 源⑦ 记忆摘要当日缺档（宪法§六之二·最高原则）───────────────────
# 容忍并日件形态（如 gm-2026-07-30_31.md）：凡文件名含该日期数字段者皆计为在档。
DD="${D//-/}"; Y="${D%%-*}"; MD="${D#*-}"
gm_hit=$(ls docs/memory-digests/ 2>/dev/null | grep -c -e "gm-${D}" -e "gm-.*_${MD#*-}\.md" || true)
cg_hit=$(ls docs/memory-digests/ 2>/dev/null | grep -c -e "cgm-${D}" -e "cgm-.*_${MD#*-}\.md" || true)
miss=""
[ "$gm_hit" -eq 0 ] && miss="${miss}GM "
[ "$cg_hit" -eq 0 ] && miss="${miss}CGM "
if [ -n "$miss" ]; then R="🔴 缺档：${miss}（**缺席须显式标注「当日无该侧会话」·未标注即计缺档**）"; RED=$((RED+1)); else R="🟢 两侧皆在档"; fi
say "| ⑦ | \`docs/memory-digests/\` 当日原声件 | GM ${gm_hit}／CGM ${cg_hit} | ${R} | 各自 |"

# ── 源⑧ gm-snapshot 戳 vs 台账版本（CGM 自罚项）──────────────────────
LAG=$(python3 - <<'PY'
import re
led=open('portfolio-state.md',encoding='utf-8').readline()
snap=open('docs/gm-snapshot.md',encoding='utf-8').read()[:1200]
lv=re.search(r'v16\.(\d+)',led); sv=re.search(r'台账\s*\*{0,2}v16\.(\d+)',snap) or re.search(r'v16\.(\d+)',snap)
if not lv or not sv: print("ERR|ERR|ERR")
else: print(f"{lv.group(0)}|{sv.group(0) if sv.group(0).startswith('v') else 'v16.'+sv.group(1)}|{int(lv.group(1))-int(sv.group(1))}")
PY
)
LV="${LAG%%|*}"; rest="${LAG#*|}"; SV="${rest%%|*}"; N8="${rest##*|}"
if [ "$N8" = "ERR" ]; then R="⚠️ 版本号解析失败——**先疑扫描坏了**"; RED=$((RED+1));
elif [ "$N8" -gt 5 ]; then R="🔴 落后 ${N8} 版（>5 版即标红）"; RED=$((RED+1));
elif [ "$N8" -gt 0 ]; then R="🟡 落后 ${N8} 版（未越 5 版闸）"; else R="🟢 同版"; fi
say "| ⑧ | gm-snapshot 戳 vs 台账版本 | 台账 ${LV}／戳 ${SV} | ${R} | CGM |"

# ── 源⑨ 台账增长闸（ADJ-0731-54⑥-b 三·2026-07-31 立）─────
LG=$(python3 - <<'LEDGER'
import io,re
raw=io.open("portfolio-state.md",encoding="utf-8").read()
seg=raw[raw.index("\n## 〔M〕"):raw.index("\n## 〔N〕")]
nums=[int(m.group(1)) for m in re.finditer(r"(?m)^(\d+)\. \*\*",seg)]
print(f"{len(raw.encode())}|{max(nums)}|{max(nums)-200}")
LEDGER
)
LB="${LG%%|*}"; lr="${LG#*|}"; LM="${lr%%|*}"; LN="${lr##*|}"
if [ "$LN" -ge 200 ]; then R="🔴 〔M〕自上次归档已新增 ${LN} 条（≥200 即触发归档批次）"; RED=$((RED+1));
else R="🟢 距 200 条余 $((200-LN)) 条"; fi
say "| ⑨ | **台账增长闸**：主档字节／〔M〕末号／距 200 条触发（**上限值候 GM 裁·-54⑥-b 一**） | ${LB} B／〔M〕${LM}／新增 ${LN} | ${R} | CGM 出数·GM 裁 |"
say "| ⑨b | **⚠️ 上限尚未裁定** —— **-54⑥-b 四明令「上限与检测同一件内立」，而本源只得其半**：在上限裁定前，本源**只能测「200 条」一条触发，测不了「超上限」那一条**——如实标，**不以半闸充全闸** | — | ⚠️ 半闸 | GM |"

# ── 源⑩ 锚存续核（ADJ-0801-01④ 立·2026-08-01）─────────────────────
# 🔴 立此源之由（GM 加严逐字）：「**须落进工具（写入相应脚本之前置检查），不得仅存于知识库条文**」
#    ——因「一条只写在文档里、依赖执行者当时记得的规则」，**定上限不立检测，等于没定**。
#    本源即该检测之**自动触发点**；主责 CGM。事故原型＝`c40c6ecc` 覆盖 E8/E7/E6/E5 历史锚。
AG=$(bash tools/anchor-guard.sh portfolio-state.md docs/constitution.md docs/succession/gm-succession.md 2>&1)
AGRC=$?
AGDROP=$(printf '%s' "$AG" | grep -c '锚计数下降' || true)
if [ "$AGRC" -ne 0 ]; then R="🔴 **有锚计数下降（${AGDROP} 类）——旧内容被覆写，须先复原**"; RED=$((RED+1));
else R="🟢 三件之锚全部存续（无下降）"; fi
say "| ⑩ | **锚存续核**（\`tools/anchor-guard.sh\`·**验旧内容是否仍在，非验新内容是否对**） | HEAD→工作树·台账／宪法／章程 | ${R} | CGM |"
say "| ⑩b | **本器盲区如实列**：只核锚形串（散文覆写看不见）／只核 HEAD→工作树（同轮先坏后 commit 则基准已带伤）／系**事后核**非阻断——**不得读作该风险已消除** | — | ⚠️ 有盲区 | GM 复核 |"

say ""
say "**标红合计：${RED} 项**"
say ""

# ── 反退化闸：与前一日对账计数逐源对照 ───────────────────────────────
PREV=$(ls docs/daily-recon/*.md 2>/dev/null | grep -v "${D}" | tail -1)
say "## 反退化闸（照周对账 (C)·**零命中默认先疑扫描坏了，而非工作做完了**）"
say ""
if [ -n "$PREV" ]; then
  say "前一期＝\`${PREV}\`。逐源计数对照："
  say ""
  say '```'
  paste <(grep -o '^| [①②③⑦⑧] |' "$PREV" 2>/dev/null) <(grep -oP '(?<=\| )[0-9]+(?=（|$| \|)' "$PREV" 2>/dev/null) 2>/dev/null | head -8
  say '```'
  say ""
  say "**若某源本期骤降为零而前期非零，须在本表下方逐一交代「减少之项去向」——不得以零命中直接报「无在途」。**"
else
  say "**本期系首期，无前期可对照**——如实标注，不以「无对照」充「无异常」。下期起本节须给出逐源计数对照。"
fi
say ""
say "## 未纳入本日对账者（如实列·不以日对账充全量）"
say ""
say "周对账八源中之 **④台账内「待补/待核/待报/悬置/候裁/候委托人」全文 grep**、**⑤\`adj-archive\` 回执内「候GM/候裁/未闭合」全档 grep（跨纪元之要害）**、**⑥复裁清单／EXT 在途／外审候启** —— **三源留周频，本日未跑**。"
say "另：周对账之 **(B) 四字段（项文·龄·主责·下一动作）与「无主项」标红**、**碎片化度量**、**条文引用一致性抽查**、**Breach 检查**、**存档与线上 prompt 一致性** —— **皆留周频**。"
say ""
say "---"
say "*生成于 \`tools/daily-recon.sh\`｜只出表不裁定｜CGM 不得自行销项*"
} > "$OUT"

cat "$OUT"
say ""
say "→ 已写入 ${OUT}"
[ "$RED" -gt 0 ] && say "→ **本期标红 ${RED} 项·须于当班产出正文内呈报**"
exit 0
