#!/usr/bin/env bash

set -euo pipefail

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
BACKUP_ROOT="$HOME/.work-setup-backups"

create_snapshot_dir() {
  local suffix="$1"
  local stamp

  stamp="$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP_ROOT"
  mktemp -d "$BACKUP_ROOT/${stamp}${suffix}.XXXXXX"
}

target_exists() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]]
}

target_path_for() {
  local relative_path="$1"

  case "$relative_path" in
    .zshrc)
      printf '%s\n' "$HOME/.zshrc"
      ;;
    vscode/settings.json)
      printf '%s\n' "$VSCODE_DIR/settings.json"
      ;;
    vscode/keybindings.json)
      printf '%s\n' "$VSCODE_DIR/keybindings.json"
      ;;
    *)
      echo "Unknown backup entry: $relative_path" >&2
      exit 1
      ;;
  esac
}

record_current_state() {
  local target="$1"
  local relative_path="$2"
  local snapshot_dir="$3"
  local manifest_file="$4"

  if target_exists "$target"; then
    printf 'present|%s\n' "$relative_path" >> "$manifest_file"
    mkdir -p "$(dirname "$snapshot_dir/$relative_path")"
    mv "$target" "$snapshot_dir/$relative_path"
    return
  fi

  printf 'missing|%s\n' "$relative_path" >> "$manifest_file"
}

backup_current_state_if_needed() {
  local snapshot_dir
  local manifest_file

  snapshot_dir="$(create_snapshot_dir "-before-restore")"
  manifest_file="$snapshot_dir/manifest.txt"
  : > "$manifest_file"

  record_current_state "$HOME/.zshrc" ".zshrc" "$snapshot_dir" "$manifest_file"
  record_current_state "$VSCODE_DIR/settings.json" "vscode/settings.json" "$snapshot_dir" "$manifest_file"
  record_current_state "$VSCODE_DIR/keybindings.json" "vscode/keybindings.json" "$snapshot_dir" "$manifest_file"

  echo "Current state recorded in $snapshot_dir"
}

restore_entry() {
  local selected_backup="$1"
  local state="$2"
  local relative_path="$3"
  local target

  target="$(target_path_for "$relative_path")"
  mkdir -p "$(dirname "$target")"
  rm -f "$target"

  if [[ "$state" == "present" ]]; then
    cp -P "$selected_backup/$relative_path" "$target"
  fi
}

if [[ ! -d "$BACKUP_ROOT" ]]; then
  echo "No backups found in $BACKUP_ROOT"
  exit 1
fi

backup_paths=()
backup_names=()

while IFS= read -r backup_path; do
  backup_paths+=("$backup_path")
  backup_names+=("$(basename "$backup_path")")
done < <(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort -r)

if [[ ${#backup_paths[@]} -eq 0 ]]; then
  echo "No backups found in $BACKUP_ROOT"
  exit 1
fi

echo "Available backups:"
PS3="Choose a backup to restore (or press Ctrl+C to cancel): "

select backup_name in "${backup_names[@]}"; do
  if [[ -n "$backup_name" ]]; then
    selected_backup="${backup_paths[$((REPLY - 1))]}"
    break
  fi

  echo "Invalid selection."
done

manifest_file="$selected_backup/manifest.txt"

if [[ ! -f "$manifest_file" ]]; then
  echo "Selected backup is missing manifest.txt: $selected_backup"
  exit 1
fi

backup_current_state_if_needed

while IFS='|' read -r state relative_path; do
  restore_entry "$selected_backup" "$state" "$relative_path"
done < "$manifest_file"

echo "Restored backup: $(basename "$selected_backup")"
echo "Restart your shell or run: source ~/.zshrc"
