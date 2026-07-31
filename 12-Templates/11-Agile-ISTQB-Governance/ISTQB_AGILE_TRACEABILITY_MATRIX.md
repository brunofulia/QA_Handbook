---
title: "ISTQB_AGILE_TRACEABILITY_MATRIX"
description: "Template for ISTQB Agile Traceability Matrix"
type: "template"
updated: "2026-07-31T13:35:29"
---

# ISTQB Agile Traceability & Test Design Record

## 1. Requirement & Risk Context
* **User Story ID:** <USER_STORY_ID>
* **Feature Module:** <MODULE_NAME>
* **Risk Score:** <RISK_SCORE> (Impact: <1-5> | Likelihood: <1-5>)
* **Target Environment:** QA / Staging

---

## 2. Test Design & Technique Mapping

| Test Case ID | Requirement / AC ID | ISTQB Level | Test Technique Used | Test Data / Boundary Definition | Automated Script Path / Reference |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `TC_<MODULE>_001` | `<AC_ID_01>` | System Testing | Boundary Value Analysis | Length = 0, 1, 255, 256 | `tests/functional/<test_file>.spec.ts` |
| `TC_<MODULE>_002` | `<AC_ID_02>` | System Integration | Equivalence Partitioning | Valid Role, Invalid Role | `tests/api/<api_test_file>.spec.ts` |
| `TC_<MODULE>_003` | `<AC_ID_03>` | System Testing | State Transition | Pending -> Approved -> Shipped | `tests/e2e/<e2e_file>.spec.ts` |
| `TC_<MODULE>_004` | `<AC_ID_04>` | System Testing | Pairwise Testing | OS x Browser x Resolution Matrix | `tests/compatibility/<test_file>.spec.ts` |

---

## 3. ISTQB Exit Criteria Verification
- [ ] 100% of critical scenarios derived from formal techniques (BVA/EP/Pairwise) successfully executed.
- [ ] Zero Critical or High severity open defects.
- [ ] Bidirectional traceability logged in the ALM engine (see **Chapter 08: Jira & Xray Integration for QA Governance & Traceability**).
