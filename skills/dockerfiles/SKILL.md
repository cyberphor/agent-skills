---
name: dockerfiles
description: Create, revise, or review Dockerfiles and their build contexts. Use for container image builds, runtime packaging, and Dockerfile failures.
---

# Dockerfiles

Inspect the existing Dockerfile, build context, dependency manifests, image consumers, and runtime requirements before editing. Preserve required entrypoints, ports, architecture support, and artifact paths. Apply changes to the requested image rather than imposing a new deployment workflow.

Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) when drafting comments or explanations. Reuse it if already loaded.

## Image Design

Choose a maintained base image compatible with the application's runtime and native dependencies. Preserve the project's tag or digest policy. A smaller image is useful only when it still supplies required libraries, certificates, and runtime files.

Use named multi-stage builds when build tools or intermediate artifacts are unnecessary at runtime. Copy only required outputs into the final stage. Inspect linking requirements before choosing a minimal runtime image.

Put dependency manifests and their installation before frequently changing source files when that preserves correct cache invalidation. Use build cache mounts when useful and supported. Keep `.dockerignore` aligned with the actual context, excluding secrets, local environments, and unnecessary artifacts without excluding required inputs.

## Runtime and Secrets

Prefer a nonroot runtime user when compatible with application permissions and mounted files. Set ownership for required writable paths instead of granting broad permissions. Use exec-form entrypoints and commands when the application should receive process signals directly.

Never put secrets in `ARG`, `ENV`, copied files, or image layers. Use BuildKit secret or SSH mounts for build credentials and the deployment's existing mechanism for runtime secrets. Removing a file in a later layer does not remove it from earlier layers.

## Verification

Build the actual Dockerfile with its intended context, target, and platform. Run a disposable container with representative required configuration and check startup, the relevant command or endpoint, permissions, and shutdown. Keep credentials out of logs. A successful build alone does not verify runtime behavior.

Report the image changes and checks actually completed. If Docker or required dependencies are unavailable, identify the missing runtime checks. Do not push images or change a deployment unless the task authorizes it.

## Official References

- [Docker build best practices](https://docs.docker.com/build/building/best-practices/) for image design, caching, and context exclusions.
- [Multi-stage builds](https://docs.docker.com/build/building/multi-stage/) for stage selection and artifact copying.
- [Build secrets](https://docs.docker.com/build/building/secrets/) for credential mounts.
