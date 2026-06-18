---
description: Single entry point for all project context. Creates/updates CLAUDE.md (§1-§10) and specialized files (DESIGN.md, API.md, DATA_MODEL.md, DECISIONS.md, WORKFLOWS.md). Replaces project-setup. Re-invocable.
---

Lê as instruções em `.claude/agents/context-generator.md` e executa o workflow de geração de contexto.

**Detecta automaticamente:** quais arquivos existem, quais gaps há, quais são relevantes para o stack.

**Flags:**
- `--map` — mostra status de todos os arquivos (não cria nada)
- `--all` — CLAUDE.md + todos os arquivos relevantes para o stack
- `--core` — apenas CLAUDE.md §1-§10 (equivalente ao antigo `/project-setup`)
- `--design` — apenas DESIGN.md
- `--api` — apenas API.md
- `--data` — apenas DATA_MODEL.md
- `--decisions` — apenas DECISIONS.md
- `--workflows` — apenas WORKFLOWS.md
- `--update` — atualiza gaps nos arquivos existentes
- `--quick` — auto-detect, perguntas mínimas, aprovação única

Sem flags: modo interativo — mostra status, usuário escolhe o que criar.

Após criação, atualiza CLAUDE.md §11 com índice dos arquivos de contexto especializados.
