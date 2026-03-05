# System-Wide Installation Guide

This guide explains how to install dev-shortcuts scripts so they can be run from anywhere on your system, including the `/projects` partition or any other directory.

## 🚀 Quick Install

### Method 1: Enhanced Installation (Recommended)

This method installs scripts to `/usr/local/bin` making them available system-wide:

```bash
cd /home/pharoh/Desktop/dev-shortcuts
sudo ./install-system-wide-enhanced.sh
```

After installation, reload your shell:

```bash
source ~/.bashrc
```

### Method 2: PATH-based Installation

This method adds the dev-shortcuts directory to your PATH:

```bash
cd /home/pharoh/Desktop/dev-shortcuts
./install-system-wide.sh
source ~/.bashrc
```

## ✨ What Gets Installed

After installation, the following scripts are available system-wide:

### Main Scripts
- **`update.sh`** - Interactive system update menu with multiple options
- **`system-info.sh`** - Comprehensive system information display
- **`update-cursor.sh`** - Update Cursor AppImage to latest version
- **`update-vscode.sh`** - Update Visual Studio Code
- **`update-original.sh`** - Original simple update script

### Git Shortcuts
- **`git_commit_with_type.sh`** - Interactive git commit helper
- **`smart_git_add`** or **`ga`** - Smart git add with interactive file selection
- **`githelp`** - Display git alias cheat sheet

### Docker Scripts
- **`docker-cleanup.sh`** - Clean up Docker containers and images

### Hardware Automation
- **`connect-earbuds.sh`** - Bluetooth earbud connection helper

## 📍 Usage from Anywhere

Once installed, you can run these scripts from ANY directory on your system:

```bash
# From your home directory
cd ~
update.sh

# From the projects partition
cd /projects/my-awesome-project
system-info.sh

# From any random directory
cd /tmp
update-cursor.sh
```

## 🔧 How It Works

### Enhanced Installation (`install-system-wide-enhanced.sh`)

1. **Creates wrapper scripts** in `/usr/local/bin/` that point to the actual scripts
2. **Adds dev-shortcuts to PATH** in your `.bashrc` and `.profile`
3. **Configures git aliases** from the git-setup directory
4. **Sets up smart_git_add** function and aliases
5. **Makes all scripts executable**

Benefits:
- ✅ Scripts work from any partition
- ✅ Scripts work in any directory
- ✅ Works for all users (if installed with sudo)
- ✅ No need to remember script locations
- ✅ Tab completion works

### PATH-based Installation (`install-system-wide.sh`)

1. **Adds dev-shortcuts directory to PATH**
2. **Creates symlinks** in `bin/` directory
3. **Configures shell integration**

## 🎯 Common Use Cases

### Running Updates from Projects Partition

```bash
cd /projects/my-web-app
update.sh
# Select option 5 for comprehensive update
```

### Checking System Info While Working

```bash
cd /projects/client-project
system-info.sh
```

### Updating IDEs from Anywhere

```bash
# Update Cursor
update-cursor.sh

# Update VS Code
update-vscode.sh
```

### Using Git Shortcuts

```bash
cd /projects/my-repo
ga                    # Smart git add (interactive)
git st               # git status (alias)
git timeline         # git log with graph
githelp              # Show all git aliases
```

## 🔄 Updating the Scripts

After making changes to scripts in the dev-shortcuts directory:

### If using Enhanced Installation:
```bash
cd /home/pharoh/Desktop/dev-shortcuts
sudo ./install-system-wide-enhanced.sh
```

The wrapper scripts will automatically use the updated versions.

### If using PATH-based Installation:
No action needed - scripts are used directly from the dev-shortcuts directory.

## 🗑️ Uninstalling

### Remove Enhanced Installation:

```bash
# Remove wrappers from /usr/local/bin
sudo rm /usr/local/bin/update.sh
sudo rm /usr/local/bin/system-info.sh
sudo rm /usr/local/bin/update-cursor.sh
sudo rm /usr/local/bin/update-vscode.sh
sudo rm /usr/local/bin/update-original.sh
sudo rm /usr/local/bin/git_commit_with_type.sh
# ... and any other installed scripts

# Or remove all at once:
cd /usr/local/bin
sudo rm -f $(ls | grep -E '(update|system-info|git_commit)')
```

### Remove PATH entries:

Edit `~/.bashrc` and `~/.profile` and remove lines between:
```bash
# Added by dev-shortcuts install-system-wide-enhanced.sh
# ... and the export PATH line
```

Then reload:
```bash
source ~/.bashrc
```

## 🐛 Troubleshooting

### Scripts not found after installation

```bash
# Reload shell configuration
source ~/.bashrc

# Check if /usr/local/bin is in PATH
echo $PATH | grep /usr/local/bin

# Verify script exists
ls -la /usr/local/bin/update.sh
```

### Permission denied errors

Make sure scripts are executable:
```bash
chmod +x /home/pharoh/Desktop/dev-shortcuts/**/*.sh
```

Or run the install script with sudo:
```bash
sudo ./install-system-wide-enhanced.sh
```

### Scripts work in some terminals but not others

Different terminals may use different shell configurations:
- Bash uses `~/.bashrc`
- Zsh uses `~/.zshrc`
- Login shells use `~/.profile`

Add the PATH export to all relevant config files.

## 📋 Verification

Test that installation worked:

```bash
# Test from home directory
cd ~
which update.sh
# Should output: /usr/local/bin/update.sh

# Test from projects partition
cd /projects
update.sh --help
# Should run without errors

# Test system-info
system-info.sh
# Should display system information
```

## 🌟 Advanced: System-wide for All Users

To make scripts available for ALL users on the system:

```bash
# Install to /usr/local/bin (already done by enhanced installer)
sudo ./install-system-wide-enhanced.sh

# For each user that needs access, add to their .bashrc:
echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
```

Note: `/usr/local/bin` is typically already in PATH for all users.

## 📝 Notes

- Scripts installed to `/usr/local/bin` take precedence over scripts in your home directory
- The enhanced installer creates wrapper scripts that always point to the latest version in dev-shortcuts
- Git integration requires git to be installed and configured
- Some scripts may require sudo privileges (like update.sh for system updates)

## 🔗 See Also

- [Main README](README.md) - Full documentation
- [Git Setup Guide](git-setup/README.md) - Git configuration details
- [Maintenance Scripts](maintenance-scripts/) - Update script documentation