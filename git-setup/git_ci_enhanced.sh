#!/bin/bash

# Enhanced git ci command that shows commit types guide first
# but otherwise functions like the original git ci command

# Show the commit types guide
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/commit_types_cheatsheet.sh" 2>/dev/null || ~/bin/commit_types_cheatsheet.sh 2>/dev/null || echo "Cheatsheet script not found"

# Ask if they'd like to continue
echo ""
read -p "Press Enter to continue to commit or Ctrl+C to cancel..."

# Show git status
echo ""
echo "Current git status:"
git status -s
echo ""

# Get the commit summary
echo "Enter commit summary (consider using a type prefix, e.g., 'feat: add feature'):"
read -r summary

# Validate input
if [ -z "$summary" ]; then
  echo "Error: Commit message cannot be empty."
  exit 1
fi

# Get the commit description
echo "Enter detailed description (press Ctrl+D when done, or just press Enter to skip):"
description=$(cat)

# Create the commit
if [ -n "$description" ]; then
  git commit -m "$summary" -m "$description"
else
  git commit -m "$summary"
fi

echo ""
echo "✅ Commit created successfully"
