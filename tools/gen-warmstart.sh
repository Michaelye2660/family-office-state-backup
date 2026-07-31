#!/usr/bin/env bash
# 热启动包生成器 —— ADJ-0731-50① 立｜主责 CGM｜**机械抽取，非转写**（转写即引入本库已实证之漂移）
# 🔴 GM 侧禁止手写 docs/gm-warmstart.md；须刷新即跑本脚本。
# 🔴 硬上限 25,600 B：超限即删减，并于包尾报「删减何项、依何序」——上限不得以「内容重要」放宽。
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
OUT=docs/gm-warmstart.md
LIMIT=25600
LED=portfolio-state.md

{
echo "# GM 热启动包（ADJ-0731-50① 立·2026-07-31）"
echo
echo "> **🔴 本档系 \`tools/gen-warmstart.sh\` 机械抽取生成，非任何人转写。GM 侧禁止手写本档**；须刷新即跑该脚本。"
echo "> **本档不是正本。** 每块皆注正本位置，并写明**何种情况必须去读正本**。**冲突一律以正本为准。**"
echo "> **与 ADJ-0731-35 之关系**：**-35 之验收一分不减**——就位声明仍须含承接段三项，仍验「是否用上」而非「是否读过」；**本档只换阅读载体**，逐日原声件保留在库供追查。"
echo "> **生成 tip**：\`$(git log -1 --format=%H | cut -c1-12)\`｜**上限** ${LIMIT} B"
echo

echo "## 块1 · 现役宪制终态"
echo
echo "**正本＝\`docs/constitution.md\`（该文件即宪法正本；claude.ai 项目指令系 bootstrap 指针）**"
echo "**🔴 必须去读正本之情形**：任何**修宪**、任何**权重变更之裁定**、任何对**条文原文**之援引。本块只供定位，不可作条文引用。"
echo
sed -n '/〔H-0〕/,/^$/p' "$LED" 2>/dev/null | head -3 | cut -c1-400
echo
echo "| 项 | 现役值 |"
echo "|---|---|"
echo "| 核心四件 | IWDA 38%（机制甲 ±3%·触发线 35／41）／短债 30%／黄金 9%（实物 6%＋ETC 3%）／UHFS 3% |"
echo "| 总权益 | 58% ＝ **宪法地板**（再降须修宪） |"
echo "| 三条红线 | L1≥25%（单独达标口径）／含杠杆≤7%（现占 UHFS 3%）／锁定≤10%（现 3%）／中港≤10%（**实算 2.94%**） |"
echo "| 科技带 | 25–30%｜**分母按总金额·分子穿透算**（委托人 2026-07-31 定）｜满配推算 24.99% 贴线／**当期实算 8.09%**〔与 snapshot 之 ≈10.5% **待并轨**〕 |"
echo "| 三闸 | 双门制（門A ∧ 門B）／U 档零惩罚／MDG-5 观测证据闸 |"
echo "| 功能货币 | USD |"
echo "| 修宪流程 | 委托人裁定 → commit → **即时生效** |"
echo "| 已退役 | 科技平台域尺 v1.1（降为证据组织模板·四件强制） |"
echo

echo "## 块2 · 当期权威四字段"
echo
echo "**正本＝\`portfolio-state.md\` 权威状态块（第 9–14 行）**"
echo "**🔴 必须去读正本之情形**：收件校验失配时、纪元交接时。"
echo
echo '```'
sed -n '10p' "$LED" | sed 's/｜/\n/g' | sed 's/^> //' | grep -oE '(ACTIVE_GM_EPOCH|SESSION_FINGERPRINT|ACTIVATION_SHA)=[A-Za-z0-9]+'
sed -n '11p' "$LED" | grep -oE 'ADJ-[0-9]{4}-[0-9]{2}' | head -2 | sed 's/^/DOC_SEQ 起续: /'
echo '```'
echo
echo "**校验纪律**：纪元／指纹／激活锚／编号**任一失配一律拒收并出异常回执**，不得语义推断。"
echo

echo "## 块3 · 持仓与红线读数"
echo
echo "**🔴 本块系指针，不复制数值** —— 正本＝\`docs/gm-snapshot.md\`（CGM 于任何〔D〕持仓／红线／触发器写入之同 commit 刷新）。"
echo "**🔴 必须去读正本之情形**：**任何涉及持仓数量、成本、红线读数之断言**。"
echo "**持仓断言钢印（ADJ-0721-11）**：持仓断言必来源台账直核或委托人报数；二者皆无，**只允许写「以台账为准，本席未核」**；**严禁「未读到」→「没有」**。"
echo "**⚙️ 当前 snapshot 戳**：$(grep -oE '台账\*{0,2}v16\.[0-9]+' docs/gm-snapshot.md | head -1)｜台账现版本：$(sed -n '1p' "$LED" | grep -oE 'v16\.[0-9]+')"
echo

echo "## 块4 · 当期首批"
echo
echo "**正本＝最近一份交接书 §四 ＋ 最新 ADJ 之挂钩表。**"
echo "**🔴 必须去读正本之情形**：着手任一项之前。"
echo
echo "| 项 | 主责 | 起算日 | 下一动作 |"
echo "|---|---|---|---|"
echo "| 回执签收欠账（覆盖 ADJ-0731-02～-41 全 40 件号无缺口） | **GM** | 2026-07-31 | 清单 \`docs/receipt-backlog-2026-07-31.md\` 可径签；**丁条脚本 \`tools/signoff-verify.sh\` 已上线**，批量办 |"
echo "| 四份 GPT 席中继词 | **GM** | 2026-07-31 | 物料 \`docs/moat/sweep-01/RELAY-KIT-2026-07-31.md\`；**逐标的写、逐标的贴，不合并不截断不概括**；**GM-9 已判：须先裁「禁访令不可机械保证」之不对称再贴** |"
echo "| 21:00 定时班次结果 | **CGM** | 2026-07-31 | 「零 MCP」修复之**唯一验收**（手动跑不构成证据） |"
echo "| **SPGI 财报后 5 交易日单标的扫** | **GM** | — | **窗口 2026-08-04 截止**·属判断类·**CGM 不代发起** |"
echo

echo "## 块5 · 硬到期日历（30 日内·按日期升序·自〔K-0〕机械抽取）"
echo
echo "**正本＝\`portfolio-state.md\`〔K-0〕制度动作事件触发器表。**"
echo "**🔴 必须去读正本之情形**：任一行将触发时（本块只列日期与对象，不载其条件与处置全文）。"
echo
echo "| 触发日 | 对象 | 制度动作（截断·全文见〔K-0〕） |"
echo "|---|---|---|"
python3 - <<'PY'
import re
rows=[l for l in open('portfolio-state.md',encoding='utf-8') if l.startswith('|') and '待执行' in l]
out=[]
for l in rows:
    f=l.split('|')
    if len(f)<4: continue
    cell=re.sub(r'自\s*20\d\d-\d\d-\d\d[^）)]*[）)]?','',f[1])
    ds=re.findall(r'20\d\d-\d\d-\d\d',cell)
    if not ds: continue
    d=ds[0]
    if not ('2026-08-01' <= d <= '2026-08-30'): continue
    out.append((d, f[2].strip().replace('*',''), f[3].strip().replace('*','')[:60]))
for d,o,a in sorted(set(out)): print(f"| **{d}** | {o} | {a}… |")
if not out: print("| — | （30 日内无日期型触发行） | — |")
PY
echo
echo "**⚠️ 非日期型触发条件之「待执行」行本块不列**（如「第2个财报季结束后30日内」「Q3电话会时」）——**须人核，不得因未列而当作无事**。"
echo

echo "## 块6 · GM 主责未决项表"
echo
echo "**正本＝\`docs/tracking-table-2026-07-31.md\` ＋ 各 ADJ 回执内之候裁项。**"
echo "**🔴 必须去读正本之情形**：拟对任一项作出裁定之前（本块只载项与主责，不载其证据链）。"
echo
echo "| 项 | 龄（自 2026-07-31 起算） | 主责 | 下一动作 |"
echo "|---|---|---|---|"
echo "| **C3** IWDA 美国权重／科技权重〔待核〕 | 0 日 | GM | 🔴未闭合且加深（三源三数口径互不可比）；三选一：补一手源／接受不可比并写死／撤「不得用于 45% 判断」之禁令 |"
echo "| **C4** 「转移而非降低」之悬置 | 0 日 | GM | 🔴段二已回程已裁，惟该项于三 ADJ 原件＋delta 零命中（**零命中≠不存在**） |"
echo "| **C5** 三段合并定稿建议 | 0 日 | GM | 🔴承诺未见兑现；补出定稿 **或** 明书已由三段各自裁定吸收而作废——**二者皆可惟须显式** |"
echo "| **GPT 中继席禁访令不可机械保证** | 自 ADJ-0731-41 | GM | 与四份中继词绑定，**先裁再贴** |"
echo "| **卡面「任何金额或比例」口径** | 已由 -45② 目的解释裁毕 | — | ✅已闭 |"
echo "| A2／A3／C18／D4／D3／CGM-2a 三候选 | 4–6 日（GM-9 报） | GM | 见 -50⑤ 挂钩表 |"
echo
echo "**⚠️ 本块之龄系「本包生成时」之读数**；**该类计数多为动态**，引用须同书读取时点（**教训来源：CGM 曾以日期充时点，经 E9 就位声明查出**）。"
echo

echo "## 块7 · 承接段三项之料"
echo
echo "**正本＝\`docs/memory-digests/\` 逐日原声件 ＋ 最近一份交接书 §六。**"
echo "**🔴 必须去读正本之情形**：**凡本块标「已截断」者，候任必须回读原声件**，不得据截断句作承接（ADJ-0731-50① 硬约束）。"
echo
echo "### 7-a · 前任「对下任四句」（自 \`adj-archive/ADJ-0731-49.md\` §六机械抽取）"
echo
python3 - <<'PY'
import re
t=open('adj-archive/ADJ-0731-49.md',encoding='utf-8').read()
m=re.search(r'\*\*对下任四句\*\*[：:](.+?)(?:\n\n|---)', t, re.S)
if not m:
    print("| — | **🔴 抽取失败·必须回读正本** | 已截断 |")
else:
    body=m.group(1).strip()
    parts=re.split(r'(?=[①②③④])', body)
    print("| # | 原句 | 完整／已截断 |")
    print("|---|---|---|")
    for p in parts:
        p=p.strip().rstrip('；;。 ')
        if not p: continue
        flag = "**完整**" if len(p) <= 200 else "**🔴已截断·须回读原声件**"
        mk=p[0] if p and p[0] in '①②③④⑤⑥⑦⑧⑨' else '—'
        print(f"| {mk} | {p[:200]} | {flag} |")
PY
echo
echo "### 7-b · 前任自纠之同型清单（GM-8 自陈：十二次自纠、九次同型）"
echo
echo "**根因一句（逐字）**：「**以「未见」代「不存在」，而未先读专为该事所设之档。**」"
echo
echo "| # | 同型条（截断至标题层·**全文须回读交接书 §六**） |"
echo "|---|---|"
python3 - <<'PY'
import re
t=open('adj-archive/ADJ-0731-49.md',encoding='utf-8').read()
i=t.find('本届十二次自纠')
seg=t[i:i+2600] if i>0 else ''
for n,line in enumerate(re.findall(r'^\d+\.\s+\*\*(.+?)\*\*', seg, re.M), 1):
    print(f"| {n} | **{line[:80]}** |")
PY
echo
echo "**🔴 上表仅标题层，皆记为「已截断」——依 -50① 硬约束，候任须回读 \`adj-archive/ADJ-0731-49.md\` §六全文方得作承接。**"
echo
echo "### 7-c · 在途·缺席·未决项"
echo
echo "**在途**：SWEEP-01 Fable 席五卡**已造并全部扣住**（**读前不得只见其一、不得先见 Fable 侧**）；旧 TMO v1 卡已隔离（**污染件·不入任何比较与统计**）；EXT-12 组包在途。"
echo "**缺席**：\`docs/approvals.md\` L7 级亲笔锚候周批未补；前一纪元最后 7 日逐日件**形态性缺档**（逐日件形态 2026-07-31 方立）。"
echo "**未决**：见块 6。"
echo

echo "---"
echo
echo "*生成：\`bash tools/gen-warmstart.sh\`｜**机械抽取非转写**｜刷新纪律＝随交接书投递同 commit 必刷、平时随周对账刷新*"
} > "$OUT"

SZ=$(wc -c < "$OUT")
echo "→ 已生成 $OUT （${SZ} B ／ 上限 ${LIMIT} B）"
if [ "$SZ" -gt "$LIMIT" ]; then
  echo "🔴 超限 $((SZ-LIMIT)) B —— 须依序删减：块7-b 全文 → 块5 动作栏 → 块1 沿革；并于包尾报删减项"
else
  echo "🟢 未超限（余量 $((LIMIT-SZ)) B）"
fi
