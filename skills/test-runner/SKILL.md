---
name: test-runner
description: Runs scoped tests for the current task. Never runs the full suite by default. Reads scope from task file.
---
## Test Runner

### Step 1: Determine scope
1. Task file exists → read `## Escopo de teste` → use those exact paths
2. No task file → `git diff --name-only HEAD` → find matching test files
3. Neither → ask the user

**Never run the full suite unless explicitly requested.**

### Step 2: Get test commands
Read **CLAUDE.md §2** for stack-specific test commands and any Node/runtime version requirements.

### Step 3: Run scoped tests

Use the commands from CLAUDE.md. Run only the files from Step 1.

### Step 4: Report

```
## Test Results: PASS | FAIL
Scope: <files>
Total: N | Passed: N | Failed: N

Failures:
1. file.test.ts:45 — "test name" — Expected X got Y
```

Pre-existing failures → see `context/TESTING-POLICY.md` (fallback: CLAUDE.md § Known Pre-existing Test Failures). Do NOT re-investigate.

**Gate:** 100% of scoped tests must pass before proceeding to `@committer`.
The **full suite** is not run here — that is `@committer` Step 2.4, the final gate.
