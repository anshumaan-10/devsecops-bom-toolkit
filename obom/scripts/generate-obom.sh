#!/usr/bin/env bash
# generate-obom.sh — Inventory operational assets (containers, k8s, cloud)
# Usage: ./generate-obom.sh <image-or-cluster> [output-dir]
# Example: ./generate-obom.sh nginx:latest ./output

set -euo pipefail

TARGET="${1:-nginx:latest}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== OBOM — Operations BOM Generation for: $TARGET ==="

# --- Trivy: scan container image ---
if command -v trivy &>/dev/null; then
  echo "[Trivy] Scanning container image for vulnerabilities..."
  trivy image --format cyclonedx --output "${OUTPUT_DIR}/obom-trivy-${TS}.cdx.json" \
    "$TARGET" 2>/dev/null || \
  trivy image --format json --output "${OUTPUT_DIR}/obom-trivy-${TS}.json" \
    "$TARGET" 2>/dev/null || true
  echo "[Trivy] Saved: obom-trivy-${TS}.cdx.json"

  # --- Trivy k8s scan ---
  if kubectl cluster-info &>/dev/null 2>&1; then
    echo "[Trivy k8s] Scanning Kubernetes cluster..."
    trivy k8s --report summary cluster \
      --format json --output "${OUTPUT_DIR}/obom-k8s-${TS}.json" 2>/dev/null || true
    echo "[Trivy k8s] Saved: obom-k8s-${TS}.json"
  fi
else
  echo "[Trivy] Not installed. Run: brew install trivy"
fi

# --- Syft: generate SBOM for container ---
if command -v syft &>/dev/null; then
  echo "[Syft] Generating OBOM (container SBOM)..."
  syft "$TARGET" -o cyclonedx-json="${OUTPUT_DIR}/obom-syft-${TS}.cdx.json"
  echo "[Syft] Saved: obom-syft-${TS}.cdx.json"
else
  echo "[Syft] Not installed. Run: brew install syft"
fi

# --- Dockle: container image security lint ---
if command -v dockle &>/dev/null; then
  echo "[Dockle] Linting container image..."
  dockle --format json --output "${OUTPUT_DIR}/obom-dockle-${TS}.json" \
    "$TARGET" 2>/dev/null || true
  echo "[Dockle] Saved: obom-dockle-${TS}.json"
else
  echo "[Dockle] Not installed. Run: brew install goodwithtech/r/dockle"
fi

# --- kube-bench: CIS k8s benchmark ---
if command -v kube-bench &>/dev/null && kubectl cluster-info &>/dev/null 2>&1; then
  echo "[kube-bench] Running CIS Kubernetes benchmark..."
  kube-bench run --targets node --json \
    > "${OUTPUT_DIR}/obom-kubebench-${TS}.json" 2>/dev/null || true
  echo "[kube-bench] Saved: obom-kubebench-${TS}.json"
else
  command -v kube-bench &>/dev/null || echo "[kube-bench] Not installed. Run: brew install kube-bench"
fi

# --- Inventory running Docker containers ---
if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
  echo "[Docker] Inventorying running containers..."
  docker ps --format '{{json .}}' \
    | python3 -c "import sys,json; print(json.dumps([json.loads(l) for l in sys.stdin if l.strip()], indent=2))" \
    > "${OUTPUT_DIR}/obom-containers-${TS}.json" 2>/dev/null || true
  echo "[Docker] Saved: obom-containers-${TS}.json"
fi

echo "=== OBOM generation complete. Output: ${OUTPUT_DIR} ==="
