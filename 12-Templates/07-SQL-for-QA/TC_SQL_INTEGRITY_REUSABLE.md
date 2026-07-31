---
title: "TC_SQL_INTEGRITY_REUSABLE"
description: "Reusable Test Case for SQL Integrity"
type: "template"
updated: "2026-07-30T17:40:02"
---

# ID: TC_SQL_INTEGRITY_REUSABLE
**Component:** Core Database / Transactional Persistence Layer
**Owner:** Quality Engineering & Data Governance Team
**Version:** <VERSION> | **Last Updated:** <LAST_UPDATED>
**Priority:** P0 | **Risk Level:** Critical | **Business Impact:** High
**Requirement:** <REQUIREMENT_ID> | **Automation Status:** Candidate
**Target DB Engine:** PostgreSQL / MySQL / Oracle / SQL Server
**Review Status:** APPROVED | **Approved By:** <REVIEWER_ID>

## Description
Validate referential integrity, absence of orphan records, and atomicity of financial transactions in the `accounts` and `transactions` entities after the execution of concurrent financial operations.

## Preconditions
1. The ephemeral test database is provisioned via `Testcontainers` and updated with the latest migration DDL script (`<MIGRATION_VERSION>`).
2. The `accounts` table contains the test customer record `<TARGET_ACCOUNT_ID>` with an initial balance of `1000.00`.
3. There are no prior unprocessed records in the `transactions` table for the test customer.

## Execution Steps
1. Execute the backend flow or API that processes a transactional debit of `200.00` for `<TARGET_ACCOUNT_ID>`.
2. Inject a simulated network failure or disconnection in the service confirmation sub-step.
3. Execute the orphan auditing SQL query in the database:
   ```sql
   SELECT t.transaction_id 
   FROM transactions t 
   LEFT JOIN accounts a ON t.account_id = a.account_id 
   WHERE a.account_id IS NULL;
   ```

4. Execute the balance reconciliation SQL query:
    
    ```SQL
    SELECT current_balance 
    FROM accounts 
    WHERE account_id = '<TARGET_ACCOUNT_ID>';
    ```

## Test Data Parameters

- `<TARGET_ACCOUNT_ID>`: Unique account identifier in the test environment.
- `<MIGRATION_VERSION>`: Database schema version identifier (e.g., `V2.4__add_transactions_table.sql`).

## Expected Results

1. The orphan detection query returns exactly `0` records.
2. Given the failure injected in step 2, the engine executes a full `ROLLBACK`; the account balance remains intact at `1000.00` and no transaction in an inconsistent state is generated.
3. Upon executing a full successful transaction, the balance in `accounts` is updated exactly to `800.00` and the corresponding record in `transactions` contains the valid relationship account ID.

## Postconditions (Teardown)

1. Execute the cleanup script or destroy the ephemeral database container instance.
