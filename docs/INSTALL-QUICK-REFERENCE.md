# Quick Reference: System-Wide Installation

> **TL;DR**: Run scripts from anywhere on your system, including `/projects` partition

---

## 🚀 One-Command Install

```bash
cd /home/pharoh/Desktop/dev-shortcuts && sudo ./install-system-wide-enhanced.sh && source ~/.bashrc
```

---

## 📋 Installation Methods

### Method 1: Interactive Quick Start
```bash
./quick-start.sh
```
- Guided installation with menu
- Choose between enhanced or PATH-based
- Built-in help and explanations

### Method 2: Enhanced Install (Recommended)
```bash
sudo ./install-system-wide-enhanced.sh
source ~/.bashrc
```
- Installs to `/usr/local/bin`
- Works from ANY directory/partition
- System-wide for all users

### Method 3: PATH-based Install
```bash
./install-system-wide.sh
source ~/.bashrc
```
- Adds dev-shortcuts to PATH
- No sudo required
- Current user only

---

## ✅ Verify Installation

```bash
# Check if scripts are accessible
which update.sh

# Test from home directory
cd ~ && update.sh

# Test from projects partition
cd /projects && system-info.sh

# Test from any random location
cd /tmp && update-cursor.sh
```

---

## 🎯 Available Commands After Install

| Command | Description |
|---------|-------------|
| `update.sh` | Interactive system update menu |
| `system-info.sh` | Display system information |
| `update-cursor.sh` | Update Cursor AppImage |
| `update-vscode.sh` | Update VS Code |
| `ga` or `smart_git_add` | Smart git add (interactive) |
| `githelp` | Git alias cheat sheet |
| `git_commit_with_type.sh` | Interactive commit helper |
| `docker-cleanup.sh` | Docker cleanup utilities |

---

## 🗑️ Uninstall

```bash
sudo ./uninstall-system-wide.sh
```

---

## 🐛 Troubleshooting

### Scripts not found after install
```bash
source ~/.bashrc
# or open new terminal
```

### Check if in PATH
```bash
echo $PATH | grep -E "(usr/local/bin|dev-shortcuts)"
```

### Permission errors
```bash
# Re-run with sudo
sudo ./install-system-wide-enhanced.sh
```

### Scripts work in some terminals but not others
```bash
# Add to all shell configs
echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.zshrc  # if using zsh
source ~/.zshrc
```

---

## 📚 Full Documentation

- **[Complete Install Guide](SYSTEM-WIDE-INSTALL.md)** - Detailed instructions
- **[Main README](README.md)** - Full documentation
- **[Git Setup](git-setup/README.md)** - Git configuration

---

## 💡 Pro Tips

1. **Use Tab Completion**: Type `upda` + `Tab` to autocomplete `update.sh`
2. **Check What's Installed**: `ls /usr/local/bin/*-*.sh`
3. **Update Scripts**: Re-run installer after making changes
4. **Backup First**: Installer creates `.backup` files automatically
5. **Multiple Locations**: Scripts work in `/projects`, `/home`, `/tmp`, everywhere!

---

## 🎓 Usage Examples

```bash
# Update system from projects directory
cd /projects/my-app
update.sh
# Select option 5 for comprehensive update

# Check system info while working
cd /projects/client-site
system-info.sh

# Update Cursor from anywhere
cd /any/directory
update-cursor.sh

# Use git shortcuts in any repo
cd /projects/some-repo
ga              # Smart git add
git st          # git status (alias)
githelp         # Show all aliases
```

---

## 🔄 Quick Commands Cheat Sheet

```bash
# Installation
./quick-start.sh                          # Interactive installer
sudo ./install-system-wide-enhanced.sh    # Direct enhanced install
./install-system-wide.sh                  # Direct PATH install

# Testing
which update.sh                           # Check if in PATH
update.sh                                 # Run from anywhere
cd /projects && system-info.sh            # Test from projects

# Maintenance
sudo ./install-system-wide-enhanced.sh    # Re-install/update
sudo ./uninstall-system-wide.sh           # Remove installation

# Shell reload
source ~/.bashrc                          # Reload bash config
exec bash                                 # Restart bash shell
```

---

**Need Help?** See [SYSTEM-WIDE-INSTALL.md](SYSTEM-WIDE-INSTALL.md) for detailed troubleshooting