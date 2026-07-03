---
description: Single entry point for all project context. Creates/updates CLAUDE.md and all specialized context files. Re-invocable — detects existing files and fills only gaps.
agent: context-generator
---

Lê as instruções em `.claude/agents/context-generator.md` e executa o workflow de geração de contexto.

**Detecta automaticamente:** quais arquivos existem, quais gaps há, quais são relevantes para o stack.

**Flags:**
- `--map` — mostra status de todos os arquivos (não cria nada)
- `--all` — CLAUDE.md + todos os arquivos relevantes para o stack
- `--core` — apenas CLAUDE.md
- `--arch` — apenas ARCH.md
- `--folder` — apenas FOLDER_ARCH.md
- `--api` — apenas API.md
- `--data` — apenas DATA_MODEL.md
- `--design` — apenas DESIGN.md
- `--decisions` — apenas DECISIONS.md
- `--gotchas` — apenas GOTCHAS.md
- `--env` — apenas ENVIRONMENT.md
- `--update` — atualiza gaps nos arquivos existentes
- `--quick` — auto-detect, perguntas mínimas, aprovação única

Sem flags: modo interativo — mostra status, usuário escolhe o que criar.

Após criação, atualiza CLAUDE.md §11 com índice dos arquivos de contexto criados.
