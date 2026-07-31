#!/usr/bin/env bash
# 载入集迁移瘦身制 · 双触发监测 —— ADJ-0731-59① ＋ ADJ-0731-60②③ 立｜主责 CGM（出表与告警·机械）
#
# 🔴 主责之分界（-60③·不得越）：
#   **CGM 出表与告警（机械）／GM 裁边界与执行令（判断·不可代裁）。**
#   本器**只出数与红灯，绝不决定迁什么**。
#
# 🔴 立此之由（-59① 原话·写死免得后人以为是形式）：
#   **乙条管得住「增件」，管不住「既有件自己变胖」。**
#   -58 把记忆摘要移出载入集、改以交接书为基础，**压力即全部压到交接书 §六**，
#   而 -58④ 又刚给它加严一条。**约束一处，压力去另一处 —— 不看总量，就会以为省下来了。**
#   此系 -54③「分母是内生的」之同一机制第二次出现。
#
# 🔴 何以取相对增幅而非绝对上限（-60② 原话·并注其限度）：
#   **绝对上限须知「多大算大」，本席无此依据（样本 n＝1）；而相对增幅只须知「涨了多少」，此数今日即可测。**
#   故先上相对触发；**绝对上限候三代实测后由其时之 GM 定，并须同书三代读数**。
#
# 🔴 委托人补本席之不足（-60④ 照录·不得删）：
#   GM 只立到「不设上限，只求其变胖时有人看得见」；**委托人当轮补足为「到量必动」**。
#   **两者之差即「监测」与「机制」之差 —— 一个只被看见而无人必须动手的指标，最终会变成一张没人看的表。**
#   故本器之红灯**不是提示，是触发**：`-60③`「**触发即 🔴，不得只记不办**」。
#
# 用法：
#   bash tools/loadset-watch.sh              # 出表并对基线判触发
#   bash tools/loadset-watch.sh --set-baseline   # 把当前读数写为新基线（**须有裁决来源：瘦身完成后方得刷**）

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
BASE=docs/loadset-baseline.md
COMMIT=$(git log -1 --format=%H)
TS=$(date -u "+%Y-%m-%d %H:%M UTC")
MODE="${1:-report}"

python3 - "$COMMIT" "$TS" "$MODE" "$BASE" <<'PY'
import json, os, re, sys
sys.path.insert(0, 'tools')
from _latest_handover import latest_handover, latest_skeleton

commit, ts, mode, basefile = sys.argv[1:5]
hb = latest_handover() or ('', '', '')
sk = latest_skeleton()

# ── 监测面＝-58② 载入六项 ＋ 其按需回读之索引件（-60①「范围：一切新任 GM 载入件＋其索引件」）──
ITEMS = [
    ('宪法正本',            'docs/constitution.md',                 '载入'),
    ('CLAUDE.md 取数链',    'CLAUDE.md',                            '载入'),
    ('继任章程',            'docs/succession/gm-succession.md',     '载入'),
    ('最新交接书',          hb[0],                                  '载入·**-59① 三件之一**'),
    ('交接书回执',          hb[2],                                  '载入·**-59① 三件之一**'),
    ('热启动包',            'docs/gm-warmstart.md',                 '载入·**-59① 三件之一**'),
    ('下一代空骨架',        sk,                                     '载入'),
    ('记忆摘要索引',        'docs/memory-digests/INDEX.md',         '索引'),
    ('知识库分节索引',      'docs/section-size-adjudicator-knowledge.md', '索引'),
    ('台账分节索引',        'docs/section-size-portfolio-state.md',  '索引'),
    ('宪法分节索引',        'docs/section-size-constitution.md',     '索引'),
]

cur = {}
for name, path, kind in ITEMS:
    cur[name] = os.path.getsize(path) if path and os.path.exists(path) else None

base = {}
base_note = ''
if os.path.exists(basefile):
    m = re.search(r'```json\n(.*?)\n```', open(basefile, encoding='utf-8').read(), re.S)
    if m:
        d = json.loads(m.group(1))
        base, base_note = d.get('bytes', {}), d.get('note', '')

