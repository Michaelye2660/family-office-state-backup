#!/usr/bin/env bash
# 继任必读集总量扫描 —— ADJ-0731-50② 立｜「凡增必读，须报总量」
# 用于周对账新增之第九源；亦可随时手跑。**只出表不裁定。**
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
python3 - <<'PY'
import os,glob,sys
sys.path.insert(0,'tools')
from _latest_handover import latest_handover, latest_skeleton
_HB = latest_handover() or ('（未找到交接书）','','')
_SK = latest_skeleton()   # 🔴 数值序·非字典序（见 _latest-handover.py 之注）

# 🔴 载入集已由 ADJ-0731-58② 重定义（2026-07-31·委托人直令即时生效）——**仅此六项**。
#    移出者（改按需回读）：memory-digests 全部逐日件与月档／裁决侧知识库全文／台账全文／cc-knowledge。
#    **本表系减法之实测载体**；照乙条（-50②）「凡增必读须报总量」，减亦须报。
MUST=[('宪法正本','docs/constitution.md'),
      ('CLAUDE.md【取数数据链】','CLAUDE.md'),
      ('继任章程','docs/succession/gm-succession.md'),
      ('最新交接书', _HB[0]),
      ('交接书回执', _HB[2] or '（回执尚不存在）'),
      ('热启动包（精简后）','docs/gm-warmstart.md'),
      ('下一代空骨架', _SK or '（尚未备）')]
# ✅ 归属已由 ADJ-0731-61③ 补裁：**属「按需回读」，不入直读载入集**；同时入索引。
#    **回读触发条件（明书）**：凡将作出任何涉持仓数量、成本、红线读数之断言前，必先直读本档（ADJ-0721-12 持仓断言钢印现役）。
#    〔沿革：本器原因其于 -58② 两清单皆未现而两总量并报；-61③ 认其系起草遗漏并补裁，两总量口径自此收为一个。〕
SNAP=('gm-snapshot〔**已裁：按需回读·-61③**〕','docs/gm-snapshot.md')
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
# 🔴 记忆摘要**已由 ADJ-0731-58② 移出载入集**（改按需回读·走 INDEX.md）——
#    原实现于此处把其合计并入 tot；若不删，本表会**既把它算进合计、又在下方列为「已移出」**，
#    **同一张表里两句互相矛盾的话，读者只会看见其中一句。**〔CGM 自捕·-58 收件当轮〕
print(f"| **合计（载入六项）** | **{tot:,}** | **不含已移出者·见下** |\n")

snap_b = os.path.getsize(SNAP[1]) if os.path.exists(SNAP[1]) else 0
print(f"| {SNAP[0]} | {snap_b:,} | **不计入合计**——**已裁为按需回读**（触发＝作持仓／成本／红线断言前必先直读） |")
print()
print(f"**载入集总量＝{tot:,} B**（单一口径·**-61③ 补裁后两总量并报之权宜已撤**）。`gm-snapshot` {snap_b:,} B 归「按需回读」，见下。")
print()
print("## 🔴 已移出载入集者（ADJ-0731-58② · **本表系减法之实测载体**）\n")
print("| 移出项 | 字节 | 改走 |")
print("|---|---:|---|")
_dg = sorted(glob.glob('docs/memory-digests/*.md'))
_dgb = sum(os.path.getsize(x) for x in _dg if os.path.basename(x)!='INDEX.md')
_ix = 'docs/memory-digests/INDEX.md'
print(f"| `docs/memory-digests/` 逐日件与月档（{len([x for x in _dg if os.path.basename(x)!='INDEX.md'])} 件） | {_dgb:,} | `INDEX.md`（{os.path.getsize(_ix):,} B·**在载入集外·按需查**） |")
for nm,pp in [('裁决侧知识库全文','docs/adjudicator-knowledge.md'),('cc-knowledge','docs/cc-knowledge.md'),('台账全文','portfolio-state.md')]:
    if os.path.exists(pp): print(f"| `{pp}` | {os.path.getsize(pp):,} | 按需回读（分节索引／有界三节） |")
print()
print(f"**移出合计（不含台账）＝{_dgb + os.path.getsize('docs/adjudicator-knowledge.md') + os.path.getsize('docs/cc-knowledge.md'):,} B**；"
      f"**含台账则另加 {os.path.getsize('portfolio-state.md'):,} B**。")
print()
print("**🔴 闸之条文（-50②）**：凡新增继任必读项，须同时 (i) 指明**从必读集移出何项**，或 (ii) 写明其**字节预算来源与新总量**。")
print("**违反之效果＝该新增项不入必读集（自动不生效，无须另裁）。**\n")
print("**⚠️ 本表只报总量，不判其是否过大**——阈值未立；**立阈值属判断类，须 ADJ**。")
print("**⚠️ 本数系动态**（记忆摘要每日增）——**引用须同书读取时点**（教训：CGM 曾以日期充时点，经 E9 就位声明查出）。")
PY
