---
name: skill-writing
description: Create, revise, or review agent skills. Use when defining a reusable workflow, improving skill guidance, or diagnosing how instructions relate to output problems.
---

# Skill Writing

A skill gives an agent reusable instructions for a defined task.

## Guidance

Read and apply the `writing-style` skill from the authoritative skill source when drafting or revising prose. Reuse it if already loaded.

**Content.** Include guidance that changes decisions or behavior. Keep conversation history and project-specific evidence in external task notes, outside reusable instructions. Examples clarify rules; they do not introduce unstated requirements.

## Problem Types

**Missing Guidance.** The desired behavior is absent. Add a scoped instruction where that behavior belongs.

**Ambiguity or Conflict.** Instructions allow competing interpretations. Clarify applicability, precedence, and the expected result.

**Noncompliance.** An applicable instruction already requires the desired behavior. Identify the execution or verification failure instead of repeating the rule.

**Uncertain.** Evidence does not establish the cause. State what is known and what would resolve the uncertainty.

## Process

**Step 1.** Establish the desired outcome and authorized scope. Read relevant existing skills from the authoritative source, including linked guidance when needed. Reuse instructions already loaded. Report unavailable required guidance before dependent changes. A new skill can start from a clear use case without a failed artifact.

**Step 2.** When reviewing feedback, compare the user's expectation, the artifact, and the applicable wording. Record locations or short excerpts in task notes and classify each issue using the problem types above. Separate explicit preferences from interpretations; ask only when a missing distinction changes the guidance. Current wording does not prove what an earlier agent loaded.

**Step 3.** Choose a focused edit when an existing skill owns the behavior. Create a new skill for a distinct reusable workflow with a clear trigger. Keep personal or project conventions in appropriately scoped guidance rather than making them universal defaults. Skill work does not authorize changes to example artifacts or other skills.

**Step 4.** Write concise frontmatter describing the capability and its trigger. Include necessary decisions, observable outcomes, and boundaries. Preserve unrelated rules and resources. Resolve contradictions explicitly. Add supporting resources only when they serve the reusable workflow; link them where they become relevant.

**Step 5.** Run an available skill validator and inspect references and unfinished scaffolding. Check whether a realistic request would produce the desired behavior while preserving unrelated requirements and scope. Use independent evaluation when complexity warrants it and delegation is authorized. Give the evaluator the request and raw evidence without the intended diagnosis. Format validation alone does not establish behavioral quality.

**Step 6.** Report the changes, evidence, checks actually run, and remaining uncertainty. For a handoff, include the proposed scope and acceptance criteria. Distinguish proposed checks from completed checks; revised guidance does not prove future compliance.
