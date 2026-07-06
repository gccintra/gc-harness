---
name: lessons-writer
description: Appends a new entry to CLAUDE.md § Lessons Learned and context/GOTCHAS.md. Call only when something non-obvious was discovered.
---
## Lessons Writer

Only call for genuinely non-obvious findings — not generic best practices.

### When to call
- Bug fix revealed a hidden constraint (stack limitation, runtime behavior, dependency quirk, etc.)
- New project-specific rule emerged that would surprise a senior engineer
- User corrected a pattern — document why

### What NOT to write
- Generic best practices ("always validate input")
- Things already in CLAUDE.md or context/GOTCHAS.md
- Anything obvious to a senior engineer

---

### Step 1: Write to CLAUDE.md

Read CLAUDE.md, find `## Lessons Learned`, append:

```markdown
### <YYYY-MM-DD> - <Category>: <Title>
**Context:** <when this applies>
**Discovery:** <what was learned>
**Solution:** <how to handle it>
**Source:** <Issue #num | User correction | Code review>
```

NEVER overwrite or delete existing entries.

---

### Step 2: Write to context/GOTCHAS.md (if it's a pitfall)

If the learning is a "gotcha" — something that would cause a silent bug or crash if not known — also add a quick entry to `context/GOTCHAS.md` under the relevant section.

```markdown
### <Title>
Short description of what goes wrong.

```typescript
// BROKEN
badPattern();

// CORRECT  
goodPattern();
```
```

If the learning is a design decision (not a pitfall), skip context/GOTCHAS.md — it goes only in CLAUDE.md.

---

### Step 3: Report

```
Added to CLAUDE.md § Lessons Learned: <title>
Added to context/GOTCHAS.md § <Section>: <title>  (or: skipped — design decision, not pitfall)
```
