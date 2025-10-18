#!/bin/bash

###############################################################################
# Mac Development Environment Setup Script
# Automated setup for macOS development environment with robust error handling
###############################################################################

# Continue on errors - individual command failures won't stop the script
set +e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters for summary
PACKAGES_INSTALLED=0
PACKAGES_SKIPPED=0
PACKAGES_FAILED=0

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Check if script is run with sudo (we don't want that)
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script with sudo"
    exit 1
fi

###############################################################################
# 1. Install Xcode Command Line Tools
###############################################################################
print_section "1. Xcode Command Line Tools"

if xcode-select -p &> /dev/null; then
    print_success "Xcode Command Line Tools already installed"
else
    print_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode installation and run this script again"
    exit 0
fi

###############################################################################
# 2. Install Homebrew
###############################################################################
print_section "2. Homebrew Package Manager"

if command -v brew &> /dev/null; then
    print_success "Homebrew already installed"
    print_info "Updating Homebrew..."
    if brew update 2>&1; then
        print_success "Homebrew updated successfully"
    else
        print_warning "Homebrew update had issues, but continuing..."
    fi
else
    print_info "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        print_success "Homebrew installed"
    else
        print_error "Failed to install Homebrew. Please install manually and re-run this script."
        exit 1
    fi
fi

###############################################################################
# 3. Add Homebrew Taps
###############################################################################
print_section "3. Homebrew Taps"

TAPS=(
    "romkatv/powerlevel10k"
)

for tap in "${TAPS[@]}"; do
    if brew tap | grep -q "^${tap}$" 2>/dev/null; then
        print_success "Tap already added: $tap"
        ((PACKAGES_SKIPPED++))
    else
        print_info "Adding tap: $tap"
        if brew tap "$tap" 2>&1; then
            print_success "Tap added: $tap"
            ((PACKAGES_INSTALLED++))
        else
            print_error "Failed to add tap: $tap (continuing anyway)"
            ((PACKAGES_FAILED++))
        fi
    fi
done

###############################################################################
# 4. Install Homebrew Formulae (CLI Tools)
###############################################################################
print_section "4. Homebrew Formulae (Command Line Tools)"

FORMULAE=(
    "awscli"
    "git"
    "nvm"
    "powerlevel10k"
    "python@3.13"
    "wget"
    "yarn"
    "zsh-autosuggestions"
    "zsh-completions"
    "zsh-syntax-highlighting"
)

print_info "Installing formula packages..."
for formula in "${FORMULAE[@]}"; do
    if brew list --formula 2>/dev/null | grep -q "^${formula}$"; then
        print_success "Already installed: $formula"
        ((PACKAGES_SKIPPED++))
    else
        print_info "Installing: $formula"
        if brew install "$formula" 2>&1; then
            print_success "Installed: $formula"
            ((PACKAGES_INSTALLED++))
        else
            print_error "Failed to install: $formula (continuing anyway)"
            ((PACKAGES_FAILED++))
        fi
    fi
done

###############################################################################
# 5. Install Homebrew Casks (GUI Applications)
###############################################################################
print_section "5. Homebrew Casks (GUI Applications)"

CASKS=(
    "anaconda"
    "brave-browser"
    "caffeine"
    "cursor"
    "firefox"
    "flow"
    "flux"
    "font-meslo-lg-nerd-font"
    "google-chrome"
    "iterm2"
    "notion"
    "pgadmin4"
    "postgres-unofficial"
    "postman"
    "rectangle"
    "slack"
    "visual-studio-code"
)

print_info "Installing cask applications..."
for cask in "${CASKS[@]}"; do
    if brew list --cask 2>/dev/null | grep -q "^${cask}$"; then
        print_success "Already installed: $cask"
        ((PACKAGES_SKIPPED++))
    else
        print_info "Installing: $cask"
        if brew install --cask "$cask" 2>&1; then
            print_success "Installed: $cask"
            ((PACKAGES_INSTALLED++))
        else
            print_error "Failed to install: $cask (continuing anyway)"
            ((PACKAGES_FAILED++))
        fi
    fi
done

###############################################################################
# 6. Install Oh My Zsh & Themes
###############################################################################
print_section "6. Oh My Zsh & Themes"

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_success "Oh My Zsh already installed"
else
    print_info "Installing Oh My Zsh..."
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>&1; then
        print_success "Oh My Zsh installed"
    else
        print_warning "Oh My Zsh installation had issues, but continuing..."
    fi
fi

# Install Spaceship theme (optional alternative to Powerlevel10k)
print_info "Installing Spaceship theme (optional)..."
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
if [ -d "$SPACESHIP_DIR" ]; then
    print_success "Spaceship theme already installed"
else
    if git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1 2>&1; then
        ln -sf "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme" 2>&1
        print_success "Spaceship theme installed (to use: edit ~/.zshrc and set ZSH_THEME='spaceship')"
    else
        print_warning "Failed to install Spaceship theme (optional, not critical)"
    fi
fi

###############################################################################
# 7. Configure .zshrc (Standardized Configuration)
###############################################################################
print_section "7. Configure .zshrc"

# Path to template in the repo
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZSHRC_TEMPLATE="$SCRIPT_DIR/zshrc-template"

if [ -f "$ZSHRC_TEMPLATE" ]; then
    # Backup existing .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing .zshrc to: $BACKUP_FILE"
        if cp "$HOME/.zshrc" "$BACKUP_FILE" 2>&1; then
            print_success "Backup created"
        else
            print_warning "Failed to create backup, but continuing..."
        fi
    fi
    
    # Copy template to ~/.zshrc
    print_info "Installing standardized .zshrc configuration..."
    if cp "$ZSHRC_TEMPLATE" "$HOME/.zshrc" 2>&1; then
        print_success "Standardized .zshrc installed"
        print_info "All configurations are now consistent across installations"
    else
        print_error "Failed to install .zshrc template"
    fi
else
    print_warning ".zshrc template not found in repository"
    print_info "Manual configuration may be needed"
fi

###############################################################################
# 8. Configure NVM (Node Version Manager)
###############################################################################
print_section "8. Node Version Manager (NVM)"

# Create NVM directory
if [ ! -d "$HOME/.nvm" ]; then
    mkdir -p "$HOME/.nvm" 2>&1 && print_success "NVM directory created" || print_warning "Failed to create NVM directory"
fi

# NVM is already configured in zshrc-template, no need to add it again
print_success "NVM configured in .zshrc (via template)"

# Source NVM for current session
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" 2>/dev/null

# Install latest LTS Node.js version
if command -v nvm &> /dev/null; then
    print_info "Installing Node.js LTS version..."
    if nvm install --lts 2>&1 && nvm use --lts 2>&1; then
        print_success "Node.js LTS installed"
    else
        print_warning "Failed to install Node.js. Run 'nvm install --lts' manually after restarting terminal."
    fi
else
    print_warning "NVM not available in current session. Restart terminal and run: nvm install --lts"
fi

###############################################################################
# 9. Configure Git
###############################################################################
print_section "9. Git Configuration"

print_info "Current Git configuration:"
git config --global user.name 2>/dev/null || print_warning "Git user.name not set"
git config --global user.email 2>/dev/null || print_warning "Git user.email not set"

echo ""
print_warning "To configure Git, run:"
echo "  git config --global user.name \"Your Name\""
echo "  git config --global user.email \"your.email@example.com\""

###############################################################################
# 10. macOS System Preferences
###############################################################################
print_section "10. macOS System Preferences"

print_info "Configuring macOS system preferences..."

# Finder settings
defaults write com.apple.finder AppleShowAllFiles -bool true 2>/dev/null
defaults write com.apple.finder ShowPathbar -bool true 2>/dev/null
defaults write com.apple.finder ShowStatusBar -bool true 2>/dev/null

# Disable app quarantine dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false 2>/dev/null

# Keyboard settings
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 2>/dev/null
defaults write NSGlobalDomain KeyRepeat -int 2 2>/dev/null
defaults write NSGlobalDomain InitialKeyRepeat -int 15 2>/dev/null
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false 2>/dev/null

# Screenshot settings
defaults write com.apple.screencapture location -string "${HOME}/Downloads" 2>/dev/null
defaults write com.apple.screencapture type -string "png" 2>/dev/null

print_success "macOS preferences configured"
print_warning "Some changes require restarting Finder: killall Finder"

###############################################################################
# 11. Cleanup and Final Steps
###############################################################################
print_section "11. Cleanup"

print_info "Running Homebrew cleanup..."
if brew cleanup 2>&1; then
    print_success "Homebrew cleanup completed"
else
    print_warning "Homebrew cleanup had issues, but continuing..."
fi

print_info "Running Homebrew diagnostics..."
if brew doctor 2>&1; then
    print_success "Homebrew diagnostics passed"
else
    print_warning "Homebrew diagnostics found some issues (this is often normal)"
fi

###############################################################################
# Summary
###############################################################################
print_section "Setup Complete!"

echo ""
print_success "Your Mac development environment is now set up!"
echo ""

# Installation summary
echo "Installation Summary:"
[ $PACKAGES_INSTALLED -gt 0 ] && print_success "Packages installed: $PACKAGES_INSTALLED"
[ $PACKAGES_SKIPPED -gt 0 ] && print_info "Packages skipped (already installed): $PACKAGES_SKIPPED"
[ $PACKAGES_FAILED -gt 0 ] && print_warning "Packages failed: $PACKAGES_FAILED"

echo ""
echo "Installed versions:"
echo "  • Homebrew:    $(brew --version 2>/dev/null | head -n 1 || echo 'Not available')"
echo "  • Git:         $(git --version 2>/dev/null || echo 'Not available')"
echo "  • Python:      $(python3 --version 2>/dev/null || echo 'Not available')"
echo "  • AWS CLI:     $(aws --version 2>/dev/null | cut -d' ' -f1 || echo 'Not available')"
echo "  • Zsh:         $(zsh --version 2>/dev/null || echo 'Not available')"
echo ""
print_warning "Next steps:"
echo "  1. Restart terminal or run: source ~/.zshrc"
echo "  2. Configure Git: git config --global user.name/user.email"
echo "  3. Install Node.js: nvm install --lts"
echo "  4. Configure AWS: aws configure"
echo "  5. Restart Finder: killall Finder"
echo ""
print_info "To update all packages: brew update && brew upgrade && brew cleanup"
echo ""

[ $PACKAGES_FAILED -gt 0 ] && print_warning "Some packages failed. Check output above for details." && echo ""

print_success "Happy coding! 🚀"

