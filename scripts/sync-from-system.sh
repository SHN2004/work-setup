#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_DIR="$HOME/Library/Application Support/Code/User"

copy_if_needed() {
  local source="$1"
  local destination="$2"

  if [[ -e "$source" && -e "$destination" && "$source" -ef "$destination" ]]; then
    return
  fi

  cp "$source" "$destination"
}

mkdir -p "$ROOT_DIR/vscode" "$ROOT_DIR/zsh"

copy_if_needed "$HOME/.zshrc" "$ROOT_DIR/zsh/.zshrc"
copy_if_needed "$VSCODE_DIR/settings.json" "$ROOT_DIR/vscode/settings.json"

if [[ -f "$VSCODE_DIR/keybindings.json" ]]; then
  copy_if_needed "$VSCODE_DIR/keybindings.json" "$ROOT_DIR/vscode/keybindings.json"
else
  printf '[]\n' > "$ROOT_DIR/vscode/keybindings.json"
fi

if command -v code >/dev/null 2>&1; then
  code --list-extensions 2>/dev/null > "$ROOT_DIR/vscode/extensions.txt" || true
fi

echo "Repo files refreshed from this machine."
