# OBOM — Operations Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [Trivy](https://github.com/aquasecurity/trivy) | `brew install trivy` | Scan containers, k8s, IaC for vulns + generate SBOM |
| [Syft](https://github.com/anchore/syft) | `brew install syft` | SBOM generation for running containers |
| [Grype](https://github.com/anchore/grype) | `brew install grype` | Vulnerability scan container SBOMs |
| [Falco](https://github.com/falcosecurity/falco) | Helm chart | Runtime security monitoring for k8s |
| [kube-bench](https://github.com/aquasecurity/kube-bench) | `brew install kube-bench` | CIS Kubernetes benchmark checks |
| [kube-hunter](https://github.com/aquasecurity/kube-hunter) | `pip install kube-hunter` | K8s cluster penetration testing |
| [Dockle](https://github.com/goodwithtech/dockle) | `brew install goodwithtech/r/dockle` | Container image linter & security checker |
| [Docker Scout](https://docs.docker.com/scout/) | Built into Docker | Container image vulnerability analysis (free tier) |

## Quick Examples

```bash
# Scan a running container image for vulnerabilities
trivy image nginx:latest

# Generate an SBOM for a container image (CycloneDX)
syft nginx:latest -o cyclonedx-json > obom-nginx.cdx.json

# Scan a live Kubernetes cluster
trivy k8s --report summary cluster

# CIS Kubernetes benchmark
kube-bench run --targets node

# Container image security lint
dockle nginx:latest

# Kubernetes cluster penetration test (passive)
kube-hunter --remote <cluster-ip>

# Docker Scout vulnerability analysis
docker scout cves nginx:latest

# Scan Kubernetes YAML manifests
trivy config ./k8s/
```

## Example OBOM Structure (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "container",
      "name": "api-service",
      "version": "2.1.0",
      "purl": "pkg:docker/myorg/api-service@2.1.0",
      "components": [
        {
          "type": "library",
          "name": "openssl",
          "version": "3.0.8",
          "purl": "pkg:deb/debian/openssl@3.0.8"
        }
      ]
    },
    {
      "type": "platform",
      "name": "Kubernetes",
      "version": "1.29.0",
      "components": [
        {
          "type": "container",
          "name": "etcd",
          "version": "3.5.9"
        }
      ]
    },
    {
      "type": "service",
      "name": "AWS ALB",
      "provider": { "name": "Amazon Web Services" },
      "endpoints": ["https://my-alb.region.elb.amazonaws.com"]
    }
  ]
}
```

## Standards & Compliance

- CIS Kubernetes Benchmark
- NIST SP 800-190 (Application Container Security)
- Docker CIS Benchmark
- PCI DSS 4.0 (container security requirements)
- SOC 2 (availability & security controls)
