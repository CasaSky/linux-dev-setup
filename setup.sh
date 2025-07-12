#!/bin/bash

# Linux Development Environment Setup Script
# Tested on: Linux Mint, Ubuntu
# Author: CasaSky
# Description: Automated setup for web and Python development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on supported system
check_system() {
    log_info "Checking system compatibility..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine OS. This script is for Linux systems."
        exit 1
    fi
    
    . /etc/os-release
    
    if [[ "$ID" != "linuxmint" && "$ID" != "ubuntu" ]]; then
        log_warning "This script is tested on Linux Mint and Ubuntu. Your system: $ID"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    log_success "System check passed"
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget vim git build-essential
    log_success "System updated"
}

# Install Homebrew
install_homebrew() {
    log_info "Installing Homebrew..."
    
    if command -v brew &> /dev/null; then
        log_warning "Homebrew already installed"
        return 0
    fi
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH
    echo >> ~/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Install build dependencies
    sudo apt-get install -y build-essential
    brew install gcc
    
    log_success "Homebrew installed"
}

# Install development tools
install_dev_tools() {
    log_info "Installing development tools via Homebrew..."
    
    # Core development tools
    brew install gh node python@3.12 go
    
    # CLI utilities
    brew install tree htop ripgrep fd fzf
    
    # Setup fzf shell integration
    log_info "Setting up fzf shell integration..."
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --update-rc
    
    log_success "Development tools installed"
}

# System optimizations
optimize_system() {
    log_info "Applying system optimizations..."
    
    # Enable TRIM for SSD
    log_info "Enabling SSD TRIM..."
    sudo systemctl enable fstrim.timer
    sudo systemctl start fstrim.timer
    
    # Optimize swappiness for systems with lots of RAM
    log_info "Optimizing memory usage..."
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    sudo sysctl vm.swappiness=10
    
    # Increase file watch limits for development
    log_info "Increasing file watch limits..."
    echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
    sudo sysctl fs.inotify.max_user_watches=524288
    
    log_success "System optimizations applied"
}

# Install JetBrains IDEs
install_jetbrains() {
    log_info "Installing JetBrains IDEs via Flatpak..."
    
    # Check if flatpak is installed
    if ! command -v flatpak &> /dev/null; then
        log_info "Installing Flatpak..."
        sudo apt install -y flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Install IDEs
    log_info "Installing IntelliJ IDEA Community..."
    flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
    
    log_info "Installing WebStorm..."
    flatpak install -y flathub com.jetbrains.WebStorm
    
    log_info "Installing PyCharm Community..."
    flatpak install -y flathub com.jetbrains.PyCharm-Community
    
    log_success "JetBrains IDEs installed"
}

# Setup GitHub SSH
setup_github_ssh() {
    log_info "Setting up GitHub SSH authentication..."
    
    read -p "Enter your GitHub email: " github_email
    read -p "Enter your GitHub username: " github_username
    
    # Generate SSH key
    ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
    
    # Start SSH agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    # Configure git
    git config --global user.name "$github_username"
    git config --global user.email "$github_email"
    
    # Display public key
    log_info "Your SSH public key (add this to GitHub):"
    echo "----------------------------------------"
    cat ~/.ssh/id_ed25519.pub
    echo "----------------------------------------"
    
    log_info "Please add this key to GitHub:"
    log_info "1. Go to GitHub.com → Settings → SSH and GPG keys"
    log_info "2. Click 'New SSH key'"
    log_info "3. Paste the key above"
    log_info "4. Give it a title like '$(hostname)'"
    
    read -p "Press Enter after adding the key to GitHub..."
    
    # Test connection
    log_info "Testing GitHub connection..."
    ssh -T git@github.com || true
    
    # Setup gh CLI
    log_info "Setting up GitHub CLI..."
    gh auth login
    
    log_success "GitHub SSH setup complete"
}

# Main execution
main() {
    echo "========================================"
    echo "  Linux Development Environment Setup  "
    echo "========================================"
    echo
    
    check_system
    
    # Ask user what to install
    echo "What would you like to install?"
    echo "1. Full setup (everything)"
    echo "2. System optimizations only"
    echo "3. Development tools only"
    echo "4. JetBrains IDEs only"
    echo "5. Custom selection"
    
    read -p "Choose option (1-5): " choice
    
    case $choice in
        1)
            update_system
            optimize_system
            install_homebrew
            install_dev_tools
            install_jetbrains
            setup_github_ssh
            ;;
        2)
            optimize_system
            ;;
        3)
            install_homebrew
            install_dev_tools
            ;;
        4)
            install_jetbrains
            ;;
        5)
            echo "Custom selection:"
            read -p "Update system? (y/n): " -n 1 update_choice; echo
            read -p "Apply optimizations? (y/n): " -n 1 opt_choice; echo
            read -p "Install Homebrew & dev tools? (y/n): " -n 1 brew_choice; echo
            read -p "Install JetBrains IDEs? (y/n): " -n 1 jetbrains_choice; echo
            read -p "Setup GitHub SSH? (y/n): " -n 1 github_choice; echo
            
            [[ $update_choice =~ ^[Yy]$ ]] && update_system
            [[ $opt_choice =~ ^[Yy]$ ]] && optimize_system
            [[ $brew_choice =~ ^[Yy]$ ]] && { install_homebrew; install_dev_tools; }
            [[ $jetbrains_choice =~ ^[Yy]$ ]] && install_jetbrains
            [[ $github_choice =~ ^[Yy]$ ]] && setup_github_ssh
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo
    log_success "Setup completed successfully!"
    echo
    echo "Installed tools:"
    echo "- Homebrew with development packages"
    echo "- Node.js, Python 3.12, Go"
    echo "- Git, GitHub CLI"
    echo "- CLI utilities (fzf, ripgrep, htop, tree)"
    echo "- JetBrains IDEs (IntelliJ, WebStorm, PyCharm)"
    echo "- System optimizations for development"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Test tools: brew --version, node --version, gh auth status"
    echo "3. Launch IDEs from applications menu"
    echo
    echo "Happy coding! 🚀"
}

# Run main function
main "$@"
