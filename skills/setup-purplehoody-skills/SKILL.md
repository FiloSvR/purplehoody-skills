---
name: setup-purplehoody-skills
description: Configure this repo for the purplehoody skills: write docs/agents/ (docs, testing, tracker, review) and the pointer block in AGENTS.md. Run once per repo.
disable-model-invocation: true
---

# Setup purplehoody skills

The shared skills (`requirement`, `plan`, `implementer`, `architect`, `review`,
`domain-modeling`, `grill-with-docs`) name no project facts. They read them from four files in
`docs/agents/`. This skill writes those files, from the templates next to it.
It is prompt-driven: explore, present, confirm, then write.

Keep `AGENTS.md` lean: it gets a short pointer block, not the facts.

## Process

### 1. Explore

Read, don't assume:

- `AGENTS.md` and `CLAUDE.md`: which exists, and is there already an
  `## Agent skills` block?
- `docs/agents/`: a previous run's output. Update it, don't overwrite edits.
- the docs: requirements, architecture, decisions, glossary, wherever they are.
  Requirements kept in one file are not moved by this skill: say so, and
  offer to split them into the `requirement` skill's one-file-per-requirement
  format as a separate pull request.
- `package.json` scripts (or the build tool's equivalent), the test layout, the
  CI config, the pre-commit hook.
- `git remote -v` and the labels on the tracker, if it can be reached.
- untracked local notes (`AGENTS.local.md` or similar): machine-specific facts
  live there, never in the files below.

### 2. Present and ask

Show what you found and what is missing. Take one file at a time: lead with the
recommended answer so "yes" accepts it, and ask only where the choice
genuinely branches.

1. **docs.md**: where the requirements, plans, architecture, decisions and
   glossary live, and what the repo must never hold.
2. **testing.md**: the layers, the commands, the dependency rules, the standing
   rules.
3. **tracker.md**: the tracker (or none), how epics link sub-issues, extra labels, the merge guard.
4. **review.md**: the mechanical checks, escape hatches, invariants, extra
   high-risk kinds.

A project with no tracker, no CI guard or no extra labels says so in the file
in one line; the shared skills still work.

### 3. Confirm and write

Show the drafts of the four files and the pointer block. After the owner's OK:

- write `docs/agents/docs.md`, `testing.md`, `tracker.md` and `review.md` from
  the templates in this skill's folder, filling every `<placeholder>`;
- add this block to the file that exists (`AGENTS.md`, else `CLAUDE.md`; if
  neither exists, ask), or update it in place:

```markdown
## Agent skills

Shared skills read these files:

- Docs layout: `docs/agents/docs.md`
- Testing and standing rules: `docs/agents/testing.md`
- Tracker, labels, board: `docs/agents/tracker.md`
- Review: `docs/agents/review.md`
```

Nothing machine-specific goes in these files: hosts, accounts, paths and
secrets belong in untracked local notes.

### 4. Done

Say which skills now read which file, and that the files can be edited by hand
later; re-run this skill only to start over.
