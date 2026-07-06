---
name: push-changes
description: Push committed changes to remote. Never push to main/master.
---
## Push Changes

```bash
BRANCH=$(git branch --show-current)
[[ "$BRANCH" == "main" || "$BRANCH" == "master" ]] && echo "ERROR: cannot push to $BRANCH" && exit 1

git push -u origin "$BRANCH"
```

If rejected (non-fast-forward): `git pull --rebase origin "$BRANCH"` then push again.

Force only on personal branches (no one else pulled): `git push --force-with-lease`.
