# Tracker, labels and board

Read by `requirement`, `plan` and `implementer`.

- Tracker: `<where issues and pull requests live and the commands that drive
  them, or "none": the plan files are then the only record; machine-specific
  details (hosts, accounts, paths) go in untracked local notes, not here>`.
- Epics and sub-issues: `<how this tracker links a task to its requirement's
  epic: native sub-issues, a parent field, or a "Part of #N" line>`.
- Issue titles: the requirement or task id, `R-NNN <Title>` or
  `R-NNN-TNN <Title>`, from the files (see `plan`).
- Extra labels (the shared ones are defined in `plan`):

  | Label | On | Means |
  |---|---|---|
  | `<label>` | `<issue or pull request>` | `<what it means and who sets it>` |

- Status commits: `<straight to main (the default), or "main is protected":
  claims are then draft pull requests (see plan, Status commits)>`.
- Merge guard: `<the CI context that fails while `needs/review` is on, or "none">`.
  Required CI contexts: `<names>`.
- Board columns: `<the ones in `plan`, or what differs>`.
- Merge authority: `<only the owner, unless this says otherwise>`.
