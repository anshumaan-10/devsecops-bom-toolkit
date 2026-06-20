# EBOM — Environment Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [Checkov](https://github.com/bridgecrewio/checkov) | `pip install checkov` | IaC security scanning (Terraform, Helm, K8s, CF) |
| [tfsec](https://github.com/aquasecurity/tfsec) | `brew install tfsec` | Terraform static analysis security scanner |
| [Kubescape](https://github.com/kubescape/kubescape) | `brew install kubescape` | K8s environment security posture management |
| [conftest](https://github.com/open-policy-agent/conftest) | `brew install conftest` | Policy testing for environment configs (OPA) |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | `brew install terraform-docs` | Generate docs from Terraform configs |
| [Infracost](https://github.com/infracost/infracost) | `brew install infracost` | Cloud resource inventory + cost estimation |
| [detect-secrets](https://github.com/Yelp/detect-secrets) | `pip install detect-secrets` | Find secrets in environment config files |
| [Terrascan](https://github.com/tenable/terrascan) | `brew install terrascan` | Static code analysis for IaC |

## Quick Examples

```bash
# Scan Terraform configs for security issues
checkov -d ./terraform --output json > ebom-checkov.json

# Scan with tfsec
tfsec ./terraform --format json > ebom-tfsec.json

# Kubernetes environment posture check
kubescape scan --format json --output ebom-kubescape.json

# Generate Terraform environment documentation
terraform-docs markdown ./terraform > ebom-infra-docs.md

# Test k8s configs against OPA policies
conftest test k8s/deployment.yaml --policy policies/

# Cloud resource cost estimation + inventory
infracost breakdown --path ./terraform --format json > ebom-infracost.json

# Scan environment files for secrets
detect-secrets scan .env* config/*.yml > ebom-secrets.json

# Terrascan: multi-cloud IaC scan
terrascan scan -t terraform -d ./terraform -o json > ebom-terrascan.json
```

## Example EBOM Structure (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "platform",
      "name": "production-environment",
      "description": "AWS production environment - us-east-1",
      "components": [
        {
          "type": "service",
          "name": "AWS VPC",
          "version": "1.0",
          "description": "Isolated network environment"
        },
        {
          "type": "service",
          "name": "AWS RDS PostgreSQL",
          "version": "15.3",
          "description": "Production database"
        },
        {
          "type": "service",
          "name": "AWS EKS",
          "version": "1.29",
          "description": "Kubernetes cluster"
        }
      ]
    },
    {
      "type": "data",
      "name": "environment-config",
      "description": "Production environment configuration",
      "components": [
        {
          "type": "data",
          "name": "APP_DATABASE_URL",
          "description": "Database connection string (secret)"
        }
      ]
    }
  ]
}
```

## Example Checkov OPA Policy

```python
# policies/require-resource-tags.rego
package main

deny[msg] {
  resource := input.resource.aws_instance[name]
  not resource.tags.Environment
  msg := sprintf("AWS instance '%s' must have an 'Environment' tag", [name])
}
```

## Standards & Compliance

- CIS Benchmarks (AWS, Azure, GCP, Kubernetes)
- NIST SP 800-53 (configuration management controls)
- ISO 27001:2022 (A.8 - Technology controls)
- SOC 2 (CC6.1 - Logical access security)
- DORA (Digital Operational Resilience Act)
