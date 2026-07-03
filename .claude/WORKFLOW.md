# Como funciona o harness — Guia do Dev

> Doc para **humanos**: o que é o harness de IA deste repo e como usá-lo no
> dia a dia. (Instruções voltadas à própria IA ficam em `CLAUDE.md` e nos
> arquivos de `.claude/`.)

## A ideia

Harness **lean, sem orquestradores**. Você conversa com o Opus direto na
thread principal — ele tem contexto completo, lê o código uma vez, age e
corrige. Não há cold start nem briefing repetido a cada passo.

Trabalho pesado é feito **inline** via _skills_ (comandos pontuais). _Agentes_
separados (cold start próprio) só entram quando há motivo real: isolamento de
uma ação irreversível, ferramentas muito diferentes, ou tarefa longa cujo
output não deve poluir o contexto.

## Fluxo típico de uma feature

```
1. /plan <issue ou descrição>   → cria task file em .claude/work/tasks/, PARA p/ aprovação
2. (aprovado) implementa        → Opus inline, ou /implement <task-file>
3. /test-runner                 → roda só os arquivos tocados
4. /code-review                 → review do diff
5. @committer <task-file>       → commit + PR (manual, único passo irreversível)
```

Cada passo é **opcional**. Bug simples: fala o problema e deixa o Opus ir
direto ao código. Feature grande: começa pelo `/plan`.

## Agentes (cold start — use só quando precisa isolar)

| Agente | Quando | Por que isolado |
|--------|--------|-----------------|
| `@committer` | Commit / push / PR | Ação irreversível, sempre manual e com aprovação |
| `@designer` | Workflow Figma | Ferramentas completamente diferentes |
| `@context-generator` | Criar/atualizar CLAUDE.md + context/ | Tarefa longa, output fora do contexto |
| `@product-manager` | Descoberta de produto (o quê/por quê) | Discussão dedicada antes do código |
| `@tech-lead` | Discussão de arquitetura (o como) | Gera docs, não mexe em código |

Para buscas largas em repo grande dá pra delegar a `cavecrew-investigator`
(read-only) — output comprimido, economiza contexto.

## Skills (inline — sem cold start)

| Skill | O que faz |
|-------|-----------|
| `/plan` | Cria task file e para para aprovação |
| `/implement` | Implementa a partir do task file ou da conversa |
| `/test-runner` | Roda testes **escopados** (só arquivos do task) |
| `/test-generator` | Gera testes para código novo |
| `/code-review` | Review do diff atual |
| `/security-checker` | Checagem de vulnerabilidades (OWASP) |
| `/commit-changes` | Prepara commits convencionais |
| `/create-pr` · `/pr-description` | Abre PR / gera descrição |
| `/feature-requirement` | Gera documento de requisito de feature |
| `/hotfix-mode` | Modo correção crítica |
| `/lessons-writer` | Registra aprendizado não-óbvio (ver abaixo) |
| `/frontend-design` · `/html-to-figma` · `/figma-implement-design` | Frontend / Figma |
| `/product-manager` · `/tech-lead` · `/context-generator` | Versões skill dos agentes acima |

## Task file (recomendado para features grandes)

Mora em `.claude/work/tasks/<nome>.md`. É a fonte da verdade de um item de
trabalho: problema, critérios de aceite, abordagem, arquivos a tocar, escopo
de teste. Criado pelo `/plan`, lido pelo `@committer`. Docs/specs em
`.claude/work/docs/`, logs em `.claude/work/logs/`.

## Regra de teste

Default: rodar **só os arquivos novos/modificados** — nunca a suite inteira
sem motivo. Suite completa fica para o gate final do `@committer` ou pedido
explícito de regressão. Testes **não rodam no CI** (CI só publica MkDocs) —
rode local antes do PR. Triagem completa do que testar vs não testar:
`TESTING-POLICY.md` (raiz do repo).

## Quando chamar `/lessons-writer`

Só quando algo **genuinamente não-óbvio** apareceu: limitação da stack, gotcha
de ambiente, decisão arquitetural e o porquê, ou um padrão que você corrigiu.
Não chamar para boa prática genérica que qualquer sênior já sabe.
