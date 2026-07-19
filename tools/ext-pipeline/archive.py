"""全程留痕（-11①层1尾 / 层3委托人查权 / -17①(a)）。

每次往返：request + response 全文归档主仓 + sha1 锚定·逐字·不可改。
自动化后可审计性 > 人肉摆渡（管道有档·复制粘贴无档）。
"""
import hashlib
import json
import os

from config import ARCHIVE_DIR


def _sha1(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()


def archive_roundtrip(*, tier: str, request_body: str, response_text: str,
                      env_attestation: dict, checker_sha1: str,
                      registered_sha1: str = None, stamp: str = "unstamped",
                      line: str = "netroom", extr_injection_sha1: str = None) -> dict:
    """归档一次往返·返回锚定记录（含 sha1）。
    stamp : 时间戳由调用方传入（脚本内 Date.now 禁用同理·外部注入·此处占位）。
    """
    os.makedirs(ARCHIVE_DIR, exist_ok=True)
    req_sha = _sha1(request_body)
    resp_sha = _sha1(response_text)
    record = {
        "tier": tier,
        "line": line,
        "stamp": stamp,
        "request_sha1": req_sha,
        "response_sha1": resp_sha,
        "checker_request_sha1": checker_sha1,
        "registered_sha1": registered_sha1,
        "extr_injection_sha1": extr_injection_sha1,
        "env_attestation": env_attestation,
    }
    base = f"{stamp}_{tier}_{req_sha[:12]}"
    # 三件：request 全文 / response 全文 / 锚定元数据
    with open(os.path.join(ARCHIVE_DIR, base + ".request.txt"), "w", encoding="utf-8") as f:
        f.write(request_body)
    with open(os.path.join(ARCHIVE_DIR, base + ".response.txt"), "w", encoding="utf-8") as f:
        f.write(response_text)
    with open(os.path.join(ARCHIVE_DIR, base + ".anchor.json"), "w", encoding="utf-8") as f:
        json.dump(record, f, ensure_ascii=False, indent=2)
    record["archive_base"] = base
    return record
