---
title: "XRAY_JUNIT_IMPORT"
description: "Blueprint for Xray JUnit Import"
type: "template"
updated: "2026-07-31T13:28:42"
---

# Bash Script for Importing JUnit Results to Xray Cloud with Retries

```bash
#!/usr/bin/env bash
# ==============================================================================
# Script: xray-junit-import.sh
# Description: Imports JUnit XML test results into Jira/Xray Cloud via REST API v2
# ==============================================================================

set -euo pipefail

# Mandatory Environment Variables Check
: "${CLIENT_ID:?Error: CLIENT_ID environment variable is required.}"
: "${CLIENT_SECRET:?Error: CLIENT_SECRET environment variable is required.}"
: "${JIRA_PROJECT_KEY:?Error: JIRA_PROJECT_KEY environment variable is required.}"

# Optional Environment Variables
TEST_EXEC_KEY="${TEST_EXEC_KEY:-}"
TEST_ENV="${TEST_ENV:-STAGING}"

JIRA_XRAY_BASE_URL="https://xray.cloud.getxray.app/api/v2"
REPORT_FILE_PATH="results/junit-report.xml"

if [ ! -f "$REPORT_FILE_PATH" ]; then
    echo "[ERROR] Report file not found at path: $REPORT_FILE_PATH"
    exit 1
fi

echo "[INFO] Authenticating with Xray Cloud API..."
AUTHENTICATION_TOKEN=$(curl --retry 3 --connect-timeout 10 -s -X POST "${JIRA_XRAY_BASE_URL}/authenticate" \
  -H "Content-Type: application/json" \
  -d "{\"client_id\": \"${CLIENT_ID}\", \"client_secret\": \"${CLIENT_SECRET}\"}" | tr -d '"')

if [ -z "$AUTHENTICATION_TOKEN" ] || [ "$AUTHENTICATION_TOKEN" == "null" ]; then
    echo "[ERROR] Authentication failed. Please check CLIENT_ID and CLIENT_SECRET."
    exit 1
fi

echo "[INFO] Importing execution results into Xray Project: ${JIRA_PROJECT_KEY} (Env: ${TEST_ENV})..."

IMPORT_URL="${JIRA_XRAY_BASE_URL}/import/execution/junit?projectKey=${JIRA_PROJECT_KEY}&testEnvironments=${TEST_ENV}"

# Append testExecKey if updating an existing Test Execution issue
if [ -n "${TEST_EXEC_KEY}" ]; then
    IMPORT_URL="${IMPORT_URL}&testExecKey=${TEST_EXEC_KEY}"
fi

RESPONSE=$(curl --retry 3 --connect-timeout 10 -s -w "\n%{http_code}" -X POST "${IMPORT_URL}" \
  -H "Authorization: Bearer ${AUTHENTICATION_TOKEN}" \
  -H "Content-Type: application/xml" \
  --data-binary "@${REPORT_FILE_PATH}")

HTTP_STATUS=$(echo "$RESPONSE" | tail -n 1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 201 ]; then
    echo "[SUCCESS] Execution results successfully imported into Xray."
    echo "[INFO] Response: ${RESPONSE_BODY}"
else
    echo "[ERROR] Failed to import results to Xray. HTTP Status: ${HTTP_STATUS}"
    echo "[ERROR] Details: ${RESPONSE_BODY}"
    exit 1
fi
```
