# purplehoody-skills

Agent skills for planning work, changing code test first, designing, reviewing
and keeping a project's words and decisions. They hold the method; each project
holds its own facts in four small files under `docs/agents/`.

| Skill | For |
|---|---|
| `setup-purplehoody-skills` | once per repo: writes `docs/agents/` and the pointer block in `AGENTS.md` |
| `requirement` | one requirement doc, problem to acceptance criteria, by interviewing the owner |
| `plan` | a requirement into task files in `docs/plans/` (mirrored as sub-issues of its epic), the board, closing a requirement once every criterion is proved |
| `implementer` | one change, test first, through to a pull request |
| `architect` | designing a change that affects structure |
| `review` | reviewing a pull request, from a fresh context |
| `domain-modeling` | the glossary and the decisions |
| `grill-with-docs` | settling a plan with the owner, recording as it settles |

All are user-invoked (`disable-model-invocation: true`): the agent never starts
one by itself.

## Install

**Claude Code** (a plugin):

```bash
claude plugin marketplace add FiloSvR/purplehoody-skills
claude plugin install purplehoody-skills@purplehoody
```

**Other agents**, as editable files:

```bash
npx skills@latest add FiloSvR/purplehoody-skills -a <agent>
```

**Linked from a clone**, so `git pull` updates them:

```bash
git clone https://github.com/FiloSvR/purplehoody-skills
cd purplehoody-skills
scripts/link-skills.sh [folder]   # default: ~/.claude/skills
```

Then, in each project, run `/setup-purplehoody-skills` once.

## Update

**Claude Code** (a plugin):

```bash
claude plugin marketplace update purplehoody
claude plugin update purplehoody-skills@purplehoody
```

**Other agents**: run the install command again. Local edits to the copied
files may be overwritten.

**Linked from a clone**: `git pull`. Re-run `scripts/link-skills.sh` only if a
skill was added, renamed or removed, and delete any stale link in the skills
folder (for example `change`, now `implementer`).

A project's `docs/agents/` files are never touched by an update. Re-run
`/setup-purplehoody-skills` only if a release changes the templates, and check
what it would overwrite first.

## What a project provides

| File | Holds | Read by |
|---|---|---|
| `docs/agents/docs.md` | where requirements, plans, architecture, decisions and glossary live; what the repo never holds | `requirement`, `plan`, `implementer`, `architect`, `domain-modeling`, `grill-with-docs` |
| `docs/agents/testing.md` | test layers, commands, dependency rules, standing rules | `implementer`, `architect`, `plan` |
| `docs/agents/tracker.md` | the tracker (or none), how epics link sub-issues, status commits, extra labels, merge guard | `requirement`, `plan`, `implementer` |
| `docs/agents/review.md` | mechanical checks, escape hatches, invariants, high-risk kinds | `review` |

Optionally, `docs/implementer-*.md` (e.g. `implementer-frontend.md`, `implementer-backend.md`) hold per-area guides; `implementer` reads the ones matching the area it touches.

Templates are in `skills/setup-purplehoody-skills/`. A project with none of
these things says so in one line; the skills still work.

## Credits

`domain-modeling` and `grill-with-docs` are adapted from
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT; the notice is in
`THIRD-PARTY-LICENSE-mattpocock` and in each skill's folder). Both keep their
upstream names, so install one source or the other, not both. The
code-quality step of `review` takes ideas from the same repo.
