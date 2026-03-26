#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_DIR="$HOME/Library/Application Support/Code/User"

mkdir -p "$ROOT_DIR/vscode" "$ROOT_DIR/zsh"

cp "$HOME/.zshrc" "$ROOT_DIR/zsh/.zshrc"
cp "$VSCODE_DIR/settings.json" "$ROOT_DIR/vscode/settings.json"

if [[ -f "$VSCODE_DIR/keybindings.json" ]]; then
  cp "$VSCODE_DIR/keybindings.json" "$ROOT_DIR/vscode/keybindings.json"
else
  printf '[]\n' > "$ROOT_DIR/vscode/keybindings.json"
fi

if command -v code >/dev/null 2>&1; then
  code --list-extensions 2>/dev/null > "$ROOT_DIR/vscode/extensions.txt" || true
fi

echo "Repo files refreshed from this machine."

