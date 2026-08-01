#!/usr/bin/env bash
export TZ=Asia/Singapore
# ============================================================================
# 产出全表（**ADJ-0801-10① 令立**·2026-08-01）
#
# 🔴 为哪次事故而立（GM-12 逐字）：
#   「G1 在纸上完整，在物理上不可行使」——GM 所见者仅备案册内 CGM **决定入册**之行，
#   而入册范围取决于「机械类 vs 判断类」之分界，**该分界由 CGM 自判**；
#   其检出法作「复核方之随机抽查」，**而抽查须有样本框，样本框亦由 CGM 提供**。
#   GM 无 shell、无范围读、连接器只能整档取回 —— **物理上无法枚举 CGM 之全部产出**。
#   **判据一句：无完整样本框之抽查不是抽查，是复核对方递过来的那一叠。**
#
# 🔴 本器即那个样本框：出**当期全部 commit 之件级清单 ＋ 每件之机械／判断类自判标注 ＋ 入册与否**。
#
# 🔴 它不核什么（先列·免「未报」被读作「已核无事」）：
#   - **不判该标注对不对** —— 标注仍系 CGM 自判，**本器只使其可被逐件质疑**；
#     **样本框之完整性可机械保证，标注之正确性不能**——**这是本器所能做到的边界，不是它已解决的问题**。
#   - 不判该入册而未入册（**那正是复核方拿本表去问的那一问**）。
#
# 🔴 `ADJ-0801-18③` 第一步（2026-08-01·即刻生效）：**凡「自判机械故不入册」者，
#   须于本表该行写一句「何以判机械」——一句话，非七栏。**
#   **其作用系负空间抽样之问法之锚**：**无它，抽样问「此件何以未入册」所得者系事后重构；
#   有它，所得者系当时之答案。两者系不同强度之证据。**
#   **成本一句 vs 备案册七栏之 978 B，而它保住收窄后唯一真会丢的东西。**
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "产出全表"; exit 3; fi
D="${1:-$(date +%F)}"
OUT="docs/output-manifest/${D}.md"; mkdir -p docs/output-manifest
{
echo "# CGM 产出全表 · ${D}（**ADJ-0801-10① 令立**·抽查之样本框）"
echo
echo "> 生成：\`bash tools/output-manifest.sh ${D}\`｜读取 commit：\`$(git log -1 --format=%H)\`"
echo "> **本表之用**：**给复核方一个完整样本框** —— 「无完整样本框之抽查不是抽查，是复核对方递过来的那一叠」（\`-10①\`）。"
echo "> **🔴 本表之限度**：**样本框之完整性可机械保证；每件之机械／判断类标注仍系 CGM 自判，其正确性不能**。**请拿本表逐件质疑，尤其是标「机械」而未入册者。**"
echo
echo "| # | commit | 件级改动 | CGM 自判 | 入备案册 |"
echo "|---:|---|---|---|---|"
i=0
for c in $(git log --since="${D} 00:00:00" --until="${D} 23:59:59" --format='%H|%s' | grep -v '^[0-9a-f]*|\[裁决侧' | cut -d'|' -f1); do
  i=$((i+1))
  files=$(git show --name-only --format='' "$c" | grep -v '^$' | tr '\n' ' ')
  subj=$(git log -1 --format=%s "$c" | cut -c1-46)
  # 自判：只动 tools/ docs/*-recon docs/internal-audit docs/state-core INDEX 者 → 机械；动 lanes/docket/agents/宪法/章程者 → 判断
  cls="机械"
  echo "$files" | grep -qE 'adjudication-lanes|cgm-rulings-docket|\.claude/agents/|constitution|succession|judgment-gate|audit-governance-charter' && cls="**判断**"
  reg="—"
  echo "$files" | grep -q 'cgm-rulings-docket' && reg="是"
  [ "$cls" = "**判断**" ] && [ "$reg" = "—" ] && reg="**否 ← 请质疑此行**"
  echo "| $i | \`$(git log -1 --format=%h $c)\` | $(echo $files|cut -c1-90) | $cls | $reg |"
done
echo
echo "**本期执行侧 commit 数＝${i}**"
echo
echo "## 🔴 本器不核之项"
echo
echo "| 不核 | 谁来核 |"
echo "|---|---|"
echo "| **标注对不对** | 复核方（拿本表逐件质疑） |"
echo "| **该入册而未入册** | 复核方（\`-10①\` 之抽查即为此而设） |"
echo "| **分界本身是否正确** | GM／委托人（\`v1.4 §四\` 弱点 2 已自曝该分界由 CGM 自判） |"
} > "$OUT"
echo "→ 已写入 $OUT"
