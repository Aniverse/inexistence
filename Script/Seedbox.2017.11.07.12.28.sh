#!/bin/sh
#
# 作者：一个辣鸡
# 四处抄来的，参考资料在下边
# 写得很烂，请大佬帮忙修正
#
# https://github.com/qbittorrent/qBittorrent/wiki/Compiling-qBittorrent-on-Debian-and-Ubuntu
# https://github.com/qbittorrent/qBittorrent/wiki/Setting-up-qBittorrent-on-Ubuntu-server-as-daemon-with-Web-interface-(15.04-and-newer)
# http://dev.deluge-torrent.org/wiki/UserGuide/Service/systemd
# https://github.com/arakasi72/rtinst
# https://github.com/QuickBox/QB
# https://flexget.com/InstallWizard/Linux
# https://rclone.org/install
# 
# --------------------------------------------------------------------------------
#Script Console Colors
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
sub_title=${bold}${yellow}; repo_title=${white}${on_blue}; message_title=${white}${on_green};
zidingyi1=${white}${on_cyan}
# --------------------------------------------------------------------------------
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------
### export ANUSER=Your.Name
### export ANPASS=Your.Password
### export WEBPASS=Web.Password




clear




# 介绍
function _intro() {
  echo
  echo
  echo "[${repo_title}A young and simple script${normal}] ${title} Seedbox Installation ${normal}  "
  echo
  echo "   ${title}                         Warning!                        ${normal} "
  echo "   ${message_title}  This script is a BETA and have many unresolved issues  ${normal} "
  echo "   ${message_title}          May work with Ubuntu 16.04 | Debian 9          ${normal} "
  echo "   ${message_title}                                                         ${normal} "
  echo "   ${message_title}          Press Ctrl+Z to stop this shit script          ${normal} "
  echo
  echo
}




# 检查是否以root运行
function _checkroot() {
  if [[ $EUID != 0 ]]; then
    echo ' {title}${bold}Navie! I think this young man will not be able to run this script without root privileges.${normal}'
    echo ' Exiting...'
    exit 1
  fi
  echo " ${green}${bold}Excited! You're running as root. Let's make some big news ... ${normal}"
  echo
}




# 询问是否继续 Type-A
function _warning() {
  echo -e "${bold}I would like to speak a few words."
  echo -e "I think I know nothing about linux, but anyway, I dare to do it, this is very important."
  echo
  echo -e "我的这个经历就是成了刷子，到刷了1PB多的时候，我在想我估计是快要退坑了"
  echo -e "我想我或许可以当个大佬。不过大佬们说这个 apply for dalao，要去做一个报告"
  echo -e "我就写了现在你看到的这个破脚本"
  echo -e "这个脚本经过几百个 Seedboxes 安装测试，一致${red}不通过${normal}"
  echo -e "${bold}于是当不成大佬的我，只好继续当弱鸡了"
  echo -e "这个脚本，也没有什么别的，大概三件事"
  echo
  echo -e "${blue} 1. 安装指定版本的 qBittorrent、Deluge、rTorrent"
  echo -e " 2. 安装最新版本的 Flexget、rclone"
  echo -e " 3. 设置个简单点的开关客户端的命令${normal}"
  echo
  echo -e "${bold}我说另请高明吧，我实在也不是谦虚；我一个刷子怎么就写脚本了呢？"
  echo -e "你们不要想着搞个大新闻，说现在出了个新脚本，然后翻车时又把我批判一番"
  echo -e "我没有说能用，没有任何这个意思"
  echo
  echo -e "下面这些消息，你们本身也要判断，明白意思吗？${normal}"
  echo
  echo '####################################################################'
  echo '#'
  if [ ! -n "$ANUSER" ]; then
    echo -e "#              ${bold}${on_yellow}用户名？还没有被钦定${normal}"
  else
    echo -e "#              ${cyan}${bold}你预设的用户名${normal}    ${bold}${yellow}${ANUSER}${normal}"
  fi
  if [ ! -n "$ANUSER" ]; then
    echo -e "#                                       ${bold}${on_yellow}UNIX密码？不存在的${normal}"
  else
    echo -e "#              ${cyan}${bold}你预设的UNIX密码${normal}  ${bold}${yellow}${ANPASS}${normal}"
  fi
  if [ ! -n "$ANUSER" ]; then
    echo -e "#                     ${bold}${on_yellow}Web密码？无可奉告${normal}"
  else
    echo -e "#              ${cyan}${bold}你预设的Web密码${normal}   ${bold}${yellow}${WEBPASS}${normal}"
  fi
  echo '#'
  echo '####################################################################'
  echo
  echo -e "${bold}如果你已经研究决定了，请敲 ${message_title}回车${normal} ${bold}继续"
  echo -e "如果报道上出现了偏差，请按 ${repo_title}Ctrl+Z${normal} ${bold}或 ${repo_title}Ctrl+C${normal} 下车"; read input
}




