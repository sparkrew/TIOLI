# ARGUS Experiments

## Purpose

This folder documents experiments with ARGUS.

ARGUS is used in this project to understand how taint tracking works in GitHub Actions workflows.

The goal is not to rebuild ARGUS. The goal is to study how existing semantic analysis detects flows from untrusted GitHub event data to dangerous sinks, then use this understanding to improve LIOTI's trigger-context model.

## Relation to TIOLI

TIOLI focuses on unsafe trigger-context combinations.

ARGUS focuses on source-to-sink taint tracking.

This difference matters:

| Tool | Main question |
|---|---|
| ARGUS | Can attacker-controlled data flow to a dangerous sink? |
| LIOTI | Does the workflow create an unsafe trust transition, and how can it be repaired? |

ARGUS helps us understand the data-flow part of risky combinations, especially cases where event fields such as issue titles, pull request bodies, comments, or branch names reach shell commands.

## Experiments

| Experiment | Target workflow | Purpose | Status |
|---|---|---|---|
| `smoke_yagipy_close` | `yagipy/habit-manager/.github/workflows/close.yml` | Run ARGUS on one vulnerable workflow and inspect the SARIF output | Done |

