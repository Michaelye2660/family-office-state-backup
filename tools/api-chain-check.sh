#!/usr/bin/env bash
# API 链条三项检查 · 一条命令跑完（〔M〕394⑦/395/411/412/414）
#
# 用法：bash tools/api-chain-check.sh
# 必须在【新会话】中跑——环境变量于容器启动时注入，旧会话不热加载。
#
# 🔒 N8 秘密纪律：本脚本【只报存在性与值长】，永不打印任何秘密值。
#    请勿修改为打印值；亦不得将输出中的任何值粘入对话或仓库。

set -uo pipefail
echo "══════ API 链条检查 · $(date -u '+%Y-%m-%d %H:%M:%S') UTC ══════"
echo "容器启动: $(date -u -d "-$(cut -d. -f1 /proc/uptime) seconds" '+%Y-%m-%d %H:%M:%S') UTC"
echo "  └─ 若变量添加时点晚于此，本会话看不到，须再开新会话"
echo

echo "── (i) 凭据存在性（只报有无与长度）──"
KEYVAR=""
for v in FABL_API_KEY FABLE_API_KEY ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN CLAUDE_API_KEY; do
  val="${!v:-}"
  if [ -n "$val" ]; then
    printf '  %-22s 【已设置·值长 %s】\n' "$v" "${#val}"
    [ -z "$KEYVAR" ] && KEYVAR="$v"
  else
    printf '  %-22s 未定义\n' "$v"
  fi
done
if [ -z "$KEYVAR" ]; then
  echo "  🔴 无任何可用凭据变量"
else
  echo "  🟢 将以 \$$KEYVAR 作 x-api-key 试调"
fi
echo

echo "── (ii) 网络可达 ──"
curl -s -o /dev/null -w "  api.anthropic.com/v1/models → HTTP %{http_code}·%{time_total}s\n" \
  --max-time 20 https://api.anthropic.com/v1/models
echo

echo "── (iii) 单卡往返（model=claude-fable-5·max_tokens=16）──"
if [ -z "$KEYVAR" ]; then
  echo "  ⏸ 跳过——(i) 无凭据。失败点仍在认证层，无须再试。"
else
  RESP=$(mktemp)
  CODE=$(curl -s -o "$RESP" -w "%{http_code}" --max-time 30 \
    -X POST https://api.anthropic.com/v1/messages \
    -H "x-api-key: ${!KEYVAR}" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d '{"model":"claude-fable-5","max_tokens":16,"messages":[{"role":"user","content":"ping"}]}')
  echo "  HTTP $CODE"
  python3 - "$RESP" <<'PY'
import json,sys
try:
    d=json.load(open(sys.argv[1]))
except Exception:
    print("  返回非 JSON"); sys.exit()
if d.get("type")=="error":
    e=d.get("error",{})
    print(f"  🔴 {e.get('type')}: {str(e.get('message'))[:160]}")
else:
    u=d.get("usage",{})
    print(f"  🟢 往返成功 · model={d.get('model')} · in={u.get('input_tokens')} out={u.get('output_tokens')} tok")
    print("     → API 链条已通。请将实测 tok 与费用登记入回执（支出闸全案 $50）。")
PY
  rm -f "$RESP"
fi
echo
echo "══════ 结果请落〔M〕并更新 docs/moat/sweep-01/sweep-01-plan-and-api-test.md ══════"
