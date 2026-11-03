# Docs

Where this project keeps what the skills read and write. Paths are relative to
the repo root.

- Requirements: `<folder, default docs/requirement/>`: one file per
  requirement, `NNN-short-title.md`, id `<prefix, default R->NNN` (the
  `requirement` skill's format).
- Plans: `<folder, default docs/plans/>`: one file per task,
  `R-NNN-TNN-short-title.md` (the `plan` skill's format).
- Architecture: `<path>`: components, processes, request flow, data and the
  invariants, each with the test that checks it.
- Decisions: `<path>`: numbered entries (D1, D2, …), under "Decisions".
- Glossary: `<path>`: the project's words, in the format of the
  `domain-modeling` skill's GLOSSARY-FORMAT.md.
- Kept out of the repo: `<what never goes in a tracked file: deployment data,
  hosts, accounts, personal data, secrets. Say where it lives instead.>`
