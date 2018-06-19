SOURCE_INIT=$(mkdir Plexus_SRC)
SOURCE_FOLDER='Plexus_SRC'
CONFIG_FILE='plexus.conf'
CONFIGFOLDER='/root/.plexus'
COIN_DAEMON='plexusd'
COIN_CLI='plexus-cli'
COIN_PATH='/usr/local/bin/'
COIN_REPO='-b v2.0.4 https://github.com/PlexusCoin/Plexus.git'

COIN_NAME='Plexus'
COIN_PORT=31001
RPC_PORT=31002

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function compile_node() {
  echo -e "Prepare to compile $COIN_NAME"
  git clone $COIN_REPO $SOURCE_FOLDER >/dev/null 2>&1
  echo -e "Clone completed"
  compile_error
  cd $SOURCE_FOLDER
  chmod +x ./autogen.sh 
  chmod +x ./share/genbuild.sh
  chmod +x ./src/leveldb/build_detect_platform
  ./autogen.sh
  compile_error
  ./configure --without-wallet
  compile_error
  make
  compile_error
  make install
  compile_error
  strip $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  chmod +x $COIN_PATH$COIN_DAEMON $COIN_PATH$COIN_CLI
  cd - >/dev/null 2>&1
  #rm -rf $TMP_FOLDER >/dev/null 2>&1
  clear
}

function stop_priv_node() {
systemctl stop $COIN_NAME.service
sleep 10
  echo -e "Stop old $COIN_NAME MN" 

  clear
}
function start_new_node() {
systemctl start $COIN_NAME.service
sleep 3
  echo -e "Re start new MN $COIN_NAME MN" 
  clear
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function Reconfigure_systemd() {

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

function create_swap() {
 echo -e "Checking if swap space is needed."
 PHYMEM=$(free -g|awk '/^Mem:/{print $2}')
 SWAP=$(free -g|awk '/^Swap:/{print $2}')
 if [ "$PHYMEM" -lt "2" ] && [ -n "$SWAP" ]
  then
    echo -e "${GREEN}Server is running with less than 2G of RAM without SWAP, creating 2G swap file.${NC}"
    SWAPFILE=$(mktemp)
    dd if=/dev/zero of=$SWAPFILE bs=1024 count=2M
    chmod 600 $SWAPFILE
    mkswap $SWAPFILE
    swapon -a $SWAPFILE
 else
  echo -e "${GREEN}Server running with at least 2G of RAM, no swap needed.${NC}"
 fi
 clear
}


function prepare_system() {
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node V2.0.4."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ libzmq5 >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw fail2ban pkg-config libevent-dev libzmq5"
 exit 1
fi

clear
}
#Main
create_swap
#prepare_system
stop_priv_node
compile_node
start_new_node
#Reconfigure_systemd
