#!/usr/bin/env python3
"""回执签收扫描 · 四判据版（ADJ-0731-04②授权·〔M〕416）
旧法 `grep -L -e 已签收 -e 两维签收 adj-archive/*receipt*.md` 已废——三缺陷见 weekly-retro prompt。
用法: python3 tools/receipt-signoff-scan.py [--list]
"""
import glob,os,io,re,sys
SIG=[re.compile(r'✓\s*裁决侧已签收'),
     re.compile(r'#+\s*签收（裁决侧'),
     re.compile(r'\[裁决侧·GM-\d\][^\n]{0,80}(两维签收|签收|核讫|签讫)'),
     re.compile(r'(两维签收|核讫)[^\n]{0,40}\[裁决侧·GM-\d\]')]
def scan():
    files=[f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]
    signed=[];unsigned=[]
    for f in files:
        b=os.path.basename(f).replace('-receipt.md','')
        if os.path.exists(f'adj-archive/{b}-receipt-signoff.md'): signed.append(b); continue
        t=io.open(f,encoding='utf-8',errors='replace').read()
        (signed if any(p.search(t) for p in SIG) else unsigned).append(b)
    return files,signed,unsigned
if __name__=='__main__':
    files,signed,unsigned=scan()
    print(f"回执 {len(files)} 件（已排除 *-receipt-signoff.md 签收片）")
    print(f"裁决侧已签 {len(signed)} ｜ **未签 {len(unsigned)}**")
    if len(unsigned): print("Breach 候选（未签收数>0）")
    if '--list' in sys.argv:
        for b in unsigned: print("  ",b)
