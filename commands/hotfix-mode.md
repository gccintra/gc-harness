---
description: Expedited workflow for critical production fixes, bypassing normal planning stages while maintaining quality gates.
---
## Hotfix Mode Skill

Fast-track workflow for urgent production issues that require immediate attention.

### When to Use
- Production is down or severely degraded
- Critical security vulnerability discovered
- Data corruption or loss occurring
- SLA breach imminent
- User explicitly flags as URGENT/HOTFIX

### When NOT to Use
- Feature requests (no matter how "urgent")
- Non-critical bugs
- Performance improvements
- Refactoring needs

### Hotfix Workflow

Pula o `/plan` (sem task file completo, sem aprovação de plano). **Não** pula o
`@committer` — commit, push e PR continuam sendo dele, com aprovação explícita.

```
1. Spec mínima      → .specs/tasks/hotfix-<num>.md (Steps 1-2)
2. Fix inline       → mudança mínima + teste de regressão (Steps 3-4)
3. Gate abreviado   → /security-checker escopado + testes dos arquivos tocados (Steps 5-6)
4. @committer       → branch hotfix/, commit fix!:, PR (Step 7)
                      gate de suite completa: WAIVED — o usuário autoriza na hora
```

### Step 1: Acknowledge Hotfix

Create minimal spec:
```markdown
# HOTFIX: Issue #<num>

## Status: IN_PROGRESS

## Problem
<brief description of the production issue>

## Impact
- Users affected: <count/scope>
- Business impact: <description>
- Started: <timestamp>

## Root Cause (preliminary)
<initial assessment>

## Fix Approach
<minimal fix description>

## Rollback Plan
<if fix fails, how to rollback>

*Hotfix mode activated at <timestamp>*
```

Save to: `.specs/tasks/hotfix-<num>.md`

### Step 2: Minimal Investigation

Time-box investigation to 15 minutes max:
```bash
# Check recent deployments
git log --oneline -10

# Check error logs
# (use appropriate monitoring tools)

# Check recent changes to affected area
git log --oneline --since="24 hours ago" -- src/affected/path/
```

### Step 3: Implement Fix

Rules for hotfix code:
- **Minimal change** - fix only the immediate problem
- **No refactoring** - save for follow-up
- **No feature additions** - focus on the fix
- **Defensive coding** - add guards, not optimizations

### Step 4: Create Regression Test

Always add a test that:
1. Reproduces the original bug
2. Verifies the fix works
3. Prevents regression

```typescript
describe('HOTFIX: Issue #123', () => {
  it('should not crash when user has null email', () => {
    // This was crashing in production
    const user = { id: 1, email: null };
    expect(() => processUser(user)).not.toThrow();
  });
});
```

### Step 5: Abbreviated Security Check

Run `/security-checker` scoped to changed files. See CLAUDE.md for any stack-specific security scan command.

### Step 6: Fast Track Testing

Run only:
- Tests for affected modules
- The new regression test

Use test commands from CLAUDE.md §2, scoped to changed files. No full suite.

### Step 7: Commit + PR — hand off to `@committer`

**You do NOT run `git commit`, `git push` or `gh pr create` yourself.** Urgência não
suspende o write-gate: commit/push/PR são do `@committer`, com plano de commit e
aprovação explícita (`CLAUDE.md` §2 e §4). Ele só é mais rápido aqui porque o gate de
suite completa é dispensado.

Set the task status to `READY_TO_COMMIT`, then invoke:

```
@committer .specs/tasks/hotfix-<num>.md
```

Tell `@committer` this is a hotfix, so it applies:

| Item | Hotfix |
|------|--------|
| Branch | `hotfix/issue-<num>-<short-desc>` |
| Commit | `fix!: <description>` — pode ser **um só** commit (fix + teste de regressão) |
| Step 2.4 (suite completa) | **WAIVED** — o usuário autoriza explicitamente; registrar o waiver na PR |
| Testes que rodaram | os escopados do Step 6 + o teste de regressão |
| PR | título `HOTFIX: <description>`, label `hotfix,priority-critical`, reviewer do on-call |

Commit body para o `@committer` usar:
```
fix!: <description>

HOTFIX for production issue #<num>

Problem: <what was broken>
Fix: <what was changed>
Impact: <users affected>

Closes #<num>
```

PR body — o template do `@committer` Step 6, na variante bug-fix, mais:
```markdown
## 🚨 HOTFIX
**Severity:** Critical
**Impact:** <description>

## Testing
- [x] Regression test added
- [x] Affected tests pass
- [ ] Full suite — **WAIVED** (hotfix, autorizado pelo usuário)

## Rollback
1. <rollback step 1>
2. <rollback step 2>

**Requires immediate review and merge.**
```

### Post-Hotfix Actions

After hotfix is merged and deployed:

1. **Monitor** - Watch metrics for 30 minutes
2. **Communicate** - Update stakeholders
3. **Document** - Update incident log
4. **Follow-up** - Create follow-up issues for:
   - Proper fix (if hotfix was a band-aid)
   - Root cause analysis
   - Process improvements

### Follow-up Issue Template

```markdown
## Follow-up from Hotfix #<num>

### Original Issue
<link to original issue>

### Hotfix Applied
<link to hotfix PR>

### Technical Debt
- [ ] <proper fix needed>
- [ ] <tests to add>
- [ ] <monitoring to improve>

### Root Cause Analysis
To be completed within 48 hours.

### Prevention
What can we do to prevent similar issues?
```

### Output Format

```
## Hotfix Mode Activated

**Issue:** #<num>
**Severity:** Critical
**Status:** IN_PROGRESS

### Timeline
- Hotfix started: <timestamp>
- Target resolution: <timestamp + 1 hour>

### Progress
- [x] Problem identified
- [x] Fix implemented
- [x] Regression test added
- [ ] Testing complete
- [ ] PR created
- [ ] Deployed

### Escalation
If not resolved in 1 hour, escalate to: <team/person>
```

### Quality Gates (Abbreviated)

Even in hotfix mode, these MUST pass:
- [ ] Regression test exists and passes
- [ ] No new security vulnerabilities
- [ ] Affected tests pass
- [ ] Code compiles/builds

These can be deferred:
- Full test suite
- Coverage threshold
- Documentation updates
- Code review depth
