#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SWEEP-01 · API-Fable 造卡席 runner（ADJ-0731-39③／-41④「核毕」后开跑）
🔒 N8：只从 $FABL_API_KEY 读，**永不打印 key 值**。
纪律：模板正文逐字不改；每标的一次独立调用（互不见）；产出落 cards-fable/ 并**扣住不呈**，
      候 GPT 席两卡齐备后同一 commit 呈 GM（-39③④）。
"""
import os, sys, json, urllib.request, re, pathlib, hashlib

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
#
# 🔴 扩用（ADJ-0801-09② 步2·SWEEP·SPGI）：`--target NAME=PATH --out DIR`
#   **不另造第二个 runner** —— 本仓已实证「**一条判据被复制第二份，它就开始各自演化**」
#   （`_latest-handover.py` 三处各坏各的／签收判据两器对不上 80 vs 79）。
#   模板取用、零工具、每标的一次独立调用、stop_reason 与 usage 之机械凭据，**一律共用本器同一段代码**。
OUT = pathlib.Path('docs/moat/sweep-01/cards-fable')
BATCH = 'SWEEP-01'
argv = sys.argv[1:]
if '--target' in argv:
    i = argv.index('--target')
    spec = argv[i+1]
    if '=' not in spec: sys.exit('🔴 --target 须作 NAME=PATH')
    n, pth = spec.split('=', 1)
    if not pathlib.Path(pth).exists(): sys.exit(f'🔴 证据包不存在：{pth}——不猜，停。')
    TARGETS = [(n, pth)]
    argv = argv[:i] + argv[i+2:]
if '--out' in argv:
    i = argv.index('--out')
    OUT = pathlib.Path(argv[i+1]); argv = argv[:i] + argv[i+2:]
if '--batch' in argv:
    i = argv.index('--batch')
    BATCH = argv[i+1]; argv = argv[:i] + argv[i+2:]
if argv:
    want = set(argv)
    TARGETS = [t for t in TARGETS if t[0] in want]
    if not TARGETS: sys.exit(f'🔴 未匹配任何标的：{want}')

OUT.mkdir(parents=True, exist_ok=True)

# ── 🔴 外发剔除（ADJ-0801-03① · CGM-G5 补 · 2026-08-01 · SGT）─────────────
#   **为哪次事故而立**：CGM-G5 于起跑前机械比对「Fable 席实收 prompt」vs「GPT 席实收 relay brief」，
#   得两席**不逐字恒等**；其中一处系实质——**证据包原文末行之我方席位署名兼模型标识行**
#   （`——证据包构建：[执行侧·CGM]（claude-opus-5…）`）**在外发正本内已依 -03① 剔除，
#   而本 runner 读的是证据包原文，故该行会随 payload 送进 Fable 席**。
#   -03① 之理由逐字：「把**我方用什么模型**外发给持权外部席，本身即是喂给对方一条破盲线索」——
#   **本路径与外发路径同类，只是入口不同**；且它造成**两席输入不对称**，
#   而外发正本包头正自陈「两席收到同一份内容」。**一个只在一条路上执行的剔除规则，等于没有规则。**
#
#   **可剔判据预先写死（-03①：仅此二类·证据实体内容一字不得剔）**：
#     ① 我方席位署名行：含 `[执行侧·CGM]` 或 `[裁决侧·GM`
#     ② 模型标识行：含 `claude-opus` / `claude-fable` / `claude-sonnet` / `claude-haiku` / `gpt-`
#   **剔除之申报落回执与封存清单，不落 payload**（设盲通则 ADJ-0731-46②：
#   **验证语句必然指涉被验证之物；在盲性场景下，指涉即泄漏**）——故本器把被剔行印到 stdout，
#   **不在 payload 内留任何「已剔除」字样**。
#
#   **它不核什么**：只按行匹配二类标记；**分不出「署名行」与「正文里恰好提到某模型名」**
#   ——故每一行被剔者一律逐字印出，由人在回执内逐行判，**不以计数充审计**。
STRIP_PAT = re.compile(r'\[执行侧·CGM\]|\[裁决侧·GM|claude-opus|claude-fable|claude-sonnet|claude-haiku|gpt-')

def strip_outbound(text):
    keep, cut = [], []
    for ln in text.split('\n'):
        (cut if STRIP_PAT.search(ln) else keep).append(ln)
    return '\n'.join(keep).rstrip() + '\n', cut

total_in = total_out = 0
for name, path in TARGETS:
    raw = pathlib.Path(path).read_text(encoding='utf-8')
    pkg, cut = strip_outbound(raw)
    print(f'── {name} · 外发剔除申报（ADJ-0801-03①·可剔二类·逐行·证据实体剔除须为 0）')
    if cut:
        for c in cut:
            print(f'   剔｜{c}')
    else:
        print('   （无命中）')
    prompt = f"{BODY}\n\n---\n\n## 证据包 · {name}\n\n{pkg}"
    print(f'   payload sha1 = {hashlib.sha1(prompt.encode()).hexdigest()}｜{len(prompt.encode())} B')
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
    hdr = (f"# {BATCH} 护城河评级卡 · {name} · **API-Fable 造卡席**\n\n"
           f"> **席位**：API-Fable（`claude-fable-5`·经 `$FABL_API_KEY` 直调 `/v1/messages`）\n"
           f"> **证据包**：`{path}`（**外发剔除后**·`ADJ-0801-03①` 可剔二类·剔除申报见回执）\n"
           f"> **payload sha1**：`{hashlib.sha1(prompt.encode()).hexdigest()}`（**席位实收之逐字凭据**）\n"
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
