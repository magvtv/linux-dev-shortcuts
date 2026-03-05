#!/bin/bash

APPDIR=~/Applications/cursor
APPIMAGE_URL_API="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
VERSION_FILE="$APPDIR/current_version.txt"

# Create the app directory if it doesn't exist
mkdir -p "$APPDIR"

echo "Checking for Cursor updates..."

# Fetch the latest release info from the API
API_RESPONSE=$(curl -sL --connect-timeout 30 --max-time 60 "$APPIMAGE_URL_API")

if [ $? -ne 0 ] || [ -z "$API_RESPONSE" ]; then
    echo "Error: Failed to connect to Cursor API."
    exit 1
fi

# Extract download URL and version info
DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.downloadUrl' 2>/dev/null)
LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.version // .tag_name // "unknown"' 2>/dev/null)

if [[ -z "$DOWNLOAD_URL" || "$DOWNLOAD_URL" == "null" ]]; then
    echo "Error: Failed to retrieve download URL from Cursor API."
    exit 1
fi

# If we can't get version info from API, use URL as version identifier
if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" || "$LATEST_VERSION" == "unknown" ]]; then
    LATEST_VERSION=$(echo "$DOWNLOAD_URL" | grep -o '/[^/]*\.AppImage' | sed 's|/||' | sed 's|\.AppImage||')
fi

echo "Latest version: $LATEST_VERSION"

# Check current version
CURRENT_VERSION=""
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
    echo "Current version: $CURRENT_VERSION"
fi

# Check if we need to update
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] && [ -f "$APPDIR/cursor.AppImage" ]; then
    echo "Cursor is already up to date (version: $CURRENT_VERSION)"
    exit 0
fi

echo "New version available! Updating from '$CURRENT_VERSION' to '$LATEST_VERSION'"

# Download the new version
echo "Downloading Cursor AppImage from $DOWNLOAD_URL..."

if curl -L --fail --progress-bar -o "$APPDIR/cursor.AppImage.tmp" "$DOWNLOAD_URL"; then
    if [ -s "$APPDIR/cursor.AppImage.tmp" ]; then
        # Backup old version if it exists
        if [ -f "$APPDIR/cursor.AppImage" ]; then
            mv "$APPDIR/cursor.AppImage" "$APPDIR/cursor.AppImage.backup"
        fi
        
        # Install new version
        mv "$APPDIR/cursor.AppImage.tmp" "$APPDIR/cursor.AppImage"
        chmod +x "$APPDIR/cursor.AppImage"
        
        # Save version info
        echo "$LATEST_VERSION" > "$VERSION_FILE"
        
        echo "✅ Cursor successfully updated to version $LATEST_VERSION"
        echo "File size: $(ls -lh "$APPDIR/cursor.AppImage" | awk '{print $5}')"
        
        # Clean up backup after successful update
        rm -f "$APPDIR/cursor.AppImage.backup"
    else
        echo "Error: Downloaded file is empty"
        rm -f "$APPDIR/cursor.AppImage.tmp"
        exit 1
    fi
else
    echo "Error: Failed to download Cursor AppImage"
    rm -f "$APPDIR/cursor.AppImage.tmp"
    exit 1
fi
