"""EXT 自动摆渡管道 · 编排器（-17①·task#46）。

一次往返编排：路由 → 组装 request → 出包检查（sha1恒等+禁词·验收必备）
             → 通过则调净室（mock/live）→ 归档留痕+sha1锚定。
出包检查不过 = 拒发·不调净室·上呈 GM（fail-closed·无检查器不上线）。
三层核验制挂接：层1=每次强制出包检查（本编排内置）；层2月度抽验/注入清单对表（verify.py）；层3=归档在库随时可查。
"""
from dataclasses import dataclass

import checker
import router
import netroom
import archive


class OutboundRejected(Exception):
    """出包检查拒发·上呈 GM·不静默放行。"""


@dataclass
class RoundtripResult:
    route: router.RouteDecision
    check: checker.CheckResult
    netroom_result: netroom.NetroomResult
    anchor: dict


def run_review(*, brief_body: str, kind: str, nav_fraction: float = 0.0,
               principal_flagged: bool = False, pre_authorized_ladder: bool = False,
               line: str = "netroom", registered_sha1: str = None,
               mode: str = "mock", mock_response: str = None,
               stamp: str = "unstamped") -> RoundtripResult:
    # 1) 四档路由
    decision = router.route(kind=kind, nav_fraction=nav_fraction,
                            principal_flagged=principal_flagged,
                            pre_authorized_ladder=pre_authorized_ladder)

    # 2) 组装 request（EXT-R 线前置注入清单·注入清单对表）
    extr_text, extr_sha = ("", None)
    if line == "extr":
        extr_text, extr_sha = netroom.load_extr_injection()
    request_body = netroom.build_request(brief_body, line=line, extr_injection=extr_text)

    # 3) 出包检查（验收必备·sha1恒等 registered_sha1 若给·禁词 v2）
    check = checker.check_outbound(request_body, registered_sha1=registered_sha1)
    if not check.passed:
        # 拒发·上呈 GM·不调净室
        raise OutboundRejected(check.escalation_note())

    # 4) 调净室（mock 段一 / live 段二）
    nr = netroom.call_netroom(request_body, mode=mode, mock_response=mock_response)

    # 5) 归档留痕 + sha1 锚定
    anchor = archive.archive_roundtrip(
        tier=decision.tier, request_body=request_body, response_text=nr.response_text,
        env_attestation=nr.env_attestation, checker_sha1=check.request_sha1,
        registered_sha1=registered_sha1, stamp=stamp, line=line, extr_injection_sha1=extr_sha,
    )
    return RoundtripResult(route=decision, check=check, netroom_result=nr, anchor=anchor)
