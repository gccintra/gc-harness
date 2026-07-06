---
description: Create a spec-driven task file inline. Stops for user approval before any code is written. No agent spawn, no cold start.
---
## Plan

Create a task file with a concrete spec. Stop for approval. Do not write code.

### Input
`$ARGUMENTS` — issue number, description, or feature name.


### Step 1: Understand the request

If `$ARGUMENTS` is a GitHub issue number:
```bash
gh issue view <number>
```
Extract: title, description, acceptance criteria, labels.

Otherwise use `$ARGUMENTS` as the problem statement directly.


### Step 2: Check context docs before investigating code

Read what's relevant to this change:
- **context/API.md** — if adding/changing routes (check existing contracts)
- **context/DATA_MODEL.md** — if touching DB (check existing schema)
- **context/DECISIONS.md** — if the change touches an area with known ADRs
- **context/FOLDER_ARCH.md** — where new files should go

Do NOT read the whole repo. Only read docs relevant to this change.


### Step 3: Minimal code investigation

Read ONLY the files directly relevant to this change.
If scope is unclear, use `cavecrew-investigator` (fork) for a targeted search.

Goal: understand what files need to change, what already exists, what to avoid.


### Step 4: Create task file

Create `.specs/tasks/task-<slug>.md`:

```markdown
# Task: <title>

## Status: PLANNING

## Source
<GitHub Issue #N | Direct request>

## Problema
<1-2 paragraphs, concrete. What breaks? What's missing?>

## Critérios de aceite
Testable behaviors — NOT goals. Write what an automated test or manual check would verify.
- [ ] `GET /api/x` returns 200 with `{ id: string, name: string }` when authenticated
- [ ] `POST /api/x` with missing `name` returns 400 `{ error: "name required" }`
- [ ] Component renders empty state when list is empty
- [ ] Clicking "Delete" calls `DELETE /api/x/:id` and removes item from list

## API changes (se houver)
| Method | Path | Body | Response | Notes |
|--------|------|------|----------|-------|
| POST | `/api/feature` | `{ name: string }` | `{ id, name, created_at }` | requires auth |

## DB changes (se houver)
| Table | Change | Column | Type | Notes |
|-------|--------|--------|------|-------|
| `features` | ADD COLUMN | `priority` | `TEXT DEFAULT 'medium'` | CHECK: low/medium/high |

## Abordagem técnica
<What to change and why. Specific — not "update the service", but "add route in routes/feature.ts, register in index.ts">

## Arquivos a modificar
- `src/routes/feature.ts` — add POST handler
- `src/db/schema.sql` — add priority column
- `src/components/Feature.tsx` — render priority badge

## Escopo de teste
Rodar: src/routes/feature.test.ts, src/components/Feature.test.tsx
NÃO rodar: suite completa

## Riscos / decisões
- <any choice that needs user input before implementing>
```


### Step 5: STOP — present plan and wait

Present the task file content and ask:

> "Plano criado em `.specs/tasks/task-<slug>.md`. Algum ajuste antes de implementar?"

Do NOT implement. Do NOT write any code. Wait for explicit approval.


### Output

```
## Plano criado

Arquivo: .specs/tasks/task-<slug>.md

Resumo:
- API changes: <N endpoints>
- DB changes: <N tables>
- Arquivos: <N>
- Testes novos: <arquivos>
- Decisão pendente: <se houver>

Algum ajuste antes de implementar?
```
