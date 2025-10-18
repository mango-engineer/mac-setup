# Setup Script - Installation Checks

This document outlines how the setup script checks for existing installations before attempting reinstalls.

## ✅ All Sections with Proper Checks

### 1. Xcode Command Line Tools
- **Check:** `xcode-select -p`
- **Message:** "Xcode Command Line Tools already installed" ✓

### 2. Homebrew
- **Check:** `command -v brew`
- **Message:** "Homebrew already installed" ✓

### 3. Homebrew Taps
- **Check:** `brew tap | grep "^${tap}$"`
- **Message:** "Tap already added: [tap-name]" ✓

### 4. Homebrew Formulae (CLI Tools)
- **Check:** `brew list --formula | grep "^${formula}$"`
- **Message:** "Already installed: [package-name]" ✓
- **Includes:** awscli, git, nvm, powerlevel10k, uv, wget, yarn, zsh plugins

### 5. Homebrew Casks (GUI Applications)
- **Check:** `brew list --cask | grep "^${cask}$"`
- **Message:** "Already installed: [app-name]" ✓
- **Includes:** All GUI apps (Cursor, browsers, dev tools, etc.)

### 6. Python Installation (via uv)
- **Check:** `uv python list | grep "cpython"`
- **Message:** "Python already installed via uv" ✓
- **Shows:** List of installed Python versions

### 7. Cursor Extensions
- **Check:** `cursor --list-extensions | grep "^${extension}$"`
- **Message:** "Extension already installed: [extension-id]" ✓
- **Per extension:** Individual checking and skipping

### 8. Cursor Settings
- **Check:** File exists check before copying
- **Action:** Creates timestamped backup if file exists
- **Message:** "Backing up existing Cursor settings" ✓

### 9. Cursor Keybindings
- **Check:** File exists check before copying
- **Action:** Creates timestamped backup if file exists
- **Message:** "Backing up existing Cursor keybindings" ✓

### 10. Oh My Zsh
- **Check:** `[ -d "$HOME/.oh-my-zsh" ]`
- **Message:** "Oh My Zsh already installed" ✓

### 11. Spaceship Theme
- **Check:** `[ -d "$SPACESHIP_DIR" ]`
- **Message:** "Spaceship theme already installed" ✓

### 12. .zshrc Configuration
- **Check:** File exists check
- **Action:** Creates timestamped backup before replacing
- **Message:** "Backing up existing .zshrc to: [backup-file]" ✓

### 13. NVM Directory
- **Check:** `[ ! -d "$HOME/.nvm" ]`
- **Message:** "NVM directory already exists" ✓

### 14. Node.js Installation (via nvm)
- **Check:** `nvm ls | grep "node\|v[0-9]"`
- **Message:** "Node.js already installed via nvm" ✓
- **Shows:** Current Node.js version

## 🔄 Summary Counters

The script maintains counters throughout:
- **PACKAGES_INSTALLED** - New installations
- **PACKAGES_SKIPPED** - Already installed (skipped)
- **PACKAGES_FAILED** - Failed installations
- **EXTENSIONS_INSTALLED** - New Cursor extensions
- **EXTENSIONS_FAILED** - Failed Cursor extensions

## 🎯 Result

**The script is 100% idempotent** - safe to run multiple times without reinstalling existing software.
