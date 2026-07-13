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
├── skills/                FONTE ÚNICA das skills — inclui cx-* (symlinks p/ commands)
├── agents/                FONTE ÚNICA das personas (name/description/mode)
├── commands/              FONTE ÚNICA dos slash commands (+ commands/templates/), sem `name`
├── context/               referências compartilhadas (ex.: TESTING-POLICY.md)
└── runtime/
    ├── claude/            settings.json · mcp.json · agents→ · commands→ · skills→
    ├── codex/             config.toml (MCP)
    └── opencode/          opencode.json · tui.json · agents→ · commands→ · skills→
```

**Fonte única + symlink.** `skills/`, `agents/` e `commands/` (com
`commands/templates/`) moram uma vez na raiz. Claude e OpenCode acessam por
symlink (`runtime/<tool>/{agents,commands,skills} → ../../…`). Agents usam
frontmatter `name/description/mode`; commands **não** têm `name` (o nome vem do
filename). Sem `model` — cada ferramenta usa o default. Editar a fonte única
vale para todas.

### Codex — sem script, só symlink

O Codex é **global-first** para config/agents (lê de `~/.codex`, não do `.codex`
do projeto), mas lê **skills por projeto** de `.agents/skills` nativamente. Como
o submódulo já se chama `.agents`, isso funciona sem symlink extra. Então:

- **Workflows** (`plan`, `implement`, `hotfix-mode`): expostos ao Codex como
  skills **`cx-*`**, onde cada `skills/cx-<nome>/SKILL.md` é um **symlink** para
  `commands/<nome>.md`. O nome `cx-*` vem do dirname (o command não tem `name`),
  então não colide com o `/plan` nativo nem com o command do Claude. Invoca com
  `$cx-plan`. Um source, zero cópia, zero script.
- **Personas:** também expostas ao Codex como skills `cx-*` (`cx-committer`,
  `cx-designer`, `cx-product-manager`, `cx-tech-lead`, `cx-context-generator`) —
  cada uma é um symlink para `commands/<persona>.md`, que por sua vez carrega
  `agents/<persona>.md`. **Não** existem como *subagents* no Codex: subagents TOML
  são global-first, invisíveis no CLI e insustentáveis sem script. No Codex a
  persona roda na thread principal via skill; em Claude/OpenCode roda como agent.
- **Prompts (`/prompts:nome`):** não usados (deprecated, globais).

Os `cx-*` aparecem também nas listas de skill do Claude/OpenCode (namespaced,
inofensivos) — é o custo de manter tudo num dir compartilhado sem script.

## Conteúdo específico do projeto

Cada projeto consumidor mantém na própria raiz o que é dele: `.env`,
`CLAUDE.md` de contexto do código (gerado por `/context-generator`), `context/`
do projeto, histórico e outputs. As skills resolvem esses caminhos a partir da
raiz Git do projeto consumidor.
