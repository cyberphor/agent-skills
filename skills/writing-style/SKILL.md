---
name: writing-style
description: Draft or revise explanatory prose, documentation, READMEs, how-to guides, and skill instructions in the user's plain, practical voice. Use for writing style and explanation choices, not code architecture.
---

# Writing Style

Write explanations that help the reader understand a concept and use it. Keep the language direct and give enough detail to explain what an action does and why it matters. Preserve the requested audience, format, and scope.

## Voice

**Direct.** Use matter-of-fact sentences and concrete verbs. Say what something is or what the reader should do. Remove promotional language, personal storytelling, and introductions that delay the explanation.

**Practical.** Connect an instruction to its useful result. Prefer “Save the settings. The application uses them the next time it starts.” over vague claims about improving the experience. Keep sentences short enough to follow, without removing necessary reasoning.

**Approachable.** Use “you” and “your” when addressing the reader. Give instructions with verbs such as Create, Activate, Install, or Check. Explain unfamiliar concepts without assuming expertise or talking down to the reader.

## Explanations

**Definition.** Start a concept guide with a short definition and its purpose: “A retry repeats a failed operation. This helps recover from a temporary connection failure.”

**How It Works.** Describe the relevant behavior or relationship next. Use concrete examples when an abstract definition leaves the reader unsure how to apply it. Keep each explanation focused on one idea.

**Purpose.** Connect the behavior to its consequence: “The process requires a saved configuration. This allows you to reuse the same settings.” Explain the reason when it helps the reader choose or act.

**Terms.** Prefer spelled-out words. Introduce a necessary acronym with its full term on first use. Preserve exact command names, identifiers, and technical syntax. Simplify the explanation without changing the meaning.

## Structure

Use H1 for the title and H2 for sections. Use bold labels for deeper subdivisions instead of H3 or smaller headings. Choose sections that fit the subject; do not impose the same layout on every document.

Group conceptual explanations under short bold labels. Use parallel bullets for related properties, questions, or choices. Organize troubleshooting by the task or symptom the reader recognizes. Put inline names and language-tagged code blocks next to the explanation they support.

## Procedures

Use numbered bold step labels when order matters. Start each step with an action and place its command or example directly after it. Number steps sequentially within each procedure.

**Step 1.** Create a directory for the output.

```sh
mkdir output
```

Explain flags briefly when their effect helps the reader. Keep descriptive material in prose rather than forcing it into steps. Avoid repeating the same procedure as a checklist.

## Revision

Check that each section answers a useful reader question. Replace vague wording with specific actions, explain necessary terms, and keep the reason or consequence where it matters. Verify technical accuracy and remove placeholders or source mistakes. Preserve the requested scope and avoid adding detail solely to make the document longer.
