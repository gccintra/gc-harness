---
name: implement
description: Inline implementation from a task file or description. No agent spawn, no cold start.
---
## Implement

Implement inline. Full context already available — no briefing, no cold start.

---

### Step 0: Read context (skip what you already know)

Read only what you need:
- **CLAUDE.md §2** — dev commands, test commands
- **GOTCHAS.md** — read this first, saves you from known pitfalls
- **ARCH.md** — if touching architecture, sessions, or PTY
- **API.md** — if adding/changing routes
- **DATA_MODEL.md** — if touching DB or schema
- **DESIGN.md** — if touching UI
- **DECISIONS.md** — if touching an area with known ADRs (read before questioning any design choice)
- **Task file** (if exists) — problem, AC, API/DB changes, files to modify, test scope

Do NOT read the whole repo.

---

### Step 1: Determine input

**With task file** (`.claude/work/tasks/<id>.md`):
Extract: problem, AC, API changes, DB changes, files to modify, test scope.
Update status: `PLANNING → IN_PROGRESS`

**Without task file:** use conversation context. If scope is unclear, ask one question.

---

### Step 2: Triage tests BEFORE writing any code

```
| Symbol/File         | Class       | Test? | Why                          |
|---------------------|-------------|-------|------------------------------|
| featureRoute()      | biz-logic   | YES   | branchy, handles auth        |
| resolveSafePath()   | security    | YES   | path-traversal boundary      |
| FeatureCard.tsx     | dumb-ui     | NO    | no logic/interaction         |
| useFoo internal var | impl-detail | NO    | refactor-fragile, no value   |
```

Zero tests is valid if all rows are NO.

---

### Step 3: Implement

Read only the files you need to change. Minimal diff — only what the task requires.

Gotchas already loaded from GOTCHAS.md in Step 0 — apply them.

**Figma:** if task has Figma URL → `figma_get_design_context` → `/figma-implement-design`

---

### Step 4: Write tests (MUST-test items only from Step 2)

`/test-generator` for each YES row. Test behavior, not implementation.

---

### Step 5: Security spot-check

Only for changes touching: auth, file I/O, user input, JWT, paths, secrets.

`/security-checker --files <changed-files>`

---

### Step 6: Self-verify

- [ ] Typecheck passes (see CLAUDE.md for command)
- [ ] Tests written for all YES rows from Step 2
- [ ] No console.log / debug code
- [ ] Diff is minimal — no unrelated changes

---

### Step 7: Inline code review

You already have full context. No re-reading. Run the diff:

```bash
git diff main...HEAD
```

Scan and check:
- [ ] Bugs, null dereferences, unhandled edge cases
- [ ] Auth on all non-public routes; input validated at boundaries
- [ ] No hardcoded secrets, no path traversal
- [ ] All YES rows from Step 2 triage have tests
- [ ] Conventions clean (per CLAUDE.md + GOTCHAS.md)
- [ ] No debug code, no unrelated changes

**Issue found:** fix (Step 3) → re-run diff → re-check.
**Clean:** update task file → `READY_TO_COMMIT`.

---

### Step 8: Update context docs

| Changed | Update |
|---------|--------|
| Route added/removed/changed | `API.md` |
| New folder or file convention | `FOLDER_ARCH.md` |
| New layer, data flow, component | `ARCH.md` |
| Schema change | `DATA_MODEL.md` |
| New design token or pattern | `DESIGN.md` |
| Non-obvious gotcha | `GOTCHAS.md` + `/lessons-writer` |
| Architectural decision | `DECISIONS.md` |

Nothing structural → skip.

---

### Step 9: Report

```
## Implementation done

Files changed:
- src/routes/feature.ts (+45, -3)
- src/components/Feature.tsx (+12, -0)

Triage:
- featureRoute() → YES → tested
- FeatureCard.tsx → NO → skipped

Tests: src/routes/feature.test.ts (8 tests)
Security: PASSED / N/A
Review: APPROVED
Status: READY_TO_COMMIT

Next: /test-runner → @committer .claude/work/tasks/task-<slug>.md
```

---

### Fix pass (after /test-runner failures)

1. Read exact failures from `/test-runner` output
2. Fix ONLY those — do NOT re-implement
3. Verify using test command from CLAUDE.md §2
4. Re-run Step 7 review on the fix diff
5. Report what changed
