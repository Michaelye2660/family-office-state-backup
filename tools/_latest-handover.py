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
    # 🔴 合并回执之查找（CGM 自捕·ADJ-0731-62 收件当轮·**且系一处已发布之预言被实测证伪**）：
    #   原实现只认 `ADJ-MMDD-NN-receipt.md` 与 `ADJ-MMDD-NN-*receipt*.md`。
    #   **而本仓之回执常系合并件**（`ADJ-0731-57-and-58-receipt.md` 等）——
    #   `-62` 之回执名为 `ADJ-0731-61-and-62-receipt.md`，**件号在名之尾而非首，遂查不到**。
    #   **后果**：`reading-set-size.sh` 之「交接书回执」永远计 0，载入集总量长期少算。
    #   🔴 **本席曾于 ADJ-0731-61-and-62-receipt §丙 与〔M〕471⑪ 断言「本回执落库后该栏即回填」——
    #      落库后实测未回填，该预言被自己的仪器证伪。** 更正见〔M〕472。
    #   **教训**：**一个「稍后就会好」的解释，若不回头量一次，就等于一个没被发现的缺陷。**
    import re as _re
    m = _re.search(r'ADJ-(\d{4})-(\d+)', base)
    num = f'{int(m.group(2)):02d}' if m else ''
    day = m.group(1) if m else ''
    cands = []
    for f in glob.glob('adj-archive/*receipt*.md'):
        b = os.path.basename(f)
        if not b.startswith(f'ADJ-{day}-'):
            continue
        # 件号须以独立 token 出现（首件、尾件、或 -and- 之任一侧），避免 -6 命中 -62
        if _re.search(rf'(?<!\d){num}(?!\d)', b.replace('-receipt', '').replace('receipt', '')):
            cands.append(f)
    if cands:
        rcpt = sorted(cands)[0]
    return path, label, rcpt


def latest_skeleton():
    """**唯一**之「下一代空骨架」判据（ADJ-0731-57②4）。

    🔴 立此之由（CGM 自捕·ADJ-0731-58 收件当轮）：
      两处各以 `sorted(glob(...))[-1]` / `ls | tail -1` 取骨架件 —— **皆系字典序**，
      故 `E11-declaration-SKELETON.md` < `E9-declaration-SKELETON.md`，**取到的是上上代之骨架**。
      **本日同族第四例**（块7 硬写死／reading-set 硬写死／warmstart-ratio 漏 sort()／本处字典序）。
      → **凡以「最新」取件者，一律按数值序，且判据只此一份。**
    """
    c = []
    for f in glob.glob('docs/succession/E*-declaration-SKELETON.md'):
        m = re.search(r'E(\d+)-declaration-SKELETON', os.path.basename(f))
        if m:
            c.append((int(m.group(1)), f))
    if not c:
        return ''
    c.sort(key=lambda t: t[0])          # 🔴 数值序·勿改回字典序
    return c[-1][1]


if __name__ == '__main__':
    r = latest_handover()
    if not r:
        sys.exit('🔴 未找到任何交接书')
    # 🔴 BrokenPipe 之处置（CGM 自捕·2026-08-01·随 ADJ-0801-01 落实轮）：
    #   调用方作 `read -r A B C < <(python3 …)`——`read` 只取首行即弃管道，
    #   第二个 print 遂抛 BrokenPipeError，**每一次正常运行都吐一段 Traceback**。
    #   其害不在这一次：**一个每跑必吐 Traceback 之脚本，会把读者训练成看见 Traceback 不当回事**；
    #   等到哪天吐的是真错，没有人会停下来。故此处**只吞下游停读这一种**，别的照抛。
    try:
        print('\t'.join(r))
        print(latest_skeleton())
        sys.stdout.flush()
    except BrokenPipeError:
        try:
            sys.stdout.close()
        except Exception:
            pass
        os._exit(0)
