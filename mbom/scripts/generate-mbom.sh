#!/usr/bin/env bash
# generate-mbom.sh — Inventory ML models and scan for security issues
# Usage: ./generate-mbom.sh <models-dir> [output-dir]

set -euo pipefail

MODELS_DIR="${1:-./models}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== MBOM — ML BOM Generation for: $MODELS_DIR ==="

# --- ModelScan: security scan ML model files ---
if command -v modelscan &>/dev/null || python3 -c "import modelscan" 2>/dev/null; then
  echo "[ModelScan] Scanning ML model files for security issues..."
  python3 -m modelscan.main scan -p "$MODELS_DIR" \
    -r "${OUTPUT_DIR}/mbom-modelscan-${TS}.json" 2>/dev/null || \
  modelscan scan -p "$MODELS_DIR" 2>/dev/null || true
  echo "[ModelScan] Saved: mbom-modelscan-${TS}.json"
else
  echo "[ModelScan] Not installed. Run: pip install modelscan"
fi

# --- cdxgen: generate ML BOM ---
if command -v cdxgen &>/dev/null; then
  echo "[cdxgen] Generating ML BOM..."
  cdxgen --type ml -o "${OUTPUT_DIR}/mbom-cdxgen-${TS}.json" "$MODELS_DIR" 2>/dev/null || true
  echo "[cdxgen] Saved: mbom-cdxgen-${TS}.json"
else
  echo "[cdxgen] Not installed. Run: npm install -g @cyclonedx/cdxgen"
fi

# --- DVC: list tracked data/models ---
if command -v dvc &>/dev/null && [[ -f .dvc/config ]]; then
  echo "[DVC] Listing tracked data and model artifacts..."
  dvc list . --dvc-only --recursive 2>/dev/null \
    > "${OUTPUT_DIR}/mbom-dvc-${TS}.txt" || true
  echo "[DVC] Saved: mbom-dvc-${TS}.txt"
else
  echo "[DVC] Not initialized or not installed. Run: pip install dvc && dvc init"
fi

# --- Collect model file hashes for integrity ---
echo "[Integrity] Computing SHA-256 hashes for model files..."
find "$MODELS_DIR" \( -name "*.pkl" -o -name "*.h5" -o -name "*.pt" -o \
  -name "*.pth" -o -name "*.onnx" -o -name "*.joblib" -o -name "*.bin" \) \
  -exec shasum -a 256 {} \; 2>/dev/null \
  > "${OUTPUT_DIR}/mbom-hashes-${TS}.txt" || true
echo "[Integrity] Saved: mbom-hashes-${TS}.txt"

echo "=== MBOM generation complete. Output: ${OUTPUT_DIR} ==="
