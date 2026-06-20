# CBOM — Cryptography Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [IBM CBOM Generator](https://github.com/IBM/cbom) | `pip install cbom` | Generate CycloneDX CBOMs with crypto discovery |
| [cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | `--type cryptography` flag for CBOM |
| [CryptoLyzer](https://github.com/c0r0n3r/cryptolyzer) | `pip install cryptolyzer` | Analyze cryptographic configurations (TLS etc.) |
| [detect-secrets](https://github.com/Yelp/detect-secrets) | `pip install detect-secrets` | Detect hardcoded secrets & crypto material |
| [truffleHog](https://github.com/trufflesecurity/trufflehog) | `brew install trufflesecurity/trufflehog/trufflehog` | Find leaked secrets/credentials |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | `brew install gitleaks` | Detect secrets in git repos |
| [Sigstore Cosign](https://github.com/sigstore/cosign) | `brew install cosign` | Software artifact signing & verification |
| [semgrep](https://github.com/semgrep/semgrep) | `brew install semgrep` | Static analysis for weak crypto patterns |

## Quick Examples

```bash
# Generate CBOM with cdxgen (cryptography type)
cdxgen --type cryptography -o cbom.json ./my-project

# Scan a host's TLS configuration with CryptoLyzer
python3 -m cryptolyzer tls all example.com

# Detect secrets in codebase
detect-secrets scan ./src > .secrets.baseline
detect-secrets audit .secrets.baseline

# Scan for leaked secrets with Gitleaks
gitleaks detect --source . -v

# Scan for secrets with truffleHog
trufflehog git file://. --only-verified

# Find weak crypto with Semgrep
semgrep --config="p/cryptography" ./src
```

## Example CBOM Output (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "cryptographic-asset",
      "name": "RSA-2048",
      "cryptoProperties": {
        "assetType": "algorithm",
        "algorithmProperties": {
          "primitive": "pke",
          "parameterSetIdentifier": "2048",
          "executionEnvironment": "software-plain-ram",
          "implementationPlatform": "x86_64"
        }
      }
    },
    {
      "type": "cryptographic-asset",
      "name": "TLS 1.3",
      "cryptoProperties": {
        "assetType": "protocol",
        "protocolProperties": {
          "type": "tls",
          "version": "1.3"
        }
      }
    }
  ]
}
```

## Standards & Compliance

- FIPS 140-3
- NIST Post-Quantum Cryptography standards
- PCI DSS 4.0 (strong cryptography requirements)
- NIST SP 800-175B (cryptographic standards guidance)
- Quantum-Safe migration planning
