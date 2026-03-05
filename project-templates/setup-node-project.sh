#!/bin/bash

# Node.js Project Setup Script
# Author: ZRW
# Description: Quickly set up a new Node.js project with common configurations

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

main() {
    # Get project name
    if [ -z "$1" ]; then
        echo -n "Enter project name: "
        read project_name
    else
        project_name="$1"
    fi
    
    if [ -z "$project_name" ]; then
        print_error "Project name is required"
        exit 1
    fi
    
    # Check if directory already exists
    if [ -d "$project_name" ]; then
        print_error "Directory '$project_name' already exists"
        exit 1
    fi
    
    print_status "Setting up Node.js project: $project_name"
    
    # Create project directory
    mkdir "$project_name"
    cd "$project_name"
    
    # Initialize npm project
    print_status "Initializing npm project..."
    npm init -y
    
    # Create basic project structure
    print_status "Creating project structure..."
    mkdir -p src tests docs
    
    # Create basic files
    cat > src/index.js << 'EOF'
// Main application entry point
console.log('Hello, World!');

function main() {
    // Your application logic here
}

if (require.main === module) {
    main();
}

module.exports = { main };
EOF
    
    cat > tests/index.test.js << 'EOF'
// Basic test file
const { main } = require('../src/index');

describe('Main function', () => {
    test('should run without errors', () => {
        expect(() => main()).not.toThrow();
    });
});
EOF
    
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
.nyc_output

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build output
dist/
build/
EOF
    
    cat > README.md << EOF
# $project_name

## Description
Brief description of your project.

## Installation
\`\`\`bash
npm install
\`\`\`

## Usage
\`\`\`bash
npm start
\`\`\`

## Testing
\`\`\`bash
npm test
\`\`\`

## License
MIT
EOF
    
    # Install common development dependencies
    print_status "Installing development dependencies..."
    npm install --save-dev jest nodemon eslint prettier
    
    # Update package.json scripts
    print_status "Updating package.json scripts..."
    npm pkg set scripts.start="node src/index.js"
    npm pkg set scripts.dev="nodemon src/index.js"
    npm pkg set scripts.test="jest"
    npm pkg set scripts.lint="eslint src/"
    npm pkg set scripts.format="prettier --write src/"
    
    # Initialize git repository
    if command_exists git; then
        print_status "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit: Project setup"
    fi
    
    print_success "Node.js project '$project_name' created successfully!"
    print_status "Next steps:"
    echo "  cd $project_name"
    echo "  npm run dev    # Start development server"
    echo "  npm test       # Run tests"
    echo "  npm run lint   # Check code style"
}

# Check if Node.js and npm are installed
if ! command_exists node; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

if ! command_exists npm; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

main "$@"
