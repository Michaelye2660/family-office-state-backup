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
print("> **生成**：`bash tools/gen-knowledge-digest.sh`｜**机械逐字截取，禁手写转写**（`-04③`）")
print(f"> **读取 commit**：`{commit}`｜**读取时点**：{ts}｜**上限** {limit} B（**超限即触发再裁，不得默默放宽**）")
print("> **载入集第 7 项**（`-04③`·**非新增一整份必读项**：正本 26,046 B 已于 `-58②` 移出，本件仅取其约 17% 回入）\n")

print("## 🔴 乙类 · 触发式必读全文（**本件不摘录·届时读正本全文**）\n")
print("**判据**：**操作手册类 —— 半个手册比没有手册更坏**（读者以为自己有，实则缺关键步）。\n")
print("| 正本节 | 字节 | **触发点（写死·可机械检出）** |")
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
print("\n**🔴 实证之由**：`ADJ-0731-62` §六 明写「下任最可能不知道自己需要之三件事」，其一即 §十；"
      "**而 GM-10 第一次要用中转仓时正撞上未读。**\n")

print("---\n")
print("## 甲类 · 摘录（**逐字截取正本之句·未改写未概括**）\n")

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
    print("**🔴 切法申报（`-04②` 逐字）**：仅取失败模式清单（**岗位结构性风险清单**），"
          "其余（前任个人史、语气自述）入丙类不摘。")
    print("**理由**：该节应读作「**此岗位之结构性风险清单**」，非前任个人档案 —— "
          "**岗位风险随岗位转移，不随实例死亡。**\n")
    # 🔴 精确取「失败模式清单」——其系正本内之**单行**（含 ①–⑩ 与 ⑧⑨ 两条补款）
    m = re.search(r'(?m)^\*\*已知失败模式.*$', b3)
    if m:
        fm = m.group(0)
        print(fm.rstrip())
        total_lines += 1
        print()
        print(f"**🔴 本段逐字全长 {len(fm.encode()):,} B —— 超 `-04②` 所定之「约 1,500 B」目标 "
              f"{len(fm.encode())/1500:.1f} 倍。**")
        print("**逐字抽取只能『选』，不能『缩』**；要压到 1,500 B 只能改写或概括，"
              "**而 `-04③` 明令「禁手写转写」** —— **两条不能同时成立，已呈裁，本器不自行取舍。**")
    else:
        print("**🔴 未抽到「已知失败模式」标记 —— 本段抽取失败，须回读正本 §三。**")
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
