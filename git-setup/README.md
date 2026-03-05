# Git Timeline & Branch Visualization Setup

## Overview

This package contains customized git aliases and scripts for visualizing branch relationships, detecting merge conflicts, and managing git repositories more effectively.

## Files Included

- `.gitconfig` - Git configuration with custom aliases
- `git-alias-help.sh` - Script to display git alias cheat sheet
- `bashrc-git-portion.txt` - Bash configuration for auto-displaying aliases
- `test-git-help.sh` - Demo script showing how the auto-display works

## Installation Instructions

### 1. Git Config Setup

Copy the `.gitconfig` file to your home directory:

```bash
cp .gitconfig ~/.gitconfig
```

Or if you already have a .gitconfig, you can merge the aliases section manually.

### 2. Git Alias Help Script

Create a bin directory if it doesn't exist and copy the script:

```bash
mkdir -p ~/bin
cp git-alias-help.sh ~/bin/
chmod +x ~/bin/git-alias-help.sh
```

### 3. Bash Integration

Add the contents of `bashrc-git-portion.txt` to your `~/.bashrc` file:

```bash
cat bashrc-git-portion.txt >> ~/.bashrc
```

### 4. Activate Changes

Either restart your terminal or run:

```bash
source ~/.bashrc
```

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
The git alias cheat sheet will automatically display whenever you enter a git repository in your Desktop/ directory, but only once per directory to avoid spam.

## Notes
- The branch comparison tools work with all git repositories
- Automatic display only activates in Desktop/ directories
- You can change the target directory by editing the `show_git_aliases_in_desktop()` function in your .bashrc
