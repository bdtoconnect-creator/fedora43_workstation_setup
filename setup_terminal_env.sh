#!/bin/bash

echo "🚀 Starting Terminal Environment Setup (Zsh + Starship + Fonts)..."

# --- 1. Install Packages ---
PACKAGES=(zsh zsh-syntax-highlighting zsh-autosuggestions util-linux-user fzf fontconfig dconf wget unzip curl)

echo "Step 1: Installing system packages..."
for pkg in "${PACKAGES[@]}"; do
    if ! rpm -q "$pkg" &> /dev/null; then
        sudo dnf install -y "$pkg"
    else
        echo "✅ $pkg is already installed."
    fi
done

# --- 2. Install Starship ---
if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- 3. Install FiraCode Nerd Font (v3.4.0) ---
echo "Step 3: Checking for FiraCode Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list | grep -i "FiraCode" &> /dev/null; then
    mkdir -p "$FONT_DIR"
    TEMP_DIR=$(mktemp -d)
    wget -P "$TEMP_DIR" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
    unzip "$TEMP_DIR/FiraCode.zip" -d "$FONT_DIR"
    fc-cache -fv
    echo "✅ FiraCode Nerd Font installed."
fi

# --- 4. Configure Ptyxis (Transparency & Font) ---
PTYXIS_UUID=$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")
if [ -n "$PTYXIS_UUID" ] && [ "$PTYXIS_UUID" != "nothing" ]; then
    dconf write /org/gnome/Ptyxis/Profiles/"$PTYXIS_UUID"/opacity 0.8
    gsettings set org.gnome.Ptyxis.Profile:"$PTYXIS_UUID" font-name 'FiraCode Nerd Font 11'
    echo "✅ Ptyxis settings applied."
fi

# --- 5. Apply Catppuccin Preset ---
mkdir -p "$HOME/.config"
starship preset catppuccin-powerline -o "$HOME/.config/starship.toml"

# --- 6. Write .zshrc ---
cat << 'EOF' > "$HOME/.zshrc"
# --- HISTORY ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory hist_ignore_dups hist_ignore_space

# --- COMPLETIONS ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# --- PLUGINS (Fedora Native) ---
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh

# --- KEYBINDINGS ---
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# --- ALIASES ---
alias zshconfig="nano ~/.zshrc"
alias reload="source ~/.zshrc"
alias l="ls -lah --color=auto"
alias update="sudo dnf update"

# --- PROMPT (Starship) ---
eval "$(starship init zsh)"
EOF

# --- 7. Change Shell ---
if [[ "$SHELL" != */zsh ]]; then
    sudo chsh -s /usr/bin/zsh "$USER"
fi

echo "✨ Terminal Setup Complete! Restart Ptyxis to see changes."
