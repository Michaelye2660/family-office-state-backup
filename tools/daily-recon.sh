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

# ── 源②b 签收时限（ADJ-0801-05③④ 立·2026-08-01）──────────────────
# 🔴 立此源之由（-05④ 逐字）：欠账「**不是存量，是无时限之队列**」——
#    「**把 77 签成 0，不改变任何结构性事实**，次日照涨」。
#    故源② 之单一计数**不足以说明问题**；须并报**逾时限件数**（时限＝3 SGT 日 或 其后第 1 个
#    委托人驱动之 GM 会话结束时·**孰后为准**）。**不治流量则欠账必然复发。**
SQ=$(bash tools/signoff-queue.sh 2>/dev/null)
OV=$(printf '%s' "$SQ" | grep -o '逾时限（代理判）＝[0-9]*' | grep -o '[0-9]*' | head -1)
NY=$(printf '%s' "$SQ" | grep -o '(a) 过而 (b) 未满足＝[0-9]*' | grep -o '[0-9]*' | head -1)
OV="${OV:-ERR}"
if [ "$OV" = "ERR" ]; then R="⚠️ 队列器未返回计数——**默认先疑扫描坏了**"; RED=$((RED+1));
elif [ "$OV" -gt 0 ]; then R="🟡 **逾时限 ${OV} 件（代理判·非实测）** —— 照 -05③ 须书不签之由·**不签亦可，惟不得静默滞留**"; RED=$((RED+1));
else R="🟢 无逾时限件"; fi
say "| ②b | **签收时限**（\`tools/signoff-queue.sh\`·**队列非存量**） | 逾时限 ${OV}／(a)过而(b)未满足 ${NY:-0} | ${R} | GM 签收·CGM 出数 |"
say "| ②c | **⚠️ (b) 不可直接观测** —— 本器以「落库后是否出现过 \`[裁决侧·GM-*]\` 提交」作**代理**；**代理≠实测**，故一律出 🟡 不出 🔴，**使「未实测」在表面上永远可见** | — | ⚠️ 代理判 | GM 可推翻 |"

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

# ── 源③c 治理产出闸之收件时机械报（ADJ-0801-07⑧ 立·2026-08-01）──────
# 🔴 闸之条文（-07⑧ 逐字）：「**凡〔K-0〕日历内挂钟之市场项未办结，不得投递纯治理类 ADJ。**」
#   **主责＝GM**；**CGM 于收件时机械报「本件投递时有无逾期挂钟项」，只报不拒**（-07⑧ 明定之边界）。
#   缘起照录（E11 交接书 §六 第4句）：「GM 自身治理产出之闸，E10 说它没立，本席也没立
#   ——两代都欠着，交给你。」**效力自 `ADJ-0801-07` 之后一件起**（其立法者不给自己发豁免，
#   已于该件 ⑨ 自陈本件即闸第一个该拦之对象并登记自违）。
# 🔴 本源之边界：**只报「有无逾期挂钟项」这一机械事实，不判任何一件 ADJ 该不该投**——
#   后者属判断类，专属 GM／委托人。
if [ "$N3" -gt 0 ]; then
  say "| ③c | **治理产出闸**（\`-07⑧\`·**CGM 只报不拒**）：〔K-0〕逾期挂钟项 | ${N3} | 🔴 **有逾期挂钟项 —— 照 -07⑧ 不得投递纯治理类 ADJ** | GM |"
else
  say "| ③c | **治理产出闸**（\`-07⑧\`·**CGM 只报不拒**）：〔K-0〕逾期挂钟项 | 0 | 🟢 无逾期挂钟项·闸不拦 | GM |"
fi
say "| ③d | **⚠️ 本闸只测日期型挂钟行** —— 非日期型触发条件（见 ③b ${NDATE_NONDATE:-$((NDATE-N3))} 行）**本器判不了**；**不得因 ③c 绿而认为闸已全测** | — | ⚠️ 半测 | GM |"

