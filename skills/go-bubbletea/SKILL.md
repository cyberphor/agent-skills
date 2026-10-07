---
name: go-bubbletea
description: Create, revise, or troubleshoot Go terminal interfaces using Bubble Tea. Use for model updates, commands, messages, rendering, and terminal lifecycle behavior.
---

# Go Bubble Tea

Read and apply `go` from the active skill catalog or [sibling skill](../go/SKILL.md) for Go style, package organization, errors, and Makefiles. Reuse it if already loaded.

Inspect `go.mod`, imports, existing models, component dependencies, and tests before selecting APIs. Preserve the installed major version unless migration is requested. Check Bubbles and Lip Gloss compatibility when using those libraries.

## Version Boundaries

Do not mix these API families:

| API | Bubble Tea v1 | Bubble Tea v2 |
| --- | --- | --- |
| Import | `github.com/charmbracelet/bubbletea` | `charm.land/bubbletea/v2` |
| View | `View() string` | `View() tea.View` |
| Key presses | `tea.KeyMsg` | `tea.KeyPressMsg` |
| Alternate screen | Program options such as `tea.WithAltScreen()` | The returned view's `AltScreen` field |

Both use `Init() tea.Cmd` and `Update(tea.Msg) (tea.Model, tea.Cmd)`. In v2, construct rendered views with the supported `tea.View` API, such as `tea.NewView(content)`. Consult the installed version's documentation for terminal options and message fields rather than adapting signatures from another major version.

## Model and Effects

Keep UI state in the model. Use `Init` for initial commands, `Update` to process messages and change state, and `View` to render that state. Keep `Update` and `View` free of blocking I/O, sleeps, and long-running work.

Perform asynchronous work through commands that return result or error messages. Capture immutable inputs or explicit copies when creating commands. Do not mutate the model or shared maps, slices, or component state from command goroutines. Apply results in `Update`, retaining original errors in error messages.

Use `tea.Batch` for independent commands without assuming completion order. Use the installed version's sequencing primitive when effects truly require ordering. Track request identity or cancellation when stale results could overwrite newer state. Return child-component commands when forwarding messages to components.

## Interaction and Lifecycle

Handle keyboard input according to focus so global bindings do not consume normal text entry. Provide the requested quit behavior through `tea.Quit`, preserving framework terminal cleanup. Handle window-size messages and narrow terminal layouts without assuming fixed dimensions.

Keep normal diagnostic output from corrupting the active terminal renderer. Display recoverable failures in the model and propagate fatal program errors through the existing entrypoint. Bound external work and cancel owned background activity when the program exits.

## Verification

Run `gofmt` and relevant project checks and tests. When behavior warrants tests, feed deterministic key, resize, success, and failure messages into `Update` and assert observable state or rendered output. Verify effects separately with controlled inputs instead of timing-dependent terminal tests. Use the race detector when changed shared-state behavior warrants it.

For an interactive change, verify focus, resizing, the relevant loading or error state, quitting, and terminal restoration in a real terminal when available. Report what was tested and any terminal limitations.

## Official References

- [Bubble Tea](https://github.com/charmbracelet/bubbletea) for current architecture and examples.
- [Bubble Tea v1 reference](https://github.com/charmbracelet/bubbletea/tree/v1.3.10) for the v1 API family. Consult the project's exact version when needed.
- [v2 upgrade guide](https://github.com/charmbracelet/bubbletea/blob/main/UPGRADE_GUIDE_V2.md) for import, view, input, and terminal API differences.
- [Commands tutorial](https://github.com/charmbracelet/bubbletea/tree/main/tutorials/commands) for command and message separation.
