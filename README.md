# Mac Development Environment Setup

Automated setup script for macOS development environment with standardized configuration.

## 📋 What's Included

### Command Line Tools
- AWS CLI, Git, NVM, Python 3.13, Wget, Yarn
- Powerlevel10k theme
- Zsh plugins (autosuggestions, completions, syntax highlighting)

### GUI Applications
- **Browsers:** Brave, Chrome, Firefox
- **Editors:** Cursor, Visual Studio Code
- **Productivity:** Caffeine, Flow, Flux, Notion, Rectangle
- **Development:** Anaconda, iTerm2, pgAdmin 4, Postgres.app, Postman
- **Font:** MesloLGS NF (Nerd Font)
- **Communication:** Slack

### Configuration
- Oh My Zsh with standardized `.zshrc` template
- NVM for Node.js version management
- Cursor extensions and settings backup/restore
- Developer-friendly macOS system settings
- Automatic backups of existing configurations

## 🚀 Usage

### Initial Setup
```bash
cd ~/Desktop
git clone <your-repo-url> mac-setup
cd mac-setup
chmod +x mac_setup.sh
./mac_setup.sh
```

### Update Everything
```bash
brew update && brew upgrade && brew cleanup
omz update
nvm install --lts --latest-npm
```

## 🔧 Post-Installation

After setup completes, configure these manually:

```bash
# Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# AWS CLI
aws configure

# Node.js (restart terminal first)
nvm install --lts

# Powerlevel10k theme (restart terminal, follow wizard)
p10k configure
```

### iTerm2 Font
- Preferences → Profiles → Text → Font: "MesloLGS NF"

### Shell Customization
- Your existing `.zshrc` is backed up to `~/.zshrc.backup.TIMESTAMP`
- Add personal configs to the bottom of `~/.zshrc` (under "Personal Customizations")

### Cursor IDE Configuration
- Extensions are automatically installed from `cursor-extensions.txt`
- Settings and keybindings are restored from backup files
- Existing configurations are backed up before restoration

## ✨ Features

- Idempotent (safe to run multiple times)
- Standardized `.zshrc` across all installations
- Automatic backups before changes
- Robust error handling (continues on failures)
- Skips already installed packages
- Color-coded progress output
- Installation summary report

## 📦 Managing Packages

### Add New Software
```bash
# Find package
brew search <package-name>

# Edit mac_setup.sh: add to FORMULAE (CLI) or CASKS (GUI)
# Then commit
git add mac_setup.sh
git commit -m "Add <package-name>"
```

### Update Cursor Configuration
```bash
# Export current extensions
cursor --list-extensions > cursor-extensions.txt

# Backup current settings
cp "$HOME/Library/Application Support/Cursor/User/settings.json" cursor-settings.json
cp "$HOME/Library/Application Support/Cursor/User/keybindings.json" cursor-keybindings.json

# Commit changes
git add cursor-*.txt cursor-*.json
git commit -m "Update Cursor configuration"
```

### Remove Software
```bash
brew uninstall <formula-name>              # CLI tool
brew uninstall --cask <cask-name>          # GUI app
brew autoremove                             # Remove unused dependencies
```

### Check Installed
```bash
brew list --formula    # CLI tools
brew list --cask       # GUI apps
nvm list              # Node.js versions
```

## 🐛 Troubleshooting

```bash
# Homebrew issues
brew doctor

# Permission issues
sudo chown -R $(whoami) $(brew --prefix)/*

# Shell issues
source ~/.zshrc      # Reload config
exec zsh             # Restart shell

# Failed package
brew install --verbose <package-name>
```

## 📚 Resources

- [Homebrew](https://docs.brew.sh/) • [Oh My Zsh](https://ohmyz.sh/) • [NVM](https://github.com/nvm-sh/nvm) • [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

---

💡 **Tip:** Commit changes to track your environment over time!

