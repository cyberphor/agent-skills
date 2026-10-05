# Go Programs

Use this example for a Go program with its main package in the module root. Adjust the package path when the project's command lives elsewhere. Keep only applicable tasks.

```make
# ---------------------------------------------------------
# Set the default target.
# ---------------------------------------------------------

.DEFAULT_GOAL := build

# ---------------------------------------------------------
# Build the artifact.
# ---------------------------------------------------------

.PHONY: build
.SILENT: build
build:
	go install -ldflags="-s -w" .

# ---------------------------------------------------------
# Update dependencies.
# ---------------------------------------------------------

.PHONY: update
.SILENT: update
update:
	go get -u ./...
	go mod tidy
```

`go install` installs the program in `GOBIN`, or the default Go binary directory when `GOBIN` is unset. The `-s -w` linker flags omit symbol and debugging information. Dependency upgrades remain an explicit task.

## Version Injection

Use a version flag only when the program defines a supported string variable. For a program with module path `example.com/app` and a `cmd.version` variable, a version supplied by the project's release workflow can be injected with:

```make
# ---------------------------------------------------------
# Build the artifact with a supplied version.
# ---------------------------------------------------------

.PHONY: build
.SILENT: build
build:
	go install -ldflags="-s -w -X 'example.com/app/cmd.version=$(VERSION)'" .
```

Use the actual module path and symbol. Preserve established timestamp generation when required by the project. Do not introduce timestamps or parse-time shell commands by default.
