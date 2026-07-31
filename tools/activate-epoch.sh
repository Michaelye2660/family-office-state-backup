#!/usr/bin/env bash
# 原子激活之钢印对咬（ADJ-0731-49§一步5）——**只核不写**，输出供 CGM 判是否放行。
# 用法： bash tools/activate-epoch.sh E9 docs/succession/E9-declaration.md adj-archive/ADJ-0731-49.md a70657e89449905696440960064d7aa393e245ab
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
EP="${1:?纪元号}"; DECL="${2:?就位声明路径}"; BOOK="${3:?交接书路径}"; ANCHOR="${4:?交接书应有 sha1}"
PASS=1; bad(){ echo "  🔴 $*"; PASS=0; }; ok(){ echo "  🟢 $*"; }

echo "── ⓪ 锚存续前置核（ADJ-0801-01④ 立·主责 CGM）──"
# 🔴 何以把它放在**激活之最前**：E11 之覆写事故（`c40c6ecc`）正发生在**轮换权威状态块**这一动作里，
#    而权威状态块之轮换恰恰只在激活时做。**事故发生在哪一步，检测点就钉在哪一步。**
#    本节**只核旧锚是否仍在**，不核新四字段是否写对（后者由 ①–④ 各节负责）——
#    当日之教训正是：**所有检查都在问「新的对不对」，没有一个在问「旧的还在不在」。**
if bash tools/anchor-guard.sh portfolio-state.md > /tmp/_act_ag.$$ 2>&1; then
  ok "台账锚全部存续（无计数下降）"
else
  bad "台账有锚计数下降 —— **旧内容被覆写。先复原，再谈激活。**"
  sed -n '/锚计数下降/,/^$/p' /tmp/_act_ag.$$ | sed 's/^/     /'
fi
rm -f /tmp/_act_ag.$$

echo "── ① 存在层 ──"
[ -f "$DECL" ] && ok "就位声明在库：$DECL" || bad "就位声明不存在：$DECL"
[ -f "$BOOK" ] && ok "交接书在库：$BOOK" || bad "交接书不存在：$BOOK"
[ -f "$DECL" ] || { echo; echo "🔴 未过：无声明即无可对咬之四字段，亦无 ACT（ACT＝该声明 commit 之自身哈希）。"; exit 2; }

echo "── ② 交接书锚对咬（三侧）──"
A=$(sha1sum "$BOOK" | cut -d' ' -f1)
[ "$A" = "$ANCHOR" ] && ok "交接书实算 sha1 ＝ 应有锚" || bad "交接书 sha1 不符：实算 $A ≠ 应有 $ANCHOR"
# 🔴 自我警戒（ADJ-0731-52 收件时补·CGM 自陈）：
#   本节系「放宽一处本席正希望通过之校验」，属最易自欺之处。故立三条硬纪律：
#   (i) 替代锚**必由本机现算**（git hash-object），**绝不采信声明内之自陈值**；
#   (ii) 走替代锚者**一律出 🟡 不出 🟢**，使「未走正路」在表面上永远可见；
#   (iii) 须同时报出正路不通之机械理由，否则即是静默绕过。
#   立此之由：blob SHA ＝ sha1("blob "+len+"\0"+content)，**系内容之确定性函数且另锁字节数**，
#   其证「同一份文件」之力**不弱于** sha1sum；对咬所欲证者正是此事，非某一种拼法。
if grep -qF "$ANCHOR" "$DECL"; then
  ok "声明内回声锚逐字命中"
else
  BLOB=$(git hash-object "$BOOK" 2>/dev/null)
  RCPT_GLOB="adj-archive/$(basename "${BOOK%.md}")*receipt*.md"
  # shellcheck disable=SC2086
  RCPT_N=$(ls $RCPT_GLOB 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "$BLOB" ] && grep -qF "$BLOB" "$DECL"; then
    echo "  🟡 声明未回声 sha1sum，**但逐字回声了本机现算之 git blob SHA ${BLOB:0:8}…** —— 内容同一性成立"
    echo "     ├ 替代锚由本机 \`git hash-object\` 现算，**非采信声明自陈**"
    echo "     ├ 正路不通之机械理由：该交接书之回执${RCPT_N:-0} 件（回执系 sha1sum 之唯一公布处；回执不存在则「整段复制自回执」无源）"
    echo "     └ **本项记 🟡 不记 🟢**；是否足以放行属判断类，**呈 GM／委托人可推翻**"
  else
    bad "声明内既无 sha1sum 之逐字回声，亦无本机现算之 blob SHA（${BLOB:0:8}…）—— 无任何内容同一性凭据"
  fi
fi

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
