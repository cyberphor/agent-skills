---
name: write-go
description: Write, revise, or review Go code in our preferred style. Use this skill whenever creating or modifying Go files, examples, tests, command-line tools, APIs, MCP servers, or code snippets.
---

## Variable declarations

Collect every local variable into a single `var (...)` block at the top of the function, one per line, ordered alphabetically, types aligned via gofmt. Assign with `=` afterward rather than declaring inline with `:=` throughout the function body.

```go
func getSystems(cmd *cobra.Command, args []string) error {
	var (
		endpoint string
		err      error
		params   url.Values
		response *http.Response
		system   models.System
		systems  []models.System
	)

	params = url.Values{}
	...
}
```

## Error handling

Check every error immediately after the call that produced it, and return early with no `else`:

```go
systems, err = config.FilterSystems(config.Data, activeProfile, systemIDs)
if err != nil {
	return err
}
```

Compose small unexported helper functions that each do one thing and return `(T, error)`, chaining them rather than writing one large function. Use plain `fmt.Errorf("lowercase message %s", detail)` with no trailing period; only wrap with `%w` when a caller needs to unwrap the underlying error.

## Readability

Give each logical step its own blank-line-separated paragraph. Precede non-obvious steps with a short sentence-case comment ending in a period that explains why, not just what. Give every exported function a doc comment in the form `// FuncName verb-phrases what it does.`

## CLI commands (Cobra)

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

Favor the standard library. Use `net/http` and `net/url` directly instead of HTTP client wrapper libraries. Only bring in a third-party package with clear justification.

## Checklist

- No inline `:=` declarations when a function has more than one local variable.
- No error silently dropped or checked more than one call late.
- No `else` following a block that ends in `return`.
- Every exported identifier has a doc comment.
- Blank lines separate logical steps — no dense walls of statements.
