---
title: "TC_IAM_PII_COMP_REUSABLE"
description: "Reusable Test Case for IAM PII Compliance"
type: "template"
updated: "2026-07-30T17:40:02"
---

# ID: TC_IAM_PII_COMP_REUSABLE
**Component:** Identity & Access Management (IAM) / Customer Gateway API
**Owner:** Security & Compliance QA
**Version:** <VERSION> | **Last Updated:** <LAST_UPDATED>
**Priority:** P0 | **Automation Status:** Automated
**Requirement:** <REQUIREMENT_ID>
**Review Status:** APPROVED | **Approved By:** <REVIEWER_ID>

## Description
Verify the enforcement of customer Personally Identifiable Information (*PII*) protection through data masking within public API response payloads and strict role-based access restrictions (*RBAC verification*).

## Core Security Mandates
* **Transport Security:** All network interactions and component integrations *MUST* run over encrypted HTTPS/TLS channels end-to-end.
* **Prohibition of Local Hashing:** Client applications *MUST NOT* apply local hashing or encryption routines to passwords prior to transmission. Transit security depends entirely on HTTPS, digital certificate checks, and backend processing.
* **URL Query Parameters Cleanliness:** No confidential payloads, authentication tokens, or PII elements *MUST* be transmitted inside URL query parameters.

## Preconditions
1. Two logical credentials are pre-configured in the test database:
   * `<AUTHORIZED_USER>`: Bound to the administrative auditor role with full read authorization.
   * `<RESTRICTED_USER>`: Bound to the operational agent role with active PII restrictions.

## Execution Steps
1. Authenticate an API session utilizing credentials belonging to the restricted profile `<RESTRICTED_USER>`.
2. Execute an HTTP GET request to the route: `HTTPS://<API_GATEWAY_URL>/v1/customers/<TARGET_CUSTOMER_ID>`.
3. Verify the presence of secure headers in the server response.
4. Analyze the returned JSON response body.

## Test Data Parameters
* `<RESTRICTED_ROLE>`: Lowest operational hierarchy role (e.g., "Support_Agent").
* `<AUTHORIZED_ROLE>`: Authorized compliance role (e.g., "Compliance_Officer").
* `<TARGET_CUSTOMER_ID>`: Unique customer entity identifier to query.

## Expected Results
1. The backend response status code is `200 OK`.
2. Communication runs over TLS 1.3 with verified digital certificates.
3. Zero confidential parameters are exposed within the URL query string.
4. The received JSON body demonstrates strict data masking rules on critical fields:
   ```json
   {
     "customer_id": "<TARGET_CUSTOMER_ID>",
     "full_name": "J*** D**",
     "email": "j***.d**@masked.domain.com",
     "national_id": "******123X",
     "rbac_status": "verified_restriction"
   }
   ```
5. If the restricted user requests access to raw unmasked audit logs, the API *MUST* reject the request with a `403 Forbidden` status code (API contract validation).