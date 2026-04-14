#!/bin/bash

# Smart Git Add - Stage files by name with intelligent path matching
# Usage: 
#   smart_git_add filename.ext
#   smart_git_add partial/path filename.ext
#   smart_git_add app layout.tsx (stages app/*/layout.tsx, not other layout.tsx files)

smart_git_add() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
        echo "Usage: smart_git_add [partial_path] filename"
        echo "Examples:"
        echo "  smart_git_add HeroSection.tsx"
        echo "  smart_git_add app layout.tsx"
        echo "  smart_git_add src/components Button.tsx"
        return 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi
    
    local filename
    local partial_path=""
    
    if [ $# -eq 1 ]; then
        filename="$1"
    else
        # Join all arguments except the last one as partial path
        partial_path="${*%${!#}}"
        partial_path="${partial_path% }"  # Remove trailing space
        filename="${!#}"  # Last argument is the filename
    fi
    
    echo "🔍 Searching for '$filename'${partial_path:+ in paths containing '$partial_path'}..."
    
    # Get list of changed files (modified, staged, and untracked)
    local modified_files
    modified_files=$(git status --porcelain 2>/dev/null | awk '{print $NF}')
    if [ -z "$modified_files" ]; then
        echo "No changed or untracked files found in repository"
        return 1
    fi
    
    # Find matching files
    local matching_files=()
    while IFS= read -r file; do
        if [[ "$file" == *"$filename" ]]; then
            if [ -n "$partial_path" ]; then
                # Check if the file path contains the partial path
                if [[ "$file" == *"$partial_path"* ]]; then
                    matching_files+=("$file")
                fi
            else
                matching_files+=("$file")
            fi
        fi
    done <<< "$modified_files"
    
    # Handle results
    if [ ${#matching_files[@]} -eq 0 ]; then
        echo "❌ No modified files found matching '$filename'${partial_path:+ with path '$partial_path'}"
        echo ""
        echo "Modified files available:"
        echo "$modified_files" | sed 's/^/  /'
        return 1
    elif [ ${#matching_files[@]} -eq 1 ]; then
        local file="${matching_files[0]}"
        echo "✅ Found: $file"
        git add "$file"
        echo "🎯 Staged: $file"
        
        # Show what was staged
        echo ""
        echo "📋 Status after staging:"
        git status --short "$file"
    else
        echo "🤔 Multiple files found matching '$filename'${partial_path:+ with path '$partial_path'}:"
        local i=1
        for file in "${matching_files[@]}"; do
            echo "  $i) $file"
            ((i++))
        done
        
        echo ""
        read -p "Enter number to stage (1-${#matching_files[@]}), 'a' for all, or 'c' to cancel: " choice
        
        case "$choice" in
            [1-9]*)
                if [ "$choice" -ge 1 ] && [ "$choice" -le ${#matching_files[@]} ]; then
                    local selected_file="${matching_files[$((choice-1))]}"
                    git add "$selected_file"
                    echo "🎯 Staged: $selected_file"
                    git status --short "$selected_file"
                else
                    echo "❌ Invalid selection"
                    return 1
                fi
                ;;
            [aA])
                echo "🎯 Staging all matching files:"
                for file in "${matching_files[@]}"; do
                    git add "$file"
                    echo "  ✓ $file"
                done
                echo ""
                git status --short "${matching_files[@]}"
                ;;
            [cC])
                echo "❌ Cancelled"
                return 1
                ;;
            *)
                echo "❌ Invalid choice"
                return 1
                ;;
        esac
    fi
}

# Export the function so it's available in subshells
export -f smart_git_add

# Note: Aliases are created in .bashrc by install-system-wide.sh
# This allows the function to work both when sourced and when called directly
