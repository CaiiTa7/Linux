start_vpn() {
    dev="vpn_vpn"
    sudo /opt/softether/vpnclient/vpnclient start
    sudo /opt/softether/vpnclient/vpncmd localhost /CLIENT /CMD AccountConnect MyConnection
    sudo dhclient $dev
    route=$(ip addr | grep $dev | awk '{print $2}' | sed 's/.$//')
    if [ -z "$route" ]; then
        sudo ip route add 10.101.150.0/24 via 192.168.33.1
        sudo ip route del default via 192.168.33.1
    else
        for route in $(ip addr | grep $dev | awk '{print $2}'); do
            sudo ip route add 10.101.150.0/24 via 192.168.33.1
            sudo ip route del default via 192.168.33.1
        done
    fi
}

config_file="~/.zshrc"

echo 'alias vpn_start=start_vpn' >> $config_file
echo 'alias vpn_stop="sudo /opt/softether/vpnclient/vpnclient stop"' >> $config_file
echo 'alias vpn_restart="sudo /opt/softether/vpnclient/vpnclient stop && sudo /opt/softether/vpnclient/vpnclient start"' >> $config_file
echo 'alias vpn_status="sudo /opt/softether/vpnclient/vpnclient status"' >> $config_file

echo "Fini"
echo "Les alias VPN ont été ajoutés à $config_file"
echo "Vous pouvez utiliser les commmandes suivants :"
echo "  - vpn_start : pour démarrer le client VPN"
echo "  - vpn_stop : pour arrêter le client VPN"
echo "  - vpn_restart : pour redémarrer le client VPN"
echo "  - vpn_status : pour afficher l'état du client VPN"

echo -e "\n Installation de Oh My Posh \n"
chsh -s $(which zsh)
## Install Oh my Posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

## Download the themes
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
tar -xzvf ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

# Configurer Oh My Posh avec le thème Dracula

eval "$(oh-my-posh --init --shell zsh --config ~/.dracula.omp.json)"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip -O ~/Downloads/Meslo.zip
cd ~
mkdir .fonts
mkdir .neofetch
tar -xzvf ~/Downloads/Meslo.zip -d ~/.fonts/Meslo
fc-cache -fv
rm ~/Downloads/Meslo.zip
# Télécharger l'image et la placer dans un répertoire
wget -O ~/.neofetch/OP.jpeg "https://w.forfun.com/fetch/d7/d7a12cf1106ee202c717b2617d457b95.jpeg"

# Configurer Neofetch pour utiliser l'image
echo 'neofetch --w3m ~/.neofetch/OP.jpeg --source "ascii" --ascii_distro arch' >> ~/.zshrc

echo 'neofetch' >> ~/.zshrc

source $config_file