# 询问需要安装的 qBittorrent 的版本
function _askqbt() {
  clear
  echo -e "01) qBittorrent ${cyan}3.3.7${normal}"
  echo -e "02) qBittorrent ${cyan}3.3.8${normal}"
  echo -e "03) qBittorrent ${cyan}3.3.9${normal}"
  echo -e "04) qBittorrent ${cyan}3.3.10${normal}"
  echo -e "05) qBittorrent ${cyan}3.3.11${normal} (default)"
  echo -e "06) qBittorrent ${cyan}3.3.12${normal}"
  echo -e "07) qBittorrent ${cyan}3.3.13${normal}"
  echo -e "08) qBittorrent ${cyan}3.3.14${normal}"
  echo -e "09) qBittorrent ${cyan}3.3.15${normal}"
  echo -e "10) qBittorrent ${cyan}3.3.16${normal}"
  echo -e "11) Do not install qBittorrent"
  echo -ne "${bold}${yellow}What version of qBittorrent do you want?${normal} (Default ${cyan}05${normal}): "; read version
  case $version in
    01) QBVERSION=3.3.7 ;;
    02) QBVERSION=3.3.8 ;;
    03) QBVERSION=3.3.9 ;;
    04) QBVERSION=3.3.10 ;;
    05 | "") QBVERSION=3.3.11 ;;
    06) QBVERSION=3.3.12 ;;
    07) QBVERSION=3.3.13 ;;
    08) QBVERSION=3.3.14 ;;
    09) QBVERSION=3.3.15 ;;
    10) QBVERSION=3.3.16 ;;
    11) QBVERSION=NO ;;
    1) QBVERSION=3.3.7 ;;
    2) QBVERSION=3.3.8 ;;
    3) QBVERSION=3.3.9 ;;
    4) QBVERSION=3.3.10 ;;
    5) QBVERSION=3.3.11 ;;
    6) QBVERSION=3.3.12 ;;
    7) QBVERSION=3.3.13 ;;
    8) QBVERSION=3.3.14 ;;
    9) QBVERSION=3.3.15 ;;
    *) QBVERSION=3.3.11 ;;
  esac
  if [ $QBVERSION == "NO" ]; then
    echo "${zidingyi1}qBittorrent will ${repo_title}not${zidingyi1} be installed${normal}"
    echo  
  else 
    echo "${zidingyi1}qBittorrent $QBVERSION${normal} will be installed"
    echo  
  mkdir -p /home/${ANUSER}/qbittorrent/download
  mkdir -p /home/${ANUSER}/qbittorrent/watch
  fi
}




# 询问需要安装的 Deluge 版本
function _askdeluge() {
  echo -e "01) Deluge ${cyan}1.3.11${normal}"
  echo -e "02) Deluge ${cyan}1.3.12${normal}"
  echo -e "03) Deluge ${cyan}1.3.13${normal}"
  echo -e "04) Deluge ${cyan}1.3.14${normal}"
  echo -e "05) Deluge ${cyan}1.3.15${normal} (default)"
  echo -e "06) Do not install Deluge"
  echo -ne "${bold}${yellow}What version of Deluge do you want?${normal} (Default ${cyan}05${normal}): "; read version
  case $version in
    01) DEVERSION=1.3.11 ;;
    02) DEVERSION=1.3.12 ;;
    03) DEVERSION=1.3.13 ;;
    04) DEVERSION=1.3.14 ;;
    05 | "") DEVERSION=1.3.15 ;;
    06) DEVERSION=NO ;;
    1) DEVERSION=1.3.11 ;;
    2) DEVERSION=1.3.12 ;;
    3) DEVERSION=1.3.13 ;;
    4) DEVERSION=1.3.14 ;;
    5) DEVERSION=1.3.15 ;;
    6) DEVERSION=NO ;;
    *) DEVERSION=1.3.15 ;;
  esac
  if [ $DEVERSION == "NO" ]; then
    echo "${zidingyi1}Deluge will ${repo_title}not${zidingyi1} be installed${normal}"
  else 
    echo "${zidingyi1}Deluge $DEVERSION${normal} will be installed"
  fi
}




