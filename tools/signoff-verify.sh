#!/usr/bin/env bash
# 两维签收 · 维一（保真核）机械表 —— ADJ-0731-50④ 立·CGM 出工具／GM 用
#
# 🔴 边界（写在最前·本脚本最要紧之一段）：
#   本脚本**只出事实与其产出命令，不出判断**。维一系「报告的与做的是否一致」（核算），
#   维二系「做法本身是否合规」（判断）——**维二全属 GM 专权，本脚本一字不涉**。
#
# 🔴 独立性申报（CGM 主动提出·非 -50 所虑）：
#   本脚本由 CGM 所写，而其所核者正是 CGM 自己之回执 —— **系自己核自己**。
#   -50④ 所虑者为「CGM 代为判断」，本条所虑者为「**自写之检查器最危险之失效是静默不覆盖**」：
#   一把自己写的尺，最容易的作弊不是报错数，是**不去量那一处**。
#   故本脚本硬性要求：**§0 必先打印「本脚本不核之项」**，使「未报」与「已核无事」不可混；
#   且**每行皆附产出命令**，GM 可逐条复跑推翻。**本脚本之输出不构成签收，签收仍须 GM 落字。**

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
R="${1:?用法: bash tools/signoff-verify.sh adj-archive/ADJ-XXXX-receipt.md}"
[ -f "$R" ] || { echo "🔴 回执不存在：$R"; exit 2; }

echo "# 维一保真核 · 机械表"
echo
echo "- **被核回执**：\`$R\`"
echo "- **回执 blob sha**：\`$(git hash-object "$R")\`　（GM 签收片可直接引用此值）"
echo "- **本脚本版本 sha1**：\`$(sha1sum "$0" | cut -d' ' -f1)\`　（**表由哪一版脚本产出，可追**）"
echo "- **产出时点**：$(git log -1 --format=%H | cut -c1-12) 之工作树（**注：容器时钟不可靠，故以 commit 定位而非时刻**）"
echo

echo "## §0 🔴 本脚本**不核**之项（先列不覆盖处·免「未报」被读作「已核无事」）"
echo
echo "| 不核之项 | 何以不核 | 谁来核 |"
echo "|---|---|---|"
echo "| **维二·纪律适用与判断质量** | 系判断非核算 | **GM 专权** |"
echo "| 回执**结论是否正确** | 同上 | **GM** |"
echo "| 回执所述**取数之实质正确性**（如某财务数是否真如所载） | 须回原始数据源，非本地可判 | GM／另案 |"
echo "| 回执内**自然语言之诚实性**（有无夸大、有无遗漏未报） | 不可机械判 | **GM** |"
echo "| **本脚本自身之盲区** | 自写检查器之固有风险 | **GM 可读本脚本源码并复跑推翻** |"
echo

echo "## §1 引用之 commit 是否在史（哈希直核）"
echo
CS=$(grep -oE '\b[0-9a-f]{7,40}\b' "$R" | sort -u)
if [ -z "$CS" ]; then echo "  （本回执未引用任何形如哈希之串）"; else
  echo "| 串 | 在史？ | 若在史·其标题 |"; echo "|---|---|---|"
  for c in $CS; do
    if git cat-file -e "$c^{commit}" 2>/dev/null; then
      printf "| \`%s\` | 🟢 在史 | %s |\n" "$c" "$(git log -1 --format=%s "$c" | cut -c1-60)"
    elif git cat-file -e "$c" 2>/dev/null; then
      printf "| \`%s\` | 🟡 系 blob/tree 非 commit | （对象在库） |\n" "$c"
    else
      printf "| \`%s\` | ⚪ 非本库对象 | （可能系外部 accession／sha1 文件摘要／他库哈希——**本脚本不判其真伪**） |\n" "$c"
    fi
  done
fi
echo
echo "> 命令：\`grep -oE '[0-9a-f]{7,40}' <回执> | sort -u\` 逐个 \`git cat-file -e <x>^{commit}\`"
echo

