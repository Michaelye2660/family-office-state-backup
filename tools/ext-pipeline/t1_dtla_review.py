"""T1 真金审计首跑 · ADJ-0720-09 DTLA长债基线首笔（task#55）。

首个 T1 真金档位 live 往返：CGM 制备外送审计包（仅A节·百分比化·无绝对金额/
身份/托管信息·B节GM意见不出仓·互不见稿）→ 出包检查器过闸 → 硬净室盲审 → 归档。

纪律：
  - 材料边界(-12④)：只出仓位百分比/久期/收益率/估值，绝对金额与身份托管不出仓。
  - 出包检查器内置（钢印：无检查器不上线·拒发即 raise·fail-closed）。
  - 秘钥只从环境读·永不打印（N8）。
  - tier=T1·真金审计档位·终裁前不执行任何交易。
  - 时间戳外部注入：--stamp 必填。
用法：
  python3 t1_dtla_review.py --stamp $(date -u +%Y%m%dT%H%M%SZ)          # live
  python3 t1_dtla_review.py --stamp <stamp> --dry                      # mock 回环
"""
import argparse
import sys

import checker
import netroom
import archive
from config import NETROOM_MODEL, NETROOM_EFFORT

# 外送审计包（仅A节事实·百分比化·零绝对金额/零身份/零托管·B节GM意见不入包）
DTLA_BRIEF = """【外部独立盲审·长债基线建仓决策·请给独立意见】
你是一位不知提问者身份、无任何历史上下文的独立固定收益/资产配置审阅人。
以下为一项拟议的结构性建仓决策事实，请给出你的独立判断，不必迎合。

■ 拟议动作
在一个多资产组合中，建立一笔长久期美国国债的"保险性"基线仓位。
- 工具：追踪 ICE 美国国债 20年以上指数的公募 UCITS ETF（爱尔兰注册·美元·大型
  流动品种·总费率 TER 0.07%·累积型）；久期约 17。
- 目标规模：净资产的 3%（无条件常设基线）。另有 2% 的条件档，触发条件为
  30年期收益率≥5.5% 或美联储政策转向——当前均未触发，本次仅议 3% 基线部分。
- 定性：明确定义为"结构保险仓"，非战术仓；不设战术止损；负 carry 视为保险费。

■ 市况快照（数据日为近一周收盘）
- 30年期美债收益率约 5.05%–5.10% 区间（近期站上 5%）。
- 久期约 17 → 利率每变动 ±1 个百分点，市值约 ∓17%（设计数学·非预测）。

■ 执行计划
- 分 4 批建仓、每批 25%、跨约 5 周；每批限价单；事件日（FOMC/CPI/非农）
  前后各 1 小时不下单。
- 资金来源两条备选路径：(甲) 组合外流动性分批注入；(乙) 组合内短久期国债头寸
  转换为长久期。二者对组合第一层流动性的影响不同（见下）。

■ 流动性红线预演（组合设有"第一层流动性不低于净资产 25%"的硬红线）
- 最紧情形（乙路径+全口径规模）：第一层流动性由约 35% 降至约 27%，仍 > 25%（守住）。
- 全口径分母下由约 80% 降至约 77%（守住）。甲路径则第一层流动性不下降。
- 零杠杆·无锁定额度冲突。

■ 情景（设计数学·非预测）
- 基准：负 carry 缓慢流血（即保险费）。
- 利率升至 6%：市值约 −15% 量级（保险费加价·不止损）。
- 通缩衰退、长端下行 1.5 个百分点：市值约 +25% 量级（含凸性·危机中作再平衡弹药）。

■ 请回答（第三问起）
第三问：在当前 30年期约 5% 的水平上，为一个多资产组合建立"无条件"3% 长久期
        国债保险基线，你认为是稳健、可接受、还是不妥？给出你的核心理由。
第四问：反方最强论点是什么？（例如再通胀二次起立、久期风险、负 carry 长期拖累。）
第五问：4 批 × 5 周、避开事件日的分批执行方式，对这类结构仓是否合理？有何改进。
第六问：甲/乙两条资金路径，从流动性与组合韧性角度，你倾向哪条？为什么。
"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--stamp", required=True, help="外部注入时间戳·如 20260720T120000Z")
    ap.add_argument("--dry", action="store_true", help="mock 回环·验证 runner·不触 OpenAI")
    args = ap.parse_args()
    mode = "mock" if args.dry else "live"

    if mode == "live":
        from live_preflight import run_preflight
        pf = run_preflight()
        if not (pf["A_key_present"] and pf["B_openai_pkg"] and pf["C_reachable"]
                and pf["D_status"] == 200):
            print("❌ 预检未过·不发起 live 调用。先跑 python3 live_preflight.py。")
            return 1
        print("✅ 预检全过·发起 T1 盲审（每次全新无状态 client·硬净室）")

    # 1) 组装 request（金丝雀+模型自报强制置顶·硬净室无上下文）
    request_body = netroom.build_request(DTLA_BRIEF, line="netroom")

    # 2) 出包检查（钢印·fail-closed·材料边界真金闸门）
    check = checker.check_outbound(request_body)
    if not check.passed:
        print("❌ 出包检查拒发·上呈 GM·不调净室：")
        print(check.escalation_note())
        return 1
    print(f"✅ 出包检查通过·request sha1={check.request_sha1[:12]}（无绝对金额/身份/托管命中）")

    # 3) 调净室（T1 真金 live）
    try:
        nr = netroom.call_netroom(request_body, mode=mode)
    except Exception as e:
        status = getattr(e, "status_code", None)
        if status is None:
            raise
        ecode = getattr(e, "code", None)
        print(f"❌ live 调用被平台拒绝：HTTP {status}·error.code={ecode}（如实报·人工判）")
        return 1

    # 4) 归档留痕（tier=T1·真金审计档位）
    anchor = archive.archive_roundtrip(
        tier="T1", request_body=request_body, response_text=nr.response_text,
        env_attestation=nr.env_attestation, checker_sha1=check.request_sha1,
        stamp=args.stamp, line="netroom",
    )
    print(f"✅ 归档三件 base={anchor['archive_base']}")
    print(f"   request  sha1={anchor['request_sha1']}")
    print(f"   response sha1={anchor['response_sha1']}")

    # 5) 盲审答卷 + 成本实测
    print("═══ T1 盲审答卷（判读/双呈留 CGM→委托人）═══")
    print(f"  模式：{nr.mode}｜模型请求档：{NETROOM_MODEL}·effort={NETROOM_EFFORT}")
    print("  ── 答卷全文 ──")
    print("  " + nr.response_text.replace("\n", "\n  "))
    if nr.usage:
        ti, to = nr.usage.get("input_tokens"), nr.usage.get("output_tokens")
        print("  ── 成本实测 ──")
        print(f"  input={ti} tok · output={to} tok（reasoning={nr.usage.get('reasoning_tokens')}）")
        if ti is not None and to is not None:
            cost = ti / 1e6 * 5.0 + to / 1e6 * 30.0
            print(f"  按 Sol 单价折算 ≈ ${cost:.4f}/次")
    print("─" * 40)
    return 0


if __name__ == "__main__":
    sys.exit(main())
