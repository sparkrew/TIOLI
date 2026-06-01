# Literature Review

## Purpose of this file

This file tracks the papers, technical reports, official documentation, and security writeups related to this project.

The goal is to keep all literature notes in one place so that we can later write the related work, background, methodology, and evaluation sections of the paper without losing context.

---

## GITHUB-DOCS-EVENTS

### Title

[Events that trigger workflows](https://docs.github.com/actions/using-workflows/events-that-trigger-workflows)

### Visited
June 1, 2026

### Source type

Official documentation


### One-line summary

This GitHub Docs page lists the official events that can trigger GitHub Actions workflows and explains their activity types, filtering behavior, and event-specific semantics.

### Problem addressed

This documentation explains how GitHub Actions workflows are triggered using the `on:` key. It describes the official events supported by GitHub Actions and explains how events can be restricted using activity types, branches, tags, paths, or other filters depending on the event.


### Main findings

The page provides the official list of workflow events and explains important trigger-specific behavior.

It also clarifies that comments on pull request conversations are handled through the `issue_comment` event, because pull requests are also issues in GitHub’s model.

### Relation to our project

This page is a primary source for the trigger catalog in `docs/02-github-actions-events.md`.

It helps define the first layer of our trigger-aware model: the official event name, activity types, filters, and event-specific behavior.

The page is also useful for identifying which events should be analyzed first, especially events that may introduce unsafe trust transitions when combined with checkout, execution, permissions, artifacts, or untrusted event fields.


### Notes

Use this source when introducing GitHub Actions triggers and when justifying the event catalog used by LIOTI.


---

## EVOLUTION-GHA-2026

### Title

[An Empirical Study of the Evolution of GitHub Actions Workflows](https://arxiv.org/abs/2602.14572)


### Venue & Year

Journal of Systems and Software / arXiv 2026

### Source type

Research paper


### One-line summary

This paper studies how GitHub Actions workflows evolve over time and shows that workflows are living configuration code, not static files.

### Problem addressed

The paper studies how GitHub Actions workflow files change over time. It is not directly a security paper, but it is useful for software supply chain security because it shows that workflows evolve, get updated, break, get patched, and are maintained like normal software artifacts.

### Method

The authors perform a large-scale empirical study of workflow histories. They classify workflow changes into conceptual categories and analyze how frequently workflow files are modified.

The study uses more than 49K repositories, 267K workflow histories, and 3.4M workflow file versions from 2019 to 2025.

### Main findings

Repositories usually have a median of three workflow files. Around 7.3% of workflow files are modified every week. Workflow files are updated on average every 159 days, and most changes are small, usually one change at a time.

The most common changes are related to task specification and task configuration, meaning maintainers mostly edit jobs and steps rather than rewriting the entire workflow structure.

Around 80% of workflow modifications are concentrated in only ten workflow paths, mostly inside jobs and steps.

### Relation to our project

This paper supports the idea that GitHub Actions workflows should be treated as maintainable configuration code. For our project, this matters because the proposed tool is not only about detecting a problem once. It is also about helping developers safely update and repair workflows.

The paper motivates repair-oriented tooling because workflows change over time and security problems may be introduced, removed, or modified during normal maintenance.

### What it does not cover

The paper is not mainly about security. It does not focus on unsafe trigger-context combinations, privileged triggers, untrusted checkout, artifact poisoning, or automated repair.

### Notes

Use this paper in the motivation or background to argue that workflow files are actively maintained and that repair tools should support small, practical workflow changes.


---

## BEYOND-YAML-2026

### Title

[Beyond the YAML File: Understanding Real-World GitHub Actions Workflow Adoption](https://arxiv.org/abs/2604.17662)



### Venue & Year

EASE 2026 / arXiv

### Source type

Research paper


### One-line summary

This paper shows that the existence of a workflow YAML file does not necessarily mean that the workflow is actively used.

### Problem addressed

The paper challenges a common assumption in GitHub Actions research: that if a `.github/workflows/*.yml` file exists, then the project actively uses GitHub Actions.

It argues that researchers should also look at workflow runs, execution records, triggers, failures, and developer reactions.

### Method

The authors analyze workflow run records and perform a deeper manual analysis of selected repositories. They study how workflows are triggered, whether they pass or fail, and how developers react after failures.

The authors analyze 258,300 workflow run records from 952 repositories. They then focus on 765 repositories with run records and perform a deeper manual analysis of 21 repositories.

### Main findings

The paper identifies three developer reactions to workflow failures:

1. Immediate fixing, where developers fix the workflow failure within minutes or hours.
2. Deferred fixing, where the failure is tolerated for days or months.
3. Ignore or abandon, where the failure is not fixed immediately and may later be disabled or removed.

The paper also finds that repositories with more workflow runs tend to have lower failure rates.

A major finding is the configuration-usage gap: some repositories contain workflow files, but the workflows may be disabled, unused, or abandoned.

### Relation to our project

This paper is useful because it pushes us to think beyond static workflow scanning. A workflow may look risky in YAML, but maybe it never runs. Or a workflow may look simple statically, but its real execution pattern may be risky because of triggers, failures, or ignored broken runs.

For our current scope, we still start with static analysis, but this paper gives us a possible future extension: usage-aware trigger security.

### What it does not cover

The paper does not propose a trigger-aware vulnerability detector or repair tool. It is mainly about adoption and usage behavior, not workflow security repair.

### Notes

Use this paper to discuss the limitation of static workflow-only datasets and to justify future work that combines YAML analysis with workflow execution behavior.

---

## COSSETER-2026

### Title

[COSSETER: GitHub Actions Permission Reduction Using Demand-Driven Static Analysis](https://enck.org/pubs/tystahl-sp26.pdf)


### Venue & Year

IEEE Symposium on Security and Privacy 2026

### Source type

Research paper


### One-line summary

COSSETER automatically infers reduced GitHub Actions permissions to limit the impact of workflow vulnerabilities.

### Problem addressed

Many GitHub Actions workflows run with too much privilege. If a workflow contains a vulnerability, such as command injection, excessive permissions can make the impact much worse.

COSSETER tries to automatically infer the minimum permissions needed by each workflow job.

### Method

COSSETER uses demand-driven static analysis. It analyzes JavaScript actions and workflow steps to infer what GitHub permissions are actually needed.

The analysis handles challenges such as packed JavaScript actions, npm dependency state explosion, GitHub API routes, Octokit calls, environment variables, Git CLI commands, and Bash steps.

The authors analyze 1,842 vulnerable workflows from prior work and extract permission summaries for 8,353 JavaScript actions.

### Main findings

COSSETER’s suggested permissions can reduce 76% of 1,274 high-severity code injection vulnerabilities into medium, low, or no severity.

The main lesson is that even when a vulnerability still exists, reducing permissions can reduce its impact.

### Relation to our project

This paper is directly relevant to the repair side of our project. Our tool detects unsafe trigger-context combinations, but some repairs may involve reducing permissions rather than changing the trigger.

This is important because the danger often comes from the combination of:

- untrusted input,
- dangerous execution,
- and excessive token permissions.

COSSETER focuses mainly on the permission part, while our project focuses on trigger-context combinations and behavior-preserving repair.

### What it does not cover

COSSETER does not mainly target trigger-context combinations. It also does not fully prove that its suggested permissions preserve workflow functionality.

The paper misses calls made inside external scripts called from JavaScript, does not consider third-party APIs beyond GitHub APIs, and excludes some workflows using composite, local, Docker actions, non-Bash shells, minified JavaScript, or cases where the analysis timed out or failed.

### Notes

Use this paper in the repair-related work section to show that permission reduction is an important repair strategy, but our work targets a different semantic unit: trigger-context trust transitions.


---

## ARGUS-2023

### Title

[ARGUS: A Framework for Staged Static Taint Analysis of GitHub Workflows and Actions](https://www.usenix.org/conference/usenixsecurity23/presentation/muralee)


### Venue & Year

USENIX Security 2023

### Source type

Research paper


### One-line summary

ARGUS detects GitHub Actions code injection vulnerabilities using staged static taint analysis across workflows and actions.

### Problem addressed

The paper addresses code injection vulnerabilities in GitHub Actions workflows.

The authors argue that simple pattern-based scanners are not enough because workflows are not flat YAML files. Workflows can contain jobs, steps, actions, reusable workflows, outputs, environment variables, secrets, and data flows between these elements.

### Method

ARGUS tracks tainted data from attacker-controlled sources to dangerous sinks.

Tainted sources may include GitHub event fields such as issue titles, pull request bodies, branch names, commit messages, or other event payload values.

Dangerous sinks include shell commands, `exec`, `eval`, or other code execution points.

A key technical contribution is the Workflow Intermediate Representation, or WIR. WIR models jobs, steps, job dependencies, inputs, outputs, environment variables, and communication between steps.

ARGUS also analyzes third-party JavaScript and Composite actions separately and creates taint summaries for them.

The authors analyzed 2,778,483 workflows from 1,014,819 repositories referencing 31,725 actions.

ARGUS raised alerts on 27,465 workflows. The authors manually verified a sample and confirmed 5,298 vulnerable workflows.

Among these, 4,307 high or medium severity workflows could compromise the underlying repository.

They also found 80 vulnerable actions.

The paper also includes VWBENCH, a small ground-truth benchmark of 24 previously reported vulnerable workflows.

### Main findings

ARGUS found more vulnerabilities than older pattern-based tools such as GHAST and GitSec because it tracks data flow instead of only checking suspicious patterns.

The paper shows that semantic workflow analysis is stronger than simple pattern matching for GitHub Actions code injection.

### Relation to our project

ARGUS is one of the most important comparison points for our project.

It shows that GitHub Actions security analysis needs semantic reasoning. However, ARGUS mainly focuses on source-to-sink taint analysis for code injection.

Our project has a different focus: trigger-context combinations as the main semantic unit, and behavior-preserving repair as a first-class goal.

### What it does not cover

ARGUS does not cover all GitHub Actions weaknesses. It supports JavaScript and Composite actions, but not Docker actions. It does not track taint flows through files, does not evaluate conditional expressions between steps, and its impact classifier uses workflow-level permissions rather than full job-level permission reasoning.

It is also focused on code injection, not on a broader trigger-centered repair framework.

### Notes

Use ARGUS in related work to position our project against taint-analysis approaches. The key distinction is that ARGUS follows attacker-controlled data to execution sinks, while our tool models unsafe trust transitions starting from the trigger and maps them to repair templates.
