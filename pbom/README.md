# PBOM — Pipeline Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [OpenSSF Scorecard](https://github.com/ossf/scorecard) | `brew install scorecard` | Automated security health checks for pipelines |
| [SLSA GitHub Generator](https://github.com/slsa-framework/slsa-github-generator) | GitHub Action | SLSA provenance for build artifacts |
| [in-toto](https://github.com/in-toto/in-toto) | `pip install in-toto` | Framework to secure the full supply chain |
| [Tekton Chains](https://github.com/tektoncd/chains) | Kubernetes operator | Pipeline attestation & signing |
| [zizmor](https://github.com/woodruffw/zizmor) | `pip install zizmor` | Static analysis for GitHub Actions workflows |
| [dependency-review-action](https://github.com/actions/dependency-review-action) | GitHub Action | Scan PRs for vulnerable/new dependencies |
| [actionlint](https://github.com/rhysd/actionlint) | `brew install actionlint` | Lint GitHub Actions workflow files |
| [Sigstore Cosign](https://github.com/sigstore/cosign) | `brew install cosign` | Sign and verify container images/artifacts |

## Quick Examples

```bash
# Run Scorecard on a GitHub repository
scorecard --repo=github.com/your-org/your-repo --checks=all

# Lint GitHub Actions workflows
actionlint .github/workflows/*.yml

# Audit GitHub Actions workflow for security issues
zizmor .github/workflows/ci.yml

# Sign a container image with Cosign (keyless)
cosign sign --yes ghcr.io/your-org/your-image:latest

# Verify a signed image
cosign verify ghcr.io/your-org/your-image:latest \
  --certificate-identity-regexp=".*" \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com
```

## CycloneDX PBOM Schema

CycloneDX 1.5+ supports pipeline components under `components[].type = "data"` or via `formulation`:

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "version": 1,
  "metadata": {
    "component": {
      "type": "application",
      "name": "my-pipeline"
    }
  },
  "formulation": [
    {
      "bom-ref": "build-step-1",
      "name": "Build & Test",
      "commands": [
        { "executed": "npm ci" },
        { "executed": "npm test" }
      ],
      "tools": [
        { "name": "node", "version": "20.x" },
        { "name": "npm", "version": "10.x" }
      ]
    }
  ]
}
```

## Standards & Compliance

- SLSA (Supply-chain Levels for Software Artifacts)
- NIST SP 800-204D
- OpenSSF Best Practices
