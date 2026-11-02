---
name: plan
description: Plan work as a spec, its cuts, issues, a board and pull requests. Use when a feature needs a spec and a cut, when a task is created, starts, moves or closes, when a decision settles, or when choosing what to work on next.
disable-model-invocation: true
---

# Plan

Every piece of work is an issue on the project's tracker, every change reaches
`main` through a pull request that closes its issue, and the board shows where
each issue stands. Where the tracker is, the accounts and the tools that drive
it are instance details: they live in local notes, never in the repo.

## Tasks

- One issue per task, one pull request per issue.
- Title: `<id> <short title>`; the project's id scheme is in
  `docs/agents/tracker.md`.
- A new issue's id is the highest existing id of its kind, plus one: check the
  tracker, not memory. A new issue lands in Backlog.
- Body:
  - **Goal**: what it achieves and why, from the user's side.
  - **Scope**: where it goes, what it includes and leaves out.
  - **Requirements**: the IDs it serves (R-…, UC-…, D…).
  - **Depends on**: the issues that must be done first, also set as tracker
    dependencies so they block it.
  - **Done when**: a checklist the review checks the pull request against.
  - the spec (below), when the task is bigger than a contained change.
- No file paths and no code snippets in the body: they go stale and the code
  moves out from under them. A decision that needs a shape (a schema, a type, a
  state machine) gets its decision entry (`domain-modeling`), and the issue cites it.
