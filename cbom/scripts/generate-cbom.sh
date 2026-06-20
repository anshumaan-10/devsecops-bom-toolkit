#!/usr/bin/env bash
# generate-cbom.sh — Inventory cryptographic assets in a codebase
# Usage: ./generate-cbom.sh <source-dir> [output-dir]

set -euo pipefail

SOURCE_DIR="${1:-.}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== CBOM — Cryptography BOM Generation for: $SOURCE_DIR ==="

# --- cdxgen CBOM ---
if command -v cdxgen &>/dev/null; then
  echo "[cdxgen] Generating CBOM (cryptography type)..."
  cdxgen --type cryptography -o "${OUTPUT_DIR}/cbom-cdxgen-${TS}.json" "$SOURCE_DIR" || true
  echo "[cdxgen] Saved: cbom-cdxgen-${TS}.json"
else
  echo "[cdxgen] Not installed. Run: npm install -g @cyclonedx/cdxgen"
fi

# --- detect-secrets: find hardcoded secrets ---
if command -v detect-secrets &>/dev/null; then
  echo "[detect-secrets] Scanning for hardcoded secrets..."
  detect-secrets scan "$SOURCE_DIR" > "${OUTPUT_DIR}/secrets-baseline-${TS}.json"
  echo "[detect-secrets] Saved: secrets-baseline-${TS}.json"
else
  echo "[detect-secrets] Not installed. Run: pip install detect-secrets"
fi

# --- Gitleaks: git secrets scan ---
if command -v gitleaks &>/dev/null; then
  echo "[Gitleaks] Scanning git history for secrets..."
  gitleaks detect --source "$SOURCE_DIR" \
    --report-format json \
    --report-path "${OUTPUT_DIR}/gitleaks-${TS}.json" \
    --no-git 2>/dev/null || true
  echo "[Gitleaks] Saved: gitleaks-${TS}.json"
else
  echo "[Gitleaks] Not installed. Run: brew install gitleaks"
fi

# --- Semgrep: weak crypto patterns ---
if command -v semgrep &>/dev/null; then
  echo "[Semgrep] Scanning for weak cryptography patterns..."
  semgrep --config="p/cryptography" --json \
    --output "${OUTPUT_DIR}/semgrep-crypto-${TS}.json" \
    "$SOURCE_DIR" 2>/dev/null || true
  echo "[Semgrep] Saved: semgrep-crypto-${TS}.json"
else
  echo "[Semgrep] Not installed. Run: brew install semgrep"
fi

echo "=== CBOM generation complete. Output: ${OUTPUT_DIR} ==="
