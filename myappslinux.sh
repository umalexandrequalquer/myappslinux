#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #

PPA_LUTRIS="ppa:lutris-team/lutris"

PPA_OBS="ppa:obsproject/obs-studio"

URL_DBEAVER=""

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

URL_SIMPLE_NOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"

URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb"

URL_VSCODE="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

URL_JDK21="https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb"


DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

PROGRAMAS_PARA_INSTALAR=(
  snapd
  guvcview
  virtualbox
  obs-studio
  vlc
  lutris
  libvulkan1
  libvulkan1:i386
  libgnutls30:i386
  libldap-2.4-2:i386
  libgpg-error0:i386
  libxml2:i386
  libasound2-plugins:i386
  libsdl2-2.0-0:i386
  libfreetype6:i386
  libdbus-1-3:i386
  libsqlite3-0:i386
)
# --------------------------------END--------------------------------------- #


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



## Atualizando e instalando o repositório depois da adição de novos repositórios ##
sudo apt update -y

sudo apt install obs-studio
sudo apt install lutris
sudo apt install snapd


# ---------------------------------------------------------------------- #




# ----------------------------- EXECUÇÃO ----------------------------- #


## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_VSCODE"    	   -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_JDK21" 		   -P "$DIRETORIO_DOWNLOADS"



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


## Instalando pacotes Flatpak ##
flatpak install flathub eu.ithz.umftpd

## Instalando pacotes Snap ##
sudo snap install photogimp
sudo snap install telegram-desktop
sudo snap install intellij-idea-community --classic
sudo snap install node --classic
sudo snap install postman



# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #
