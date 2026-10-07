---
name: github-actions
description: Create, revise, review, or troubleshoot GitHub Actions workflows and reusable actions. Use when automating repository checks, builds, releases, or deployments in .github/workflows, or diagnosing their failed or skipped jobs.
---

# GitHub Actions

Inspect existing workflows, action metadata, reusable configurations, repository instructions, and the commands they invoke. Establish the intended event, checked-out revision, runner, job dependencies, and required tools before editing. Preserve existing release and deployment scope.

Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) when drafting comments or explanations. Reuse it if already loaded. Apply `makefiles`, `go`, or `python` through the catalog or [Makefiles](../makefiles/SKILL.md), [Go](../go/SKILL.md), or [Python](../python/SKILL.md) skills when editing those files. Workflow commands should preserve the project's required artifacts and tooling.

## Events and Revisions

Choose triggers and branch, tag, path, and activity filters from the requested behavior. Distinguish a branch push, tag push, pull request, and manual dispatch. PR branch filters match the base branch. Normal open-PR checks use a merge ref and merge commit by default, while the head revision is available through the PR payload. `pull_request_target` uses the base context. Manual dispatch has selected-ref and input semantics and requires the workflow on the default branch.

Use event-specific fields only where that event supplies them, with appropriate fallbacks for mixed triggers. Confirm the revision checkout actually tests or releases and its history requirements. Do not derive a release version from a PR merge ref or assume `github.ref_name` is always a branch.

## Jobs and Reuse

Express ordering through `needs`. Account for failed or skipped prerequisites and the implicit success condition when writing `if` expressions. Use explicit status checks for intended cleanup or reporting, preserving cancellation behavior. Do not use `always()` to make a failed build eligible for publication.

Keep matrix combinations relevant to supported platforms and runtimes. Choose fail-fast behavior deliberately and give artifacts and outputs distinct identities when jobs run in parallel. Write step outputs through `GITHUB_OUTPUT`, map them to job outputs, and consume them through `needs`. Do not assume shared filesystems or a deterministic matrix completion order.

Call reusable workflows at job level and actions at step level. Preserve typed input and output contracts, passing only required secrets and permissions. Check local action paths and required checkout. Prefer existing Make targets for shared build or check logic. Verify the runner supplies every tool those targets require, installing tools such as uv explicitly when necessary rather than assuming runner availability.

## Trust and Deployment

Set the minimum required `GITHUB_TOKEN` permissions, adding write access only to jobs that need it. Respect repository action policies. Prefer verified full commit SHAs for external actions and reusable workflows when compatible with that policy. Confirm the commit belongs to the intended source and retain a readable version comment when useful.

Keep privileged triggers separate from untrusted PR execution. Do not check out and run contributor code under `pull_request_target` with repository secrets or write credentials. Consider scripts, local actions, dependency installation, and artifacts as possible execution paths across that boundary.

Pass untrusted event text through step `env` values or action inputs. Quote shell variables when consuming it. Interpolating `${{ ... }}` directly into a `run` script can turn a PR title or branch name into executable syntax. Do not use `eval` to process those values.

Use concurrency groups that identify the workflow and resource being coordinated. Cancel superseded checks when useful, but do not automatically cancel an in-progress deployment that needs completion or cleanup. Preserve configured environment protections. Scope OIDC token permission to the job that authenticates and constrain the provider trust to intended repository, ref or environment, and audience. Editing a workflow does not authorize cloud changes, publication, or dispatch.

## Caches and Artifacts

Key dependency caches by relevant platform, architecture, tool version, and dependency lockfile. Check that hash paths actually match files. Keep restore fallbacks compatible and preserve cache trust boundaries. Never cache credentials. Use artifacts to transfer or retain build outputs with explicit names and paths. A cache hit does not prove a build is current and does not replace a release artifact.

## Verification

Run the project's workflow checks and `actionlint` when available, using its documented invocation. Validate shell snippets with the configured shell tooling when relevant. YAML parsing alone does not validate Actions expressions, contexts, or event behavior.

Review representative intended and excluded events, including a fork PR or manual input when applicable. Trace checkout, conditions, job dependencies, permissions, outputs, and artifact paths through success, failure, and cancellation. Run authorized local build or check commands when they verify changed behavior. Inspect existing run logs for troubleshooting.

Report completed static and local checks separately from GitHub runtime results. Do not dispatch a workflow or publish a release merely to verify an edit. Identify runner, secret, environment, or cloud behavior that remains untested.

## Official References

- [Events that trigger workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows) when choosing filters or resolving event refs and payloads.
- [Workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax) when changing jobs, dependencies, outputs, reusable calls, or concurrency.
- [Secure use reference](https://docs.github.com/en/actions/reference/security/secure-use) when reviewing action pinning, token privileges, or untrusted input.
- [Dependency caching](https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching) when changing keys, restore behavior, or cache access.
- [OpenID Connect](https://docs.github.com/en/actions/concepts/security/openid-connect) when configuring short-lived cloud authentication and trust.
