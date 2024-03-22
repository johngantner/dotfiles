# dotfiles
jgantner user dotfiles

# Automated Setup Script

This script automates the setup process for a Linux environment, focusing on Ubuntu Linux. It installs essential packages, configures system settings, sets up Anaconda, Git, SSH, Vim, and more.

## Prerequisites

- This script is designed for Ubuntu Linux.
- Ensure that you have sudo privileges to execute the script.

## Usage

1. Download the script to your system.
2. Make it executable using the following command:
3. Run the script using sudo: sudo ./install.sh
4. Follow the on-screen prompts and instructions.

## Functionality

- Checks if running as root to prevent accidental execution with elevated privileges.
- Installs essential packages such as `dnsutils`, `nmap`, `git`, and `bastet`.
- Installs Anaconda, a Python and R distribution.
- Configures Git with user details.
- Sets up SSH keys and configuration.
- Installs Vim plugins using Vundle.
- Configures system settings and aliases for enhanced productivity.

## Customization

- You may customize the script to suit your specific requirements by modifying variables or adding/removing package installations and configurations.

## Notes

- This script assumes a certain directory structure and user setup. Adjust paths and configurations as needed for your environment.
- Ensure that you review and understand the script before executing it, especially if you're running it on a production system.

## Citation 

- This script was generated using chatgpt and pieces from Professor Duncan's dotfiles in github.
