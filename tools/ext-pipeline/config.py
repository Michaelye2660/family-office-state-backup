"""EXT 自动摆渡管道 · 配置层（ADJ-0719-17·task#46·真金审计线）

秘钥纪律（-10②(i)/-11①）：OPENAI_API_KEY 只从环境变量读·严禁入库入档·永不硬编码永不打印。
材料边界（-12④相对化）：仓位百分比/组合权重/估值倍数放行·绝对金额/身份/托管行拒发。
"""
import os
import re

# ── 净室线模型（成本申报见 docs/ext/pipeline-setup-guide.md）──
NETROOM_MODEL = "gpt-5.6"          # 硬净室=每次全新无状态调用
NETROOM_EFFORT = "high"            # Thinking 高 effort（EXT 审计建议档）

# ── 秘钥（只从环境读·不落盘不打印）──
def get_api_key():
    key = os.environ.get("OPENAI_API_KEY")
    if not key:
        raise RuntimeError(
            "OPENAI_API_KEY 未配置（段二 live 需要）。段一干跑用 mock 模式不需 key。"
            "配置见 docs/ext/pipeline-setup-guide.md（只进环境变量·严禁入库）。"
        )
    return key

# ── 归档留痕根（主仓·request+response 全文+sha1 锚定）──
REPO_ROOT = os.environ.get("FO_REPO_ROOT", "/home/user/family-office-state")
ARCHIVE_DIR = os.path.join(REPO_ROOT, "docs", "ext", "pipeline-archive")
EXTR_DIET = os.path.join(REPO_ROOT, "docs", "ext", "EXT-R-diet.md")

# ── 出包检查器 · 禁词正则 v2（-12④相对化·任一命中=拒发上呈 GM）──
# 拒发类（fail-closed）：绝对金额 / 身份信息 / 托管行 / 账户标识
BANNED_PATTERNS = {
    # 美元绝对额：$1,000,000 / $1.5M / $2.3 billion / US$500k
    "usd_absolute": re.compile(
        r"(?:US)?\$\s?\d[\d,]*(?:\.\d+)?\s?(?:万|亿|千|百|million|billion|thousand|[MBKmbk])?\b"
    ),
    # 中文货币绝对额：1000万美元 / 3.5亿元 / 500万人民币 / 2亿港元
    "cny_absolute": re.compile(
        r"\d[\d,]*(?:\.\d+)?\s?(?:万|亿|千|百)?\s?(?:美元|美金|元|人民币|港元|港币|新元|新币|欧元|英镑|日元)"
    ),
    # 账户标识：账户号 / account number / 长数字串(≥8位·疑账号)
    "account_id": re.compile(
        r"(?:账户|帐户|账号|帐号)\s*[#:：]?\s*\w+|account\s*(?:number|no\.?|#)\s*[:：]?\s*\w+|\b\d{8,}\b",
        re.IGNORECASE,
    ),
    # 身份：email / 电话 / SSN 式
    "identity_pii": re.compile(
        r"[\w.+-]+@[\w-]+\.[\w.-]+|\b(?:\+?\d{1,3}[-\s]?)?(?:\(?\d{3}\)?[-\s]?)\d{3}[-\s]?\d{4}\b|\b\d{3}-\d{2}-\d{4}\b"
    ),
    # 托管行/身份关键词（配置式·命中即上呈人工判）
    "custodian_identity": re.compile(
        r"托管行|托管银行|custodian|开户行|Interactive\s*Brokers|盈透|嘉信|Charles\s*Schwab|Fidelity\s*托管|摩根大通托管|花旗托管|汇丰托管",
        re.IGNORECASE,
    ),
}

# 放行类（-12④明许·仅作文档说明·不参与拒发判定）：
#   仓位百分比  \d+%        组合权重  权重/weight \d+%      估值倍数  \d+x / \d+倍 / PE\d+
# 这些模式天然不被上面的拒发正则命中（无货币符/无账户/无身份），故无需显式白名单——
# 但保留说明以备审计：百分比/倍数=相对量·材料边界许可。
ALLOW_NOTE = "仓位百分比(\\d+%)/组合权重/估值倍数(\\d+x/\\d+倍/PE)=相对量·-12④许可·不触发拒发正则"

# ── 四档路由阈值 ──
NAV_PCT_T1_THRESHOLD = 0.005       # ≥0.5% 净值 → T1 事前必审
