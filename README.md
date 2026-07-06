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
├── context/               referências compartilhadas (ex.: TESTING-POLICY.md)
└── runtime/
    ├── claude/            settings.json · mcp.json · agents/ · commands/ · skills→../../skills
    ├── codex/             config.toml · skills→../../skills
    └── opencode/          opencode.json · tui.json · agents/ · commands/ · skills→../../skills
```

`agents/` e `commands/` são físicos por ferramenta (o frontmatter difere entre
Claude e OpenCode); só as `skills/` são compartilhadas por link.

## Conteúdo específico do projeto

Cada projeto consumidor mantém na própria raiz o que é dele: `.env`,
`CLAUDE.md` de contexto do código (gerado por `/context-generator`), `context/`
do projeto, histórico e outputs. As skills resolvem esses caminhos a partir da
raiz Git do projeto consumidor.
