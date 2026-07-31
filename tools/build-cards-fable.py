#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SWEEP-01 · API-Fable 造卡席 runner（ADJ-0731-39③／-41④「核毕」后开跑）
🔒 N8：只从 $FABL_API_KEY 读，**永不打印 key 值**。
纪律：模板正文逐字不改；每标的一次独立调用（互不见）；产出落 cards-fable/ 并**扣住不呈**，
      候 GPT 席两卡齐备后同一 commit 呈 GM（-39③④）。
"""
import os, sys, json, urllib.request, re, pathlib

K = os.environ.get('FABL_API_KEY', '')
if not K:
    sys.exit('🔴 FABL_API_KEY 未设置——本席只报存在性，不打印值。')
BASE = os.environ.get('ANTHROPIC_BASE_URL', 'https://api.anthropic.com').rstrip('/')

TPL = pathlib.Path('docs/moat/sweep-01/card-builder-prompt-SEALED.md').read_text(encoding='utf-8')
m = re.search(r'## 模板正文[^\n]*\n', TPL)
if not m:
    sys.exit('🔴 未找到模板正文起点——不猜，停。')
BODY = TPL[m.end():].strip()   # 模板正文逐字，不改一字

TARGETS = [
    ('MSFT',   'docs/moat/sweep-01/evidence-MSFT-2026-07-30.md'),
    ('META',   'docs/moat/sweep-01/evidence-META-2026-07-30.md'),
    ('TMO',    'docs/moat/sweep-01/evidence-TMO-2026-07-31.md'),
    ('0700HK', 'docs/moat/sweep-01/evidence-0700HK-2026-07-31.md'),
    # ADJ-0731-56 扩充件（模板配对＝现役正本 4ac3eb65·同 TMO·非原文本·-56②）
    ('AMZN',   'docs/moat/sweep-01/evidence-AMZN-2026-07-31.md'),
]

# 可指定标的（ADJ-0731-46④ 只须重造 TMO 一卡·不重造其余三卡）
if len(sys.argv) > 1:
    want = set(sys.argv[1:])
    TARGETS = [t for t in TARGETS if t[0] in want]
    if not TARGETS: sys.exit(f'🔴 未匹配任何标的：{want}')

OUT = pathlib.Path('docs/moat/sweep-01/cards-fable')
OUT.mkdir(parents=True, exist_ok=True)

total_in = total_out = 0
for name, path in TARGETS:
    pkg = pathlib.Path(path).read_text(encoding='utf-8')
    prompt = f"{BODY}\n\n---\n\n## 证据包 · {name}\n\n{pkg}"
    req = urllib.request.Request(
        f'{BASE}/v1/messages',
        data=json.dumps({
            'model': 'claude-fable-5',
            'max_tokens': 16000,
            'messages': [{'role': 'user', 'content': prompt}],
        }).encode(),
        headers={'x-api-key': K, 'anthropic-version': '2023-06-01',
                 'content-type': 'application/json'})
    try:
        d = json.loads(urllib.request.urlopen(req, timeout=180).read())
    except Exception as e:
        print(f'🔴 {name} 调用失败：{type(e).__name__}——如实报，不以旧值或推断充替代')
        continue
    text = ''.join(c.get('text', '') for c in d.get('content', []))
    u = d.get('usage', {})
    total_in += u.get('input_tokens', 0); total_out += u.get('output_tokens', 0)
    hdr = (f"# SWEEP-01 护城河评级卡 · {name} · **API-Fable 造卡席**\n\n"
           f"> **席位**：API-Fable（`claude-fable-5`·经 `$FABL_API_KEY` 直调 `/v1/messages`）\n"
           f"> **证据包**：`{path}`\n"
           f"> **模板**：`card-builder-prompt-SEALED.md`（模板正文**逐字未改**）\n"
           f"> **零工具**：本次调用无任何工具、无检索、无文件访问——席位只见模板正文与本证据包\n"
           f"> **互不见**：本席未见 GPT 席之任何产出；本卡**扣住不呈**，候两卡齐备后同一 commit 呈 GM（ADJ-0731-39③④）\n"
           f"> **usage**：input {u.get('input_tokens')}／output {u.get('output_tokens')} tokens"
           f"｜**stop_reason**：`{d.get('stop_reason')}`"
           + ("　**🔴 本卡因触达 max_tokens 而截断·不得充作完整卡**" if d.get('stop_reason') == 'max_tokens'
              else "　（`end_turn`＝自然收尾·未截断）")
           + "\n\n---\n\n")
    (OUT / f'card-{name}-fable.md').write_text(hdr + text.strip() + '\n', encoding='utf-8')
    print(f'🟢 {name} 卡已落 cards-fable/card-{name}-fable.md（{len(text)} 字符）')

print(f'\n合计 tokens：input {total_in}／output {total_out}')
