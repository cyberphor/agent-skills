---
name: changelog
description: Create or maintain repository CHANGELOG.md files in the preferred style. Use when asked to edit a changelog or when making repository changes that require a changelog entry.
---

# Changelog

Read the existing changelog, relevant changes, and repository instructions before editing. Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) for entry wording, rather than changelog structure. Reuse it if already loaded.

## Format

Read [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) and use it as the primary guide for format and change categories. Explicit user and repository instructions take precedence.

Accumulate changes directly in the user's current planned release or tag section instead of using an `Unreleased` section. This planned-version workflow is the preferred exception to Keep a Changelog. If the planned version is unknown, ask the user rather than choosing a version or assuming the latest published release is the target. Use supplied or verified dates and links. Do not invent the next version, release dates, or comparison links. Preserve historical facts and known release references.

## Entries

Record actual changes to the repository in the current working section. Describe the resulting capability, behavior, or guidance. Keep entries useful to readers rather than recording commands, conversations, or every edit.

Update an existing bullet when the same change is already recorded. Combine closely related changes and avoid duplicates. Do not add entries for read-only work or changes made only in another repository.

Before finishing, compare entries with the changes made. Check the section, category, dates, known links, and preserved history.
