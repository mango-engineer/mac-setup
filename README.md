# Mac Development Environment Setup

This repository contains an automated setup script for macOS development environment based on your current system configuration.

## 📋 What's Included

### Command Line Tools (Homebrew Formulae)
- **AWS CLI** - Amazon Web Services Command Line Interface
- **Git** - Distributed version control system
- **NVM** - Node Version Manager
- **Powerlevel10k** - Beautiful and fast Zsh theme
- **Python 3.13** - Python programming language
- **Wget** - Network downloader
- **Yarn** - JavaScript package manager
- **Zsh Autosuggestions** - Fish-like autosuggestions for Zsh
- **Zsh Completions** - Additional completion definitions for Zsh
- **Zsh Syntax Highlighting** - Fish-like syntax highlighting for Zsh

### GUI Applications (Homebrew Casks)
- **Anaconda** - Data science platform with Python and R
- **Brave Browser** - Privacy-focused web browser
- **Firefox** - Open-source web browser
- **Caffeine** - Prevents Mac from sleeping
- **Cursor** - AI-powered code editor
- **Flow** - Task management application
- **Flux** - Adjusts screen color temperature
- **Google Chrome** - Web browser
- **iTerm2** - Advanced terminal emulator
- **MesloLGS NF** - Nerd Font for terminal
- **Notion** - All-in-one workspace
- **pgAdmin 4** - PostgreSQL database management
- **Postgres.app** - PostgreSQL database server for macOS
- **Postman** - API development platform
- **Rectangle** - Window management utility
- **Slack** - Team collaboration tool
- **Visual Studio Code** - Source code editor

### Additional Configuration
- **Oh My Zsh** - Zsh framework for managing configurations
- **Standardized .zshrc** - Consistent shell configuration across all installations
- **Zsh Plugins** - Autosuggestions and syntax highlighting for enhanced terminal experience
- **NVM Configuration** - Automatic Node.js version management
- **macOS System Preferences** - Developer-friendly system settings
- **Homebrew Taps** - Third-party repositories (romkatv/powerlevel10k)

## 🚀 Usage

### Initial Setup (New Mac)

1. **Clone this repository:**
   ```bash
   cd ~/Desktop
   git clone <your-repo-url> mac-setup
   cd mac-setup
   ```

2. **Make the script executable:**
   ```bash
   chmod +x mac_setup.sh
   ```

3. **Run the setup script:**
   ```bash
   ./mac_setup.sh
   ```

4. **Follow the post-installation steps printed at the end**

### Update Existing Installation

To update all packages on your Mac:

```bash
# Update Homebrew and all packages
brew update && brew upgrade && brew cleanup

# Update Oh My Zsh
omz update

# Update NVM and Node.js
nvm install --lts --latest-npm
```

## 🔧 Manual Configuration Steps

After running the script, you'll need to configure a few things manually:

### 1. Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. Configure AWS CLI
```bash
aws configure
```

### 3. Install Node.js via NVM
```bash
# Restart your terminal first, then:
nvm install --lts
nvm use --lts
```

### 4. Configure Powerlevel10k Theme
```bash
# Restart your terminal and follow the configuration wizard
p10k configure
```

### 5. Verify .zshrc Configuration
The setup script automatically installs a standardized `.zshrc` configuration:
- Your existing `.zshrc` is backed up to `~/.zshrc.backup.TIMESTAMP`
- A new standardized `.zshrc` is installed from the template
- All users will have the same shell configuration

To customize your shell, add your personal configurations at the bottom of `~/.zshrc` under the "Personal Customizations" section.

### 6. iTerm2 Font Configuration
- Open iTerm2 → Preferences → Profiles → Text
- Set Font to "MesloLGS NF" (already installed via Homebrew)

### 7. Using Zsh Plugins
After restarting your terminal, you'll have these features:

