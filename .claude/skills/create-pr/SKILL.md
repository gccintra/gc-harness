---
name: create-pr
description: Creates well-documented Pull Requests on GitHub with proper linking and formatting.
---
## Create PR Skill

Create comprehensive Pull Requests that facilitate efficient code review and maintain project quality.

### Prerequisites
- GitHub CLI (`gh`) authenticated
- Branch pushed to remote
- All CI checks passing (or acceptable)

### Step 1: Gather Context

```bash
BRANCH=$(git branch --show-current)
git log main..HEAD --oneline
git diff --stat main..HEAD
echo $BRANCH | grep -oE '[0-9]+' | head -1
```

### Step 2: Generate PR Description

```markdown
## Summary
<!-- 1-2 sentence description of what this PR does -->

## Changes Made
- <!-- Bullet points of significant changes -->
- <!-- Include new dependencies if any -->
- <!-- Mention breaking changes if any -->

## Type
<!-- Feature | Bug Fix | Refactor | Docs | Tests | Maintenance -->

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Security
- [ ] Security scan passed
- [ ] No sensitive data exposed
- [ ] Auth/permissions verified

## Screenshots
<!-- If UI changes, include before/after -->

## Related
Closes #<issue-number>

## Checklist
- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] No console.log/debug statements
```

### Step 3: Create PR via GitHub CLI

```bash
gh pr create \
  --title "feat(auth): add JWT token refresh endpoint" \
  --body "$(cat <<'EOF'
## Summary
Implement automatic token refresh to improve user session handling.

## Changes Made
- Add /api/auth/refresh endpoint
- Implement token rotation for security
- Add refresh token to HTTP-only cookie

## Type
Feature

## Testing
- [x] Unit tests added
- [x] Integration tests added

## Security
- [x] Security scan passed
- [x] No sensitive data exposed

## Related
Closes #42

## Checklist
- [x] Code follows project conventions
- [x] Self-review completed
- [x] No debug statements
EOF
)" \
  --base main \
  --head "$(git branch --show-current)"
```

### Step 4: Add Labels and Assignees

```bash
gh pr edit --add-label "feature,needs-review"
gh pr edit --add-reviewer "@team/backend"
```

### Step 5: Verify PR

```bash
gh pr view --json number,url
gh pr checks
```

### PR Title Conventions

Follow same format as commit messages:
```
<type>(<scope>): <short description>
```

| Type | Example |
|------|---------|
| `feat` | `feat(auth): add password reset flow` |
| `fix` | `fix(api): handle null user gracefully` |
| `refactor` | `refactor(db): optimize query performance` |
| `docs` | `docs(readme): update installation guide` |

### PR Labels

- `feature`, `bug`, `enhancement`, `documentation`
- `needs-review`, `work-in-progress`, `ready-to-merge`
- `breaking-change`, `security`, `performance`
- Priority: `priority-high`, `priority-medium`, `priority-low`

### Output Format

```
## Pull Request Created

**PR Number:** #45
**Title:** feat(auth): add JWT token refresh endpoint
**URL:** https://github.com/owner/repo/pull/45

**Branch:** feat/issue-42-add-auth-refresh → main
**Linked Issue:** #42
**Labels:** feature, needs-review

**Next Steps:**
1. Wait for CI to complete
2. Request review from team
3. Address any feedback
4. Merge when approved
```

### Draft PRs

For work-in-progress:
```bash
gh pr create --draft \
  --title "WIP: feat(auth): add token refresh" \
  --body "Work in progress - do not review yet"
```

Convert to ready when complete:
```bash
gh pr ready
```

### Error Handling

#### PR Already Exists
```bash
gh pr edit <number> --body "updated description"
```

#### Base Branch Conflicts
```bash
git fetch origin main
git rebase origin/main
# Resolve conflicts
git push --force-with-lease
```
