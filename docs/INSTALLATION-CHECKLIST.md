# Installation Checklist for System-Wide Setup

Use this checklist to ensure proper installation of dev-shortcuts system-wide.

---

## 📋 Pre-Installation Checklist

- [ ] Located the dev-shortcuts directory at `/home/pharoh/Desktop/dev-shortcuts`
- [ ] Terminal is open
- [ ] Have sudo password ready (for enhanced installation)
- [ ] Backed up important shell configurations (optional but recommended)
  ```bash
  cp ~/.bashrc ~/.bashrc.backup-$(date +%Y%m%d)
  cp ~/.profile ~/.profile.backup-$(date +%Y%m%d)
  ```

---

## 🚀 Choose Installation Method

### Option A: Interactive Installation (Recommended for First-Time Users)

- [ ] Run the quick start script
  ```bash
  cd /home/pharoh/Desktop/dev-shortcuts
  ./quick-start.sh
  ```
- [ ] Follow the on-screen menu
- [ ] Choose installation method (Enhanced recommended)
- [ ] Confirm installation when prompted

### Option B: Direct Enhanced Installation (Recommended for Power Users)

- [ ] Navigate to dev-shortcuts directory
  ```bash
  cd /home/pharoh/Desktop/dev-shortcuts
  ```
- [ ] Run enhanced installer with sudo
  ```bash
  sudo ./install-system-wide-enhanced.sh
  ```
- [ ] Wait for installation to complete
- [ ] Review installation summary

### Option C: PATH-based Installation (No Sudo Required)

- [ ] Navigate to dev-shortcuts directory
  ```bash
  cd /home/pharoh/Desktop/dev-shortcuts
  ```
- [ ] Run standard installer
  ```bash
  ./install-system-wide.sh
  ```
- [ ] Wait for installation to complete

---

## ✅ Post-Installation Steps

- [ ] Reload shell configuration
  ```bash
  source ~/.bashrc
  ```
  **OR** open a new terminal window

- [ ] Verify installation was successful
  ```bash
  which update.sh
  ```
  Should output: `/usr/local/bin/update.sh` (enhanced) or path to dev-shortcuts (PATH-based)

---

## 🧪 Testing & Verification

### Basic Tests

- [ ] Test `update.sh` from home directory
  ```bash
  cd ~
  update.sh
  ```
  Expected: Menu appears

- [ ] Test `system-info.sh` from any directory
  ```bash
  cd /tmp
  system-info.sh
  ```
  Expected: System information displays

- [ ] Test from projects partition (if exists)
  ```bash
  cd /projects
  update-cursor.sh --help 2>/dev/null || update-cursor.sh
  ```
  Expected: Script runs without "command not found"

### Git Integration Tests (if applicable)

- [ ] Test smart_git_add function
  ```bash
  type smart_git_add
  ```
  Expected: Function definition shown

- [ ] Test `ga` alias
  ```bash
  alias ga
  ```
  Expected: `alias ga='smart_git_add'`

- [ ] Test githelp (if in a git repo)
  ```bash
  githelp 2>/dev/null || echo "Git help available"
  ```

### Advanced Tests

- [ ] Test tab completion
  ```bash
  # Type: upda<TAB>
  # Should autocomplete to: update
  ```

- [ ] Verify all main scripts are accessible
  ```bash
  which update.sh && \
  which system-info.sh && \
  which update-cursor.sh && \
  which update-vscode.sh && \
  echo "All main scripts found!"
  ```

---

## 🎯 Functional Testing

- [ ] Run a system update
  ```bash
  update.sh
  # Select option 1 (Update)
  # Verify it works
  ```

- [ ] Check system information
  ```bash
  system-info.sh
  # Verify information displays correctly
  ```

- [ ] Test from projects directory (if /projects exists)
  ```bash
  cd /projects
  pwd
  system-info.sh
  ```

---

## 🔧 Configuration Verification

- [ ] Check `.bashrc` was modified
  ```bash
  grep "dev-shortcuts" ~/.bashrc
  ```
  Expected: Lines containing dev-shortcuts path

- [ ] Check if `/usr/local/bin` has wrapper scripts (Enhanced install only)
  ```bash
  ls -la /usr/local/bin/update.sh 2>/dev/null
  ```
  Expected: File exists and is executable

- [ ] Verify PATH includes required directories
  ```bash
  echo $PATH | grep -E "(usr/local/bin|dev-shortcuts)"
  ```
  Expected: Matches found

---

## 📝 Optional Post-Installation Tasks

- [ ] Update Git configuration (if not done automatically)
  ```bash
  git config --global --list | grep alias
  ```

- [ ] Test Docker shortcuts (if Docker is installed)
  ```bash
  docker-cleanup.sh --help 2>/dev/null || echo "Docker scripts available"
  ```

- [ ] Customize git aliases (optional)
  ```bash
  # Edit ~/.gitconfig to add personal aliases
  ```

- [ ] Add custom scripts to dev-shortcuts
  ```bash
  # Place your custom .sh files in dev-shortcuts/
  # Re-run installer to make them system-wide
  ```

---

## 🐛 Troubleshooting Checklist

If scripts are not working:

- [ ] Verify you reloaded shell configuration
  ```bash
  source ~/.bashrc
  ```

- [ ] Check if PATH is correct
  ```bash
  echo $PATH
  ```

- [ ] Verify script permissions
  ```bash
  ls -la /usr/local/bin/update.sh
  # Should show: -rwxr-xr-x
  ```

- [ ] Check for error messages in installer output
  ```bash
  # Re-run installer and read output carefully
  ```

- [ ] Verify sudo was used (for enhanced install)
  ```bash
  ls -la /usr/local/bin/ | grep update
  ```

- [ ] Try in a new terminal window
  ```bash
  # Close current terminal
  # Open new terminal
  # Try commands again
  ```

---

## 📚 Documentation Review

- [ ] Read [INSTALL-QUICK-REFERENCE.md](INSTALL-QUICK-REFERENCE.md) for quick tips
- [ ] Bookmark [SYSTEM-WIDE-INSTALL.md](SYSTEM-WIDE-INSTALL.md) for detailed guide
- [ ] Review [README.md](README.md) for available scripts
- [ ] Check [IMPLEMENTATION-SUMMARY.md](IMPLEMENTATION-SUMMARY.md) for technical details

---

## 🎉 Success Criteria

You've successfully installed dev-shortcuts system-wide when:

✅ You can run `update.sh` from any directory
✅ Scripts work on all partitions (home, projects, tmp, etc.)
✅ Tab completion works for script names
✅ Git shortcuts are functional (if configured)
✅ No "command not found" errors

---

## 📞 Getting Help

If you encounter issues:

1. Check the troubleshooting section in [SYSTEM-WIDE-INSTALL.md](SYSTEM-WIDE-INSTALL.md)
2. Review error messages from the installer
3. Verify all checklist items above
4. Re-run the installer: `sudo ./install-system-wide-enhanced.sh`
5. Check file permissions: `ls -la /usr/local/bin/*.sh`

---

## 🔄 Maintenance

After installation:

- [ ] Bookmark this checklist for future reference
- [ ] Note the uninstall command: `sudo ./uninstall-system-wide.sh`
- [ ] Remember to re-run installer after adding new scripts
- [ ] Keep dev-shortcuts directory in place (scripts reference it)

---

## ✨ You're All Set!

Once all items are checked, you're ready to use dev-shortcuts from anywhere on your system!

Try it out:
```bash
cd /projects   # or any directory
update.sh
system-info.sh
ga             # if in a git repo
```

Happy coding! 🚀