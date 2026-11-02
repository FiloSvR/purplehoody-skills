---
name: grill-with-docs
description: A relentless interview to settle a plan, decision or idea with the owner, which also records the project's words and decisions in the docs as they settle. Use when the owner wants to stress-test their thinking or uses any 'grill' trigger phrase ("grill me", "grill this"); also when the architect skill reaches a decision the docs don't settle, and for a decision issue.
disable-model-invocation: true
---

<!--
Adapted from mattpocock/skills at commit
95249b0b49782349740fd9b8c6ce32b4e59e497a (MIT, see LICENSE in this folder):
skills/engineering/grill-with-docs/SKILL.md, with the interview from
skills/productivity/grilling/SKILL.md folded in.
Changes: the interview is part of this skill instead of a separate `grilling`
skill; trigger phrases, the architect hook and decision issues in the
description; the agent may start it; sub-agent step made tool-neutral;
"Settled so far" list; "Recording" section for the project's docs and branch.
Upgrades are deliberate: diff against upstream before changing the commit.
-->

Interview the user relentlessly until you reach a shared understanding, and follow the `domain-modeling` skill while you do: it challenges the words used and writes them, and the decisions, into the docs as they settle.

Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
**Settled so far:** <terms and decisions settled in earlier rounds, one line each, and where each was written>

❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Word each question so "yes" accepts your recommended answer.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, docs, code, tools, the web), look it up yourself, or with a sub-agent if your tool has them; don't ask the user for anything you could look up yourself. Don't block on it: a lookup still running is an unsettled prerequisite, so only the questions downstream of it wait; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

## Recording

The user's answer is the OK to record it: write each settled term or decision as it settles, not in a batch at the end.

- Work on a branch; the pull request is the gate to `main`. When the session
  comes from an issue, the pull request closes it (see the `plan` skill)
  and the issue gets a comment listing what was settled.
- Where each kind of thing goes is in `docs/agents/docs.md`: a term goes to
  the glossary; a decision that passes the three tests in `domain-modeling`
  gets a decision entry; a requirement goes to the requirements doc; the
  resulting structure to the architecture doc.
- Anything settled that fits none of those still goes on the issue comment, so
  nothing lives only in the conversation.
- Anything the project keeps out of the repo (`docs/agents/docs.md`) stays out.
