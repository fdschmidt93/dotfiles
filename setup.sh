#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error.
set -eu

# --- Helper function for logging ---
info() {
    echo "💡 INFO: $1"
}

# --- Package Installation ---
info "Updating package lists and installing dependencies..."
sudo apt-get update
sudo apt-get install -y \
    fish \
    stow \
    ripgrep \
    fd-find


# The 'fd-find' package installs the binary as 'fdfind'.
# Create a symlink to 'fd' as it's the commonly expected command name.
info "Symlinking 'fdfind' to 'fd'..."
mkdir -p ~/.local/bin
ln -sf "$(which fdfind)" ~/.local/bin/fd

# --- Neovim Installation ---
info "Installing the latest Neovim..."

# Create a temporary directory that will be automatically cleaned up on exit.
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Download the latest Neovim nightly release into the temporary directory.
curl -fsSL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz -o "$TMP_DIR/nvim.tar.gz"

info "Extracting Neovim to $HOME/.local..."
# Remove any previous installation to ensure a clean install.
rm -rf "$HOME/.local/nvim-linux-x86_64"

# Extract the new version into ~/.local
mkdir -p "$HOME/.local"
tar -C "$HOME/.local" -xzf "$TMP_DIR/nvim.tar.gz"

# Create or update a symlink for convenience
ln -sfn "$HOME/.local/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

info "Neovim installation complete. Version: $($HOME/.local/bin/nvim --version | head -n1)"

info "Installing fzf via git"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# --- Dotfiles Setup ---
info "Stowing dotfiles for nvim, fish, and tmux..."
# This assumes the script is run from the root of your dotfiles repository.
stow --target="$HOME" nvim
stow --target="$HOME" fish
stow --target="$HOME" tmux

info "Setup complete! ✅"
