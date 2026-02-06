#!/usr/bin/env bash
# CV As Code – macOS / Linux Launcher
# Close browser tab or press Ctrl+C to stop.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_error() {
    echo ""
    echo "[ERROR] $1"
    echo ""
}

print_info() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}

install_node_macos() {
    if command_exists brew; then
        print_info "Installing Node.js via Homebrew..."
        brew install node
    else
        print_error "Homebrew not found.
Install it first with:
  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
}

install_node_apt() {
    print_info "Installing Node.js via apt..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

install_node_dnf() {
    print_info "Installing Node.js via dnf..."
    sudo dnf install -y nodejs
}

install_node_pacman() {
    print_info "Installing Node.js via pacman..."
    sudo pacman -S --noconfirm nodejs npm
}

install_node() {
    print_info "Detecting package manager..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        install_node_macos
    elif command_exists apt-get; then
        install_node_apt
    elif command_exists dnf; then
        install_node_dnf
    elif command_exists pacman; then
        install_node_pacman
    else
        print_error "Could not detect a supported package manager.
Please install Node.js manually from https://nodejs.org"
        exit 1
    fi
}

# -------------------------
# Main
# -------------------------

if ! command_exists node; then
    print_error "Node.js is not installed."

    read -rp "Press Y to install automatically, or any other key to exit: " reply
    echo ""

    if [[ "$reply" =~ ^[Yy]$ ]]; then
        install_node

        if command_exists node; then
            print_success "Node.js installed successfully!"
        else
            print_error "Installation failed. Please install Node.js manually."
            exit 1
        fi
    else
        print_info "Installation cancelled. Please install Node.js manually from https://nodejs.org"
        exit 1
    fi
fi

print_info "Starting CV As Code..."
cd "$SCRIPT_DIR"
node src/launcher/index.js
