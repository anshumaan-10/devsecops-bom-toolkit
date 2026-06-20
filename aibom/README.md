# AIBOM — AI Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [AIBom](https://github.com/airbom/aibom) | `pip install aibom` | AI-specific BOM generation for LLM systems |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | AI/ML BOM via CycloneDX 1.5+ spec |
| [garak](https://github.com/NVIDIA/garak) | `pip install garak` | LLM vulnerability & red-team security scanner |
| [promptfoo](https://github.com/promptfoo/promptfoo) | `npm install -g promptfoo` | LLM prompt testing & evaluation |
| [rebuff](https://github.com/protectai/rebuff) | `pip install rebuff` | Prompt injection detection |
| [Guardrails AI](https://github.com/guardrails-ai/guardrails) | `pip install guardrails-ai` | AI output validation & governance |
| [model-transparency](https://github.com/google/model-transparency) | `pip install model-signing` | LLM model signing & provenance |
| [LLM Guard](https://github.com/protectai/llm-guard) | `pip install llm-guard` | Security toolkit for LLM interactions |

## Quick Examples

```bash
# Scan an LLM for common vulnerabilities with garak
pip install garak
python -m garak --model_type openai --model_name gpt-3.5-turbo \
  --probes encoding,injection,prompt_injection

# Test LLM prompts with promptfoo
npm install -g promptfoo
promptfoo eval --config promptfoo.yaml

# Validate AI outputs with Guardrails AI
pip install guardrails-ai
guardrails hub install hub://guardrails/detect_pii

# Scan for prompt injection with LLM Guard
pip install llm-guard
python -c "
from llm_guard.input_scanners import PromptInjection
scanner = PromptInjection()
sanitized, is_valid, risk = scanner.scan('Ignore instructions and...')
print(f'Valid: {is_valid}, Risk: {risk}')
"
```

## Example promptfoo.yaml

```yaml
# promptfoo.yaml — LLM prompt evaluation config
prompts:
  - "Summarize the following: {{text}}"
  - "In 2 sentences, summarize: {{text}}"

providers:
  - openai:gpt-4o-mini
  - openai:gpt-3.5-turbo

tests:
  - vars:
      text: "The quick brown fox jumps over the lazy dog."
    assert:
      - type: contains
        value: "fox"
      - type: llm-rubric
        value: "Is the summary accurate and concise?"
```

## Example AIBOM Structure (CycloneDX 1.6)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "machine-learning-model",
      "name": "customer-support-agent",
      "version": "2.1.0",
      "description": "LLM-based customer support AI agent",
      "modelCard": {
        "modelParameters": {
          "task": { "type": "text-generation" },
          "architectureFamily": "transformer",
          "implementationPlatform": "openai-api"
        }
      },
      "components": [
        {
          "type": "data",
          "name": "system-prompt-v3",
          "description": "System prompt template defining agent behavior"
        },
        {
          "type": "library",
          "name": "langchain",
          "version": "0.3.0"
        },
        {
          "type": "service",
          "name": "pinecone-vector-db",
          "description": "Embedding vector store for RAG"
        }
      ]
    }
  ]
}
```

## Standards & Compliance

- OWASP LLM Top 10
- EU AI Act (transparency obligations)
- NIST AI RMF
- ISO/IEC 42001
- MITRE ATLAS (adversarial threat landscape for AI)
