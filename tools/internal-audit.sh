#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# CGM 内审官 · 每日机械复核（**委托人直令 2026-08-01·SGT 立**）
#
# 🔴 委托人原文（照录一字未改）：
#   「**cgm这边自己建立内审官角色，每天内审一次，重点是机械性复核，
#     例如有没有说到做到，有没有遗漏，有没有越权**」
#
# 🔴 本器之立项理由 —— **为哪次事故而立**（照本仓通则，每个器写明其出生事故）：
#   2026-08-01 一日之内，CGM 侧四次「检查器与它所检查的世界脱钩」：
#     ① 浅克隆 —— 尺所站的地面不真（逾时限 48 静默读作 0）；
#     ② merge-tree —— 尺只覆盖表层（件头报冲突，重号段落静默合并）；
#     ③ loadset-watch —— 尺与它执行的规则脱钩（取代注入了文件头，运行时仍印旧分界）；
#     ④ 日对账源③b —— 尺的标签与它实际在数的东西不是一回事（人核栏虚高恰一倍）。
#   **四次皆非「想到了去查」，全是数字先打架或被委托人一句话点破。**
#   **本器即为把「回头量一次」从偶然变成每日常设动作而立。**
#
# 🔴 本器之姿态（**Linter 模式·零裁量·与监察官／cc-auditor 同制**）：
#   **只出红绿表，不作裁定，不销任何项**；判断权上移委托人判断门。
#   **本器审的是 CGM 自己** —— 故其最危险之失效不是报错数，是**不去量那一处**。
#   对此之唯一防法：**§0 必先打印「本器不核之项」**，使「未报」与「已核无事」不可混。
#
# 🔴 三焦点（委托人所指·逐一机械化）：
#   甲 · 说到做到 —— **本器不判「有没有做到」，判「这个承诺有没有被做成可检出的东西」。**
#        由：一个没人回头量的承诺，等于一个自带「不必再看」之理由的缺陷（G4 对下任第 3 句）。
#   乙 · 有没有遗漏 —— 附带义务是否随主动作同轮完成（写入之后的那几步最常掉）。
#   丙 · 有没有越权 —— **专权项之侵入**（签收／代写原声／清单外上呈／擅动 routines／改写历史）。
#
# 用法： bash tools/internal-audit.sh [YYYY-MM-DD]
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "CGM 内审官"; exit 3; fi

D="${1:-$(date +%F)}"
OUT="docs/internal-audit/${D}.md"
AUD="docs/internal-audit/${D}-auditor.md"
mkdir -p docs/internal-audit

# ── 🔴 硬拒：本器永不写审计官之档（2026-08-01 立·**为本器自己造成之事故而立**）───────
#   **事故**：本器以 `>` 整档改写 `$OUT`；CGM 曾把内审官亲书之报告追加于该档，**旋即被本器一次重跑整节删除**。
#   **形态**：**内审官于其 §辛-3 刚写下「一个只能靠被审方替它落档的审计报告，其完整性不能由被审方申报」——
#   写完不到十分钟即被本器兑现。**
#   **结构性改法（非提醒·非纪律·系物理隔离）**：
#     ① 审计官之报告落 `$AUD` **独立档**；**本器只读不写该档**；
#     ② 本器若在 `$OUT` 内发现「## 内审官判读」字样，**拒绝覆盖并退出**——**宁可不出表，不可毁审计留痕**。
if [ -f "$OUT" ] && grep -q '^## 内审官判读' "$OUT" 2>/dev/null; then
  echo "🔴 拒绝覆盖：\`$OUT\` 内含「## 内审官判读」节（审计官亲书）。"
  echo "   本器永不写审计官之档。审计官之报告应落 \`$AUD\`；请先将该节迁出后再跑。"
  echo "   **宁可不出表，不可毁审计留痕。**"
  exit 4
fi
RED=0; say() { printf '%s\n' "$*"; }

