#!/usr/bin/env bash
# ============================================================================
# setup-moat-env.sh · moat 研究环境一键装配（ADJ-0716-06② · CC-0713-02终裁落地）
# ----------------------------------------------------------------------------
# 用途：为 moat 深查会话装配 edgartools（美股财报法证·EDGAR 一手文件），
#       走【独立 venv 隔离】以杜绝对系统环境 httpx 之污染
#       （mootdx / a-stock-data 域依赖系统 httpx，共存曾疑冲突——venv 隔离=结构性消雷正解）。
#
# 边界与护栏（写死·执行前须知）：
#   · 零秘密值：本脚本不读、不写、不传任何密钥/token（N8 秘密禁令无涉）。
#   · 网络域：仅 pypi（pip 装包）+ 既放行之 sec.gov 域（edgartools 运行时取 EDGAR）；
#             不触其他外网。
#   · 隔离：edgartools 只装进 venv-edgar，系统 python / 系统 httpx 零改动。
#   · 失败不阻断：装配失败仅本工具不可用，不阻断会话其余工作；失败如实申报（退出码非0）。
#   · ai-berkshire：不经本脚本——直接读 vendor/ai-berkshire/（已 vendored，无需安装）。
# ============================================================================
set -uo pipefail

VENV_DIR="${MOAT_VENV_DIR:-/home/claude/venv-edgar}"
EDGAR_VERSION="5.42.0"   # 锁版本（升级须走 ADJ）

echo "[setup-moat-env] venv 目标目录 = ${VENV_DIR}"
echo "[setup-moat-env] edgartools 锁版本 = ${EDGAR_VERSION}"

# 1) 建独立 venv（若已存在则复用）
if [ ! -d "${VENV_DIR}" ]; then
  python3 -m venv "${VENV_DIR}" || { echo "[setup-moat-env] ❌ venv 创建失败（不阻断会话其余工作）"; exit 1; }
  echo "[setup-moat-env] ✅ venv 已创建"
else
  echo "[setup-moat-env] venv 已存在，复用"
fi

# 2) 锁版本装 edgartools（仅 pypi）
"${VENV_DIR}/bin/pip" install --quiet --disable-pip-version-check "edgartools==${EDGAR_VERSION}" \
  || { echo "[setup-moat-env] ❌ edgartools==${EDGAR_VERSION} 装配失败（网络/pypi？如实申报，不阻断）"; exit 2; }
echo "[setup-moat-env] ✅ edgartools==${EDGAR_VERSION} 装配完成"

# 3) 最小冒烟：venv 内 import 一行
if "${VENV_DIR}/bin/python" -c "import edgar; print('[setup-moat-env] ✅ 冒烟通过 · edgartools import OK · venv=${VENV_DIR}')"; then
  echo "[setup-moat-env] === 装配成功 ==="
  echo "[setup-moat-env] 调用方式：用 ${VENV_DIR}/bin/python 运行 edgar 相关脚本（勿用系统 python）"
  exit 0
else
  echo "[setup-moat-env] ❌ 冒烟失败：edgartools 已装但 import 异常（如实申报，不阻断会话其余工作）"
  exit 3
fi
