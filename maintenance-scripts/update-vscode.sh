#!/bin/bash

APPDIR=~/Applications/vscode
DOWNLOAD_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
VERSION_FILE="$APPDIR/current_version.txt"

# Create the app directory if it doesn't exist
mkdir -p "$APPDIR"

echo "Checking for VS Code updates..."

# Get the redirect URL which contains version info
REDIRECT_URL=$(curl -sIL -w '%{url_effective}' -o /dev/null "$DOWNLOAD_URL")

if [ $? -ne 0 ] || [ -z "$REDIRECT_URL" ]; then
    echo "Error: Failed to connect to VS Code download server."
    exit 1
fi

# Extract version from the redirect URL
# URL format: https://vscode.download.prss.microsoft.com/.../code_X.Y.Z-TIMESTAMP_amd64.deb
LATEST_VERSION=$(echo "$REDIRECT_URL" | grep -oP 'code_\K[0-9]+\.[0-9]+\.[0-9]+-[0-9]+' || echo "unknown")

echo "Latest version: $LATEST_VERSION"

# Check current version
CURRENT_VERSION=""
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
    echo "Current version: $CURRENT_VERSION"
fi

# Check if we need to update
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] && [ -f "$APPDIR/code.deb" ]; then
    echo "VS Code is already up to date (version: $CURRENT_VERSION)"
    exit 0
fi

echo "New version available! Updating from '$CURRENT_VERSION' to '$LATEST_VERSION'"

# Download the new version
echo "Downloading VS Code .deb package from Microsoft..."

if curl -L --fail --progress-bar -o "$APPDIR/code.deb.tmp" "$DOWNLOAD_URL"; then
    if [ -s "$APPDIR/code.deb.tmp" ]; then
        # Backup old version if it exists
        if [ -f "$APPDIR/code.deb" ]; then
            mv "$APPDIR/code.deb" "$APPDIR/code.deb.backup"
        fi
        
        # Move to final location
        mv "$APPDIR/code.deb.tmp" "$APPDIR/code.deb"
        
        # Install the .deb package
        echo "Installing VS Code..."
        if sudo dpkg -i "$APPDIR/code.deb"; then
            # Save version info
            echo "$LATEST_VERSION" > "$VERSION_FILE"
            
            echo "✅ VS Code successfully updated to version $LATEST_VERSION"
            echo "File size: $(ls -lh "$APPDIR/code.deb" | awk '{print $5}')"
            
            # Clean up backup after successful update
            rm -f "$APPDIR/code.deb.backup"
        else
            echo "Error: Failed to install VS Code package"
            echo "Attempting to fix dependencies..."
            sudo apt-get install -f -y
            exit 1
        fi
    else
        echo "Error: Downloaded file is empty"
        rm -f "$APPDIR/code.deb.tmp"
        exit 1
    fi
else
    echo "Error: Failed to download VS Code package"
    rm -f "$APPDIR/code.deb.tmp"
    exit 1
fi
