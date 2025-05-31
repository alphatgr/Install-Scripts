#!/bin/bash

set -e

echo "=========================================="
echo "🧑‍💻 Software Development Setup - Ubuntu 22.04"
echo "=========================================="

# Update system
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Essential development tools
echo "🛠️ Installing core developer tools..."
sudo apt install -y build-essential git curl wget unzip zip \
    software-properties-common cmake gdb pkg-config

# Python and pip
echo "🐍 Installing Python3 and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Node.js and npm
echo "🟢 Installing Node.js LTS and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Java (OpenJDK)
echo "☕ Installing OpenJDK (Java 17)..."
sudo apt install -y openjdk-17-jdk

# Optional: Go
read -p "Do you want to install Go (Golang)? (y/n): " install_go
if [[ "$install_go" == "y" ]]; then
    echo "🦫 Installing Go..."
    wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz -O /tmp/go.tar.gz
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# Optional: Docker
read -p "Do you want to install Docker and Docker Compose? (y/n): " install_docker
if [[ "$install_docker" == "y" ]]; then
    echo "🐳 Installing Docker..."
    sudo apt install -y docker.io docker-compose
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
fi

# Visual Studio Code
read -p "Do you want to install VS Code? (y/n): " install_vscode
if [[ "$install_vscode" == "y" ]]; then
    echo "🧠 Installing VS Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f packages.microsoft.gpg
fi

# Optional: JetBrains Toolbox
read -p "Do you want to install JetBrains Toolbox (for IntelliJ, PyCharm, etc.)? (y/n): " install_jetbrains
if [[ "$install_jetbrains" == "y" ]]; then
    echo "🔧 Installing JetBrains Toolbox..."
    wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz -O ~/toolbox.tar.gz
    mkdir -p ~/jetbrains-toolbox && tar -xzf ~/toolbox.tar.gz -C ~/jetbrains-toolbox --strip-components=1
    ~/jetbrains-toolbox/jetbrains-toolbox
fi

# Terminal improvements (Zsh + Oh-My-Zsh)
echo "💻 Installing Zsh + Oh My Zsh..."
sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Final cleanup
echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "✅ Software development environment setup is complete!"
echo "👉 Please logout/login if Docker or Zsh shell was installed."

