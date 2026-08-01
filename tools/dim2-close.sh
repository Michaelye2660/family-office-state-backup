#!/usr/bin/env bash
# 🔴 治理时钟＝SGT
export TZ=Asia/Singapore
# ============================================================================
# 91 件维二结案器（**委托人直令 2026-08-01：「审查员复核后所有 cgm 代裁项目当结案处理」**）
#
# 🔴 本器所结者 ＝ **「91 件之维二审查」这道程序**。
#   **它不结那 19 项乙档缺项，也不结录尾十项须 GM／委托人者** ——
#   那些系**实体事项**，各挂其 CR 号，**不随本程序结案而销**。
#   **若不写死此别，日后读库者会把「91 件已结案」读成「那些问题都处理完了」。**
#
# 🔴 三条硬闸（**皆失败关闭，不得以「实质已办」绕过**）：
#   闸一 · 审查员复审报告不在 → 拒跑。令文系「审查员复核**后**」，无报告即时序未到。
#   闸二 · 可重跑而不重复追加（已含结案标记者跳过）。
#   闸三 · **跑毕须实测「未签收件数」与「NEAR 疑似件数」皆未变** ——
#          结案标记**绝不得触发签收谓词**。此非推理，系实测：
#          `ADJ-0731-04②` 已有实证——**「含关键词即判已签」曾结构性掩盖 112 件从未签收之回执**；
#          `_signoff_predicate` 病二亦系「一句声明『什么都没签』的话被判成已签」。
#          **本器若把 91 件染成已签，即以自己之手复现该事故。**
# ============================================================================
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
. tools/_repo-depth-guard.sh
if ! repo_depth_ok; then repo_depth_banner "维二结案器"; exit 3; fi

RECHECK="docs/internal-audit/2026-08-01-dim2-recheck.md"
if [ ! -s "$RECHECK" ]; then
  printf '🔴 闸一未过：审查员复审报告不在（%s）。\n' "$RECHECK"
  printf '   委托人令系「审查员复核**后**……当结案处理」——报告不在即时序未到，拒跑。\n'
  exit 3
fi

python3 - "$@" <<'PYEOF'
import io, os, re, subprocess, sys
sys.path.insert(0, 'tools')
from _signoff_predicate import is_signed, is_near_suspect

DRY = '--dry-run' in sys.argv
ROSTER = 'docs/internal-audit/2026-08-01-91-roster.txt'
roster = [x.strip() for x in io.open(ROSTER, encoding='utf-8') if x.strip()]
files = [f'adj-archive/{b}-receipt.md' for b in roster]

# 闸三之前测
before_uns = sum(1 for f in files if os.path.exists(f) and not is_signed(f))
before_nr = sum(1 for f in files if os.path.exists(f) and is_near_suspect(f))

# 判档（照追注一之修正读数·逐号点名，不靠加总）
YI = {'ADJ-0720-11', 'ADJ-0721-01', 'ADJ-0721-12', 'ADJ-0726-03',
      'ADJ-0728-01', 'ADJ-0728-02', 'ADJ-0728-03', 'ADJ-0728-04', 'ADJ-0728-05',
      'ADJ-0728-06', 'ADJ-0728-07', 'ADJ-0728-08', 'ADJ-0728-09', 'ADJ-0728-10',
      'ADJ-0728-11', 'ADJ-0728-12', 'ADJ-0728-13', 'ADJ-0728-14',
      'ADJ-0731-19-to-22'}
DING = {'ADJ-0721-08', 'E9-activation'}

MARK_KEY = '已结案 —— 维二代审（CGM）＋ 审查员复审'


def marker(base):
    d = '乙 缺项' if base in YI else ('丁 结构不可自审' if base in DING else '甲 通过')
    L = ['', '---', '',
         f'{MARK_KEY}｜委托人 2026-08-01 令「审查员复核后所有 cgm 代裁项目当结案处理」',
         '',
         f'- **判档**：{d}｜**判决录**：`docs/internal-audit/2026-08-01-dim2-verdicts.md`'
         '（**并见其「追注一」之修正读数**）',
         '- **复审**：`docs/internal-audit/2026-08-01-dim2-recheck.md`（审查员亲书·CGM 未改写）',
         '- 🔴 **本件未经 GM 之 G1 签收** —— **「已结案」不等于「已被独立审查过」**。'
         '本批之维二由**被审方自办**，审查员复审系其唯一外部环节。',
         '- 🔴 **本件如有乙档缺项，其实体事项另挂 `CR` 号，不随本结案销项** ——'
         '**结的是审查程序，不是那些问题。**',
         '- **档位**：`claude-opus-5`（**低于库面登记之现役最高档 `claude-fable-5`**）·'
         '判断类·**临时生效·候最高档复裁**（`ADJ-0725-06①`）。', '']
    return '\n'.join(L)


done = skipped = missing = 0
for b, f in zip(roster, files):
    if not os.path.exists(f):
        missing += 1
        print(f'  ⚠️ 件缺：{b}')
        continue
    t = io.open(f, encoding='utf-8', errors='replace').read()
    if MARK_KEY in t:                       # 闸二
        skipped += 1
        continue
    if not DRY:
        io.open(f, 'a', encoding='utf-8').write(marker(b))
    done += 1

print(f'→ {"【试跑·未写盘】" if DRY else "已落"} 结案标记 {done} 件｜已有而跳过 {skipped} 件｜件缺 {missing} 件')

# 闸三之后测
after_uns = sum(1 for f in files if os.path.exists(f) and not is_signed(f))
after_nr = sum(1 for f in files if os.path.exists(f) and is_near_suspect(f))
print(f'   闸三·未签收件数 {before_uns} → {after_uns}｜NEAR 疑似 {before_nr} → {after_nr}')
if after_uns != before_uns or after_nr != before_nr:
    print('🔴 **闸三未过：结案标记改动了签收读数** —— 即以本器之手复现 `ADJ-0731-04②` 之事故形态。')
    print('   **须立即 `git checkout -- adj-archive/` 回滚，并改写标记措辞后重跑。**')
    sys.exit(4)
print('   ✅ 闸三过：签收读数零变动 —— **结案未被误读为签收**。')
PYEOF
