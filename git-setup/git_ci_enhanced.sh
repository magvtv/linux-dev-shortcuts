#!/bin/bash

# Enhanced git ci command that shows commit types guide first
# but otherwise functions like the original git ci command

# Show the commit types guide
/home/pharoh/dev-shortcuts/git-setup/commit_types_cheatsheet.sh

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
