# GitHub Actions Events Catalog

## Purpose of this file

This file documents the official GitHub Actions events that can trigger workflows.

The goal is not only to list the events, but to progressively analyze their security meaning for our trigger-aware detection and repair tool.

In this project, an event is not treated as dangerous or safe by itself. The security relevance of an event depends on its context, including:

- who can trigger the workflow,
- what activity type is used,
- whether branch, tag, or path filters are configured,
- what data from `github.event` may be attacker-controlled,
- whether the workflow runs in a privileged context,
- whether secrets or write permissions are available,
- whether the workflow checks out code,
- whether it executes code or uses event-controlled data inside commands,
- whether it consumes artifacts, caches, or outputs from another workflow.

This file will be filled gradually. For now, it provides the table structure and the complete list of official GitHub Actions events to investigate.

## How to use this catalog

For each event, we will analyze the following questions:

1. What causes this event to run?
2. Who can influence or trigger it?
3. What event payload fields may be controlled by an external or untrusted actor?
4. Does the workflow run on the default branch, the event branch, a pull request merge ref, or another ref?
5. Can the workflow receive secrets or write permissions?
6. Can the event become dangerous when combined with checkout, execution, artifacts, caches, or mutable references?
7. What repair templates may be relevant if a risky combination is detected?

## Column definitions

| Column | Meaning |
|---|---|
| Event | The official GitHub Actions event name used under the `on:` key. |
| Activity types | The supported `types:` values for the event, when applicable. |
| Default branch only? | Whether the workflow only runs if the workflow file exists on the default branch. |
| Trigger source | Who or what can cause the event to happen, for example maintainer, contributor, external user, GitHub system, scheduled time, API caller, previous workflow, etc. |
| Trust level | Initial trust classification of the trigger source, for example trusted, partially trusted, untrusted, external, system, or unknown. |
| Important event fields | Relevant fields from `github.event`, especially fields that can influence refs, commands, comments, titles, labels, artifacts, or workflow decisions. |
| User-controlled data? | Whether an external actor may control some event fields. |
| Ref / SHA behavior | What `GITHUB_REF` and `GITHUB_SHA` usually point to for this event. |
| Supports filters? | Whether the event supports filters such as `branches`, `branches-ignore`, `paths`, `paths-ignore`, `tags`, or event `types`. |
| Privilege sensitivity | Whether the event is sensitive when combined with secrets, write token, deployments, repository contents, or privileged repository context. |
| Main risky combinations | The trigger-context combinations that may become dangerous. |
| Possible repair direction | Initial idea of how the tool could repair or mitigate unsafe combinations. |
| Priority | Analysis priority for our project: high, medium, low, or unknown. |
| Notes | Free notes, references, doubts, or TODOs. |

## Events table

| Event | Activity types | Default branch only? | Trigger source | Trust level | Important event fields | User-controlled data? | Ref / SHA behavior | Supports filters? | Privilege sensitivity | Main risky combinations | Possible repair direction | Priority | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `branch_protection_rule` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `check_run` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `check_suite` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `create` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `delete` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `deployment` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `deployment_status` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `discussion` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `discussion_comment` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `fork` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `gollum` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `image_version` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `issue_comment` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `issues` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `label` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `merge_group` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `milestone` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `page_build` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `public` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `pull_request` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `pull_request_comment` |  |  |  |  |  |  |  |  |  |  |  |  | Use `issue_comment` instead. |
| `pull_request_review` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `pull_request_review_comment` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `pull_request_target` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `push` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `registry_package` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `release` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `repository_dispatch` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `schedule` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `status` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `watch` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `workflow_call` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `workflow_dispatch` |  |  |  |  |  |  |  |  |  |  |  |  |  |
| `workflow_run` |  |  |  |  |  |  |  |  |  |  |  |  |  |

## Initial analysis priority

The first events to analyze should be:

| Priority | Events | Reason |
|---|---|---|
| High | `pull_request_target` | Privileged base-repository context. Dangerous when combined with untrusted checkout and code execution. |
| High | `workflow_run` | Can connect an unprivileged workflow to a privileged follow-up workflow. Important for artifact poisoning and cross-workflow trust. |
| High | `issue_comment` | Used in IssueOps patterns. Can be dangerous when comments trigger checkout or execution of pull request code. |
| High | `pull_request` | Main event for pull request code execution. Important baseline for comparing safer and unsafe PR workflows. |
| High | `workflow_dispatch` | Manual trigger with inputs. Important when inputs are used in commands, deployment logic, or privileged jobs. |
| Medium | `repository_dispatch` | External API-triggered event. Important because payload data can come from outside GitHub. |
| Medium | `push` | Common event. Usually trusted in protected branches, but risk depends on branch protection and who can push. |
| Medium | `pull_request_review` | Relevant for approval gates and TOCTOU patterns. |
| Medium | `pull_request_review_comment` | Relevant when review comments influence automation. |
| Medium | `deployment` / `deployment_status` | Relevant for deployment gates and privileged release workflows. |
| Low for now | Other events | We keep them in the catalog, but analyze them after the high-impact trigger families. |

## Notes

This catalog should evolve with the project.

When we analyze each event, we should avoid saying only "safe" or "dangerous". The better question is:

> What unsafe trust transition can happen when this event is combined with checkout, execution, permissions, artifacts, caches, mutable refs, or untrusted event fields?

This framing matches the core idea of the project: the security-relevant unit is the trigger-context combination, not the trigger alone.