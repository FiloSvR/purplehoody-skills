---
name: requirement
description: Write one requirement document, problem to acceptance criteria, by interviewing the owner. Use when a feature or behaviour needs to be pinned down before it is planned, when the owner wants to write or change a requirement, or when plan finds work that no requirement covers.
disable-model-invocation: true
---

# Requirement

A requirement is one file: what the product must do, why, and the acceptance
criteria that prove it does. It is written with the owner in an interview, the
`grill-with-docs` skill, aimed at behaviour rather than design. It is the input
of the `plan` skill, which cuts it into tasks. With a tracker, it is also the
epic, and its tasks are the epic's sub-issues.

A requirement is **done** when every acceptance criterion is proved, by an
end-to-end test or by documentation; its Proof table records which (see
`plan`, Closing).

A requirement says nothing about how it is built: no modules, no schemas, no
file paths. Those belong to `plan`, `architect` and the decision entries.

## Where it lives

`docs/agents/docs.md` names the requirements folder and the id prefix. Unless
it says otherwise:

- one file per requirement: `docs/requirement/NNN-short-title.md`, with
  `NNN` zero-padded (`012`) and the title in lowercase kebab case;
- its id is the prefix and the number: `R-012`. The file number *is* the id,
  so an issue's `R-012` leads straight to the file;
- a new requirement takes the highest existing number in the folder, plus one:
  list the folder on an up-to-date `main`, don't trust memory. A withdrawn or
  superseded requirement keeps its number; numbers are never reused;
- two interviews can take the same number at once, and git won't notice, since
  the titles differ. So before the pull request is merged, its number is
  checked again against `main`, and renumbered if taken (file, heading, epic
  title).

## Process

### 1. Read

- `docs/agents/docs.md`, the glossary and the decisions doc.
- the existing requirements: their titles, then the full text of any that
  touch the same behaviour. If one already covers it, propose amending that
  requirement instead of writing a second (see Changing a requirement).
- the code the behaviour touches, enough to know what exists today, so the
  questions are about what changes.

### 2. Interview

Run `grill-with-docs`. Its rounds, frontier and recommended answers apply as
they are; this skill seeds the design tree with these branches, roughly in
this order, since each depends on the ones before:

1. **Problem**: who has it, what they do today, what goes wrong. In the
   owner's words, from the user's side.
2. **Actors**: who acts and who is affected, in the glossary's words. A new
   word is settled in the glossary (`domain-modeling`) before it is used.
3. **Solution**: what the product does about it, from the user's side.
4. **Behaviour**: the main path, step by step, then each variation: the
   edge cases, the empty and the limit cases, the failures (denied, missing,
   duplicate, concurrent, too late), and what the user sees in each.
5. **Constraints**: the qualities it must keep: speed, limits, security,
   privacy, accessibility, compatibility. Only those that are real, each with
   a number or a check, never "fast" or "secure".
6. **Acceptance criteria**: drafted by you from the settled behaviour, put to
   the owner one round at a time, never invented after the interview.
7. **Out of scope**: what it deliberately does not do. Ask for these: the
   owner's "no" draws the edge as much as the "yes".

Keep the interview on behaviour. When a question about *how* comes up, it is
not this skill's: note it under Notes for `plan` or `architect`, unless it is a
decision that passes the three tests in `domain-modeling`, which records it
now. When the owner states how something works today, check the code (as in
`domain-modeling`), and surface a contradiction.

### 3. Write as it settles

Branch from an up-to-date `main` and create the file once the title and the
problem have settled, from the template below, with `Status: draft` and a
`<!-- pending -->` line in each section still open. Then fill each section the round it settles, as
`grill-with-docs` records, not in a batch at the end.

### 4. Check before it is done

The interview is done when the `grill-with-docs` frontier is empty and the
owner confirms the shared understanding. Before asking for that, check:

- every acceptance criterion is **observable** (something a user or a caller
  can see, not an internal state), **one behaviour**, **free of design** (no
  modules, tables or endpoints unless the endpoint is the product),
  **decidable** (pass or fail, no "should be quick"), and **provable** by an
  end-to-end test or by documentation: one that neither could show is
  reworded until one can;
