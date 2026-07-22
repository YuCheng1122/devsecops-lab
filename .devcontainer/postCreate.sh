#!/usr/bin/env bash
set -uo pipefail

pip install --upgrade -r requirements.txt pip-audit semgrep pre-commit

GITLEAKS_VERSION="8.18.2"
ARCH="$(dpkg --print-architecture)"
[ "$ARCH" = "amd64" ] && GL_ARCH="x64" || GL_ARCH="arm64"

if curl -sSL -o /tmp/gitleaks.tar.gz \
  "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_${GL_ARCH}.tar.gz"; then
  sudo tar -xzf /tmp/gitleaks.tar.gz -C /usr/local/bin gitleaks
  sudo chmod +x /usr/local/bin/gitleaks
  echo "gitleaks ${GITLEAKS_VERSION} installed via GitHub Releases binary"
else
  echo "WARNING: 下載固定版本二進位檔失敗，改用 apt 版本 gitleaks（版本可能不是 8.18.2）"
  sudo apt-get update -qq && sudo apt-get install -y gitleaks
fi

echo "=== 版本檢查 ==="
gitleaks version
pip-audit --version
semgrep --version
pre-commit --version
