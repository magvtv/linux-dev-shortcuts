# Git Timeline & Branch Visualization Setup

## Overview

This package contains customized git aliases and scripts for visualizing branch relationships, detecting merge conflicts, and managing git repositories more effectively.

## Files Included

- `.gitconfig` - Git configuration with custom aliases
- `git-alias-help.sh` - Script to display git alias cheat sheet
- `bashrc-git-portion.txt` - Bash configuration for auto-displaying aliases
- `test-git-help.sh` - Demo script showing how the auto-display works

## Quick Installation

Run the automated setup script:

```bash
bash setup-git-aliases.sh
```

This will:
1. ✅ Install git aliases to `~/.gitconfig`
2. ✅ Copy helper scripts to `~/bin/`
3. ✅ Configure bash integration in `~/.bashrc`
4. ✅ Set up auto-display for git directories

Then activate the changes:

```bash
source ~/.bashrc
```

## Manual Installation (if needed)

If you prefer manual setup:

1. **Git Config**: `cp .gitconfig ~/.gitconfig` (or merge manually)
2. **Helper Script**: `cp git-alias-help.sh ~/bin/ && chmod +x ~/bin/git-alias-help.sh`
3. **Bash Integration**: `cat bashrc-git-portion.txt >> ~/.bashrc`
4. **Reload**: `source ~/.bashrc`

## Key Git Commands

### Branch Visualization
- `git timeline` - Shows a full timeline graph of all branches
- `git branches` or `git br` - Shows branch overview with dates
- `git relations` - Shows ASCII branch relationship visualization

### Branch Comparison
- `git compare` - Interactive comparison between branches
- `git ahead-behind` - Shows commits ahead/behind all remotes
- `git merge-preview` - Preview merge changes and conflicts
- `git fork-point` - Find where branches diverged

### Quick Reference
You can always display the git alias cheat sheet by typing:
```
githelp
```

## Automatic Display

The git alias cheat sheet will automatically display whenever you enter a git repository in:
- `~/Desktop/` directories
- `/projects/` directories

The display shows once per directory to avoid spam. You can manually trigger it anytime with:

```bash
githelp
```

## Configuration Locations

After setup, these files are used:
- `~/.gitconfig` - Your git aliases (main configuration)
- `~/bin/git-alias-help.sh` - The helper script (auto-triggered on cd)
- `~/.bashrc` - Bash integration (auto-display on directory change)
