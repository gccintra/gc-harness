#!/usr/bin/env bash
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HARNESS_DIR/.." && pwd)"

if [[ "$(basename "$HARNESS_DIR")" != ".agents" ]]; then
  echo "O harness precisa estar clonado como '.agents' na raiz do projeto." >&2
  echo "Encontrado: $HARNESS_DIR" >&2
  exit 1
fi

if [[ ! -d "$PROJECT_DIR/.git" && -z "$(git -C "$PROJECT_DIR" rev-parse --show-toplevel 2>/dev/null)" ]]; then
  echo "Aviso: $PROJECT_DIR não parece ser um repositório Git." >&2
fi

link_path() {
  local target="$1"
  local path="$2"

  if [[ -L "$path" && "$(readlink "$path")" == "$target" ]]; then
    return
  fi

  if [[ -e "$path" || -L "$path" ]]; then
    echo "Não alterado: $path já existe. Mova ou remova esse caminho e execute novamente." >&2
    return 1
  fi

  ln -s "$target" "$path"
}

link_path ".agents/runtime/claude"         "$PROJECT_DIR/.claude"
link_path ".agents/runtime/codex"          "$PROJECT_DIR/.codex"
link_path ".agents/runtime/opencode"       "$PROJECT_DIR/.opencode"
link_path ".agents/runtime/claude/mcp.json" "$PROJECT_DIR/.mcp.json"

if ! git -C "$PROJECT_DIR" check-ignore -q .agents 2>/dev/null; then
  echo
  echo "Falta ignorar o harness no projeto. Rode:"
  echo "  echo '.agents' >> $PROJECT_DIR/.gitignore"
  echo "  echo -e '.claude\\n.codex\\n.opencode\\n.mcp.json' >> $PROJECT_DIR/.gitignore"
fi

echo "Harness instalado em $PROJECT_DIR"