- every user story is proved by at least one criterion, and every behaviour
  and failure settled in the interview has one;
- every constraint has its number or check, and a criterion where it can be
  tested;
- no section is left `pending`, and the words match the glossary.

Fix what fails with the owner, then set the status to `ready`: it can now be
planned. A `draft` requirement is never planned.

### 5. Hand off

Open a pull request with the requirement (and any glossary or decision entries
it settled); it is the gate to `main`. With a tracker, create the epic now
(see On the tracker). When the session comes from an issue, that issue becomes
the epic instead of a new one. If the owner rejects the pull request, close
the epic with a comment saying why (or, if it came from an issue, comment
there and leave it open). Once it merges, say that `plan R-NNN` cuts it into
tasks: only a requirement `ready` on `main` is planned. Do not create tasks
from here.

## On the tracker

With a tracker (`docs/agents/tracker.md`), the requirement is mirrored as one
issue, the epic:

- title `R-NNN <Title>`, label `requirement`, body the file's content plus a
  link to the file;
- its number goes into the file's `Tracker` line;
- the file wins: whenever the file changes (this skill, `plan`'s Proof table,
  the plan, the close), the epic's body is re-synced from it. A change
  someone made on the tracker is copied into the file first;
- the epic has no pull request of its own; it closes when the requirement is
  done (`plan`, Closing).

## Template

```md
# R-NNN <Title>

- **Status**: draft | ready | ongoing | done | superseded by R-… | withdrawn
- **Date**: <YYYY-MM-DD>
- **Decisions**: <D…, the decision entries it depends on, or "none">
- **Tracker**: <#N, the epic, or "none">

The tasks that build it are `docs/plans/R-NNN-*.md`.

## Problem

<Who has the problem, what they do today and what goes wrong. The owner's
words, from the user's side.>

## Solution

<What the product does about it, from the user's side. A few sentences.>

## User stories

1. As a <actor>, I want <a feature>, so that <benefit>.
2. …

## Acceptance criteria

- **AC1 <short name>**: Given <state>, when <act>, then <observable result>.
- **AC2 <short name>**: Given …, when …, then ….

## Constraints

- <a quality it must keep, with its number or check> (AC…)

## Out of scope

- <what it deliberately does not do>

## Notes

<Questions of design raised in the interview, for plan and architect.
Optional.>

## Proof

| Criterion | Task | Kind | Proof |
|---|---|---|---|
| AC1 | <T…, filled by plan> | <e2e or doc> | <the test's name, or the doc section's link; filled at the close> |
```

The user stories are numbered and long: one per behaviour and actor, as many
as the feature has. An acceptance criterion is cited from outside as
`R-NNN AC3`; criteria keep their numbers once the requirement is merged, and a
removed one is struck through, not renumbered. "Constraints" and "Notes" are
dropped when empty.

This skill writes the Proof table with one row per criterion and the other
columns empty; `plan` fills Task and Kind. Each task records its proof in its
own file, so tasks running at once never edit this one; the Proof column is
copied from them at the close, when the status becomes `done`.

The status follows the work (see `plan`, Status and working concurrently):
`draft` while this skill writes it, `ready` once the owner accepts it,
`ongoing` once its plan is merged, `done` once every criterion is proved.
Every change of status is in a pull request, reviewed with the change.

## Changing a requirement

A `ready`, `ongoing` or `done` requirement is edited in place, on a branch,
through the same interview for the part that changes. Add a line under the
header: `- **Changed**: <date>: <what changed and why>`. A criterion that
changes keeps its number; a new one takes the next. A changed or new
criterion's Proof row is emptied, and a `done` requirement goes back to
`ongoing`. If the change undoes behaviour that is already built, say so in the
pull request: `plan` adds the tasks that bring the code in line. With a
tracker, re-sync the epic.

A requirement that is replaced gets `Status: superseded by R-…`; one that is
dropped gets `Status: withdrawn`, with a line saying why. Neither is deleted.
