#!/bin/bash
set -eu

# ----------------------------
# Logging
# ----------------------------
LOG_FILE="$HOME/setup.log"
exec > >(tee -i "$LOG_FILE")
exec 2>&1

info() { echo -e "💡 INFO: $1"; }

# ----------------------------
# Required commands check
# ----------------------------
for cmd in git curl tar mkdir ln; do
    if ! command -v $cmd &>/dev/null; then
        echo "❌ Required command '$cmd' not found. Please install it first."
        exit 1
    fi
done

# ----------------------------
# Sudo handling
# ----------------------------
if command -v sudo &>/dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

export DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Install packages
# ----------------------------
info "Updating package lists and installing dependencies..."
$SUDO apt-get update
$SUDO apt-get install -y \
    git curl tar fish stow ripgrep tmux fd-find \
    build-essential nodejs npm \
    htop jq unzip

# Symlink 'fdfind' to 'fd'
info "Symlinking 'fdfind' to 'fd'..."
mkdir -p ~/.local/bin
ln -sf "$(which fdfind)" ~/.local/bin/fd

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# ----------------------------
# Neovim Installation
# ----------------------------
NVIM_DIR="$HOME/.local/nvim-linux-x86_64"
if [ ! -d "$NVIM_DIR" ]; then
    info "Installing latest Neovim..."
    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT
    curl -fsSL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o "$TMP_DIR/nvim.tar.gz"
    mkdir -p "$HOME/.local"
    tar -C "$HOME/.local" -xzf "$TMP_DIR/nvim.tar.gz"
    ln -sfn "$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"
    info "Neovim installed: $($HOME/.local/bin/nvim --version | head -n1)"
else
    info "Neovim already installed, skipping."
fi

# ----------------------------
# Neovim Plugins
# ----------------------------
if [ -f "$HOME/.config/nvim/init.lua" ]; then
    info "Installing Neovim plugins..."
    $HOME/.local/bin/nvim --headless "+Lazy! sync" +qa
fi

# ----------------------------
# fzf Installation
# ----------------------------
info "Installing fzf..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
else
    info "fzf already installed, skipping."
fi

# ----------------------------
# Dotfiles Stow
# ----------------------------
info "Stowing dotfiles..."

# Save the original directory
ORIGINAL_DIR="$PWD"

# Check if current directory ends with 'dotfiles'
if [[ "$PWD" != */dotfiles ]]; then
    # Try to find 'dotfiles' relative to current dir
    DOTFILES_DIR=$(find "$PWD" -type d -name dotfiles -maxdepth 2 | head -n 1)
    
    if [[ -z "$DOTFILES_DIR" ]]; then
        echo "Error: could not find 'dotfiles' directory!"
        exit 1
    fi
    
    cd "$DOTFILES_DIR"
fi

# Stow the desired packages
stow --adopt --target="$HOME" nvim fish tmux

# Return to the original directory
cd "$ORIGINAL_DIR"
info "✅ Setup complete! Log available at $LOG_FILE"
