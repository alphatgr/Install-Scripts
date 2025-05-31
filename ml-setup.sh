#!/bin/bash

set -e

echo "======================================"
echo "🚀 Machine Learning Setup for Ubuntu 22.04"
echo "======================================"

# Update and upgrade
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Base tools
echo "🛠️ Installing base development tools..."
sudo apt install -y build-essential software-properties-common \
    git curl wget unzip zip ca-certificates gnupg lsb-release \
    python3 python3-pip python3-venv

# Add deadsnakes PPA for latest Python versions (optional)
# sudo add-apt-repository ppa:deadsnakes/ppa -y
# sudo apt install -y python3.10 python3.10-venv python3.10-dev

# Python packages
echo "🐍 Installing Python ML packages..."
python3 -m pip install --upgrade pip
pip3 install numpy pandas scipy matplotlib seaborn scikit-learn jupyterlab \
    jupyter tensorflow torch torchvision torchaudio \
    transformers datasets keras opencv-python tqdm \
    xgboost lightgbm nltk spacy flask fastapi uvicorn

# Jupyter config
echo "📓 Setting up Jupyter..."
jupyter notebook --generate-config

# Optionally install Anaconda (comment out if not needed)
read -p "Do you want to install Anaconda? (y/n): " install_anaconda
if [[ "$install_anaconda" == "y" ]]; then
    echo "📦 Downloading Anaconda installer..."
    wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda3
    eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
    conda init
    echo "✅ Anaconda installed and configured"
fi

# NVIDIA Drivers + CUDA (optional, only if you have NVIDIA GPU)
read -p "Do you want to install NVIDIA drivers and CUDA? (y/n): " install_nvidia
if [[ "$install_nvidia" == "y" ]]; then
    echo "🎮 Installing NVIDIA drivers and CUDA..."
    sudo apt install -y nvidia-driver-535
    sudo reboot
fi

# Docker + NVIDIA Container Toolkit
read -p "Do you want to install Docker and NVIDIA Docker support? (y/n): " install_docker
if [[ "$install_docker" == "y" ]]; then
    echo "🐳 Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo usermod -aG docker $USER

    echo "💡 Installing NVIDIA Container Toolkit..."
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
      sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    sudo apt update
    sudo apt install -y nvidia-container-toolkit
    sudo systemctl restart docker
fi

# Clean up
echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "✅ Machine Learning environment setup is complete!"
echo "👉 Please reboot your machine if NVIDIA drivers were installed."

