---
name: domain-modeling
description: Build and sharpen the project's domain model. Use when discussing the project's terminology, writing or editing the glossary, or recording or editing a decision in the decisions doc.
disable-model-invocation: true
---

<!--
Adapted from mattpocock/skills, skills/engineering/domain-modeling/SKILL.md
(with ADR-FORMAT.md folded in) at commit
95249b0b49782349740fd9b8c6ce32b4e59e497a (MIT, see LICENSE in this folder).
Changes: one glossary, no multi-context map; decisions are numbered entries in
the project's decisions doc instead of ADRs in docs/adr/, with the same three
tests; the file paths come from docs/agents/docs.md; written on a branch (see
grill-with-docs).
Upgrades are deliberate: diff against upstream before changing the commit.
-->

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is the *active* discipline: challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise. (Merely *reading* the glossary for vocabulary is not this skill: that's a one-line habit any skill can do. This skill is for when you're changing the model, not just consuming it.)

## Files

The paths are in `docs/agents/docs.md`.

- the glossary: the project's words, in the format of [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).
- the decisions doc: the decisions, numbered, under "Decisions".

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in the glossary, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account': do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"

### Update the glossary inline

When a term is resolved, update the glossary right there. Don't batch these up: capture them as they happen. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

The glossary should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Record decisions sparingly

Only record a decision as an entry when all three are true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will look at the code and wonder "why did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it: you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing." What fails the tests but still shapes the work goes to the requirements or the architecture, or stays on the issue (see `grill-with-docs`).

What qualifies:

- **Architectural shape.** "Components run out of process."
- **Integration patterns between parts.** "Components reach each other only through a public API."
- **Technology choices that carry lock-in.** Not every library: just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.**
- **Rejected alternatives when the rejection is non-obvious**, so nobody suggests them again in six months.

### Decision entry format

Add the next number to the list under "Decisions" (or wherever `docs/agents/docs.md` says; it also gives the id prefix, if any):

```md
N. **{Short title}** ({id}, {date}). {What we decided and why, in a few sentences.}
   {Optional: the alternatives rejected and why, non-obvious consequences.}
   Discussion: issue #{issue}.
```

An entry can be a single paragraph. The value is in recording *that* a decision was made and *why*, not in filling out sections. A decision that changes an earlier one edits that entry and says what changed and when; it doesn't leave two entries that disagree.
