# Multi-Container Projects

Use this example when the project already defines Docker Compose services. It assumes the Compose configuration defines an `all` profile. Replace that default with the project's actual profile when needed. Keep only applicable targets.

```make
# ---------------------------------------------------------
# Set default values.
# ---------------------------------------------------------

.DEFAULT_GOAL := build
export COMPOSE_BAKE := true
DOCKER_COMPOSE_PROFILE ?= all

# ---------------------------------------------------------
# Build the containers.
# ---------------------------------------------------------

.PHONY: build
.SILENT: build
build:
	docker compose --profile "$(DOCKER_COMPOSE_PROFILE)" build

# ---------------------------------------------------------
# Start the containers.
# ---------------------------------------------------------

.PHONY: start
.SILENT: start
start:
	docker compose --profile "$(DOCKER_COMPOSE_PROFILE)" up -d

# ---------------------------------------------------------
# Stop the containers.
# ---------------------------------------------------------

.PHONY: stop
.SILENT: stop
stop:
	docker compose --profile "$(DOCKER_COMPOSE_PROFILE)" down

# ---------------------------------------------------------
# Check the status of the containers.
# ---------------------------------------------------------

.PHONY: status
.SILENT: status
status:
	docker compose --profile "$(DOCKER_COMPOSE_PROFILE)" ps
```

Export `COMPOSE_BAKE` so Docker Compose receives the build setting. The profile remains caller-overridable, for example with `make start DOCKER_COMPOSE_PROFILE=api`. Starting and stopping services require explicit targets. The default target only builds images.
