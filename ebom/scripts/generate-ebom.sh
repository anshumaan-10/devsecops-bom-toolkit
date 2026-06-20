#!/usr/bin/env bash
# generate-ebom.sh — Scan environment configurations and IaC for security issues
# Usage: ./generate-ebom.sh [iac-dir] [output-dir]

set -euo pipefail

IAC_DIR="${1:-.}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== EBOM — Environment BOM Generation for: $IAC_DIR ==="

# --- Checkov: IaC security scanning ---
if command -v checkov &>/dev/null; then
  echo "[Checkov] Scanning IaC for security issues..."
  checkov -d "$IAC_DIR" \
    --output json \
    --output-file-path "${OUTPUT_DIR}" \
    --quiet 2>/dev/null || true
  echo "[Checkov] Results in: ${OUTPUT_DIR}/results_json.json"
else
  echo "[Checkov] Not installed. Run: pip install checkov"
fi

# --- tfsec: Terraform static analysis ---
if command -v tfsec &>/dev/null && find "$IAC_DIR" -name "*.tf" | grep -q .; then
  echo "[tfsec] Scanning Terraform configs..."
  tfsec "$IAC_DIR" --format json \
    --out "${OUTPUT_DIR}/ebom-tfsec-${TS}.json" 2>/dev/null || true
  echo "[tfsec] Saved: ebom-tfsec-${TS}.json"
else
  command -v tfsec &>/dev/null || echo "[tfsec] Not installed. Run: brew install tfsec"
fi

# --- Kubescape: k8s environment posture ---
if command -v kubescape &>/dev/null; then
  if kubectl cluster-info &>/dev/null 2>&1; then
    echo "[Kubescape] Scanning live cluster..."
    kubescape scan --format json \
      --output "${OUTPUT_DIR}/ebom-kubescape-cluster-${TS}.json" 2>/dev/null || true
    echo "[Kubescape] Saved: ebom-kubescape-cluster-${TS}.json"
  fi
  # Scan k8s YAML files
  if find "$IAC_DIR" -name "*.yaml" -o -name "*.yml" | grep -q .; then
    echo "[Kubescape] Scanning k8s YAML manifests..."
    kubescape scan "$IAC_DIR" --format json \
      --output "${OUTPUT_DIR}/ebom-kubescape-manifests-${TS}.json" 2>/dev/null || true
    echo "[Kubescape] Saved: ebom-kubescape-manifests-${TS}.json"
  fi
else
  echo "[Kubescape] Not installed. Run: brew install kubescape"
fi

# --- terraform-docs: generate environment documentation ---
if command -v terraform-docs &>/dev/null && find "$IAC_DIR" -name "*.tf" | grep -q .; then
  echo "[terraform-docs] Generating environment documentation..."
  terraform-docs markdown table "$IAC_DIR" \
    > "${OUTPUT_DIR}/ebom-infra-docs-${TS}.md" 2>/dev/null || true
  echo "[terraform-docs] Saved: ebom-infra-docs-${TS}.md"
else
  command -v terraform-docs &>/dev/null || echo "[terraform-docs] Not installed. Run: brew install terraform-docs"
fi

# --- detect-secrets: scan environment files ---
if command -v detect-secrets &>/dev/null; then
  echo "[detect-secrets] Scanning env/config files for secrets..."
  detect-secrets scan "$IAC_DIR" \
    --exclude-files '\.git/.*' \
    > "${OUTPUT_DIR}/ebom-secrets-${TS}.json" 2>/dev/null || true
  echo "[detect-secrets] Saved: ebom-secrets-${TS}.json"
else
  echo "[detect-secrets] Not installed. Run: pip install detect-secrets"
fi

echo "=== EBOM generation complete. Output: ${OUTPUT_DIR} ==="
