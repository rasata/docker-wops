#!/bin/bash
# 2014-09-08 08:17 CEST
# y0ug
DST=/var/tools
LOCAL_BIN="/usr/local/bin/"


TARGET=$DST/msf
if [ ! -d "$TARGET" ]; then
  sudo apt-get -yq install \
    build-essential zlib1g zlib1g-dev \
    libxml2 libxml2-dev libxslt-dev locate \
    libreadline6-dev libcurl4-openssl-dev git-core \
    libssl-dev libyaml-dev openssl autoconf libtool \
    ncurses-dev bison libpq-dev \
    libapr1 libaprutil1 libsvn1 \
    libpcap-dev libsqlite3-dev

  cd $DST
  git clone https://github.com/rapid7/metasploit-framework.git msf 
  cd msf
  bundle install
  sudo find /var/lib/gems/1.9.1/gems/ -type f -exec chmod 644 {} \;
  sudo find /var/lib/gems/1.9.1/gems/ -type d -exec chmod 755 {} \;
  sudo ln -s $(pwd)/msf* $LOCAL_BIN
fi

TARGET=$DST/burp
VER=burpsuite_free_v1.6
if [ ! -d "$TARGET" ]; then
  mkdir -p $TARGET
  cd $TARGET
  wget http://portswigger.net/burp/$VER.jar
  cat > burp.sh <<EOF
#!/bin/bash
BIN_PATH=${PWD}/${VER}.jar
java -Xms1024m -Xmx1024m -jar \$BIN_PATH "\$@" 1>/dev/null 2>&1 
EOF
  chmod +x burp.sh
  sudo ln -s $TARGET/burp.sh $LOCAL_BIN
fi

TARGET=$DST/ZAP
VER=ZAP_2.3.1
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo add-apt-repository -y ppa:webupd8team/java
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  sudo apt-get update && sudo apt-get install -yq oracle-java7-installer
  wget http://sourceforge.net/projects/zaproxy/files/2.3.1/${VER}_Linux.tar.gz
  tar xvf ${VER}_Linux.tar.gz
  rm ${VER}_Linux.tar.gz
  mv $VER $TARGET
  cd $TARGET
  sudo ln -s $TARGET/zap.sh $LOCAL_BIN
fi

TARGET=$DST/DirBuster
VER=DirBuster-0.12
if [ ! -d "$TARGET" ]; then
  cd $DST
  wget http://sourceforge.net/projects/dirbuster/files/DirBuster%20%28jar%20%2B%20lists%29/0.12/$VER.tar.bz2
  tar xvf DirBuster-0.12.tar.bz2
  mv $VER $TARGET
  cd $TARGET
  cat > dirbuster.sh <<EOF
#!/bin/bash
BIN_PATH=${PWD}/${VER}.jar
java -Xms512m -jar \$BIN_PATH "\$@" 1>/dev/null 2>&1
EOF
  chmod +x dirbuster.sh
  sudo ln -s $TARGET/dirbuster.sh $LOCAL_BIN
fi

TARGET=$DST/beef
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo apt-get install -yq libsqlite3-ruby libsqlite3-dev libssl-dev
  git clone git://github.com/beefproject/beef.git
  cd beef
  bundle install
fi

#TARGET=$DST/NoSQLMap
#if [ ! -d "$TARGET" ]; then
#  cd $DST
#  git clone https://github.com/tcstool/NoSQLMap.git
#  cd $TARGET
#  echo y | sudo bash setup.sh
#fi

TARGET=$DST/john
VER=john-1.7.9-jumbo-7
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo apt-get install -yq libnspr4-dev libnss3-dev libopenmpi-dev
  wget http://www.openwall.com/john/g/$VER.tar.gz
  tar xvf $VER.tar.gz 
  rm -Rf $VER.tar.gz
  mv $VER $TARGET
  cd $TARGET/src
  sed -i 's/#OMPFLAGS = -fopenmp -msse2/OMPFLAGS = -fopenmp -msse2/g' Makefile
  sed -i 's/#HAVE_NSS/HAVE_NSS/g' Makefile
fi

