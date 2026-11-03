---
name: plan
description: Turn a requirement into its tasks, saved as plan files in the repo and mirrored to the tracker as sub-issues of the requirement, and run the board and pull requests. Use when a requirement (R-…) is ready to be planned, when a task is created, starts, moves or closes, when a decision settles, or when choosing what to work on next.
disable-model-invocation: true
---

# Plan

A requirement (the `requirement` skill) says what the product must do and how
to tell it does. Planning turns it into **tasks**: one file each in the repo,
one pull request each to `main`. The files are the source of truth. When the
project has a tracker, it mirrors them: the requirement is the epic, its tasks
are its sub-issues, and the board shows where each one stands. Where the
tracker is, the accounts and the tools that drive it are instance details:
they live in local notes, never in the repo.

## Where the plan lives

`docs/agents/docs.md` names the plans folder; unless it says otherwise:

- one file per task: `docs/plans/R-012-T01-short-title.md`, the requirement
  id, the task id and the title in lowercase kebab case;
- task ids count from `T01` within their requirement, in dependency order
  (blockers first). A task added later takes the highest `T` of that
  requirement, plus one: list the folder on an up-to-date `main`, don't trust
  memory. Numbers are never reused;
- two sessions can take the same number at once, and git won't notice, since
  the titles differ. So before a pull request that adds a task file is merged,
  its number is checked again against `main`, and renumbered if taken (file,
  title, every **Blocked by** that links it, the tracker issue);
- work that serves no requirement (a chore, a dependency bump) uses `chore`
  as its requirement id, numbered across all chores: `chore-T07-bump-node.md`,
  with `Requirement: none (chore)`. A bug against a criterion is a task of
  that criterion's requirement.

With a tracker (`docs/agents/tracker.md`), each task file is also an issue:

- title `R-012-T01 <Title>`, body the file's content plus a link to the file;
- a sub-issue of the requirement's epic (`requirement` creates it), with its
  **Blocked by** set as native tracker dependencies;
- the issue number goes back into the file's `Tracker` line, so either one
  leads to the other;
- the file wins: change the file and re-sync the issue, never the other way.
  A change someone made on the tracker is copied into the file first. The
  board follows the file's status (see Board).

## Status and working concurrently

Every requirement and every task carries a `Status` line, so several agents
(or people) can work at once without picking the same thing.

A status changes only in a pull request, together with the change it
describes, so it is reviewed with it; nothing is pushed to `main` directly.
`main` therefore shows what is merged: `ready` until the work lands, then
`done`. Work in between shows as its branch and its open pull request, where
the file already says `ongoing`.

| Status | Requirement | Task |
|---|---|---|
| `draft` | being written, on the `requirement` branch; never planned | — (a task not yet on `main` is not pickable anyway) |
| `ready` | accepted and merged; can be planned | merged with its plan; can be picked once every task in its **Blocked by** is `done` |
| `ongoing` | planned: set by the plan pull request, while its tasks are built | claimed: set by the first commit of its own branch (see Claiming a task) |
| `done` | every criterion proved, set by the close pull request (see Closing) | set by its own pull request, true once that merges |
| `dropped` | (`superseded by R-…` or `withdrawn`, see `requirement`) | abandoned or replaced, set in the pull request that replaces or drops it; a line says why |

**Blocked** is not a status: a `ready` task is blocked while any task in its
**Blocked by** is not `done` on `main`, or while it carries `decision` or
`blocked`. It is picked only once none of that holds.

**Claimed** is read from the branches: a task that is `ready` on `main` but
has an open pull request or a remote branch of its name is `ongoing`. Whoever
reads statuses (to propose work, to move cards, to pick a task) checks both,
`main` and the open branches; `main` alone misses the work in flight.

### Claiming a task

The claim is the task's branch, named after its file without `.md`
(`R-012-T01-add-attempt-counter`), and the draft pull request opened from it.

1. Pull `main`. Pick a task that is `ready` and not blocked, and has no open
   pull request and no remote branch of that name.
2. Create the branch from `main`. Its first commit sets the task `ongoing`
   and fills `Claimed by` (who, and the branch).
3. Push it and open a **draft** pull request at once. A rejected push means
   the branch already exists: someone else has the task; pick another. The
   push is the lock, and the draft pull request is the claim everyone sees.
4. With a tracker, move its card to In Progress.

The work then continues on that branch, and the pull request leaves draft
when it is ready for review (`implementer`). Its last change sets the task
`done` and clears `Claimed by`, so the merge makes both true together.

Two tasks are safe to work concurrently when neither is in the other's
**Blocked by**, directly or through others. The planner keeps edges only where
one task truly needs the other's code, so that as many tasks as possible are
free at once.

