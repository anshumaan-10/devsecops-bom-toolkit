#!/usr/bin/env bash
# generate-hbom.sh — Collect hardware inventory from local system
# Usage: ./generate-hbom.sh [output-dir]

set -euo pipefail

OUTPUT_DIR="${1:-.}"
TS=$(date +%Y%m%d_%H%M%S)
HBOM_FILE="${OUTPUT_DIR}/hbom-${TS}.json"

echo "=== HBOM — Hardware BOM Generation ==="

# --- lshw: comprehensive hardware list ---
if command -v lshw &>/dev/null; then
  echo "[lshw] Generating hardware inventory..."
  sudo lshw -json 2>/dev/null > "${OUTPUT_DIR}/hbom-lshw-${TS}.json" || \
  lshw -json 2>/dev/null > "${OUTPUT_DIR}/hbom-lshw-${TS}.json" || true
  echo "[lshw] Saved: hbom-lshw-${TS}.json"
else
  echo "[lshw] Not installed. Run: brew install lshw  OR  apt install lshw"
fi

# --- dmidecode: BIOS/hardware info ---
if command -v dmidecode &>/dev/null; then
  echo "[dmidecode] Collecting BIOS/hardware details..."
  for dtype in system bios processor memory baseboard; do
    sudo dmidecode --type "$dtype" > "${OUTPUT_DIR}/hbom-dmi-${dtype}-${TS}.txt" 2>/dev/null || true
  done
  echo "[dmidecode] Saved: hbom-dmi-*-${TS}.txt"
else
  echo "[dmidecode] Not installed. Run: apt install dmidecode"
fi

# --- inxi: quick system summary ---
if command -v inxi &>/dev/null; then
  echo "[inxi] Generating system summary..."
  inxi -F -xxx 2>/dev/null > "${OUTPUT_DIR}/hbom-inxi-${TS}.txt" || true
  echo "[inxi] Saved: hbom-inxi-${TS}.txt"
else
  echo "[inxi] Not installed. Run: apt install inxi"
fi

# --- fwupd: firmware inventory ---
if command -v fwupdmgr &>/dev/null; then
  echo "[fwupd] Collecting firmware device inventory..."
  fwupdmgr get-devices --json 2>/dev/null > "${OUTPUT_DIR}/hbom-firmware-${TS}.json" || true
  echo "[fwupd] Saved: hbom-firmware-${TS}.json"
else
  echo "[fwupd] Not installed. Run: apt install fwupd"
fi

# --- macOS system_profiler (fallback for macOS) ---
if [[ "$(uname)" == "Darwin" ]]; then
  echo "[system_profiler] Generating macOS hardware report..."
  system_profiler SPHardwareDataType SPMemoryDataType SPStorageDataType \
    -json 2>/dev/null > "${OUTPUT_DIR}/hbom-macos-${TS}.json" || true
  echo "[system_profiler] Saved: hbom-macos-${TS}.json"
fi

echo "=== HBOM generation complete. Output: ${OUTPUT_DIR} ==="
