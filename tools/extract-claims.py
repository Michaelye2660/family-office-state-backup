#!/usr/bin/env python3
"""机械提取表生成器（ADJ-0731-20③1·A类·零裁量零概括）

用法: python3 tools/extract-claims.py [件号...]
不带参数则用 -22③ 所列之余十件。
输出逐字摘录（含行号），不作任何压缩或改写——转写稀释系两侧共有之已实证失败模式(cc-knowledge §5.10)。
"""
import re, os, sys, subprocess

DEFAULT = ["ADJ-0721-09","ADJ-0721-10","ADJ-0721-11","ADJ-0721-12","ADJ-0721-13","ADJ-0721-14",
           "ADJ-0726-06","ADJ-0726-08","ADJ-0728-03","ADJ-0728-11"]
PEND  = re.compile(r'候\s*GM|候裁|候委托人|候一字|未闭合|待补|待核|待报|悬置|在途|遗留|候批|候确认|待定|未决')
CLAIM = re.compile(r'全部|唯一|零[^\s]{0,3}(?:未|件|份|仓位)|全库|一律|共\s*\d+\s*[件项份]|\d+\s*[件份]|皆|全数|无一')

def run(names):
    for n in names:
        p = f"adj-archive/{n}-receipt.md"
        if not os.path.exists(p):
            print(f"## {n}\n\n🔴 回执不存在: {p}\n"); continue
        lines = open(p, encoding='utf-8').read().split('\n')
        sha = subprocess.run(['git','log','-1','--format=%h',p], capture_output=True, text=True).stdout.strip()
        pend = [(i+1,l.strip()) for i,l in enumerate(lines) if l.strip() and PEND.search(l)]
        clm  = [(i+1,l.strip()) for i,l in enumerate(lines) if l.strip() and CLAIM.search(l)]
        print(f"## {n}\n\n**文件** `{p}`（{len(lines)} 行·末次 commit `{sha}`）\n")
        print(f"### (a) 未决项逐字摘录（命中 {len(pend)} 行）\n")
        for i,l in pend: print(f"- **L{i}**：{l}")
        if not pend: print("- （零命中——**零命中不等于无未决项**，须 GM 抽读校验）")
        print(f"\n### (c) 全称／计数型断言逐字摘录（命中 {len(clm)} 行）\n")
        for i,l in clm: print(f"- **L{i}**：{l}")
        print("\n**(b) 闭合证据比对**：须逐条人工/机械核\n\n---\n")

if __name__ == "__main__":
    run(sys.argv[1:] or DEFAULT)
