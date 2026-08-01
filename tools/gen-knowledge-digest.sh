#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# 裁决侧知识库摘录件生成器 —— ADJ-0801-04③ 立｜主责 CGM 机械抽取，GM 核
#
# 🔴 生成方式之硬纪律（-04③ 逐字）：
#   **CGM 以脚本机械抽取，GM 核；禁手写转写** —— **手写摘录系本库已实证之转写漂移来源**
#   （`-34③` 立逐日件形态之同一病因）。
#   故本器**只逐字截取正本之句**，绝不改写、绝不概括、绝不合并两句为一句。
#
# 🔴 摘录边界之判据（-04① 裁·不按字节切，按「半读是否比不读更危险」切）：
#   甲 · 入摘录件（直读）：其价值在「知道它存在」而非细节；读了摘要就能用，不读就会犯错
#   乙 · 触发式必读全文：**操作手册类——半个手册比没有手册更坏**（读者以为自己有，实则缺关键步）
#   丙 · 纯索引：查得到就够；不读不致犯错
#   **立此判据之由**：按字节或占比切，等于让「哪一节重要」由「哪一节长」来决定；
#   而本库已有实证反例——§十 EXT 手册**既长又关键，按字节切会最先被砍**，
#   而 GM-10 第一次要用中转仓时正撞上未读。
#
# 用法： bash tools/gen-knowledge-digest.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
SRC=docs/adjudicator-knowledge.md
OUT=docs/adjudicator-knowledge-DIGEST.md
LIMIT=4500
COMMIT=$(git log -1 --format=%H)
TS=$(date -u "+%Y-%m-%d %H:%M UTC")

python3 - "$SRC" "$COMMIT" "$TS" "$LIMIT" <<'PY' > "$OUT"
import re, sys, os
src, commit, ts, limit = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
raw = open(src, encoding='utf-8').read()

# 分节（正本系 `## 一、`…`## 十二、` 之扁平形态）
starts = [m.start() for m in re.finditer(r'(?m)^## ', raw)]
secs = []
for i, a in enumerate(starts):
    b = starts[i+1] if i+1 < len(starts) else len(raw)
    title = raw[a+3:raw.index('\n', a)].split('（')[0].split('(')[0].strip()
    secs.append((title, raw[a:b]))

def find(kw):
    for t, body in secs:
        if kw in t:
            return t, body
    return None, ''

# 甲类：入摘录件（-04② 之归类·逐节）
JIA = ['一、委托人画像', '二、委托人行为模式', '五、哲学基线']
# 甲类之特例：§三 只取「失败模式清单」，其余（前任个人史、语气自述）入丙
SAN_KW = '三、裁决侧自画像'

print("# 裁决侧知识库 · 摘录件 DIGEST（ADJ-0801-04③ 立）\n")
print("> **🔴 摘录·非正本。冲突一律以 `docs/adjudicator-knowledge.md` 为准。**")
print("> **生成**：`bash tools/gen-knowledge-digest.sh`｜**机械逐字截取，禁手写转写**（`-04③`）｜每节注正本节号与回读触发条件")
print(f"> **读取 commit**：`{commit}`｜**读取时点**：{ts}｜**上限** {limit} B（**超限即触发再裁，不得默默放宽**）")
print("> **载入集第 7 项**（`-04③`）｜**切法与逐单元归类见 `tools/gen-knowledge-digest.sh`；副产品＝`docs/failure-modes-uncovered.md`**\n")

print("## 🔴 乙类 · 触发式必读全文（**本件不摘录·届时读正本全文**）\n")
print("**判据**：**半个手册比没有手册更坏**。\n")
print("| 正本节 | B | **触发点（写死·可机械检出）** |")
print("|---|---:|---|")
for kw, trig in [('十、EXT 中转仓操作手册',
                  '**凡将发起任一 EXT／DR、或将向中转仓装载或回收任何件之前** —— 读**全文**，不得据摘要或他人转述行事'),
                 ('十一、两维签收制',
                  '**凡将执行任一签收动作之前** —— 读**全文**')]:
    t, body = find(kw.split('、')[0] + '、')
    if t and kw.split('、')[1][:4] in t:
        print(f"| §{t[:40]} | {len(body.encode()):,} | {trig} |")
    else:
        t2, b2 = find(kw.split('、')[1][:4])
        print(f"| §{t2 or kw} | {len(b2.encode()):,} | {trig} |")
