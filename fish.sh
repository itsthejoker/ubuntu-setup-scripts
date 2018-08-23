#!/bin/bash
#
# Script Name: fish.sh
#
# Author: https://github.com/itsthejoker
# Date : July 29, 2018
#
# Description: Installs, activates, and configures the fish shell as default for the server.
#
# Run Information: chmod +x fish.sh; ./fish.sh
#

echo Ubuntu Fish Shell Installer
echo itsthejoker, July 2018
echo ""

if [[ $EUID -eq 0 ]]; then
   echo "This script must be run as a regular user!"
   exit 1
fi

sudo apt update
sudo apt install fish -y

isinshell=$(grep -R $(which fish) /etc/shells)

if ! [ $isinshell ]; then
    echo $(which fish) | sudo tee --append /etc/shells > /dev/null
fi

# actually change the shell
chsh -s $(which fish)

if [ ! -f "~/.config/fish/config.fish" ]; then
  mkdir -p ~/.config/fish/
  touch ~/.config/fish/config.fish
fi

cat > ~/.config/fish/config.fish << EOL
alias htop="sudo htop"
alias reload_profile=". ~/.config/fish/config.fish"
alias ls="ls -FGhla"
alias gs="git status"
alias m="micro"
# shell theming crap -- requires the nerd fonts patched version of fira code called "fura"
set -g theme_nerd_fonts yes
set -x PYENV_VIRTUALENV_DISABLE_PROMPT 1
set -x TERM xterm-256color
EOL

# get oh-my-fish
curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install > install_omf
sudo chmod +x install_omf
./install_omf --noninteractive

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/FiraCode.zip
sudo unzip FiraCode.zip -d /usr/local/share/fonts/
sudo fc-cache -fv

# theeeeeming and plugins
# -----------------------
# bobthefish: badass theme
# z: context-aware directory CD'ing based on keywords
# pisces: automatically match quotes, brackets, and parentheses
# bang-bang: auto-expand !! into the previous command
# pyenv: fish-style pyenv support
fish -c "omf install bobthefish z pisces bang-bang pyenv"

echo "All done! Must log out and back in to complete."
