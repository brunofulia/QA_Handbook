---
title: "BUG_REPORT_TEMPLATE"
description: "Template for Defect Reporting"
type: "template"
updated: "2026-07-31T13:49:07"
---

# Bug Report Template

## [BUG]_[<MODULE_NAME>]_[<COMPONENT>]_<SHORT_DESCRIPTION>

* **Issue Key:** <JIRA_ISSUE_KEY>
* **Environment Detected:** <DEVELOPMENT / QA / STAGING / PRODUCTION>
* **Severity:** <S1 - Blocker / S2 - Critical / S3 - Medium / S4 - Low>
* **Priority:** <P0 - Immediate / P1 - High / P2 - Medium / P3 - Low>
* **Build / Commit Hash:** <GIT_COMMIT_HASH>

---

### 1. Requirements Traceability
* **User Story / Requirement ID:** <USER_STORY_ID>
* **Acceptance Criteria Affected:** <ACCEPTANCE_CRITERIA_ID>

---

### 2. Business & Customer Impact Analysis
* **Customer Impact Level:** <LOW / MEDIUM / HIGH / CRITICAL>
* **Affected User Base:** <ESTIMATED_NUMBER_OR_PERCENTAGE_OF_USERS>
* **Financial / Regulatory Risk:** <NONE / DESCRIPTION_OF_FINANCIAL_OR_COMPLIANCE_IMPACT>

---

### 3. Steps to Reproduce (Deterministic Flow)
1. Navigate to `<APPLICATION_URL_OR_API_ENDPOINT>`.
2. Execute action `<ACTION_DESCRIPTION>` using test data `<TEST_DATA_PARAMETER>`.
3. Perform state transition `<STATE_MUTATION_STEP>`.

---

### 4. Expected vs. Observed Behavior
* **Expected Result:** <CLEAR_TECHNICAL_DESCRIPTION_OF_EXPECTED_BEHAVIOR>
* **Observed Result:** <CLEAR_TECHNICAL_DESCRIPTION_OF_ACTUAL_FAILURE>

---

### 5. Technical Diagnostics & Evidence Bundle
* **Correlation-ID / Trace-ID:** `<APM_CORRELATION_ID>`
* **System Logs / Payload:**
```json
{
  "error_code": "<ERROR_CODE_IDENTIFIER>",
  "message": "<SERVER_RESPONSE_MESSAGE>",
  "timestamp": "<UTC_TIMESTAMP>"
}
```

- **Attached Files:** `[Screenshot_Annotated.png]`, `[Console_Logs.txt]`
    

### 6. Root Cause Analysis (RCA) & Prevention (Post-Fix Mandatory)

- **Root Cause Category:** <REQUIREMENTS / LOGIC / TECH_DEBT / CONFIG / TEST_DATA / THIRD_PARTY>
    
- **Automated Test Candidate:** <YES / NO>
    
- **Regression Scope:** <NONE / FEATURE / MODULE / FULL_REGRESSION>
