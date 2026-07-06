# gc-harness

Harness de codificação compartilhado para **Claude Code, Codex e OpenCode**.
Skills, agentes, comandos e regras num só lugar, versionados, reutilizáveis em
qualquer projeto.

## Instalação em um projeto

```bash
git submodule add https://github.com/gccintra/gc-harness.git .agents
./.agents/install.sh
```

O instalador cria somente links de integração:

```text
.claude     -> .agents/runtime/claude
.codex      -> .agents/runtime/codex
.opencode   -> .agents/runtime/opencode
.mcp.json   -> .agents/runtime/claude/mcp.json
```

As skills vivem fisicamente **apenas** em `.agents/skills`. Cada runtime
(`runtime/claude`, `runtime/codex`, `runtime/opencode`) acessa as mesmas skills
pelo link `skills -> ../../skills`. Edita em um lugar, vale para as três
ferramentas.

O harness **não** carrega regras de comportamento (`CLAUDE.md` / `AGENTS.md`) —
essas são **por projeto**. Cada consumidor cria o próprio `CLAUDE.md` (Claude Code)
e/ou `AGENTS.md` (Codex, OpenCode) na raiz, com contexto do código + as regras que
quiser. O `opencode.json` já lê `../AGENTS.md` do consumidor quando existir.

## Atualização

```bash
git -C .agents pull --ff-only
git add .agents
```

O segundo comando fixa no projeto consumidor a revisão registrada do submódulo —
ou seja, cada projeto controla **quando** puxa o update (nada quebra sozinho).

## Customização por projeto

O submódulo aponta para uma revisão fixa por projeto, então há dois caminhos
para divergir sem sujar o harness compartilhado:

- **Branch por projeto:** `git -C .agents checkout -b projeto-x`, customize lá,
  nunca dê merge para `main`.
- **Skill local:** crie um diretório de skill real em `.claude/skills/` que
  **não** seja o link do submódulo (ex.: aponte só skills selecionadas por
  symlink e mantenha as locais como pastas físicas). Fica só naquele projeto.

## Estrutura

```text
gc-harness/
├── WORKFLOW.md            guia humano do fluxo de trabalho
├── install.sh
├── skills/                FONTE ÚNICA das skills (SKILL.md tool-agnostic)
├── agents/                FONTE ÚNICA das personas (frontmatter comum: name/description/mode)
├── commands/              FONTE ÚNICA dos slash commands (+ commands/templates/)
├── context/               referências compartilhadas (ex.: TESTING-POLICY.md)
└── runtime/
    ├── claude/            settings.json · mcp.json · agents→ · commands→ · skills→
    ├── codex/             config.toml · agents/ (*.toml gerados da fonte única)
    └── opencode/          opencode.json · tui.json · agents→ · commands→ · skills→
```

**Fonte única + symlink.** `skills/`, `agents/` e `commands/` (com
`commands/templates/`) moram uma vez na raiz. Claude e OpenCode acessam por
symlink (`runtime/<tool>/{agents,commands,skills} → ../../…`), com frontmatter
comum (`name`, `description`, `mode`) — sem `model`, cada ferramenta usa o
default. O Codex não simlinká agents (formato TOML): `runtime/codex/agents/*.toml`
é **gerado** da mesma fonte única (`developer_instructions` = corpo do agent).
Editar a fonte única vale para as três — regenerar os TOML do Codex quando um
agent mudar.

### Codex — descoberta é diferente

O Codex **não** escaneia `.codex/` como o Claude/OpenCode fazem com skills, e é
global-first. No harness ele funciona assim:

- **Skills:** o Codex lê `.agents/skills/<nome>/SKILL.md` **nativamente** (o
  submódulo já se chama `.agents`). Invoca com `$skill` ou `/skills`. Não usa
  symlink em `.codex`.
- **Agents (personas):** subagents em `.codex/agents/*.toml` (formato TOML,
  campo `developer_instructions`). Invoca com `/agent` ou pedindo em linguagem
  natural. Descobertos por projeto via o link `.codex → runtime/codex`.
- **Prompts (`/prompts:nome`):** **não usados** — são deprecated, globais
  (`~/.codex/prompts`) e não descobertos por projeto. Comandos/workflows viram
  skills; personas viram agents.

## Conteúdo específico do projeto

Cada projeto consumidor mantém na própria raiz o que é dele: `.env`,
`CLAUDE.md` de contexto do código (gerado por `/context-generator`), `context/`
do projeto, histórico e outputs. As skills resolvem esses caminhos a partir da
raiz Git do projeto consumidor.
