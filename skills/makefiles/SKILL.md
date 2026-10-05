---
name: makefiles
description: Create, revise, or review Makefiles in our preferred style. Use when adding project task automation, changing build or test workflows, or editing Make targets and recipes.
---

# Makefiles

Use Makefiles as a readable entrypoint for routine project tasks. Inspect the existing Makefile, project configuration, and invoked tools before editing. Align targets being changed with these preferences, including small directly related changes needed for consistency. Established inconsistent style alone does not override these preferences. Respect explicit user and repository instructions and configuration. Preserve target interfaces, required tooling, and behavior unless the relevant preference or task calls for a change. Avoid unrelated project-wide target renames, restructuring, or reformatting.

Read and apply the `writing-style` skill from the authoritative skill source when writing comments or task descriptions. Reuse it if already loaded.

## Layout

Put settings at the top: shell selection, default goal, project metadata, paths, and tool configuration. Set `.DEFAULT_GOAL` explicitly. Choose a routine build or check target for new projects. Deployment, destructive cleanup, and migration resets need explicit targets.

Use matching divider comments around a short sentence describing each settings group or task. Put `.PHONY: target` and `.SILENT: target` immediately before each task target. Use literal tabs for recipes and continuation indentation, with blank lines between task blocks. Real output-file targets should retain file-based dependency tracking rather than being declared phony.

```make
# ---------------------------------------------------------
# Default settings.
# ---------------------------------------------------------

.DEFAULT_GOAL := check
APP ?= example
BUILD_CONTEXT ?= src

# ---------------------------------------------------------
# Check the source code for quality.
# ---------------------------------------------------------

.PHONY: check
.SILENT: check
check:
	echo "[*] Checking $(APP)'s source code quality"
	ruff check "$(BUILD_CONTEXT)"
```

Use concise `echo "[*] ..."` progress messages for multi-step or quiet tasks. Silence command echoing while leaving tool output and failures visible. Avoid redundant `@` prefixes on targets covered by `.SILENT`.

## Settings and Variables

Use uppercase names with underscores. Centralize repeated paths, images, services, profiles, and scanner thresholds. Prefix component-specific settings in multi-service projects.

Invoke well-known tools by their literal names, such as `go` and `gofmt`. Do not add configurable command variables such as `GO` or `GOFMT` unless the project explicitly requires an alternate executable or wrapper.

- Use `?=` for caller-overridable defaults and `:=` for fixed or derived values that should expand once. Command-line assignments still override ordinary Makefile assignments. Avoid `override` without a concrete requirement.
- Use `$(NAME)` for Make variables. Quote path arguments and individual values in recipes.
- Export settings needed by subprocesses, such as `export COMPOSE_BAKE := true` or a normalized workspace path. A Make assignment alone does not reliably expose a value to tools.
- Use `include` for required files containing valid Make syntax and `-include` for intentional optional files. Dotenv files are not necessarily valid Make syntax. Prefer the consuming tool's `--env-file` option. Never echo secret values.

Keep shell work out of parse-time `$(shell ...)` where practical. It can run for unrelated targets and dry runs. Validate failures explicitly when deriving configuration from external tools.

## Recipes and Dependencies

Each recipe line normally runs in a separate shell. Keep a directory change and its command together: `cd "$(BUILD_CONTEXT)" && uv lock`. Use `&&` with backslash continuations when commands must share state or stop after a failure. Set `SHELL := /bin/bash` when Bash syntax is needed. Otherwise match the selected shell.

Escape shell dollars as `$$`: `$$VALUE` for shell variables and `$$(date ...)` for shell command substitution. Make expands `$(VALUE)` before the shell runs, even inside shell quotes. Export multiline `define` values when passing them through the environment and consume them as `"$$NAME"`. Pass data as quoted environment values rather than interpolating it into filter or program source.

Express real dependencies in the target graph. Recipes wait for all prerequisites, but `build: lock check format` does not sequence those prerequisites under `make -j`. Chain dependencies or use sequential recipe commands when order matters, especially when tasks modify the same files. Use `$(MAKE)` for recursive Make calls so flags and job scheduling propagate.

Let failed commands fail the target. Avoid blanket `|| true`, ignored errors, and pipelines that hide failures. Handle only expected absence explicitly. Keep check-only tasks distinct from fixing or formatting tasks. Preserve existing names while making mutation clear in their descriptions.

## Project Workflows

Include only workflows supported by the project. Reuse established targets such as `check`, `format`, `build`, and `update`. Suffix container tasks when that distinguishes them from local tasks.

**Go.** For a new Go program Makefile, set `.DEFAULT_GOAL := build` and use `go install -ldflags="-s -w" .` in `build`. When an existing build target is in scope, align it with this install convention when applicable, preserving required linker flags, package paths, and output contracts. Retain artifact-building commands when installation would not satisfy the project's required outputs. Add version injection only when the program supports it, using the actual module path and symbol. Do not add timestamp generation or parse-time shell commands by default. Keep dependency upgrades in an explicit `update` task that runs `go get -u ./...` followed by `go mod tidy`, rather than in an ordinary build.

Read [the Go example](references/go-projects.md) when creating or revising a Go program's build and dependency update tasks.

**Python.** In projects using uv, run `uv lock` in the appropriate project directory and `uv run` for project commands. Use Ruff for checks and formatting when configured. Lockfile updates and fixes are mutating tasks, not universal build prerequisites.

**Containers.** Use Docker Compose for configured services. Centralize repeated arguments when useful, expose a configurable profile, and provide applicable build, start, stop, status, and test tasks. Export settings needed by Compose. Normalize and validate workspace paths before using them as mounts.

Read [Multi-Container Projects](references/multi-container-projects.md) when creating or revising tasks for a project with multiple Docker Compose services.

**Security.** Where configured, expose secret scanning, Dockerfile linting, source analysis, software bill of materials (SBOM) generation, vulnerability exploitability exchange (VEX) generation, and dependency scanning as separate tasks. Existing tools may include TruffleHog, Hadolint, Semgrep, Syft, yq, and Grype. Keep scanner configuration and failure thresholds configurable. Connect image build → image SBOM → dependency scan, with VEX generated before a scan that consumes it. Apply gates where required and retain nonzero failure status. Do not impose the whole toolchain on every project.

Keep deployment, provisioning, migration deletion, image removal, and other destructive operations out of new default goals and ordinary build prerequisites. Existing examples establish style, not authorization to copy those operations or hide failures.

## Verification

Check target names, literal tabs, variable overrides, exported settings, dependency order, and failure propagation. Inspect before a dry run: `make -n` can still evaluate `$(shell ...)`, remake included files, and run recipe lines containing recursive `$(MAKE)` or prefixed with `+`. Use trusted nonmutating fixtures for isolated checks. Run relevant project targets within the task's authorized scope.
