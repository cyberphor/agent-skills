---
name: python
description: Write, revise, or review Python code in our preferred concise, explicit, service-oriented style. Use for Python modules, APIs, MCP servers, automation, integrations, parsers, and tests when creating or modifying Python code.
---

# Python Writing Style

Use this skill to produce Python that is explicit, readable, typed, and operationally simple.

## Prose

Read and apply the `writing-style` skill from the authoritative skill source when drafting or revising READMEs, documentation, command help, explanatory comments, or docstrings. Reuse it if already loaded. Preserve Python comment and docstring formats and the code conventions below.

## Precedence

Follow rules in this order:

1. The user's explicit instructions.
2. Repository-local instructions and configuration.
3. This skill.
4. Established conventions where this skill leaves a choice open.

Apply these preferences to the functions and code being changed, including small directly related changes needed for consistency. Established inconsistent style alone does not override these preferences. Preserve behavior, public interfaces, and required tooling unless the task calls for changing them. Avoid unrelated project-wide renames, restructuring, or reformatting.

Before writing code, inspect the nearest relevant Python files plus `pyproject.toml`, tests, and lint or formatting configuration when available.

## Core Style

Prefer simple, direct code over abstraction for its own sake.

- Keep functions focused on one clear responsibility.
- Use descriptive variable and function names rather than abbreviations. Conventional short package and module names such as `cmd` are an exception.
- Prefer guard clauses when they reduce nesting.
- Avoid new classes, wrappers, factories, compatibility layers, dependencies, and configuration options unless they solve a concrete requirement.
- Keep orchestration code easy to read from top to bottom.
- Preserve asynchronous behavior in asynchronous code.
- Use framework-native patterns instead of recreating functionality manually.
- Keep side effects visible and close to the code that initiates them.

## Package and Module Names

Prefer conventional short package and module names such as `cmd` rather than `command`. Preserve existing names and public interfaces when modifying a repository. Do not rename unrelated packages or modules to enforce this preference.

## Imports

Group imports in this order and separate groups with one blank line:

```python
# Standard library imports.

# Third party imports.

# Local imports.
```

Include only groups that are present. Prefer direct imports of the symbols actually used. Remove unused imports.

Do not reorganize an existing file solely to add import headings when that would create unrelated churn, but use this convention in new modules and when materially editing the import section.

## Constants and Configuration

Place module-level constants after imports. When the surrounding project uses section headings, label the block:

```python
# Constants.
```

Use uppercase names for true module-level constants.

For environment-based configuration:

- Use `environ["NAME"]` when the value is required.
- Use `getenv("NAME", default)` when a default is intentional.
- Convert environment strings to their required types explicitly.
- Fail early with a clear error when startup cannot continue without a required setting.
- Do not embed secrets, credentials, or environment-specific endpoints in source code.
- Prefer configuration at startup or construction boundaries rather than scattering environment reads through business logic.

## Types

Use modern Python type syntax.

- Add parameter and return types to public functions and non-trivial helpers.
- Prefer built-in generics such as `list[str]`, `dict[str, str]`, and `tuple[str, ...]`.
- Prefer unions such as `str | None`.
- Use `TypedDict`, dataclasses, Pydantic models, or framework schemas when structured data has a stable shape.
- Use `Any` only when the boundary is genuinely dynamic.
- Do not add complex typing that makes straightforward code harder to read.

## Functions and Control Flow

Write functions so their behavior is apparent without tracing unnecessary layers.

- Validate assumptions near the boundary.
- Raise a specific exception when callers need to distinguish a domain failure.
- Chain exceptions with `raise ... from exc` when translating a lower-level failure.
- Use `match` when dispatching across a small, explicit set of named modes and it is clearer than repeated conditionals.
- Use comprehensions when they remain immediately readable.
- Prefer explicit loops when they carry branching, error handling, or multiple side effects.
- Return structured data instead of encoding structure into strings unless a text interface specifically requires text.

## Filesystem and Serialization

Prefer `pathlib.Path` for filesystem work.

- Specify text encodings explicitly.
- Create parent directories only when the operation is expected to create output.
- Use standard-library serializers when they are sufficient.
- Keep parsing and serialization logic separate from orchestration when either becomes non-trivial.
- Validate file type, existence, or schema when failure would otherwise be ambiguous.

## Async and HTTP

