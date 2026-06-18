---
model: sonnet
description: Receives an issue or prompt, creates a detailed implementation plan in .claude/work/tasks/<id>.md, and STOPS. Does NOT delegate to any executor. For standalone planning without execution.
---
**Carrega o agente `plan-maker`** (`.claude/agents/plan-maker.md`). Cria plano detalhado e para — sem implementar.

$ARGUMENTS
