#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# §五 ＋ §5-A 抽取件生成器 —— ADJ-0801-08⑦ 令｜主责 CGM｜**比照 `-07⑦` 之 state-core 形态**
#
# 🔴 立此件之由（-08⑦ 逐字）：
#   §五（三角色分离与三行运行节奏）与 §5-A 七问之正文，**在基底 56,145 B 之内**；
#   v2 合并稿系宣示形态、基底不重抄；**而 GM 侧无仓库 shell、连接器无范围读**
#   → **本席无法读到该扫描之逐项判据本身。**
#   **定性**：此系 `-07⑦`（有界三节不可执行）之**第二个实例，同一形态** ——
#   **一份被指定为操作依据的文件，在其执行者一侧读不到。**
#   而 `-04④` 恰恰已立「操作手册类不摘录、届时读全文」，理由是「半个手册比没有手册更坏」——
#   **-08⑦ 即在报：读全文这条路，GM 侧现在走不通。**
#
# 🔴 硬纪律：机械逐字抽取，**非转写**；件头硬标「抽取件·非正本」；
#   节边界靠标题字面定位 → **上游改标题即静默失效**，故每次打印所定位之标题原文；
#   **任一节抽得 0 B 即报 🔴 并非零退出**，不以空节充「该节为空」。
#
# 用法： bash tools/gen-sell-trigger-sec5.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
SRC=docs/moat/sell-trigger-spec-draft-v0.md
OUT=docs/moat/sell-trigger-sec5.md

python3 - "$SRC" "$OUT" <<'PY'
import io, re, subprocess, sys
src, out = sys.argv[1], sys.argv[2]
raw = io.open(src, encoding='utf-8').read()
commit = subprocess.run(['git','log','-1','--format=%H'], capture_output=True, text=True).stdout.strip()

m = re.search(r'(?m)^## 五、执行机制.*$', raw)
if not m:
    print("🔴 未定位到 `## 五、执行机制` —— 抽取失败，**不得当作该节为空**。"); sys.exit(1)
j = raw.find('\n## ', m.start() + 3)
body = raw[m.start(): j if j > 0 else len(raw)].rstrip()

# §5-A 系 §五 之内的 `### 5-A`；确认其确在所抽范围内，否则单独再抽
sub = re.search(r'(?m)^### 5-A.*$', body)
sub_in = bool(sub)
extra = ''
if not sub_in:
    s2 = re.search(r'(?m)^### 5-A.*$', raw)
    if s2:
        j2 = raw.find('\n## ', s2.start())
        extra = raw[s2.start(): j2 if j2 > 0 else len(raw)].rstrip()

o = []
o.append("# 卖出触发器 §五 ＋ §5-A · 抽取件（ADJ-0801-08⑦ 令）\n")
o.append("> **🔴 抽取件·非正本。冲突一律以 `docs/moat/sell-trigger-spec-draft-v0.md` 为准。**")
o.append("> **生成**：`bash tools/gen-sell-trigger-sec5.sh`｜**机械逐字截取，非转写**（一字未改、未概括、未补写）")
o.append(f"> **抽自 commit**：`{commit}`｜**正本**：`{src}`（{len(raw.encode()):,} B）")
o.append("> **立此件之由**：§五与 §5-A 之正文在 56 KB 基底之内，**而 GM 侧无仓库 shell、连接器无范围读** ——"
         "**一份被指定为操作依据的文件，在其执行者一侧读不到**；本件即其可读路径。"
         "此系 `ADJ-0801-07⑦`（有界三节不可执行）之**同型第二例**。\n")
o.append("| 所抽之节 | 定位到之标题原文 | 字节 |")
o.append("|---|---|---:|")
o.append(f"| §五（含 §5-A） | `{m.group(0)[:70]}` | {len(body.encode()):,} |")
if extra:
    o.append(f"| §5-A（**不在 §五 范围内·单独抽**） | `{re.search(r'(?m)^### 5-A.*$', raw).group(0)[:70]}` | {len(extra.encode()):,} |")
o.append("")
o.append(f"**§5-A 是否在 §五 范围内**：{'🟢 是（随 §五 一并抽出）' if sub_in else '🟡 否（已单独抽出，见下第二段）'}\n")
o.append("**🔴 本器之盲区**：节边界靠标题字面定位（`## 五、执行机制`／`### 5-A`）——**上游改标题即静默失效**；"
         "故上表打印所定位之标题原文，**使「定位到了什么」可被一眼核对**。\n")
o.append("---\n")
o.append(body)
if extra:
    o.append("\n---\n"); o.append(extra)
doc = '\n'.join(o)
io.open(out, 'w', encoding='utf-8').write(doc)
print(f"→ 已生成 {out}（{len(doc.encode()):,} B）")
print(f"   §五 定位：{m.group(0)[:60]} → {len(body.encode()):,} B")
print(f"   §5-A 在 §五 内：{'是' if sub_in else '否（已单独抽）'}")
if len(body.encode()) == 0:
    print("🔴 抽得 0 B —— 不以空节充「该节为空」。"); sys.exit(1)
print("🟢 抽取非空且定位到标题")
PY