# 询问需要安装的 Deluge libtorrent 版本
function _askdelt() {
  if [ $DEVERSION == "NO" ]; then
    echo  
  else
    echo  
    echo -e "01) libtorrent ${cyan}RC_0_16${normal}"
    echo -e "02) libtorrent ${cyan}RC_1_0${normal}"
    echo -e "03) libtorrent ${cyan}1.1.3${normal}"
    echo -e "04) libtorrent ${cyan}repo${normal} (default)"
    echo -e "05) libtorrent ${cyan}dev${normal} (unstable)"
    echo -ne "${bold}${yellow}What version of libtorrent-rasterbar do you want to be used for Deluge?${normal} (Default ${cyan}04${normal}): "; read version
    case $version in
      1) DELTVERSION=RC_0_16 ;;
      2) DELTVERSION=RC_1_0 ;;
      3) DELTVERSION=libtorrent-1_1_3 ;;
      4 | "") DELTVERSION=NO ;;
      5) DELTVERSION=master ;;
      01) DELTVERSION=RC_0_16 ;;
      02) DELTVERSION=RC_1_0 ;;
      03) DELTVERSION=libtorrent-1_1_3 ;;
      04) DELTVERSION=NO ;;
      05) DELTVERSION=master ;;
      *) DELTVERSION=RC_1_0 ;;
    esac
    if [ $DELTVERSION == "NO" ]; then
      echo "libtorrent will be installed from repo"
    elif [ $DELTVERSION == "master" ]; then
      echo "${zidingyi1}libtorrent dev${normal} will be installed"
    elif [ $DELTVERSION == "libtorrent-1_1_3" ]; then
      echo "${zidingyi1}libtorrent 1.1.3${normal} will be installed"
    else 
      echo "${zidingyi1}libtorrent $DELTVERSION${normal} will be installed"
    fi
    mkdir -p /home/${ANUSER}/deluge/download
    mkdir -p /home/${ANUSER}/deluge/watch
    echo
  fi
}




# 询问需要安装的 rTorrent 版本
function _askrt() {
  echo -e "01) rTorrent ${cyan}0.9.3${normal}"
  echo -e "02) rTorrent ${cyan}0.9.4${normal} (default)"
  echo -e "03) rTorrent ${cyan}0.9.4 (with unoffical ipv6 support)${normal}"
  echo -e "04) rTorrent ${cyan}0.9.6 (with offical ipv6 support)${normal}"
  echo -e "05) Do not install rTorrent"
  echo -ne "${bold}${yellow}What version of rTorrent do you want?${normal} (Default ${cyan}02${normal}): "; read version
  case $version in
    01) RTVERSION=0.9.3 ;;
    02 | "") RTVERSION=0.9.4 ;;
    03) RTVERSION=0.9.4-6 ;;
    04) RTVERSION=0.9.6 ;;
    05) RTVERSION=NO ;;
    1) RTVERSION=0.9.3 ;;
    2) RTVERSION=0.9.4 ;;
    3) RTVERSION=0.9.4-6 ;;
    4) RTVERSION=0.9.6 ;;
    5) RTVERSION=NO ;;
    *) RTVERSION=0.9.4 ;;
  esac
  if [ $RTVERSION == "NO" ]; then
    echo "${zidingyi1}rTorrent will ${repo_title}not${zidingyi1} be installed${normal}"
    echo
  elif [ $RTVERSION == "0.9.4-6" ]; then
    echo "${zidingyi1}rTorrent 0.9.4 (with unoffical ipv6 support)${normal} and ${zidingyi1}h5ai${normal} will be installed"
    echo
  elif [ $RTVERSION == "0.9.6" ]; then
    echo "${zidingyi1}rTorrent 0.9.6 (feature-bind branch)${normal} and ${zidingyi1}h5ai${normal} will be installed"
    echo
  else 
    echo "${zidingyi1}rTorrent $RTVERSION${normal}and ${zidingyi1}h5ai${normal} will be installed"
    echo
  fi
}




