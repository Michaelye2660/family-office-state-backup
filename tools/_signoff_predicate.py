#!/usr/bin/env python3
"""签收判据 · **单一正本**（ADJ-0801-05① 之机械载体｜CGM 2026-08-01 立）

🔴 何以必须单一：本库已有实证——「最新交接书」之取件判据曾散在三处，**三处各自坏成不同的样子**
   （字典序／写死件号／丢 sort），故已并入 `_latest-handover.py`。签收判据本日重演同一形态：
   `receipt-signoff-scan.py` 与新造之 `signoff-queue.sh` 各持一份，**两器计数当场对不上（80 vs 79）**。
   **凡一条判据被复制第二份，它就开始各自演化。** 故此处收为一份，两器皆 import。

🔴 本文件之两条病史（皆当轮实证·写死免复发）：

  病一 · **两位数纪元盲区（潜伏未发）**
     原式作 `\\[裁决侧·GM-\\d\\]` —— **只认一位数**。`[裁决侧·GM-10]`／`[GM-11]` 一律不匹配。
     现状核过：全库含 `裁决侧·GM-1[0-9]` 之回执**仅 1 件**且该件并非签收，
     **故此缺陷至今未造成任何错数**——**惟 GM-11 一旦真签，其签收即静默不计。**
     **一个「还没出错」的缺陷，和一个「不会出错」的缺陷，是两回事。**

  病二 · **放宽正则当场造出假阳性（已发生）**
     为修病一而改作 `GM-\\d+` 后，`ADJ-0731-52-receipt.md` 立即由「未签」翻为「已签」。
     而该件之原句是：「`[裁决侧·GM-10]` **零发令零签收零投递零改台账实质字段**」——
     **一句声明「什么都没签」的话，被判成了「已签」。**
     其形态恰是 `-05①` 所禁者之机械版：**把「未核」变成「已核」之留痕，而留痕比空白更难被后人怀疑。**
     故本判据**加否定闸**：邻近窗口内出现否定词者，一律不计签收。

🔴 本判据之限度（如实申报·不得读作已消除）：
   邻近匹配**本质上分不清断言与否定**，否定闸只是把已知的几个否定词挡住；
   **写法一变就可能再漏**。**真正的解只有一个：签收须有其专属之结构化标记，而非靠散文里的两个字。**
   此系判断类，**呈 GM**（`-05①` 已定义签收之含义，尚未定义其形式）。
"""
import io, os, re

# 强标记：形态明确，无须否定闸
STRONG = [re.compile(r'✓\s*裁决侧已签收'),
          re.compile(r'#+\s*签收（裁决侧')]

# 邻近标记：须过否定闸
NEAR = [re.compile(r'\[裁决侧·GM-\d+\][^\n]{0,80}(两维签收|签收|核讫|签讫)'),
        re.compile(r'(两维签收|核讫)[^\n]{0,40}\[裁决侧·GM-\d+\]')]

# 🔴 否定闸（病二之解）：命中窗口内出现下列任一者，**不计签收**
NEG = re.compile(r'零签收|未签收|无签收|不签|零发令|待签|候签|尚未签|未经签收|拒签')

# 🔴 纪元结转登记（-05① 之乙义）——**知悉而不追认·绝不并入已签**
CARRY = [re.compile(r'纪元结转登记'), re.compile(r'结转登记（不追认')]


def _near_hit(text):
    for p in NEAR:
        for m in p.finditer(text):
            a = max(0, m.start() - 40)
            b = min(len(text), m.end() + 40)
            if not NEG.search(text[a:b]):
                return True
    return False


def is_signed(path, text=None):
    """签收（-05① 甲义：已阅并认可）。签收片存在亦算。"""
    if text is None:
        text = io.open(path, encoding='utf-8', errors='replace').read()
    base = os.path.basename(path).replace('-receipt.md', '').replace('.md', '')
    if os.path.exists(os.path.join(os.path.dirname(path), f'{base}-receipt-signoff.md')):
        return True
    if any(p.search(text) for p in STRONG):
        return True
    return _near_hit(text)


def is_carried(path, text=None):
    """纪元结转登记（-05① 乙义：知悉而不追认）。"""
    if text is None:
        text = io.open(path, encoding='utf-8', errors='replace').read()
    return any(p.search(text) for p in CARRY)


if __name__ == '__main__':
    import glob, sys
    files = [f for f in sorted(glob.glob('adj-archive/*receipt*.md')) if 'signoff' not in f]
    uns = [f for f in files if not is_signed(f)]
    print(f"回执 {len(files)} 件｜已签 {len(files)-len(uns)}｜**未签 {len(uns)}**")
    if '--list' in sys.argv:
        for f in uns:
            print("  ", os.path.basename(f).replace('-receipt.md', ''))
