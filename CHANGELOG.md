# Changelog

## [0.1.6] - 2026-10-06
### Added
- Added `dockerfiles`, `docker-compose`, `vex`, and `troubleshooting-kubernetes` skills
- Added `python-django` and `go-bubbletea` skills
- Added the `github-actions` skill

### Updated
- Updated `python-django` with the Nostromo memory API example, adapting Django Ninja patterns from Kaiju and Squidfall with owner-scoped queries, constrained upserts, and readable source links
- Updated the publish workflow to install uv and validate skills before packaging and publishing
- Updated the Makefile to validate skills with `skills-ref` through uv before packaging
- Updated `skill-writing` with Agent Skills format, authoring, description evaluation, pop culture example naming, and readable source-link guidance that preserves attribution, and audited all skills to clarify discovery, shared guidance, and verification
- Updated the `go` and `makefiles` skills to prefer Go install builds and omit Go run targets by default, and the `python` and `makefiles` skills to prefer uv for Python workflows

## [0.1.5] - 2026-10-05
### Added
- Added examples to the `go` skill
- Added Go and multi-container project references to the `makefiles` skill
- Added the `changelog` skill and repository changelog maintenance instructions

### Updated
- Updated and applied the `writing-style` skill to all skills (no semi-colons, use `preferred` instead of `house`, etc.)
- Updated the `go`, `python`, and `makefiles` skills to apply preferences incrementally to touched code and directly related changes
- Updated the `makefiles` skill to invoke tools by their names and prefer Go install builds with explicit dependency updates
- Updated the `changelog` skill to use [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) as its primary format guidance and accumulate changes in the current planned release section

## [0.1.4] - 2026-10-04
### Added
- Added `makefiles` skill

## [0.1.3] - 2026-10-04
### Added
- Added `skill-writing` skill
- Added `writing-style` skill

### Changed
- Updated `go` skill to use `writing-style` skill
- Updated `python` skill use `writing-style` skill

## [0.1.2] - 2026-10-04
### Changed
- Renamed named used inside `write-go` skill file to `go`
- Renamed named used inside `write-python` skill file to `python`

## [0.1.1] - 2026-10-04
### Added
- Added `python` skill

### Changed
- Renamed `write-go` skill to `go`

## [0.1.0] - 2026-10-04
### Added
- Added `write-go` skill

[0.1.2]: https://github.com/cyberphor/agent-skills/releases/tag/0.1.2
[0.1.1]: https://github.com/cyberphor/agent-skills/releases/tag/0.1.1
[0.1.0]: https://github.com/cyberphor/agent-skills/releases/tag/0.1.0
