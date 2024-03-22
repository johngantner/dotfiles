#!/bin/bash

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Please run this script as a non-root user."
    exit 1
fi

# Validate sudo usage and get the invoking user
if [ -n "$SUDO_USER" ]; then
    ME="$SUDO_USER"
else
    echo "Please run this script using sudo."
    exit 1
fi

# Check for apt package manager
if ! [ -x "$(command -v apt)" ]; then
    echo "Error: apt package manager not found. This script is designed for Ubuntu Linux."
    exit 1
fi

# Package installs
sudo apt update
sudo apt install -y dnsutils nmap git bastet curl

# Install Anaconda
anaconda_installer="Anaconda3-2024.02-1-Linux-x86_64.sh"
if [ -e "$anaconda_installer" ]; then
    echo "Installer found, running it"
    bash "$anaconda_installer" -b -p "/home/$ME/anaconda3"
else
    echo "Downloading Anaconda installer"
    curl -O "https://repo.anaconda.com/archive/$anaconda_installer"
fi

# Add Anaconda to PATH
echo "export PATH=\$PATH:/home/$ME/anaconda3/bin" >> "/home/$ME/.profile"

# Git configuration
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"
git config --global core.editor "vim"
git config --global help.autocorrect 1

# Symbolic link for .gitconfig
ln -sf "/home/$ME/dotfiles/gitfiles" "/home/$ME/.gitconfig"

# Bash aliases
echo 'alias ll="ls -al"' >> "/home/$ME/.bashrc"

# Symbolic link for .bashrc
ln -sf "/home/$ME/dotfiles" "/home/$ME/.bashrc"

# SSH public keys
mkdir -p "/home/$ME/.ssh"
ln -sf "/home/$ME/authorized_keys" "/home/$ME/.ssh/authorized_keys"

# SSH config
read -p "Enter SSH user for fry.cs.wright.edu: " ssh_user
read -p "Enter SSH identity file path (leave empty for default): " ssh_identity

ssh_config="/home/$ME/.ssh/config"
echo -e "Host fry.cs.wright.edu\n\tUser $ssh_user" >> "$ssh_config"
if [ -n "$ssh_identity" ]; then
    echo -e "\tIdentityFile $ssh_identity" >> "$ssh_config"
fi

# Vim customizations
# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git "/home/$ME/.vim/bundle/Vundle.vim"

# Install a color scheme
mkdir -p "/home/$ME/.vim/colors"
curl -o "/home/$ME/.vim/colors/jellybeans.vim" "https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim"

# Install Vim plugins
echo "Installing Vim plugins..."
vim -c "PluginInstall" -c "qa"

# Additional package installs for Vim plugins
vim +PluginInstall +qall
/home/$ME/.vim/bundle/YouCompleteMe/install.py --clangd-completer

echo "Setup complete. Remember to restart your terminal for changes to take effect."
