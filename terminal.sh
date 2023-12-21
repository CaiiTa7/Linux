#!/bin/bash

# Mettez à jour le système
sudo apt update
sudo apt upgrade -y

# Installer les prérequis
sudo apt install -y zsh wget

# Installer Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installer les polices Nerd Font (assurez-vous d'avoir curl installé)
sudo apt install -y fonts-powerline
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh

# Installer Oh My Posh
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O oh-my-posh
chmod +x oh-my-posh
sudo mv oh-my-posh /usr/local/bin/

# Télécharger et appliquer le thème Dracula pour Oh My Posh
wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json -O ~/.config/oh-my-posh/theme/dracula.omp.json

# Configurer le shell Zsh pour utiliser Oh My Posh
echo 'eval "$(oh-my-posh --init --shell zsh --config ~/.config/oh-my-posh/theme/dracula.omp.json)"' >> ~/.zshrc

# Installer Neofetch
sudo apt install -y neofetch

# Télécharger l'image Neofetch
wget https://w.forfun.com/fetch/d7/d7a12cf1106ee202c717b2617d457b95.jpeg -O ~/.config/neofetch/neofetch.png

# Configurer Neofetch avec le mode de recadrage spécifié
echo 'image_source="$HOME/.config/neofetch/neofetch.png"' >> ~/.config/neofetch/config.conf
echo 'crop_mode="fill"' >> ~/.config/neofetch/config.conf

# Appliquer les modifications
source ~/.zshrc

# Afficher un message de confirmation
echo "Installation et configuration terminées. Redémarrez votre terminal pour appliquer les changements."
