---
title: "TC_API_BOLA_SECURITY_REUSABLE"
description: "Reusable Test Case for API BOLA Security"
type: "template"
updated: "2026-07-30T17:40:02"
---

# ID: TC_API_BOLA_SECURITY_REUSABLE
**Component:** Order Management Service API
**Owner:** QA Engineering & Security Team
**Version:** <VERSION> | **Last Updated:** <LAST_UPDATED>
**Priority:** P0 | **Risk Level:** Critical | **Business Impact:** High
**Risk Classification:** Security / Compliance / Functional
**Environment Target:** QA / Staging (Production-like)
**Requirement:** <REQUIREMENT_ID> | **Automation Status:** Automated
**Protocol:** HTTPS/TLS 1.3 | **Target Endpoint:** `GET /v1/orders/<ORDER_ID>`
**Review Status:** APPROVED | **Approved By:** <REVIEWER_ID>

## Description
Validate that the API strictly restricts cross-access to purchase orders between authenticated users of different tenants (BOLA/RBAC Check), further ensuring compliance with JSON schemas and the transmission of secure transport headers.

## Preconditions
1. There are two independent user accounts configured in the test database:
   * `<USER_A_TOKEN>`: Valid JWT token for User A (Owner of order `<ORDER_ID_A>`).
   * `<USER_B_TOKEN>`: Valid JWT token for User B (Not authorized for order `<ORDER_ID_A>`).
2. The API operates under encrypted HTTPS/TLS channels.

## Execution Steps
1. Send an HTTP GET request to `HTTPS://<API_GATEWAY_URL>/v1/orders/<ORDER_ID_A>` using the header `Authorization: Bearer <USER_A_TOKEN>`.
2. Assert the legitimate owner's response.
3. Send a second HTTP GET request to the same endpoint `HTTPS://<API_GATEWAY_URL>/v1/orders/<ORDER_ID_A>` using the header `Authorization: Bearer <USER_B_TOKEN>`.
4. Evaluate the status code, security headers, and response body structure.

## Test Data Parameters
* `<USER_A_TOKEN>`: Bearer Token of the entity author user.
* `<USER_B_TOKEN>`: Bearer Token of the unauthorized user.
* `<ORDER_ID_A>`: Unique identifier of the order under test.

## Expected Results
1. **Owner Request (User A):**
   * HTTP Status Code: `200 OK`.
   * The response body is 100% compliant with the formally declared JSON schema.
   * Contains security headers: `Strict-Transport-Security` and `X-Content-Type-Options: nosniff`.
2. **Unauthorized User Request (User B - BOLA Attempt):**
   * HTTP Status Code: `403 Forbidden` (or `404 Not Found` depending on the resource obfuscation policy).
   * The response body does not expose any attribute of order `<ORDER_ID_A>` or system *stack traces*.
   * The consumed URL does not contain query parameters with sensitive data or PII.

## Evidence Requirements
1. Capture of Request/Response Payloads of both requests with sanitized tokens.
2. APM system traceability identifier (`Trace-ID` / `Correlation-ID`).
3. Backend audit logs confirming the unauthorized access attempt.

## Postconditions (Teardown)
1. Revoke test tokens if they were generated with explicit temporary validity.