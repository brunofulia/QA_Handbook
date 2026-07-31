---
title: "TEST_AUTOMATION_CI_PIPELINE"
description: "Blueprint for Test Automation CI Pipeline"
type: "template"
updated: "2026-07-31T13:31:41"
---

# Integrated Parallel Execution, Sharding, and Report Merge Pipeline in GitHub Actions

File: `.github/workflows/test-automation-ci.yml`


```YAML
name: Test Automation Architecture CI Execution

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test-execution:
    name: Execute Playwright Automation (Shard ${{ matrix.shard }}/${{ matrix.total-shards }})
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        shard: [1, 2, 3, 4]
        total-shards: [4]

    steps:
      - name: Checkout Code Repository
        uses: actions/checkout@v4

      - name: Setup Node.js Runtime
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Project Dependencies
        run: npm ci

      - name: Install Playwright Browser Binaries
        run: npx playwright install --with-deps chromium

      - name: Execute Automated Tests with Sharding
        env:
          BASE_URL: ${{ secrets.QA_BASE_URL }}
          HEROKU_ALERTS_URL: ${{ secrets.QA_HEROKU_ALERTS_URL }}
          CI: true
        run: |
          npx playwright test --shard=${{ matrix.shard }}/${{ matrix.total-shards }} --reporter=blob

      - name: Archive Shard Blob Report Artifact
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: all-blob-reports-shard-${{ matrix.shard }}
          path: blob-report/
          retention-days: 1

  merge-reports:
    name: Consolidate and Publish Unified Test Report
    if: always()
    needs: test-execution
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code Repository
        uses: actions/checkout@v4

      - name: Setup Node.js Runtime
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'

      - name: Install Project Dependencies
        run: npm ci

      - name: Download All Shard Blob Reports
        uses: actions/download-artifact@v4
        with:
          path: all-blob-reports
          pattern: all-blob-reports-*
          merge-multiple: true

      - name: Merge Blob Reports into Unified HTML Report
        run: npx playwright merge-reports --reporter=html ./all-blob-reports

      - name: Archive Unified HTML Test Report
        uses: actions/upload-artifact@v4
        with:
          name: unified-html-report
          path: playwright-report/
          retention-days: 7
```
