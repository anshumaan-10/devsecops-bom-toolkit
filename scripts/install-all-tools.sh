#!/usr/bin/env bash
# install-all-tools.sh — Install all free BOM tools
# Supports macOS (Homebrew) and Linux (apt/pip/npm)
# Usage: ./scripts/install-all-tools.sh

set -euo pipefail

OS="$(uname -s)"
echo "=== DevSecOps BOM Toolkit — Tool Installer (OS: $OS) ==="

install_brew() {
  if ! command -v brew &>/dev/null; then
    echo "[Homebrew] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_pip_pkg() { python3 -m pip install --quiet --upgrade "$1" && echo "  ✓ $1"; }
install_npm_pkg() { npm install -g --silent "$1" && echo "  ✓ $1"; }

echo ""
echo "--- SBOM Tools ---"
if [[ "$OS" == "Darwin" ]]; then
  install_brew
  brew install syft grype trivy 2>/dev/null && echo "  ✓ syft, grype, trivy"
  brew install microsoft/sbom/sbom-tool 2>/dev/null || true
elif command -v apt-get &>/dev/null; then
  curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
  curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
  curl -sSfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi
install_npm_pkg "@cyclonedx/cdxgen"

echo ""
echo "--- PBOM Tools ---"
if [[ "$OS" == "Darwin" ]]; then
  brew install actionlint cosign 2>/dev/null && echo "  ✓ actionlint, cosign"
fi
install_pip_pkg "zizmor"

echo ""
echo "--- CBOM Tools ---"
install_pip_pkg "detect-secrets"
install_pip_pkg "cryptolyzer"
install_pip_pkg "semgrep"
if [[ "$OS" == "Darwin" ]]; then
  brew install gitleaks trufflesecurity/trufflehog/trufflehog 2>/dev/null && echo "  ✓ gitleaks, trufflehog"
fi

echo ""
echo "--- MBOM Tools ---"
install_pip_pkg "modelscan"
install_pip_pkg "mlflow"
install_pip_pkg "dvc"
install_pip_pkg "model-signing"

echo ""
echo "--- AIBOM Tools ---"
install_pip_pkg "llm-guard"
install_pip_pkg "guardrails-ai"
install_pip_pkg "garak"
install_npm_pkg "promptfoo"

echo ""
echo "--- SaaSBOM Tools ---"
install_pip_pkg "prowler"
install_pip_pkg "scoutsuite"
if [[ "$OS" == "Darwin" ]]; then
  brew install turbot/tap/steampipe 2>/dev/null && echo "  ✓ steampipe"
fi

echo ""
echo "--- OBOM Tools ---"
if [[ "$OS" == "Darwin" ]]; then
  brew install kube-bench goodwithtech/r/dockle 2>/dev/null && echo "  ✓ kube-bench, dockle"
fi
install_pip_pkg "kube-hunter"

echo ""
echo "--- EBOM Tools ---"
install_pip_pkg "checkov"
install_pip_pkg "terrascan"
if [[ "$OS" == "Darwin" ]]; then
  brew install tfsec kubescape terraform-docs infracost conftest 2>/dev/null && \
    echo "  ✓ tfsec, kubescape, terraform-docs, infracost, conftest"
fi

echo ""
echo "=== Installation complete! Run './scripts/generate-all-boms.sh' to generate all BOMs ==="
