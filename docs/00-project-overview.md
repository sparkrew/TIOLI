# Project Overview

This project investigates trigger-aware detection and repair of unsafe GitHub Actions workflows.

The central idea is that workflow security problems do not come from triggers alone, but from combinations between triggers, event data, checkout behavior, artifacts, token permissions, and execution sites.

The tool will statically analyze GitHub Actions workflow files, detect unsafe trigger-context combinations, and suggest or synthesize behavior-preserving repairs.