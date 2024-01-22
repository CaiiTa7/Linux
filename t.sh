#!/bin/bash
pacman -Syu --noconfirm make gcc wget curl git base-devel net-tools neofetch zsh unzip

url="https://www.softether-download.com/files/softether/"
get_last_version() {
    # Effectuer une requête HTTP pour obtenir le contenu de la page
    response=$(curl -s "$1")
    
    if [ $? -eq 0 ]; then
        # Filtrer les liens pour obtenir les versions et les trier
        versions=$(echo "$response" | grep -oP 'v\d+\.\d+-\d+-\w+-\d+\.\d+\.\d+-tree')
        
        if [ -n "$versions" ]; then
            # Retourner la dernière version
            echo "$versions" | sort -r | head -n 1
            return
        fi
    fi
    echo "Nope"
}
version=$(get_last_version "$url")
last_version=$(echo "$version" | sed 's/-tree/-linux-x64-64bit.tar.gz/')
download_link="$url$version/Linux/SoftEther_VPN_Client/64bit_-_Intel_x64_or_AMD64/softether-vpnclient-$last_version"
package_name="softether-vpnclient-$last_version"
if [ "$last_version" != "Nope" ]; then
    mkdir -p /opt/softether
    cd /opt/softether
    echo "Downloading SoftEther VPN Client..."
    wget -q "$download_link"
    echo "Extracting..."
    tar -xzvf "$package_name"
    echo "Installing..."
    cd vpnclient
    make
    cd /opt/softether/vpnclient
    make install
    
    echo "Cleaning..."
    rm -rf "$package_name"
    echo "Done"
fi
VPNCLIENT_BIN="./vpnclient"
VPNCMD_BIN="./vpncmd"
HOSTNAME="networking.iesn.henallux.be"
PORT="443"
HUB_NAME="ETU"
USER_NAME="MASI_ETU_LAB"
PASSWORD="PwD_M@s1-L@b0"
$VPNCLIENT_BIN start
$VPNCMD_BIN localhost /CLIENT /CMD NicCreate "VPN"
# Créer une nouvelle connexion nommée "MyConnection"
$VPNCMD_BIN localhost /CLIENT /CMD AccountCreate MyConnection /SERVER:$HOSTNAME:$PORT /HUB:$HUB_NAME /USERNAME:$USER_NAME /NICNAME:VPN
# Co$nfigurer la connexion pour l'authentification par mot de passe
$VPNCMD_BIN localhost /CLIENT /CMD AccountPasswordSet MyConnection /PASSWORD:$PASSWORD /TYPE:standard
# Dé$marrer la connexion VPN
$VPNCMD_BIN localhost /CLIENT /CMD AccountConnect MyConnection
# Vé$rifier l'état de la connexion
$VPNCMD_BIN localhost /CLIENT /CMD AccountStatusGet MyConnection
sleep 3
config_file="~/.zshrc"
echo '
eval "$(oh-my-posh --init --shell zsh --config ~/.poshthemes/dracula.omp.json)" 
neofetch --w3m ~/.neofetch/OP.jpeg --source "ascii" --ascii_distro arch

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

alias vpn_start=start_vpn
alias vpn_stop="sudo /opt/softether/vpnclient/vpnclient stop"
alias vpn_restart="sudo /opt/softether/vpnclient/vpnclient stop && sudo /opt/softether/vpnclient/vpnclient start"
alias vpn_status="sudo /opt/softether/vpnclient/vpnclient status"
' >> $config_file

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
mkdir ~/.fonts
mkdir ~/.neofetch

wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

# Configurer Oh My Posh avec le thème Dracula
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip -O ~/.fonts/Meslo.zip

unzip ~/.fonts/Meslo.zip -d ~/.fonts/Meslo
fc-cache -fv
rm ~/Downloads/Meslo.zip
# Télécharger l'image et la placer dans un répertoire
wget -O ~/.neofetch/OP.jpeg "https://w.forfun.com/fetch/d7/d7a12cf1106ee202c717b2617d457b95.jpeg"

# Configurer Neofetch pour utiliser l'image
source $config_file
