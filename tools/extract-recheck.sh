#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 抽取件二次超线复查器（`docs/gm-readability-inventory.md` §三-1 之判据落成日期与检出器）
#
# 🔴 为哪条「只写成判据、没变成东西」而立：
#   `gm-readability-inventory.md` §三-1 本席自书 ——
#     **「抽取件不是一次性解法，是一个会自己复发的东西。
#       凡立抽取件，须同轮写死其『二次超线之复查日』，否则它只是把同一个问题推迟。」**
#   **而该判据当轮只写成了一句话**：同件 §四-4 自记「**本轮只写出判据，未变成日期，亦未变成检出器**」。
#   **本器即其兑现。**
#
# 🔴 立此之实证（**非假想·同日两例**）：
#   - `docs/state-core.md` 系为解决「`portfolio-state.md` 读不动」而造，**今已越线**；
#   - `docs/ext/SUBMISSION-SUMMARY-*.md` 系为摘要而造，**自己也越了线**。
#   **两者皆非「有一天可能会」，是「已经发生了」。**
#
# 🔴 它不核什么（先列不覆盖处）：
#   - **不核抽取件是否忠于其正本** —— 那是包含性检验之事（见 `gm-verify-proxy.sh` 行 2）；
#   - **不核该件是否还有存在必要**；
#   - **不核 GM 侧之真实可读上限** —— 本器沿用 30 KB 之**代理线**，
#     **该线系 CGM 所划、无实测支撑**（`gm-readability-inventory.md` §一 已如实标）；
#   - **不自动修复**：越线者本器只报，**不删不拆不重生成**。
#
# 🔴 死法与检出法（照 `cc-knowledge.md:261`）：
#   **退役条件**：当 GM 侧获得范围读（可只取一档之一节）→ 抽取件整族失去存在理由，本器随之退役。
#     **「一直无越线」不构成退役理由** —— 本器所防者恰是「悄悄长回去」。
#   **检出法（落本器之外）**：〔K-0〕之**日期型挂钟**（**2026-09-01 首次复查**）——
#     **逾期即由日对账源③／内审官甲2 自动报红**，**不靠人记得跑本器**。
#
# 用法： bash tools/extract-recheck.sh
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "抽取件二次超线复查器"; exit 3; fi

LINE=30000   # 代理线（30 KB）·本席所划·无实测支撑·GM 若报实测上限即以实测取代
RED=0

echo "# 抽取件 · 二次超线复查（$(date +%F)·SGT）"
echo
echo "> **判据**：**抽取件不是一次性解法，是一个会自己复发的东西。**"
echo "> **线＝${LINE} B（代理量·CGM 所划·无实测支撑）**；**本器只报，不删不拆不重生成。**"
echo
echo "| 抽取件 | 它替谁挡 | 字节 | 判 |"
echo "|---|---|---:|---|"

check() {
  local f="$1" for_what="$2"
  [ -f "$f" ] || { echo "| \`$f\` | $for_what | **不在** | ⚪ 未造 |"; return; }
  local b; b=$(wc -c < "$f" | tr -d ' ')
  if [ "$b" -gt "$LINE" ]; then
    RED=$((RED+1))
    echo "| \`$f\` | $for_what | **${b}** | 🔴 **已二次超线** —— 它自己变成了它所要解决的那个问题 |"
  else
    echo "| \`$f\` | $for_what | ${b} | 🟢 线下 |"
  fi
}

check docs/state-core.md "portfolio-state.md（1.87 MB）"
check docs/adjudication-lanes-CURRENT.md "adjudication-lanes.md（78 KB·十版层叠）"
check docs/ext/REGIME-CURRENT-extract.md "同上·机械抽取之对照件"
check docs/moat/sell-trigger-sec5.md "sell-trigger-spec-draft-v0.md（56 KB）"
check docs/adjudicator-knowledge-DIGEST.md "adjudicator-knowledge.md"
for f in gm-inbox/AUDIT-*-DIGEST.md; do
  [ -e "$f" ] && check "$f" "内审官全文报告（28 KB）"
done
for f in docs/ext/SUBMISSION-SUMMARY-*.md; do
  [ -e "$f" ] && check "$f" "呈裁正本之摘要"
done

echo
if [ "$RED" -gt 0 ]; then
  echo "**🔴 二次超线 ${RED} 件。**"
  echo
  echo "**处置不是「删」，是三选一，且须显式记其选择**："
  echo "1. **分卷**（照 \`gen-submission-summary.sh\` 自书：**须另立分卷而非截断**——截断使「未含」与「不存在」不可分）；"
  echo "2. **再抽一层**（并**同轮写死这一层自己的复查日**，否则只是把问题又推迟一次）；"
  echo "3. **判其已无必要而退役**（须书其退役条件是否成就）。"
  echo
  echo "**🔴 不得选第四条「先这样」** —— 本器之全部立项理由，就是上一次选了第四条。"
else
  echo "**🟢 无二次超线。**"
fi
echo
echo "**下次复查日＝\`〔K-0〕\` 之日期型挂钟（2026-09-01）** —— **逾期由日对账源③／内审官甲2 自动报红，不靠人记得跑本器。**"
