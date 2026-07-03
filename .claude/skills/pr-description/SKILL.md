---
name: pr-description
description: Generate comprehensive PR descriptions with test evidence, coverage reports, and proper formatting.
---
## PR Description Generator

Generate professional pull request descriptions from git history, diffs, and test evidence.

## Steps

### Step 1: Gather Context
```bash
git log --oneline main...HEAD
git diff --stat main...HEAD
git diff main...HEAD
```

### Step 2: Detect PR Type
From branch name:
| Prefix | Type |
|--------|------|
| `feat/` or `feature/` | New Feature |
| `fix/` or `bugfix/` | Bug Fix |
| `refactor/` | Refactoring |
| `docs/` | Documentation |
| `test/` | Tests |
| `chore/` | Maintenance |
| `hotfix/` | Hotfix |

### Step 3: Find Issue Reference
Check branch name and commit messages for: `JIRA-123`, `#456`, `issue-42`

---

## PR Description Template

```markdown
## Summary
[1-2 sentence description of what this PR does and why]

## Changes Made
- [Bullet point for each significant change]
- [Focus on what changed, not how]
- [Include new dependencies if any]
- [Note breaking changes if any]

## Type
[Feature | Bug Fix | Refactor | Docs | Tests | Maintenance | Hotfix]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] E2E tests added/updated
- [ ] Manual testing completed

### Test Evidence
- **Tests:** X passed, 0 failed
- **Coverage:** XX%

## Security
- [x] Security scan passed
- [x] No sensitive data exposed

## Screenshots
<!-- If UI changes, include before/after screenshots -->

## Related
Closes #<issue-number>

## Checklist
- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] No console.log/debug statements
- [ ] Tests passing locally
```

---

## Type-Specific Emphasis

### Feature PRs
```markdown
## Summary
Add JWT token refresh endpoint to improve session handling.

## Changes Made
- Add `/api/auth/refresh` endpoint
- Implement automatic token rotation
- Store refresh token in HTTP-only cookie

## How to Test
1. Login with valid credentials
2. Wait for token to near expiry
3. Observe automatic refresh
```

### Bug Fix PRs
```markdown
## Summary
Fix null pointer exception when user has no profile photo.

## Root Cause
`getUserAvatar()` assumed all users have a profile, returning null
and causing NPE in the template renderer.

## Fix
Added null check with fallback to default avatar.

## Regression Test
Added test case for users without profile photos.
```

### Refactor PRs
```markdown
## Summary
Refactor authentication module for better testability.

## Changes Made
- Extract auth logic into AuthService
- Add dependency injection for token provider
- No behavior changes

## Motivation
Previous implementation was tightly coupled, making unit testing
difficult.
```

---

## Rules

1. **Keep summary to 1-2 sentences** - Get to the point quickly
2. **3-5 bullet points for changes** - Significant changes only
3. **Make it scannable** - Reviewers should understand in 15 seconds
4. **Reference issues** - Always link related issues
5. **No implementation details** - Unless they affect the review
