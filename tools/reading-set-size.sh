#!/usr/bin/env bash
# 继任必读集总量扫描 —— ADJ-0731-50② 立｜「凡增必读，须报总量」
# 用于周对账新增之第九源；亦可随时手跑。**只出表不裁定。**
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
python3 - <<'PY'
import os,glob
MUST=[('宪法正本','docs/constitution.md'),
      ('继任章程','docs/succession/gm-succession.md'),
      ('最近交接书','adj-archive/ADJ-0731-49.md'),
      ('交接书回执','adj-archive/ADJ-0731-48-and-49-receipt.md'),
      ('gm-snapshot','docs/gm-snapshot.md'),
      ('裁决侧知识库','docs/adjudicator-knowledge.md'),
      ('热启动包','docs/gm-warmstart.md')]
print("# 继任必读集总量扫描（ADJ-0731-50② · 只出表不裁定）\n")
print("| 件 | 字节 | 备注 |"); print("|---|---:|---|")
tot=0
for n,p in MUST:
    b=os.path.getsize(p) if os.path.exists(p) else 0
    tot+=b
    print(f"| {n} | {b:,} | {'' if b else '🔴 不在库'} |")
# 🔴 修正（CGM 自捕·2026-07-31）：原 glob '[gc]m-*.md' **匹配不到 cgm-***
#    （'cgm' 之第二字为 g 非 m）→ **CGM 侧摘要被静默漏掉**。
#    此正系本席同日写入 signoff-verify.sh §0 之警告：**自写检查器最危险之失效是静默不覆盖**。
dg=sorted(glob.glob('docs/memory-digests/*.md'))
d=sum(os.path.getsize(x) for x in dg); tot+=d
print(f"| 记忆摘要（{len(dg)} 件·**线性增长项**） | {d:,} | 逐日原声件纯追加不可压缩（-34③）→ **本项系总量之主要增长源** |")
print(f"| **合计** | **{tot:,}** | — |\n")
print("**🔴 闸之条文（-50②）**：凡新增继任必读项，须同时 (i) 指明**从必读集移出何项**，或 (ii) 写明其**字节预算来源与新总量**。")
print("**违反之效果＝该新增项不入必读集（自动不生效，无须另裁）。**\n")
print("**⚠️ 本表只报总量，不判其是否过大**——阈值未立；**立阈值属判断类，须 ADJ**。")
print("**⚠️ 本数系动态**（记忆摘要每日增）——**引用须同书读取时点**（教训：CGM 曾以日期充时点，经 E9 就位声明查出）。")
PY
