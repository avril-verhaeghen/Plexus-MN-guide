TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='plexus.conf'
CONFIGFOLDER='/root/.plexus'
COIN_DAEMON='plexusd'
COIN_CLI='plexus-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/PlexusCoin/Plexus/releases/download/V2.0.5/linux_v2.0.5.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')

COIN_NAME='Plexus'
COIN_PORT=31001
RPC_PORT=31002

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function stop_priv_node(){
  systemctl stop $COIN_NAME.service
  sleep 3
}

function restart_node(){
  systemctl start $COIN_NAME.service
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function download_node() {
  echo -e "Prepare to download $COIN_NAME binaries"
  cd $TMP_FOLDER
  wget -q $COIN_TGZ
  echo -e "Download $COIN_NAME binaries completed"
  tar xvzf $COIN_ZIP -C /usr/local/bin/
  compile_error
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  cd - >/dev/null 2>&1
  rm -r $TMP_FOLDER >/dev/null 2>&1
  clear
}

stop_priv_node
download_node
restart_node
