# SaaSBOM — SaaS Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | External service/SaaS inventory in BOM |
| [Cartography](https://github.com/lyft/cartography) | `pip install cartography` | Infrastructure & SaaS relationship graph (Neo4j) |
| [Steampipe](https://github.com/turbot/steampipe) | `brew install turbot/tap/steampipe` | Query SaaS/cloud APIs with SQL |
| [Prowler](https://github.com/prowler-cloud/prowler) | `pip install prowler` | Cloud & SaaS security best practice checks |
| [CloudSploit](https://github.com/aquasecurity/cloudsploit) | `npm install -g @aquasecurity/cloudsploit` | Cloud security configuration scanning |
| [ScoutSuite](https://github.com/nccgroup/ScoutSuite) | `pip install scoutsuite` | Multi-cloud security auditing |
| [truffleHog](https://github.com/trufflesecurity/trufflehog) | `brew install trufflesecurity/trufflehog/trufflehog` | Detect SaaS API keys & tokens |
| [OpenCSPM](https://github.com/OpenCSPM/opencspm) | Docker image | Continuous cloud/SaaS security posture mgmt |

## Quick Examples

```bash
# Query AWS resources as a SaaS inventory with Steampipe
steampipe plugin install aws
steampipe query "select name, arn, region from aws_s3_bucket"
steampipe query "select display_name, id from aws_iam_user"

# Cloud security audit with Prowler
pip install prowler
prowler aws --compliance iso27001_2013_aws
prowler aws --services s3 iam sts

# Multi-cloud security audit with ScoutSuite
pip install scoutsuite
python -m scout aws --report-name saas-audit

# Discover SaaS API tokens in code/env
trufflehog git file://. --only-verified

# CloudSploit: AWS/Azure/GCP config scanning
npm install -g @aquasecurity/cloudsploit
cloudsploit scan --config ./cloudsploit-config.js --json saas-cloudsploit.json
```

## Example SaaSBOM Structure (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "service",
      "name": "Salesforce CRM",
      "version": "Spring '24",
      "provider": { "name": "Salesforce" },
      "endpoints": ["https://myorg.salesforce.com"],
      "authenticated": true,
      "data": [
        { "classification": "PII", "flow": "bi-directional" }
      ]
    },
    {
      "type": "service",
      "name": "Slack",
      "provider": { "name": "Slack Technologies" },
      "endpoints": ["https://slack.com/api"],
      "authenticated": true,
      "data": [
        { "classification": "confidential", "flow": "outbound" }
      ]
    },
    {
      "type": "service",
      "name": "GitHub",
      "provider": { "name": "GitHub, Inc." },
      "endpoints": ["https://api.github.com"],
      "authenticated": true,
      "data": [
        { "classification": "source-code", "flow": "bi-directional" }
      ]
    }
  ]
}
```

## Standards & Compliance

- SOC 2 Type II vendor assessments
- ISO 27001:2022 (supplier relationships)
- GDPR / CCPA (third-party data processors)
- CSA STAR (Cloud Security Alliance)
- NIST SP 800-161 (C-SCRM)
