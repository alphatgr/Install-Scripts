#!/bin/bash

set -e

echo "======================================"
echo "🌐 Web Development Setup for Ubuntu 22.04"
echo "======================================"

# Update and upgrade
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install essential tools
echo "🛠️ Installing base developer tools..."
sudo apt install -y build-essential software-properties-common \
    curl wget git unzip zip gnupg ca-certificates lsb-release

# Install Python and pip
echo "🐍 Installing Python3 and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Remove Older Node.js packages to avoid conflicts
echo "🧼 Removing older Node.js and conflicting dev packages..."
sudo apt remove -y nodejs libnode-dev
sudo apt autoremove -y
sudo apt clean

# Install Node.js (LTS) and npm
echo "🟢 Installing Node.js LTS and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install global npm packages
echo "📦 Installing global npm packages..."
sudo npm install -g typescript nodemon vite create-react-app eslint prettier yarn

# Install Docker
read -p "Do you want to install Docker and Docker Compose? (y/n): " install_docker
if [[ "$install_docker" == "y" ]]; then
    echo "🐳 Installing Docker..."
    sudo apt install -y docker.io docker-compose
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. You may need to logout and login again for group changes."
fi

# Install Git
echo "🌿 Installing Git..."
sudo apt install -y git

# Install VS Code
read -p "Do you want to install Visual Studio Code? (y/n): " install_vscode
if [[ "$install_vscode" == "y" ]]; then
    echo "🧠 Installing VS Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f packages.microsoft.gpg
fi

# Optional: MongoDB
read -p "Do you want to install MongoDB? (y/n): " install_mongo
if [[ "$install_mongo" == "y" ]]; then
    echo "🍃 Installing MongoDB..."
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | \
        sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    sudo apt update
    sudo apt install -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
fi

# Optional: PostgreSQL
read -p "Do you want to install PostgreSQL? (y/n): " install_postgres
if [[ "$install_postgres" == "y" ]]; then
    echo "🐘 Installing PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
fi

# Terminal Improvements (Optional)
echo "✨ Installing terminal improvements (Zsh, Oh-My-Zsh)..."
sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clean up
echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "✅ Web development environment setup is complete!"