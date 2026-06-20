#!/usr/bin/env bash
# generate-ibom.sh — Inventory infrastructure assets and scan IaC configs
# Usage: ./generate-ibom.sh [iac-dir] [output-dir]
# Example: ./generate-ibom.sh ./terraform ./output/ibom

set -euo pipefail

IAC_DIR="${1:-.}"
OUTPUT_DIR="${2:-.}"
TS=$(date +%Y%m%d_%H%M%S)

echo "=== IBOM — Infrastructure BOM Generation for: $IAC_DIR ==="
mkdir -p "$OUTPUT_DIR"

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
if command -v tfsec &>/dev/null && find "$IAC_DIR" -name "*.tf" 2>/dev/null | grep -q .; then
  echo "[tfsec] Scanning Terraform configs..."
  tfsec "$IAC_DIR" --format json \
    --out "${OUTPUT_DIR}/ibom-tfsec-${TS}.json" 2>/dev/null || true
  echo "[tfsec] Saved: ibom-tfsec-${TS}.json"
else
  command -v tfsec &>/dev/null || echo "[tfsec] Not installed. Run: brew install tfsec"
fi

# --- Terrascan: multi-cloud IaC ---
if command -v terrascan &>/dev/null; then
  echo "[Terrascan] Scanning IaC configs..."
  terrascan scan -d "$IAC_DIR" -o json \
    > "${OUTPUT_DIR}/ibom-terrascan-${TS}.json" 2>/dev/null || true
  echo "[Terrascan] Saved: ibom-terrascan-${TS}.json"
else
  echo "[Terrascan] Not installed. Run: pip install terrascan"
fi

# --- terraform-docs: generate infrastructure documentation ---
if command -v terraform-docs &>/dev/null && find "$IAC_DIR" -name "*.tf" 2>/dev/null | grep -q .; then
  echo "[terraform-docs] Generating infrastructure documentation..."
  terraform-docs markdown table "$IAC_DIR" \
    > "${OUTPUT_DIR}/ibom-infra-docs-${TS}.md" 2>/dev/null || true
  echo "[terraform-docs] Saved: ibom-infra-docs-${TS}.md"
else
  command -v terraform-docs &>/dev/null || echo "[terraform-docs] Not installed. Run: brew install terraform-docs"
fi

# --- Infracost: cloud resource inventory ---
if command -v infracost &>/dev/null && find "$IAC_DIR" -name "*.tf" 2>/dev/null | grep -q .; then
  echo "[Infracost] Generating cloud resource inventory..."
  infracost breakdown --path "$IAC_DIR" --format json \
    > "${OUTPUT_DIR}/ibom-infracost-${TS}.json" 2>/dev/null || true
  echo "[Infracost] Saved: ibom-infracost-${TS}.json"
else
  command -v infracost &>/dev/null || echo "[Infracost] Not installed. Run: brew install infracost"
fi

# --- Steampipe: query live AWS infrastructure ---
if command -v steampipe &>/dev/null && aws sts get-caller-identity &>/dev/null 2>&1; then
  echo "[Steampipe] Querying live AWS infrastructure..."
  steampipe query "select name, vpc_id, cidr_block from aws_vpc" \
    --output json > "${OUTPUT_DIR}/ibom-vpcs-${TS}.json" 2>/dev/null || true
  steampipe query "select name, arn from aws_iam_role" \
    --output json > "${OUTPUT_DIR}/ibom-iam-roles-${TS}.json" 2>/dev/null || true
  steampipe query "select group_name, vpc_id, description from aws_vpc_security_group" \
    --output json > "${OUTPUT_DIR}/ibom-security-groups-${TS}.json" 2>/dev/null || true
  echo "[Steampipe] Saved: ibom-vpcs/iam-roles/security-groups-${TS}.json"
else
  command -v steampipe &>/dev/null || echo "[Steampipe] Not installed. Run: brew install turbot/tap/steampipe"
fi

# --- Kubescape: k8s infrastructure posture ---
if command -v kubescape &>/dev/null; then
  if kubectl cluster-info &>/dev/null 2>&1; then
    echo "[Kubescape] Scanning live Kubernetes infrastructure..."
    kubescape scan --format json \
      --output "${OUTPUT_DIR}/ibom-kubescape-${TS}.json" 2>/dev/null || true
    echo "[Kubescape] Saved: ibom-kubescape-${TS}.json"
  fi
  # Scan k8s YAML manifests
  if find "$IAC_DIR" \( -name "*.yaml" -o -name "*.yml" \) 2>/dev/null | grep -q .; then
    kubescape scan "$IAC_DIR" --format json \
      --output "${OUTPUT_DIR}/ibom-kubescape-manifests-${TS}.json" 2>/dev/null || true
  fi
else
  echo "[Kubescape] Not installed. Run: brew install kubescape"
fi

# --- Generate IBOM CycloneDX template ---
echo "[Template] Generating IBOM CycloneDX skeleton..."
cat > "${OUTPUT_DIR}/ibom-template-${TS}.json" << EOF
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "version": 1,
  "metadata": {
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "tools": [{ "name": "devsecops-bom-toolkit", "version": "1.0.0" }],
    "component": {
      "type": "platform",
      "name": "infrastructure-bom",
      "description": "Infrastructure Bill of Materials"
    }
  },
  "components": []
}
EOF
echo "[Template] Saved: ibom-template-${TS}.json"

echo "=== IBOM generation complete. Output: ${OUTPUT_DIR} ==="
