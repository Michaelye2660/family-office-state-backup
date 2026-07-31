#!/usr/bin/env python3
"""回执签收扫描 · 四判据版（ADJ-0731-04②授权·〔M〕416）
旧法 `grep -L -e 已签收 -e 两维签收 adj-archive/*receipt*.md` 已废——三缺陷见 weekly-retro prompt。
用法: python3 tools/receipt-signoff-scan.py [--list]

🔴 判据已于 2026-08-01（ADJ-0801-05 落实轮）**移入 `tools/_signoff_predicate.py` 单一正本**。
   本文件不再自持一份正则 —— 其由：本器与新造之 `signoff-queue.sh` 曾各持一份，
   **当场对不上（80 vs 79）**；同型病史见 `_latest-handover.py`（同一判据散三处，三处各坏各的）。
   **凡一条判据被复制第二份，它就开始各自演化。**
"""
import glob, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _signoff_predicate import is_signed, is_carried


def scan():
    files = [f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]
    signed, unsigned = [], []
    for f in files:
        b = os.path.basename(f).replace('-receipt.md', '')
        (signed if is_signed(f) else unsigned).append(b)
    return files, signed, unsigned


if __name__ == '__main__':
    files, signed, unsigned = scan()
    print(f"回执 {len(files)} 件（已排除 *-receipt-signoff.md 签收片）")
    print(f"裁决侧已签 {len(signed)} ｜ **未签 {len(unsigned)}**")
    if len(unsigned):
        print("Breach 候选（未签收数>0）")
    if '--list' in sys.argv:
        for b in unsigned:
            print("  ", b)
