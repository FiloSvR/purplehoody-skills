---
name: architect
description: Design a change before coding it. Use when a change adds, moves or removes a component, package, API resource, store, dependency or process, or changes how parts connect; also when unsure where code belongs.
disable-model-invocation: true
---

# Architect

Decide where a change goes and how it fits before anyone writes code. The
facts live in the project's docs; this skill is the procedure.

## Read first

The docs named in `docs/agents/docs.md`: requirements, architecture,
decisions and glossary.
Read the sections the change touches, not the whole set. Name new things with
the glossary's words.

## Steps

1. **Name what it serves.** List the use-case and requirement IDs. If none
   fits, the change may be out of scope: say so and ask.
2. **Place it.** Which component, package or layer owns it? Which dependency
   edges does it add, and does the architecture doc allow each one? Apply the
   project's placement rules if `docs/agents/docs.md` has them. A wide
   refactor has no single design: it goes expand–contract, and each cut is
   designed on its own (`plan` cuts it).
3. **Check it against the decisions.** Read every decision the change touches
   and the invariants in the architecture doc. A change that contradicts one is
   not a design problem: it is step 4.
4. **Stop if it needs a decision.** A new dependency, a new kind of component,
   a change to a decision, or a trade-off the docs don't settle is discussed
   with the owner first, using the `grill-with-docs` skill; the owner's
   answers are what it records.
5. **Write a short design note** in the issue or pull request:
   - the requirement IDs;
   - where it goes and the interfaces it adds or changes;
   - what happens on failure (crash, restart, timeout, denied access);
   - the tests that will prove it, with their layers (`docs/agents/testing.md`),
     written first for the contracts other code depends on.
6. **Update the architecture doc** in the same pull request: tables, status
   (planned → built) and invariants with the test that checks each. If a rule
   can be checked by a tool (a dependency check, CI), extend the tool rather
   than only writing the rule down.
7. **Clear the label.** With the note on the issue or pull request, remove its
   `needs/architect` label; the rule is the `plan` skill's.

Then implement with the `implementer` skill.
