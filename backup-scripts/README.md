# Home Directory Backup Scripts

Comprehensive backup and restoration solution for your Ubuntu home directory, specifically designed to handle development environments with Node.js projects.

## 📁 Scripts Overview

### 🚀 `comprehensive-home-backup.sh`
Creates compressed backups of your entire home directory with intelligent exclusions.

**Key Features:**
- ✅ **Preserves .git directories** in all projects (no need to `git init` again)
- ✅ **Excludes node_modules** to save ~4GB+ per project  
- ✅ **Smart compression** with gzip for maximum efficiency
- ✅ **Space checking** before backup to prevent failures
- ✅ **Detailed reports** with backup statistics and project listings
- ✅ **Backup verification** to ensure integrity
- ✅ **Timestamped backups** with "latest" symlink

### 🔄 `restore-backup.sh`
Restores backups and automatically reinstalls npm packages for all projects.

**Key Features:**
- ✅ **Complete restoration** from compressed backups
- ✅ **Automatic npm package installation** for all detected projects
- ✅ **Safety backups** during restoration process
- ✅ **Dry-run mode** for testing before actual restoration
- ✅ **Selective restoration** (npm-only mode available)

## 🎯 Quick Start

### Create a Backup
```bash
# Basic backup
./comprehensive-home-backup.sh

# List existing backups
./comprehensive-home-backup.sh list

# Show help
./comprehensive-home-backup.sh help
```

### Restore from Backup
```bash
# List available backups
./restore-backup.sh

# Restore latest backup
./restore-backup.sh latest

# Restore specific backup
./restore-backup.sh home_backup_20250922_213000

# Test restoration (dry-run)
./restore-backup.sh latest --dry-run

# Only reinstall npm packages (no file restoration)
./restore-backup.sh --npm-only
```

## 📊 What Gets Backed Up

### ✅ **Included:**
- All Desktop projects (with .git directories intact)
- Documents, Pictures, Music, Videos
- Configuration files (.bashrc, .profile, SSH keys, etc.)
- Development environments (python_dev_env, etc.)
- Browser bookmarks and settings
- Custom scripts and shortcuts
- All dotfiles and configurations

### ❌ **Excluded (to save space):**
- `node_modules/` directories (~4GB+ per project)
- Cache files (browser caches, .cache/, etc.)
- Temporary files (*.tmp, *.log, .DS_Store)
- Large application caches (Snap, VSCode, etc.)
- Trash and thumbnail caches
- Build artifacts (dist/, build/)

## 🔍 Backup Details

### Backup Structure
```
/home/pharoh/Backups/
├── latest -> home_backup_20250922_213000/
├── home_backup_20250922_213000/
│   ├── home_data.tar.gz          # Compressed home directory
│   ├── backup_report.md          # Detailed backup report
│   ├── backup_log.txt           # Backup process log
│   └── exclude_list.txt         # List of excluded patterns
└── home_backup_20250921_180000/
    └── ...
```

### Size Estimates
- **Original home size**: ~25GB
- **Typical backup size**: ~8-12GB (after compression & exclusions)
- **Space savings**: 60-70% compared to naive backup
- **Node modules excluded**: ~15GB+ across all projects

## 🛠️ Advanced Usage

### Custom Exclusions
Edit the `create_exclusion_list()` function in `comprehensive-home-backup.sh` to add custom exclusion patterns.

### Scheduling Backups
Add to crontab for automatic backups:
```bash
# Daily backup at 2 AM
0 2 * * * /home/pharoh/dev-shortcuts/backup-scripts/comprehensive-home-backup.sh >/dev/null 2>&1

# Weekly backup on Sunday at 3 AM
0 3 * * 0 /home/pharoh/dev-shortcuts/backup-scripts/comprehensive-home-backup.sh
```

### Integration with External Storage
Mount external drive and modify `BACKUP_BASE_DIR` in scripts:
```bash
# Example: backup to external drive
BACKUP_BASE_DIR="/media/pharoh/external-drive/Backups"
```

## 🚨 Recovery Process

### Full System Recovery (After Ubuntu Reinstall)
1. **Restore backup**:
   ```bash
   ./restore-backup.sh latest
   ```

2. **Reinstall system packages** (Node.js, VS Code, etc.)
   ```bash
   # Your system will need these first
   curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

3. **NPM packages are automatically reinstalled** by the restore script

4. **Verify git configurations**:
   ```bash
   git config --global --list
   ```

### Project Recovery Only
If you just need to reinstall npm packages after backup restoration:
```bash
./restore-backup.sh --npm-only
```

## 📈 Performance & Resources

### Backup Performance
- **Typical duration**: 3-8 minutes (depends on data size)
- **CPU usage**: Moderate during compression phase  
- **I/O impact**: Sequential reads/writes (SSD friendly)
- **Memory usage**: ~200-500MB for tar compression

### Restoration Performance
- **Extract duration**: 2-5 minutes
- **NPM installs**: 5-15 minutes (depends on project count)
- **Total restoration**: 10-20 minutes for complete recovery

## 💡 Tips & Best Practices

1. **Test your backups**: Run `./restore-backup.sh latest --dry-run` periodically

2. **Monitor backup sizes**: Check if backups are growing unexpectedly

3. **Clean old backups**: Remove old backups manually when storage is low

4. **Verify git repos**: After restoration, ensure all git remotes are configured

5. **External storage**: Consider backing up to external drive or cloud storage

6. **Pre-reinstall backup**: Always create a backup before major system changes

## 🔧 Troubleshooting

### Common Issues

**"Insufficient space for backup"**
- Solution: Clean up Downloads, remove old backups, or use external storage

**"npm install failed for project X"**
- Solution: Check Node.js version compatibility, run `npm install` manually in that project

**"Backup verification failed"**
- Solution: Check disk space during backup, verify backup archive isn't corrupted

**".git directories missing after restore"**
- Solution: This shouldn't happen with these scripts - they specifically preserve .git dirs

### Support
Check the log files in each backup directory for detailed error information:
- `backup_log.txt` - Backup process details
- `backup_report.md` - Comprehensive backup report

---

**Generated**: September 22, 2025  
**Compatible with**: Ubuntu 22.04+ and similar Linux distributions  
**Requirements**: bash, tar, gzip, npm (for restoration), find, du