# 询问是否需要安装 Flexget
function _askflex() {
  echo -ne "${bold}${yellow}Would you like to install Flexget? (Used for RSS)${normal} [Y]es or [${cyan}N${normal}]o: "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss]) flexget=YES ;;
    [nN] | [nN][Oo] | "" ) flexget=NO ;;
    *) flexget=NO ;;
  esac
  if [ $flexget == "YES" ]; then
    echo "${zidingyi1}Flexget${normal} will be installed"
  else 
    echo "${zidingyi1}Flexget will ${repo_title}not${zidingyi1} be installed${normal}"
  fi
  echo
}




# 询问是否需要安装 rclone
function _askrclone() {
  echo -ne "${bold}${yellow}Would you like to install rclone? (Used for sync files to cloud drives)${normal} [Y]es or [${cyan}N${normal}]o: "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss]) rclone=YES ;;
    [nN] | [nN][Oo] | "" ) rclone=NO ;;
    *) rclone=NO ;;
  esac
  if [ $rclone == "YES" ]; then
    echo "${zidingyi1}rclone${normal} will be installed"
  else 
    echo "${zidingyi1}rclone will ${repo_title}not${zidingyi1} be installed${normal}"
  fi
  echo
}




# 询问是否需要设置快捷命令
function _askcommands() {
  echo -ne "${bold}${yellow}Would you like to use quick commands? ${normal} [Y]es or [${cyan}N${normal}]o: "; read responce
  case $responce in
    [yY] | [yY][Ee][Ss]) commands=YES ;;
    [nN] | [nN][Oo] | "" ) commands=NO ;;
    *) commands=NO ;;
  esac
  if [ $commands == "YES" ]; then
    echo "${zidingyi1}Quick commands${normal} will be configured"
  else 
    echo "${zidingyi1}Quick commands will ${repo_title}not${zidingyi1} be configured${normal}"
  fi
  echo
}




# 询问是否继续
function _askcontinue() {
  export serverip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
  echo
  echo "Press ${standout}${green}ENTER${normal} when you're ready to begin or ${standout}${red}Ctrl+Z${normal} to cancel" ;read input
}




# 编译安装 qBittorrent
function _installqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd
  else
    apt-get update 
    apt-get install -y libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools python geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git 
    cd
    git clone -b RC_1_0 https://github.com/arvidn/libtorrent.git 
    cd libtorrent
    ./autotool.sh 
    ./configure --disable-debug --enable-encryption --prefix=/usr --with-libgeoip=system 
    make clean 
    make -j$(nproc) 
    make install 
    cd
    git clone -b release-${QBVERSION} https://github.com/qbittorrent/qBittorrent.git 
    cd qBittorrent
    ./configure --prefix=/usr --disable-gui 
    make -j$(nproc) 
    make install 
    cd
    rm -rf libtorrent qBittorrent
    echo;echo;echo 
    echo "  QBITTORRENT-INSTALLATION-COMPLETED  " 
    echo;echo;echo 
  fi
}




# 设置 qBittorrent
function _setqbt() {
  if [ $QBVERSION == "NO" ]; then
    cd
  else

  cat >/etc/systemd/system/qbittorrent.service<<EOF
[Unit]
Description=qBittorrent Daemon Service
After=network.target

[Service]
User=root
ExecStart=/usr/bin/qbittorrent-nox --webui-port=2017
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF



  mkdir -p /root/.config/qBittorrent
  cat >/root/.config/qBittorrent/qBittorrent.conf<<EOF
[LegalNotice]
Accepted=true

[Preferences]
Connection\GlobalDLLimitAlt=0
Connection\GlobalUPLimitAlt=0
Bittorrent\MaxConnecs=-1
Bittorrent\MaxConnecsPerTorrent=-1
Bittorrent\MaxRatioAction=0
General\Locale=zh
Queueing\QueueingEnabled=false
WebUI\Port=2017
EOF

  systemctl daemon-reload 
  systemctl enable qbittorrent 
  fi
}




