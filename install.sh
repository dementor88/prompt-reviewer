#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_URL="https://github.com/dementor88/prompt-reviewer.git"
REPO_NAME="prompt-reviewer"

# Print colored output
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# Show usage
usage() {
    cat << EOF
Usage: install.sh [OPTIONS] <target>

Targets:
  opencode    Install for OpenCode (~/.config/opencode/skills/)
  claude      Install for Claude Code (~/.claude/skills/)

Options:
  --update    Update existing installation
  --uninstall Remove installation
  --help      Show this help message

Examples:
  curl -fsSL https://raw.githubusercontent.com/dementor88/prompt-reviewer/main/install.sh | bash -s -- opencode
  curl -fsSL https://raw.githubusercontent.com/dementor88/prompt-reviewer/main/install.sh | bash -s -- --update claude
  ./install.sh --uninstall opencode
EOF
    exit 0
}

# Get target directory
get_target_dir() {
    case "$1" in
        opencode) echo "$HOME/.config/opencode/skills/$REPO_NAME" ;;
        claude)   echo "$HOME/.claude/skills/$REPO_NAME" ;;
        *)        error "Unknown target: $1. Use 'opencode' or 'claude'." ;;
    esac
}

# Install
install() {
    local target="$1"
    local target_dir=$(get_target_dir "$target")
    local parent_dir=$(dirname "$target_dir")

    info "Installing prompt-reviewer for $target..."

    # Check git
    command -v git >/dev/null 2>&1 || error "Git is required but not installed."

    # Create parent directory
    if [ ! -d "$parent_dir" ]; then
        info "Creating directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi

    # Clone or update
    if [ -d "$target_dir" ]; then
        warn "Installation exists. Use --update to update."
        exit 1
    fi

    info "Cloning repository..."
    git clone --quiet "$REPO_URL" "$target_dir"

    # Verify
    if [ -f "$target_dir/skills/prompt-reviewer/SKILL.md" ]; then
        success "Installation complete!"
        echo ""
        echo "  Location: $target_dir"
        echo ""
        echo "  Usage:"
        echo "    prompt-review: <your prompt here>"
        echo "    robust-prompt-review: <your prompt here>"
        echo ""
    else
        error "Installation verification failed. SKILL.md not found."
    fi
}

# Update
update() {
    local target="$1"
    local target_dir=$(get_target_dir "$target")

    info "Updating prompt-reviewer for $target..."

    if [ ! -d "$target_dir" ]; then
        error "No installation found at $target_dir. Run without --update to install."
    fi

    cd "$target_dir"
    git pull --quiet origin main
    success "Update complete!"
}

# Uninstall
uninstall() {
    local target="$1"
    local target_dir=$(get_target_dir "$target")

    info "Uninstalling prompt-reviewer for $target..."

    if [ ! -d "$target_dir" ]; then
        warn "No installation found at $target_dir"
        exit 0
    fi

    rm -rf "$target_dir"
    success "Uninstalled from $target_dir"
}

# Main
main() {
    local action="install"
    local target=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)    usage ;;
            --update)     action="update"; shift ;;
            --uninstall)  action="uninstall"; shift ;;
            opencode|claude) target="$1"; shift ;;
            *)            error "Unknown option: $1" ;;
        esac
    done

    # Validate target
    [ -z "$target" ] && error "Target required. Use 'opencode' or 'claude'."

    # Execute action
    case "$action" in
        install)   install "$target" ;;
        update)    update "$target" ;;
        uninstall) uninstall "$target" ;;
    esac
}

main "$@"