TARGET=$DST/thc-hydra
if [ ! -d "$TARGET" ]; then
  sudo apt-get install -yq libssl-dev libssh-dev libidn11-dev libpcre3-dev \
    libmysqlclient-dev libpq-dev libsvn-dev \
    firebird2.1-dev # libncp-dev
  cd $DST
  git clone https://github.com/vanhauser-thc/thc-hydra.git
  cd $TARGET
  ./configure
  make
  sudo make install
  sudo ln -s $TARGET/hydra $LOCAL_BIN
fi

TARGET=$DST/rp
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/0vercl0k/rp.git
  cd $TARGET
  mkdir build
  cd build
  cmake ../ && make
  sudo ln -s $TARGET/rp-lin-x64 $LOCAL_BIN
fi

TARGET=$DST/clusterd
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/hatRiot/clusterd.git
  sudo ln -s $TARGET/clusterd.py $LOCAL_BIN
fi

TARGET=$DST/theharvester
if [ ! -d "$TARGET" ]; then
  cd $DST
  svn checkout http://theharvester.googlecode.com/svn/trunk/ theharvester
fi

TARGET=$DST/wafw00f
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/sandrogauci/wafw00f.git
  cd $TARGET
  sudo python setup.py install
fi

TARGET=$DST/blindelephant
if [ ! -d "$TARGET" ]; then
  cd $DST
  svn co https://blindelephant.svn.sourceforge.net/svnroot/blindelephant/trunk blindelephant
  cd $TARGET/src
  sudo python setup.py install
fi

TARGET=$DST/whatweb
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/urbanadventurer/WhatWeb.git whatweb
  cd $TARGET
  sudo make install
fi

TARGET=$DST/cms-explorer
if [ ! -d "$TARGET" ]; then
  cd $DST
  svn checkout http://cms-explorer.googlecode.com/svn/trunk/ cms-explorer
fi

TARGET=$DST/joomscan
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo apt-get install -yq libwww-perl libswitch-perl libwww-mechanize-perl
  svn checkout svn://svn.code.sf.net/p/joomscan/code/trunk joomscan
fi

TARGET=$DST/wpscan
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo apt-get install -yq libcurl4-gnutls-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential
  git clone https://github.com/wpscanteam/wpscan.git
  cd $TARGET
  sudo gem install bundler && bundle install --without test
  sudo ln -s $(pwd)/wpscan.rb $LOCAL_BIN
fi

TARGET=$DST/weevely
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/epinna/Weevely.git weevely
  cd $TARGET
  sudo ln -s $(pwd)/weevely.py $LOCAL_BIN
fi

TARGET=$DST/sqlmap
if [ ! -d "$TARGET" ]; then
  cd $DST
  git clone https://github.com/sqlmapproject/sqlmap.git
  cd $TARGET
  sudo ln -s $(pwd)/sqlmap.py $LOCAL_BIN
fi

TARGET=$DST/dnsrecon
if [ ! -d "$TARGET" ]; then
  cd $DST
  sudo pip install netaddr dnspython
  git clone https://github.com/darkoperator/dnsrecon.git
  cd $TARGET
  sudo ln -s $(pwd)/dnsrecon.py $LOCAL_BIN
fi

TARGET=$DST/fierse
if [ ! -d "$TARGET" ]; then
  sudo apt-get install -yq libnet-dns-perl
  mkdir -p $TARGET
  cd $TARGET
  wget http://ha.ckers.org/fierce/fierce.pl
  wget http://ha.ckers.org/fierce/hosts.txt
  chmod 755 fierce.pl
  sudo ln -s $(pwd)/fierce.pl $LOCAL_BIN
fi

TARGET=$DST/wfuzz
VER=wfuzz-2.0
if [ ! -d "$TARGET" ]; then
  cd $DST
  wget https://wfuzz.googlecode.com/files/$VER.tgz
  tar xvf $VER.tgz
  rm $VER.tgz
  mv wfuzz-read-only $TARGET
  sudo pip install pycurl
  chmod 755 wfuzz/wfuzz.py
  sudo ln -s $(pwd)/wfuzz/wfuzz.py $LOCAL_BIN
fi

TARGET=$DST/nikto
VER=nikto-2.1.5
if [ ! -d "$TARGET" ]; then
  cd $DST
  wget https://www.cirt.net/nikto/$VER.tar.gz
  tar xvf $VER.tar.gz
  rm $VER.tar.gz
  mv $VER nikto
  cd $TARGET
  chmod +x nikto.pl
fi
