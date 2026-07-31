#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""外发纪律机械扫描（ADJ-0731-41③ 放行前置闸·ADJ-0730-11⑤ 外发纪律）

扫描对象＝SWEEP-01 四份证据包。三类命中数须为零：
  (a) 我方持仓金额与仓位比例字样
  (b) 我方仓位与持股数
  (c) 我方既有 MDG 评级与结论

🔴 口径申报（写在这里，免得后人以为「零」是随手报的）：
  外发纪律所禁者＝**我方之**持仓金额／仓位比例／既有结论与评级，
  **非标的公司自身之公开披露财务数字**（收入、利润率、资本开支等系证据包之正当内容）。
  故本脚本**不扫一般数字**，只扫**能指向我方账本之标记词与我方特有术语**；
  并**逐条打印命中行**供 GM 复核——**不以「零」自证，只以「所扫范围＋逐行输出」自证**。
"""
import re, sys, glob

PKGS = sorted(glob.glob('docs/moat/sweep-01/evidence-*.md'))

# (a) 我方账本标记词（公司自身财务数字不含这些词）
A_TOKENS = ['持仓金额', '仓位比例', '占 NAV', '占NAV', '全口径NAV', '全口径 NAV',
            '台账', '口袋', '核心层', '万美元', '成本额口径', '本户', '本组合',
            '红线', '满配', '权重上限', '〔L-1', '〔A〕', '〔D〕', '〔H-0〕']
# (b) 我方持股数与份额（我方已入账之实际股数·逐个钉死，避免用泛化「股」误伤公司披露）
B_SHARES = ['2,263', '5,085', '3,527', '3,257', '34,667', '1,753', '4,347',
            '2,431', '2,133', '1,394', '7,100', '6,519', '1,370,000', '250,000',
            '877,000', '1,032,500', '12,400', '592.6']
B_TOKENS = ['持股数', '我方持有', '本户持有', '份额', '建仓', '加仓', '减仓']
# (c) 我方既有评级与结论术语
C_RATING = re.compile(r'MDG-[1-5U]')
C_TOKENS = ['错杀', '錯殺', '門A', '門B', '门A', '门B', '亮灯', '猎场', '价值仓',
            '安全垫', '净室', '熔断指纹', '深沟', '磐石', '浅沟', '沙堡', '有沟',
            '三色', 'P(错杀)', '失效日', '本席判', '我方评级', '既有评级']

def scan(path):
    hits = {'a': [], 'b': [], 'c': []}
    for i, line in enumerate(open(path, encoding='utf-8'), 1):
        for t in A_TOKENS:
            if t in line: hits['a'].append((i, t, line.strip()[:150]))
        for t in B_SHARES + B_TOKENS:
            if t in line: hits['b'].append((i, t, line.strip()[:150]))
        for m in C_RATING.finditer(line):
            hits['c'].append((i, m.group(0), line.strip()[:150]))
        for t in C_TOKENS:
            if t in line: hits['c'].append((i, t, line.strip()[:150]))
    return hits

print('# 外发纪律机械扫描 · ADJ-0731-41③ 放行前置闸\n')
print(f'**扫描范围**：`docs/moat/sweep-01/evidence-*.md` —— **{len(PKGS)} 份**\n')
for p in PKGS: print(f'- `{p}`')
print('\n**扫描口径**：只扫**能指向我方账本之标记词与我方特有术语**；'
      '**标的公司自身之公开披露财务数字不在扫描之列**（系证据包之正当内容）。'
      '**逐条打印命中行供 GM 复核——不以「零」自证。**\n')

total = {'a': 0, 'b': 0, 'c': 0}
detail = []
for p in PKGS:
    h = scan(p)
    for k in total: total[k] += len(h[k])
    detail.append((p, h))

print('| 证据包 | (a) 持仓金额／仓位比例 | (b) 仓位与持股数 | (c) 我方既有 MDG 评级与结论 |')
print('|---|---:|---:|---:|')
for p, h in detail:
    print(f'| `{p.split("/")[-1]}` | {len(h["a"])} | {len(h["b"])} | {len(h["c"])} |')
print(f'| **合计** | **{total["a"]}** | **{total["b"]}** | **{total["c"]}** |')

print('\n## 逐条命中明细（**非零者全列·零者明书零**）\n')
any_hit = False
for p, h in detail:
    for k, name in [('a', '(a) 持仓金额／仓位比例'), ('b', '(b) 仓位与持股数'),
                    ('c', '(c) 我方既有 MDG 评级与结论')]:
        if h[k]:
            any_hit = True
            print(f'### `{p.split("/")[-1]}` · {name} —— {len(h[k])} 条\n')
            for ln, tok, txt in h[k]:
                print(f'- **L{ln}**｜命中词 `{tok}`｜`{txt}`')
            print()
if not any_hit:
    print('**三类于四份证据包内皆零命中。**\n')

print('\n## 🔴 TMO 包专项确认（ADJ-0730-14② 复现要件·-41③ 另令）\n')
tmo = [p for p in PKGS if 'TMO' in p]
if not tmo:
    print('**⚠️ 未找到 TMO 包——本项无法确认。**')
else:
    t = tmo[0]
    txt = open(t, encoding='utf-8').read()
    forbidden = {
        '既有档位 MDG-4 之陈述': re.findall(r'MDG-4', txt),
        '主辅机制标签（T2 嵌入锁定／T3 规模成本）': re.findall(r'T2\s*嵌入锁定|T3\s*规模成本|嵌入锁定|规模成本', txt),
        '既有置信度（0.73／压3/4边界）': re.findall(r'0\.73|压3/4|压 3/4', txt),
        '既有三色判': re.findall(r'三色', txt),
        '既有失效日 2027-07-15': re.findall(r'2027-07-15', txt),
        '既有三概率 P(错杀)/P(失守)/P(公允)': re.findall(r'P\(错杀\)|P\(失守\)|P\(公允\)|0\.42|0\.25|0\.33', txt),
    }
    print('| 应剔除项 | 命中数 | 判 |')
    print('|---|---:|---|')
    ok = True
    for k, v in forbidden.items():
        if v: ok = False
        print(f'| {k} | {len(v)} | {"🔴 仍在" if v else "🟢 已剔除"} |')
    print(f'\n**结论：{"🟢 既有 MDG-4 及其理由已剔除——复现要件成立" if ok else "🔴 仍有残留·须先清除方得投放"}**')
    mdg = re.findall(r'.*MDG.*', txt)
    print(f'\n**并附：TMO 包内 `MDG` 字样共 {len(mdg)} 处·逐条列出供 GM 判其是否属「我方评级」**\n')
    for m in mdg:
        print(f'- `{m.strip()[:180]}`')

print('\n---')
print(f'\n**总判：三类合计 {sum(total.values())} 条命中。**'
      f'{" **三类皆零·符合 -41③ 之「须为零」。**" if sum(total.values()) == 0 else " **非零——逐条已列，性质属 GM 判。**"}')