- Every issue carries its seam from the moment it is cut, not only a bigger
  task: a `Seam:` line, or the spec's Testing decisions (below). The batch
  proposal shows it (see What's next).
- Labels. These are the shared ones, defined here and nowhere else; a project's
  extra labels are in `docs/agents/tracker.md`:

  | Label | On | Means |
  |---|---|---|
  | `who/agent` | issue | an agent can do it |
  | `who/user` | issue | the owner must: sudo, a browser, a secret |
  | `needs/architect` | issue | the design note (`architect`) is required before `change`: the coordinator adds it when planning the cut, and whoever runs `architect` removes it once the note is on the issue or its pull request. The note is the evidence — no second "architect: yes" line in the body — and a review that finds the label gone without one is a finding |
  | `needs/review` | pull request | a review is owed before merge; how it is added, removed and re-added is under Pull requests |
  | `decision` | issue | stop and ask the owner (`grill-with-docs`) |
  | `blocked` | issue | waiting on something outside the plan |

### The spec of a bigger task

A task bigger than a contained change carries, after Scope:

- **Problem**: the problem, from the user's side, in their words.
- **Solution**: what the feature does about it, from the user's side.
- **User stories**: numbered and long, `As a <actor>, I want <a feature>, so
  that <benefit>`, one per behaviour and actor the feature has. Only where
  they add an act or an actor beyond the use cases in
  the project's requirements doc, which are already the product's story.
- **Testing decisions**: the seam (above) and its layer (from
  `docs/agents/testing.md`), what a good test here is, and the prior art.
- **Out of scope**: what the feature does not do, so the edge is as visible
  as the scope.

The implementation decisions are not a section of it: a decision lives where
its own skill puts it — a decision entry, a requirement, the architecture, or the
design note (`architect`, `domain-modeling`) — and the issue cites it.

**Choose the seam before the code**, and confirm it with the owner when the
spec is published: the highest point that proves the behaviour, and as few
seams as possible — ideally one. `change` starts from the seam the issue
records, and the review checks the tests against it.

### One cut, not one layer

An issue is one **vertical cut**: narrow, but through every layer it needs
(store, service, API, interface, tests), never a horizontal slice of one layer. It
is verifiable on its own when done, and fits the budget `change` sets. The
project's own hints for where to cut are in `docs/agents/tracker.md`.

- Larger than that: split it into cuts, each with its own **Done when**, and
  set the edges as `Depends on` plus tracker dependencies. Split when the
  Scope crosses more than one package family or layer, or a contract and its
  docs.
- Parity work (a fake or a second implementation kept in step with the real
  one) is its own cut when it would double the diff.
- Make the change easy first: groundwork that makes the rest small — a small
  prefactoring that makes the real change simple — is its own cut, and the
  rest depend on it.
- A cut whose brief cannot be finished inside the budget is the wrong cut,
  not a long agent run.
- A **wide refactor** is the exception: one mechanical change (a rename, a
  retyped shared symbol, a public contract change) whose blast radius fans
  across the codebase, so that no single cut lands green. Sequence it
  expand–contract:
  1. **expand**: the new form beside the old; nothing breaks;
  2. **migrate**: the callers move over in batches sized by blast radius (a
     package, a directory), each batch its own issue depending on the expand;
     the old form stays, so each batch lands green;
  3. **contract**: the old form goes, once no caller remains, in an issue
     depending on every batch.

  When a batch cannot stay green alone, the cut is wrong, not the plan: expand
  further (a shim, a re-export, an adapter) until each batch lands green on
  `main` by itself. There is no shared integration branch: every change
  reaches `main` through a pull request that is green there.

### The delegation pattern

A cut is usually one implementer. When a second model is available and the
seam is clear, split it: the spec writer writes the failing tests and a short
plan; the implementer writes only the code, against tests it may not edit; the
coordinator runs the gate and the review. Resume those sessions instead of
starting new ones — the saved context is the cost saving. The split is a
choice, not a default: the brief names it, and if it does not, ask the owner.
Never use it while the second model is unavailable, and the coordinator, not
the implementer, adjudicates the red-first gate.

### A feature spanning several issues has a parent

The parent is an issue too, the spec without the code and without a pull
request of its own; its children are the cuts, and each one names it. A child's
pull request closes the child, never the parent; the parent closes when the
last child does.

## Output and handoff

The output of planning is the issue set — the parent and its cuts — with the
dependency edges, the labels and the cards, and nothing else: no document.
The issue body is what `architect` and `change` read; the design note returns
to the same issue or its pull request; a decision goes to its decision entry, not to
the plan.

## Board

| Column | Holds | Moved there |
|---|---|---|
| Backlog | not ready: blocked, or waiting on a decision | when created; when an abandoned or superseded pull request sends its issue back (see Closing) |
| To Do | ready to start | when its dependencies and decisions are done (see What's next) |
| In Progress | being worked on | when work starts; from In Review or Approved when a finding needs behaviour work |
| PR open | pull request with green CI, waiting for the owner's go to review (a first review, or a re-review after fixes) | when the pull request opens with green CI; from In Progress, In Review or Approved when fixes are pushed with green CI and a re-review is owed (`needs/review` is on) |
| In Review | under review, or with fixes in progress | when the owner says to review (see `review`) |
| Approved | the last required review approved and the low fixes it leaves are confirmed or re-reviewed, waiting for the owner's merge | when that condition holds (see Pull requests) |
| Done | closed | after the merge |

The agent coordinating the work moves every card; the owner doesn't have to.
A review that approves with low findings keeps the card In Review until the
implementer confirms the fixes, or a re-review passes them, and only then does
it move to Approved. A parent issue's card follows its children: In Progress
while any child is In Progress, PR open, In Review or Approved, Done when the
last one closes it.

## Pull requests

- The body says `Closes #N` for the issue it completes, so the merge closes
  it; `Refs #N` when it only touches one. Never the parent of a feature: a
  child closes its own issue and leaves the parent open. Fixes from the review
  go on the same pull request, without a new issue.
- The body holds the design note (see the `architect` skill), how it was
  tested (the tests that failed first), and **Open points**.
- Every review is a comment on the pull request (see the `review` skill). The
  label is the machine-readable state, and it follows the review. If the
  project guards merges on it (`docs/agents/tracker.md` names the guard), the
  guard fails while the label is on and passes again once it comes off, with no
  new push. While the label is on, "green CI" means the test check: the guard is
  red by design until the label goes, and every context is green only once it
  has.
  - the implementer adds `needs/review` when it opens the pull request;
  - the review that completes the round removes it. For a high-risk change
    that is the second, independent review: a first approval leaves the label
    in place and says why;
  - a review with findings leaves the label in place;
  - a fix push that changes code after an approval adds the label back, unless
    the fixes are low-only and change no behaviour, which a re-review may allow
    without another round (see the `review` skill);
  - a merge with the label present is a mistake: before merging, the
    coordinator checks that it is gone, that the last review approved, and
    that its low fixes are confirmed or re-reviewed, so no merge lands with an
    open finding.
- Merge authority is the project's. Unless it says otherwise, only the owner
  merges; agents never do.

## Closing

- An issue with a pull request is closed by its merge.
- An issue without one (a `who/user` task, something verified outside the
  repo) is closed by the agent after checking the result itself, with a
  comment that gives the evidence.
- A parent closes when its last child does, naming the children.
- Never close on a check that failed or wasn't run: comment, and leave it
  open or label it `blocked`.
- An abandoned or superseded pull request gets a comment saying why. Its issue
  goes back to Backlog, or is closed with a link to the replacement. `blocked`
  is only for a blocker outside the plan.

## What's next

The coordinating agent reads the board at the start of a session and after
each merge, and proposes the next batch (see the project's workflow).
After each merge it also re-reads the Backlog, moves every issue whose
`Depends on` is now done to To Do, and proposes it. For a `who/user` task, it
posts the exact commands as a comment.

The proposal is the breakdown, not only the list: for each issue, its title,
the issues that block it, its seam and the behaviour it delivers when done.
Then it asks the owner, and iterates until they agree:

- is the granularity right, too coarse or too fine?
- does each issue depend only on what genuinely gates it?
- should any be merged, or split further?

Work that arrives as a feature is cut before it reaches the board.

## Decisions

A `decision` issue blocks the tasks that depend on it. It is settled with the
owner in a conversation (the `grill-with-docs` skill): the docs are written on
a branch as the answers settle, the outcome goes on the issue as a comment,
and that docs pull request closes the issue.

## Open points

An open point a review leaves behind never lives only in a pull request:

- deferred: a new Backlog issue, so it is not lost. The coordinator files it
  without asking: filing is planning, not recording a decision. Only a decision
  (a decision entry, a glossary term, a doc sentence) needs the owner's agreement
  first;
- part of another open issue: a comment on that issue;
- accepted as built: recorded in the next decisions pull request.
