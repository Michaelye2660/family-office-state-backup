"""四档路由（T1-T4·charter §二/§五·-17①(a)）。

T1 事前必审  ：新开仓/清仓/单笔≥0.5%净值 → 自动送净室→独立意见→GM逐条回应→双意见并呈委托人终裁·互不见稿·分歧>一档标红。
T2 事后周审  ：当周全部已执行动作·匿名化汇总→意见入周复盘+喂N14。
T3 预授权豁免：已过T1之阶梯设计单批执行不重审（防拖延）·归T2兜底。
T4 委托人点审：委托人任何动作/计划前后缀「审」·无门槛/无类型限/无需理由→即时送净室双呈；
              两特护=(i)计划外默认冷却〔意见回来前不执行·"审但先做"可豁免入档〕(ii)疑虑登记〔季度命中率〕。
"""
from dataclasses import dataclass
from config import NAV_PCT_T1_THRESHOLD


@dataclass
class RouteDecision:
    tier: str            # T1 / T2 / T3 / T4
    must_review: bool    # 是否强制送审
    blocks_execution: bool  # 意见回来前是否冻结执行
    dual_present: bool   # 是否双意见并呈委托人终裁
    note: str


def route(*, kind: str, nav_fraction: float = 0.0,
          principal_flagged: bool = False,
          pre_authorized_ladder: bool = False) -> RouteDecision:
    """
    kind : "trade"（交易动作）/ "weekly"（周批）/ "principal_review"（委托人「审」）
    nav_fraction : 该动作占净值比例（0.005 = 0.5%）
    principal_flagged : 委托人后缀「审」触发 T4
    pre_authorized_ladder : 是否已过 T1 的阶梯设计单批（→T3 豁免）
    """
    # T4：委托人点审优先级最高（一字「审」压倒一切·无门槛）
    if kind == "principal_review" or principal_flagged:
        return RouteDecision("T4", must_review=True, blocks_execution=True, dual_present=True,
                             note="委托人点审·计划外默认冷却(意见回来前不执行·「审但先做」可豁免入档)+疑虑登记季度命中率")

    # T3：预授权阶梯豁免（已过 T1·单批不重审·归 T2 兜底）
    if kind == "trade" and pre_authorized_ladder:
        return RouteDecision("T3", must_review=False, blocks_execution=False, dual_present=False,
                             note="预授权豁免·已过T1阶梯设计单批不重审·归T2兜底")

    # T1：事前必审（新开仓/清仓/单笔≥0.5%净值）
    if kind == "trade" and nav_fraction >= NAV_PCT_T1_THRESHOLD:
        return RouteDecision("T1", must_review=True, blocks_execution=True, dual_present=True,
                             note=f"事前必审(≥{NAV_PCT_T1_THRESHOLD:.1%}净值)·双意见并呈·互不见稿·分歧>一档标红·GM逐条回应")

    # T2：事后周审（周批/低于阈值动作汇总）
    if kind == "weekly" or (kind == "trade" and nav_fraction < NAV_PCT_T1_THRESHOLD):
        return RouteDecision("T2", must_review=True, blocks_execution=False, dual_present=False,
                             note="事后周审·匿名化汇总·意见入周复盘+喂N14")

    raise ValueError(f"无法路由：kind={kind} nav_fraction={nav_fraction}")
