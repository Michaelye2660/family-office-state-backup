#!/usr/bin/env bash
# FMP 取数 · Bash/curl 直调 REST（绕过 MCP 连接器授权）
#
# 立项缘起（2026-07-31·委托人验证）：`.claude/settings.json` 已白名单化
#   `mcp__FMP__*` 通配 + 30 个工具全名，**定时会话仍弹授权窗** →
#   permissions.allow 管工具调用，管不了 MCP 连接器本身之授权 → 仓库侧无解。
# 本脚本走 Bash curl 直调 REST：Bash 权限已在白名单、不经 MCP、无弹窗。
#
# 🔒 N8：只从 $FMP_API_KEY 读，**永不打印 key 值**；勿改为回显。
#
# 用法：
#   bash tools/fmp-fetch.sh check                 # 凭据与连通性自检
#   bash tools/fmp-fetch.sh quote MSFT META       # 报价（可多标的）
#   bash tools/fmp-fetch.sh etf SMH               # ETF 信息（含 sectorsList 穿透用）
#   bash tools/fmp-fetch.sh eod IWDA.L 5          # 历史收盘（末 N 条）

set -uo pipefail
BASE="https://financialmodelingprep.com/stable"
K="${FMP_API_KEY:-}"

need_key() {
  if [ -z "$K" ]; then
    echo "🔴 \$FMP_API_KEY 未设置——本环境无 FMP 凭据。"
    echo "   委托人侧动作：claude.ai/code → Settings → Environments → personal 设 FMP_API_KEY"
    echo "   （N8：值永不入对话、永不入仓库；设后须新开会话方生效）"
    exit 1
  fi
}

case "${1:-check}" in
  check)
    echo "── (i) 凭据存在性（只报有无与长度）──"
    if [ -n "$K" ]; then echo "   FMP_API_KEY 【已设置·值长 ${#K}】"; else echo "   FMP_API_KEY 未定义"; fi
    echo "── (ii) 网络可达（无凭据亦可测）──"
    curl -s -o /dev/null -w "   %{http_code}·%{time_total}s（401＝可达·唯缺凭据）\n" --max-time 20 "$BASE/quote?symbol=MSFT"
    [ -z "$K" ] && { echo "── (iii) 跳过：无凭据 ──"; exit 0; }
    echo "── (iii) 带凭据往返 ──"
    C=$(curl -s -o /tmp/_fmp.json -w "%{http_code}" --max-time 25 "$BASE/quote?symbol=MSFT&apikey=$K")
    echo "   HTTP $C"
    python3 -c "
import json,sys
try: d=json.load(open('/tmp/_fmp.json'))
except Exception: print('   返回非 JSON'); sys.exit()
if isinstance(d,dict) and d.get('Error Message'): print('   🔴',str(d['Error Message'])[:120])
elif d: print(f\"   🟢 通 · {d[0].get('symbol')} \${d[0].get('price')} · as-of ts={d[0].get('timestamp')}\")
else: print('   空返回')
"; rm -f /tmp/_fmp.json ;;
  quote)
    need_key; shift
    for s in "$@"; do
      curl -s --max-time 25 "$BASE/quote?symbol=$s&apikey=$K" | python3 -c "
import json,sys
d=json.load(sys.stdin)
if isinstance(d,dict) and d.get('Error Message'): print(f'  🔴 {\"$s\"}: '+str(d['Error Message'])[:100])
elif d:
    q=d[0]; print(f\"  {q['symbol']:8} \${q.get('price')}  {q.get('changePercentage',0):+.2f}%  vol={q.get('volume')}  ts={q.get('timestamp')}\")
else: print(f'  ⚠️ {\"$s\"}: 空返回（非美标的？照数据链走第②层网页）')
"
    done ;;
  etf)
    need_key; shift
    curl -s --max-time 25 "$BASE/etf/info?symbol=$1&apikey=$K" | python3 -m json.tool 2>/dev/null | head -40 ;;
  eod)
    need_key; shift; N="${2:-5}"
    curl -s --max-time 25 "$BASE/historical-price-eod/light?symbol=$1&apikey=$K" | python3 -c "
import json,sys
d=json.load(sys.stdin)
rows=d if isinstance(d,list) else d.get('historical',[])
for r in rows[:$N]: print(f\"  {r.get('date')}  {r.get('price') or r.get('close')}\")
" ;;
  *) echo "用法: check | quote SYM... | etf SYM | eod SYM [N]"; exit 2 ;;
esac