print("\n**实证**：`ADJ-0731-62` §六 列 §十 为「下任最可能不知道自己需要」之一，**而 GM-10 第一次要用中转仓时正撞上未读**。\n")

print("---\n")
print("## 甲类 · 摘录（**逐字·未改写未概括**）\n")

total_lines = 0
for kw in JIA:
    t, body = find(kw[:4])
    if not t:
        continue
    print(f"### §{t}（正本节·全节 {len(body.encode()):,} B）\n")
    # 逐字取其项目行与粗体句，不改写
    for ln in body.split('\n'):
        st = ln.strip()
        if not st or st.startswith('## '):
            continue
        if st.startswith(('- ', '* ', '1.', '2.', '3.', '4.', '5.', '6.', '7.', '8.', '9.')) or st.startswith('**'):
            print(ln.rstrip())
            total_lines += 1
    print()

# §三 只取「失败模式清单」段（-04② 之切法申报）
t3, b3 = find(SAN_KW[:4])
if t3:
    print(f"### §{t3} —— **仅取「失败模式清单」段**（正本全节 {len(b3.encode()):,} B）\n")
    print("**切法（`-04②`）**：仅取失败模式清单（**岗位结构性风险清单**），其余（前任个人史、语气自述）入丙不摘 —— "
          "**岗位风险随岗位转移，不随实例死亡。**\n")
    # 🔴 精确取「失败模式清单」——其系正本内之**单行**
    m = re.search(r'(?m)^\*\*已知失败模式.*$', b3)
    if not m:
        print("**🔴 未抽到「已知失败模式」标记 —— 本段抽取失败，须回读正本 §三。**")
    else:
        fm = m.group(0)
        # ── ADJ-0801-07④ 之取舍判据：**该失败模式是否已被机械检测覆盖** ──
        #   有器兜底者 → 降为索引一行 ＋ 指向该器（**不逐字**）
        #   无器、只能靠人警觉者 → **逐字全留**
        #   立此判据之由（-07④ 逐字）：摘录件之功能由 -04① 甲类定义＝「读了就能用，不读就会犯错」；
        #   **有检测器会喊的失败模式，不读也不会犯错——器会说话；没有器的，才是必须靠读来防的。**
        MARKS = ['**⑧转写稀释', '**⑨步0搜索不完备', '**⑨-补款', '**⑧⑨补充', '**⑩归属过度断言']
        cuts, prev = [], 0
        for mk in MARKS:
            k = fm.find(mk)
            if k < 0:
                continue
            cuts.append(fm[prev:k]); prev = k
        cuts.append(fm[prev:])
        units = [c for c in cuts if c.strip()]
        # 🔴 对平核：切完之字节须等于原文，**缺一字即报错，不以「切好了」充「没丢」**
        joined = ''.join(cuts)
        if joined != fm:
            print("**🔴 切分对不平原文 —— 抽取作废，须回读正本 §三。**")
            units = []

        # 判据表：单元 → (是否已有器, 器名／检测点)
        # 🔴 判据之适用须照 GM 自己所举之例，不得比它更宽：
        #   `-07④` 表内「无检测器、只能靠人警觉者」之三例即
        #   **「以未见代不存在」「批量即把未核变已核」「归属过度断言」**。
        #   本席初版把 ⑨「步0搜索不完备」归入「已有器」（理由：日对账源① 机械枚举两 inbox）——
        #   **而 ⑨ 正是「以未见代不存在」之本条**，GM 明列其为无器。**故改归无器。**
        #   **判据是 GM 的，例也是 GM 的；本席按自己的理解放宽一格，就等于自己改了判据。**
        #   现状：本清单**全部单元皆无器兜底** —— 器所覆盖者系「产物状态」（锚、签收、字节、缺档），
        #   而本清单所载者系「推理与姿态之失效」，**两类不同域，故省不下来**。此系事实，非本器之推托。
        COVERED = {}
        keep, idx = [], []
        for u in units:
            hit = next((k for k in COVERED if u.startswith(k)), None)
            (idx if hit else keep).append((u, COVERED.get(hit, '')))

        print("**切法（`-07④`）**：按「**是否已被机械检测覆盖**」切；判据全文与逐单元归类见 "
              "`tools/gen-knowledge-digest.sh` 与副产品 `docs/failure-modes-uncovered.md`。"
              f"**本轮实测：{len(units)} 单元全部无器兜底，故全留。**\n")

        if idx:
            print("**已有器兜底者（索引一行·不逐字）**：")
            for u, d in idx:
                head = u.strip().split('**')[1] if '**' in u else u[:24]
                print(f"- {head} → **器＝{d}**（{len(u.encode()):,} B 已省）")
            print()
        print("**无器者·逐字全留**：\n")
        for u, _ in keep:
            print(u.rstrip())
        print()
        kb = sum(len(u.encode()) for u, _ in keep)
        ib = sum(len(u.encode()) for u, _ in idx)
        print(f"**本段：逐字留 {kb:,} B ／ 索引省 {ib:,} B ／ 原文 {len(fm.encode()):,} B（对平：{kb+ib:,}）**")
        # 🔴 副产品（-07④ 明令单独输出）：尚无检测器之失败模式清单 → 下一批该建器之处
        import io as _io
        with _io.open('docs/failure-modes-uncovered.md', 'w', encoding='utf-8') as fh:
            fh.write("# 尚无机械检测器之失败模式清单（ADJ-0801-07④ 之副产品·令单独输出）\n\n")
            fh.write("> **生成**：`bash tools/gen-knowledge-digest.sh`（**摘录件切分之副产品，非另行判断**）\n")
            fh.write(f"> **抽自**：`{src}` §三「已知失败模式」单行｜**读取 commit**：`{commit}`\n")
            fh.write("> **🔴 本清单之用途（`-07④` 逐字）**：「**切完自动得出一张「尚无检测器之失败模式」清单，"
                     "那正是下一批该建器的地方。**」\n")
            fh.write("> **本清单不排优先级、不提建器方案** —— 建不建、先建哪个，**属判断类，呈 GM**。\n\n")
            fh.write(f"**尚无器者 {len(keep)} 单元／已有器者 {len(idx)} 单元。**\n\n")
            fh.write("## 尚无器（逐字照录·未改写）\n\n")
            for u, _ in keep:
                fh.write("- " + u.strip().replace('\n', ' ') + "\n")
            fh.write("\n## 已有器（附其器）\n\n")
            for u, d in idx:
                fh.write("- " + u.strip()[:60].replace('\n', ' ') + f" → **{d}**\n")
    print()

print("---\n")
print("## 丙类 · 纯索引（**查得到就够；不读不致犯错**）\n")
print("| 正本节 | 字节 |")
print("|---|---:|")
for t, body in secs:
    if any(k[:4] in t for k in JIA) or SAN_KW[:4] in t or t.startswith(('十、', '十一')):
        continue
    print(f"| §{t[:46]} | {len(body.encode()):,} |")
print("\n**正本＝`docs/adjudicator-knowledge.md`；分节字节表＝`docs/section-size-adjudicator-knowledge.md`（14 节·对平 0 B）。**")
PY

B=$(wc -c < "$OUT")
echo "→ 已生成 $OUT （${B} B ／ 上限 ${LIMIT} B）"
if [ "$B" -gt "$LIMIT" ]; then
  echo "🔴 **超限 $((B-LIMIT)) B —— 照 -04③「超限即触发再裁，不得默默放宽」，本器只报不自削。**"
else
  echo "🟢 未超限（余量 $((LIMIT-B)) B）"
fi
