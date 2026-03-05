#!/bin/bash

# Enhanced git commit script with commit type selection
# This script helps select a conventional commit type prefix

# Function to display help
show_help() {
  echo "Enhanced git commit command with conventional commit types"
  echo "Usage: git_commit [options]"
  echo ""
  echo "This will prompt you for a commit type and message, then commit with a properly formatted message."
  echo ""
  echo "Options:"
  echo "  -h, --help    Display this help message"
  echo "  -s, --skip    Skip the type selection prompt and use a custom message"
  echo ""
  echo "For more information on commit types, see: /home/pharoh/dev-shortcuts/git-setup/commit_shorthand_notes.md"
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: Not in a git repository."
  exit 1
fi

# Skip type selection if requested
if [[ "$1" == "-s" || "$1" == "--skip" ]]; then
  shift
  if [ -n "$1" ]; then
    git commit -m "$*"
  else
    git commit
  fi
  exit $?
fi

# Show the status before committing
echo "Current git status:"
git status -s

# Function to show commit type menu
show_commit_type_menu() {
  echo ""
  echo "Select a commit type:"
  echo "1) feat     - New feature"
  echo "2) fix      - Bug fix"
  echo "3) chore    - Routine task"
  echo "4) perf     - Performance improvement"
  echo "5) docs     - Documentation"
  echo "6) style    - Code style changes"
  echo "7) refactor - Code refactoring"
  echo "8) test     - Adding/updating tests"
  echo "9) hotfix   - Critical bug fix"
  echo "10) revert   - Reverting changes"
  echo "11) custom   - Use custom message"
  echo "12) help     - Show detailed descriptions"
  echo "q) quit     - Cancel commit"
  echo ""
  read -p "Enter your choice (1-12 or q): " choice
  
  case $choice in
    1) echo "feat";;
    2) echo "fix";;
    3) echo "chore";;
    4) echo "perf";;
    5) echo "docs";;
    6) echo "style";;
    7) echo "refactor";;
    8) echo "test";;
    9) echo "hotfix";;
    10) echo "revert";;
    11) echo "custom";;
    12) 
      less /home/pharoh/dev-shortcuts/git-setup/commit_shorthand_notes.md
      show_commit_type_menu
      ;;
    q|Q) 
      echo "Commit canceled."
      exit 0
      ;;
    *)
      echo "Invalid choice. Please try again."
      show_commit_type_menu
      ;;
  esac
}

# Get commit type
commit_type=$(show_commit_type_menu)

# Handle custom message case
if [ "$commit_type" == "custom" ]; then
  read -p "Enter your commit message: " commit_message
  git commit -m "$commit_message"
  exit $?
fi

# Get commit message
if [ "$commit_type" != "help" ] && [ "$commit_type" != "quit" ]; then
  read -p "Enter commit message (without type): " commit_message
  
  # Check if commit message is empty
  if [ -z "$commit_message" ]; then
    echo "Error: Commit message cannot be empty."
    exit 1
  fi
  
  # Construct the full commit message
  full_message="$commit_type: $commit_message"
  
  # Confirm the commit
  echo ""
  echo "About to commit with message: \"$full_message\""
  read -p "Proceed? (y/n): " confirm
  
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    git commit -m "$full_message"
  else
    echo "Commit canceled."
  fi
fi
