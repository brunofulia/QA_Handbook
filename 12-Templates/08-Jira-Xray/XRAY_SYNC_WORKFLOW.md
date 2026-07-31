---
title: "XRAY_SYNC_WORKFLOW"
description: "Blueprint for Xray Sync Workflow"
type: "template"
updated: "2026-07-31T13:28:42"
---

# GitHub Actions Workflow Configuration for Automatic Synchronization with Xray

```yaml
name: QA Automation & Xray Test Results Sync

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test-and-sync:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Source Code
        uses: actions/checkout@v4

      - name: Setup Node.js Environment
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci

      # Execute Playwright E2E Tests.
      # continue-on-error is set to true to allow pipeline continuation exclusively for
      # publishing execution evidence to Xray. Quality gate decisions are evaluated in Xray/Jira.
      - name: Execute Playwright E2E Tests
        run: npx playwright test --reporter=junit
        continue-on-error: true

      - name: Publish Test Results to Jira Xray
        if: always()
        env:
          CLIENT_ID: ${{ secrets.XRAY_CLIENT_ID }}
          CLIENT_SECRET: ${{ secrets.XRAY_CLIENT_SECRET }}
          JIRA_PROJECT_KEY: "QA"
          TEST_ENV: "STAGING"
        run: |
          chmod +x ./scripts/xray-junit-import.sh
          ./scripts/xray-junit-import.sh
```