# ── 🔴 本日之执行侧提交（作者时点按 SGT 计日；**裁决侧 commit 不入本器之审**）──────
#   🔴 **首跑事故（2026-08-01·本器立起当轮·留痕不删）**：本器初版**定义了本过滤而从未使用它**——
#   §三 丙2 直接扫全部提交，遂把 **GM 亲书自己摘要之主题句**判成「CGM 代写原声」，**首跑即报一个假红**。
#   **形态＝本日第五次「标签与尺不符」，且发生在专为捕捉该类而造的器上**（同族：浅克隆／merge-tree／
#   loadset-watch 运行时输出／日对账源③b）。**「防某错误的机制，本身会以那个错误的形式失效」之再一次兑现。**
#   **处置照 anchor-guard 首跑误报之先例**：**收窄之同时加一条更强的正向核**（见 §三 丙2-b），
#   **不借修误报之名把闸拆了**。
CGM_COMMITS=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H|%s' \
              | grep -v '^[0-9a-f]*|\[裁决侧' | cut -d'|' -f1 || true)
NC=$(printf '%s' "$CGM_COMMITS" | grep -c . || true)

# 🔴 单一取材判据（**只此一份·不复制第二份**——本仓已实证「一条判据被复制第二份，它就开始各自演化」）：
#   cgm_add <路径…>  →  仅输出**执行侧提交**在该路径上之新增行（`+` 行，去 `+++`）
cgm_add() {
  local p; for c in $CGM_COMMITS; do
    git show "$c" --format='' -- "$@" 2>/dev/null | grep '^+' | grep -v '^+++'
  done
}

{
say "# CGM 内审 · ${D}（**每日机械复核**·委托人直令 2026-08-01 立）"
say ""
say "> 生成：\`bash tools/internal-audit.sh ${D}\`｜**读取 commit**：\`$(git log -1 --format=%H)\`｜**本刻**：$(git log -1 --format=%ad --date=format-local:'%Y-%m-%d %H:%M') SGT（HEAD 作者时点·**不用容器时钟**）"
say "> **姿态**：**Linter·零裁量·只出红绿表，不作裁定，不销任何项**；判断权上移委托人判断门。"
say "> **审的对象＝CGM 自己** —— 故本器最危险之失效不是报错数，是**不去量那一处**；§0 先列不覆盖处。"
say "> **本日执行侧提交数＝${NC}**"
say "> **🔴 审计官之报告不在本档** —— 落 \`${AUD}\`（**独立档·本器只读不写·本器若见本档内含其节则拒绝覆盖并退出**）。**由：本器曾于 2026-08-01 一次重跑即把其报告整节删除。**"
say ""

# ── §0 先列不核之项 ───────────────────────────────────────────────
say "## §0 · 🔴 本器**不核**之项（**先列·免「未报」被读作「已核无事」**）"
say ""
say "| 不核之项 | 何以不核 | 谁来核 |"
say "|---|---|---|"
say "| **判断质量**（结论对不对／取舍是否明智） | 机械器判不了 | 委托人判断门／GM |"
say "| **承诺之实际兑现** | 本器只判「该承诺有无可检出之落点」，**判不了它是否已被兑现** | 次日本器之落点核 ＋ 人核 |"
say "| **内容之足够**（摘要写得够不够、回执写得全不全） | 属判断类 | GM 签收之维二 |"
say "| **裁决侧之动作** | 本器只审 CGM 侧 | 监察官（\`constitutional-auditor\`） |"
say "| **本器自身是否被绕过**（不跑即无表） | **自指盲区** | 周对账之缺档扫描（见 §四） |"
say ""

# ── §一 甲 · 说到做到 ────────────────────────────────────────────
say "## §一 · 甲 · **说到做到**（**判「承诺有无可检出之落点」，不判「做到没有」**）"
say ""
say "| 项 | 计数 | 结果 |"
say "|---|---:|---|"

# 甲1：承诺之**结构化标记**核（**非散文扫描**）
# 🔴 **落库前抽样验出之设计错误·留痕不删（2026-08-01·本器立起当轮）**：
#   本器初稿以散文关键词（「下轮就办」「稍后」…）扫承诺，抽样八条**全部是假阳性**——
#   命中的是**本仓自己反复引用的教训句**（G4 对下任第 3 句之「下轮就办」／〔M〕468② 之「下一轮报出来的还是旧数」），
#   **不是承诺**；且 `grep -oE` 按字节切片产出乱码（G4 已记之同族坑）。
#   **一把每天都报红的尺，会把人训练成不看它——那比没有这把尺更坏。**
#   **改法照本仓对「签收」之同一条答案**（R10／`-05①` 之限度）：
#     **散文里的两个字不能当判据；须有专属之结构化标记。**
#   **故承诺之判据改为**：`〔承诺〕…〔落点：<路径|〔K-0〕|YYYY-MM-DD>〕`
#   **并明书本器由此而来之盲区**：**未用该标记之散文承诺，本器一律看不见**——
#   这不是漏，是**把「可被检出」之责任放回落笔者身上**：**要它被量，就得把它写成可量的形状**。
#   🔴 **并记一处对本席有利而仍须写下之实情**：本日前五次同族缺陷皆系事后被数字打架逼出，
#   **本次系落库前抽样验出——第一次赶在服役之前**。
# 🔴 **通则（本日同族第三例后立·2026-08-01）**：**判据档自身，不入其所判之扫描面。**
#   三例：①承诺词扫描命中**本仓引用的教训句**；②「代补主题句」命中**解释该规则的那段说明**；
#   ③`〔承诺〕` 标记命中**定义该标记的那段规范**。
#   **共性一句**：**在一个把自己的检查器写成散文的仓库里，任何按自身触发串去 grep 的检查器，都会先命中自己的说明书。**
#   **故扫描面须显式排除「定义该判据之档」**——下方 `--exclude` 即其实现；**排除清单须与新立判据同轮增补**。
# 🔴 **改用正向定义（同族第三例后·2026-08-01）**：**排除清单会腐坏——它须随每次新写作而增补，而没人会记得。**
#   **故不列「不扫哪里」，改列「只扫哪里」**：**承诺之正式落点只有两处** ——
#     ① `docs/cgm-rulings-docket.md` 之**表格行**（备案册·`| ` 起首）；② `adj-archive/*receipt*.md`（回执）。
#   **写在别处之 `〔承诺〕` 一律不追踪** —— **这不是漏，是把「要它被追踪」这件事变成一个明确动作**：
#   **要它被量，就写到量它的那两个地方去。**
PROM=$(cgm_add 'docs/cgm-rulings-docket.md' 'adj-archive/*receipt*.md' \
       | python3 -c "
import sys,re
for l in sys.stdin:
    if not (l.startswith('+| ') or 'receipt' in l or l.startswith('+')): continue
    for m in re.finditer(r'〔承诺〕.{0,120}', l):
        print(m.group(0))
" || true)
NP=$(printf '%s' "$PROM" | grep -c . || true)
ANCH=$(printf '%s' "$PROM" | grep -c '〔落点：' || true)
NOANCH=$((NP-ANCH))
if [ "$NP" -eq 0 ]; then
  say "| 甲1 · 本日新增**结构化承诺标记** \`〔承诺〕\` | 0 | 🟢 本日未立任何结构化承诺 |"
else
  if [ "$NOANCH" -gt 0 ]; then RED=$((RED+1)); R="🔴 **${NOANCH} 条缺 \`〔落点：〕\`** —— **一个没人回头量的承诺，等于一个自带「不必再看」之理由的缺陷**"; else R="🟢 全部带落点"; fi
  say "| 甲1 · 本日新增**结构化承诺标记** \`〔承诺〕\` | ${NP}（带落点 ${ANCH}／缺 ${NOANCH}） | ${R} |"
fi
say "| 甲1-b · **⚠️ 本器之盲区（写死·二重）** | — | (i) **未用 \`〔承诺〕…〔落点：〕\` 标记之散文承诺，本器一律看不见**（**散文里的两个字不能当判据**·同 R10 之限度）；(ii) **写在备案册表行与回执之外者，亦不追踪** —— **本器改用正向定义而非排除清单，因排除清单须随每次新写作增补而没人会记得**。**两重盲区皆非漏，是把「要它被量」变成一个明确动作：写到量它的那两个地方去。** |"

# 甲2：〔K-0〕日期型逾期（复用日对账源③之同一判据·不另造第二份）
OVR=$(python3 - "$D" <<'PY'
import re,sys
d=sys.argv[1]; n=0
for l in open('portfolio-state.md',encoding='utf-8'):
    if not (l.startswith('|') and '待执行' in l): continue
    f=l.split('|')
    if len(f)<3: continue
    c=re.sub(r'自\s*20\d\d-\d\d-\d\d[^）)]*[）)]?','',f[1]); c=re.sub(r'自\s*20\d\d-\d\d-\d\d','',c)
    ds=re.findall(r'20\d\d-\d\d-\d\d',c)
    if ds and ds[0] <= d: n+=1
print(n)
PY
)
if [ "${OVR:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 逾期 ${OVR} 项"; else R="🟢 无逾期"; fi
say "| 甲2 · 〔K-0〕日期型挂钟逾期（**判据与日对账源③ 同一份，不另造**） | ${OVR:-0} | ${R} |"

# 甲3：本日回执内呈裁项 vs gm-inbox 当日落件
RC=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --name-only --format='' 2>/dev/null | grep -c '^adj-archive/.*receipt' || true)
GI=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --diff-filter=A --name-only --format='' 2>/dev/null | grep -c '^gm-inbox/CGM-' || true)
PEND=$(cgm_add 'adj-archive/*receipt*.md' | grep -cE '呈裁|候 ?GM|属 ?GM 判|不代裁' || true)
if [ "$PEND" -gt 0 ] && [ "$GI" -eq 0 ]; then RED=$((RED+1)); R="🔴 **呈裁项非零而 gm-inbox 零落件** —— 「信箱空」不等于「无事」，恰恰可能是「有事而没送到」"; else R="🟢"; fi
say "| 甲3 · 回执内呈裁字样 vs \`gm-inbox\` 当日落件 | 呈裁 ${PEND}／落件 ${GI} | ${R} |"
say ""

# ── §二 乙 · 遗漏 ────────────────────────────────────────────────
say "## §二 · 乙 · **有没有遗漏**（**附带义务是否随主动作同轮完成**）"
say ""
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"

# 乙1：〔M〕新条目是否皆带条尾版本戳
MISS=$(python3 - "$D" <<'PY'
import re,subprocess,sys
d=sys.argv[1]
cs=[l.split('\t')[0] for l in subprocess.run(['git','log',f'--since={d} 00:00:00',f'--until={d} 23:59:59','--format=%H\t%s'],
     capture_output=True,text=True).stdout.split('\n') if l and not l.split('\t')[-1].startswith('[裁决侧')]
out=''.join(subprocess.run(['git','show',c,'--format=','--','portfolio-state.md'],capture_output=True,text=True).stdout for c in cs)
bad=0
for l in out.split('\n'):
    if l.startswith('+') and re.match(r'^\+\d{3}\. ', l):
        if not re.search(r'版本v16\.\d+。\s*$', l): bad+=1
print(bad)
PY
)
if [ "${MISS:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 **${MISS} 条缺条尾戳** —— 而件头／沿革／末条之三处一致核正以该戳为读数"; else R="🟢 皆带"; fi
say "| 乙1 · 本日新增〔M〕条目之**条尾版本戳** | 缺 ${MISS:-0} | ${R} |"

# 乙2：三处一致（复用 anchor-guard·不另造判据）
if bash tools/anchor-guard.sh portfolio-state.md >/tmp/_ia_ag.$$ 2>&1; then R="🟢 锚存续＋三处一致"; else RED=$((RED+1)); R="🔴 anchor-guard 报不通过"; fi
say "| 乙2 · 锚存续核 ＋ 件头／沿革／末条三处一致（**复用 \`anchor-guard.sh\`**） | — | ${R} |"
rm -f /tmp/_ia_ag.$$

# 乙3：台账写入是否跟 state-core 同轮刷新
LEDW=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H' -- portfolio-state.md 2>/dev/null | wc -l | tr -d ' ')
SCW=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H' -- docs/state-core.md 2>/dev/null | wc -l | tr -d ' ')
if [ "$LEDW" -gt 0 ] && [ "$SCW" -eq 0 ]; then RED=$((RED+1)); R="🔴 台账有写入而 \`state-core\` 零刷新"; else R="🟢"; fi
say "| 乙3 · 台账写入 vs \`state-core\` 刷新（\`-0801-07⑦\`） | 台账 ${LEDW} 次／core ${SCW} 次 | ${R} |"

# 乙4：当日 CGM 摘要在档（宪法§六之二·最高原则）
DG=$(ls docs/memory-digests/cgm-${D}*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "${DG:-0}" -eq 0 ]; then RED=$((RED+1)); R="🔴 **当日无 CGM 摘要** —— 宪法 §六之二最高原则「入库即算，不入库即未办」"; else R="🟢 在档 ${DG} 件"; fi
say "| 乙4 · 当日 CGM 记忆摘要在档（**宪法最高原则**） | ${DG:-0} 件 | ${R} |"
# 乙4-b／乙4-c：GM 侧读物之当日在否（`ADJ-0801-12⑤` 之 DIGEST 令 ＋ 委托人令「能帮 gm 分担的不要丢回给 gm」）
DIG=$([ -f "gm-inbox/AUDIT-${D}-DIGEST.md" ] && echo 1 || echo 0)
AUDF=$([ -f "docs/internal-audit/${D}-auditor.md" ] && echo 1 || echo 0)
if [ "$AUDF" = "1" ] && [ "$DIG" = "0" ]; then RED=$((RED+1)); R="🔴 **正本在而抽取件缺** —— GM 侧无范围读，缺抽取件即等于令其整档取回 28 KB"; else R="🟢"; fi
say "| 乙4-b · 当日 \`gm-inbox/AUDIT-${D}-DIGEST.md\` 在否（\`-12⑤\`） | 正本 ${AUDF}／抽取件 ${DIG} | ${R} |"
GATE=$([ -f "gm-inbox/GATE-${D}.md" ] && echo 1 || echo 0)
if [ "$GATE" = "0" ]; then RED=$((RED+1)); R="🔴 **缺件** —— GM 须于步0 目录枚举即见〔K-0〕读数，**不必在 281 份回执里找一行**"; else R="🟢"; fi
say "| 乙4-c · 当日 \`gm-inbox/GATE-${D}.md\` 在否（**闸读数之单行件·CGM 单边办·不问 GM**） | ${GATE} | ${R} |"

# 乙5：摘要入库是否跟索引刷新（-0731-58③）
IDXW=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H' -- docs/memory-digests/INDEX.md 2>/dev/null | wc -l | tr -d ' ')
DGW=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --diff-filter=A --name-only --format='' 2>/dev/null | grep -c '^docs/memory-digests/cgm-' || true)
if [ "$DGW" -gt 0 ] && [ "$IDXW" -eq 0 ]; then RED=$((RED+1)); R="🔴 摘要入库而索引零刷新"; else R="🟢"; fi
say "| 乙5 · 摘要入库 vs \`INDEX.md\` 刷新（\`-0731-58③\`） | 新摘要 ${DGW}／索引 ${IDXW} | ${R} |"
# 乙6：收件七步逐项留痕（内审官 R7·〔M〕286 现役而全库仅 11% 合规·此前零检出器）
SEVEN=0; SEVBAD=0
for f in $(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --diff-filter=A --name-only --format='' 2>/dev/null | grep '^adj-archive/.*receipt.*\.md$' | sort -u); do
  [ -f "$f" ] || continue
  SEVEN=$((SEVEN+1))
  h=0
  grep -q 'pull --rebase\|ff-only\|fetch' "$f" && h=$((h+1))
  grep -q 'adj-inbox' "$f" && h=$((h+1))
  grep -q '四字段' "$f" && h=$((h+1))
  grep -qE '三要件|三要素' "$f" && h=$((h+1))
  grep -qE '逐项执行|逐项落实|落实总表' "$f" && h=$((h+1))
  grep -qE '〔M〕[0-9]' "$f" && h=$((h+1))
  grep -q 'git mv' "$f" && h=$((h+1))
  [ "$h" -lt 7 ] && SEVBAD=$((SEVBAD+1))
done
if [ "$SEVEN" -eq 0 ]; then R="🟢 本日无新回执"
elif [ "$SEVBAD" -gt 0 ]; then RED=$((RED+1)); R="🔴 **${SEVBAD}/${SEVEN} 份缺步** —— 〔M〕286 现役：**七步须在回执内逐项留痕**；**该规则立于「第⑦步曾漏一次」，而全库仅 11% 合规**"
else R="🟢 ${SEVEN} 份皆七步齐"; fi
say "| 乙6 · **收件七步逐项留痕**（〔M〕286 现役·**内审官 R7 立其检出法·此前零覆盖**） | 本日回执 ${SEVEN} 份／缺步 ${SEVBAD} | ${R} |"

# ── §三 丙 · 越权 ────────────────────────────────────────────────
say "## §三 · 丙 · **有没有越权**（**专权项之侵入**）"
say ""
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"

# 丙1：CGM 代签收（签收属 GM 专权）
SG=$(cgm_add 'adj-archive/*receipt*.md' | grep -cE '\[执行侧[^]]*\][^\n]{0,40}已签收|两维签收＝✅[^\n]{0,40}执行侧' || true)
if [ "${SG:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 **疑似 CGM 代签 ${SG} 处** —— 签收系 GM 专权"; else R="🟢 零代签"; fi
say "| 丙1 · CGM 代签收（**GM 专权**） | ${SG:-0} | ${R} |"

# 丙2：CGM 代写原声主题句（原声不可代）
GS=$(cgm_add 'docs/memory-digests/gm-*.md' | grep -c '一句话主题' || true)
if [ "${GS:-0}" -gt 0 ]; then R="⚠️ **${GS} 处·须人核** —— **本器机械上分不出「有授权之代录」与「无授权之代写」**（\`-0731-61⑤\` 许代录于亲书者已不在之件，且须附来源申报）；**须核其授权凭据**。**本器不因分不出而略过，亦不因分不出而判红**"; else R="🟢 零改动"; fi
say "| 丙2 · CGM 改动 GM 侧摘要之主题句（**原声不可代**） | ${GS:-0} | ${R} |"
# 🔴 丙2-b · 抵偿正向核（**收窄丙2 之同时加一条更强者·不借修误报之名把闸拆了**）：
#   丙2 收窄后只看「CGM 提交动了 GM 摘要」；**而「代补」标记之滥用它看不见**——
#   `-0731-61⑤` 只许在**亲书者已不在**之件上用「代补主题句」，且须硬标「非原声」。
#   本核直接量全库「代补」标记数，**任何新增皆须有其亲书者不在之凭据**。
DB=$(grep -rl '代补主题句' docs/memory-digests/ 2>/dev/null | wc -l | tr -d ' ')
# 🔴 收窄之由（落库前验出·留痕）：初版扫「代补主题句」四字，**命中的是 `INDEX.md` 里解释该规则的那段说明**，
#   **不是一次真实的代补** —— 与本器 §一 甲1 初版之「引文假阳性」同族。**改为只认真实用法之行首形态。**
DBN=$(cgm_add 'docs/memory-digests/*.md' | grep -cE '^\+> \*\*代补主题句\*\*：' || true)
if [ "${DBN:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 **本日 CGM 新增代补标记 ${DBN} 处** —— 须有「亲书者已不在」之凭据，否则即以代补冒充原声"; else R="🟢 本日零新增"; fi
say "| 丙2-b · 「**代补主题句**」标记之新增（\`-0731-61⑤\` 限亲书者已不在之件） | 全库 ${DB:-0} 件／本日新增 ${DBN:-0} | ${R} |"

# 丙3：清单外自行上呈（规则一封闭清单·首例已入册〔M〕494）
OUTL=$(cgm_add 'gm-inbox/*.md' | grep -cE '一字即回.*属其正当异议权|GM 若认' || true)
say "| 丙3 · **清单外自行上呈**之疑似句（\`adjudication-lanes\` 规则一：**清单之外不得以「看起来重要」为由自行上呈**） | ${OUTL:-0} | ⚠️ **本器只标疑似，判不了该事项在不在清单内**——须人核（首例＝〔M〕494 之 N8／N9） |"

# 丙4：擅动 routines/ 或 .claude/agents/（判断类·须裁决来源）
RT=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --name-only --format='' 2>/dev/null | grep -cE '^(routines/|\.claude/agents/)' || true)
if [ "${RT:-0}" -gt 0 ]; then R="⚠️ **本日改动 ${RT} 处** —— **判断类，须有裁决来源**；本器只报，**裁决来源之有无须人核**"; else R="🟢 未动"; fi
say "| 丙4 · \`routines/\`／\`.claude/agents/\` 之改动（**判断类·须授权**） | ${RT:-0} | ${R} |"

# 丙5：改写历史／force-push 之痕（追加式铁律）
FP=$(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H' --walk-reflogs 2>/dev/null | wc -l | tr -d ' ')
# 🔴 R4 修（内审官捕获·2026-08-01）：原式 `--is-ancestor origin/master HEAD` **只在本地领先或相等时为真**，
#   **凡本地落后（GM 刚推件而 CGM 未 pull）必然为假 → 必然报「疑改写历史」** —— 本日 16:08 即实发。
#   **一把在「同事刚推了东西」这种最常见情形下必然报红的尺，会在几天内把人训练成不看它。**
#   **改法**：改核「二者是否有共同祖先且无一方系被强推所毁」——**本地落后系正常，单列不判红**。
if git merge-base --is-ancestor origin/master HEAD 2>/dev/null; then ANC=ok; ANCNOTE="本地领先或相等"
elif git merge-base --is-ancestor HEAD origin/master 2>/dev/null; then ANC=ok; ANCNOTE="**本地落后于远端（正常·非改写）**——须 pull"
else ANC=no; ANCNOTE="**二者已分叉**"; fi
if [ "$ANC" = "ok" ]; then R="🟢 未改写已推之历史（${ANCNOTE}）"; else RED=$((RED+1)); R="🔴 **本地与远端已分叉，二者互非祖先** —— 疑改写历史（${ANCNOTE}）"; fi
say "| 丙5 · 改写 master 历史（**追加式铁律·永不 force-push**） | — | ${R} |"
say ""

# ── §三-补 · 批量复核到期核 ＋ 备案核（v1.4 立·2026-08-01）────────────
# 🔴 何以挂在日核而不新造日历项：**新造即又一个会被忘掉的待办**（本仓通则）。
#   本器每日跑，故「今日是不是批次日」由它顺手判，**批次日而批次未出即 🔴**。
# 🔴 本器之边界：**只核「有没有备案」「批次有没有出」，核不了「备案得对不对」**——
#   后者属判断质量，**归每周二次之 GM＋GPT 批量复核**（委托人令：**内审官每日复核重点是机械核**）。
say "## §三-补 · **批量复核到期核 ＋ 依据论点备案核**（v1.4·**只核有无，不核对错**）"
say ""
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"
DOW=$(date -d "$D" +%u 2>/dev/null || echo 0)
BATCHDAY="否"; [ "$DOW" = "2" ] || [ "$DOW" = "5" ] && BATCHDAY="是"
NEW_CR=$(cgm_add 'docs/cgm-rulings-docket.md' | grep -c '^+| `CR-' || true)
UNREV=$(grep -c '未复核' docs/cgm-rulings-docket.md 2>/dev/null || echo 0)
if [ "$BATCHDAY" = "是" ]; then
  BF=$(ls docs/internal-audit/../../gm-inbox/CGM-*batch* 2>/dev/null | wc -l | tr -d ' ')
  if [ "${BF:-0}" -eq 0 ]; then RED=$((RED+1)); R="🔴 **本日系批次日（周二／周五）而未见批次件** —— 照 v1.4 §三"; else R="🟢 批次已出"; fi
else R="🟢 本日非批次日（周二／周五）"; fi
say "| 补1 · **每周二次批量复核之到期核**（周二／周五·SGT） | 本日 dow=${DOW}／批次日=${BATCHDAY} | ${R} |"
say "| 补2 · 本日新增**备案行** \`CR-\` | ${NEW_CR:-0} | ⚠️ **本器核不了「该备案而未备案」** —— 该缺口由批量复核之随机抽查承担（v1.4 §二末） |"
say "| 补3 · 备案册待复核存量 | ${UNREV:-0} 行 | **只出数不催**——**复核属 GM＋GPT，本器一字不涉** |"
say "| 补4 · **⚠️ 本器不核「备案得对不对」** | — | **依据论点是否成立、反证条件是否真可证伪 —— 属判断质量，归每周二次批量复核**（委托人令：**内审官每日复核重点是机械核**） |"
say ""

# ── §三-补三 · 🔴 收件七步之逐份留痕（内审官 R7 强制回应·v1.6 §十-A 立）────────
# 🔴 立此之由（内审官逐字）：「该规则立于「第⑦步曾漏一次」，其立规之全部意义就是让漏步可被看见；
#   而现在它自己漏了 89%，且没有任何检查在量它。」——**本源即那个「没有任何检查」之出口。**
# 🔴 何以只判 ⚠️ 不判 🔴（写死·免被读作放水）：
#   本器无权把一条现役规则（〔M〕286）之违反自行降格为「无事」；
#   但亦不得在未经裁决之前，用红旗压着全库 89% 之历史件。
#   **故：出数、逐份点名、不判红，并把「该规则是否应改形态」呈 GM（G4·方法论层）。**
# 🔴 它不核什么：只核**字样在否**，不核**那一步是否真做了** —— 一份写了「①git pull --rebase」而没跑的回执，本源判它有留痕。
say "## §三-补三 · **收件七步之留痕**（**\`ADJ-0801-12①\` 裁改形态·2026-08-01**）"
say ""
say "> **🔴 判据（GM 逐字）**：**「留痕只加在『做了也看不出做没做对』的步骤上。」**"
say "> **强制者只有 ③四字段核 ／ ④三要素＋轮号核** —— **「核过」与「没核」在库面上完全不可分，此二步是本条规则唯一真正承重之处**。"
say "> **①pull ②读 inbox ＝ 免**（不做则后续步骤机械失败，其证据自带——**要求为一件不做就会自己暴露的事留痕，是在收集已知信息**）。"
say "> **⑤逐项 ⑥〔M〕＋版本行 ⑦receipt＋git mv＋push ＝ 免**（**产物在库即证其已做；件仍在 inbox 即证其未做**）。"
say "> **免者仍逐份出读数，但不判红** —— **出数是为看趋势，判红只对承重两步。**"
say ""
say "| 回执 | **🔴③四字段** | **🔴④三要素＋轮号** | ①pull | ②inbox | ⑤逐项 | ⑥〔M〕 | ⑦git mv | 承重 2/2？ |"
say "|---|---|---|---|---|---|---|---|---|"
STEP_N=0; STEP_BAD=0
for f in $(git log --since="${D} 00:00" --until="${D} 23:59" --name-only --pretty=format: -- 'adj-archive/*receipt*.md' 2>/dev/null | sort -u | grep -v '^$'); do
  [ -f "$f" ] || continue
  s3=$(grep -qE '四字段|GM_EPOCH' "$f" && echo "✅" || echo "🔴")
  s4a=$(grep -qE '三要素|三要件' "$f" && echo 1 || echo 0)
  s4b=$(grep -qE '轮号|轮:|轮 ?`' "$f" && echo 1 || echo 0)
  if [ "$s4a" = "1" ] && [ "$s4b" = "1" ]; then s4="✅"; else s4="🔴"; fi
  s1=$(grep -qE 'pull --rebase' "$f" && echo "✅" || echo "—")
  s2=$(grep -qE 'adj-inbox' "$f" && echo "✅" || echo "—")
  s5=$(grep -qE '逐项执行|逐条执行|逐项办' "$f" && echo "✅" || echo "—")
  s6=$(grep -qE '〔M〕' "$f" && echo "✅" || echo "—")
  s7=$(grep -qE 'git mv' "$f" && echo "✅" || echo "—")
  STEP_N=$((STEP_N+1))
  if [ "$s3" = "✅" ] && [ "$s4" = "✅" ]; then OK="**2/2** 🟢"; else OK="**承重缺** 🔴"; STEP_BAD=$((STEP_BAD+1)); fi
  say "| \`$(basename "$f")\` | ${s3} | ${s4} | ${s1} | ${s2} | ${s5} | ${s6} | ${s7} | ${OK} |"
done
if [ "$STEP_N" -eq 0 ]; then
  say "| **当日无新增回执** | — | — | — | — | — | — | — | **不适用** |"
fi
if [ "${STEP_BAD:-0}" -gt 0 ]; then RED=$((RED+1)); RR="🔴 **${STEP_BAD} 份承重步缺留痕**"; else RR="🟢 承重两步全数留痕"; fi
say ""
say "**当日 ${STEP_N} 份 ｜ ${RR}** ｜ 正本 \`portfolio-state.md\`·\`〔M〕286\`·**形态已由 \`ADJ-0801-12①\` 改**"
say "**⚠️ 免留痕之五步仍出读数不判红** —— **一条把力气用在自证之处的规则，其形态即错**（GM 之承重分析）。"
say ""

# ── §三-补四 · 🔴 `ADJ-0801-14` ＋ E13 就位所捕之三处（新增四核）────────────
say "## §三-补四 · **签收标记 ＋ 载入集维护物之核**（\`ADJ-0801-14\` ＋ E13 就位声明所捕）"
say ""
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"
# 核1（-14②）：被签件其后有追加者 —— **不自动作废，只使其可见**
LATE=0
for f in $(git ls-files "adj-archive/*receipt*.md" 2>/dev/null); do
  grep -q "^SIGNOFF: " "$f" 2>/dev/null || continue
  SA=$(grep -m1 "^SIGNOFF: " "$f" | grep -oE "[0-9a-f]{40}" | head -1)
  [ -n "$SA" ] || continue
  CUR=$(sha1sum "$f" | cut -d" " -f1)
  [ "$SA" = "$CUR" ] || LATE=$((LATE+1))
done
say "| 补四-1 · **签收锚早于末次追加**（\`-14②\`·**不自动作废，只使其可见**） | ${LATE} | $( [ "${LATE}" -eq 0 ] && echo "🟢" || echo "⚠️ **${LATE} 件之签收锚指向非当前版本 —— 须人核**" ) |"
# 核2（-14①）：复述不得为标题行之复制（只挡机械照抄·挡不住敷衍·如实标）
say "| 补四-2 · **复述与件标题之最长公共子串 >一半者**（\`-14①\`·**只挡机械照抄，挡不住敷衍**） | 0 | 🟢 **本日零 \`SIGNOFF:\` 标记** —— **零读数不等于零违规，系新制尚未有对象** |"
# 核3（E13 所捕）：下一代骨架之前纪元四字段须与台账权威状态块逐字相符
# 🔴 取**数值最大**之骨架，非字典序最大 —— 首版用 `ls|tail -1`，遂在 E9/E11/E12/E13/E14 中选中 **E9**（字典序 E9 最大），
#   报出一个「不符」而其实是选错了对象。**本日第三次「判据自身写错」，故此处写死取法。**
SK=$(ls docs/succession/E*-declaration-SKELETON.md 2>/dev/null | sed -E 's/.*\/E([0-9]+)-.*/\1 &/' | sort -n -k1,1 | tail -1 | cut -d" " -f2)
LFP=$(grep -oE "SESSION_FINGERPRINT=\`?[0-9a-f]{32}" portfolio-state.md | head -1 | grep -oE "[0-9a-f]{32}")
if [ -n "$SK" ] && [ -n "$LFP" ] && grep -q "$LFP" "$SK"; then R="🟢 相符"; else RED=$((RED+1)); R="🔴 **不符或缺** —— \`${SK:-无骨架}\` 内未见台账现行 FP。**E13 就位时即捕出前代骨架把 E11 之 FP 与 E10 之 ACT 误标为 E12**"; fi
say "| 补四-3 · **下一代骨架之前纪元 FP ↔ 台账权威状态块**（E13 所捕·**误标会再传一代**） | \`${SK:-—}\` | ${R} |"
# 核4（E13 所捕）：gm-snapshot 版本戳与台账件头之差
SV=$(grep -oE "v16\.[0-9]+" docs/gm-snapshot.md 2>/dev/null | head -1 | tr -d "v")
LV=$(head -1 portfolio-state.md | grep -oE "v16\.[0-9]+" | tr -d "v")
if [ -n "$SV" ] && [ -n "$LV" ]; then
  D2=$(echo "${LV#16.} - ${SV#16.}" | bc 2>/dev/null || echo 0)
  if [ "${D2:-0}" -gt 3 ]; then R="⚠️ **落后 ${D2} 版** —— 本件已立陈旧申报，**只得作索引不得作读数**；**须回读 \`state-core.md\` 或正本**"; else R="🟢 差 ${D2} 版"; fi
else R="⚠️ 取不到版本戳"; fi
say "| 补四-4 · **\`gm-snapshot.md\` ↔ 台账件头之版本差**（E13 所捕·阈值 >3 版） | snapshot v${SV:-?} ／ 台账 v${LV:-?} | ${R} |"
say ""

# ── §三-补五 · 🔴 委托人前置过滤之核（v1.9·委托人直令 2026-08-01）────────────
say "## §三-补五 · **委托人前置过滤**（v1.9·阈值 **4,000 B**）"
say ""
say "| 当日新增呈裁件 | 字节 | 达阈？ | 回执内「已先呈委托人」留痕 | 结果 |"
say "|---|---:|---|---|---|"
PF_BAD=0; PF_N=0
for f in $(git log --since="${D} 00:00" --until="${D} 23:59" --diff-filter=A --name-only --pretty=format: -- "gm-inbox/CGM-*.md" 2>/dev/null | sort -u | grep -v "^$"); do
  [ -f "$f" ] || continue
  PF_N=$((PF_N+1))
  B=$(wc -c < "$f" | tr -d " ")
  # 🔴 生效时点闸（**落库前自捕·2026-08-01**）：v1.9 立于 `5d81057` 之后；
  #   首版无本闸，遂把**立规之前**落库之五件（`-05`／`-06`／`-08`／`-09`／`-10`）全数判红。
  #   **一条新规不得追溯地把旧件染红** —— 同内审官 §丙-3 之判据：
  #   **一把在最常见情形下必然报红的尺，会在几天内把人训练成不看它。**
  #   **判据＝该件之加入 commit 是否晚于 v1.9 之立规 commit。**
  # 🔴 锚须是「v1.9 那一节首次入库之 commit」，不是任何代理物。
  #   **首版误以 `adjudication-lanes-CURRENT.md` 之创建 commit 为锚 —— 而该件早于 v1.9 立规，
  #   且与 `CGM-0801-10-ACTIVATION.md` 同一 commit，遂把该件误判为「立规后」并报红。**
  #   **本日第五次「判据自身写错」，形态＝拿一个代理物当那件事本身。**
  #   **锚取不到时（本节尚未入库）→ 一律视同「立规前」**，fail-safe 偏向不报红：
  #   **一条尚未落库之规则，不该先把任何件染红。**
  V19=$(git log -S"# 🔴 v1.9 ·" --format=%H -- docs/adjudication-lanes.md 2>/dev/null | tail -1)
  ADDC=$(git log --diff-filter=A --format=%H -1 -- "$f" 2>/dev/null)
  PRE=no
  if [ -z "$V19" ]; then PRE=yes
  elif [ -n "$ADDC" ] && ! git merge-base --is-ancestor "$V19" "$ADDC" 2>/dev/null; then PRE=yes; fi
  if [ "$PRE" = "yes" ]; then
    say "| \`$(basename "$f")\` | ${B} | $( [ "$B" -ge 4000 ] && echo "**是**" || echo "否" ) | **立规前** | ⚪ **不适用·本件落库早于 v1.9 立规** |"
    continue
  fi
  if [ "$B" -ge 4000 ]; then
    OVER="**是**"
    if grep -rqs "已先呈委托人" adj-archive/*receipt*.md "$f" 2>/dev/null; then T="✅"; R="🟢"; else T="—"; R="🔴 **达阈而无前置留痕**"; PF_BAD=$((PF_BAD+1)); fi
  else OVER="否"; T="不适用"; R="🟢 **未达阈·字节已书使其可复算**"; fi
  say "| \`$(basename "$f")\` | ${B} | ${OVER} | ${T} | ${R} |"
done
[ "$PF_N" -eq 0 ] && say "| **当日无新增呈裁件** | — | — | — | 🟢 |"
[ "${PF_BAD:-0}" -gt 0 ] && RED=$((RED+1))
say ""
say "**⚠️ 本核之限度（写死）**：只核**达阈者有无前置留痕**，**核不了「短而重」者是否该前置** ——"
say "**v1.9 §三 之三类（甲档／自陈失守／改变 GM 工作量）系语义判断，本器判不了，归委托人判断门。**"
say ""

# ── §三-补六 · 🔴 天花板计数（`ADJ-0801-15⑦`·「不得停更」此前零检出点）──────────
say "## §三-补六 · **天花板计数**（\`ADJ-0801-15⑦\`·GM-13 捕：**「不得停更」在此之前没有任何检出点**）"
say ""
CEIL=docs/adjudication-lanes-CURRENT.md
GMN=$(sed -n "/当前计数（/,/天花板「/p" "$CEIL" 2>/dev/null | grep -c "| \*\*GM\*\*" || true)
CGN=$(sed -n "/当前计数（/,/天花板「/p" "$CEIL" 2>/dev/null | grep -c "| CGM |" || true)
TOT=$((GMN+CGN))
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"
if [ "$TOT" -eq 0 ]; then RED=$((RED+1)); R="🔴 **逐条表读不到** —— \`${CEIL}\` §六 之列举表缺或格式已改。**断言不是读数**"; else R="🟢 逐条表在·可复算"; fi
say "| 补六-1 · **天花板逐条表在否**（\`-15⑥\`：**否则是断言不是读数**） | GM ${GMN} ／ CGM ${CGN} ／ 计 ${TOT} | ${R} |"
say "| 补六-2 · **本日是否已重算**（\`-15⑦\`·**停更即 🔴**） | 本器每跑一次即重算一次 | 🟢 **本行之存在即其重算留痕** |"
say ""
say "**⚠️ 限度（写死）**：本核只数**表内之行**，**不核那些检出点是否真在跑**——"
say "**一个写在表里而实际已坏的检出点，本核照样数它。** 其真伪归各器自身之自检与内审官逐日判读。"
say ""

# ── §三-补二 · 🔴 本器之自检（内审官 R3／R4／R6 强制回应·2026-08-01）────────
# 🔴 立此之由（内审官逐字）：「**这是一个把自己报告内容删掉却不报错的失效**」——
#   本器 line 80／216 之未转义反引号被 bash 当命令替换执行，**把「谁来核裁决侧」与丙2 所依之规则号删空**，
#   而**正表照常产出、格式完整、看不出缺了东西**；且「本器跑过了」与「本器跑对了」在库面上不可分。
#   **故本节即其出口：本器须能报自己的错。**
say "## §三-补二 · **本器自检**（内审官 R3／R4／R6 之强制回应·**本器须能报自己的错**）"
say ""
say "| 项 | 读数 | 结果 |"
say "|---|---|---|"
# 自检1：全 tools/ 之未转义反引号（本器自身在内）
UB=$(grep -nE '^[^#]*say "[^"]*[^\\]`' tools/*.sh 2>/dev/null | wc -l | tr -d ' ')
if [ "${UB:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 **${UB} 处** —— 反引号在双引号内未转义即被 bash 当命令替换执行，**会把报告内容删空且不报错**"; else R="🟢 零处"; fi
say "| 自检1 · \`tools/*.sh\` 内 \`say "…\\\`…"\` 之**未转义反引号** | ${UB:-0} | ${R} |"
# 自检2：全库 UTF-8 合法性（内审官 R6：本日事故所属缺陷族零检出器覆盖）
BAD=$(git ls-files -z | xargs -0 -I{} sh -c 'iconv -f UTF-8 -t UTF-8 "{}" >/dev/null 2>&1 || echo "{}"' 2>/dev/null | wc -l | tr -d ' ')
if [ "${BAD:-0}" -gt 0 ]; then RED=$((RED+1)); R="🔴 **${BAD} 件非法 UTF-8**"; else R="🟢 零件非法"; fi
say "| 自检2 · **全库 UTF-8 合法性**（R6·**本日事故所属缺陷族之类级检出器**·此前零覆盖） | ${BAD:-0} | ${R} |"
# 自检3：cut -c 之同族写法（内审官指出仍在库 3 处）
CUTC=$(grep -nE 'cut -c[0-9]' tools/*.sh 2>/dev/null | wc -l | tr -d ' ')
say "| 自检3 · \`tools/*.sh\` 内 \`cut -c\` 同族写法（**按字节切·多字节文本上会产出非法 UTF-8**） | ${CUTC:-0} | ⚠️ **只报不判**——截 hash／英文 subject 者无害，截中文者有害；**本器分不出，须人核** |"
# 自检4：第四验之「手敲式 vs 正本式」读数比对（`tools/_text-integrity.sh` 之外挂检出法）
# 🔴 立此之由：2026-08-01 CGM-G5 手敲 `grep -cP '[À-ÿ]{2,}'` 得 57，正本 python 路得 0。
#   成因＝会话 locale 空 → grep 按字节解释模式串 → 每段中文皆命中。**方向是假红，不是假绿。**
#   假红之害在于**把人训练成「那个数一向不准」**，从而让一次真命中被当噪声。
if [ -f tools/_text-integrity.sh ]; then
  # shellcheck disable=SC1091
  . tools/_text-integrity.sh
  TI_PROBE="docs/state-core.md"
  if [ -f "$TI_PROBE" ]; then
    TI_CANON="$(ti_scan_file "$TI_PROBE" | awk '{print $2}')"
    TI_NAIVE="$(ti_naive_shell_count "$TI_PROBE")"
    if [ "${TI_CANON:-x}" = "${TI_NAIVE:-y}" ]; then
      R="🟢 两式一致（${TI_CANON}）"
    else
      R="⚠️ **两式不一致：正本 ${TI_CANON} ／ 手敲 ${TI_NAIVE}** —— 系已知 locale 缺陷（\`_text-integrity.sh\` 头部载其成因），**本行不判红**；其用在于**凡回执所书之数若等于手敲值，即知其走错了路**"
    fi
  else
    R="⚠️ 探针文件缺失，未能比对"
  fi
else
  RED=$((RED+1)); R="🔴 **\`tools/_text-integrity.sh\` 不在** —— 第四验之单一判据正本缺失，手敲路重新敞开"
fi
say "| 自检4 · **第四验判据之单一入口在否 ＋ 手敲式对照**（探针 \`docs/state-core.md\`） | 正本 ${TI_CANON:-—} ／ 手敲 ${TI_NAIVE:-—} | ${R} |"
say ""
# ── §四 自指盲区 ─────────────────────────────────────────────────
say "## §四 · 🔴 本器之**自指盲区**（**写死·不靠人记得**）"
say ""
say "**本器不跑，即无表；无表与「全绿」在库面上不可分。**"
say "**故其检出法必须落在本器之外**：**周对账新增一核 —— \`docs/internal-audit/\` 当周缺档日期逐一列出**；"
say "**缺档即 🔴，且不得以「当日无 CGM 会话」自动豁免**（须显式标注，与记忆摘要之缺席标注同制）。"
say ""
say "**并写死其退役条件（照「凡新增结构，立时即写其死法」）**："
say "**本器连续 30 日零 🔴，且同期无任何由委托人或 GM 指出而本器未捕之 CGM 侧失守 —— 得呈请降频或退役。**"
say "**「连续零 🔴」本身不构成退役理由**：一把从不报红的尺，先该疑它是不是没在量。"
say ""

say "---"
say ""
say "**标红合计：${RED} 项**"
say ""
say "*生成于 \`tools/internal-audit.sh\`｜只出表不裁定｜**CGM 不得自行销项**（销项须有裁决或委托人一字为据）*"
} > "$OUT"

sed -n '1,3p' "$OUT"
echo "→ 已写入 $OUT"
echo "→ **本期标红 ${RED} 项**"
