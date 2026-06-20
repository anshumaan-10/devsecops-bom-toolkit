# DevSecOps BOM Toolkit — Free Tools for All 9 BOM Types

> *Based on: **Types of BOM in DevSecOps & Supply Chain Security** — Anshumaan Singh, DevSecOps Engineer, Zee Entertainment Enterprises Ltd.*

> **Complete visibility. Stronger security. Resilient delivery.**

A single reference repository demonstrating **free, open-source tools** for every Bill of Materials (BOM) type used across the DevSecOps & Supply Chain Security lifecycle.

---

## BOM Types Covered

| # | BOM | Full Name | Purpose |
|---|-----|-----------|---------|
| 1 | [SBOM](#1-sbom) | Software Bill of Materials | Vulnerability mgmt, license compliance, risk |
| 2 | [PBOM](#2-pbom) | Pipeline Bill of Materials | Secure & transparent CI/CD build integrity |
| 3 | [CBOM](#3-cbom) | Cryptography Bill of Materials | Crypto asset visibility, FIPS/NIST compliance |
| 4 | [HBOM](#4-hbom) | Hardware Bill of Materials | Hardware supply chain visibility & firmware security |
| 5 | [MBOM](#5-mbom) | Machine Learning Bill of Materials | Reproducibility, governance, model risk management |
| 6 | [AIBOM](#6-aibom) | AI Bill of Materials | AI transparency, security, ethical AI & regulatory compliance |
| 7 | [SaaSBOM](#7-saasbom) | SaaS Bill of Materials | Third-party risk management, data security & compliance |
| 8 | [OBOM](#8-obom) | Operations Bill of Materials | Runtime visibility, incident response & operational resilience |
| 9 | [IBOM](#9-ibom) | Infrastructure Bill of Materials | Environment consistency, security and compliance |

---

## Relationship Between BOMs

```
HBOM → SBOM → CBOM → PBOM → MBOM
                ↓       ↓
             AIBOM  SaaSBOM → OBOM → IBOM
```

- **HBOM** — Hardware is the root foundation
- **SBOM** — Runs on top of hardware
- **CBOM** — Secures software
- **PBOM** — Builds & delivers software securely
- **MBOM** — Includes ML artifacts
- **AIBOM** — Extends to AI assets
- **SaaSBOM** — Uses external SaaS services
- **OBOM** — Runs in operations
- **IBOM** — Across different infrastructure environments

---

## Quick Start

```bash
# Clone this repo
git clone https://github.com/your-org/devsecops-bom-toolkit.git
cd devsecops-bom-toolkit

# Install all free tools at once
./scripts/install-all-tools.sh

# Generate all BOMs for a project
./scripts/generate-all-boms.sh /path/to/your/project
```

---

## 1. SBOM

**Software Bill of Materials** — inventories all software components, libraries, packages and dependencies.

**Examples:** OpenSSL, Log4j, Spring Boot, Nginx, React, Node.js

### Free Tools

| Tool | Description | Output Format |
|------|-------------|---------------|
| [Syft](https://github.com/anchore/syft) | Generate SBOMs from container images, filesystems, archives | SPDX, CycloneDX, Syft JSON |
| [cdxgen](https://github.com/CycloneDX/cdxgen) | Multi-ecosystem CycloneDX SBOM generator | CycloneDX JSON/XML |
| [Trivy](https://github.com/aquasecurity/trivy) | Comprehensive SBOM + vulnerability scanner | SPDX, CycloneDX |
| [SPDX SBOM Generator](https://github.com/opensbom-generator/spdx-sbom-generator) | Native SPDX document generator | SPDX |
| [Grype](https://github.com/anchore/grype) | Vulnerability scanner using SBOMs | JSON, Table |
| [OSS Review Toolkit](https://github.com/oss-review-toolkit/ort) | License compliance & vulnerability scanning | SPDX, CycloneDX |
| [bomber](https://github.com/devops-kung-fu/bomber) | Scan SBOMs for vulnerabilities | JSON, HTML |
| [sbom-tool](https://github.com/microsoft/sbom-tool) | Microsoft's SBOM generation tool | SPDX 2.2 |

📁 See [`sbom/`](./sbom/) for examples and scripts.

---

## 2. PBOM

**Pipeline Bill of Materials** — represents all components of the CI/CD pipeline including tools, plugins, actions and configurations.

**Examples:** GitHub Actions, Jenkins, OpenSSL, Trivy Scanner

### Free Tools

| Tool | Description |
|------|-------------|
| [OpenSSF Scorecard](https://github.com/ossf/scorecard) | Automated security checks for CI/CD pipelines |
| [SLSA GitHub Generator](https://github.com/slsa-framework/slsa-github-generator) | Generate SLSA provenance for pipeline artifacts |
| [in-toto](https://github.com/in-toto/in-toto) | Framework to secure the software supply chain |
| [Tekton Chains](https://github.com/tektoncd/chains) | Supply chain security for Tekton pipelines |
| [GitHub dependency-review-action](https://github.com/actions/dependency-review-action) | Scan PRs for vulnerable dependencies |
| [pipeline-cleaner](https://github.com/rhenning/pipeline-cleaner) | Analyze and audit GitHub Actions workflows |
| [zizmor](https://github.com/woodruffw/zizmor) | Static analysis tool for GitHub Actions |

📁 See [`pbom/`](./pbom/) for examples and scripts.

---

## 3. CBOM

**Cryptography Bill of Materials** — inventories cryptographic assets such as algorithms, libraries, keys, certificates and configurations.

**Examples:** TLS 1.3, AES-256, OpenSSL 3.0, AWS KMS, SSL Certificates

### Free Tools

| Tool | Description |
|------|-------------|
| [IBM CBOM Generator](https://github.com/IBM/cbom) | Generate CycloneDX CBOMs with crypto discovery |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | Supports `--type cryptography` for CBOM generation |
| [detect-secrets](https://github.com/Yelp/detect-secrets) | Detect hardcoded secrets & crypto material |
| [truffleHog](https://github.com/trufflesecurity/trufflehog) | Find leaked secrets/credentials in code |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Detect hardcoded secrets in git repos |
| [Sigstore](https://github.com/sigstore/sigstore) | Signing, verifying software artifacts |
| [codeql-crypto-queries](https://github.com/github/codeql) | CodeQL queries for cryptographic misuse |
| [CryptoLyzer](https://github.com/c0r0n3r/cryptolyzer) | Analyze cryptographic configurations |

📁 See [`cbom/`](./cbom/) for examples and scripts.

---

## 4. HBOM

**Hardware Bill of Materials** — lists all hardware components, firmware, and embedded systems in the IT/OT environment.

**Examples:** Servers, Network Devices, TPM Chip, BIOS/Firmware, IoT Devices

### Free Tools

| Tool | Description |
|------|-------------|
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | Supports hardware component inventory via CycloneDX spec |
| [lshw](https://ezix.org/project/wiki/HardwareLiSter) | Hardware lister for Linux systems |
| [fwupd](https://github.com/fwupd/fwupd) | Firmware update daemon & device inventory |
| [LVFS (Linux Vendor Firmware Service)](https://fwupd.org/) | Open firmware metadata & tracking |
| [OpenBMC](https://github.com/openbmc/openbmc) | Open-source BMC firmware with hardware inventory |
| [dmidecode](https://www.nongnu.org/dmidecode/) | BIOS/UEFI hardware component info dumper |
| [inxi](https://github.com/smxi/inxi) | Full system information reporting script |
| [OCSInventory](https://github.com/OCSInventory-NG/OCSInventory-ocsreports) | Hardware & software inventory |

📁 See [`hbom/`](./hbom/) for examples and scripts.

---

## 5. MBOM

**Machine Learning Bill of Materials** — provides visibility into ML models, datasets, training data, features, libraries and training pipelines.

**Examples:** Trained Model (v1.2), Training Dataset, Feature Store, Python Libraries, Jupyter Notebook

### Free Tools

| Tool | Description |
|------|-------------|
| [model-transparency](https://github.com/google/model-transparency) | Google's ML model signing & provenance |
| [MLflow](https://github.com/mlflow/mlflow) | ML lifecycle management with model registry & lineage |
| [DVC (Data Version Control)](https://github.com/iterative/dvc) | Track ML datasets, models, and experiments |
| [AIBom](https://github.com/airbom/aibom) | AI/ML BOM generation |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | Supports ML model component tracking |
| [ml-metadata (MLMD)](https://github.com/google/ml-metadata) | Store & query ML component metadata |
| [Seldon Alibi](https://github.com/SeldonIO/alibi) | ML model audit and explainability |
| [ModelScan](https://github.com/protectai/modelscan) | Scan ML models for security vulnerabilities |

📁 See [`mbom/`](./mbom/) for examples and scripts.

---

## 6. AIBOM

**AI Bill of Materials** — inventories AI specific assets like LLMs, prompts, agents, embeddings, vector DBs and model configurations.

**Examples:** LLM (GPT-4), Prompt Templates, Vector DB (Pinecone), AI Agents, Embedding Model

### Free Tools

| Tool | Description |
|------|-------------|
| [AIBom](https://github.com/airbom/aibom) | Generate AI-specific BOMs for LLM systems |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | AI/ML BOM support via CycloneDX 1.5+ spec |
| [OWASP LLM Top 10](https://github.com/OWASP/www-project-top-10-for-large-language-model-applications) | LLM security risk framework |
| [garak](https://github.com/NVIDIA/garak) | LLM vulnerability & security scanner |
| [promptfoo](https://github.com/promptfoo/promptfoo) | Test & evaluate LLM prompts and agents |
| [rebuff](https://github.com/protectai/rebuff) | Prompt injection detection |
| [model-transparency](https://github.com/google/model-transparency) | Model signing and provenance |
| [Guardrails AI](https://github.com/guardrails-ai/guardrails) | AI output validation & governance |

📁 See [`aibom/`](./aibom/) for examples and scripts.

---

## 7. SaaSBOM

**SaaS Bill of Materials** — inventories all third-party SaaS applications and services used by the organization.

**Examples:** Salesforce, Slack, Microsoft 365, Google Workspace

### Free Tools

| Tool | Description |
|------|-------------|
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | Supports external service/SaaS inventory |
| [Cartography](https://github.com/lyft/cartography) | Infrastructure & SaaS asset relationship graph |
| [SaaS Discovery via OAuth scopes](https://github.com/trufflesecurity/trufflehog) | Detect SaaS API keys & tokens |
| [ScoutSuite](https://github.com/nccgroup/ScoutSuite) | Multi-cloud SaaS security auditing |
| [CAASM tools (OpenCSPM)](https://github.com/OpenCSPM/opencspm) | Continuous cloud/SaaS security posture mgmt |
| [Prowler](https://github.com/prowler-cloud/prowler) | Cloud/SaaS security best practice checks |
| [CloudSploit](https://github.com/aquasecurity/cloudsploit) | Cloud security configuration scanning |
| [steampipe](https://github.com/turbot/steampipe) | Query SaaS/cloud APIs using SQL |

📁 See [`saasbom/`](./saasbom/) for examples and scripts.

---

## 8. OBOM

**Operations Bill of Materials** — represents runtime operational assets including infrastructure, containers, orchestration and cloud resources.

**Examples:** Kubernetes Cluster, Docker Images, AWS EC2, S3 Buckets, Load Balancers

### Free Tools

| Tool | Description |
|------|-------------|
| [Trivy](https://github.com/aquasecurity/trivy) | Scan containers, k8s, IaC for vulnerabilities |
| [Syft](https://github.com/anchore/syft) | Generate SBOMs for running containers & images |
| [Grype](https://github.com/anchore/grype) | Vulnerability scan container/runtime SBOMs |
| [Falco](https://github.com/falcosecurity/falco) | Runtime security & behavioral monitoring for k8s |
| [Kubehunter](https://github.com/aquasecurity/kube-hunter) | K8s cluster penetration testing |
| [kube-bench](https://github.com/aquasecurity/kube-bench) | CIS Kubernetes benchmark checks |
| [Dockle](https://github.com/goodwithtech/dockle) | Container image linter & security checker |
| [Docker SBOM (docker sbom)](https://docs.docker.com/engine/sbom/) | Built-in Docker SBOM generation |

📁 See [`obom/`](./obom/) for examples and scripts.

---

## 9. IBOM

**Infrastructure Bill of Materials** — describes the infrastructure environments (Dev, Test, Staging, Prod) and their configurations, variables, secrets and policies.

**Examples:** VPC / Subnets, IAM Roles, Security Groups, Databases, Storage Buckets

### Free Tools

| Tool | Description |
|------|-------------|
| [Checkov](https://github.com/bridgecrewio/checkov) | IaC security scanning (Terraform, Helm, K8s) |
| [tfsec](https://github.com/aquasecurity/tfsec) | Terraform static analysis security scanner |
| [Kubescape](https://github.com/kubescape/kubescape) | K8s infrastructure security posture management |
| [conftest](https://github.com/open-policy-agent/conftest) | Policy testing for infrastructure configs (OPA) |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | Generate docs from Terraform infrastructure configs |
| [Infracost](https://github.com/infracost/infracost) | Cloud infrastructure resource inventory + cost |
| [Terrascan](https://github.com/tenable/terrascan) | Static code analysis for IaC |
| [Steampipe](https://github.com/turbot/steampipe) | Query live AWS/Azure/GCP infrastructure via SQL |
| [Prowler](https://github.com/prowler-cloud/prowler) | Cloud infrastructure security best-practice checks |

📁 See [`ibom/`](./ibom/) for examples and scripts.

---

## Key Benefits

- End-to-end visibility across the software supply chain
- Improved vulnerability detection and risk mitigation
- License compliance and audit readiness
- Stronger security, compliance and governance
- Faster incident response and root cause analysis
- Support for regulatory requirements (NIST, EO 14028, PCI DSS, ISO 27001, DORA)

## Common Use Cases

- Supply Chain Security
- Vulnerability Management
- License Compliance
- Secure CI/CD
- AI Governance
- Crypto Compliance
- Incident Response
- Regulatory Compliance

---

## Legend

- ✅ Standard / Well Established
- 🔵 Emerging / Evolving

---

## Contributing

Pull requests welcome! Add tools, scripts, or example outputs for any BOM type.

## License

MIT
