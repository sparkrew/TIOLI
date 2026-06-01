# Threat Model and Scope

## In scope

- GitHub Actions workflow YAML files.
- Trigger-related unsafe combinations.
- Privileged triggers such as pull_request_target and workflow_run.
- Untrusted checkout.
- Event-context injection into run steps.
- Artifact reuse across workflows.
- Mutable references after approval or label gates.
- Token permission risks.