# 编译安装 Deluge
function _installde() {
  if [ $DEVERSION == "NO" ]; then
    cd 
  else
    if [ $DELTVERSION == "NO" ]; then
      cd 
      apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako
      wget -q http://download.deluge-torrent.org/source/deluge-$DEVERSION.tar.gz 
      tar zxf deluge*.tar.gz
      cd deluge*
      python setup.py build
      python setup.py install --install-layout=deb
      cd
      rm -rf deluge*
      echo;echo;echo
      echo "  DE-INSTALLATION-COMPLETED  "
      echo;echo;echo
    else
      cd
      apt-get install -y git build-essential checkinstall libboost-system-dev libboost-python-dev libboost-chrono-dev libboost-random-dev libssl-dev git libtool automake autoconf
      git clone -b ${DELTVERSION} https://github.com/arvidn/libtorrent.git
      cd libtorrent
      ./autotool.sh
      ./configure --enable-python-binding --with-libiconv
      make -j$(nproc)
      checkinstall -y
      ldconfig
      cd
      apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako
      wget -q http://download.deluge-torrent.org/source/deluge-$DEVERSION.tar.gz 
      tar zxf deluge*.tar.gz 
      cd deluge* >/dev/null 2>&1
      python setup.py build 
      python setup.py install --install-layout=deb 
      cd >/dev/null 2>&1
      rm -rf deluge* libtorrent
      echo;echo;echo 
      echo "  DE-INSTALLATION-COMPLETED  " 
      echo;echo;echo 
    fi
  fi
}




# 设置 Deluge 启动脚本
function _setde() {
  if [ $DEVERSION == "NO" ]; then
    cd
  else

  cat >/etc/systemd/system/deluged.service<<EOF
[Unit]
Description=Deluge Daemon Service
After=network.target

[Service]
LimitNOFILE=100000
User=root
ExecStart=/usr/bin/deluged -d -l /var/log/deluge/daemon.log -L warning

[Install]
WantedBy=multi-user.target
EOF

  cat >/etc/systemd/system/deluge-web.service<<EOF
[Unit]
Description=Deluge Bittorrent Client Web Interface
After=network.target
[Service]
Type=simple
User=root
ExecStart=/usr/bin/deluge-web -l /var/log/deluge/weberror.log -L error
ExecStop=/usr/bin/killall -w -s 9 /usr/bin/deluge-web
TimeoutStopSec=300
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

  mkdir -p /var/log/deluge/web
  chmod -R 777 /var/log/deluge
  touch /var/log/deluge/daemon.log
  touch /var/log/deluge/weberror.log

  systemctl daemon-reload
  systemctl enable /etc/systemd/system/deluge-web.service
  systemctl enable /etc/systemd/system/deluged.service
  fi
}




# 使用 rtinst 安装 rTorrent
function _installrt() {
  if [ $RTVERSION == "NO" ]; then
    cd
  elif [ $RTVERSION == "0.9.4-6" ]; then
    export RTVERSION=0.9.4
    wget https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup
    bash rtsetup h5ai-ipv6
    sed -i "s/rtorrentrel=''/rtorrentrel='${RTVERSION}'/g" /usr/local/bin/rtinst
    rtinst -t -l -y -u ${ANUSER} -p ${ANPASS} -w ${WEBPASS}
    export serverip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
    echo;echo;echo
  elif [ $RTVERSION == "0.9.4" ]; then
    wget https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup
    bash rtsetup h5ai
    sed -i "s/rtorrentrel=''/rtorrentrel='${RTVERSION}'/g" /usr/local/bin/rtinst
    rtinst -t -l -y -u ${ANUSER} -p ${ANPASS} -w ${WEBPASS}
    export serverip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
    echo;echo;echo
  else
    wget https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup
    bash rtsetup h5ai-ipv6
    sed -i "s/rtorrentrel=''/rtorrentrel='${RTVERSION}'/g" /usr/local/bin/rtinst
    rtinst -t -l -y -u ${ANUSER} -p ${ANPASS} -w ${WEBPASS}
    export serverip=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
    echo;echo;echo
  fi
}




# 安装 Flexget
function _installflex() {
  apt-get -y install python-pip 
  pip install --upgrade setuptools 
  pip install flexget 
  cd  
  mkdir .flexget 
  cd .flexget 
  touch config.yml 
  cd 
  echo;echo;echo 
  echo "  FLEXGET-INSTALLATION-COMPLETED  " 
  echo;echo;echo 
}




