#!/usr/bin/env bash
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

files = sorted(p for p in glob.glob('docs/memory-digests/*.md')
               if os.path.basename(p) != 'INDEX.md')

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

print(f"\n**件数 {len(files)}**｜**主题句缺 {miss} 件** → "
      f"{'🟢 无缺' if miss == 0 else '🔴 **周对账须标红**（-58③④·主题句系强制项）'}\n")
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
