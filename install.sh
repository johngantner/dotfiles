#!/bin/bash

# get username that called script
echo $SUDO_USER
ME=$SUDO_USER

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Please run this script as a non-root user."
    exit 1
fi

# Check for apt package manager
if ! [ -x "$(command -v apt)" ]; then
    echo "Error: apt package manager not found. This script is designed for Ubuntu Linux."
    exit 1
fi

# Package installs
sudo apt update
sudo apt install -y dnsutils nmap

# Install Anaconda
if [[ -e $(ls Anaconda3*.sh 2> /dev/null | head -1) ]]; then
        echo "Installer found, running it"
        bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /home/$ME/anaconda3
        echo "PATH=$PATH:/home/kduncan/anaconda3/bin" >> /home/$ME/.profile

else
        echo "Downloading anaconda installer"
        curl -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh                bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /home/$ME/anaconda3
        echo "PATH=$PATH:/home/kduncan/anaconda3/bin" >> /home/$ME/.profile
fi

# Command line games installation
sudo apt install -y dnsutils nmap bastet

# Git configuration
git config --global user.name "John Gantner"
git config --global user.name "" git config --global user.email "jgantner73@gmail.com"
git config --global core.editor "vim"
git config --global help.autocorrect 1

# Symbolic link for .gitconfig
ln -sf /home/jgantner/dotfiles/gitfiles ~/.gitconfig

# Bash aliases
echo 'alias ll="ls -al"' >> /home/$ME/.bashrc

# Symbolic link for .bashrc
ln -sf /home/jgantner/dotfiles ~/.bashrc

# SSH public keys
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi

# Symbolic link for authorized_keys
ln -sf /home/jgantner/authorized_keys ~/.ssh/authorized_keys

# SSH config
echo -e "Host fry.cs.wright.edu\n\tUser your_w_number\n\tIdentityFile ~/.ssh/id_rsa" > ~/.ssh/config

# Vim customizations
# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install a color scheme
mkdir -p ~/.vim/colors
curl -o ~/.vim/colors/jellybeans.vim https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# Install a Vim improvement plugin
# Install NERDTree
echo "Installing NERDTree..."
vim -c "PluginInstall" -c "qa"

# Additional package installs for Vim plugins
vim +PluginInstall +qall
~/.vim/bundle/YouCompleteMe/install.py --clangd-completer

echo "Setup complete. Remember to restart your terminal for changes to take effect."
