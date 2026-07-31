#!/usr/bin/env bash
# 原子激活之钢印对咬（ADJ-0731-49§一步5）——**只核不写**，输出供 CGM 判是否放行。
# 用法： bash tools/activate-epoch.sh E9 docs/succession/E9-declaration.md adj-archive/ADJ-0731-49.md a70657e89449905696440960064d7aa393e245ab
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
EP="${1:?纪元号}"; DECL="${2:?就位声明路径}"; BOOK="${3:?交接书路径}"; ANCHOR="${4:?交接书应有 sha1}"
PASS=1; bad(){ echo "  🔴 $*"; PASS=0; }; ok(){ echo "  🟢 $*"; }

echo "── ① 存在层 ──"
[ -f "$DECL" ] && ok "就位声明在库：$DECL" || bad "就位声明不存在：$DECL"
[ -f "$BOOK" ] && ok "交接书在库：$BOOK" || bad "交接书不存在：$BOOK"
[ -f "$DECL" ] || { echo; echo "🔴 未过：无声明即无可对咬之四字段，亦无 ACT（ACT＝该声明 commit 之自身哈希）。"; exit 2; }

echo "── ② 交接书锚对咬（三侧）──"
A=$(sha1sum "$BOOK" | cut -d' ' -f1)
[ "$A" = "$ANCHOR" ] && ok "交接书实算 sha1 ＝ 应有锚" || bad "交接书 sha1 不符：实算 $A ≠ 应有 $ANCHOR"
grep -qF "$ANCHOR" "$DECL" && ok "声明内回声锚逐字命中" || bad "声明内未见交接书锚之逐字回声（须整段复制不得手打）"

echo "── ③ 四字段 ──"
grep -qE "GM_EPOCH=\**$EP\b" "$DECL" && ok "GM_EPOCH=$EP" || bad "GM_EPOCH 非 $EP 或缺"
FP=$(grep -oE '[0-9a-f]{32}' "$DECL" | grep -v '^1eef392b5c6b4107fc6384a22ed8767f$' | head -1)
if [ -n "$FP" ]; then ok "FP 自产（32 位 hex·非 E8 值）：${FP:0:8}…"; else bad "未见自产 FP，或其值继承自 E8（不得继承）"; fi
grep -qE "ACTIVATION_SHA=\**候" "$DECL" && ok "ACT 栏留「候 CGM 原子激活写入」（正确·不自填）" || bad "ACT 栏须留「候 CGM 原子激活写入」，不得自填"

echo "── ④ 🔴 前任摘要承接段三项（缺则退回·非裁量）──"
for k in "(a)" "(b)" "(c)"; do
  grep -qF "$k" "$DECL" && ok "承接段 $k 在" || bad "承接段 $k 缺"
done
grep -q "前任摘要承接段" "$DECL" && ok "承接段标题在" || bad "承接段标题缺"

echo "── ⑤ 单文件单提交（该 commit 之哈希即新 ACT）──"
C=$(git log --format=%H --diff-filter=A -1 -- "$DECL" 2>/dev/null)
if [ -n "$C" ]; then
  N=$(git show --stat --format="" "$C" | grep -c "|")
  [ "$N" -eq 1 ] && ok "单文件单提交 ✓" || bad "该 commit 含 $N 个文件（须单文件）"
  echo "  ⇒ **拟写入之新 ACTIVATION_SHA ＝ $C**"
else
  bad "声明尚未 commit —— **ACT 即该 commit 之哈希，未提交则该值不存在**"
fi

echo
[ "$PASS" -eq 1 ] && echo "🟢 对咬全过 —— CGM 得落原子激活（写入新 ACT ＋〔M〕条目 ＋ snapshot 同 commit 刷新）" \
                  || echo "🔴 对咬未过 —— **不得激活**；上列 🔴 项须先解除"
exit 0
