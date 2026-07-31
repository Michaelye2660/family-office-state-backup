#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""**唯一**之「本届交接书」判据 —— 三处共用，不得各写一份。

输出一行：`<交接书路径>\t<E<n>→E<m>>\t<回执路径或空>`

🔴 立此单点之由（ADJ-0731-53 收件时·CGM 自捕留痕）：
  同一判据本席今日在三处各写了一份，**三份各坏一种**：
    ① `gen-warmstart.sh`      —— 把 `ADJ-0731-49` **硬写死**，块7 之「前任」永远停在 GM-8（GM-10 首次外部实测查出）；
    ② `reading-set-size.sh`   —— 同样把 `-49` 与其回执**硬写死**，必读集分母之「最近交接书」永远停在 -49；
    ③ `warmstart-ratio.sh`    —— 判据抄对了、**`sort()` 漏了**，`c[-1]` 遂取 glob 顺序之末件（E7→E8），
                                 **而输出仍是一份真交接书、一份真回执、一个像样的比值** —— 三个数全错而表面无异常。
  → **判据复制三份 ＝ 失效面复制三份**；③ 尤须记：**抄对了主体、漏了一个 `sort()`，输出照样自洽**。
  **故本判据自此只此一份；任何新用处一律 import 或调用本档，不得再抄。**

判据（机械·不可含糊）：
  `adj-archive` ∪ `adj-inbox` 内**首行含「交接书」且形如 `E<n>→E<m>`** 之件（**排除文件名含 receipt 者**——
  回执之首行亦含「交接书」三字），**按 (MMDD, NN) 数值序取最大**（非字串序、非 glob 序）。
"""
import glob
import os
import re
import sys


def latest_handover():
    cands = []
    for f in glob.glob('adj-archive/ADJ-*.md') + glob.glob('adj-inbox/ADJ-*.md'):
        if 'receipt' in os.path.basename(f):
            continue
        with open(f, encoding='utf-8') as fh:
            head = fh.readline()
        if '交接书' not in head:
            continue
        lab = re.search(r'E\d+\s*(?:→|->)\s*E\d+', head.replace('*', ''))
        num = re.search(r'ADJ-(\d{4})-(\d+)', f)
        if lab and num:
            cands.append(((int(num.group(1)), int(num.group(2))), f,
                          lab.group(0).replace(' ', '')))
    if not cands:
        return None
    cands.sort(key=lambda t: t[0])          # 🔴 数值序·此行系 ③ 之病灶，勿删
    _, path, label = cands[-1]
    base = os.path.basename(path)[:-3]
    rcpt = ''
    for pat in (f'adj-archive/{base}-receipt.md', f'adj-archive/{base}-*receipt*.md'):
        hit = sorted(glob.glob(pat))
        if hit:
            rcpt = hit[0]
            break
    return path, label, rcpt


if __name__ == '__main__':
    r = latest_handover()
    if not r:
        sys.exit('🔴 未找到任何交接书')
    print('\t'.join(r))
