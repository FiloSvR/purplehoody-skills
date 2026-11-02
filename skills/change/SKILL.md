---
name: change
description: Implement a requirement or fix a bug, test first, through to a pull request with green CI. Use for any code change; use the architect skill first if the change affects structure.
disable-model-invocation: true
---

# Change

Code and tests are one task here: the test comes first and the change is done
when CI is green. In a split delegation (see the `plan` skill) the failing
tests belong to the spec writer and the implementer writes only the code,
against tests it may not edit; steps 1 and 2 are then the spec writer's. An
implementer that thinks one of those tests is wrong stops and reports it to the
coordinator, who decides; it never edits the test.

The project's own facts (test layers and suffixes, commands, dependency rules,
the rules that hold whatever the task) are in `docs/agents/testing.md`. Read it
first.

## Before

- If the change adds or moves a component, package, API resource, store or
  dependency, run the `architect` skill first.
- Find the requirement or use-case ID it serves. A bug fix references the
  requirement it violated, or the issue.
- Work from an issue (see the `plan` skill); create one if there is none, and
  move its card to In Progress.
- An issue with no `Seam:` line (and no Testing decisions) is a question for
  the coordinator: stop and ask; do not pick a seam yourself.
- Branch from an up-to-date `main`. Every change reaches `main` through a pull
  request.
- Mind the context budget: stay under 200k tokens and about 50 turns. Read
  only the docs and sections the issue or brief names, not whole documents,
  and use `git diff` instead of re-reading files. Approaching the budget, stop
  and report what is done and what is left.

## Steps

1. **Write the failing test.** In a split, the spec writer does this step; the
   implementer starts at step 2. Start from the seam the issue names (see
   `plan`). Put the test next to the code, in the layer the project's testing
   file assigns to that kind of behaviour.
   - Put the ID in the test name or a comment on it.
   - Never use the network or real credentials; fake models and the clock.
     Each test gets its own temporary directory.
   - Test behaviour through the public interface, not internals.
   - For tooling and wiring — configuration, scripts, adapters, generated
     files — assert the observable outcome (the files a runner collects, the
     request a server answers), not the value you put in the configuration.
     A config value can be right while the wiring around it is broken.
2. **Watch it fail for the right reason.** Run only the test files the change
   touches, never the whole suite — CI is the full gate. A test that passes
   before the change proves nothing.
3. **Write the code.** Follow the surrounding code: names, comments, idioms.
   Prefer the platform's own concepts and APIs over new abstractions.
4. **Run the gates.** Run only the test files the change touches, plus the
   project's check command (`docs/agents/testing.md`). On a shared or small
   host, run them with whatever resource caps the local notes require.
5. **Commit.** Commit at each green checkpoint, so a restart keeps the work.
   Reference the IDs in the message. Follow the project's dependency rules in
   `docs/agents/testing.md`.
6. **Open the pull request.** Say what changed, the IDs, how it was tested and
   anything left out, and `Closes #N` for its issue. Add the `needs/review`
   label (`plan` owns the rule). CI must pass; what "green" means while the
   label is on is in `plan` (Pull requests). Docs-only pull requests skip the
   tests. The project's extra CI gates and labels are in
   `docs/agents/tracker.md` and `docs/agents/testing.md`. A branch that
   conflicts after another merge is rebased and goes through CI again. Then report the pull request and stop: the review starts
   when the owner asks (`review`), and its findings come back to you on the
   same pull request.
7. **Keep the docs true.** If the change alters what the architecture doc says
   (status, invariants, tables), update it in the same pull request.

## Never

- Skip or weaken a failing test to get green; fix the cause or say why not.
- Break the project's standing rules (`docs/agents/testing.md`).
- Commit secrets, or print them in logs or test output.
