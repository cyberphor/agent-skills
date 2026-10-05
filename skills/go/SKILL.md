---
name: go
description: Write, revise, or review Go code in our preferred style. Use this skill whenever creating or modifying Go files, examples, tests, command-line tools, APIs, MCP servers, or code snippets.
---

# Go Writing Style

Write Go code with explicit control flow, focused packages, and consistent conventions.

## Incremental Adoption

Inspect relevant code and project configuration before editing. Apply these preferences to the functions and code being changed, including small directly related changes needed for consistency. Established inconsistent style alone does not override these preferences. Respect explicit user and repository instructions and configuration. Preserve behavior, public interfaces, and required tooling unless the task calls for changing them. Avoid unrelated project-wide renames, restructuring, or reformatting.

## Prose

Read and apply the `writing-style` skill from the authoritative skill source when drafting or revising READMEs, documentation, command help, or explanatory comments. Reuse it if already loaded. Preserve Go doc-comment syntax and the code conventions below.

## Package Organization

Keep `main.go` minimal: delegate to the `cmd` or application package and handle the process exit. Put execution and orchestration functions in those packages rather than in `main.go`.

Prefer conventional short package names such as `cmd` rather than `command`. Preserve existing package names and public interfaces when modifying a repository. Do not rename unrelated packages to enforce this preference.

Organize code into packages by responsibility. Keep all struct definitions in a shared `models` or `types` package. Choose one name consistently. Files defining structs should contain only those definitions and functions or methods that add functionality to those types. Keep configuration parsing, API requests, and report orchestration in their responsible packages. This organization does not require a separate `go.mod` for each package.

## Variable Declarations

Collect every local variable into a single `var (...)` block at the top of the function, one per line, ordered alphabetically, types aligned via gofmt. Assign with `=` afterward rather than declaring inline with `:=` throughout the function body.

```go
package names

import "strings"

// Normalize trims a name and converts it to lowercase.
func Normalize(name string) string {
	var (
		normalized string
	)

	normalized = strings.TrimSpace(name)

	return strings.ToLower(normalized)
}
```

## Error Handling

Check every error immediately after the call that produced it, and return early with no `else`:

```go
systems, err = config.FilterSystems(config.Data, activeProfile, systemIDs)
if err != nil {
	return err
}
```

Compose small unexported helper functions that each do one thing and return `(T, error)`, chaining them rather than writing one large function.

Return existing errors unchanged. Do not add contextual text, wrap them, or reconstruct them from their messages. When an operation must retain multiple failures, preserve the original errors, using `errors.Join` when aggregation is needed. Do not add prefixes or discard errors. Simple operations should return their single error directly.

Create a new error when there is no underlying error, such as invalid input or an unsuccessful HTTP status. Use a lowercase message with no trailing period. Use `fmt.Errorf` when the new message requires formatting.

## Readability

Use descriptive, spelled-out variable and function names, such as `configuration` rather than `cfg`. Preserve established initialisms and conventional Go names such as `err`. Conventional short package names such as `cmd` are an exception to the spelled-out naming preference.

Give each logical step its own blank-line-separated paragraph. Precede non-obvious steps with a short sentence-case comment ending in a period that explains why, not just what. Give every exported function a doc comment in the form `// FuncName verb-phrases what it does.`

## CLI Commands (Cobra)

Use Cobra for command-line tools instead of manually registering and parsing flags. Cobra is the preferred exception to the standard-library dependency default.

Structure one subpackage per command group, each with a `cmd.go` declaring the parent command and registering child commands in `init()`, plus one file per leaf command.

Per leaf command file:

- A package-level `var (...)` block for flag-backed variables, named `<resource><FlagName>` in camelCase.
- A second `var (...)` block declaring the `*cobra.Command` (`Use`, `Short`, `RunE`).
- The `RunE` function named after the command (e.g. `getSystems`).
- An `init()` that registers only that command's flags — subcommand registration belongs in the group's `cmd.go`.

## Structs

Tag every field with `mapstructure`, `json`, and `yaml`, aligned in columns by gofmt:

```go
type System struct {
	ID   int    `mapstructure:"id" json:"id" yaml:"id"`
	Name string `mapstructure:"name" json:"name" yaml:"name"`
}
```

## Dependencies

Favor the standard library, with Cobra preferred for command-line tools. Use `net/http` and `net/url` directly instead of HTTP client wrapper libraries. Only bring in another third-party package with clear justification.

## Makefiles

Read and apply the `makefiles` skill from the authoritative skill source when creating or modifying a Makefile. Reuse it if already loaded.

Include a root `Makefile` when creating a Go project. When changing a project, reuse its existing Makefile and align affected tasks with the `makefiles` skill. Expose applicable routine tasks such as `build`, `run`, `test`, `check`, and `format` using the repository's required tools. Include only tasks that apply to the project. Standalone snippets do not require a Makefile.

## Generic Examples

Read [the code examples](references/code-examples.md) when implementing an entrypoint, shared model, helper chain, or HTTP integration. Adapt the examples to the project's behavior and configuration.

## Checklist

- Every local variable is declared in one alphabetical `var (...)` block at the top of its function, with no inline `:=` declarations.
- No error silently dropped or checked more than one call late.
- Existing errors are returned or aggregated unchanged.
- No `else` following a block that ends in `return`.
- Every exported identifier has a doc comment.
- Blank lines separate logical steps — no dense walls of statements.
