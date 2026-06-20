# SBOM — Software Bill of Materials

## Free Tools

| Tool | Install | Stars |
|------|---------|-------|
| [Syft](https://github.com/anchore/syft) | `brew install syft` | ⭐ 6k+ |
| [cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | ⭐ 800+ |
| [Trivy](https://github.com/aquasecurity/trivy) | `brew install trivy` | ⭐ 24k+ |
| [SPDX SBOM Generator](https://github.com/opensbom-generator/spdx-sbom-generator) | [Download binary](https://github.com/opensbom-generator/spdx-sbom-generator/releases) | ⭐ 600+ |
| [Grype](https://github.com/anchore/grype) | `brew install grype` | ⭐ 9k+ |
| [OSS Review Toolkit](https://github.com/oss-review-toolkit/ort) | [Docker image](https://github.com/oss-review-toolkit/ort#docker) | ⭐ 1.5k+ |
| [sbom-tool](https://github.com/microsoft/sbom-tool) | `brew install microsoft/sbom/sbom-tool` | ⭐ 1.4k+ |
| [bomber](https://github.com/devops-kung-fu/bomber) | `brew install devops-kung-fu/tap/bomber` | ⭐ 200+ |

## Quick Examples

```bash
# Generate SBOM with Syft (CycloneDX format)
syft nginx:latest -o cyclonedx-json > sbom-nginx.cdx.json

# Generate SBOM with Trivy (SPDX format)
trivy image --format spdx-json --output sbom.spdx.json nginx:latest

# Generate SBOM with cdxgen for a Node.js project
cdxgen -t nodejs -o sbom.json ./my-project

# Scan an SBOM for vulnerabilities with Grype
grype sbom:sbom-nginx.cdx.json

# Scan SBOM with bomber
bomber scan --provider osv sbom-nginx.cdx.json
```

## Output Formats Supported

- **CycloneDX** (JSON, XML) — OWASP standard
- **SPDX** (JSON, TV, RDF) — Linux Foundation standard
- **SWID** — ISO/IEC 19770-2

## Standards & Compliance

- NIST SP 800-161 (C-SCRM)
- Executive Order 14028 (US)
- EU Cyber Resilience Act
- NTIA Minimum Elements for SBOM