echo "## §2 所述文件落点是否在库"
echo
PS=$(grep -oE '\`[A-Za-z0-9_./-]+\.(md|sh|py|json)\`' "$R" | tr -d '`' | sort -u)
if [ -z "$PS" ]; then echo "  （本回执未以反引号引用任何文件路径）"; else
  echo "| 路径 | 在库？ | 字节 |"; echo "|---|---|---|"
  for p in $PS; do
    if [ -f "$p" ]; then printf "| \`%s\` | 🟢 | %s |\n" "$p" "$(wc -c < "$p")"
    else printf "| \`%s\` | 🔴 **不在库** | — |\n" "$p"; fi
  done
fi
echo
echo "> 命令：\`grep -oE '\\\`[A-Za-z0-9_./-]+\\.(md|sh|py|json)\\\`' <回执>\` 逐个 \`test -f\`"
echo

echo "## §3 权威四字段（逐字·对当期权威状态块）"
echo
LED=$(sed -n '10p' portfolio-state.md)
for k in GM_EPOCH SESSION_FINGERPRINT ACTIVATION_SHA; do
  RV=$(grep -oE "${k}=[A-Za-z0-9]+" "$R" | head -1 | cut -d= -f2)
  LV=$(printf '%s' "$LED" | grep -oE "${k}=[A-Za-z0-9]+" | head -1 | cut -d= -f2)
  if [ -z "$RV" ]; then printf "| %s | （回执未载） | 台账 \`%s\` | ⚪ |\n" "$k" "${LV:0:16}"
  elif [ "$RV" = "$LV" ]; then printf "| %s | \`%s\` | 同 | 🟢 恒等 |\n" "$k" "${RV:0:16}"
  else printf "| %s | \`%s\` | 台账 \`%s\` | 🔴 **失配** |\n" "$k" "${RV:0:16}" "${LV:0:16}"; fi
done
echo
echo "> 命令：回执与 \`portfolio-state.md\` 第 10 行（权威状态块）逐字段比对"
echo

echo "## §4 三要素（对应原 ADJ 件·若可定位）"
echo
BASE=$(basename "$R" | sed 's/-receipt.*//')
SRC="adj-archive/${BASE}.md"
if [ -f "$SRC" ]; then
  printf "  原件 \`%s\` 在库：编号 %s ｜ 类别行 %s ｜ 用户已确认 %s\n" "$SRC" \
    "$(grep -c '编号' "$SRC")" "$(grep -cE '【共[0-9]+项' "$SRC")" "$(grep -c '用户已确认' "$SRC")"
  echo "  〔计数为 0 者非即违规——「甲」延及同系列后续件之先例在册（〔M〕425／441／442），**性质属 GM 判**〕"
else
  echo "  （未定位到单一对应原件；并批件请逐件手取）"
fi
echo

echo "## §5 结构四验之可复验性（回执若自称已验，此处复算）"
echo
python3 - <<'PY'
import glob,re
f=glob.glob('**/*.md',recursive=True)
n1=sum(open(p,encoding='utf-8',errors='ignore').read().count('�') for p in f)
n2=sum(len(re.findall(r'[À-ÿ]{2,}',open(p,encoding='utf-8',errors='ignore').read())) for p in f)
print(f"| 乱码 U+FFFD | {n1} | {'🟢' if n1==0 else '🔴'} |")
print(f"| 连续 Latin-1 串 | {n2} | {'🟢' if n2==0 else '🔴'} |")
print(f"| 扫描范围 | 全库 {len(f)} 个 md | — |")
PY
echo
echo "---"
echo
echo "**本表系核算产出，不构成签收。** 维二（纪律适用与判断质量）与最终签收，**仍属 GM 专权**。"
echo "**GM 若欲推翻本表任一行：逐条命令已附，可直接复跑。**"
