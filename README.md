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

## Install Repo Files Into Your System

Clone the repository first:

```bash
git clone https://github.com/SHN2004/work-setup.git
cd work-setup
```

Then run:

```bash
./scripts/install-into-system.sh
```

The install script:

- backs up existing target files with a timestamp
- stores each backup snapshot in `~/.work-setup-backups/<date-time>/`
- copies the repo files into your home directory and VS Code config folder
- replaces existing symlinks with normal files, so the setup keeps working even if you move or remove this repo

If needed, reload your shell:

```bash
source ~/.zshrc
```

## Sync From Your System Into The Repo

```bash
./scripts/sync-from-system.sh
```

This copies the current local files from:

- `~/Library/Application Support/Code/User/`
- `~/.zshrc`

Use it after changing your editor or shell setup and before committing.
Use `./scripts/install-into-system.sh` after pulling repo updates when you want to refresh the files installed on your machine.

## Restore A Backup

```bash
./scripts/restore-backup.sh
```

The restore script:

- lists the dated snapshots available in `~/.work-setup-backups/`
- lets you choose which snapshot to restore interactively
- backs up your current files into a new dated snapshot before restoring the selected backup

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
