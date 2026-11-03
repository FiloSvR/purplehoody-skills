---
name: review
description: Review a pull request the same way whatever agent, tool or model does it, and leave the review as a comment on the pull request. Use when the owner asks for a pull request to be reviewed, and when the owner asks again after the implementer's fixes; a high-risk change gets a second, independent review.
disable-model-invocation: true
---

<!--
The code-quality step, the convergence rule and the headline take ideas from
mattpocock/skills at commit 3da8c01116264675eeefbd6e9d59c734de9095cc (MIT):
skills/engineering/code-review/SKILL.md. Its smells baseline follows Fowler's
*Refactoring*. Written independently; no text copied.
-->

# Review

A review finds what is wrong with a change; it does not confirm that it works.
Its result is one comment on the pull request, so the owner and later readers
see what was checked and on what evidence. Findings go back to the
implementer, who fixes them on the same pull request.

## Who reviews

- Never the author of the change. The coordinator reviews the implementers'
  pull requests when the owner asks; a pull request the coordinator wrote is
  reviewed by another agent.
- Start from the pull request number, in a fresh context. Read the task (its
  file in the plans folder, or its issue), the requirement criteria and the
  docs it cites, and the diff first, and form your own view. Only then read the
  pull request body and the implementer's report, and check each claim in them
  against the code.
- A **high-risk** change gets a second, independent review: one that touches
  access, identities or tokens; a store or a migration; restarts, crash
  recovery or concurrency; a public contract; secrets. The project's own list is in
  `docs/agents/review.md` and adds to this one.
  The second reviewer writes its review without reading the first, and is a
  different model or tool where one is available. When one is not available,
  the second review says so and records that it came from a different agent
  (or only a fresh context), so the owner can see how independent it was.
  There is no label for it: the reviewer decides from the diff and marks the
  risk in the review's `Risk:` line, saying why; if it is not sure, treat the
  change as high-risk.

## Steps

1. **Scope.** Compare the diff with the issue's scope: nothing missing, nothing
   extra, and nothing from its Out of scope (for a contained issue, what its
   Scope leaves out). The tests must prove the behaviour at the seam the issue
   names; one below that seam is fine, one at another seam is a finding unless
   the diff says why. Extra work belongs in its own issue.
2. **Done when.** Give each item its evidence: a test name, a `file:line`, or
   a command and its output. An item without evidence is not met. Each
   criterion the task covers has its proof in the requirement's Proof table,
   and the proof is an e2e test or a doc section that really shows the
   criterion; a lower-level test does not count. Where the
   issue carried `needs/architect`, check the design note is on the issue or
   its pull request and the label is gone (the rule is the `plan` skill's).
3. **CI.** Green CI includes the project's mechanical checks;
   `docs/agents/review.md` lists them and what each one means. Read what they ran, not only that they
   passed, and judge every escape-hatch mark the project defines there: a mark
   that hides what the rules exclude is a finding.
4. **Break it.** For each rule the change adds, break the code in the
   smallest way (drop a check, invert a condition, allow everything), run the
   tests, and see at least one fail. Record each break and what caught it. A
   break nothing catches is a finding. Do it in a throwaway checkout (a
   `git worktree` or a copy): never commit or push the break, and remove the
   checkout afterwards.
5. **Invariants.** Check the change against:
   - the invariants and request flow in the architecture doc;
   - the standing rules and invariants listed in `docs/agents/review.md`;
   - the decisions the issue cites;
   - the docs that describe the changed code: they must still be true.

6. **Code quality.** Read the diff for code that will be hard to change. The
   repo's own rules come first (the project's docs, how the surrounding
   code is written); where they say nothing, use this baseline of smells,
   after Fowler's *Refactoring*:
   - a name that doesn't say what the thing does or holds;
   - the same logic in two places in the change;
   - a function that works on another object's data more than its own;
   - fields or parameters that always travel together: a type waiting to be
     named;
   - a string or number standing for a domain concept that deserves its own
     type;
   - the same switch on the same type in several places;
   - one logical change spread over many files, or one file changed for
     unrelated reasons;
   - an abstraction, parameter or hook the issue doesn't need;
   - a caller walking a long chain of objects it shouldn't depend on;
   - a function or class that only passes calls on;
   - an implementer that ignores most of what it inherits.

   Skip what the gates (step 8) already enforce. A breach of a written rule
   cites the rule. A smell is a judgement call, not a rule: report it as low,
   name the smell, quote the lines, and say what simpler shape you expect.
7. **Attack it** (high risk). Look for:
   - failure paths and cleanup: what an absent or throwing hook does (it must
     fail closed), what is left behind on an error;
   - a crash or restart between two writes;
   - retries and races: a request id retried by another principal, two calls
     at once;
   - input from another user, channel or namespace;
   - data written by an older version (migrations), or two stores out of step.
8. **Gates.** Run only the focused tests the steps need on the final head,
   within the local resource caps; a green CI on the head covers the full
   suite. Keep within the context budget `implementer` owns.

## Findings

- Each finding has:
  - a severity:
    - high: a wrong result, lost data, or access that should be refused;
    - medium: a gap that will bite, such as an untested risky case, or the
      contract and the fake drifting apart;
    - low: wrong claims, clarity, code quality;
  - a concrete scenario (inputs and state → wrong outcome; for a smell, the
    quoted lines);
  - the `file:line`;
  - what to change.
- Report only what you verified, by reading the code path or reproducing it;
  say what you could not verify.
- Send findings back: the implementer fixes them on the same pull request. The
  reviewer fixes only typos and formatting, and lists them.

## Re-review

A review after fixes does not start over: every fix adds code, so a full
review each round never ends.

- It covers the fix commits and the findings they answer, at the new head, in
  the same format, breaking the new code too. In code the fixes did not
  touch, it reports only a new high or medium finding.
- When every open finding is low, the reviewer approves and lists them. The
  implementer fixes them and confirms in one comment on the pull request:
  each fix, its commit, and the gates run on the final head. There is no
  further round if the fixes change no behaviour: docs, comments, names,
  formatting, or added tests. A fix that changes what code does still goes
  back to the reviewer when the owner asks; the reviewer checks only that diff
  and posts a short `## Re-review` approving it or raising a finding. A finding
  it raises follows these same rules, so each round covers a smaller diff.
- The second reviewer looks again when the owner asks, if the fixes change
  behaviour in high-risk code (the list under "Who reviews").
- The headline of a re-review counts the findings still open after it: the
  new ones and those carried over. When unsure between two severities, take
  the higher one.

## The record

One comment per review, on the pull request:

```markdown
## Review: <approve | changes requested>

<n> high, <n> medium, <n> low; worst: <F<n>, in a few words | none>.

Reviewed at `<sha>` against #<issue>, the diff and the docs. Risk: <low | high (why)>.

### Done when
| Item | Status | Evidence |
|---|---|---|

### Findings
**F<n> (<high | medium | low>): <the claim>.** <scenario; `file:line`; what to change>

### Open points
<each one, with where it lives now>
```

The headline line lets the owner see the outcome without reading on. The
second reviewer heads it `## Second review (independent): …`; a review after
fixes heads it `## Re-review: …`. The report to the owner links the review
comments and says what is left for them to decide.

A review that leaves no finding approves the change. Whether that clears the
pull request's `needs/review` label is the `plan` skill's (Pull requests): a
first approval on a high-risk change is not the last required review.

## Open points

An open point never lives only in a pull request; where each kind of it goes
is in the `plan` skill.

## Never

- Approve on the implementer's word, or with a "Done when" item that has no
  evidence.
- Review your own change.
- Merge: the owner decides, unless the project says otherwise.
