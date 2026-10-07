---
name: skill-writing
description: Create, revise, or audit reusable agent skills and SKILL.md instructions. Use when packaging a workflow as an agent skill, improving skill discovery or execution, or diagnosing failures tied to a skill's instructions.
---

# Skill Writing

A skill gives an agent reusable instructions for a defined task.

## Guidance

Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) when drafting or revising prose. Reuse it if already loaded.

**Content.** Ground instructions in user preferences, real task traces, project artifacts, or verified domain sources. Extract reusable decisions and procedures instead of a single task's answer. Keep conversation history and temporary evidence in external task notes. Examples clarify rules without introducing unstated requirements.

**Example names.** Do not name authored examples after the projects or repositories that inspired them. For example titles, filenames, fictional projects, domains, and identifiers, use character, creature, place, or object names from Alien, Predator, Godzilla, Toy Story, Metal Gear Solid, Transformers, Ninja Turtles, or X-Files. Examples include Nostromo, Yautja, Mothra, Buzz, Snake, Cybertron, Shredder, and Mulder. Adapt spelling and casing to the required syntax. Preserve accurate source URLs, attribution, and literal technical identifiers when discussing actual source code. Fictional example names must not imply that adapted code exists in the source project.

**Source links.** Prefer readable GitHub file URLs in the form `/blob/<verified-branch>/<path>`, or the repository landing page when it provides enough context. Use descriptive link labels. Verify the branch and target before linking, and use `main` only when it is the actual branch. Avoid `/blob/<40-character-commit-SHA>/...` URLs in authored skill prose by default. Keep exact revision metadata separately when reproducibility needs it or the user explicitly requires it. Branch links can change, so preserve truthful attribution and distinguish a linked branch from the revision actually inspected.

## Format and Scope

Use the [Agent Skills specification](https://agentskills.io/specification) for format requirements. Each directory must contain `SKILL.md` with YAML frontmatter and a Markdown body. `name` and `description` must be strings. The name must match its directory, contain 1-64 lowercase alphanumeric characters or hyphens, and have no leading, trailing, or consecutive hyphens. The description must contain 1-1024 characters.

Add optional fields only when needed. `compatibility`, if present, is a 1-500 character string. `metadata` maps string keys to string values. `license` and experimental `allowed-tools` are strings. Tool metadata does not grant execution permission beyond the active environment's authorization.

Use the [best-practices guide](https://agentskills.io/skill-creation/best-practices) for recommended patterns. Keep coherent scope and moderate detail, preserving explicit user conventions. Prefer useful defaults and procedures. Calibrate fixed steps to fragile operations. Keep essential constraints in the entrypoint and conditional detail in focused resources, linked with relative paths and explicit load triggers. Staying below 500 lines and roughly 5,000 tokens is recommended, not a format requirement. Do not add scripts, examples, checklists, or metadata without a concrete purpose.

## Descriptions and Evaluation

Follow [description optimization guidance](https://agentskills.io/skill-creation/optimizing-descriptions) when discovery is uncertain or observed routing fails. Write concise imperative descriptions around user intent, including implicit requests that need the skill. Clarify adjacent near-miss tasks when confusion is likely. Avoid keyword lists that expand unrelated scope.

For runtime evaluation, use realistic positive and near-miss negative prompts, varying phrasing, detail, and complexity. Verify registration first and observe whether the agent actually loads `SKILL.md`. Repeat prompts enough to measure inconsistent activation within the task's budget. Fixed query counts, repetition counts, and thresholds are starting points, not mandatory workloads.

Keep training and held-out sets fixed, with positives and negatives in both. Revise from training failures, reserve held-out results for comparison, and avoid copying failed prompt keywords into descriptions. Check the selected revision with fresh prompts when warranted. Inspect execution traces and results to distinguish discovery from output-quality failures. Report static review separately from runtime trigger evidence.

## Problem Types

**Missing Guidance.** The desired behavior is absent. Add a scoped instruction where that behavior belongs.

**Ambiguity or Conflict.** Instructions allow competing interpretations. Clarify applicability, precedence, and the expected result.

**Noncompliance.** An applicable instruction already requires the desired behavior. Identify the execution or verification failure instead of repeating the rule.

**Uncertain.** Evidence does not establish the cause. State what is known and what would resolve the uncertainty.

## Process

**Step 1.** Establish the desired outcome and authorized scope. Resolve relevant skills through the active catalog or provider, using sibling files when working from this repository. Read linked guidance when its load condition applies and reuse instructions already loaded. Report unavailable required guidance before dependent changes. A new skill can start from a clear use case without a failed artifact.

**Step 2.** When reviewing feedback, compare the user's expectation, the artifact, and the applicable wording. Record locations or short excerpts in task notes and classify each issue using the problem types above. Separate explicit preferences from interpretations. Ask only when a missing distinction changes the guidance. Current wording does not prove what an earlier agent loaded.

**Step 3.** Choose a focused edit when an existing skill owns the behavior. Create a new skill for a distinct reusable workflow with a clear trigger. Keep personal or project conventions in appropriately scoped guidance rather than making them universal defaults. Skill work does not authorize changes to example artifacts or other skills.

**Step 4.** Write concise front-matter describing the capability and its trigger. Include necessary decisions, observable outcomes, and boundaries. Preserve unrelated rules and resources. Resolve contradictions explicitly. Add supporting resources only when they serve the reusable workflow. Link them where they become relevant.

**Step 5.** Run `skills-ref validate <skill-directory>` when available and check directory names, resource links, and unfinished scaffolding. Fix validation failures and rerun affected checks. Review realistic requests against the guidance, preserving unrelated requirements and scope. Use independent evaluation when complexity warrants it and delegation is authorized. Give the evaluator the request and raw evidence without the intended diagnosis. Format validation alone does not establish behavioral quality.

**Step 6.** Report the changes, evidence, checks actually run, and remaining uncertainty. For a handoff, include the proposed scope and acceptance criteria. Distinguish proposed checks from completed checks. Revised guidance does not prove future compliance.
