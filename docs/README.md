# ZRW's Dev Shortcuts Collection

A collection of automation scripts and development shortcuts to streamline system management and development workflows.

> **🚀 New User?** → **[START HERE](START-HERE.md)** for a quick 3-step installation guide!

## 🚀 System-Wide Installation

Make all scripts available system-wide - run them from **any directory** on your system, including `/projects` or any other partition!

### Quick Install (Recommended)

**Enhanced Installation** - Installs to `/usr/local/bin` for true system-wide access:

```bash
cd /home/pharoh/Desktop/dev-shortcuts
sudo ./install-system-wide-enhanced.sh
source ~/.bashrc
```

**Or PATH-based Installation** - Adds dev-shortcuts to your PATH:

```bash
cd /home/pharoh/Desktop/dev-shortcuts
./install-system-wide.sh
source ~/.bashrc
```

### What Gets Installed

✅ **Main Scripts:**
- `update.sh` - Interactive system update menu
- `system-info.sh` - Comprehensive system information
- `update-cursor.sh` - Update Cursor AppImage
- `update-vscode.sh` - Update VS Code
- `update-original.sh` - Original update script

✅ **Git Shortcuts:**
- `smart_git_add` or `ga` - Smart git add with interactive selection
- `githelp` - Git alias cheat sheet
- `git_commit_with_type.sh` - Interactive commit helper

✅ **Additional Tools:**
- `docker-cleanup.sh` - Docker cleanup utilities
- `connect-earbuds.sh` - Bluetooth connection helper
- And more...

### Usage from Anywhere

After installation, run scripts from **any location**:

```bash
# From home directory
cd ~
update.sh

# From projects partition
cd /projects/my-awesome-project
system-info.sh

# From any directory
cd /tmp
update-cursor.sh
```

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  Enhanced Installation Creates:                              │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  /usr/local/bin/                                              │
│  ├── update.sh ────────────┐                                 │
│  ├── system-info.sh ───────┤                                 │
│  ├── update-cursor.sh ─────┼──► Wrapper scripts pointing to  │
│  └── (all other scripts)   │    dev-shortcuts directory      │
│                             │                                 │
│  /home/pharoh/Desktop/dev-shortcuts/                          │
│  ├── maintenance-scripts/   │                                 │
│  │   ├── update.sh ◄────────┘                                │
│  │   └── ...                                                  │
│  ├── system-monitoring/                                       │
│  │   └── system-info.sh ◄──── Actual script files            │
│  └── ...                                                      │
│                                                               │
│  Result: Run from ANYWHERE on any partition!                 │
│  ✓ /projects/  ✓ /home/  ✓ /tmp/  ✓ Everywhere!             │
└─────────────────────────────────────────────────────────────┘
```

### Interactive Installer

Want a guided installation? Use the interactive quick start:

```bash
./quick-start.sh
```

📖 **Documentation:**
- **[Quick Reference](INSTALL-QUICK-REFERENCE.md)** - One-page cheat sheet
- **[Full Installation Guide](SYSTEM-WIDE-INSTALL.md)** - Detailed instructions, troubleshooting, and advanced configuration
- **[Implementation Details](IMPLEMENTATION-SUMMARY.md)** - Technical documentation

### Uninstalling

To remove system-wide installation:

```bash
sudo ./uninstall-system-wide.sh
```

## Directory Structure

```
dev-shortcuts/
├── update.sh                    # Enhanced interactive system update menu
├── update-original.sh           # Original update script backup
├── git-setup/                   # Git configuration and aliases
├── docker-shortcuts/            # Docker management scripts
├── system-monitoring/           # System information and monitoring
├── project-templates/          # Project setup automation
├── hardware-automation/        # Hardware connection scripts
└── backup-scripts/             # (Future) Backup automation
```

## Scripts Overview

### System Management

- **`update.sh`** - Enhanced interactive system update menu with colors and additional package managers
- **`update-original.sh`** - Your original simple update script (backup)
- **`update-vscode.sh`** - Automatically download and update VS Code to the latest version
- **`update-cursor.sh`** - Automatically download and update Cursor editor to the latest version

### Docker Management (`docker-shortcuts/`)

- **`docker-cleanup.sh`** - Clean up Docker containers, images, volumes, and networks

### System Monitoring (`system-monitoring/`)

- **`system-info.sh`** - Comprehensive system information display

### Project Templates (`project-templates/`)

- **`setup-node-project.sh`** - Quick Node.js project setup with best practices

### Git Setup (`git-setup/`)

- **`.gitconfig`** - Comprehensive git aliases (installed/merged automatically)
- **`git-alias-help.sh`** - Display git alias cheat sheet
- **`bashrc-git-portion.txt`** - Auto-display git help in Desktop projects
- **Smart Git Add** - `smart_git_add.sh` provides intelligent file staging:
  - `ga filename.tsx` - Stage files by name
  - `ga app layout.tsx` - Stage with path matching
  - Available as `ga` or `smart_git_add` after installation

### Hardware Automation (`hardware-automation/`)

- **`connect-earbuds.sh`** - Comprehensive Bluetooth earbuds connection script for Redmi Buds 6 Play

## Usage Examples

### After System-Wide Installation

```bash
# System updates (from any directory)
update.sh                                    # Interactive menu
update-vscode.sh                            # Update VS Code
update-cursor.sh                            # Update Cursor editor
update-original.sh                          # Original simple version

