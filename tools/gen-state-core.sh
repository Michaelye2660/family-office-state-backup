#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# 有界三节抽取件生成器 —— ADJ-0801-07⑦ 令｜主责 CGM
#
# 🔴 立此件之由（-07⑦ 逐字）：
#   `ADJ-0731-54⑥-c` 把「台账全文」废为「**权威状态块 ＋〔K-0〕＋〔L-1x〕持仓节**」，
#   其理由是全文规模下不可执行；**惟改后条文在 GM 侧同样无实现路径**——
#   GM 侧无仓库 shell，连接器只能整档取回、无范围读。
#   **「同一缺陷降了一级，不是被修好。」**
#   CGM 实测：三节合计 62,064 B ＝台账 1,684,947 B 之 **3.68%**，抽取机械可行。
#
# 🔴 硬纪律：
#   (i)  **机械抽取，非转写** —— 逐字截取，绝不改写、绝不概括、绝不补写一字；
#   (ii) 件头硬标「**抽取件·非正本，冲突以 `portfolio-state.md` 为准**」；
#   (iii) **随任何〔D〕持仓／红线／触发器写入之同 commit 刷新**（与 `gm-snapshot.md` 同构）；
#   (iv) 本器**只抽不裁**：三节之边界由标题决定，不由本器挑选内容。
#
# 🔴 本器之盲区（先列）：
#   节边界靠标题字面定位（`### 〔K-0〕`／`## 〔L-1`）——**上游改标题即静默失效**；
#   故本器**每次打印所定位之标题原文与其字节**，使「定位到了什么」可被一眼核对；
#   且**任一节抽得 0 B 即报 🔴 并非零退出**，不以空节充「该节为空」。
#
# 用法： bash tools/gen-state-core.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
SRC=portfolio-state.md
OUT=docs/state-core.md

python3 - "$SRC" "$OUT" <<'PY'
import io, re, subprocess, sys
src, out = sys.argv[1], sys.argv[2]
raw = io.open(src, encoding='utf-8').read()
commit = subprocess.run(['git','log','-1','--format=%H'], capture_output=True, text=True).stdout.strip()
ver = re.search(r'^#[^\n]*?（(v1[0-9]\.\d+)', raw).group(1)
seg = raw[raw.index('\n## 〔M〕'):raw.index('\n## 〔N〕')]
last_m = re.findall(r'(?m)^(\d+)\. \*\*', seg)[-1]

parts, bad = [], []

# ① 权威状态块＝文件头至第一个 `## ` 之前
i = raw.index('\n## ')
parts.append(('权威状态块（单活纪元栅栏）', raw[:i].rstrip()))

# ②〔K-0〕节
m = re.search(r'(?m)^### 〔K-0〕.*$', raw)
if m:
    j = raw.find('\n## ', m.start())
    parts.append((m.group(0)[:60], raw[m.start(): j if j > 0 else len(raw)].rstrip()))
else:
    bad.append('〔K-0〕')

# ③〔L-1x〕持仓节
m = re.search(r'(?m)^## 〔L-1.*$', raw)
if m:
    j = raw.find('\n## 〔', m.start() + 5)
    parts.append((m.group(0)[:60], raw[m.start(): j if j > 0 else len(raw)].rstrip()))
else:
    bad.append('〔L-1x〕')

o = []
o.append("# state-core · 台账有界三节抽取件（ADJ-0801-07⑦ 令）\n")
o.append("> **🔴 抽取件·非正本。冲突一律以 `portfolio-state.md` 为准。**")
o.append("> **生成**：`bash tools/gen-state-core.sh`｜**机械逐字截取，非转写**（一字未改、未概括、未补写）")
o.append(f"> **抽自 commit**：`{commit}`｜**台账版本**：**{ver}**｜**末条〔M〕**：**{last_m}**")
o.append("> **刷新纪律**：**随任何〔D〕持仓／红线／触发器写入之同 commit 刷新**（与 `gm-snapshot.md` 同构）。")
o.append("> **立此件之由**：`-54⑥-c` 之有界三节在 GM 侧原**无实现路径**（无仓库 shell·连接器只能整档取回）——"
         "**同一缺陷降了一级，不是被修好**；本件即其实现路径。\n")
o.append("| 所抽之节 | 定位到之标题原文 | 字节 |")
o.append("|---|---|---:|")
tot = 0
for t, body in parts:
    b = len(body.encode()); tot += b
    o.append(f"| — | `{t}` | {b:,} |")
o.append(f"| **合计** | | **{tot:,}** |")
o.append(f"\n**对照：台账全档 {len(raw.encode()):,} B —— 本件为其 {tot/len(raw.encode())*100:.2f}%。**\n")
o.append("**🔴 本器之盲区（先列·免「未报」被读作「已核无事」）**：节边界靠标题字面定位，"
         "**上游改标题即静默失效**；故上表打印所定位之标题原文，**使「定位到了什么」可被一眼核对**。\n")
o.append("---\n")
for t, body in parts:
    o.append(body); o.append("\n---\n")
doc = '\n'.join(o)
io.open(out, 'w', encoding='utf-8').write(doc)

print(f"→ 已生成 {out}（{len(doc.encode()):,} B）")
for t, body in parts:
    print(f"   定位：{t[:50]} → {len(body.encode()):,} B")
if bad:
    print(f"🔴 **未定位到之节：{'／'.join(bad)}** —— 抽取不完整，**不得当作该节为空**。")
    sys.exit(1)
if any(len(b.encode()) == 0 for _, b in parts):
    print("🔴 **有节抽得 0 B** —— 不以空节充「该节为空」。"); sys.exit(1)
print("🟢 三节皆非空且皆定位到标题")
PY
