# Testing and standing rules

Read by `change`, `architect` and `plan`.

## Layers

| Suffix or place | Layer | Use for |
|---|---|---|
| `<e.g. .test.ts>` | unit | `<pure logic, parsing>` |
| `<…>` | integration | `<…>` |
| `<…>` | end-to-end | `<…>` |

## Commands

- One test file or folder: `<command>`. Never the whole suite; CI is the gate.
- Check (lint, types, dependency rules): `<command>`. Runs on every commit
  through `<the hook>`, if there is one.
- Format fix: `<command>`.

## Dependencies

`<How to add one: exact versions, lockfile rules, the label a lockfile change
needs, any packages that must stay on one version.>`

## Standing rules

`<The rules that hold whatever the task: tests offline, no real credentials,
what never goes in the repo, public API boundaries. One line each.>`
