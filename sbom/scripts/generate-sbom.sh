#!/usr/bin/env bash
# generate-sbom.sh — Generate SBOM using Syft, Trivy, and cdxgen
# Usage: ./generate-sbom.sh <target> [output-dir]
# target: container image (nginx:latest), directory path, or archive

set -euo pipefail

TARGET="${1:-nginx:latest}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== SBOM Generation for: $TARGET ==="

# --- Syft (CycloneDX JSON) ---
if command -v syft &>/dev/null; then
  echo "[Syft] Generating CycloneDX SBOM..."
  syft "$TARGET" -o cyclonedx-json="${OUTPUT_DIR}/sbom-syft-${TS}.cdx.json"
  echo "[Syft] Saved: sbom-syft-${TS}.cdx.json"
else
  echo "[Syft] Not installed. Run: brew install syft"
fi

# --- Trivy (SPDX JSON) ---
if command -v trivy &>/dev/null; then
  echo "[Trivy] Generating SPDX SBOM..."
  trivy image --format spdx-json --output "${OUTPUT_DIR}/sbom-trivy-${TS}.spdx.json" "$TARGET" 2>/dev/null || \
  trivy fs   --format spdx-json --output "${OUTPUT_DIR}/sbom-trivy-${TS}.spdx.json" "$TARGET"
  echo "[Trivy] Saved: sbom-trivy-${TS}.spdx.json"
else
  echo "[Trivy] Not installed. Run: brew install trivy"
fi

# --- cdxgen (CycloneDX JSON for source directories) ---
if command -v cdxgen &>/dev/null && [[ -d "$TARGET" ]]; then
  echo "[cdxgen] Generating CycloneDX SBOM from source..."
  cdxgen "$TARGET" -o "${OUTPUT_DIR}/sbom-cdxgen-${TS}.cdx.json"
  echo "[cdxgen] Saved: sbom-cdxgen-${TS}.cdx.json"
elif ! command -v cdxgen &>/dev/null; then
  echo "[cdxgen] Not installed. Run: npm install -g @cyclonedx/cdxgen"
fi

# --- Vulnerability scan with Grype ---
if command -v grype &>/dev/null && [[ -f "${OUTPUT_DIR}/sbom-syft-${TS}.cdx.json" ]]; then
  echo "[Grype] Scanning SBOM for vulnerabilities..."
  grype "sbom:${OUTPUT_DIR}/sbom-syft-${TS}.cdx.json" -o table
fi

echo "=== SBOM generation complete. Output: ${OUTPUT_DIR} ==="
