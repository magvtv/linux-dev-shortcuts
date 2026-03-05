# 🚀 START HERE - Dev Shortcuts Quick Guide

Welcome to **ZRW's Dev Shortcuts**! This guide will get you up and running in minutes.

---

## 🎯 What is This?

A collection of powerful automation scripts for:
- **System updates** (`update.sh`)
- **System information** (`system-info.sh`)
- **IDE updates** (`update-cursor.sh`, `update-vscode.sh`)
- **Git shortcuts** (smart add, commit helpers, aliases)
- **Docker management** (cleanup utilities)
- **And much more!**

---

## ⚡ Quick Install (3 Steps)

### Step 1: Navigate to the directory
```bash
cd /home/pharoh/Desktop/dev-shortcuts
```

### Step 2: Run the installer
```bash
sudo ./install-system-wide-enhanced.sh
```

### Step 3: Reload your shell
```bash
source ~/.bashrc
```

**That's it!** Your scripts are now available everywhere! 🎉

---

## ✅ Verify It Works

Try running scripts from any directory:

```bash
# Go to any directory
cd /projects  # or cd ~ or cd /tmp

# Run a script
update.sh
```

If you see the update menu, **you're all set!** ✓

---

## 🎓 What Can You Do Now?

### Run Scripts from Anywhere

```bash
cd /projects/my-app      # Your project directory
update.sh                # Works!

cd /tmp                  # Random directory
system-info.sh           # Works!

cd ~                     # Home directory
update-cursor.sh         # Works!
```

### Use Git Shortcuts

```bash
cd /projects/my-repo
ga                       # Smart git add (interactive)
git st                   # Git status (alias)
githelp                  # Show all git shortcuts
```

### Available Commands

| Command | What It Does |
|---------|-------------|
| `update.sh` | Interactive system update menu |
| `system-info.sh` | Display system information |
| `update-cursor.sh` | Update Cursor IDE |
| `update-vscode.sh` | Update VS Code |
| `ga` | Smart git add with file picker |
| `githelp` | Show git alias cheat sheet |

---

## 📚 Need More Help?

### For Quick Reference
→ **[INSTALL-QUICK-REFERENCE.md](INSTALL-QUICK-REFERENCE.md)** - One-page cheat sheet

### For Step-by-Step Installation
→ **[INSTALLATION-CHECKLIST.md](INSTALLATION-CHECKLIST.md)** - Detailed checklist

### For Complete Documentation
→ **[SYSTEM-WIDE-INSTALL.md](SYSTEM-WIDE-INSTALL.md)** - Full installation guide

### For Interactive Installation
```bash
./quick-start.sh
```
This gives you a menu to choose installation methods with explanations.

### To See All Documentation
→ **[DOCS-INDEX.md](DOCS-INDEX.md)** - Complete documentation index

---

## 🤔 Common Questions

### Where are the scripts installed?
The enhanced installer creates wrappers in `/usr/local/bin` that point to your dev-shortcuts directory.

### Do I need sudo?
Yes, for the enhanced installation (recommended). Use `./install-system-wide.sh` if you want a no-sudo option.

### Will this work on all partitions?
Yes! That's the whole point. Run your scripts from `/projects`, `/home`, `/tmp`, anywhere!

### What if I have problems?
1. Check **[INSTALLATION-CHECKLIST.md](INSTALLATION-CHECKLIST.md)** - Troubleshooting section
2. Make sure you ran `source ~/.bashrc`
3. Try opening a new terminal window
4. Re-run the installer: `sudo ./install-system-wide-enhanced.sh`

### How do I uninstall?
```bash
sudo ./uninstall-system-wide.sh
```

### Can I add my own scripts?
Yes! Add `.sh` files to any subdirectory, then re-run the installer.

---

## 🎯 Next Steps

1. ✅ **Install** (if you haven't): `sudo ./install-system-wide-enhanced.sh`
2. ✅ **Test**: Run `cd /tmp && update.sh`
3. ✅ **Explore**: Try `system-info.sh`, `ga`, and other commands
4. ✅ **Customize**: Add your own scripts to the collection
5. ✅ **Bookmark**: Keep **[INSTALL-QUICK-REFERENCE.md](INSTALL-QUICK-REFERENCE.md)** handy

---

## 💡 Pro Tips

- Use **Tab completion**: Type `upda` + `Tab` to autocomplete `update.sh`
- Keep scripts updated: Just re-run the installer after changes
- All scripts work in **any directory** - that's the magic!
- Check `ls /usr/local/bin/*.sh` to see what's installed
- Git shortcuts work in **any git repository**

---

## 🎉 You're Ready!

```bash
# Install
sudo ./install-system-wide-enhanced.sh

# Test
cd /anywhere/you/want
update.sh

# Enjoy! 🚀
```

---

## 📖 Full Documentation

- **[README.md](README.md)** - Complete project overview
- **[SYSTEM-WIDE-INSTALL.md](SYSTEM-WIDE-INSTALL.md)** - Detailed installation guide
- **[INSTALL-QUICK-REFERENCE.md](INSTALL-QUICK-REFERENCE.md)** - Quick reference card
- **[INSTALLATION-CHECKLIST.md](INSTALLATION-CHECKLIST.md)** - Step-by-step checklist
- **[DOCS-INDEX.md](DOCS-INDEX.md)** - Documentation index
- **[IMPLEMENTATION-SUMMARY.md](IMPLEMENTATION-SUMMARY.md)** - Technical details

---

**Questions?** Check the documentation above or run `./quick-start.sh` for an interactive guide!

Happy scripting! 🎊