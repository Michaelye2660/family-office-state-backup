#!/usr/bin/env bash
# 🔴 治理时钟＝SGT（ADJ-0801-01① 裁）
export TZ=Asia/Singapore
# ============================================================================
# 装载申报三项自核 —— ADJ-0801-09④ 立｜主责 CGM
#
# 🔴 立此器之由（-09④ 逐字）：
#   委托人 2026-08-01 直令「引导语这种非重要判断类工作都由 cgm 来做」→ 拟稿主责移交 CGM，
#   **GM 之目视随之退场**。故：
#   「**减一个弱检查，须以一个强检查抵之；否则就是借省事之名把闸拆了。**」
#   「**GM 目视本就不是强检查——它靠的是当时记得看；装载申报是可事后审计的。
#     此处不是降级，是换成更硬的那一种。**」
#
# 🔴 三项（缺一即不合格·本器不放行）：
#   (i)   证据包锚 sha1
#   (ii)  剔除申报：剔了什么·依何判据（`-0801-03①`：**我方席位署名行与模型标识行，仅此二类**；
#         **证据实体内容一字不得剔**）
#   (iii) 盲设计三项之在否：同源同包／互不见／独立会话
#
# 🔴 本器之盲区（先列·免「未报」被读作「已核无事」）：
#   (a) 本器**核不了「引导语问得对不对」** —— 那是实质设计，属 (甲) 情形回 GM；
#   (b) 本器**核不了「独立会话」是否真独立** —— 对话式席位我方无机械凭据（`-03③` 已裁其为
#       「他报口径·未经机械验证」）；本器只核该项**有无被申报**，不核其真伪；
#   (c) 本器**不判该批该不该发** —— 发不发属判断类。
#
# 🔴 两处已修之缺陷（首跑当轮自捕·写死免复发）：
#   (a) 双引号内含反引号 → shell 当成命令替换，把 `-09⑤` 整段吞掉，
#       **只在 stderr 留一行 command not found，正文里看不出缺了字**；改单引号。
#   (b) `cut -c1-90` 在 C locale 下**按字节切**，截断多字节字符 → **产出之文件不是合法 UTF-8**；
#       改以 python 按字符截。**两处共性：坏掉的是输出，而输出本身看起来是完整的。**
#
# 用法： bash tools/relay-load-declare.sh <证据包路径> <外发文本路径> [标的]
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
PKG="${1:?证据包路径}"; OUT="${2:?外发文本路径}"; SYM="${3:-（未标）}"
PASS=1; bad(){ echo "  🔴 $*"; PASS=0; }; ok(){ echo "  🟢 $*"; }

echo "# 装载申报（ADJ-0801-09④ · 三项自核）"
echo
echo "- **标的**：${SYM}｜**证据包**：\`${PKG}\`｜**外发文本**：\`${OUT}\`"
echo "- **读取 commit**：\`$(git log -1 --format=%H)\`"
# 🔴 此行曾以双引号内含反引号书写 —— shell 当成命令替换，把 `-09⑤` 整段吞掉且**只在 stderr 留一行 command not found**。
#   其形态＝**输出看起来完整，缺的那几个字不会在正文里留下任何痕迹**；故改单引号。
echo '- **🔴 §十 全文读毕之申报**：装载支之读全文义务已于 `ADJ-0801-09⑤` 转归 CGM；**本次装载前是否读毕 §十 全文＝〔须由执行者当轮填「是／否」，本器不代填〕**'
echo

echo "## (i) 证据包锚 sha1"
if [ -f "$PKG" ]; then
  ok "包在库｜**内容 sha1 ＝ \`$(sha1sum "$PKG" | cut -d' ' -f1)\`**｜字节 $(wc -c < "$PKG")"
  echo "     └ blob SHA \`$(git hash-object "$PKG")\`（**与内容 sha1 系不同函数·不可互充**）"
else bad "证据包不存在：$PKG"; fi
echo

echo "## (ii) 剔除申报（判据＝\`-0801-03①\`：**我方席位署名行 ＋ 模型标识行，仅此二类**）"
if [ -f "$PKG" ] && [ -f "$OUT" ]; then
  # 机械求差：包内有而外发文本内无之行
  DIFF=$(grep -vxF -f "$OUT" "$PKG" 2>/dev/null | grep -v '^[[:space:]]*$' || true)
  N=$(printf '%s' "$DIFF" | grep -c . || true)
  echo "  **被剔行数＝${N}**"
  if [ "${N:-0}" -gt 0 ]; then
    echo
    echo "  | # | 被剔之行（逐字） | 是否属可剔二类 |"
    echo "  |---:|---|---|"
    i=0
    printf '%s\n' "$DIFF" | while IFS= read -r ln; do
      i=$((i+1))
      if printf '%s' "$ln" | grep -qE '执行侧·CGM|裁决侧·GM|claude-opus|claude-sonnet|claude-fable|证据包构建|模型'; then
        printf '  | %d | `%s` | 🟢 属（席位署名／模型标识） |\n' "$i" "$(printf '%s' "$ln" | python3 -c 'import sys;print(sys.stdin.read().rstrip()[:60])')"
      else
        printf '  | %d | `%s` | 🔴 **不属二类——证据实体不得剔** |\n' "$i" "$(printf '%s' "$ln" | python3 -c 'import sys;print(sys.stdin.read().rstrip()[:60])')"
      fi
    done
    echo
    if printf '%s\n' "$DIFF" | grep -qvE '执行侧·CGM|裁决侧·GM|claude-opus|claude-sonnet|claude-fable|证据包构建|模型|^[[:space:]]*$'; then
      bad "**有被剔之行不属可剔二类 —— 证据实体内容一字不得剔**"
    else ok "全部被剔行皆属可剔二类"; fi
  else ok "零剔除（外发文本逐行覆盖证据包）"; fi
else bad "包或外发文本缺失，剔除申报无法机械求差"; fi
echo

echo "## (iii) 盲设计三项之在否（**本器只核有无被申报，不核其真伪**）"
for k in "同源同包" "互不见" "独立会话"; do
  if [ -f "$OUT" ] && grep -qF "$k" "$OUT"; then ok "「${k}」已于外发文本内申报"
  else bad "「${k}」未见于外发文本 —— 三项须逐项写死"; fi
done
echo

echo "## 🔴 本器**不核**之项（先列不覆盖处）"
echo
echo "| 不核之项 | 谁来核 |"
echo "|---|---|"
echo "| **引导语问得对不对**（实质设计） | **GM**——属 \`-09④\` (甲) 情形，须回 GM |"
echo "| **「独立会话」是否真独立** | **无人可机械核**；对话式席位系他报口径（\`-03③\`），本器只核其有无被申报 |"
echo "| **该批该不该发** | **GM／委托人**（判断类） |"
echo
if [ $PASS -ne 0 ]; then echo "**🟢 三项自核过 —— 得装载。**"; else echo "**🔴 未过 —— 不得装载。**"; fi
exit $((1-PASS))