A claim given up (the work stops, the session ends unfinished) is released by
closing the draft pull request with a comment saying where the work stopped,
and renaming its branch `abandoned/<name>` so the name is free again. `main`
never changed, so the task is still `ready`.

## From a requirement to tasks

The argument names the requirement: an id (`R-012`) or a path. Without one,
ask which. A feature or a change of behaviour with no requirement goes to
`requirement` first; planning does not interview the owner about behaviour.

### 1. Read

- the requirement, all of it, and every decision entry it names;
- the glossary, the decisions and the architecture sections it touches
  (`docs/agents/docs.md`), and `docs/agents/testing.md`;
- the plan files that already exist for it, if it was planned before;
- the code the behaviour touches: what exists, what can be reused, and the
  prefactoring that would make the change small ("make the change easy, then
  make the easy change").

### 2. Choose how each criterion is proved

A requirement is done when every acceptance criterion is proved, by an
**end-to-end test** or by **documentation**:

- an end-to-end test, in the project's e2e layer (`docs/agents/testing.md`),
  for any behaviour a user or a caller can exercise. This is the default;
- documentation, a named section of a doc in the repo, only for a criterion
  about what someone can learn or do by hand (an operator procedure, a
  documented limit), where a test would prove nothing a reader could not.

Pick one for each criterion, with the test or doc it will be. Then the seams
of the tasks: the highest point that proves their behaviour, existing seams
before new ones, as few as possible. The proof of a criterion is always e2e
or a doc; a groundwork task may prove itself lower down.

A project with no e2e layer cannot prove a behaviour criterion: stop, and ask
the owner whether the first task builds one or the requirement changes.
Confirm the proofs and the seams with the owner before step 3: they decide the
tasks.

### 3. Cut

Break the work into tasks, each a vertical cut (see One cut, not one layer),
prefactoring first, each with its blocking edges. Map every criterion to the
task that delivers its proof:

- every criterion is covered by a task; one no task covers is either a missing
  task or out of scope, and the owner says which;
- a task that covers no criterion is groundwork (a prefactor, an expand step,
  the e2e harness) and says which tasks it enables;
- a criterion split over several tasks says which part each proves, and which
  task writes its proof.

### 4. Propose

Propose the breakdown as in What's next, with the criteria and the proof each
task covers, and iterate until the owner agrees.

### 5. Write and publish

Only a requirement that is `ready` on `main` is planned; a `draft` one, or
one whose pull request is still open, goes back to `requirement`. On a branch
from an up-to-date `main`:

1. write the task files, from the template below, with `Status: ready`: none
   can be picked until the plan is merged, since only `main` counts;
2. fill the requirement's **Proof** table: for each criterion, its task and
   the kind of proof (`e2e` or `doc`), the proof itself left empty; and set
   the requirement `ongoing`;
3. with a tracker: create the issues in dependency order, so every edge names
   a real issue: each one a sub-issue of the epic, with its dependencies and
   labels, in Backlog, its number written into the file's `Tracker` line;
4. open the pull request, `Plan R-012`. It is the gate to `main` like any
   other. If the owner rejects it, close the issues it created; when it
   merges, move the unblocked ones to To Do.

### 6. Gaps go back

Planning writes only the requirement's Proof table and status, never its
behaviour. A criterion that is ambiguous, a missing case found in the code,
two criteria that contradict: stop, and settle it with the owner through
`requirement` (Changing a requirement). Plan what is settled; the gap becomes
a decision task (see Decisions), and the tasks that depend on it list it in
their **Blocked by**.

## Tasks

- One file per task, one pull request per task; one issue too, with a tracker.
- No code snippets and no file paths in a task, beyond the requirement and the
  docs it links: they go stale and the code moves out from under them. A
  decision that needs a shape (a schema, a type, a state machine) gets its
  decision entry (`domain-modeling`), and the task cites it.
- Every task carries its seam from the moment it is cut. The batch proposal
  shows it (see What's next).
- Labels. These are the shared ones, defined here and nowhere else; a project's
  extra labels are in `docs/agents/tracker.md`. Without a tracker they are a
  `Labels` line in the file:

  | Label | On | Means |
  |---|---|---|
  | `requirement` | issue | the epic mirroring a requirement doc (set by `requirement`) |
  | `who/agent` | task | an agent can do it |
  | `who/user` | task | the owner must: sudo, a browser, a secret |
  | `needs/architect` | task | the design note (`architect`) is required before `implementer`: the coordinator adds it when planning the task, and whoever runs `architect` removes it once the note is on the task or its pull request. The note is the evidence — no second "architect: yes" line in the body — and a review that finds the label gone without one is a finding |
  | `needs/review` | pull request | a review is owed before merge; how it is added, removed and re-added is under Pull requests |
  | `decision` | task | stop and ask the owner (`grill-with-docs`) |
  | `blocked` | task | waiting on something outside the plan |

### Template

```md
# R-012-T01 <Title>

- **Requirement**: [R-012 <title>](../requirement/012-<title>.md);
  covers AC1, AC3 (proof: AC1 e2e, AC3 doc). Groundwork says
  "enables T02, T03" instead.
- **Decisions**: <D…, or "none">
- **Seam**: <where the tests sit, and the layer from docs/agents/testing.md>
- **Labels**: <who/agent, needs/architect, …>
- **Tracker**: <#N, or "none">
- **Status**: ready | ongoing | done | dropped
- **Claimed by**: <who, and the branch, while ongoing; empty otherwise>

## Blocked by

- [R-012-T01 <Title>](R-012-T01-<title>.md)
- [R-007-T03 <Title>](R-007-T03-<title>.md): a task of another requirement
  blocks it the same way

<or "None: can start as soon as it is ready.">

## Goal

<What it achieves and why, from the user's side.>

## Scope

<What it includes and what it leaves to other tasks or out.>

## Approach

<The components it touches and the interfaces it adds or changes, in the
glossary's words. Enough to justify the cut; the design itself is the
architect note's.>

## Done when

- [ ] AC1: <the e2e test that proves it> passes
- [ ] AC3: <the doc section that shows it> is written
- [ ] <anything else the task owes: a doc updated, a fake kept in step>

## Proof

- AC1: <the e2e test's name, filled by the task's pull request>
- AC3: <the doc section's link, filled by the task's pull request>
```

The **Done when** list is what the review checks the pull request against.
**Blocked by** lists only the tasks this one truly needs done first, by link,
in any requirement; the same edges go to the tracker. The proof is recorded
here, in the task, so that tasks of one requirement never edit the same file
at once; the requirement's Proof table is filled from these at its close.

### One cut, not one layer

A task is one **vertical cut**: narrow, but through every layer it needs
(store, service, API, interface, tests), never a horizontal slice of one layer. It
is verifiable on its own when done, and fits the budget `implementer` sets. The
project's own hints for where to cut are in `docs/agents/tracker.md`.

- Larger than that: split it into tasks, each with its own **Done when**, and
  set the edges in **Blocked by** (plus tracker dependencies). Split when the
  Scope crosses more than one package family or layer, or a contract and its
  docs.
- Parity work (a fake or a second implementation kept in step with the real
  one) is its own task when it would double the diff.
- Make the change easy first: groundwork that makes the rest small — a small
  prefactoring that makes the real change simple — is its own task, and the
  rest depend on it.
- A task whose brief cannot be finished inside the budget is the wrong cut,
  not a long agent run.
- A **wide refactor** is the exception: one mechanical change (a rename, a
  retyped shared symbol, a public contract change) whose blast radius fans
  across the codebase, so that no single cut lands green. Sequence it
  expand–contract:
  1. **expand**: the new form beside the old; nothing breaks;
  2. **migrate**: the callers move over in batches sized by blast radius (a
     package, a directory), each batch its own task depending on the expand;
     the old form stays, so each batch lands green;
  3. **contract**: the old form goes, once no caller remains, in a task
     depending on every batch.

  When a batch cannot stay green alone, the cut is wrong, not the plan: expand
  further (a shim, a re-export, an adapter) until each batch lands green on
  `main` by itself. There is no shared integration branch: every change
  reaches `main` through a pull request that is green there.

### The delegation pattern

A task is usually one implementer. When a second model is available and the
seam is clear, split it: the spec writer writes the failing tests and a short
plan; the implementer writes only the code, against tests it may not edit; the
coordinator runs the gate and the review. Resume those sessions instead of
starting new ones — the saved context is the cost saving. The split is a
choice, not a default: the brief names it, and if it does not, ask the owner.
Never use it while the second model is unavailable, and the coordinator, not
the implementer, adjudicates the red-first gate.

## Output and handoff

The output of planning is the task files and the requirement's Proof table, in
one pull request, and with a tracker their issues under the epic, with the
dependency edges, the labels and the cards. The task file (or its issue) is
what `architect` and `implementer` read; the design note returns to the task's
pull request; a decision goes to its decision entry, not to the plan.

## Board

The files' statuses are the truth; with a tracker, the board mirrors them and
adds the review steps the files don't track. A `ready` task sits in Backlog
while blocked and in To Do once not; a task with an open pull request (its
file `ongoing` on the branch) spans In Progress to Approved; `done` and
`dropped` are Done.

| Column | Holds | Moved there |
|---|---|---|
| Backlog | `ready` but blocked: a task in its **Blocked by** not `done`, or a `decision` or `blocked` label | when created, if blocked |
| To Do | `ready`, not blocked and not claimed | when created unblocked; when its blockers are done (see What's next); when an abandoned pull request releases its claim |
| In Progress | being worked on | when work starts; from In Review or Approved when a finding needs behaviour work |
| PR open | pull request with green CI, waiting for the owner's go to review (a first review, or a re-review after fixes) | when the pull request leaves draft with green CI; from In Progress, In Review or Approved when fixes are pushed with green CI and a re-review is owed (`needs/review` is on) |
| In Review | under review, or with fixes in progress | when the owner says to review (see `review`) |
| Approved | the last required review approved and the low fixes it leaves are confirmed or re-reviewed, waiting for the owner's merge | when that condition holds (see Pull requests) |
| Done | closed | after the merge |

The agent coordinating the work moves every card; the owner doesn't have to.
A review that approves with low findings keeps the card In Review until the
implementer confirms the fixes, or a re-review passes them, and only then does
it move to Approved. An epic's card follows its tasks: In Progress while any
task is In Progress, PR open, In Review or Approved; Done only when the
requirement is done (see Closing).

Every change of status is in a pull request; a task's `done` is in its own,
so the merge makes it true.

## Pull requests

- The body names the task file. With a tracker it also says `Closes #N` for
  the task's issue, so the merge closes it; `Refs #N` when it only touches
  one. Never the epic: it closes when the requirement is done. Fixes from the
  review go on the same pull request, without a new task.
- The body holds the design note (see the `architect` skill), how it was
  tested (the tests that failed first), and **Open points**.
- Every review is a comment on the pull request (see the `review` skill). The
  label is the machine-readable state, and it follows the review. If the
  project guards merges on it (`docs/agents/tracker.md` names the guard), the
  guard fails while the label is on and passes again once it comes off, with no
  new push. While the label is on, "green CI" means the test check: the guard is
  red by design until the label goes, and every context is green only once it
  has.
  - the implementer adds `needs/review` when the pull request leaves draft;
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

- A task with a pull request is `done` by its merge (the pull request sets the
  status), which also closes its issue.
- A task without one (a `who/user` task, something verified outside the
  repo) is set `done` by the agent in a small pull request, after checking
  the result itself, with the evidence in its Proof section and on its issue.
- **A requirement is done** when every acceptance criterion is proved by an
  e2e test that passes on `main`, or a doc section that shows it. Not when its
  last task merges: a criterion without a proof keeps it `ongoing`, and needs a
  task. Once every task of it is `done` or `dropped`, the coordinator checks
  each proof itself (runs the named tests, opens the docs), copies them from
  the tasks' Proof sections into the requirement's Proof table, sets it to
  `done` in a pull request, and with a tracker closes the epic with a comment
  listing each criterion and its proof.
- Never close on a check that failed or wasn't run: comment, and leave it
  open or label it `blocked`.
- An abandoned pull request gets a comment saying why; its task stays
  `ready` on `main` (see Claiming a task). A superseded one's task is
  `dropped`, with a link to the replacement. `blocked` is only for a blocker
  outside the plan.

## What's next

The coordinating agent reads the statuses on `main` and the open branches
and pull requests (see Claimed) at the start of a session and after each
merge, and proposes the next batch (see the project's workflow): every
`ready` task neither blocked nor claimed, grouped by what can run
concurrently. After each merge, with a tracker, it moves the cards of the
tasks just unblocked to To Do; and when a requirement's last task merges, it
runs the requirement's close (see Closing). For a `who/user` task, it posts the
exact commands as a comment.

The proposal is the breakdown, not only the list: for each task, its title,
the tasks that block it, its seam, the criteria it covers with their proof,
and the behaviour it delivers when done. Then it asks the owner, and iterates
until they agree:

- is the granularity right, too coarse or too fine?
- does each task depend only on what genuinely gates it?
- should any be merged, or split further?
- is every acceptance criterion covered, with its proof?

Work that arrives as a feature becomes a requirement, then is planned, before
it reaches the board.

## Decisions

A decision is a task labelled `decision`, and the tasks that need it list it
in their **Blocked by**. It uses the same template, with
`Requirement: R-012, decision for AC2` (or `none (chore)`), `Seam: none
(decision)`, no Approach, and a **Done when** that names the doc the answer
goes to. It is settled with the owner in a conversation (the
`grill-with-docs` skill): the docs are written on a branch as the answers
settle, the outcome goes in the task's Proof section (and on its issue), and
that docs pull request sets it `done`.

## Open points

An open point a review leaves behind never lives only in a pull request:

- deferred: a new task, `ready`: a task file with the next `T` of its
  requirement (or `chore`), and its issue with a tracker. The coordinator
  files it without asking, in a small pull request of its own, never in the
  pull request under review (that one changes only for its findings): filing
  is planning, not recording a decision. Only a decision (a decision entry, a
  glossary term, a doc sentence) needs the owner's agreement first;
- part of another open task: a comment on its issue, or a line in its file;
- accepted as built: recorded in the next decisions pull request.
