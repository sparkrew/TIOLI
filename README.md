# LIOTI: Take It Or Leave It

LIOTI is a research prototype for studying security risks in GitHub Actions workflows.

The project focuses on how workflow behavior is shaped by triggers, event context, permissions, checkout behavior, artifacts, and execution steps. Instead of treating a trigger as risky in isolation, LIOTI explores how different workflow elements combine to create unsafe trust transitions.

At this stage, the repository is used to document the research direction, collect background material, define the analysis scope, and gradually build the tool and its evaluation methodology.

## Project goal

The goal of LIOTI is to support the study of trigger-aware security analysis for GitHub Actions workflows.

In particular, the project investigates whether unsafe workflow patterns can be better understood by looking at combinations such as:

- workflow triggers,
- event activity types,
- event-controlled data,
- checkout references,
- token permissions,
- secrets exposure,
- artifact and cache usage,
- command execution,
And workflow repair strategies.

The long-term objective is to explore how a tool can detect unsafe trigger-context combinations and suggest safer alternatives while preserving the intended purpose of the workflow.

## Why this project matters

GitHub Actions workflows are widely used to automate software development tasks such as testing, building, releasing, and deployment.

However, small configuration choices can have important security consequences. For example, a workflow may become risky when privileged execution is combined with untrusted pull request code, external event data, mutable references, or artifacts produced by less trusted workflows.

LIOTI studies these situations from a trigger-aware perspective.