if mode == '--set-baseline':
    payload = {'commit': commit, 'read_at': ts, 'bytes': {k: v for k, v in cur.items() if v is not None},
               'note': '〔基线之性质须由写入者于下方正文标明——暂记抑或正式〕'}
    with open(basefile, 'w', encoding='utf-8') as f:
        f.write("# 载入集瘦身基线（ADJ-0731-60② · CGM 落库并标读取 commit）\n\n"
                "> **🔴 刷新基线须有裁决来源** —— `-60②`「**本轮瘦身完成后之实测值即首个基线**」。\n"
                "> **无裁决而刷基线 ＝ 把增长洗掉**：基线一刷，增幅归零，红灯自然不亮。\n"
                "> **故本档之每次改动皆须于 `git log` 可追，并于〔M〕留痕。**\n\n"
                "```json\n" + json.dumps(payload, ensure_ascii=False, indent=2) + "\n```\n")
    print(f"🟢 基线已写入 {basefile}（commit `{commit[:12]}`·{ts}）")
    sys.exit(0)

print("# 载入集迁移瘦身制 · 双触发监测（ADJ-0731-59①／-60②③ · **只出数与红灯，不裁边界**）\n")
print(f"> **读取 commit**：`{commit}`｜**读取时点**：{ts}")
print(f"> **基线**：{'`'+basefile+'`' if base else '**🔴 尚未设立**'}"
      + (f"｜{base_note}" if base_note else "") + "\n")
print("| 件 | 类 | 基线 B | 现值 B | 增幅 | 判（**≥25% 即强制触发·-60②乙**） |")
print("|---|---|---:|---:|---:|---|")

trig, tot_b, tot_c = [], 0, 0
for name, path, kind in ITEMS:
    c = cur[name]
    if c is None:
        print(f"| {name} | {kind} | — | **不在库** | — | 🔴 **件缺**（`{path or '路径未定'}`） |")
        continue
    tot_c += c
    b = base.get(name)
    if b is None:
        print(f"| {name} | {kind} | — | {c:,} | — | ⚪ 无基线 |")
        continue
    tot_b += b
    g = (c - b) / b * 100 if b else 0
    hot = g >= 25
    if hot:
        trig.append(f"{name} +{g:.1f}%")
    print(f"| {name} | {kind} | {b:,} | {c:,} | **{g:+.1f}%** | {'🔴 **触发**' if hot else ('🟡 涨' if g > 0 else '🟢')} |")

if tot_b:
    gt = (tot_c - tot_b) / tot_b * 100
    if gt >= 25:
        trig.append(f"**载入集总量 +{gt:.1f}%**")
    print(f"| **合计** | — | **{tot_b:,}** | **{tot_c:,}** | **{gt:+.1f}%** | "
          f"{'🔴 **触发**' if gt >= 25 else ('🟡 涨' if gt > 0 else '🟢')} |")
else:
    print(f"| **合计** | — | — | **{tot_c:,}** | — | ⚪ 无基线可比 |")

print()
if trig:
    print("## 🔴 **强制触发瘦身流程**（-60②乙·-60③「触发即 🔴，不得只记不办」）\n")
    for t in trig:
        print(f"- {t}")
    print("\n**次序（-60①3·两维分工·此后为定式）**：**CGM 出分节字节表 → GM 裁迁移边界 → CGM 执行（不删只迁）→ 重跑总量并刷基线。**")
    print("**逾期未办者入周对账预警位并计龄** —— 照 -51②：**龄不得被任何载体重置。**")
else:
    print("**本期无件越 25% 增幅闸。**\n")
    print("**⚠️ 惟须记：无触发 ≠ 无增长。** 上表之「🟡 涨」逐件可见；**-60② 之 25% 系触发线，不是容忍线**。")

print("\n## 时间触发（-60②甲）\n")
print("**每季一次，并入章程既有之「每季随章程过庭复审」——不新造日历项**（**新造即又一个会被忘掉的待办**）。")
print("**下一季点以章程过庭复审之既定节奏为准；本器不另设日历，故亦不代管其到期。**")
print("\n## 🔴 本器不做之事\n")
print("- **不裁任何迁移边界**（-60③：GM 专权，CGM 不可代裁）；")
print("- **不自行刷基线** —— `--set-baseline` 须有裁决来源；**基线一刷，增幅归零，红灯自然不亮**；")
print("- **不测绝对大小是否「过大」** —— 绝对上限未立（-60② 明书候三代实测），**本器只测相对增幅**。")
PY