# 安装 rclone
function _installrclone() {
  cd 
  wget https://downloads.rclone.org/rclone-current-linux-amd64.zip 
  unzip rclone-current-linux-amd64.zip 
  cd rclone-*-linux-amd64 
  cp rclone /usr/bin/ 
  chown root:root /usr/bin/rclone 
  chmod 755 /usr/bin/rclone 
  mkdir -p /usr/local/share/man/man1 
  cp rclone.1 /usr/local/share/man/man1 
  mandb 
  cd 
  rm -rf rclone* 
  echo;echo;echo 
  echo "  RCLONE-INSTALLATION-COMPLETED  " 
  echo;echo;echo 
}




# 设置快捷命令
function _setcommands() {
if [ $commands == "NO" ]; then
  echo
else
  cat>>/etc/bash.bashrc<<EOF
alias qba="systemctl start qbittorrent"
alias qbb="systemctl stop qbittorrent"
alias qbc="systemctl status qbittorrent"
alias qbr="systemctl restart qbittorrent"
alias dea="systemctl start deluged"
alias deb="systemctl stop deluged"
alias dec="systemctl status deluged"
alias der="systemctl restart deluged"
alias dewa="systemctl start deluge-web"
alias dewb="systemctl stop deluge-web"
alias dewc="systemctl status deluge-web"
alias dewr="systemctl restart deluge-web"
alias rta="sudo -u ${ANUSER} rt start"
alias rtb="sudo -u ${ANUSER} rt stop"
alias rtr="sudo -u ${ANUSER} rt restart"
alias flexa="flexget daemon start --daemonize"
alias flexb="flexget daemon stop"
alias flexc="flexget daemon status"
alias flexs="nano /root/.flexget/config.yml"
alias cdde="cd /home/${ANUSER}/deluge/download && ls -l"
alias cdqb="cd /home/${ANUSER}/qbittorrent/download && ls -l"
alias cdrt="cd /home/${ANUSER}/rtorrent/download && ls -l"
alias shanchu="rm -rf"
alias xiugai="nano /etc/bash.bashrc && source /etc/bash.bashrc"
EOF
  source /etc/bash.bashrc
fi
}




