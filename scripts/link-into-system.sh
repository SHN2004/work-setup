#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup_if_needed() {
  local target="$1"

  if [[ -L "$target" ]]; then
    rm "$target"
    return
  fi

  if [[ -e "$target" ]]; then
    mv "$target" "${target}.bak.${STAMP}"
  fi
}

mkdir -p "$VSCODE_DIR"

backup_if_needed "$HOME/.zshrc"
backup_if_needed "$VSCODE_DIR/settings.json"
backup_if_needed "$VSCODE_DIR/keybindings.json"

ln -s "$ROOT_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -s "$ROOT_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"
ln -s "$ROOT_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

echo "Symlinks created."
echo "Restart your shell or run: source ~/.zshrc"

