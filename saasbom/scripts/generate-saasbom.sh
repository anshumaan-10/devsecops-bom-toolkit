#!/usr/bin/env bash
# generate-saasbom.sh — Discover and audit SaaS services in use
# Usage: ./generate-saasbom.sh [source-dir] [output-dir]

set -euo pipefail

SOURCE_DIR="${1:-.}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== SaaSBOM — SaaS BOM Generation ==="

# --- Discover SaaS API endpoints in source code ---
echo "[Discovery] Scanning source for SaaS API endpoints and keys..."

SAAS_PATTERNS=(
  "salesforce\\.com"
  "slack\\.com/api"
  "api\\.github\\.com"
  "googleapis\\.com"
  "api\\.stripe\\.com"
  "api\\.sendgrid\\.com"
  "hooks\\.slack\\.com"
  "api\\.twilio\\.com"
  "api\\.hubspot\\.com"
  "atlassian\\.net"
  "zendesk\\.com"
  "api\\.notion\\.so"
  "api\\.openai\\.com"
  "api\\.anthropic\\.com"
)

PATTERN=$(IFS="|"; echo "${SAAS_PATTERNS[*]}")

grep -rE "$PATTERN" "$SOURCE_DIR" \
  --include="*.{js,ts,py,go,java,rb,env,yaml,yml,json,tf,toml}" \
  -l 2>/dev/null \
  > "${OUTPUT_DIR}/saasbom-files-${TS}.txt" || true

echo "[Discovery] Files with SaaS references:"
cat "${OUTPUT_DIR}/saasbom-files-${TS}.txt" 2>/dev/null || echo "  (none found)"

# --- truffleHog: detect SaaS API keys ---
if command -v trufflehog &>/dev/null; then
  echo "[truffleHog] Scanning for exposed SaaS credentials..."
  trufflehog git "file://${SOURCE_DIR}" --only-verified \
    --json 2>/dev/null \
    > "${OUTPUT_DIR}/saasbom-secrets-${TS}.json" || true
  echo "[truffleHog] Saved: saasbom-secrets-${TS}.json"
else
  echo "[truffleHog] Not installed. Run: brew install trufflesecurity/trufflehog/trufflehog"
fi

# --- Prowler: cloud SaaS security checks (if AWS creds available) ---
if command -v prowler &>/dev/null && aws sts get-caller-identity &>/dev/null 2>&1; then
  echo "[Prowler] Running AWS SaaS security checks..."
  prowler aws --services s3 iam sts --output-formats json \
    --output-directory "${OUTPUT_DIR}" 2>/dev/null || true
  echo "[Prowler] Output in: ${OUTPUT_DIR}"
else
  if ! command -v prowler &>/dev/null; then
    echo "[Prowler] Not installed. Run: pip install prowler"
  else
    echo "[Prowler] AWS credentials not configured. Run: aws configure"
  fi
fi

# --- Generate SaaSBOM template ---
echo "[Template] Generating SaaSBOM CycloneDX template..."
cat > "${OUTPUT_DIR}/saasbom-template-${TS}.json" << 'EOF'
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "version": 1,
  "metadata": {
    "timestamp": "TIMESTAMP",
    "tools": [{ "name": "devsecops-bom-toolkit", "version": "1.0.0" }]
  },
  "components": [
    {
      "type": "service",
      "bom-ref": "saas-service-1",
      "name": "SAAS_SERVICE_NAME",
      "version": "SAAS_SERVICE_VERSION",
      "provider": { "name": "VENDOR_NAME" },
      "endpoints": ["https://api.example.com"],
      "authenticated": true,
      "data": [
        {
          "classification": "CLASSIFICATION",
          "flow": "bi-directional|inbound|outbound"
        }
      ]
    }
  ]
}
EOF
echo "[Template] Saved: saasbom-template-${TS}.json"

echo "=== SaaSBOM generation complete. Output: ${OUTPUT_DIR} ==="