# 结尾
function _end() {
  echo
  echo -e " ${zidingyi1}    Installation Completed    ${normal} "
  echo
  if [ $QBVERSION == "NO" ] && [ $DEVERSION == "NO" ] && [ $RTVERSION == "NO" ] && [ $flexget == "NO" ] && [ $rclone == "NO" ] && [ $commands == "NO" ]; then
    echo '####################################################################'
    echo "#   "
    echo "#   "
    echo "#   ${yellow}${bold}你们刷子千万要注意啊，不要见着风，是得雨！${normal}"
    echo "#   "
    echo "#   "
    echo '####################################################################'
    echo
    echo
  else
    if [ $QBVERSION == "NO" ]; then
      cd >> /dev/null 2>&1
    else
      echo -e " ${cyan}qBittorrent WebUI${normal} http://${serverip}:2017"
    fi
    
    if [ $DEVERSION == "NO" ]; then
      cd >> /dev/null 2>&1
    else
      echo -e " ${cyan}Deluge WebUI${normal}      http://${serverip}:8112"
    fi
    
    if [ $RTVERSION == "NO" ]; then
      cd >> /dev/null 2>&1
    else
      echo -e " ${cyan}RuTorrent${normal}         https://${ANUSER}:${WEBPASS}@${serverip}/rutorrent"
    fi
    
    if [ $commands == "NO" ]; then
      cd
    else
      echo
      echo -e " ${message_title}我有必要告诉你们一些人生的经验${normal}"
      echo
      echo '###################################################################################################'
      echo "#                                                                                                 #"
      echo -e "#  ${green}qba${normal} = 运行 qBittorrent-nox  ${green}dea${normal} = 运行 Deluged  ${green}dewa${normal} = 运行 Deluge WebUI  ${green}rta${normal} = 运行 rTorrent  #"
      echo -e "#  ${green}qbb${normal} = 关闭 qBittorrent-nox  ${green}deb${normal} = 关闭 Deluged  ${green}dewb${normal} = 关闭 Deluge WebUI  ${green}rtb${normal} = 关闭 rTorrent  #"
      echo -e "#  ${green}qbc${normal} = 检查 qBittorrent-nox  ${green}dec${normal} = 检查 Deluged  ${green}dewc${normal} = 检查 Deluge WebUI  ${green}   ${normal}                  #"
      echo -e "#  ${green}qbr${normal} = 重启 qBittorrent-nox  ${green}der${normal} = 重启 Deluged  ${green}dewr${normal} = 重启 Deluge WebUI  ${green}rtr${normal} = 重启 rTorrent  #"
      echo "#                                                                                                 #"
      echo -e "#  ${green}cdde${normal}    = 切换目录到 de 的下载目录并显示内容    ${green}flexa${normal} = 运行 Flexget daemon                    #"
      echo -e "#  ${green}cdrt${normal}    = 切换目录到 rt 的下载目录并显示内容    ${green}flexb${normal} = 关闭 Flexget daemon                    #"
      echo -e "#  ${green}cdqb${normal}    = 切换目录到 qb 的下载目录并显示内容    ${green}flexc${normal} = 检查 Flexget daemon                    #"
      echo -e "#  ${green}shanchu${normal} = rm -rf，删除                          ${green}flexs${normal} = 编辑 Flexget 配置文件                  #"
      echo -e "#  ${green}xiugai${normal}  = 编辑快捷命令                                                                         #"
      echo "#                                                                                                 #"
      echo '###################################################################################################'
      echo
    fi
    echo
    echo '        :iLKW######Ef:                       ,fDKKEDj;::         '
    echo '  #KE####j           f######f        tDW###Wf          ,W####### '
    echo '  ####j                   t#########EW#f                   ##### '
    echo '  LW##                      ######KE#W                      ##WK '
    echo '    WG                      i###KG###i                      ##   '
    echo '    WK                      f#t    ;#i                      WE   '
    echo '    i#                      ##      ##                      #.   '
    echo '     W                     D#.      :#E                     W    '
    echo '     KL                   DW;        f#i                   fL    '
    echo '      W,                 GWi          tW:                  #     '
    echo '      :KW              ,#W              W#                #,     '
    echo '         WW#W:     ,K#Kj                  WWD.        ,#Kf       '
    echo '             .:W#:,                           :ftGWEf;           '
    echo
    echo
    echo '########################################################################'
    echo "#                                                                      #"
    echo "#                                                                      #"
    echo "#                    ${yellow}${bold}很惭愧，就做了一点微小的工作。${normal}                    #"
    echo "#                                                                      #"
    echo "#                                                                      #"
    echo '########################################################################'
  echo
  echo
  fi
}




# 结构
_intro
_checkroot
_warning
echo
echo
_askqbt
_askdeluge
_askdelt
_askrt
_askflex
_askrclone
_askcommands
_askcontinue




echo "${bold}${magenta}The selected clients will be installed, this may take between${normal}"
echo "${bold}${magenta}10 and 35 minutes depending on your systems specs${normal}"
echo ""


if [ $QBVERSION == "NO" ] && [ $DEVERSION == "NO" ] && [ $RTVERSION == "NO" ] && [ $flexget == "NO" ] && [ $rclone == "NO" ] && [ $commands == "NO" ]; then
  echo "Skip qBittorrent installation"
fi


if [ $QBVERSION == "NO" ]; then
  echo "Skip qBittorrent installation"
else
  echo -n "Installing qBittorrent ... ";_installqbt
  echo -n "Configuring qBittorrent ... ";_setqbt
fi


if [ $DEVERSION == "NO" ]; then
  echo "Skip Deluge installation"
else
  echo -n "Installing Deluge ... ";_installde
  echo -n "Configuring Deluge ... ";_setde
fi


if [ $RTVERSION == "NO" ]; then
  echo "Skip rTorrent installation"
else
  echo -n "Installing rTorrent ... ";_installrt
fi


if [ $flexget == "NO" ]; then
  echo "Skip Flexget installation"
else
  echo -n "Installing Flexget ... ";_installflex
fi


if [ $rclone == "NO" ]; then
  echo "Skip rclone installation"
else
  echo -n "Installing rclone ... ";_installrclone
fi


if [ $commands == "NO" ]; then
  echo "Skip Configure quick commands"
else
  echo -n "Configuring quick commands ... ";_setcommands
fi


clear
_end