# ── 源⑦ 记忆摘要当日缺档（宪法§六之二·最高原则）───────────────────
# 容忍并日件形态（如 gm-2026-07-30_31.md）：凡文件名含该日期数字段者皆计为在档。
DD="${D//-/}"; Y="${D%%-*}"; MD="${D#*-}"
# 🔴 须锚定行首（CGM 立 ⑦b 当轮顺带自捕·2026-08-01）：
#   原式作 `grep -e "gm-${D}"`，**而 `cgm-2026-08-01.md` 内含子串 `gm-2026-08-01`**
#   —— 故 CGM 之件被一并计入 GM 之数（本日实测：报「GM 5」，真值 3）。
#   **其真正的害不在数偏大，在于：某日 GM 若无摘要而 CGM 有，本源会把 GM 报成在档。**
#   一个把别人的作业算成自己交了的检查，正是本仓反复记载之「存在性检查被读成义务已尽」。
gm_hit=$(ls docs/memory-digests/ 2>/dev/null | grep -c -e "^gm-${D}" -e "^gm-.*_${MD#*-}\.md" || true)
cg_hit=$(ls docs/memory-digests/ 2>/dev/null | grep -c -e "^cgm-${D}" -e "^cgm-.*_${MD#*-}\.md" || true)
miss=""
[ "$gm_hit" -eq 0 ] && miss="${miss}GM "
[ "$cg_hit" -eq 0 ] && miss="${miss}CGM "
if [ -n "$miss" ]; then R="🔴 缺档：${miss}（**缺席须显式标注「当日无该侧会话」·未标注即计缺档**）"; RED=$((RED+1)); else R="🟢 两侧皆在档"; fi
say "| ⑦ | \`docs/memory-digests/\` 当日原声件 | GM ${gm_hit}／CGM ${cg_hit} | ${R} | 各自 |"

# ── 源⑦b 当日件之**覆盖核**（CGM 自捕后补·2026-08-01）───────────────
# 🔴 立此源之由（本席自陈·系本日第四次撞上同一形态）：
#   源⑦ 只测「当日有没有这个文件」，**不测这个文件覆不覆盖当日的事**。
#   实证：`cgm-2026-08-01.md` 落于本日早段，**其后本席又办六件 ADJ、三份呈报、五个新工具、
#   台账四条条目——全不在件内**，而源⑦ 照报 🟢「两侧皆在档」。
#   **一个只测存在性的检查，会被读成「义务已尽」** —— 同型于委托人所指之
#   「空的收件箱不是『无待办』之证据」与「A3 已办而无人回头销它」。
# 判据（机械·只报不裁）：该侧当日**最后一次提交**之时点，是否晚于其当日摘要件之**最后一次改动**。
#   晚者即报 🟡「在档但落后其后 N 个提交」——**不判其内容是否足够，只判其是否可能未覆盖**。
# 🔴 取件须按**时点**不按字典序（本日同族第五例·CGM 立本源当轮自捕）：
#   `ls | tail -1` 取字典序末位，而 `gm-2026-08-01-part2.md` **<** `gm-2026-08-01.md`
#   （`-`＝0x2D 小于 `.`＝0x2E），故它取到的是**基础件而非最新追加件**——
#   与 `_latest-handover.py` 所记之「E11 骨架 < E9 骨架」**同一族**。
#   **凡以「最新」取件者，一律按数值／时点序** —— 此规本日已第五次被同一形态验证。
cov_report(){  # $1=侧名 $2=文件通配 $3=提交主题之判别模式
  local side="$1" pat="$2" mode="$3" f last_d n c ts best_ts
  best_ts=-1; f=""
  for c in $(ls docs/memory-digests/ 2>/dev/null | grep -e "$pat"); do
    ts=$(git log -1 --format=%ct -- "docs/memory-digests/$c" 2>/dev/null)
    [ -z "$ts" ] && ts=9999999999          # 未提交＝本轮新写，视为最新
    if [ "$ts" -gt "$best_ts" ]; then best_ts="$ts"; f="$c"; fi
  done
  [ -z "$f" ] && { say "| ⑦b-${side} | 覆盖核 | — | ⚪ 无当日件·见源⑦ | ${side} |"; return; }
  last_d="$best_ts"
  [ "$last_d" -eq 9999999999 ] && { say "| ⑦b-${side} | **覆盖核** | \`${f}\`（**本轮新写·尚未提交**） | 🟢 当日件即本轮所写 | ${side} |"; return; }
  if [ "$mode" = "gm" ]; then
    n=$(git log --format='%ct %s' --since="@$last_d" 2>/dev/null | awk '$2 ~ /^\[裁决侧·GM/ {c++} END{print c+0}')
  else
    n=$(git log --format='%ct %s' --since="@$last_d" 2>/dev/null | awk '$2 !~ /^\[裁决侧·GM/ {c++} END{print c+0}')
  fi
  if [ "${n:-0}" -gt 0 ]; then
    say "| ⑦b-${side} | **覆盖核**：当日件之后该侧仍有提交 | \`${f}\` 后 **${n}** 个 | 🟡 **在档但可能未覆盖**——照宪法§六之二须补追加件（**追加不重写**·\`-34③\`） | ${side} |"
    RED=$((RED+1))
  else
    say "| ⑦b-${side} | **覆盖核** | \`${f}\` 后 0 个 | 🟢 当日件不落后于该侧最后一次提交 | ${side} |"
  fi
}
cov_report GM  "^gm-${D}"  gm
cov_report CGM "^cgm-${D}" cgm
say "| ⑦c | **⚠️ 本核只判「时序上是否可能未覆盖」，不判内容是否足够**——**内容之足够属判断类，不可机械判** | — | ⚠️ 有界 | GM |"

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
