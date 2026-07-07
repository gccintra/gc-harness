---
description: Single entry point for all project context. Creates/updates CLAUDE.md and all specialized context files. Re-invocable — detects existing files and fills only gaps.
---

Lê as instruções em `.claude/agents/context-generator.md` e executa o workflow de geração de contexto.

**Detecta automaticamente:** quais arquivos existem, quais gaps há, quais são relevantes para o stack.

**Flags:**
- `--map` — mostra status de todos os arquivos (não cria nada)
- `--all` — CLAUDE.md + todos os arquivos relevantes para o stack
- `--core` — apenas CLAUDE.md
- `--arch` — apenas context/ARCH.md
- `--folder` — apenas context/FOLDER_ARCH.md
- `--api` — apenas context/API.md
- `--data` — apenas context/DATA_MODEL.md
- `--design` — apenas context/DESIGN.md
- `--decisions` — apenas context/DECISIONS.md
- `--gotchas` — apenas context/GOTCHAS.md
- `--env` — apenas context/ENVIRONMENT.md
- `--testing` — apenas context/TESTING-POLICY.md
- `--update` — atualiza gaps nos arquivos existentes
- `--quick` — auto-detect, perguntas mínimas, aprovação única

Sem flags: modo interativo — mostra status, usuário escolhe o que criar.

Após criação, atualiza CLAUDE.md §11 com índice dos arquivos de contexto criados.