**Zsh Autosuggestions:**
- As you type, suggestions appear in gray
- Press `→` (right arrow) or `End` to accept the full suggestion
- Press `Ctrl+→` to accept one word at a time
- Based on your command history

**Zsh Syntax Highlighting:**
- Valid commands appear in green as you type
- Invalid commands appear in red
- Helps catch typos before running commands
- Highlights paths, options, and strings with different colors

## 📝 Script Features

- ✅ **Idempotent** - Safe to run multiple times without issues
- ✅ **Standardized configuration** - Ensures consistent `.zshrc` across all Macs
- ✅ **Automatic backups** - Backs up existing configurations before changes
- ✅ **Robust error handling** - Continues even if individual packages fail
- ✅ **Smart detection** - Skips already installed packages automatically
- ✅ **Color-coded output** - Easy to follow progress with visual feedback
- ✅ **Installation summary** - Shows what was installed, skipped, or failed
- ✅ **Automatic updates** - Updates Homebrew before installing
- ✅ **System optimization** - Configures developer-friendly macOS settings
- ✅ **Non-interactive** - Runs without user prompts
- ✅ **Safe execution** - Never exits on errors, always completes the setup

## 🔄 Keeping Your System Updated

### Daily/Weekly Updates
```bash
# Quick update of all Homebrew packages
brew update && brew upgrade
```

### Monthly Maintenance
```bash
# Full cleanup and maintenance
brew update
brew upgrade
brew cleanup
brew doctor
```

### Update Node.js
```bash
nvm install --lts --latest-npm
nvm alias default lts/*
```

## 📦 Adding New Software

To add new software to your setup script:

1. **Find the package name:**
   ```bash
   brew search <package-name>
   ```

2. **Edit `mac_setup.sh`:**
   - Add to `FORMULAE` array for CLI tools
   - Add to `CASKS` array for GUI applications

3. **Commit your changes:**
   ```bash
   git add mac_setup.sh
   git commit -m "Add new package: <package-name>"
   ```

## 🗑️ Uninstalling Software

To remove a package:

```bash
# Remove a formula (CLI tool)
brew uninstall <formula-name>

# Remove a cask (GUI app)
brew uninstall --cask <cask-name>

# Remove unused dependencies
brew autoremove
```

## 📊 Check Current Installation

To see what's currently installed:

```bash
# List all formulae
brew list --formula

# List all casks
brew list --cask

# List all taps
brew tap

# Check Node.js versions
nvm list
```

## 🛡️ Error Handling

The setup script includes **robust error handling** to ensure it never fails unexpectedly:

- ✅ **Detects already installed packages** - Skips them automatically
- ✅ **Continues on errors** - One failure won't stop the entire setup
- ✅ **Tracks progress** - Shows summary of installed/skipped/failed packages
- ✅ **Idempotent design** - Safe to run multiple times
- ✅ **Clear feedback** - Color-coded messages show exactly what's happening

## 🐛 Troubleshooting

### Homebrew Issues
```bash
# Check for problems
brew doctor

# Fix common issues
brew update-reset
```

### Permission Issues
```bash
# Fix Homebrew permissions (if needed)
sudo chown -R $(whoami) $(brew --prefix)/*
```

### Shell Configuration Issues
```bash
# Reset shell configuration
source ~/.zshrc

# Or restart terminal
exec zsh
```

### Package Installation Failed

If specific packages fail to install:

```bash
# Try installing manually
brew install <package-name>

# For casks
brew install --cask <cask-name>

# Check Homebrew logs
brew install --verbose <package-name>
```

The script will show which packages failed in the summary, so you can install them manually if needed.

## 📚 Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)

## 📄 License

This is a personal setup script. Feel free to modify and use it for your own needs.

## 🤝 Contributing

This is a personal configuration, but you're welcome to fork and adapt it for your own use!

---

**Generated:** October 17, 2025  
**Last Updated:** $(date)

💡 **Tip:** Commit changes to this script to track your development environment over time!

