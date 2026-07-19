"""段二 live 联调预检（-17①(b)·task#46·N8 秘钥纪律合规）。

四项检查·全过=exit 0·任一不过=exit 1：
  A. OPENAI_API_KEY 环境变量存在性（只报 有/无·永不打印值·永不打印长度片段）
  B. openai 包可导入（段二 live 依赖·requirements.txt）
  C. 出网连通性 api.openai.com（区分：可达〔未带 key 得 HTTP 401=正常〕
     vs 代理 403/连接失败=环境网络策略未放行·须委托人在环境设置加白名单）
  D. key 有效性（仅当 A+C 过）：GET /v1/models 带 Bearer·只报 HTTP 状态码
     （200=有效·401=key 无效或过期·其余如实报）

用法：python3 live_preflight.py
"""
import json
import os
import ssl
import sys
import urllib.error
import urllib.request

API_PROBE = "https://api.openai.com/v1/models"
TIMEOUT = 20


def _http_status(headers: dict) -> tuple:
    """GET API_PROBE·返回 (状态码 or None, 失败说明, error.code or "")。
    走环境代理(urllib 自动读 https_proxy)。
    error.code 取自平台错误体的结构化字段（如 invalid_api_key）·不含任何 key 片段（N8）。"""
    req = urllib.request.Request(API_PROBE, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
            return resp.status, "", ""
    except urllib.error.HTTPError as e:
        code = ""
        try:
            code = json.loads(e.read().decode("utf-8", "replace")).get(
                "error", {}).get("code") or ""
        except Exception:
            pass
        return e.code, "", code
    except urllib.error.URLError as e:
        return None, f"连接失败：{e.reason}", ""
    except (ssl.SSLError, OSError) as e:
        return None, f"连接失败：{e}", ""


def run_preflight() -> dict:
    r = {}

    # A. key 存在性（N8：只报有/无）
    r["A_key_present"] = bool(os.environ.get("OPENAI_API_KEY"))

    # B. openai 包
    try:
        import openai  # noqa: F401
        r["B_openai_pkg"] = True
        r["B_version"] = getattr(openai, "__version__", "?")
    except ImportError:
        r["B_openai_pkg"] = False

    # C. 出网连通性（不带 key·401=可达）
    status, err, _ = _http_status({})
    r["C_status"] = status
    r["C_err"] = err
    r["C_reachable"] = status in (200, 401, 403) and status is not None
    # 注：无 key 裸探正常应得 401；若 urllib 层报"连接失败/tunnel 403"=代理策略拦截。
    # 代理拦截表现为 URLError(OSError: Tunnel connection failed: 403)——归入 err。
    if err and "403" in err:
        r["C_reachable"] = False
        r["C_err"] += "（=出网网关策略拒绝 CONNECT·须环境网络白名单放行 api.openai.com）"

    # D. key 有效性（仅当 A+C 过·只报状态码+平台 error.code·N8 不打印值/长度/片段）
    r["D_status"] = None
    r["D_error_code"] = ""
    if r["A_key_present"] and r["C_reachable"]:
        key = os.environ["OPENAI_API_KEY"]
        # 形状自检（只产出布尔·辅助区分"值无效"vs"注入格式问题"）
        r["D_shape_clean"] = (key == key.strip()
                              and not any(c in key for c in "'\"\r\n")
                              and key.startswith("sk-"))
        status, err, ecode = _http_status({"Authorization": "Bearer " + key})
        r["D_status"] = status
        r["D_err"] = err
        r["D_error_code"] = ecode

    return r


def main() -> int:
    r = run_preflight()
    ok_a = r["A_key_present"]
    ok_b = r["B_openai_pkg"]
    ok_c = r["C_reachable"]
    ok_d = r["D_status"] == 200

    print("═══ 段二 live 联调预检（N8：不打印任何秘钥值）═══")
    print(f"  {'✅' if ok_a else '❌'} A key存在性  OPENAI_API_KEY："
          f"{'已注入环境' if ok_a else '未注入本容器环境（须在 claude.ai/code 环境变量配置·新容器生效）'}")
    print(f"  {'✅' if ok_b else '❌'} B openai包   "
          f"{'v' + r.get('B_version', '?') if ok_b else '未安装（pip install -r requirements.txt）'}")
    if ok_c:
        print(f"  ✅ C 出网连通  api.openai.com 可达（裸探 HTTP {r['C_status']}·未带key得401=正常）")
    else:
        print(f"  ❌ C 出网连通  api.openai.com 不可达：{r['C_err'] or 'HTTP ' + str(r['C_status'])}")
    if r["D_status"] is not None:
        label = {200: "key 有效", 401: "key 无效/过期/未授权（平台侧核对或重建）"}.get(
            r["D_status"], "如实报·人工判")
        extra = f"·error.code={r['D_error_code']}" if r.get("D_error_code") else ""
        shape = "" if r.get("D_shape_clean", True) else "·注意：key 形状异常（含空白/引号或非 sk- 前缀·疑注入格式问题）"
        print(f"  {'✅' if ok_d else '❌'} D key有效性  HTTP {r['D_status']}（{label}{extra}{shape}）")
    else:
        print("  ⏸️  D key有效性  跳过（前置 A/C 未过）")

    all_ok = ok_a and ok_b and ok_c and ok_d
    print("─" * 40)
    print("预检结论：" + ("✅ 全过·可执行 live_acceptance.py 首跑验收"
                     if all_ok else "❌ 未过·段二 live 阻塞（阻塞项见上·均须委托人环境侧动作）"))
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
