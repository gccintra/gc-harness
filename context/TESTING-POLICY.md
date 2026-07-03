# Testing Policy — Risk-Based

Single source of truth for **what to test and what not to test**. All test
skills (`test-generator`, `test-runner`) read this before writing or gating
tests.

**Goal is NOT 100% coverage.** Goal is tests on code where a bug costs money,
data, or a broken core flow. A test that only re-asserts the framework, or
locks in an internal variable name, is negative value — it costs tokens to
write, breaks on every refactor, and protects nothing. Skipping it is correct,
not lazy.

The rule of gold: **test software the way a user uses it.** User clicks
buttons and reads the screen; user does not care about internal state or
function names.

---

## 🚨 MUST test (high priority)

1. **Critical user journeys (happy path, E2E/integration).**
   The flows where breakage = money/data lost or product unusable.
   _Illustrative only (judge the actual diff, not this list):_ login/auth,
   create session, terminal WS stream stays alive, session survives
   worker/server restart (tmux reattach), kill/DELETE session.
2. **Business logic & non-trivial calculations (unit).**
   Discounts, taxes, financial formatting, state machines, parsers, anything
   with branches. Fast and cheap to test in isolation.
   _Illustrative only (judge the actual diff, not this list):_ status detector
   regex (`waiting`/`active`/`finished`), `buildCliCommand()`, `resolveSafePath()`
   path sanitization, IPC protocol encode/decode, JWT issue/verify.
3. **Shared UI primitives (unit/integration).**
   A `<Button>`/`<Modal>`/`<Input>` used across many screens — renders with
   the right props, fires the expected events (`onClick`). Break it → break
   everything that uses it.
4. **Error handling (integration, mocked failures).**
   API down → user sees a friendly message, not a white screen. Mock the
   network/IPC failure and assert the fallback UI/behavior.
5. **Security boundaries.** Auth, path traversal, input validation at trust
   boundaries — always tested, never skipped.

## 🛑 Do NOT test (waste)

1. **Third-party code.** Don't test that React sets state, Axios sends HTTP,
   react-router changes the URL, xterm renders a glyph. Trust the library.
   Test only *your* code's interaction with it.
2. **Implementation details.** Test the *result*, not how it's written. Test
   "click submit → form sends", never the internal variable holding click
   state. Detail tests break on every refactor while the feature still works.
3. **Style/CSS in unit tests.** Don't assert "text is red" or "margin 16px"
   with Vitest/Testing-Library — fragile. If visual fidelity is critical, use
   visual-regression tooling (snapshots/Percy/Chromatic), not unit tests.
4. **Dumb/static components.** A page that's only `<h1>`/`<p>`, a static footer
   of links. No logic, no interaction → test cost > value.
5. **Trivial one-liners / pure passthroughs.** A getter that returns a field,
   a thin re-export. YAGNI applies to tests too.

---

## Triage gate (run BEFORE writing any test)

Criticality is decided **dynamically, from the diff in front of you** — never
from a fixed checklist. For each changed file/symbol, judge what *this change*
does and write a concrete reason in the `Why` column (e.g. "parses untrusted
input", "shared by 12 screens", "guards the auth boundary"). A vague reason
("important") means you haven't triaged — redo it. The categories above are
lenses for judging, not a list to match against.

For each changed file/symbol, classify:

```
| Symbol/File            | Class      | Test? | Why                          |
|------------------------|------------|-------|------------------------------|
| resolveSafePath()      | security   | YES   | path-traversal boundary      |
| statusDetector regex   | biz-logic  | YES   | branchy, core to status      |
| <Sidebar> static links | dumb-ui    | NO    | no logic/interaction         |
| useFoo internal flag   | impl-detail| NO    | refactor-fragile, no value   |
```

Write tests ONLY for `YES` rows. Put the table in the test-generation output
so the gate is auditable. If everything classifies `NO`, write zero tests and
say so — that is a valid outcome.

## Coverage = signal, not gate

Coverage % is **informational**, never a blocking number. There is no global
80% gate. The gate is:

- **All written tests pass (zero failures).** Hard block.
- **Every MUST-test item above has a test.** Hard block.
- A low coverage % caused only by `NO`-class code is **PASS**, not a gap.

A "coverage gap" only matters if it lands on a MUST-test item.
