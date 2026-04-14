# Git Setup — Aliases, Smart Tools & Branch Visualization

## Overview

Customized git aliases, interactive commit/add tools, and branch visualization scripts — installed system-wide so they work in **all** your git projects.

## Files Included

- `.gitconfig` - Git configuration with custom aliases
- `git-alias-help.sh` - Script to display git alias cheat sheet
- `git_smart_commit.sh` - **Interactive commit with conventional commit types** (combines git_commit_with_type.sh + git_ci_enhanced.sh)
- `smart_git_add.sh` - **Smart staging with fuzzy file matching**
- `commit_types_cheatsheet.sh` - Colorful commit type reference
- `commit_shorthand_notes.md` - Detailed commit type descriptions
- `bashrc-git-portion.txt` - Bash configuration for auto-displaying aliases
- `setup-git-aliases.sh` - Automated installer for everything above

## Quick Installation

Run the automated setup script:

```bash
bash setup-git-aliases.sh
```

This will:
1. ✅ Install git aliases to `~/.gitconfig`
2. ✅ Copy all scripts to `~/bin/` (system-wide access)
3. ✅ Configure bash integration in `~/.bashrc`
4. ✅ Set up auto-display for git directories
5. ✅ Register bash aliases: `gitcommit`, `gc`, `ga`, `gitcheat`

Then activate the changes:

```bash
source ~/.bashrc
```

## System-wide Git Smart Tools

After setup, these commands are available **in any git repo**:

| Command | Description |
|---------|-------------|
| `gitcommit` | Full interactive commit: cheatsheet → status → type menu → message → description |
| `gc` | Quick smart commit (skips cheatsheet, goes straight to type menu) |
| `ga <filename>` | Smart add: fuzzy-match files by name with path filtering |
| `gitcheat` | Display the colorful commit types cheatsheet |
| `git ci` | Git alias for quick smart commit |
| `git ac` | Git alias: stage all + quick smart commit |
| `githelp` | Show all git aliases |

### Smart Commit Examples

```bash
gitcommit            # Full flow with cheatsheet
gc                   # Quick: type menu → message → commit
gitcommit -s "msg"   # Skip type selection entirely
gitcommit -q         # Same as gc
```

### Smart Add Examples

```bash
ga HeroSection.tsx              # Find and stage any file named HeroSection.tsx
ga app layout.tsx               # Stage layout.tsx only under paths containing "app"
ga src/components Button.tsx    # Stage Button.tsx under src/components
```

### Context-Sensitive Helpers

The regular `git` command is wrapped to show relevant tips at the right moment:

- **After `git add`** — shows staged file summary + nudge to use `gc` or `gitcommit`
- **Before `git commit`** — shows a compact commit type quick-reference box

These appear automatically — no extra commands needed. All other `git` commands pass through unchanged.

## Manual Installation (if needed)

If you prefer manual setup:

1. **Git Config**: `cp .gitconfig ~/.gitconfig` (or merge manually)
2. **Scripts**: `cp *.sh commit_shorthand_notes.md ~/bin/ && chmod +x ~/bin/*.sh`
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
- `~/bin/git-alias-help.sh` - Alias cheat sheet script
- `~/bin/git_smart_commit.sh` - Smart commit script
- `~/bin/smart_git_add.sh` - Smart add function
- `~/bin/commit_types_cheatsheet.sh` - Commit types cheatsheet
- `~/bin/commit_shorthand_notes.md` - Detailed commit type reference
- `~/.bashrc` - Bash integration (aliases + auto-display on directory change)
