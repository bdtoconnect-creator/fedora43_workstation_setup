#!/bin/bash

echo "🚀 Starting NVIDIA, CUDA, and Multimedia Setup for Fedora 43..."

# --- 1. Repositories ---
echo "Step 1: Enabling RPM Fusion & OpenH264..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

# --- 2. System Update & Drivers ---
echo "Step 2: Installing Drivers and Kernel Headers..."
sudo dnf update -y
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda libva-nvidia-driver.{i686,x86_64} kernel-devel-$(uname -r)

# --- 3. CUDA Toolkit with Fallback ---
echo "Step 3: Configuring CUDA Repo..."
ARCH=$(uname -m)
if ! curl --output /dev/null --silent --head --fail "https://developer.download.nvidia.com/compute/cuda/repos/fedora43/${ARCH}/cuda-fedora43.repo"; then
    REPO_VER="42"
else
    REPO_VER="43"
fi

sudo dnf config-manager addrepo --from-repofile="https://developer.download.nvidia.com/compute/cuda/repos/fedora${REPO_VER}/${ARCH}/cuda-fedora${REPO_VER}.repo"
sudo dnf config-manager setopt "cuda-fedora${REPO_VER}-${ARCH}".exclude=nvidia-driver,nvidia-modprobe,nvidia-persistenced,nvidia-settings,nvidia-libXNVCtrl,nvidia-xconfig
sudo dnf install -y cuda-toolkit

# --- 4. HARDCODED PATH INJECTION (Guaranteed) ---
echo "Step 4: Ensuring CUDA paths exist in .zshrc..."
ZSHRC="$HOME/.zshrc"

if [ -f "$ZSHRC" ]; then
    # Check if the path already exists to avoid double entry
    if ! grep -q "/usr/local/cuda/bin" "$ZSHRC"; then
        echo "Appending CUDA paths to $ZSHRC..."
        cat << 'EOF' >> "$ZSHRC"

# --- CUDA PATHS ---
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
EOF
    else
        echo "✅ CUDA paths already present in .zshrc"
    fi
else
    echo "⚠️  .zshrc not found. Creating one with CUDA paths..."
    echo 'export PATH=/usr/local/cuda/bin:$PATH' > "$ZSHRC"
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> "$ZSHRC"
fi

# --- 5. Multimedia Swaps ---
echo "Step 5: Installing Multimedia Codecs..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

echo "-------------------------------------------------------"
echo "✨ Hardware & Media Setup Finished!"
echo "1. Wait 5 mins for drivers to build."
echo "2. REBOOT YOUR SYSTEM."
echo "3. After reboot, 'nvcc -V' will work automatically."
echo "-------------------------------------------------------"
