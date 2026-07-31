---
title: "GOLDEN_DATASET_ENTRY_TEMPLATE"
description: "Template for AI Golden Dataset Entry"
type: "template"
updated: "2026-07-30T17:40:02"
---

# Golden Dataset Entry Template


```YAML
dataset_id: "CUSTOMER_SUPPORT_RAG_V1"
case_id: "RAG_CASE_001"
version: "1.0.0"
category:
  - "factual_question"
  - "regression"
risk_level: "medium"

input:
  user_query: "What is the return policy for electronics?"

ground_truth:
  expected_answer: "The customer has 30 days for returns in original condition with proof of purchase."
  source_documents:
    - "returns_policy_v3.pdf"

expected_behavior:
  must_answer: true
  must_cite_source: true
  hallucination_allowed: false

evaluation_thresholds:
  faithfulness: 0.90
  answer_relevance: 0.85

metadata:
  created_by: "QA Engineering Team"
  validated_by: "Product Owner / Domain Expert"
  last_updated: "2026-07-28"
```