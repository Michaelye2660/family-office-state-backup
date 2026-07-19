"""干跑自测（段一·-17①(b)）· mock 回环·无 key·无 OpenAI。

覆盖 GM 指定用例：
  A. 出包检查器拒发用例（绝对金额 / 身份 各一）+ 放行用例（百分比/倍数）+ sha1恒等用例
  B. 四档路由用例（T1/T2/T3/T4）
  C. 留痕链用例（request+response 归档+sha1 锚定）
  D. EXT-R 受控重放（注入清单对表·sha1）
运行：python3 selftest.py  → 打印自测报告·全过 exit 0·任一失败 exit 1。
"""
import os
import sys
import tempfile

import checker
import router
import netroom
import archive
import pipeline

PASS, FAIL = "✅", "❌"
results = []


def check(name, cond, detail=""):
    results.append((cond, name, detail))
    print(f"  {PASS if cond else FAIL} {name}{('  · ' + detail) if detail else ''}")


print("=" * 68)
print("EXT 管道段一干跑自测（mock 回环·无 key·无 OpenAI）")
print("=" * 68)

# 归档写入临时目录·不污染主仓
_tmp = tempfile.mkdtemp(prefix="ext-pipe-selftest-")
archive.ARCHIVE_DIR = _tmp

# ── A. 出包检查器 ──────────────────────────────────────────────
print("\n[A] 出包检查器（禁词 v2 + sha1 恒等）")

r = checker.check_outbound("本次拟加仓组合权重 3.2%，估值 18x PE，仓位占比 4.5%。")
check("A1 放行·相对量（百分比/倍数/权重）", r.passed, "无命中")

r = checker.check_outbound("拟买入 $2,500,000 的某标的。")
check("A2 拒发·美元绝对额 $2,500,000", (not r.passed) and any(c == "usd_absolute" for c, _ in r.hits))

r = checker.check_outbound("加仓约 1500万美元。")
check("A3 拒发·中文货币绝对额 1500万美元", (not r.passed) and any(c == "cny_absolute" for c, _ in r.hits))

r = checker.check_outbound("联系人 zhang.san@example.com 电话 415-555-0199。")
check("A4 拒发·身份信息（email/电话）", (not r.passed) and any(c == "identity_pii" for c, _ in r.hits))

r = checker.check_outbound("经由 Interactive Brokers 托管行执行。")
check("A5 拒发·托管行", (not r.passed) and any(c == "custodian_identity" for c, _ in r.hits))

body = "组合权重 5% 的规则复审材料。"
r_ok = checker.check_outbound(body, registered_sha1=checker.sha1_text(body))
check("A6 sha1 恒等·相符放行", r_ok.passed)
r_bad = checker.check_outbound(body, registered_sha1="deadbeef" * 5)
check("A7 sha1 不符·拒发（出包漂移）", (not r_bad.passed) and any("sha1不符" in x for x in r_bad.reasons))

# escalation note 不含命中原文（防二次泄漏）
note = r_bad.escalation_note()
check("A8 上呈 GM 说明生成·不含命中原文", ("上呈GM" in note) and ("$" not in note))

# ── B. 四档路由 ────────────────────────────────────────────────
print("\n[B] 四档路由（T1/T2/T3/T4）")
check("B1 T1 事前必审（≥0.5%净值）",
      router.route(kind="trade", nav_fraction=0.008).tier == "T1")
check("B2 T2 事后周审（<0.5%净值 或 周批）",
      router.route(kind="trade", nav_fraction=0.002).tier == "T2"
      and router.route(kind="weekly").tier == "T2")
check("B3 T3 预授权阶梯豁免",
      router.route(kind="trade", nav_fraction=0.02, pre_authorized_ladder=True).tier == "T3")
check("B4 T4 委托人「审」优先压倒一切",
      router.route(kind="trade", nav_fraction=0.02, principal_flagged=True).tier == "T4")
d1 = router.route(kind="trade", nav_fraction=0.008)
check("B5 T1 冻结执行+双呈", d1.blocks_execution and d1.dual_present)

# ── C. 留痕链（含拒发不落净室）──────────────────────────────────
print("\n[C] 留痕链 + 拒发不调净室")
rt = pipeline.run_review(brief_body="规则复审：组合权重 5% 阈值是否合理？",
                         kind="principal_review", mode="mock", stamp="20260719-selftest")
check("C1 往返归档·三件落盘", all(os.path.exists(os.path.join(_tmp, rt.anchor["archive_base"] + s))
      for s in (".request.txt", ".response.txt", ".anchor.json")))
check("C2 request/response sha1 锚定", len(rt.anchor["request_sha1"]) == 40 and len(rt.anchor["response_sha1"]) == 40)
check("C3 金丝雀首问置顶+环境证明表六项", netroom.CANARY_Q in rt.netroom_result.request_body
      and len(rt.netroom_result.env_attestation) == 6)

rejected = False
try:
    pipeline.run_review(brief_body="拟动用 $5,000,000。", kind="trade", nav_fraction=0.01,
                        mode="mock", stamp="20260719-selftest")
except pipeline.OutboundRejected:
    rejected = True
check("C4 禁词命中→拒发·不调净室（fail-closed）", rejected)

# 拒发件不应产生 response 归档（净室未被调用）
leaked = any("5,000,000" in open(os.path.join(_tmp, f), encoding="utf-8").read()
             for f in os.listdir(_tmp) if f.endswith(".response.txt"))
check("C5 拒发件无 response 落盘（净室零触达）", not leaked)

# ── D. EXT-R 受控重放 ──────────────────────────────────────────
print("\n[D] EXT-R 受控重放（注入清单对表）")
extr_text, extr_sha = netroom.load_extr_injection()
check("D1 EXT-R-diet 注入清单载入+sha1", len(extr_sha) == 40)
rt2 = pipeline.run_review(brief_body="EXT-R 季度纵向模式审试跑。", kind="principal_review",
                          line="extr", mode="mock", stamp="20260719-selftest")
check("D2 EXT-R 线注入 sha1 入锚定（对表用）", rt2.anchor["extr_injection_sha1"] == extr_sha)

# ── E. 三层核验制层2（月度抽验 + 注入清单对表）──────────────────
print("\n[E] 三层核验制层2（GM 周期抽验）")
import verify
verify.ARCHIVE_DIR = _tmp          # 抽验临时归档
aud = verify.audit_archive()
check("E1 月度抽验·归档件 sha1 + 禁词复扫全过", len(aud) > 0 and all(v["ok"] for v in aud.values()),
      f"{len(aud)} 件")
vex = verify.verify_extr_injection()
check("E2 EXT-R 注入清单对表·无未登记喂料", vex["ok"], f"diet sha1={vex['current_diet_sha1'][:12]}")

# 篡改探测：改一件归档 request → 抽验须报漂移
import os as _os
_first = next(iter(aud))
with open(_os.path.join(_tmp, _first + ".request.txt"), "a", encoding="utf-8") as f:
    f.write("\n篡改注入 $9,999,999")
aud2 = verify.audit_archive([_first])
check("E3 篡改探测·归档被改→抽验报漂移+禁词", not aud2[_first]["ok"] and len(aud2[_first]["issues"]) >= 1)

# ── 汇总 ──────────────────────────────────────────────────────
print("\n" + "=" * 68)
passed = sum(1 for ok, _, _ in results if ok)
total = len(results)
print(f"自测结果：{passed}/{total} 通过")
print("=" * 68)
sys.exit(0 if passed == total else 1)
