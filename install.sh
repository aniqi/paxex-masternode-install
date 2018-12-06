#/bin/bash
clear



echo "Do you want to install all needed dependencies (no if you did it before) in Ubuntu 18.04? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then

  sudo apt update
  sudo apt -y upgrade
  sudo apt -y dist-upgrade
  echo "deb http://archive.ubuntu.com/ubuntu/ xenial main universe" | sudo tee -a /etc/apt/sources.list
  sudo apt update
  sudo apt install -y nano htop git curl


  sudo apt install -y software-properties-common

  sudo apt install -y libzmq3-dev
  sudo apt install -y build-essential libtool autotools-dev pkg-config libssl-dev
   
  sudo apt install -y libboost1.58-dev libboost-system1.58 libboost-filesystem1.58 libboost-program-options1.58 libboost-thread1.58 libboost-thread1.58
  sudo apt update && sudo apt install -y libqt5network5 libqt5widgets5
  sudo apt install -y libqrencode3 libprotobuf9v5 libminiupnpc10 libevent-pthreads-2.0-5 libevent-2.0-5 libprotobuf9v5
  sudo apt install -y autoconf
  sudo apt install -y automake unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt update

  sudo apt install -y libdb4.8-dev libdb4.8++-dev

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=4000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd
  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

echo "Do you want to compile Daemon (please choose no if you did it before)? [y/n]"
read DOSETUPTWO

if [[ $DOSETUPTWO =~ "y" ]] ; then

paxchange-cli stop > /dev/null 2>&1
cd /home/
wget http://167.99.88.119/files/paxchanged -O paxchanged
wget http://167.99.88.119/files/paxchange-cli -O paxchange-cli
chmod +x paxchange*
mv paxchange* /usr/local/bin/
fi

echo ""
echo "Configuring IP - Please Wait......."

declare -a NODE_IPS
for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
do
  NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
done

if [ ${#NODE_IPS[@]} -gt 1 ]
  then
    echo -e "More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
    INDEX=0
    for ip in "${NODE_IPS[@]}"
    do
      echo ${INDEX} $ip
      let INDEX=${INDEX}+1
    done
    read -e choose_ip
    IP=${NODE_IPS[$choose_ip]}
else
  IP=${NODE_IPS[0]}
fi

echo "IP Done"
echo ""
echo "Enter masternode private key for node $ALIAS , Go To your Windows Wallet Tools > Debug Console , Type masternode genkey"
read PRIVKEY

CONF_DIR=~/.PAXCHANGE/
CONF_FILE=PAXCHANGE.conf
PORT=4133

mkdir -p $CONF_DIR
echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` > $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "rpcport=4132" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "mastenodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE
echo "addnode=207.246.117.202" >> $CONF_DIR/$CONF_FILE
echo "addnode=149.28.52.246" >> $CONF_DIR/$CONF_FILE
echo "addnode=89.47.161.100" >> $CONF_DIR/$CONF_FILE
echo "addnode=178.128.53.28" >> $CONF_DIR/$CONF_FILE
echo "addnode=207.246.84.190" >> $CONF_DIR/$CONF_FILE
echo "addnode=140.82.59.18" >> $CONF_DIR/$CONF_FILE
echo "addnodes=45.77.52.145" >> $CONF_DIR/$CONF_FILE
echo "addnode=173.149.60.152" >> $CONF_DIR/$CONF_FILE
echo "addnode=176.223.143.201" >> $CONF_DIR/$CONF_FILE
echo "addnode=45.77.231.88" >> $CONF_DIR/$CONF_FILE
echo "addnode=140.82.39.165" >> $CONF_DIR/$CONF_FILE
echo "addnode=80.211.39.203" >> $CONF_DIR/$CONF_FILE
echo "addnode=45.32.158.96" >> $CONF_DIR/$CONF_FILE
echo "addnode=173.249.23.37" >> $CONF_DIR/$CONF_FILE
echo "addnode=45.76.33.171" >> $CONF_DIR/$CONF_FILE
echo "addnode=8.9.31.144" >> $CONF_DIR/$CONF_FILE
echo "addnode=149.28.236.128" >> $CONF_DIR/$CONF_FILE
echo "addnode=194.135.88.248" >> $CONF_DIR/$CONF_FILE
echo "addnode=80.208.230.40" >> $CONF_DIR/$CONF_FILE
echo "addnode=80.209.234.210" >> $CONF_DIR/$CONF_FILE
echo "addnode=80.209.235.51" >> $CONF_DIR/$CONF_FILE
echo "addnode=89.108.125.174" >> $CONF_DIR/$CONF_FILE


paxchanged -daemon
