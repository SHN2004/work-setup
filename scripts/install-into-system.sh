#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
BACKUP_ROOT="$HOME/.work-setup-backups"

create_snapshot_dir() {
  local stamp

  stamp="$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_ROOT"
  mktemp -d "$BACKUP_ROOT/${stamp}.XXXXXX"
}

target_exists() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]]
}

record_backup() {
  local target="$1"
  local relative_path="$2"

  if target_exists "$target"; then
    printf 'present|%s\n' "$relative_path" >> "$MANIFEST_FILE"
    mkdir -p "$(dirname "$BACKUP_DIR/$relative_path")"
    mv "$target" "$BACKUP_DIR/$relative_path"
    return
  fi

  printf 'missing|%s\n' "$relative_path" >> "$MANIFEST_FILE"
}

stage_source() {
  local source="$1"
  local relative_path="$2"
  local staged_path="$STAGING_DIR/$relative_path"

  mkdir -p "$(dirname "$staged_path")"
  cp "$source" "$staged_path"
}

mkdir -p "$VSCODE_DIR"

BACKUP_DIR="$(create_snapshot_dir)"
MANIFEST_FILE="$BACKUP_DIR/manifest.txt"
STAGING_DIR="$BACKUP_DIR/staged"
: > "$MANIFEST_FILE"

stage_source "$ROOT_DIR/zsh/.zshrc" ".zshrc"
stage_source "$ROOT_DIR/vscode/settings.json" "vscode/settings.json"
stage_source "$ROOT_DIR/vscode/keybindings.json" "vscode/keybindings.json"

record_backup "$HOME/.zshrc" ".zshrc"
record_backup "$VSCODE_DIR/settings.json" "vscode/settings.json"
record_backup "$VSCODE_DIR/keybindings.json" "vscode/keybindings.json"

echo "Previous state recorded in $BACKUP_DIR"

cp "$STAGING_DIR/.zshrc" "$HOME/.zshrc"
cp "$STAGING_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"
cp "$STAGING_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"

echo "Config files installed as copies."
echo "Restart your shell or run: source ~/.zshrc"
