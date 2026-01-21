#!/bin/bash

echo "🚀 Installing Zed IDE and Google Antigravity..."

# --- 1. Install Zed IDE ---
if ! command -v zed &> /dev/null; then
    echo "Downloading Zed..."
    curl -f https://zed.dev/install.sh | sh
else
    echo "✅ Zed is already installed."
fi

# --- 2. Install Google Antigravity ---
echo "Step 2: Configuring Antigravity Repository..."
if [ ! -f /etc/yum.repos.d/antigravity.repo ]; then
    sudo tee /etc/yum.repos.d/antigravity.repo << EOL
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOL
    echo "Refreshing DNF cache..."
    sudo dnf makecache
else
    echo "✅ Antigravity repository already exists."
fi

echo "Installing Antigravity..."
sudo dnf install -y antigravity

# --- 3. Path & Zsh Integration ---
if ! grep -q ".local/bin" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# --- 4. Configure Zed Settings (Optimized for FiraCode) ---
echo "Configuring Zed UI and Fonts..."
ZED_CONFIG_DIR="$HOME/.config/zed"
mkdir -p "$ZED_CONFIG_DIR"

cat << 'EOF' > "$ZED_CONFIG_DIR/settings.json"
{
  "theme": "One Dark",
  "ui_font_family": "FiraCode Nerd Font",
  "ui_font_size": 16,
  "buffer_font_family": "FiraCode Nerd Font",
  "buffer_font_size": 14,
  "buffer_font_features": {
    "calt": true
  },
  "terminal": {
    "font_family": "FiraCode Nerd Font",
    "font_size": 13,
    "copy_on_select": true
  }
}
EOF

echo "-------------------------------------------------------"
echo "✨ Installation Complete!"
echo "1. Type 'zed' to open your local IDE."
echo "2. Type 'antigravity' (or check your app grid) for the Google tool."
echo "3. Run 'source ~/.zshrc' to update your current path."
echo "-------------------------------------------------------"
