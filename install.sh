#!/bin/bash

# Check if effective user id is 0 (root)
if [[ "$(id -u)" -eq 0 ]]; then
    echo "Script is running as root"
    exit 1
fi

# Check if apt is available
if ! command -v apt &> /dev/null; then
    echo "This script requires apt package manager, which is not available on your system."
    exit 1
fi

# Define paths
DOTFILES_DIR="$HOME/dotfiles"
GITCONFIG_FILE="$HOME_DIR/gitconfig"
BASHRC_FILE="$HOME_DIR/bashrc"
AUTHORIZED_KEYS_FILE="$DOTFILES_DIR/authorized_keys"
SSH_CONFIG_FILE="$DOTFILES_DIR/ssh_config"

# Install packages
install_packages() {
    sudo apt update
    sudo apt install -y vim git
}

# Symbolically link files
link_files() {
    ln -sf "$GITCONFIG_FILE" "$HOME/.gitconfig"
    ln -sf "$BASHRC_FILE" "$HOME/.bashrc"
    ln -sf "$AUTHORIZED_KEYS_FILE" "$HOME/.ssh/authorized_keys"
    ln -sf "$SSH_CONFIG_FILE" "$HOME/.ssh/config"
}

# Install Vundle
install_vundle() {
    if [ ! -d "$VUNDLE_DIR" ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
    fi
}

# Install vim plugins
install_vim_plugins() {
    # Install Vundle plugins
    vim +PluginInstall +qall

    # Install color scheme
    cp "$VIM_COLOR_SCHEME_FILE" "$HOME/.vim/colors/"

    # Install Vim improvement plugin
    vim +"PluginInstall your_vim_improvement_plugin" +qall
}

# Change ownership of linked files to non-root user
change_ownership() {
    sudo chown -R $USER:$USER "$HOME/.gitconfig" "$HOME/.bashrc" "$HOME/.ssh/authorized_keys" "$HOME/.ssh/config" "$HOME/.vim" "$HOME/.vimrc"
}

# Create ~/.ssh directory if it doesn't exist
create_ssh_directory() {
    if [ ! -d "$HOME/.ssh" ]; then
        mkdir "$HOME/.ssh"
    fi
}

# Copy authorized_keys file to dotfiles directory
copy_authorized_keys_to_repo() {
    cp "$HOME/.ssh/authorized_keys" "$AUTHORIZED_KEYS_FILE"
}

# Create SSH config file with entry
create_ssh_config_file() {
    cat <<EOF > "$SSH_CONFIG_FILE"
Host fry.cs.wright.edu
    User your_username
    # Add other configurations as needed
EOF
}

# Main function
main() {
    install_packages
    create_ssh_directory
    copy_authorized_keys_to_repo
    create_ssh_config_file
    link_files
    change_ownership
    install_vim_plugins
}

# Run the main function
main
