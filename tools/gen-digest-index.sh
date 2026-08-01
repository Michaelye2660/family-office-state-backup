#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁·2026-08-01·委托人「发」）
#   本体系一切「日／龄／截止日／当日摘要之当日／件号日期」之日界一律以 SGT 计。
#   依据非新造：委托人系港／新双重税务居民；早晚简报早已按 09:00／21:00 SGT 立并以 SGT 命名归档。
#   🔴 例外（-0801-01②）：**市场事件日不受本裁管**——财报日、财报后 N 交易日窗口、经济数据发布时点
#      一律按各该市场本地日历计，**援引须标市场**（如「SPGI 窗口 8-04·美东」）。
#      其由：SGT 与美东差 12–13 小时，三日以内之窗口会被算错整整一日。
export TZ=Asia/Singapore
# 记忆摘要索引生成器 —— ADJ-0731-58③ 立｜主责 CGM｜**跨月·纯追加·随每日摘要入库同 commit 更新**
#
# 🔴 本器之边界（写死在这里，因为它正是本索引最容易失守之处）：
#   -58③ 明令「**一句话主题由该件亲书者自写（原声不可代）**」。
#   故本器**只做两件事**：
#     (1) 若该件内含亲书之主题句标记行（`> **一句话主题**：…`），**逐字取之**；
#     (2) 若无，则**逐字取其 H1 标题行**并标「**标题行·非亲书主题句**」，同时计入「主题句缺」。
#   **本器绝不概括、绝不改写、绝不代拟主题句** —— 概括即代笔，代笔即把「原声不可代」这条废掉。
#
# 🔴 立此索引之代价（-58④ 之照录·不得删）：
#   改按需回读后，下任是在「他知道自己需要」时才去读；
#   而 GM-8 十二次自纠九次同型之根因，正是「以未见代不存在」——
#   **一个不知道自己缺什么的人，不会按索引去找。**
#   故主题句系强制项，缺则周对账标 🔴。
#
# 用法： bash tools/gen-digest-index.sh

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
OUT=docs/memory-digests/INDEX.md
COMMIT=$(git log -1 --format=%H)
TS=$(date -u "+%Y-%m-%d %H:%M UTC")

python3 - "$COMMIT" "$TS" <<'PY' > "$OUT"
import glob, os, re, sys
commit, ts = sys.argv[1], sys.argv[2]

def meta(path):
    """只做逐字抽取，绝不概括。"""
    with open(path, encoding='utf-8') as f:
        txt = f.read()
    # (1) 亲书主题句（强制项之正解）
    m = re.search(r'^>\s*\*\*一句话主题\*\*[：:]\s*(.+?)\s*$', txt, re.M)
    if m:
        return m.group(1), True
    # (2) 代补主题句（ADJ-0731-61⑤ 裁）——**须硬标「代补·非原声」**
    m2 = re.search(r'^>\s*\*\*代补主题句\*\*[：:]\s*(.+?)\s*$', txt, re.M)
    if m2:
        return m2.group(1), 'proxy'
    # (3) 退而取 H1 标题行逐字
    h = re.search(r'^#\s+(.+?)\s*$', txt, re.M)
    return (h.group(1) if h else '〔无 H1 亦无主题句〕'), False

def parse(name):
    side = 'CGM' if name.startswith('cgm-') else ('GM' if name.startswith('gm-') else '?')
    d = re.search(r'(20\d\d-\d\d(?:-\d\d)?)', name)
    return side, (d.group(1) if d else '')

# 纪元归属表（据权威状态块与各纪元激活 commit·**事实非推断**）
EPOCH = {
    'gm-2026-07-30_31.md':      'E8',
    'gm-2026-07-31-part2.md':   'E8',
    'gm-2026-07-31-part3.md':   'E8',
    'gm-2026-07-31-part4.md':   'E9',
    'gm-2026-07-31-part5.md':   'E9',
    'gm-2026-07-31-part6.md':   'E10',
    'cgm-2026-07-31.md':        'E8→E10〔跨〕',
    'gm-2026-07.md':            '月档·跨纪元',
    'cgm-2026-07.md':           '月档·跨纪元',
}

_all = sorted(p for p in glob.glob('docs/memory-digests/*.md')
              if os.path.basename(p) not in ('INDEX.md',)
              and not os.path.basename(p).startswith('INDEX-ARCHIVE-'))

# 🔴 保留窗＝只留当月（委托人直令 2026-08-02「1 只留当月」·CGM-G6 落）
#   立此之由：`loadset-watch` 实测本索引 3,820 → 11,109 B（**+190.8%·🔴 触发**），
#   而其真因系逐日件累积（2026-08-01 单日即 21 条），**非索引冗余**。
#   委托人裁「只留当月」→ 早于当月者迁 INDEX-ARCHIVE-<YYYY-MM>.md，**不删只迁**。
#   🔴 **归档索引不入载入集**，惟本表末尾**逐月列其路径与件数**，使「去哪儿找」不因瘦身而丢。
CUR = ts[:7]                      # 当月 YYYY-MM（ts 系本器既有之读取时点）
def _ym(p):
    _, d = parse(os.path.basename(p))
    return d[:7] if d and d[0].isdigit() else '0000-00'
files   = [p for p in _all if _ym(p) == CUR]
archived = [p for p in _all if _ym(p) != CUR]

