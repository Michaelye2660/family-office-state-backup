"""出包检查器（-11①层1 / -12④ / -17①(a)）· 验收必备·无检查器不上线。

两道机械闸：
  1. sha1 恒等校验：request 体 sha1 vs 当期登记件 sha1——防出包漂移/中途改写。
  2. 禁词正则扫描 v2：绝对金额/身份/托管行/账户标识命中=拒发上呈 GM；百分比/权重/倍数放行。
任一闸不过 = 拒发（fail-closed）·不静默放行·上呈 GM。
"""
import hashlib
from dataclasses import dataclass, field

from config import BANNED_PATTERNS


def sha1_text(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()


@dataclass
class CheckResult:
    passed: bool
    request_sha1: str
    reasons: list = field(default_factory=list)   # 拒发原因（禁词命中/sha1不符）
    hits: list = field(default_factory=list)       # [(类别, 命中文本片段)]

    def escalation_note(self) -> str:
        """拒发时上呈 GM 的说明（不含命中原文·只报类别·防二次泄漏）。"""
        if self.passed:
            return ""
        cats = ", ".join(sorted({c for c, _ in self.hits})) or "sha1不符"
        return f"[出包检查器·拒发·上呈GM] request_sha1={self.request_sha1[:12]} 命中类别={cats} 原因={'; '.join(self.reasons)}"


def scan_banned(text: str):
    """扫描禁词·返回 [(类别, 片段)]。片段截断防日志二次泄漏。"""
    hits = []
    for cat, pat in BANNED_PATTERNS.items():
        for m in pat.finditer(text):
            frag = m.group(0)
            hits.append((cat, frag[:24]))
    return hits


def check_outbound(request_body: str, registered_sha1: str = None) -> CheckResult:
    """出包前强制调用。
    request_body : 将发往净室的完整请求体文本。
    registered_sha1 : 当期登记件（brief/EXT-R注入清单）的 sha1；None 则跳过恒等校验（仅禁词）。
    """
    req_sha = sha1_text(request_body)
    reasons, hits = [], []

    # 闸1：sha1 恒等
    if registered_sha1 is not None and req_sha != registered_sha1:
        reasons.append(f"sha1不符(出包漂移/中途改写)：req={req_sha[:12]} vs 登记={registered_sha1[:12]}")

    # 闸2：禁词扫描 v2
    hits = scan_banned(request_body)
    if hits:
        cats = sorted({c for c, _ in hits})
        reasons.append(f"禁词命中(材料边界·-12④)：{cats}")

    return CheckResult(passed=(len(reasons) == 0), request_sha1=req_sha, reasons=reasons, hits=hits)