# Docker management
docker-cleanup.sh                           # Clean up Docker

# System monitoring
system-info.sh                              # Show system info

# Project setup
setup-node-project.sh my-app                # Create Node.js project

# Hardware automation
sudo connect-earbuds.sh                    # Connect Bluetooth earbuds

# Git helpers
git_commit_with_type.sh                    # Enhanced git commit
ga filename.tsx                            # Smart git add (alias)
smart_git_add app layout.tsx               # Smart git add with path
githelp                                     # Show git alias cheat sheet
git st                                      # Git status (alias)
git br                                      # Branch overview (alias)
git timeline                                # Full branch timeline (alias)
```

### Without System-Wide Installation

```bash
# System updates
./update.sh                                    # Interactive menu
./update-original.sh                          # Original simple version

# Docker management
./docker-shortcuts/docker-cleanup.sh          # Clean up Docker

# System monitoring
./system-monitoring/system-info.sh            # Show system info

# Project setup
./project-templates/setup-node-project.sh my-app  # Create Node.js project

# Hardware automation
sudo ./hardware-automation/connect-earbuds.sh     # Connect Bluetooth earbuds
```

## Adding New Scripts

To add new automation scripts:

1. Create appropriate subdirectory if needed
2. Add your script with proper permissions (`chmod +x script.sh`)
3. Include header comments with description and author
4. Use consistent color coding for output
5. Update this README

## Suggested Additional Automations

Here are some ideas for future automation scripts:

### Backup Scripts (`backup-scripts/`)
- **`backup-home.sh`** - Backup home directory to external drive
- **`backup-configs.sh`** - Backup important config files
- **`sync-to-cloud.sh`** - Sync specific folders to cloud storage

### Development Tools (`dev-tools/`)
- **`setup-python-env.sh`** - Python virtual environment setup
- **`setup-react-app.sh`** - React application boilerplate
- **`code-formatter.sh`** - Format code across multiple languages

### System Utilities (`system-utils/`)
- **`cleanup-logs.sh`** - Clean old log files
- **`network-diagnostics.sh`** - Network troubleshooting tools
- **`performance-monitor.sh`** - System performance monitoring

### Database Tools (`db-tools/`)
- **`backup-databases.sh`** - Backup all databases
- **`db-health-check.sh`** - Database health monitoring

### Security (`security/`)
- **`security-audit.sh`** - Basic security checks
- **`firewall-setup.sh`** - Configure firewall rules

## Author

Created by ZRW for personal development automation.
