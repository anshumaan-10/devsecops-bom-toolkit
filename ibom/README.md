# IBOM — Infrastructure Bill of Materials

## What is IBOM?

**Infrastructure Bill of Materials** describes the infrastructure environments (Dev, Test, Staging, Prod) and their configurations, variables, secrets and policies — covering VPC/Subnets, IAM Roles, Security Groups, Databases, and Storage Buckets.

**Examples:** VPC / Subnets, IAM Roles, Security Groups, Databases, Storage Buckets

**Purpose:** Environment consistency, security and compliance.

---

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [Checkov](https://github.com/bridgecrewio/checkov) | `pip install checkov` | IaC security scanning (Terraform, Helm, K8s, CF) |
| [tfsec](https://github.com/aquasecurity/tfsec) | `brew install tfsec` | Terraform static analysis security scanner |
| [Kubescape](https://github.com/kubescape/kubescape) | `brew install kubescape` | K8s infrastructure security posture management |
| [conftest](https://github.com/open-policy-agent/conftest) | `brew install conftest` | Policy testing for infrastructure configs (OPA) |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | `brew install terraform-docs` | Generate docs from Terraform infrastructure configs |
| [Infracost](https://github.com/infracost/infracost) | `brew install infracost` | Cloud infrastructure resource inventory + cost |
| [Terrascan](https://github.com/tenable/terrascan) | `brew install terrascan` | Static code analysis for IaC |
| [Steampipe](https://github.com/turbot/steampipe) | `brew install turbot/tap/steampipe` | Query live AWS/Azure/GCP infrastructure via SQL |
| [CloudMapper](https://github.com/duo-labs/cloudmapper) | `pip install cloudmapper` | Visualize AWS infrastructure & network topology |
| [Prowler](https://github.com/prowler-cloud/prowler) | `pip install prowler` | Cloud infrastructure security best-practice checks |

---

## Quick Examples

```bash
# Scan Terraform infrastructure configs for security issues
checkov -d ./terraform --output json > ibom-checkov.json

# Scan with tfsec
tfsec ./terraform --format json > ibom-tfsec.json

# Generate Terraform infrastructure documentation
terraform-docs markdown ./terraform > ibom-infra-docs.md

# Cloud infrastructure cost + resource inventory
infracost breakdown --path ./terraform --format json > ibom-infracost.json

# Test infrastructure configs against OPA policies
conftest test infra/deployment.yaml --policy policies/

# Terrascan: multi-cloud IaC scan
terrascan scan -t terraform -d ./terraform -o json > ibom-terrascan.json

# Query live AWS infrastructure (Steampipe)
steampipe plugin install aws
steampipe query "select name, vpc_id, cidr_block from aws_vpc"
steampipe query "select name, arn from aws_iam_role"
steampipe query "select group_name, vpc_id from aws_vpc_security_group"

# Prowler AWS infrastructure audit
prowler aws --services vpc iam ec2 s3 rds --compliance cis_level1_aws
```

---

## Example IBOM Structure (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "version": 1,
  "metadata": {
    "component": {
      "type": "platform",
      "name": "production-infrastructure",
      "description": "AWS Production Environment — us-east-1"
    }
  },
  "components": [
    {
      "type": "platform",
      "name": "aws-vpc-prod",
      "description": "Production VPC",
      "properties": [
        { "name": "cidr", "value": "10.0.0.0/16" },
        { "name": "region", "value": "us-east-1" }
      ]
    },
    {
      "type": "service",
      "name": "aws-iam-role-app",
      "description": "Application IAM Role",
      "properties": [
        { "name": "arn", "value": "arn:aws:iam::123456789012:role/app-role" }
      ]
    },
    {
      "type": "service",
      "name": "aws-rds-postgres",
      "version": "15.3",
      "description": "Production PostgreSQL database",
      "properties": [
        { "name": "engine", "value": "postgres" },
        { "name": "multi_az", "value": "true" }
      ]
    },
    {
      "type": "service",
      "name": "aws-s3-app-storage",
      "description": "Application storage bucket",
      "properties": [
        { "name": "encryption", "value": "AES256" },
        { "name": "versioning", "value": "enabled" }
      ]
    }
  ]
}
```

---

## Relationship to Other BOMs

- **HBOM** → hardware foundation that IBOM runs on
- **OBOM** → running containers/workloads inside IBOM infrastructure
- **EBOM** (if used) → environment variables and secrets within IBOM
- **SBOM** → software deployed onto IBOM infrastructure

---

## Standards & Compliance

- CIS Benchmarks (AWS, Azure, GCP)
- NIST SP 800-53 (configuration management controls)
- ISO 27001:2022 (A.8 — Technology controls)
- SOC 2 (CC6.1 — Logical access security)
- DORA (Digital Operational Resilience Act)
- PCI DSS 4.0 (network segmentation & access control)
