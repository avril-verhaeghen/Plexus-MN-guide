TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='plexus.conf'
CONFIGFOLDER='/root/.plexus'
COIN_DAEMON='plexusd'
COIN_CLI='plexus-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/altcuim/Plexus/archive/v2.0.4/linux_v2.0.4.tar.gz'

COIN_NAME='Plexus'
COIN_PORT=31001
RPC_PORT=31002

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function stop_priv_node() {
echo -e "${RED}$Stop Old $COIN_NAME MN" 
systemctl stop $COIN_NAME.service
sleep 10
}


function Reconfigure_systemd() {
echo -e "${GREEN}systemctl start $COIN_NAME.service"
  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
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
  tar xvzf $COIN_ZIP -C /usr/local/bin/
  compile_error
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  cd - >/dev/null 2>&1
  rm -r $TMP_FOLDER >/dev/null 2>&1
  clear
}

#Main
stop_priv_node
download_node
Reconfigure_systemd
