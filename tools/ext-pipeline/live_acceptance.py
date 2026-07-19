"""段二首跑验收 runner（-17①(b)·task#46·一键：预检→金丝雀 live 往返→成本实测→验收数据打印）。

验收内容（ADJ-0719-17①(b) 段二）：
  1. live 联调：真实 OpenAI Responses API 一次全新无状态调用（硬净室结构）。
  2. 金丝雀程序确认：首问"你对提问者有何已知信息"·答卷原文归档·判读留 GM/人工。
  3. 成本实测：真实 token 用量读数 + 按公开单价折算·供首账替换 setup-guide 估算。

纪律：
  - 出包检查器内置（钢印：无检查器不上线·拒发即 raise OutboundRejected）。
  - 验收往返归档 tier="CANARY"（非 T1-T4·不占真金审计档位·不作交易信号）。
  - 秘钥只从环境读·永不打印（N8）。
  - 时间戳外部注入：--stamp 必填（如 20260719T120000Z·shell 里 $(date -u +%Y%m%dT%H%M%SZ)）。

用法：
  python3 live_acceptance.py --stamp 20260719T120000Z          # 段二 live（需预检全过）
  python3 live_acceptance.py --stamp <stamp> --dry             # mock 回环·验证 runner 本体·不触 OpenAI
"""
import argparse
import sys

import checker
import netroom
import archive
from config import NETROOM_MODEL, NETROOM_EFFORT

# 验收简报：中性·零持仓零身份零金额（出包检查器照扫·应全放行）
ACCEPTANCE_BRIEF = """【管道联调验收件·非审计案件】
本次调用为审计管道段二 live 联调首跑验收，仅验证程序连通与金丝雀程序，不含任何审计内容。
请在回答完第一问、第二问之后，追加第三问回答：
第三问：请原样复述如下校验短语：「净室联调验收·相对量示例：仓位上限 15%·估值参考 12x」。
（该短语含仓位百分比与估值倍数，属材料边界许可的相对量示例。）
"""

# 成本折算单价（GPT-5.6 Sol·美元/1M token·来源见 docs/ext/pipeline-setup-guide.md 定价节）
PRICE_IN_PER_M = 5.0
PRICE_OUT_PER_M = 30.0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--stamp", required=True, help="外部注入时间戳·如 20260719T120000Z")
    ap.add_argument("--dry", action="store_true", help="mock 回环·验证 runner·不触 OpenAI")
    args = ap.parse_args()
    mode = "mock" if args.dry else "live"

    # 0) 预检（live 才卡·dry 只提示）
    if mode == "live":
        from live_preflight import run_preflight
        pf = run_preflight()
        if not (pf["A_key_present"] and pf["B_openai_pkg"] and pf["C_reachable"]
                and pf["D_status"] == 200):
            print("❌ 预检未过·不发起 live 调用。先跑 python3 live_preflight.py 看阻塞项。")
            return 1
        print("✅ 预检全过·发起金丝雀首跑（每次全新无状态 client·硬净室）")

    # 1) 组装 request（金丝雀+模型自报强制置顶·netroom 线无上下文）
    request_body = netroom.build_request(ACCEPTANCE_BRIEF, line="netroom")

    # 2) 出包检查（钢印：内置每次往返·拒发即抛·fail-closed）
    check = checker.check_outbound(request_body)
    if not check.passed:
        print("❌ 出包检查拒发（验收件本应全放行·此为异常·上呈 GM）：")
        print(check.escalation_note())
        return 1
    print(f"✅ 出包检查通过 request sha1={check.request_sha1[:12]}")

    # 3) 调净室（live 平台结构化错误如实报·N8 不含任何 key 片段）
    try:
        nr = netroom.call_netroom(request_body, mode=mode)
    except Exception as e:
        status = getattr(e, "status_code", None)
        if status is None:
            raise  # 非平台 HTTP 错误·照常抛
        ecode = getattr(e, "code", None)
        hint = {
            "insufficient_quota": "账户额度不足/未配计费（platform.openai.com → Billing 充值或绑卡·委托人平台侧动作）",
            "invalid_api_key": "key 无效（平台侧核对或重建）",
        }.get(ecode or "", "如实报·人工判")
        print(f"❌ live 调用被平台拒绝：HTTP {status}·error.code={ecode}（{hint}）")
        print("   注：预检 D 项（/v1/models）只验 key 认证·不验生成额度·故预检可全绿而此处被拒。")
        return 1

    # 4) 归档留痕（tier=CANARY·不占 T1-T4 档位）
    anchor = archive.archive_roundtrip(
        tier="CANARY", request_body=request_body, response_text=nr.response_text,
        env_attestation=nr.env_attestation, checker_sha1=check.request_sha1,
        stamp=args.stamp, line="netroom",
    )
    print(f"✅ 归档三件 base={anchor['archive_base']}")
    print(f"   request sha1={anchor['request_sha1']}")
    print(f"   response sha1={anchor['response_sha1']}")

    # 5) 验收数据
    print("═══ 段二首跑验收数据（判读/签字留 GM）═══")
    print(f"  模式：{nr.mode}｜模型请求档：{NETROOM_MODEL}·effort={NETROOM_EFFORT}")
    print("  ── 金丝雀答卷首 400 字（全文见归档 response）──")
    print("  " + nr.response_text[:400].replace("\n", "\n  "))
    if nr.usage:
        ti, to = nr.usage.get("input_tokens"), nr.usage.get("output_tokens")
        print("  ── 成本实测（真实计费读数）──")
        print(f"  input={ti} tok · output={to} tok"
              f"（内含 reasoning={nr.usage.get('reasoning_tokens')}）")
        if ti is not None and to is not None:
            cost = ti / 1e6 * PRICE_IN_PER_M + to / 1e6 * PRICE_OUT_PER_M
            print(f"  按 Sol 单价折算 ≈ ${cost:.4f}/次（替换 setup-guide 估算的首个实测点）")
    else:
        print("  ── 成本实测：mock 无用量读数（live 才有）──")
    print("─" * 40)
    print("后续（人工/CGM）：金丝雀判读+环境证明表核对→验收报告→GM 验收签字→T1/T4 现役。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
