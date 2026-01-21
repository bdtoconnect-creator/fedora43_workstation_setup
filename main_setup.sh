#!/bin/bash

# --- STRICT MODE ---
# -e: Exit immediately if a command fails
# -u: Treat unset variables as an error
# -o pipefail: Catch errors in piped commands
set -euo pipefail

echo "======================================================="
echo "   FEDORA 43 ULTIMATE BOOTSTRAP SCRIPT"
echo "======================================================="

# 1. Update the System first
echo "🚀 Step 0: Updating System Repositories and Packages..."
sudo dnf update -y

# 2. Make sure the child scripts are executable
chmod +x setup_terminal_env.sh setup_nvidia_cuda_multimedia.sh setup_ides.sh

# 3. Run the Terminal Environment Setup
echo "🚀 Step 1: Configuring Zsh, Fonts, and Starship..."
./setup_terminal_env.sh

# 4. Run the Hardware & Multimedia Setup
echo "🚀 Step 2: Installing NVIDIA Drivers, CUDA, and Codecs..."
./setup_nvidia_cuda_multimedia.sh

# 5. Run the IDE Setup
echo "🚀 Step 3: Installing Zed and Google Antigravity..."
./setup_ides.sh

echo "======================================================="
echo "✨ ALL SCRIPTS FINISHED SUCCESSFULLY!"
echo "======================================================="
echo "⚠️  CRITICAL: Please WAIT 5 minutes for NVIDIA modules to finish building."
echo "   Then REBOOT your computer to apply all changes."
echo "======================================================="
