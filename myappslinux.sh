#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #

PPA_LUTRIS="ppa:lutris-team/lutris"

PPA_OBS="ppa:obsproject/obs-studio"

URL_DBEAVER="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

URL_SIMPLE_NOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"

URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb"

URL_VSCODE="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

URL_JDK21="https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb"

URL_KDELINE= "https://download.kde.org/stable/kdenlive/24.02/linux/kdenlive-24.02.1-x86_64.AppImage"

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  guvcview
  virtualbox
  obs-studio
  vlc
  lutris
  snapd
)
# --------------------------------END VARIÁVEIS--------------------------------------- #


# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock




## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386




## Atualizando o repositório ##
sudo apt update -y




## Adicionando repositórios de terceiros ##
sudo add-apt-repository "$PPA_LUTRIS" -y

sudo add-apt-repository "$PPA_OBS" -y



## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

# ---------------------------------------------------------------------- #







# ----------------------------- EXECUÇÃO ----------------------------- #


## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_VSCODE"    	   -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_JDK21" 		   -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_DBEAVER"   -P "$DIRETORIO_DOWNLOADS"


## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# ----------------------------- Docker ----------------------------- #

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# -----------------------------------END Docker ----------------------------------- #

## Instalando pacotes Appimage ##

SER_HOME=$(getent passwd "$USER" | cut -d: -f6)

# Verifica se o diretório AppImage existe, se não, cria
APPIMAGE_DIR="$USER_HOME/AppImage"
mkdir -p "$APPIMAGE_DIR"

# Muda para o diretório AppImage
cd "$APPIMAGE_DIR" || exit

wget https://download.kde.org/stable/kdenlive/24.02/linux/kdenlive-24.02.1-x86_64.AppImage

# Verifica se o download foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Download concluído com sucesso!"
else
    echo "O download falhou. Verifique sua conexão com a internet ou tente novamente mais tarde."
fi



## Instalando pacotes Flatpak ##




## Instalando pacotes Snap ##
sudo snap install photogimp
sudo snap install telegram-desktop
sudo snap install intellij-idea-community --classic
sudo snap install node --classic
sudo snap install postman
sudo snap install beekeeper-studio
sudo snap install whatsie --edge
sudo snap install qbittorrent-arnatious --edge
sudo snap install authenticator --edge

mkdir /home/mrrobot/Documents
cd /home/mrrobot

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #
