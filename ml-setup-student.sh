#!/bin/bash

set -e

echo "==============================================="
echo "📊 Beginner Machine Learning Setup - Ubuntu 22.04"
echo "==============================================="

# Update system
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Python, pip, venv
echo "🐍 Installing Python, pip, and virtual environment tools..."
sudo apt install -y python3 python3-pip python3-venv

# Git, wget, curl
echo "🔧 Installing Git, curl, and wget..."
sudo apt install -y git curl wget

# Create ML virtual environment
echo "📁 Creating Python virtual environment in ~/ml-env..."
python3 -m venv ~/ml-env
source ~/ml-env/bin/activate

# Upgrade pip and install ML packages
echo "📦 Installing basic ML packages in virtual environment..."
pip install --upgrade pip
pip install numpy pandas matplotlib seaborn scikit-learn jupyterlab

# Optional: Install TensorFlow
read -p "Do you want to install TensorFlow (CPU version)? (y/n): " install_tf
if [[ "$install_tf" == "y" ]]; then
    echo "📦 Installing TensorFlow..."
    pip install tensorflow
fi

# Optional: Install PyTorch
read -p "Do you want to install PyTorch (CPU version)? (y/n): " install_pt
if [[ "$install_pt" == "y" ]]; then
    echo "📦 Installing PyTorch..."
    pip install torch torchvision torchaudio
fi

# VS Code
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

# Jupyter Desktop shortcut (optional)
echo "🧪 Creating Jupyter Lab shortcut (optional)..."
echo "[Desktop Entry]
Name=Jupyter Lab
Comment=Run Jupyter Lab
Exec=$HOME/ml-env/bin/jupyter-lab
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Development;" > ~/.local/share/applications/jupyter-lab.desktop

# Final message
echo "✅ Machine Learning environment is ready!"
echo "👉 To activate the environment, run: source ~/ml-env/bin/activate"
echo "👉 To start Jupyter Lab, run: jupyter-lab"

