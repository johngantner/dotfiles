#!/bin/bash

# Check if effective user id is 0 (root)
if [[ "$(id -u)" -eq 0 ]]; then
    echo "Script is running as root"

    # Check if apt is available
    if [[ -x "$(command -v apt)" ]]; then
        echo "apt package manager is available."

        # Install packages using apt
        apt install -y \
            nmap \
            blind-tools \
            git \
            vim

        # Configure Git settings
        git config --global user.name "Your Name"
        git config --global user.email "your.email@example.com"
        git config --global core.editor "vim"
        git config --global core.excludesfile "$HOME/.gitignore_global"
        git config --global help.autocorrect 1

        # Copy .gitconfig to the Git repository
        cp "$HOME/.gitconfig" "$DOTFILES_DIR/.gitconfig"

        # Continue adding more packages as needed

    else
        echo "apt package manager is not available."
        # Add fallback installation method or exit
        exit 1
    fi

else
    echo "Script is not running as root, exiting..." >&2
    exit 1
fi