Use asynchronous libraries consistently inside asynchronous workflows.

- Reuse an async client when lifecycle and scope make that practical. Otherwise use a clearly scoped context manager.
- Call `raise_for_status()` before consuming successful response data.
- Use explicit request parameters and headers.
- Use reasonable timeouts unless the surrounding framework manages them.
- Do not disable TLS verification except when the user explicitly requires it for a controlled environment and the security tradeoff is understood.
- Let transport errors propagate unless the caller needs a domain-specific error.

## Comments

Write comments as complete sentences ending with periods.

Comments should explain intent, lifecycle, constraints, or a non-obvious choice. Do not narrate obvious syntax.

Good:

```python
# Register tools after applying the configured policy.
```

Avoid:

```python
# Loop through tools.
```

Short section comments are appropriate for lifecycle-oriented modules, such as:

```python
# Get environment variables.
# Init the API.
# Register tools with the server.
# Start the server.
```

Use them only when they improve scanability.

## Docstrings

Use concise docstrings for public modules, classes, functions, methods, tools, routes, and non-obvious helpers.

Prefer this structure when the sections are useful:

```python
def load_record(path: str) -> dict[str, str]:
    """Load a record from a JSON file.

    Args:
        path: Path to the JSON file.

    Returns:
        The parsed record.

    Raises:
        RecordError: If the record cannot be loaded.
    """
```

Do not repeat information that is already obvious from a good name, signature, and type annotations.

## Strings, Formatting, and Layout

Unless repository tooling says otherwise:

- Use four-space indentation.
- Use double-quoted strings.
- Use f-strings for interpolation.
- Use trailing commas in multiline calls, collections, and signatures.
- Keep multiline calls vertically readable.
- Follow PEP 8-compatible line lengths.
- Separate top-level definitions with two blank lines.

Let the configured formatter decide final whitespace.

## Entrypoints and Service Modules

Prefer a small `main() -> None` function for executable modules.

Keep startup code focused on:

1. Reading and validating configuration.
2. Constructing framework or service objects.
3. Registering routes, tools, handlers, or dependencies.
4. Starting the process.

Use the standard entrypoint guard:

```python
if __name__ == "__main__":
    main()
```

Avoid performing complex startup work merely by importing a module unless the framework or repository intentionally uses that pattern.

## Error Messages

Make errors actionable.

- State what failed.
- Include the relevant value when safe and useful.
- Name the expected options for invalid enumerated input.
- Preserve the original exception as the cause when translating errors.
- Never include secrets or credentials in messages.

## Tests

Follow the repository's existing test framework and layout.

- Test observable behavior, not implementation details.
- Give assertions useful failure messages when the framework does not already provide them.
- Keep fixtures and setup proportional to the behavior under test.
- Cover expected failures and boundary conditions when they are part of the contract.
- Prefer deterministic tests and explicit inputs.
- Do not add mocking when a simpler isolated test is sufficient.

## Dependencies and Tooling

Prefer the Python standard library when it cleanly solves the problem.

When a dependency is already present and is the repository's established abstraction, use it rather than introducing a competing implementation.

Respect the project's formatter, linter, type checker, dependency manager, and test runner. Do not silently replace project tooling.

## Makefiles

Read and apply the `makefiles` skill from the authoritative skill source when creating or modifying a Makefile. Reuse it if already loaded.

Include a root `Makefile` when creating a Python project. When changing a project, reuse its existing Makefile and align affected tasks with the `makefiles` skill. Expose applicable routine tasks such as `build`, `run`, `test`, `check`, and `format` using the repository's required tools. Include only tasks that apply to the project. Standalone snippets do not require a Makefile.

## Generic Examples

Read [references/code-examples.md](references/code-examples.md) when concrete examples would help with a new module, service entrypoint, async integration, parser, API route, or test.

The examples are patterns, not templates to copy mechanically. Adapt names, frameworks, error handling, and configuration to the repository.

## Final Check

Before finishing a Python change:

- Confirm touched code follows these preferences and explicit repository instructions and configuration.
- Remove unused imports and dead code introduced by the change.
- Confirm types are useful and accurate.
- Check comments and docstrings for signal rather than narration.
- Confirm required configuration fails clearly.
- Confirm errors do not expose sensitive data.
- Run the relevant formatter, linter, type checker, and tests when available.
- Avoid unrelated formatting or refactoring churn.
