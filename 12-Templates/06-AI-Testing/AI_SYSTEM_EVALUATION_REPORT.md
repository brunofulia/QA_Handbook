---
title: "AI_SYSTEM_EVALUATION_REPORT"
description: "Template for AI System Evaluation Report"
type: "template"
updated: "2026-07-30T17:40:02"
---

# AI System & RAG Quality Evaluation Report
* **Evaluation Target:** <MODEL_OR_AGENT_NAME_VERSION>
* **Golden Dataset Version:** <DATASET_VERSION_ID>
* **Evaluation Date:** <YYYY-MM-DD>
* **Assessor:** <AI_QA_SPECIALIST>

---

## 1. Quantitative Quality Evaluation (RAGAS / Framework Metrics)
| Metric Name | Evaluation Method | Target Threshold | Measured Score | Evaluation Verdict |
| :--- | :--- | :--- | :--- | :--- |
| **Faithfulness** | LLM-based factual consistency evaluation vs. context | $\ge 0.85$ | <SCORE> | <PASS / FAIL> |
| **Answer Relevance** | Embedding Cosine Similarity $(\vec{E}_Q, \vec{E}_{Q_i})$ | $\ge 0.80$ | <SCORE> | <PASS / FAIL> |
| **Context Precision** | Relevant retrieved chunks ratio | $\ge 0.80$ | <SCORE> | <PASS / FAIL> |
| **Tool Selection Accuracy** | Correct tool & argument invocation ratio | $\ge 95.0\%$ | <SCORE>% | <PASS / FAIL> |

---

## 2. Safety & Guardrails Security Scan
* **Prompt Injection Resilience:** <PASS / FAIL> (Tools used: *Promptfoo / Garak*)
* **PII Leakage Scan:** <ZERO_LEAKAGE_CONFIRMED / LEAKAGE_DETECTED>
* **Drift Tolerance Check:** $\Delta \text{Score} = \text{Score}_{\text{current}} - \text{Score}_{\text{baseline}} \le 5\%$ (<PASSED_WITHIN_5_PERCENT / DRIFT_EXCEEDED>)

---

## 3. Final Deployment Recommendation
* **Verdict:** <APPROVED_FOR_PRODUCTION / REJECTED_HIGH_HALLUCINATION_OR_SAFETY_RISK>