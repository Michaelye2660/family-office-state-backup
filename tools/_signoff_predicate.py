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


# 🔴 病三 · 否定闸挡不住「述而不签」（2026-08-01·**同轮再犯·本器自捕**）
#   补上否定闸后，`ADJ-0801-05-receipt.md`（**即记录病一病二那份回执本身**）仍被判「已签」。
#   命中处系其 §五 之**表格行**：
#     「| 病一 | 原式 `GM-\d` 只认一位数 —— `[裁决侧·GM-10]`／`[GM-11]` 一律不匹配 | 潜伏未发：全库现无两位数纪元之真签收…」
#   ——**一份记录「散文里的两个字不能当签收」之文件，被那两个字判成了已签收。**
#   否定词确实在句中（「无……签收」），**但被中间的字隔开，字面挡不住**。
#   **这正是本器上一轮自己写下之限度「写法一变就可能再漏」之当场兑现，且下一份文件就是它。**
#
# 🔴 收紧：**签收系落款行为，不是叙述**。故 NEAR 只在「落款位」生效——
#   命中行**不得为表格行**（含 `|`）。理由不靠直觉，靠实测：
#   **全库 261 份回执中，靠 NEAR 判为已签者仅 1 件，且系上述假阳性——NEAR 之真阳性数＝0。**
#   故此收紧**不损任何已知真命中**；一切真签收皆由 STRONG 或签收片认出。
#
# 🔴 收紧之抵偿（照 anchor-guard 之例：减一个检查须补一个可见性）：
#   `contribution()` 逐判据报真/假贡献，**每次跑都看得见**；
#   若哪天 NEAR 之贡献由 0 变正，即说明有真签收只能靠它认出，届时此收紧须复议。
def _near_hit(text):
    for p in NEAR:
        for m in p.finditer(text):
            a, b = max(0, m.start() - 40), min(len(text), m.end() + 40)
            if NEG.search(text[a:b]):
                continue
            ls = text.rfind('\n', 0, m.start()) + 1
            le = text.find('\n', m.end())
            line = text[ls:le if le > 0 else len(text)]
            if '|' in line:          # 🔴 表格行＝叙述，非落款
                continue
            return True
    return False


def contribution(files):
    """逐判据之贡献度（**常报项·使收紧之代价可见**）。返回 {判据: 命中件数}。"""
    out = {'签收片': 0, 'STRONG': 0, 'NEAR': 0}
    for f in files:
        t = io.open(f, encoding='utf-8', errors='replace').read()
        base = os.path.basename(f).replace('-receipt.md', '').replace('.md', '')
        if os.path.exists(os.path.join(os.path.dirname(f), f'{base}-receipt-signoff.md')):
            out['签收片'] += 1
        elif any(p.search(t) for p in STRONG):
            out['STRONG'] += 1
        elif _near_hit(t):
            out['NEAR'] += 1
    return out


def is_signed(path, text=None):
    """签收（-05① 甲义：已阅并认可）。签收片存在亦算。"""
    if text is None:
        text = io.open(path, encoding='utf-8', errors='replace').read()
    base = os.path.basename(path).replace('-receipt.md', '').replace('.md', '')
    if os.path.exists(os.path.join(os.path.dirname(path), f'{base}-receipt-signoff.md')):
        return True
    if any(p.search(text) for p in STRONG):
        return True
    # 🔴 `ADJ-0801-14③`(a)（2026-08-01·GM-12 裁·委托人「adj14你现在处理」）：
    #   **NEAR 两判据自「判为已签」降为「报为疑似·须人核」** —— 故本函数不再据 NEAR 返回 True。
    #   **GM 之丙路照录**：「NEAR 之真阳性 0%，其样本系全库 261 份历史回执 —— 而这 261 份，
    #   全部写于『结构化签收标记尚不存在』的时代。在一个没有硬格式的时代，NEAR 本就没有可分辨的对象。
    #   **0% 不是它失效的证据，是它从未在其设计场景中被测试过的证据。**」
    #   故不退役、不作废，只改其效力：**捕捉不合规之签收企图**（(b)）。
    #   **退役端点改为**：结构化标记现役满 60 日（**＝2026-09-30**）后，若 NEAR 在新制下仍真阳性为 0，
    #   **方得再议退役；旧样本不得再作退役依据**（(c)）。
    return False


def is_near_suspect(path, text=None):
    """🔴 `-14③`(a)：NEAR 命中＝**疑似签收·须人核**，不判已签。
    与 `is_signed` 分离，使「已签」与「疑似」在读数上不可混。"""
    if text is None:
        text = io.open(path, encoding='utf-8', errors='replace').read()
    if is_signed(path, text):
        return False          # 已由 STRONG／签收片认定者，不再计入疑似
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
    # 🔴 `ADJ-0801-19⑪`（2026-08-02·GM 裁）：**未签收数在结构上不可能收敛**——
    #   每出一份回执即 +1，**而结案动作本身产生回执**；审查员实见分母 91／92／93 三值且无时点钉。
    #   **裁：改「按批次钉时点之存量」＋「新增流量」两栏；单一存量数不得再作进度指标。**
    import subprocess as _sp
    _tip = _sp.run(['git','log','-1','--format=%H %ad','--date=short'],
                   capture_output=True, text=True).stdout.strip()
    _roster = 'docs/internal-audit/2026-08-01-91-roster.txt'
    try:
        _r = {x.strip() for x in io.open(_roster, encoding='utf-8') if x.strip()}
    except OSError:
        _r = set()
    _base = lambda f: os.path.basename(f).replace('-receipt.md', '')
    _stock = [f for f in uns if _base(f) in _r]
    _flow = [f for f in uns if _base(f) not in _r]
    print(f"回执 {len(files)} 件｜已签 {len(files)-len(uns)}｜**未签 {len(uns)}**")
    print(f"🔴 **两栏分列（`-19⑪`·单一存量数不得作进度指标）**：")
    print(f"   **存量**（钉于 2026-08-01 之 91 件名册）＝ **{len(_stock)}/{len(_r) or '—'}**")
    print(f"   **流量**（名册之后新增未签）＝ **{len(_flow)}**｜**读取 tip ＝ {_tip}**")
    print(f"   ⚠️ 名册缺失则存量栏不可算——**本器不以「当前未签收集合」回落充之**。" if not _r else '')
    susp = [f for f in files if is_near_suspect(f)]
    print(f"🔴 **NEAR 疑似（须人核·不判已签·`-14③`(a)）＝{len(susp)} 件**"
          f"{'：' + ', '.join(os.path.basename(x) for x in susp[:5]) if susp else ''}")
    c = contribution(files)
    print(f"判据贡献度：签收片 {c['签收片']}｜STRONG {c['STRONG']}｜**NEAR {c['NEAR']}**"
          f"（NEAR 若长期为 0，即说明该两条判据无真阳性——**是否退役属判断类，呈 GM**）")
    if '--list' in sys.argv:
        for f in uns:
            print("  ", os.path.basename(f).replace('-receipt.md', ''))
