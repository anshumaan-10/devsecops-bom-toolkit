#!/usr/bin/env bash
# generate-pbom.sh — Audit CI/CD pipeline security posture
# Usage: ./generate-pbom.sh <github-repo-slug> [workflow-dir]
# Example: ./generate-pbom.sh myorg/myrepo .github/workflows

set -euo pipefail

REPO="${1:-}"
WORKFLOW_DIR="${2:-.github/workflows}"
TS=$(date +%Y%m%d_%H%M%S)
OUTPUT="pbom-report-${TS}.json"

echo "=== PBOM — Pipeline BOM Generation ==="

# --- actionlint: lint workflow files ---
if command -v actionlint &>/dev/null && [[ -d "$WORKFLOW_DIR" ]]; then
  echo "[actionlint] Linting GitHub Actions workflows in ${WORKFLOW_DIR}..."
  actionlint "$WORKFLOW_DIR"/*.yml 2>&1 || true
else
  echo "[actionlint] Not installed. Run: brew install actionlint"
fi

# --- zizmor: security analysis of GitHub Actions ---
if command -v zizmor &>/dev/null && [[ -d "$WORKFLOW_DIR" ]]; then
  echo "[zizmor] Security analysis of GitHub Actions..."
  for wf in "${WORKFLOW_DIR}"/*.yml; do
    echo "  Scanning: $wf"
    zizmor "$wf" 2>&1 || true
  done
else
  echo "[zizmor] Not installed. Run: pip install zizmor"
fi

# --- Scorecard: pipeline/repo security health ---
if command -v scorecard &>/dev/null && [[ -n "$REPO" ]]; then
  echo "[Scorecard] Running security checks for: $REPO"
  scorecard --repo="github.com/${REPO}" \
    --checks=DependencyUpdateTool,PinnedDependencies,SAST,SignedReleases,Token-Permissions \
    --format=json > "$OUTPUT" 2>/dev/null || true
  echo "[Scorecard] Report saved: $OUTPUT"
else
  [[ -z "$REPO" ]] && echo "[Scorecard] Pass repo slug as first argument (e.g., myorg/myrepo)"
  ! command -v scorecard &>/dev/null && echo "[Scorecard] Not installed. Run: brew install scorecard"
fi

echo "=== PBOM audit complete ==="
