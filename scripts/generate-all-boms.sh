#!/usr/bin/env bash
# generate-all-boms.sh — Run all BOM generators for a project
# Usage: ./scripts/generate-all-boms.sh [project-dir] [output-dir]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="${1:-$PWD}"
OUTPUT_BASE="${2:-${REPO_ROOT}/output}"
TS=$(date +%Y%m%d_%H%M%S)

mkdir -p "${OUTPUT_BASE}"/{sbom,pbom,cbom,hbom,mbom,aibom,saasbom,obom,ebom}

echo "========================================"
echo " DevSecOps BOM Toolkit — All BOMs"
echo " Project : $PROJECT_DIR"
echo " Output  : $OUTPUT_BASE"
echo " Time    : $TS"
echo "========================================"

make_executable() { chmod +x "$1" 2>/dev/null || true; }

run_bom() {
  local name="$1"
  local script="${REPO_ROOT}/${name,,}/scripts/generate-${name,,}.sh"
  local out_dir="${OUTPUT_BASE}/${name,,}"
  echo ""
  echo "--- Generating $name ---"
  if [[ -f "$script" ]]; then
    make_executable "$script"
    bash "$script" "$PROJECT_DIR" "$out_dir" || true
  else
    echo "[SKIP] Script not found: $script"
  fi
}

run_bom "sbom"
run_bom "pbom"
run_bom "cbom"
run_bom "hbom"
run_bom "mbom"
run_bom "aibom"
run_bom "saasbom"
run_bom "obom"
run_bom "ebom"

echo ""
echo "========================================"
echo " All BOMs generated!"
echo " Output directory: $OUTPUT_BASE"
echo "========================================"
echo ""
echo " Summary:"
for bom in sbom pbom cbom hbom mbom aibom saasbom obom ebom; do
  count=$(find "${OUTPUT_BASE}/${bom}" -type f 2>/dev/null | wc -l | tr -d ' ')
  echo "   ${bom^^}: ${count} file(s)"
done
