# Tracker, labels and board

Read by `plan`, `change` and `review`.

- Tracker: `<where issues and pull requests live and the commands that drive
  them; machine-specific details (hosts, accounts, paths) go in untracked local
  notes, not here>`.
- Issue ids: `<the scheme, e.g. a letter per milestone plus a number>`.
- Extra labels (the shared ones are defined in `plan`):

  | Label | On | Means |
  |---|---|---|
  | `<label>` | `<issue or pull request>` | `<what it means and who sets it>` |

- Merge guard: `<the CI context that fails while `needs/review` is on, or "none">`.
  Required CI contexts: `<names>`.
- Board columns: `<the ones in `plan`, or what differs>`.
- Merge authority: `<only the owner, unless this says otherwise>`.
