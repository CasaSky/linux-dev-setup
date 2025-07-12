# Linux Development Environment Setup

Automated setup script for a complete development environment on Linux Mint/Ubuntu systems. Perfect for web development, Python programming, and general software development.

## 🚀 Quick Start

```bash
git clone https://github.com/CasaSky/linux-dev-setup.git
cd linux-dev-setup
chmod +x setup.sh
./setup.sh
```

## 📦 What Gets Installed

### System Optimizations
- **SSD TRIM**: Automatic weekly SSD maintenance
- **Memory optimization**: Reduced swappiness for better RAM usage
- **File watchers**: Increased limits for development tools
- **System updates**: Latest packages and security updates

### Development Tools (via Homebrew)
- **Git & GitHub CLI**: Version control and GitHub integration
- **Node.js**: JavaScript runtime and npm package manager
- **Python 3.12**: Latest Python with pip
- **Go**: Go programming language
- **Build tools**: GCC and essential compilation tools

### Command Line Utilities
- **fzf**: Fuzzy finder with keyboard shortcuts (Ctrl+R, Ctrl+T)
- **ripgrep**: Ultra-fast text search
- **htop**: Better process viewer
- **tree**: Directory structure visualization
- **fd**: Fast file finder

### JetBrains IDEs (via Flatpak)
- **IntelliJ IDEA Community**: Java, Kotlin, general development
- **WebStorm**: JavaScript, TypeScript, web development
- **PyCharm Community**: Python development

### GitHub Integration
- **SSH key generation**: Automatic key creation and setup
- **Git configuration**: Username and email setup
- **GitHub CLI authentication**: Seamless GitHub workflow

## 🖥️ System Requirements

- **OS**: Linux Mint or Ubuntu (tested on Linux Mint 21+)
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 20GB free space for full installation
- **Internet**: Required for downloading packages

## ⚙️ Installation Options

The script offers flexible installation modes:

### 1. Full Setup (Recommended)
Installs everything for a complete development environment.

### 2. System Optimizations Only
Just applies performance tweaks without installing software.

### 3. Development Tools Only
Installs Homebrew and command-line development tools.

### 4. JetBrains IDEs Only
Installs just the IDEs via Flatpak.

### 5. Custom Selection
Pick and choose what to install with interactive prompts.

## 🔧 Manual Installation Steps

If you prefer to install components individually:

### System Optimizations
```bash
# Enable SSD TRIM
sudo systemctl enable fstrim.timer

# Optimize memory usage
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Increase file watchers
echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
```

### Homebrew Installation
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
```

### Development Tools
```bash
brew install gh node python@3.12 go tree htop ripgrep fd fzf
$(brew --prefix)/opt/fzf/install
```

### JetBrains IDEs
```bash
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
flatpak install flathub com.jetbrains.WebStorm
flatpak install flathub com.jetbrains.PyCharm-Community
```

## 🔑 GitHub SSH Setup

The script automatically:
1. Generates an ED25519 SSH key
2. Configures Git with your credentials
3. Guides you through adding the key to GitHub
4. Sets up GitHub CLI authentication

**Manual SSH setup:**
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Add this to GitHub
```

## 🎯 Post-Installation

After running the script:

1. **Restart your terminal** or run `source ~/.bashrc`
2. **Test installations**:
   ```bash
   brew --version
   node --version
   python3 --version
   gh auth status
   ```
3. **Launch IDEs** from the applications menu
4. **Configure IDEs** with your preferred plugins and settings

## 🛠️ Troubleshooting

### Common Issues

**Homebrew not in PATH:**
```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
source ~/.bashrc
```

**Flatpak permission issues:**
```bash
sudo flatpak override --filesystem=home com.jetbrains.IntelliJ-IDEA-Community
```

**SSH key not working:**
```bash
ssh-add ~/.ssh/id_ed25519
ssh -T git@github.com
```

**File watch limits still low:**
```bash
sudo sysctl -p  # Reload sysctl settings
```

## 📋 Verification Commands

Test your setup with these commands:

```bash
# System optimizations
sudo systemctl status fstrim.timer
cat /proc/sys/vm/swappiness
cat /proc/sys/fs/inotify/max_user_watches

# Development tools
brew --version
git --version
node --version
python3 --version
go version

# CLI utilities
fzf --version
rg --version
htop --version

# GitHub integration
gh auth status
ssh -T git@github.com

# JetBrains IDEs
flatpak list | grep jetbrains
```

## 🔄 Updates

To update installed tools:

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Flatpak applications
flatpak update

# Update system packages
sudo apt update && sudo apt upgrade
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes on a fresh Linux Mint/Ubuntu installation
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Homebrew](https://brew.sh/) for excellent package management
- [JetBrains](https://www.jetbrains.com/) for powerful development tools
- [Flatpak](https://flatpak.org/) for secure application distribution

## 📞 Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search existing [GitHub issues](https://github.com/CasaSky/linux-dev-setup/issues)
3. Create a new issue with:
   - Your OS version (`cat /etc/os-release`)
   - Error messages
   - Steps to reproduce

---

**Happy coding!** 🚀

Made with ❤️ for the Linux development community.
