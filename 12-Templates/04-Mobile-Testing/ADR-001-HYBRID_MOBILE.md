---
title: "ADR-001-HYBRID_MOBILE"
description: "Architecture Decision Record for Hybrid Mobile"
type: "template"
updated: "2026-07-30T17:40:02"
---

# ADR-001: Adoption of Hybrid Mobile Automation Strategy

## Status
Approved (APPROVED)

## Context
The development of the mobile platform requires accelerating feedback time in CI/CD executions
without losing the ability to validate advanced Android OS scenarios
(dynamic permissions, application lifecycle, and deep links).

Exclusively using Appium for all flows generates high maintenance overhead and
prolonged execution times in functional regression suites. Exclusively using
declarative tools prevents the validation of OS integration behaviors.

## Decision
Adopt a hybrid automation architecture segregated by responsibilities:
1. Maestro for the fast business validation layer, Smoke Tests, and critical product flows.
2. Appium 2 + WebdriverIO + TypeScript for deep system automation, lifecycle,
   permissions, and network resilience.
3. ADB Service as an isolated infrastructure layer for OS manipulation and
   diagnostics extraction.

## Consequences

### Positive:
* Decrease in the total execution time of the functional regression suite.
* Reduction of UI test flakiness through declarative abstraction.
* Immediate debugging capability upon failures through automatic extraction of Logcat,
  network state, and metadata.

### Trade-offs / Risks:
* The Quality Engineering team must maintain technical competencies in two automation technologies
  (Maestro YAML and Appium/TypeScript).
