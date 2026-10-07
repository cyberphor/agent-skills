---
name: docker-compose
description: Create, revise, or troubleshoot Docker Compose service configurations. Use for local or existing Compose application workflows, service connectivity, and startup failures.
---

# Docker Compose

Inspect the Compose files, overrides, profiles, environment inputs, Dockerfiles, and existing task commands before editing. Use Compose v2 through `docker compose`. Preserve service names, persistent data, and the intended development or deployment scope. Do not add the obsolete top-level `version` key.

Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) when drafting comments or explanations. Reuse it if already loaded. Resolve `makefiles` through the catalog or [sibling skill](../makefiles/SKILL.md) when changing Makefile tasks.

## Service Configuration

Use service names and container ports for communication between services on a shared network. Publish host ports only when host access is required. Add separate networks when the application needs isolation rather than for every service by default.

Choose named volumes for persistent service data and bind mounts for intentional host-file access. Check mount paths, permissions, and whether a mount hides image contents. Preserve existing volumes during troubleshooting.

Distinguish Compose variable interpolation from the environment passed to containers. Inspect the effective configuration with the same files, profiles, and environment inputs as the real invocation. Avoid exposing resolved credentials in shared output. Use Compose secrets when the application supports file-based credentials, granting them only to consuming services.

## Readiness

Startup order does not establish application readiness. Use a meaningful `healthcheck` and `depends_on` with `condition: service_healthy` when a dependent service must wait for readiness. Use `service_completed_successfully` for a required one-shot prerequisite. Keep application retry behavior where dependencies can become unavailable after startup.

## Verification

Run `docker compose config --quiet` with the project's actual options to validate configuration. Within the authorized scope, build and start the affected services, inspect `docker compose ps` and relevant logs, and verify the application's service-to-service connection or endpoint.

Do not treat configuration validation as a runtime test. Avoid `down --volumes`, unrelated restarts, and production changes unless the task authorizes them. Report remaining failures and checks that could not run.

## Official References

- [Compose file reference](https://docs.docker.com/reference/compose-file/) for current service and resource settings.
- [Startup and shutdown order](https://docs.docker.com/compose/how-tos/startup-order/) for readiness conditions.
- [Compose secrets](https://docs.docker.com/compose/how-tos/use-secrets/) for service credential access.
- [docker compose config](https://docs.docker.com/reference/cli/docker/compose/config/) for effective configuration validation.
