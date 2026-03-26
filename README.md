# work-setup

This repository stores personal development setup files in Git so they can be versioned, backed up, and reused on another machine.

It currently tracks:

- VS Code user settings
- VS Code keybindings
- VS Code extension list
- Oh My Zsh config via `.zshrc`

## Tracked Files

- `vscode/settings.json`
- `vscode/keybindings.json`
- `vscode/extensions.txt`
- `zsh/.zshrc`

## Sync From This Mac Into The Repo

```bash
./scripts/sync-from-system.sh
```

This copies the current local files from:

- `~/Library/Application Support/Code/User/`
- `~/.zshrc`

Use it after changing your editor or shell setup and before committing.

## Link Repo Files Back Into Your System

```bash
./scripts/link-into-system.sh
```

The link script:

- backs up existing target files with a timestamp
- creates symlinks from your home directory into this repo

Use this when setting up a new machine and you want your live config files to point to the tracked files in this repository.

## New Machine Setup

Clone the repository first:

```bash
git clone <your-repo-url>
cd work-setup
```

Then link the tracked files into your system:

```bash
./scripts/link-into-system.sh
```

If needed, reload your shell:

```bash
source ~/.zshrc
```

## Updating The Repo

```bash
./scripts/sync-from-system.sh
git status
git add .
git commit -m "Update VS Code and zsh settings"
git push
```

## Notes

- This repo is intended to contain configuration, not secrets.
- If you later add API keys or private environment variables, keep them in a separate ignored file instead of `.zshrc`.
