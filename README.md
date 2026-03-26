# work-setup

Personal dotfiles repo for:

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

This copies the current files from:

- `~/Library/Application Support/Code/User/`
- `~/.zshrc`

## Link Repo Files Back Into Your System

```bash
./scripts/link-into-system.sh
```

The link script:

- backs up existing target files with a timestamp
- creates symlinks from your home directory into this repo

## GitHub Workflow

```bash
git add .
git commit -m "Initial dotfiles setup"
git remote add origin <your-repo-url>
git push -u origin main
```

This repo is already initialized with `main` as the default branch.
