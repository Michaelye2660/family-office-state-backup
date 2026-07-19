"""三层核验制挂接（-11①层2·-17①(a)第7件）· GM 周期抽验接口。

层1=每次强制出包检查（pipeline 内置）·层3=归档在库随时可查（archive）。
本模块=层2 GM 周期抽验：
  - 月度抽验：归档 request 逐字 vs 登记版本 sha1 比读 + 禁词复扫 + response 完整性。
  - EXT-R 线注入清单对表：实际发送注入 sha1 = EXT-R-diet 登记清单 sha1 恒等（防未登记喂料）。
任何不符 = 管道暂停 + 事件立案（本模块只报·暂停/立案由 CGM+GM 执行）。
"""
import glob
import json
import os

import checker
import netroom
from config import ARCHIVE_DIR


def audit_archive(sample_bases=None) -> dict:
    """月度抽验：对归档往返件复核 sha1 + 禁词复扫。
    sample_bases : 指定 archive_base 列表；None 则全量。
    返回 {base: {ok, issues[]}}。
    """
    report = {}
    anchors = glob.glob(os.path.join(ARCHIVE_DIR, "*.anchor.json"))
    for ap in anchors:
        base = os.path.basename(ap)[:-len(".anchor.json")]
        if sample_bases and base not in sample_bases:
            continue
        issues = []
        with open(ap, encoding="utf-8") as f:
            rec = json.load(f)
        req_path = os.path.join(ARCHIVE_DIR, base + ".request.txt")
        resp_path = os.path.join(ARCHIVE_DIR, base + ".response.txt")
        # request 完整性：现盘 sha1 vs 锚定
        if os.path.exists(req_path):
            body = open(req_path, encoding="utf-8").read()
            if checker.sha1_text(body) != rec["request_sha1"]:
                issues.append("request sha1 漂移(归档件被改)")
            # 禁词复扫（层2 二次机械闸）
            hits = checker.scan_banned(body)
            if hits:
                issues.append(f"禁词复扫命中：{sorted({c for c,_ in hits})}")
        else:
            issues.append("request 归档缺失")
        # response 完整性
        if os.path.exists(resp_path):
            if checker.sha1_text(open(resp_path, encoding="utf-8").read()) != rec["response_sha1"]:
                issues.append("response sha1 漂移")
        else:
            issues.append("response 归档缺失")
        report[base] = {"ok": not issues, "issues": issues}
    return report


def verify_extr_injection() -> dict:
    """EXT-R 线注入清单对表：当前 EXT-R-diet sha1 vs 归档中 EXT-R 往返所录注入 sha1。
    防未登记喂料（层2·-11①）。
    """
    _, current_sha = netroom.load_extr_injection()
    mismatches = []
    for ap in glob.glob(os.path.join(ARCHIVE_DIR, "*.anchor.json")):
        rec = json.load(open(ap, encoding="utf-8"))
        if rec.get("line") == "extr" and rec.get("extr_injection_sha1"):
            if rec["extr_injection_sha1"] != current_sha:
                mismatches.append((os.path.basename(ap), rec["extr_injection_sha1"][:12]))
    return {"current_diet_sha1": current_sha, "mismatches": mismatches,
            "ok": not mismatches,
            "note": "注入 sha1 与当前 diet 不符=可能未登记喂料或 diet 事后被改·须查（非必然违规·diet 更新属正常·比对是为可审计）"}