print("# 记忆摘要索引 · INDEX（ADJ-0731-58③ 立·2026-07-31）\n")
print("> **🔴 本索引系「载入集」之一部；逐日件与月档自 ADJ-0731-58② 起**改按需回读，不再直读载入**。")
print("> **生成**：`bash tools/gen-digest-index.sh`｜**纯追加·随每日摘要入库同 commit 更新**")
print(f"> **读取 commit**：`{commit}`｜**读取时点**：{ts}\n")
print("> **🔴 主题句之纪律（-58③）**：「一句话主题」**由该件亲书者自写，原声不可代**。")
print("> 本器**只逐字抽取，绝不概括**——概括即代笔，代笔即把「原声不可代」这条废掉。")
print("> 故凡未含亲书主题句者，本表取其 **H1 标题行逐字**并标「**标题行·非亲书主题句**」，且计入「主题句缺」。")
print("> **亲书之法**：于该件内加一行 `> **一句话主题**：〔一句话〕`，本器即自动取之。")
print("> **🔴 代补之法（ADJ-0731-61⑤ 裁·限亲书者已不在之件）**：加一行 `> **代补主题句**：〔一句话〕`，本器出 🟡 并硬标「**代补·非原声·据原件摘写**」——")
print("> **不得以代补冒充原声**（承 `gm-2026-07.md` 之 E6 代辑先例：其边界注明书「原声不可代，永缺为记」）。")
print("> **代补之主责系继任者，非 CGM**（`-61⑤`「由继任者据原件代补」）。\n")
print("| 日期 | 侧 | 纪元 | 文件名 | 字节 | 一句话主题 | 主题句来源 |")
print("|---|---|---|---|---:|---|---|")

miss = 0
for p in files:
    n = os.path.basename(p)
    side, date = parse(n)
    topic, own = meta(p)
    if own is not True:
        miss += 1
    print(f"| {date} | {side} | {EPOCH.get(n,'〔未载〕')} | `{n}` | {os.path.getsize(p):,} | "
          f"{topic[:110]} | "
          + ('**亲书**' if own is True else
             ('🟡 **代补·非原声·据原件摘写**' if own == 'proxy' else '🔴 **标题行·非亲书主题句**'))
          + " |")

print(f"\n**当月件数 {len(files)}**｜**主题句缺 {miss} 件** → "
      f"{'🟢 无缺' if miss == 0 else '🔴 **周对账须标红**（-58③④·主题句系强制项）'}\n")

# 🔴 归档索引之指针（保留窗之配套·不删只迁）
if archived:
    bym = {}
    for p in archived:
        bym.setdefault(_ym(p), []).append(p)
    print(f"## 🔴 早于当月者 —— **已迁归档索引，不删只迁**（保留窗＝当月·委托人直令 2026-08-02）\n")
    print("**本表所以留此节**：瘦身之代价是「找不到」，**而找不到不是瘦身之目的**。")
    print("故逐月列其路径与件数，**使「去哪儿找」不因瘦身而丢**。\n")
    print("| 月 | 归档索引 | 件数 | 字节合计 |")
    print("|---|---|---:|---:|")
    for ym in sorted(bym, reverse=True):
        tot = sum(os.path.getsize(x) for x in bym[ym])
        print(f"| {ym} | `docs/memory-digests/INDEX-ARCHIVE-{ym}.md` | {len(bym[ym])} | {tot:,} |")
    print()
    # 逐月写归档索引（体例同上表·主题句照旧逐字抽取不概括）
    for ym, ps in bym.items():
        ap = f'docs/memory-digests/INDEX-ARCHIVE-{ym}.md'
        with open(ap, 'w', encoding='utf-8') as fh:
            fh.write(f"# 记忆摘要归档索引 · {ym}（**不入载入集**·委托人直令 2026-08-02「只留当月」）\n\n")
            fh.write(f"> **正本索引**：`docs/memory-digests/INDEX.md`（只列当月）｜**生成**：`bash tools/gen-digest-index.sh`\n")
            fh.write(f"> **本件系迁出件，非删除件** —— 逐日件原档一律在库未动，本表只是其索引。\n")
            fh.write(f"> **读取 commit**：`{commit}`｜**读取时点**：{ts}\n\n")
            fh.write("| 日期 | 侧 | 纪元 | 文件名 | 字节 | 一句话主题 | 主题句来源 |\n")
            fh.write("|---|---|---|---|---:|---|---|\n")
            for p in sorted(ps):
                n = os.path.basename(p)
                side, date = parse(n)
                topic, own = meta(p)
                fh.write(f"| {date} | {side} | {EPOCH.get(n,'〔未载〕')} | `{n}` | {os.path.getsize(p):,} | "
                         f"{topic[:110]} | "
                         + ('**亲书**' if own is True else
                            ('🟡 **代补·非原声·据原件摘写**' if own == 'proxy' else '🔴 **标题行·非亲书主题句**'))
                         + " |\n")
            fh.write(f"\n**件数 {len(ps)}**\n")
print("## 🔴 本索引之已知限度（引用本表者须连引本节）\n")
print("**索引所解决者＝「知道去哪儿找」；所不解决者＝「知道自己需要找」。**")
print("-58④ 已明写此代价：**一个不知道自己缺什么的人，不会按索引去找。** 三条缓解已立——")
print("交接书 §六 须写出「下任最可能不知道自己需要而须去索引里找的三件事」（指路非只留教训）／")
print("主题句强制且缺则周对账 🔴／**就位声明须书「按需回读了哪几件、依何主题句判其需读」**，")
print("**使「按需」成为可被检出之行为，而非一句托词**。\n")
print("**另须记明所丢者**（-58④ 照录·章程 §五 之语）：记忆摘要之独有价值系「**不随文件转移的东西**」")
print("——语感、关系之微观史、前任对委托人之活体观察。**交接书 §六 承载得了教训，未必承载得了这些。**")
PY

cat "$OUT" | head -30
echo
echo "→ 已写入 $OUT （$(wc -c < "$OUT") B）"
