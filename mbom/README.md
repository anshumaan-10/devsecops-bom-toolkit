# MBOM — Machine Learning Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [model-transparency](https://github.com/google/model-transparency) | `pip install model-signing` | ML model signing & provenance (Google) |
| [MLflow](https://github.com/mlflow/mlflow) | `pip install mlflow` | ML lifecycle: tracking, registry, lineage |
| [DVC](https://github.com/iterative/dvc) | `pip install dvc` | Data & model versioning |
| [ModelScan](https://github.com/protectai/modelscan) | `pip install modelscan` | Security scan ML model files |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | ML BOM via CycloneDX spec |
| [ml-metadata](https://github.com/google/ml-metadata) | `pip install ml-metadata` | Store & query ML component metadata |
| [Evidently AI](https://github.com/evidentlyai/evidently) | `pip install evidently` | ML model monitoring & data drift detection |
| [Great Expectations](https://github.com/great-expectations/great_expectations) | `pip install great_expectations` | Data validation & documentation |

## Quick Examples

```bash
# Scan ML model file for security vulnerabilities
pip install modelscan
modelscan scan -p ./models/my_model.pkl
modelscan scan -p ./models/my_model.h5

# Sign an ML model with model-transparency
pip install model-signing
python -m model_signing.sign --path ./models/my_model.pkl \
  --signer sigstore

# Verify a signed model
python -m model_signing.verify --path ./models/my_model.pkl

# Track ML experiment with MLflow
mlflow experiments create --experiment-name "model-v1"
mlflow run . --experiment-name "model-v1"

# Initialize DVC for data/model tracking
dvc init
dvc add data/train.csv
dvc add models/model.pkl
git add data/train.csv.dvc models/model.pkl.dvc .gitignore
```

## Example MBOM Structure (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "machine-learning-model",
      "name": "fraud-detection-v1.2",
      "version": "1.2.0",
      "modelCard": {
        "modelParameters": {
          "task": {
            "type": "classification"
          },
          "architectureFamily": "random-forest",
          "implementationPlatform": "scikit-learn"
        },
        "quantitativeAnalysis": {
          "performanceMetrics": [
            { "type": "accuracy", "value": "0.94" },
            { "type": "f1-score", "value": "0.91" }
          ]
        },
        "considerations": {
          "trainingData": [
            {
              "type": "dataset",
              "name": "transactions-2024",
              "contents": {
                "url": "s3://ml-datasets/transactions-2024.parquet"
              }
            }
          ]
        }
      }
    }
  ]
}
```

## Standards & Compliance

- NIST AI RMF (AI Risk Management Framework)
- EU AI Act
- ISO/IEC 42001 (AI Management Systems)
- OWASP ML Security Top 10
