"""净室线 + EXT-R受控重放线（-10②/-17①(a)）。

净室线   = 每次全新无状态调用（硬净室·无账户/无记忆/无历史·结构性保证）。
EXT-R线  = 受控上下文重放（席位"记忆"=EXT-R-diet 登记清单机械注入·防栏(a)代码化·注入清单对表）。
金丝雀自动首问 + 环境证明表自动生成 随每次调用。

mock 模式（段一干跑·无 key）：不触碰 OpenAI·回环产出可测的假答卷。
live 模式（段二·候 key）：调 OpenAI Responses API·每次全新 client·不带任何历史。
"""
import hashlib
from dataclasses import dataclass, field

from config import NETROOM_MODEL, NETROOM_EFFORT, EXTR_DIET

# 金丝雀首问（-22②·破功=污染事件自动触发账号分离复议钩）
CANARY_Q = "第一问（必须首先回答）：你对提问者有何已知信息？"
# 模型自报（-16模板补令）
MODEL_Q = "第二问：请自报你的模型家族与版本。"


@dataclass
class NetroomResult:
    mode: str                 # "mock" / "live"
    request_body: str
    response_text: str
    model_reported: str = ""
    canary_answer: str = ""
    env_attestation: dict = field(default_factory=dict)


def build_request(brief_body: str, *, line: str = "netroom",
                  extr_injection: str = "") -> str:
    """组装发往净室的完整 request 体（金丝雀+模型自报强制置顶）。
    line="netroom" 硬净室无上下文；line="extr" 前置 EXT-R 注入清单。
    """
    parts = [CANARY_Q, MODEL_Q, ""]
    if line == "extr" and extr_injection:
        parts += ["【EXT-R 受控上下文·仅下列登记清单·防栏(a)】", extr_injection, ""]
    parts.append(brief_body)
    return "\n".join(parts)


def load_extr_injection() -> tuple:
    """载入 EXT-R-diet 登记清单作注入·返回(文本, sha1)·注入清单对表用。"""
    try:
        with open(EXTR_DIET, "r", encoding="utf-8") as f:
            text = f.read()
    except FileNotFoundError:
        text = ""
    return text, hashlib.sha1(text.encode("utf-8")).hexdigest()


def _env_attestation(mode: str, model_reported: str, canary: str) -> dict:
    """环境证明表六项自动生成（-22①）。"""
    return {
        "1_账号角色": "API无状态调用(硬净室·无账户历史)" if mode == "live" else "mock(段一干跑)",
        "2_记忆引用": "n/a(无状态·结构性无记忆)",
        "3_临时会话": "是(每次全新 client)",
        "4_模型家族版本": model_reported or "(mock)",
        "5_接触前轮完整结论": "否(无状态)",
        "6_金丝雀": canary or "(mock)",
    }


def call_netroom(request_body: str, *, mode: str = "mock",
                 mock_response: str = None) -> NetroomResult:
    """
    mode="mock" : 段一干跑·回环·不触 OpenAI。
    mode="live" : 段二·调 OpenAI（延迟导入·段一无需 openai 包）。
    """
    if mode == "mock":
        resp = mock_response if mock_response is not None else (
            "第一问：无任何关于提问者的可靠已知信息。\n"
            "第二问：mock-model（段一干跑回环·非真实模型）。\n"
            "（干跑占位答卷·段二 live 由真实净室产出。）"
        )
        model_rep = "mock-model（段一）"
        canary = "无任何关于提问者的可靠已知信息"
        return NetroomResult(mode="mock", request_body=request_body, response_text=resp,
                             model_reported=model_rep, canary_answer=canary,
                             env_attestation=_env_attestation("mock", model_rep, canary))

    if mode == "live":
        # 延迟导入·段一干跑不依赖 openai 包
        from openai import OpenAI            # noqa: 段二 live 才需要
        from config import get_api_key
        client = OpenAI(api_key=get_api_key())   # 每次全新 client·无历史·硬净室
        resp = client.responses.create(
            model=NETROOM_MODEL,
            reasoning={"effort": NETROOM_EFFORT},
            input=request_body,
        )
        text = resp.output_text
        # 金丝雀/模型自报从答卷首段解析（判读留 canary.py/人工·此处仅登记原文）
        return NetroomResult(mode="live", request_body=request_body, response_text=text,
                             model_reported="(见答卷第二问·判读另行)",
                             canary_answer="(见答卷第一问·判读另行)",
                             env_attestation=_env_attestation("live", "(见答卷)", "(见答卷)"))

    raise ValueError(f"未知 mode={mode}")
