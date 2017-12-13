#!/bin/bash
# https://github.com/Aniverse/inexistence
# Author: 弱鸡
#
# 四处抄来的，参考资料见 GitHub
#
# 无脑root，无脑777权限
# --------------------------------------------------------------------------------
### 颜色样式 ###
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue}; bailvse=${white}${on_green};
baiqingse=${white}${on_cyan}; baihongse=${white}${on_red}; baizise=${white}${on_magenta};
heibaise=${black}${on_white};
shanshuo=$(tput blink); wuguangbiao=$(tput civis); guangbiao=$(tput cnorm)
# --------------------------------------------------------------------------------
### 硬盘计算 ###
calc_disk() {
    local total_size=0
    local array=$@
    for size in ${array[@]}
    do
        [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
        [ "`echo ${size:(-1)}`" == "K" ] && size=0
        [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
        [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
        [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
        total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
    done
    echo ${total_size}
}
# --------------------------------------------------------------------------------
### 是否为 IP 地址 ###
function isValidIpAddress() {
	echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$'
}

### 是否为内网 IP 地址 ###
function isInternalIpAddress() {
	echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))'
}
# --------------------------------------------------------------------------------
# 检查客户端安装情况
function _check_install_1(){
  client_location=$( command -v ${client_name} )

  if [[ "${client_name}" == "qbittorrent-nox" ]]; then
      client_name=qb
  elif [[ "${client_name}" == "transmission-daemon" ]]; then
      client_name=tr
  elif [[ "${client_name}" == "deluged" ]]; then
      client_name=de
  elif [[ "${client_name}" == "rtorrent" ]]; then
      client_name=rt
  elif [[ "${client_name}" == "flexget" ]]; then
      client_name=flex
  fi

  if [[ -a $client_location ]]; then
      eval "${client_name}"_installed=Yes
  else
      eval "${client_name}"_installed=No
  fi
}

function _check_install_2(){
for apps in qbittorrent-nox deluged rtorrent transmission-daemon flexget rclone virt-what lsb_release smartctl irssi ffmepg mediainfo; do
    client_name=$apps; _check_install_1
done
}
# --------------------------------------------------------------------------------
### 随机数 ###
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------
###   Downloads\ScanDirsV2=@Variant(\0\0\0\x1c\0\0\0\0)
###   ("yakkety"|"xenial"|"wily"|"jessie"|"stretch"|"zesty"|"artful")
# --------------------------------------------------------------------------------









clear

# --------------------- 系统检查 --------------------- #
function _intro() {
  echo "${bold}Now the script is installing ${yellow}lsb-release${white} and ${yellow}virt-what${white} for seedbox spec detection ...${normal}"
  apt-get -yqq install lsb-release virt-what >> /dev/null 2>&1
  DISTRO=$(lsb_release -is)
  RELEASE=$(lsb_release -rs)
  CODENAME=$(lsb_release -cs)
  SETNAME=$(lsb_release -rc)
  arch=$( uname -m )
  lbit=$( getconf LONG_BIT )
  relno=$(lsb_release -sr | cut -d. -f1)
  kern=$( uname -r )
  kv1=$(uname -r | cut  -d. -f1)
  kv2=$(uname -r | cut  -d. -f2)
  kv3=$(echo $kv1.$kv2)
  kv4=$(uname -r | cut  -d- -f1)
  kv5=$(uname -r | cut  -d- -f2)
  kv6=$(uname -r | cut  -d- -f3)

  echo "${bold}Checking your server's public IP address ...${normal}"
# echo "${bold}If you stick here for quite a while, please press ${red}Ctrl+C${white} to stop the script${normal}"
  serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
  isInternalIpAddress "$serveripv4" || serveripv4=$(wget --no-check-certificate --timeout=10 -qO- http://v4.ipv6-test.com/api/myip.php)
  isValidIpAddress "$serveripv4" || serveripv4=$(curl -s --connect-timeout 10 ip.cn | awk -F'：' '{print $2}' | awk '{print $1}')
  isValidIpAddress "$serveripv4" || serveripv4=$(curl -s --connect-timeout 10 ifconfig.me)
  isValidIpAddress "$serveripv4" || echo "${bold}${red}ERROR${red} Failed to detect your public IPv4 address ...${normal}"
  serveripv6=$( wget --no-check-certificate -qO- -t1 -T2 ipv6.icanhazip.com )

  _check_install_2

  virtua=$(virt-what) 2>/dev/null
  cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
  cputhreads=$( grep 'processor' /proc/cpuinfo | sort -u | wc -l )
  cpucores=$( grep 'core id' /proc/cpuinfo | sort -u | wc -l )
  disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
  disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
  disk_total_size=$( calc_disk ${disk_size1[@]} )
  disk_used_size=$( calc_disk ${disk_size2[@]} )
  freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
  tram=$( free -m | awk '/Mem/ {print $2}' )
  uram=$( free -m | awk '/Mem/ {print $3}' )

  clear

  wget --no-check-certificate --timeout=5 -qO- https://raw.githubusercontent.com/Aniverse/inexistence/master/03.Files/inexistence.logo.1

  echo "${bold}---------- [System Information] ----------${normal}"
  echo

  echo -ne "  IPv4    : "
  if [[ "${serveripv4}" ]]; then
      echo -e "${cyan}$serveripv4${normal}"
  else
      echo -e "${cyan}No Public IPv4 Address Found${normal}"
  fi

  echo -ne "  IPv6    : "
  if [[ "${serveripv6}" ]]; then
      echo -e "${cyan}$serveripv6${normal}"
  else
      echo -e "${cyan}No IPv6 Address Found${normal}"
  fi

  echo "  CPU     : ${cyan}$cname${normal}"
  echo "  Cores   : ${cyan}${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
  echo "  Mem     : ${cyan}$tram MB ($uram MB Used)${normal}"
  echo "  Disk    : ${cyan}$disk_total_size GB ($disk_used_size GB Used)${normal}"
  echo "  OS      : ${cyan}$DISTRO $RELEASE $CODENAME ($arch) ${normal}"
  echo "  Kernel  : ${cyan}$kern${normal}"

  echo -ne "  Virt    : "
  if [[ "${virtua}" ]]; then
      echo -e "${cyan}$virtua${normal}"
  else
      echo -e "${cyan}No Virt${normal}"
  fi

  echo
  if [ ! -x  /usr/bin/lsb_release ]; then
      echo "Too young! It looks like you are running $DISTRO, which is not supported by this script"
      echo "Exiting..."
      exit 1
  fi
  if [[ ! "$DISTRO" =~ ("Ubuntu"|"Debian") ]]; then
      echo "$DISTRO: ${alert}Too simple! It looks like you are running $DISTRO, which is not supported by this script${normal} "
      echo 'Exiting...'
      exit 1
  elif [[ ! "$CODENAME" =~ ("xenial"|"jessie"|"stretch") ]]; then
      echo "Too young too simple! You do not appear to be running a supported $DISTRO release"
      echo "${bold}$SETNAME${normal}"
      echo 'Exiting...'
      exit 1
  fi
}




# --------------------- 检查是否以root运行 --------------------- #
function _checkroot() {
  if [[ $EUID != 0 ]]; then
    echo '{title}${bold}Navie! I think this young man will not be able to run this script without root privileges.${normal}'
    echo ' Exiting...'
    exit 1
  fi
  echo "${green}${bold}Excited! You're running as root. Let's make some big news ... ${normal}"
}





# --------------------- 询问是否继续 Type-A --------------------- #
function _warning() {
  echo
  echo -e "${bold}The author of this script is a fool, speaks poor English and knows nothing about Linux or codes"
  echo -e "So you guys should not have any expectations on this garbage, you could use something better instead"
  echo -e "This script will try to do the following things, but it couldn't work fine on every SeedBox"
  echo
  echo -e "${blue} 1. Install the selected version of qBittorrent, Deluge, rTorrent, Transmission"
  echo -e " 2. Install Flexget, rclone, BBR and some other softwares"
  echo -e " 3. Do some system tweaks${normal}"
  echo
  echo -e "${bold}For more information, please refer the guide"
  echo -e "If you do not care about the potential possiblity of installation failure, Press ${bailvse}ENTER${normal} ${bold}to continue"
  echo -e "If you want to exit, you may press ${on_red}Ctrl+C${normal} ";read input
# echo -ne "${guangbiao}"
}





# --------------------- 录入账号密码部分 --------------------- #

# 向用户确认信息，Yes or No
function _confirmation(){
local answer
while true
  do
    read answer
    case $answer in [yY] | [yY][Ee][Ss] | "" ) return 0 ;;
                    [nN] | [nN][Oo] ) return 1 ;;
                    * ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
    esac
  done
}


# 生成随机密码，genln=密码长度
function genpasswd() {
local genln=$1
[ -z "$genln" ] && genln=12
tr -dc A-Za-z0-9 < /dev/urandom | head -c ${genln} | xargs
}


# 询问用户名。检查用户名是否有效的功能以后再做
function _askusername(){

    clear
    echo "${bold}${yellow}The script needs a username${white}"
    echo "The username may only consist of characters and numbers and must start with a character"
    echo "This will be your primary user. It can be an existing user or a new user ${normal}"

    confirm_name=1
    while [ $confirm_name = 1 ]
      do
        echo -ne "${bold}Enter user name: ${normal}${blue}${bold}"
        read -e answerusername
        addname="${answerusername}"
        echo -n "${normal}${bold}Confirm that user name is ${blue}"${answerusername}"${normal}, ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o ? "
        if _confirmation; then
            confirm_name=0
        fi
      done

    ANUSER=$addname
}





# 询问密码。检查密码是否足够复杂的功能以后再做（需要满足 Flexget WebUI 密码复杂度的要求）
function _askpassword() {

local localpass
local exitvalue=0
local password1
local password2

exec 3>&1 >/dev/tty

echo
echo "${bold}${yellow}The script needs a password, it will be used for Unix and WebUI${white} "
echo "The password must consist of characters and numbers and at least 9 chars"

while [ -z $localpass ]
do
  echo "${bold}Please enter the new password, or leave blank to generate a random one${normal}"
  stty -echo
  read -e password1
  stty echo

  if [ -z $password1 ]; then
      echo "${bold}Random password generated${normal} "
      exitvalue=1
      localpass=$(genpasswd)
  elif [ ${#password1} -lt 9 ]; then
      echo "${bold}${red}ERROR${normal} ${bold}Password needs to be at least ${on_yellow}[9]${normal}${bold} chars long${normal}" && continue
  else
      echo "${bold}Enter the new password again${normal} "
      stty -echo
      read -e password2
      stty echo
      if [ $password1 != $password2 ]; then
          echo "${bold}${red}WARNING${normal} ${bold}Passwords do not match${normal}"
      else
          localpass=$password1
      fi
  fi
done

ANPASS=$localpass
exec >&3-
echo "${bold}Password sets to ${blue}$localpass${normal}"
echo
return $exitvalue

}





# --------------------- 询问安装前是否需要更换软件源 --------------------- #
function _askaptsource() {
  echo -ne "${bold}${yellow}Would you like to change sources list ?${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
      [yY] | [yY][Ee][Ss]) aptsources=Yes ;;
      [nN] | [nN][Oo] | "" ) aptsources=No ;;
      *) aptsources=No ;;
  esac
  if [ $aptsources == "Yes" ]; then
      echo "${bold}${baiqingse}/etc/apt/sources.list${normal} ${bold}will be replaced${normal}"
  else
      echo "${baizise}/etc/apt/sources.list will ${baihongse}not${baizise} be replaced${normal}"
  fi
  echo
}





# --------------------- 询问编译安装时需要使用的线程数量 --------------------- #
function _askmt() {
  echo -e "${green}01)${white} Use ${cyan}all${white} avaliable threads (default)"
  echo -e "${green}02)${white} Use ${cyan}half${white} of avaliable threads"
  echo -e "${green}03)${white} Use ${cyan}one${white} thread"
  echo -e "${green}04)${white} Use ${cyan}two${white} threads"
# echo -e   "${red}99)${white} Do not compile, install softwares from repo"

  echo -e "${bold}${red}Note that${normal} ${bold}using more than one thread to compile may cause failure in some cases${normal}"
  echo -ne "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): "; read -e version
  case $version in
      01 | 1 | "") MAXCPUS=$(nproc) ;;
      02 | 2) MAXCPUS=$(echo "$(nproc) / 2"|bc) ;;
      03 | 3) MAXCPUS=1 ;;
      04 | 4) MAXCPUS=2 ;;
      05 | 5) MAXCPUS=No ;;
      *) MAXCPUS=$(nproc) ;;
  esac
  if [ $MAXCPUS == "No" ]; then
      echo "${baiqingse}Deluge/qBittorrent/Transmission will be installed from repo${normal}"
  else
      echo -e "${bold}${baiqingse}[${MAXCPUS}]${normal} ${bold}thread(s) will be used when compiling${normal}"
  fi

  echo
}





# --------------------- 询问需要安装的 qBittorrent 的版本 --------------------- #
function _askqbt() {
  echo -e "${green}01)${white} qBittorrent ${cyan}3.3.7${white}"
# echo -e "${green}02)${white} qBittorrent ${cyan}3.3.8${white}"
# echo -e "${green}03)${white} qBittorrent ${cyan}3.3.9${white}"
# echo -e "${green}04)${white} qBittorrent ${cyan}3.3.10${white}"
  echo -e "${green}05)${white} qBittorrent ${cyan}3.3.11${white} (default)"
  echo -e "${green}06)${white} qBittorrent ${cyan}3.3.12${white}"
  echo -e "${green}07)${white} qBittorrent ${cyan}3.3.13${white}"
  echo -e "${green}08)${white} qBittorrent ${cyan}3.3.14${white}"
  echo -e "${green}09)${white} qBittorrent ${cyan}3.3.15${white}"
  echo -e "${green}10)${white} qBittorrent ${cyan}3.3.16${white}"
  echo -e "${green}11)${white} qBittorrent ${cyan}4.0.2${white}"
  echo -e "${green}30)${white} qBittorrent from ${cyan}repo${white}"
  echo -e "${green}40)${white} qBittorrent from ${cyan}PPA${white} (not supported by Debian)"
  echo -e   "${red}99)${white} Do not install qBittorrent"

  echo -ne "${bold}${yellow}What version of qBittorrent do you want?${normal} (Default ${cyan}05${normal}): "; read -e version
  case $version in
      01 | 1) QBVERSION=3.3.7 ;;
      02 | 2) QBVERSION=3.3.8 ;;
      03 | 3) QBVERSION=3.3.9 ;;
      04 | 4) QBVERSION=3.3.10 ;;
      05 | 5 | "") QBVERSION=3.3.11 ;;
      06 | 6) QBVERSION=3.3.12 ;;
      07 | 7) QBVERSION=3.3.13 ;;
      08 | 8) QBVERSION=3.3.14 ;;
      09 | 9) QBVERSION=3.3.15 ;;
      10) QBVERSION=3.3.16 ;;
      11) QBVERSION=4.0.2 ;;
      30) QBVERSION='Install from repo' ;;
      40) QBVERSION='Install from PPA' ;;
      99) QBVERSION=No ;;
      *) QBVERSION=3.3.11 ;;
  esac

  if [ "${QBVERSION}" == "No" ]; then

      echo "${baizise}qBittorrent will ${baihongse}not${baizise} be installed${normal}"

  elif [ "${QBVERSION}" == "4.0.2" ]; then

      if [ $relno = 8 ]; then
          echo "${bold}${red}WARNING${normal} ${bold}For now, qBittorrent4.X's compilation doesn't work on ${green}Debian 8${normal}"
          QBVERSION=3.3.16
          echo "${bold}The script will use qBittorrent 3.3.16 instead. If you do not want to use this version, press ${baihongse}Ctrl+C${normal}${bold} to exit and run this script again"
          echo "${bold}${baiqingse}qBittorrent "${QBVERSION}"${normal} ${bold}will be installed with ${green}libtorrent-rasterbar 1.0.11${normal}"
      elif [ $relno = 16 ]; then
          QBVERSION='Install from PPA'
          echo "${bold}${baiqingse}qBittorrent 4.0.2${normal} ${bold}will be installed with ${green}libtorrent-rasterbar 1.1.5${normal}"
      else
          echo "${bold}${baiqingse}qBittorrent "${QBVERSION}"${normal} ${bold}will be installed with ${green}libtorrent-rasterbar 1.0.11${normal}"
      fi

  elif [[ "${QBVERSION}" == "Install from repo" ]]; then

      echo -ne "${bold}qBittorrent will be installed from repository, and "

      if [ $relno = 9 ]; then
          echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}qBittorrent 3.3.7-3${normal}"
      elif [ $relno = 8 ]; then
          echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}qBittorrent 3.1.10-1${normal}"
      elif [ $relno = 16 ]; then
          echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}qBittorrent 3.3.1-1${normal}"
      fi

  elif [[ "${QBVERSION}" == "Install from PPA" ]]; then

      if [[ $DISTRO == Debian ]]; then
          echo -e "Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
          echo -e "Change install mode to ${cyan}Install from repo${white}"
          QBVERSION='Install from repo'
      else
          echo "qBittorrent will be installed from Stable PPA, in most cases it will be the latest version"
      fi

  else

      echo "${bold}${baiqingse}qBittorrent "${QBVERSION}"${normal} ${bold}will be installed with ${green}libtorrent-rasterbar 1.0.11${normal}"

  fi

  echo
}




# --------------------- 询问需要安装的 Deluge 版本 --------------------- #
function _askdeluge() {
  echo -e "${green}01)${white} Deluge ${cyan}1.3.11${white}"
  echo -e "${green}02)${white} Deluge ${cyan}1.3.12${white}"
  echo -e "${green}03)${white} Deluge ${cyan}1.3.13${white}"
  echo -e "${green}04)${white} Deluge ${cyan}1.3.14${white}"
  echo -e "${green}05)${white} Deluge ${cyan}1.3.15${white} (default)"
  echo -e "${green}30)${white} Deluge from ${cyan}repo${white} (default)"
  echo -e "${green}40)${white} Deluge from ${cyan}PPA${white} (not supported by Debian)"
  echo -e   "${red}99)${white} Do not install Deluge"

  echo -ne "${bold}${yellow}What version of Deluge do you want?${normal} (Default ${cyan}05${normal}): "; read -e version
  case $version in
      01 | 1) DEVERSION=1.3.11 ;;
      02 | 2) DEVERSION=1.3.12 ;;
      03 | 3) DEVERSION=1.3.13 ;;
      04 | 4) DEVERSION=1.3.14 ;;
      05 | 5 | "") DEVERSION=1.3.15 ;;
      30) DEVERSION='Install from repo' ;;
      40) DEVERSION='Install from PPA' ;;
      99) DEVERSION=No ;;
      *) DEVERSION=1.3.15 ;;
  esac

  if [ "${DEVERSION}" == "No" ]; then

      echo "${baizise}Deluge will ${baihongse}not${baizise} be installed${normal}"

  elif [[ "${DEVERSION}" == "Install from repo" ]]; then 

      echo -ne "${bold}Deluge will be installed from repository, and "

      if [ $relno = 9 ]; then
          echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}Deluge 1.3.13+git20161130.48cedf63-3${normal}"
      elif [ $relno = 8 ]; then
          echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}Deluge 1.3.10-3+deb8u1${normal}"
      elif [ $relno = 16 ]; then
          echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}Deluge 1.3.12-1ubuntu1${normal}"
      fi

  elif [[ "${DEVERSION}" == "Install from PPA" ]]; then

      if [[ $DISTRO == Debian ]]; then
          echo -e "Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
          echo -e "Change install mode to ${cyan}Install from repo${white}"
          DEVERSION='Install from repo'
      else
          echo "Deluge will be installed from Stable PPA, in most cases it will be the latest version"
      fi

  else

      echo "${bold}${baiqingse}Deluge "${DEVERSION}"${normal} ${bold}will be installed${normal}"

  fi
}




# --------------------- 询问需要安装的 Deluge libtorrent 版本 --------------------- #
function _askdelt() {
  if [[ "${DEVERSION}" == "No" ]] || [[ "${DEVERSION}" == "Install from repo" ]] || [[ "${DEVERSION}" == "Install from PPA" ]]; then
      echo
  else
      echo
      echo -e "${green}01)${white} libtorrent ${cyan}RC_0_16${white}"
      echo -e "${green}02)${white} libtorrent ${cyan}RC_1_0${white}"
      echo -e "${green}03)${white} libtorrent ${cyan}RC_1_1${white} (NOT recommended)"
      echo -e "${green}04)${white} libtorrent from ${cyan}repo${white} (default)"

      echo -ne "${bold}${yellow}What version of libtorrent-rasterbar do you want to be used for Deluge?${normal} (Default ${cyan}04${normal}): "; read -e version
      case $version in
          01 | 1) DELTVERSION=RC_0_16 ;;
          02 | 2) DELTVERSION=RC_1_0 ;;
          03 | 3) DELTVERSION=RC_1_1 ;;
          04 | 4 | "") DELTVERSION=No ;;
          *) DELTVERSION=RC_1_0 ;;
      esac

      if [ $DELTVERSION == "No" ]; then

          echo -ne "${bold}libtorrent-rasterbar will be installed from repo, and "
          if [ $relno = 9 ]; then
              echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}libtorrent 1.1.1${normal}"
          elif [ $relno = 8 ]; then
              echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}libtorrent 0.16.18${normal}"
          elif [ $relno = 16 ]; then
              echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}libtorrent 1.0.7${normal}"
          fi

      else

          echo "${baiqingse}libtorrent $DELTVERSION${normal} ${bold}will be installed${normal}"

      fi

  echo
  fi
}




# --------------------- 询问需要安装的 rTorrent 版本 --------------------- #
function _askrt() {
  echo -e "${green}01)${white} rTorrent ${cyan}0.9.3${white}"
  echo -e "${green}02)${white} rTorrent ${cyan}0.9.4${white} (default)"
  echo -e "${green}03)${white} rTorrent ${cyan}0.9.4${white} (with unoffical ipv6 support)"
  echo -e "${green}04)${white} rTorrent ${cyan}0.9.6${white}"
  echo -e   "${red}99)${white} Do not install rTorrent"

  echo -ne "${bold}${yellow}What version of rTorrent do you want?${normal} (Default ${cyan}02${normal}): "; read -e version
  case $version in
    01 | 1) RTVERSION=0.9.3 ;;
    02 | 2 | "") RTVERSION=0.9.4 ;;
    03 | 3) RTVERSION='0.9.4 ipv6 supported' ;;
    04 | 4) RTVERSION=0.9.6 ;;
    99) RTVERSION=No ;;
    *) RTVERSION=0.9.4 ;;
  esac

  if [ "${RTVERSION}" == "No" ]; then

      echo "${baizise}rTorrent will ${baihongse}not${baizise} be installed${normal}"

  else

      if [ $CODENAME == "stretch" ]; then
          RTVERSION=0.9.6
          echo "${bold}${red}Note that${normal} ${bold}${green}Debian 9${normal} ${bold}is only supported by ${green}rTorrent 0.9.6${normal}"
      fi

      if [ "${RTVERSION}" == "0.9.4 ipv6 supported" ]; then
          echo "${bold}${baiqingse}rTorrent 0.9.4 (with unoffical ipv6 support)${normal} ${bold}will be installed${normal}"
      elif [ "${RTVERSION}" == "0.9.6" ]; then
          echo "${bold}${baiqingse}rTorrent 0.9.6 (feature-bind branch)${normal} ${bold}will be installed${normal}"
      else
          echo "${bold}${baiqingse}rTorrent "${RTVERSION}"${normal} ${bold}will be installed${normal}"
      fi

  fi

  echo
}




# --------------------- 询问需要安装的 Transmission 版本 --------------------- #
function _asktr() {
  echo -e "${green}01)${white} Transmission ${cyan}2.77${white}"
  echo -e "${green}02)${white} Transmission ${cyan}2.82${white}"
  echo -e "${green}03)${white} Transmission ${cyan}2.84${white}"
  echo -e "${green}04)${white} Transmission ${cyan}2.92${white} (default)"
  echo -e "${green}30)${white} Transmission from ${cyan}repo${white} (default)"
  echo -e "${green}40)${white} Transmission from ${cyan}PPA${white} (not supported by Debian)"
  echo -e   "${red}99)${white} Do not install Transmission"

  echo -ne "${bold}${yellow}What version of Transmission do you want?${normal} (Default ${cyan}04${normal}): "; read -e version
  case $version in
      01 | 1) TRVERSION=2.77 ;;
      02 | 2) TRVERSION=2.82 ;;
      03 | 3) TRVERSION=2.84 ;;
      04 | 4 | "") TRVERSION=2.92 ;;
      30) TRVERSION='Install from repo' ;;
      40) TRVERSION='Install from PPA' ;;
      99) TRVERSION=No ;;
      *) TRVERSION=2.92 ;;
  esac

  if [ "${TRVERSION}" == "No" ]; then
      echo "${baizise}Transmission will ${baihongse}not${baizise} be installed${normal}"
  else

      if [ "$CODENAME" = "stretch" ]; then

          ecgo "Sorry, for now the compilation on Debian 9 doesn't work"
          echo "For ${green}${bold}Debian 9${normal}${bold}, Transmission will be installed from repo which version is ${baiqingse}Transmission 2.92-2${normal}"
          TRVERSION='Install from repo'

      else

          if [[ "${TRVERSION}" == "Install from repo" ]]; then 
              echo -ne "${bold}Transmission will be installed from repository, and "

              if [ "$CODENAME" = "stretch" ]; then
                  echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}Transmission 2.92-2${normal}"
              elif [ "$CODENAME" = "jessie" ]; then
                  echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}Transmission 2.84-0.2${normal}"
              elif [ "$CODENAME" = "xenial" ]; then
                  echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}Transmission 2.84-3ubuntu3${normal}"
              fi

          elif [[ "${TRVERSION}" == "Install from PPA" ]]; then

              if [[ $DISTRO == Debian ]]; then
                  echo -e "Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
                  echo -e "Change install mode to ${cyan}Install from repo${white}"
                  TRVERSION='Install from repo'
              else
                  echo "Transmission will be installed from Stable PPA, in most cases it will be the latest version"
              fi

          fi

          echo "${bold}${baiqingse}Transmission "${TRVERSION}"${normal} ${bold}will be installed${normal}"

      fi

  fi
  echo
}





# --------------------- 询问是否需要安装 Flexget --------------------- #
function _askflex() {
  echo -ne "${bold}${yellow}Would you like to install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
    [yY] | [yY][Ee][Ss]) flexget=Yes ;;
    [nN] | [nN][Oo] | "" ) flexget=No ;;
    *) flexget=No ;;
  esac
  if [ $flexget == "Yes" ]; then
      echo "${bold}${baiqingse}Flexget${normal} ${bold}will be installed${normal}"
  else
      echo "${baizise}Flexget will ${baihongse}not${baizise} be installed${normal}"
  fi
  echo
}





# --------------------- 询问是否需要安装 rclone --------------------- #
function _askrclone() {
  echo -ne "${bold}${yellow}Would you like to install rclone?${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
      [yY] | [yY][Ee][Ss]) rclone=Yes ;;
      [nN] | [nN][Oo] | "" ) rclone=No ;;
      *) rclone=No ;;
  esac
  if [ $rclone == "Yes" ]; then
      echo "${bold}${baiqingse}rclone${normal} ${bold}will be installed${normal}"
  else
      echo "${baizise}rclone will ${baihongse}not${baizise} be installed${normal}"
  fi
  echo
}





# --------------------- 询问是否需要安装 VNC --------------------- #
function _askvnc() {
  echo -ne "${bold}${yellow}Would you like to install VNC? ${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
      [yY] | [yY][Ee][Ss]) vnc=Yes ;;
      [nN] | [nN][Oo] | "" ) vnc=No ;;
      *) vnc=No ;;
  esac
  if [ $tweaks == "Yes" ]; then
      echo "${bold}${baiqingse}VNC${normal} ${bold}will be installed${normal}"
  else
      echo "${baizise}VNC will ${baihongse}not${baizise} be installed${normal}"
  fi
  echo
}





# --------------------- 询问是否需要修改一些设置 --------------------- #
function _asktweaks() {
  echo -ne "${bold}${yellow}Would you like to configure some system settings? ${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
      [yY] | [yY][Ee][Ss]) tweaks=Yes ;;
      [nN] | [nN][Oo] | "" ) tweaks=No ;;
      *) tweaks=No ;;
  esac
  if [ $tweaks == "Yes" ]; then
      echo "${bold}${baiqingse}System tweaks${normal} ${bold}will be configured${normal}"
  else
      echo "${baizise}System tweaks will ${baihongse}not${baizise} be configured${normal}"
  fi
  echo
}




# --------------------- BBR 相关 --------------------- #

# 检查是否已经启用BBR
function check_bbr_status() {
    export bbrstatus=$(sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}')
    if [[ "${bbrstatus}" =~ ("bbr"|"bbr_powered"|"nanqinlang"|"tsunami") ]]; then
        bbrinuse=Yes
    else
        bbrinuse=No
    fi
}


# 检查系统内核版本是否大于4.9
function check_kernel_version() {
  if [[ ${kv1} -ge 4 ]] && [[ ${kv2} -ge 9 ]]; then
      bbrkernel=Yes
  else
      bbrkernel=No
  fi
}


# 询问是否安装BBR
function _askbbr() {
  check_bbr_status
  if [[ "${bbrinuse}" == "Yes" ]]; then
      echo -e "${bold}${yellow}TCP BBR has been installed. Skip it${normal}"
      echo
      bbr=Already\ Installed
  else
      check_kernel_version
      if [[ "${bbrkernel}" == "Yes" ]]; then
          echo -e "${bold}Your kernel version is newer than ${green}4.9${normal}${bold}, but BBR is not enabled${normal}"
          echo -ne "${bold}${yellow}Would you like to use BBR as default congestion control algorithm? ${normal} [${cyan}Y${normal}]es or [N]o: "; read -e responce
          case $responce in
              [yY] | [yY][Ee][Ss] | "" ) bbr=Yes ;;
              [nN] | [nN][Oo]) bbr=No ;;
              *) bbr=Yes ;;
          esac
      else
          echo -e "${bold}Your kernel version is below than ${green}4.9${normal}${bold} while BBR requires at least a ${green}4.9${normal}${bold} kernel"
          echo -e "A new kernel will be installed if BBR is to be installed"
          echo -e "${red}WARNING${normal} ${bold}Installing new kernel may cause reboot failure in some cases${normal}"
          echo -ne "${bold}${yellow}Would you like to install latest kernel and enable BBR? ${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
          case $responce in
              [yY] | [yY][Ee][Ss]) bbr=Yes ;;
              [nN] | [nN][Oo] | "" ) bbr=No ;;
              *) bbr=No ;;
          esac
      fi
      if [ "${bbr}" == "Yes" ]; then
          echo "${bold}${baiqingse}TCP BBR${normal} ${bold}will be installed${normal}"
      else
          echo "${baizise}TCP BBR will ${baihongse}not${baizise} be installed${normal}"
      fi
  fi
  echo
}




# --------------------- 询问是否安装发种工具箱 --------------------- #
# 目前不启用

function _asktools() {
  echo -e "wine, mono, BDinfo, eac3to, MKVToolnix, VNC, mktorrent, ffmpeg, mediainfo ..."
  echo -ne "${bold}${yellow}Would you like to install the above additional softwares related to uploading torrents? ${normal} [Y]es or [${cyan}N${normal}]o: "; read -e responce
  case $responce in
      [yY] | [yY][Ee][Ss]) tools=Yes ;;
      [nN] | [nN][Oo] | "" ) tools=No ;;
      *) tools=No ;;
  esac
  if [ $tools == "Yes" ]; then
      echo "${bold}${baiqingse}Uploading Toolbox${normal} ${bold}will be installed${normal}"
  else
      echo "${baizise}Uploading Toolbox will ${baihongse}not${baizise} be configured${normal}"
  fi
  echo
}




# --------------------- 装完后询问是否重启 --------------------- #
function _askreboot() {
  echo -ne "${bold}${yellow}Would you like to reboot the system now? ${normal} [y/${cyan}N${normal}]: "; read -e is_reboot
  if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
      reboot
  else
      echo -e "Reboot has been canceled..."
      echo
  fi
}




# --------------------- 询问是否继续 Type-B --------------------- #
function _askcontinue() {
  clear
  echo -e "${bold}Please check the following information${normal}"
  echo
  echo '####################################################################'
  echo
  echo -e "                  ${cyan}${bold}Username${normal}      ${bold}${yellow}${ANUSER}${normal}"
  echo -e "                  ${cyan}${bold}Password${normal}      ${bold}${yellow}${ANPASS}${normal}"
  echo
  echo -e "                  ${cyan}${bold}qBittorrent${normal}   ${bold}${yellow}"${QBVERSION}"${normal}"
  echo -e "                  ${cyan}${bold}Deluge${normal}        ${bold}${yellow}"${DEVERSION}"${normal}"
  echo -e "                  ${cyan}${bold}rTorrent${normal}      ${bold}${yellow}"${RTVERSION}"${normal}"
  echo -e "                  ${cyan}${bold}Transmission${normal}  ${bold}${yellow}"${TRVERSION}"${normal}"
  echo -e "                  ${cyan}${bold}Flexget${normal}       ${bold}${yellow}"${flexget}"${normal}"
  echo -e "                  ${cyan}${bold}rclone${normal}        ${bold}${yellow}"${rclone}"${normal}"
# echo -e "                  ${cyan}${bold}UpTools${normal}       ${bold}${yellow}"${tools}"${normal}"
  echo -e "                  ${cyan}${bold}BBR${normal}           ${bold}${yellow}"${bbr}"${normal}"
  echo -e "                  ${cyan}${bold}System tweak${normal}  ${bold}${yellow}"${tweaks}"${normal}"
  echo -e "                  ${cyan}${bold}Threads${normal}       ${bold}${yellow}"${MAXCPUS}"${normal}"
  echo -e "                  ${cyan}${bold}SourceList${normal}    ${bold}${yellow}"${aptsources}"${normal}"
  echo
  echo '####################################################################'
  echo
  echo -e "${bold}If you want to stop or correct some selections, Press ${on_red}Ctrl+C${normal} ${bold}; or Press ${on_green}ENTER${normal} ${bold}to start${normal}" ;read input
  echo ""
  echo "${bold}${magenta}The selected softwares will be installed, this may take between${normal}"
  echo "${bold}${magenta}1 and 90 minutes depending on your systems specs and your selections${normal}"
  echo ""
}





# --------------------- 创建用户、准备工作 --------------------- #

function _setuser() {

starttime=$(date +%s)
apt-get install -y git

if [[ -d /etc/inexistence ]]; then
    mv /etc/inexistence /etc/inexistence2
fi

git clone --depth=1 https://github.com/Aniverse/inexistence /etc/inexistence
mkdir -p /etc/inexistence/01.Log
mkdir -p /etc/inexistence/OLD
local_packages=/etc/inexistence/00.Installation
chmod -R 777 /etc/inexistence

mv /etc/inexistence2/* /etc/inexistence/OLD >> /dev/null 2>&1
rm -rf /etc/inexistence2

if id -u ${ANUSER} >/dev/null 2>&1; then
    echo "${ANUSER} already exists"
else
    adduser --gecos "" ${ANUSER} --disabled-password
    echo "${ANUSER}:${ANPASS}" | sudo chpasswd
fi

sed -i '/^INEXISTEN*/'d /etc/profile
sed -i '/^ANUSER/'d /etc/profile
#sed -i '/^ANPASS/'d /etc/profile
sed -i '/^QBVERSION/'d /etc/profile
sed -i '/^DEVERSION/'d /etc/profile
sed -i '/^TRVERSION/'d /etc/profile
sed -i '/^RTVERSION/'d /etc/profile
sed -i '/^MAXCPUS/'d /etc/profile
sed -i '/^FLEXGETINSTALLED/'d /etc/profile
sed -i '/^RCLONEINSTALLED/'d /etc/profile
sed -i '/^USETWEAKS/'d /etc/profile
sed -i '/^BBRINSTALLED/'d /etc/profile
sed -i '/^UPLOADTOOLS/'d /etc/profile
sed -i '/^APTSOURCES/'d /etc/profile
sed -i '/^VNCINSTALLED/'d /etc/profile
sed -i '/^#####\ U.*/'d /etc/profile

#UPLOADTOOLS=${tools}
#VNCINSTALLED=${vnc}

cat>>/etc/profile<<EOF

##### Used for future script determination #####
INEXISTENCEinstalled=Yes
INEXISTENCEVER=087
INEXISTENCEDATE=20171213
ANUSER=${ANUSER}
QBVERSION="${QBVERSION}"
DEVERSION="${DEVERSION}"
RTVERSION="${RTVERSION}"
TRVERSION="${TRVERSION}"
MAXCPUS=${MAXCPUS}
FLEXGETINSTALLED=${flexget}
RCLONEINSTALLED=${rclone}
USETWEAKS=${tweaks}
BBRINSTALLED=${bbr}
APTSOURCES=${aptsources}
##### U ########################################
EOF

source /etc/profile

}





# --------------------- 替换系统源 --------------------- #

function _setsources() {
  if [ $aptsources == "Yes" ]; then
        if [[ $DISTRO == Debian ]]; then
            cp "${local_packages}"/template/debian.apt.sources /etc/apt/sources.list
            sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
            apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
            apt-get --yes --force-yes update
        elif [[ $DISTRO == Ubuntu ]]; then
            cp "${local_packages}"/template/ubuntu.apt.sources /etc/apt/sources.list
            sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
            apt-get -y update
        fi
  else
      apt-get -y update
  fi

  apt-get install -y wget python ntpdate sysstat wondershaper lrzsz mtr tree figlet toilet lolcat psmisc dirmngr zip unzip locales aptitude smartmontools
}





# --------------------- 编译安装 qBittorrent --------------------- #
function _installqbt() {

  if [ "${QBVERSION}" == "No" ]; then
      cd
  elif [[ "${QBVERSION}" == "Install from repo" ]]; then
      apt-get install -y qbittorrent-nox
  elif [[ "${QBVERSION}" == "Install from PPA" ]]; then
      apt-get install -y software-properties-common
      apt-get install -y python-software-properties
      add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
      apt-get update
      apt-get install -y qbittorrent-nox
  else
      apt-get install -y libqt5svg5-dev libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools  geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git psmisc python python3
      cd
      git clone --depth=1 -b RC_1_0 --single-branch https://github.com/arvidn/libtorrent.git
      cd libtorrent
      ./autotool.sh
      ./configure --disable-debug --enable-encryption --prefix=/usr --with-libgeoip=system
      make clean
      make -j${MAXCPUS}
      make install
      cd
      git clone --depth=1 -b release-${QBVERSION} --single-branch https://github.com/qbittorrent/qBittorrent.git
      cd qBittorrent
      ./configure --prefix=/usr --disable-gui
      make -j${MAXCPUS}
      make install
      cd
      rm -rf libtorrent qBittorrent
      echo;echo;echo;echo;echo;echo "  QBITTORRENT-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

  fi
}




# --------------------- 设置 qBittorrent --------------------- #
function _setqbt() {

  if [ ! "${QBVERSION}" == "No" ]; then

      mkdir -p /root/.config/qBittorrent
      mkdir -p /home/${ANUSER}/qbittorrent/download
      mkdir -p /home/${ANUSER}/qbittorrent/torrent
      mkdir -p /home/${ANUSER}/qbittorrent/watch
      chmod -R 777 /home/${ANUSER}/qbittorrent
      chmod -R 777 /etc/inexistence/01.Log
      mkdir -p /var/www
      ln -s /home/${ANUSER}/qbittorrent/download /var/www/qbittorrent.download

      cp -f "${local_packages}"/template/config/qBittorrent.conf /root/.config/qBittorrent/qBittorrent.conf
      cp -f "${local_packages}"/template/systemd/qbittorrent.service /etc/systemd/system/qbittorrent.service
      QBPASS=$(python "${local_packages}"/script/special/qbittorrent.userpass.py ${ANPASS})
      sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/qBittorrent/qBittorrent.conf
      sed -i "s/SCRIPTQBPASS/${QBPASS}/g" /root/.config/qBittorrent/qBittorrent.conf

      systemctl daemon-reload
      systemctl enable qbittorrent
      systemctl start qbittorrent

  fi
}




# --------------------- 编译安装 Deluge --------------------- #
function _installde() {

  if [ "${DEVERSION}" == "No" ]; then
      cd
  elif [[ "${DEVERSION}" == "Install from repo" ]]; then
      apt-get install -y deluged deluge-web
  elif [[ "${DEVERSION}" == "Install from PPA" ]]; then
      apt-get install -y software-properties-common
      apt-get install -y python-software-properties
      add-apt-repository -y ppa:deluge-team/ppa
      apt-get update
      apt-get install -y deluged deluge-web
  else
      if [ ! $DELTVERSION == "No" ]; then
          cd
          apt-get install -y git build-essential checkinstall libboost-system-dev libboost-python-dev libboost-chrono-dev libboost-random-dev libssl-dev git libtool automake autoconf psmisc
          git clone --depth=1 -b ${DELTVERSION} --single-branch https://github.com/arvidn/libtorrent.git
          cd libtorrent
          ./autotool.sh
          ./configure --enable-python-binding --with-libiconv
          make -j${MAXCPUS}
          checkinstall -y
          ldconfig
          cd
      fi

      apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-libtorrent python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako psmisc
      wget --no-check-certificate -q http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
      tar zxf deluge-"${DEVERSION}".tar.gz
      cd deluge-"${DEVERSION}"
      python setup.py build
      python setup.py install --install-layout=deb
      cd
      rm -rf deluge* libtorrent
      echo;echo;echo;echo;echo;echo "  DELUGE-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

  fi
}




# --------------------- Deluge 启动脚本、配置文件 --------------------- #
function _setde() {

  if [ ! "${DEVERSION}" == "No" ]; then

      mkdir -p /home/${ANUSER}/deluge/download
      mkdir -p /home/${ANUSER}/deluge/torrent
      mkdir -p /home/${ANUSER}/deluge/watch
      mkdir -p /var/www
      ln -s /home/${ANUSER}/deluge/download/ /var/www/deluge.download
      chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/deluge
      chmod -R 777 /home/${ANUSER}/deluge

      cp -f "${local_packages}"/template/systemd/deluged.service /etc/systemd/system/deluged.service
      cp -f "${local_packages}"/template/systemd/deluge-web.service /etc/systemd/system/deluge-web.service

      touch /etc/inexistence/01.Log/deluged.log
      touch /etc/inexistence/01.Log/delugeweb.log
      chmod -R 777 /etc/inexistence/01.Log

      mkdir -p /root/.config
      cd /root/.config
      rm -rf deluge
      cp -f "${local_packages}"/template/config/deluge.config.tar.gz /root/.config/deluge.config.tar.gz
      tar zxf deluge.config.tar.gz
      chmod -R 777 /root/.config
      rm -rf deluge.config.tar.gz
      cd

      DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      DWP=$(python "${local_packages}"/script/special/deluge.userpass.py ${ANPASS} ${DWSALT})
      echo "${ANUSER}:${ANPASS}:10" > /root/.config/deluge/auth
      sed -i "s/delugeuser/${ANUSER}/g" /root/.config/deluge/core.conf
      sed -i "s/DWSALT/${DWSALT}/g" /root/.config/deluge/web.conf
      sed -i "s/DWP/${DWP}/g" /root/.config/deluge/web.conf

      systemctl daemon-reload
      systemctl enable /etc/systemd/system/deluge-web.service
      systemctl enable /etc/systemd/system/deluged.service
      systemctl start deluged
      systemctl start deluge-web

  fi
}




# --------------------- 使用修改版 rtinst 安装 rTorrent，h5ai --------------------- #
function _installrt() {

  wget --no-check-certificate https://raw.githubusercontent.com/Aniverse/rtinst/h5ai-ipv6/rtsetup

  if [ "${RTVERSION}" == "No" ]; then
      cd
  elif [ "${RTVERSION}" == "0.9.4 ipv6 supported" ]; then
      export RTVERSION=0.9.4
      bash rtsetup h5ai-ipv6
  elif [ "${RTVERSION}" == "0.9.4" ]; then
      bash rtsetup h5ai
  else
      bash rtsetup h5ai-ipv6
  fi

wget --no-check-certificate --timeout=10 -q https://raw.githubusercontent.com/Aniverse/rtinst/h5ai-ipv6/rarlinux-x64-5.5.0.tar.gz
tar zxf rarlinux-x64-5.5.0.tar.gz 2>/dev/null
if [ -d rar ]; then
    cp -f rar/rar /usr/bin/rar
    cp -f rar/unrar /usr/bin/unrar
    rm -rf rar
fi

  apt-get install -y libncurses5-dev libncursesw5-dev
  sed -i "s/rtorrentrel=''/rtorrentrel='${RTVERSION}'/g" /usr/local/bin/rtinst
  sed -i "s/make\ \-s\ \-j\$(nproc)/make\ \-s\ \-j${MAXCPUS}/g" /usr/local/bin/rtupdate
  rtinst -t -l -y -u ${ANUSER} -p ${ANPASS} -w ${ANPASS}
  openssl req -x509 -nodes -days 3650 -subj /CN=$serveripv4 -config /etc/ssl/ruweb.cnf -newkey rsa:2048 -keyout /etc/ssl/private/ruweb.key -out /etc/ssl/ruweb.crt
  rtwebmin
  cp -f /home/${ANUSER}/rtinst.log /etc/inexistence/01.Log/rtinst.log
  cp -f /root/rtinst.log /etc/inexistence/01.Log/rtinst.log
  cp -f /home/${ANUSER}/rtinst.info /etc/inexistence/01.Log/rtinst.info
  
# FTPPort=$( cat /etc/inexistence/01.Log/rtinst.info | grep "ftp port" | cut -c20- )
  sed -i '/listen_port/c listen_port=21' /etc/vsftpd.conf
  /etc/init.d/vsftpd start

  apt-get install -y sox libsox-fmt-mp3

  cd /var/www/rutorrent/plugins
  wget --no-check-certificate https://github.com/Aniverse/rtinst/raw/master/spectrogram.tar.gz
  tar zxf spectrogram.tar.gz
  rm -rf spectrogram.tar.gz
  chown -R www-data:www-data spectrogram

  cp -f "${local_packages}"/template/systemd/rtorrent@.service /etc/systemd/system/rtorrent@.service
  cp -f "${local_packages}"/template/systemd/irssi@.service /etc/systemd/system/irssi@.service
  systemctl daemon-reload

  cd
  echo;echo;echo;echo;echo;echo "  RTORRENT-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo
}





# --------------------- 安装 Transmission --------------------- #
function _installtr() {

if [ "${TRVERSION}" == "No" ]; then
    cd
elif [[ "${TRVERSION}" == "Install from repo" ]]; then
    apt-get install -y transmission-daemon
elif [[ "${TRVERSION}" == "Install from PPA" ]]; then
    apt-get install -y software-properties-common
    apt-get install -y python-software-properties
    add-apt-repository -y ppa:transmissionbt/ppa
    apt-get update
    apt-get install -y transmission-daemon
else
    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev ca-certificates libssl-dev pkg-config checkinstall cmake git psmisc
    apt-get install -y openssl
    wget --no-check-certificate https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
    tar xvf release-2.1.8-stable.tar.gz
    cd libevent-release-2.1.8-stable
    ./autogen.sh
    ./configure
    make -j${MAXCPUS}
    make install
    cd
    rm -rf libevent-release-2.1.8-stable release-2.1.8-stable.tar.gz
    ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib/libevent-2.1.so.6

    git clone --depth=1 -b ${TRVERSION} --single-branch https://github.com/transmission/transmission
    cd transmission
    git submodule update --init
    sed -i "s/m4_copy/m4_copy_force/g" m4/glib-gettext.m4
    ./autogen.sh
    ./configure --prefix=/usr
    make -j${MAXCPUS}
    make install
    cd
    rm -rf transmission
    echo;echo;echo;echo;echo;echo "  TR-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

fi
}




# --------------------- 配置 Transmission --------------------- #
function _settr() {

if [ ! "${TRVERSION}" == "No" ]; then
    wget --no-check-certificate -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/tr-control-easy-install.sh | bash
    rm -rf tr-control-easy-install.sh

    rm -rf /root/.config/transmiss*
    mkdir -p /root/.config/transmission-daemon

    cp -f "${local_packages}"/template/config/transmission.settings.json /root/.config/transmission-daemon/settings.json
    cp -f "${local_packages}"/template/systemd/transmission.service /etc/systemd/system/transmission.service
    [[ `command -v transmission-daemon` == /usr/local/bin/transmission-daemon ]] && sed -i "s/usr/usr\/local/g" /etc/systemd/system/transmission.service
    
    sed -i "s/RPCUSERNAME/${ANUSER}/g" /root/.config/transmission-daemon/settings.json
    sed -i "s/RPCPASSWORD/${ANPASS}/g" /root/.config/transmission-daemon/settings.json

    mkdir -p /home/${ANUSER}/transmission/download
    mkdir -p /home/${ANUSER}/transmission/watch
    chmod -R 777 /home/${ANUSER}/transmission
    mkdir -p /var/www
    ln -s /home/${ANUSER}/transmission/download/ /var/www/transmission.download

    systemctl daemon-reload
    systemctl enable transmission
#   systemctl enable /etc/systemd/system/transmission.service
    systemctl start transmission

fi
}




# --------------------- 安装、配置 Flexget --------------------- #
function _installflex() {

  apt-get -y install python-pip
  pip install --upgrade setuptools
  pip install flexget
  pip install transmissionrpc
  pip install --upgrade pip

  cd
  mkdir -p /root/.flexget
  mkdir -p /home/${ANUSER}/qbittorrent/download
  mkdir -p /home/${ANUSER}/qbittorrent/watch
  mkdir -p /home/${ANUSER}/rtorrent/download
  mkdir -p /home/${ANUSER}/rtorrent/watch
  mkdir -p /home/${ANUSER}/transmission/download
  mkdir -p /home/${ANUSER}/transmission/watch
  mkdir -p /home/${ANUSER}/deluge/download
  mkdir -p /home/${ANUSER}/deluge/watch

  cp -f "${local_packages}"/template/config/flexfet.config.yml /root/.flexget/config.yml
  sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.flexget/config.yml
  sed -i "s/SCRIPTPASSWORD/${ANPASS}/g" /root/.flexget/config.yml
  cp -f "${local_packages}"/template/systemd/flexget.service /etc/systemd/system/flexget.service

  systemctl daemon-reload
  systemctl enable /etc/systemd/system/flexget.service

  cd
  flexget web passwd ${ANPASS}
  systemctl start flexget

  echo;echo;echo;echo;echo;echo "  FLEXGET-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo
}




# --------------------- 安装 rclone --------------------- #
function _installrclone() {

  cd
  wget --no-check-certificate https://downloads.rclone.org/rclone-current-linux-amd64.zip
  unzip rclone-current-linux-amd64.zip
  cd rclone-*-linux-amd64
  cp rclone /usr/bin/
  chown root:root /usr/bin/rclone
  chmod 755 /usr/bin/rclone
  mkdir -p /usr/local/share/man/man1
  cp rclone.1 /usr/local/share/man/man1
  mandb
  cd
  rm -rf rclone-*-linux-amd64 rclone-current-linux-amd64.zip
  echo;echo;echo;echo;echo;echo "  RCLONE-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo
}





# --------------------- 安装 BBR --------------------- #
function _installbbr() {
cd
bash "${local_packages}"/script/dalao/bbr1.sh
# 下边增加固件是为了解决 Online.net 服务器安装 BBR 后无法开机的问题
mkdir -p /lib/firmware/bnx2
cp -f "${local_packages}"/03.Files/firmware/bnx2-mips-06-6.2.3.fw /lib/firmware/bnx2/bnx2-mips-06-6.2.3.fw
cp -f "${local_packages}"/03.Files/firmware/bnx2-mips-09-6.2.1b.fw /lib/firmware/bnx2/bnx2-mips-09-6.2.1b.fw
cp -f "${local_packages}"/03.Files/firmware/bnx2-rv2p-09ax-6.0.17.fw /lib/firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw
cp -f "${local_packages}"/03.Files/firmware/bnx2-rv2p-09-6.0.17.fw /lib/firmware/bnx2/bnx2-rv2p-09-6.0.17.fw
cp -f "${local_packages}"/03.Files/firmware/bnx2-rv2p-06-6.0.15.fw /lib/firmware/bnx2/bnx2-rv2p-06-6.0.15.fw
echo;echo;echo;echo;echo;echo "  BBR-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo
}





# --------------------- 安装 VNC --------------------- #
function _installvnc() {

cd
apt-get install -y vnc4server xfonts-intl-chinese-big fcitx locales xfonts-wqy
apt-get install xfce4
#apt-get install -y mate-desktop-environment-extras
vncpasswd=`date +%s | sha256sum | base64 | head -c 8`
vncpasswd <<EOF
$ANPASS
$ANPASS
EOF
vncserver && vncserver -kill :1
mkdir -p .vnc
cp -f "${local_packages}"/script/template/xstartup.1 /root/.vnc/xstartup
cp -f "${local_packages}"/script/template/systemd/vncserver.service /etc/systemd/system/vncserver.service

systemctl daemon-reload
systemctl enable vncserver
systemctl start vncserver

#vncserver -geometry 1366x768

}





# --------------------- 安装 mkvtoolnix／wine／mktorrent／ffmpeg／mediainfo --------------------- #
# 没写完，目前还不会投入使用

function _installtools() {

cd

########## 安装 ffmpeg x265 x264 yasm imagemagick ##########

apt-get install -y imagemagick

if [[ $DISTRO == Ubuntu ]]; then
    apt-get -y install x265
elif [[ $DISTRO == Debian ]]; then
    apt-get -y install -t jessie-backports x265
fi

git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
git clone --depth 1 git://github.com/yasm/yasm ffmpeg/yasm
git clone --depth 1 https://github.com/yixia/x264 ffmpeg/x264

cd ffmpeg/yasm
./autogen.sh
./configure
make -j${MAXCPUS}
make install
cd ../x264
./configure --enable-static --enable-shared
make -j${MAXCPUS}
make install
ldconfig

cd ..
export FC_CONFIG_DIR=/etc/fonts
export FC_CONFIG_FILE=/etc/fonts/fonts.conf
./configure --enable-libfreetype --enable-filter=drawtext --enable-fontconfig --disable-asm --enable-libx264 --enable-gpl
make -j${MAXCPUS}
make install
cp -f /usr/local/bin/ffmpeg /usr/bin
cp -f /usr/local/bin/ffprobe /usr/bin
rm -rf /root/ffmpeg

########## 安装 mkvtoolnix ##########

apt-get install -y apt-transport-https
wget --no-check-certificate -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -

    if [ $relno = 8 ]; then

cat >>/etc/apt/sources.list<<EOF
deb https://mkvtoolnix.download/debian/jessie/ ./
deb-src https://mkvtoolnix.download/debian/jessie/ ./
EOF

    elif [ $relno = 9 ]; then

cat >>/etc/apt/sources.list<<EOF
deb https://mkvtoolnix.download/debian/stretch/ ./
deb-src https://mkvtoolnix.download/debian/stretch/ ./
EOF

    else

cat >>/etc/apt/sources.list<<EOF
deb https://mkvtoolnix.download/ubuntu/xenial/ ./
deb-src https://mkvtoolnix.download/ubuntu/xenial/ ./
EOF

    fi

apt-get update
apt-get install -y mkvtoolnix mkvtoolnix-gui

########### 安装 mediainfo ########## https://mediaarea.net/en/MediaInfo/Download/Debian

if [ $relno = 8 ]; then
    wget --no-check-certificate -qO 1 https://mediaarea.net/download/binary/libzen0/0.4.37/libzen0_0.4.37-1_amd64.Debian_8.0.deb
    wget --no-check-certificate -qO 2 https://mediaarea.net/download/binary/libmediainfo0/17.10/libmediainfo0_17.10-1_amd64.Debian_8.0.deb
    wget --no-check-certificate -qO 3 https://mediaarea.net/download/binary/mediainfo/17.10/mediainfo_17.10-1_amd64.Debian_8.0.deb
elif [ $relno = 9 ]; then
    wget --no-check-certificate -qO 1 https://mediaarea.net/download/binary/libzen0/0.4.37/libzen0v5_0.4.37-1_amd64.Debian_9.0.deb
    wget --no-check-certificate -qO 2 https://mediaarea.net/download/binary/libmediainfo0/17.10/libmediainfo0v5_17.10-1_amd64.Debian_9.0.deb
    wget --no-check-certificate -qO 3 https://mediaarea.net/download/binary/mediainfo/17.10/mediainfo_17.10-1_amd64.Debian_9.0.deb
else
    wget --no-check-certificate -qO 1 https://mediaarea.net/download/binary/libzen0/0.4.37/libzen0v5_0.4.37-1_amd64.xUbuntu_16.04.deb
    wget --no-check-certificate -qO 2 https://mediaarea.net/download/binary/libmediainfo0/17.10/libmediainfo0v5_17.10-1_amd64.xUbuntu_16.04.deb
    wget --no-check-certificate -qO 3 https://mediaarea.net/download/binary/mediainfo/17.10/mediainfo_17.10-1_amd64.xUbuntu_16.04.deb
fi

dpkg -i 1
dpkg -i 2
dpkg -i 3
rm -rf 1 2 3

########### 安装 mktorrent  ###########

# wget --no-check-certificate https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz
# tar zxf v1.1.tar.gz
# cd mktorrent-1.1
# make -j${MAXCPUS}
# make install
# cd ..
# rm -rf mktorrent-1.1 v1.1.tar.gz
apt-get install -y mktorrent

mkdir -p /var/www/mktorrent
cp -f "${local_packages}"/script/template/mktorrent.php /var/www/mktorrent/index.php
sed -i "s/REPLACEUSERNAME/${ANUSER}/g" /var/www/mktorrent/index.php

######################  eac3to  ######################

cd /etc/inexistence/02.Tools/eac3to
wget --no-check-certificate -q http://madshi.net/eac3to.zip
unzip -qq eac3to.zip
rm -rf eac3to.zip
cd



echo;echo;echo;echo;echo;echo "  UPTOOLBOX-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo
}






# --------------------- 一些设置修改 --------------------- #
function _tweaks() {
if [ $tweaks == "Yes" ]; then

    rm -rf /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
    ntpdate time.windows.com
    hwclock -w

cat>>/etc/profile<<EOF

################## Seedbox Script Mod Start ##################

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

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
alias tra="systemctl start transmission"
alias trb="systemctl stop transmission"
alias trc="systemctl status transmission"
alias trr="systemctl restart transmission"
alias rta="systemctl start rtorrent@${ANUSER}"
alias rtb="systemctl stop rtorrent@${ANUSER}"
alias rtc="systemctl status rtorrent@${ANUSER}"
alias rtr="systemctl restart rtorrent@${ANUSER}"
alias irssia="systemctl start irssi@${ANUSER}"
alias irssib="systemctl stop irssi@${ANUSER}"
alias irssic="systemctl status irssi@${ANUSER}"
alias irssir="systemctl restart irssi@${ANUSER}"
alias flexa="systemctl start flexget"
alias flexb="systemctl stop flexget"
alias flexc="flexget daemon status"
alias flexr="systemctl restart flexget"
alias cdde="cd /home/${ANUSER}/deluge/download && ll"
alias cdqb="cd /home/${ANUSER}/qbittorrent/download && ll"
alias cdrt="cd /home/${ANUSER}/rtorrent/download && ll"
alias cdtr="cd /home/${ANUSER}/transmission/download && ll"
alias shanchu="rm -rf"
alias xiugai="nano /etc/bash.bashrc && source /etc/bash.bashrc"
alias quanxian="chmod -R 777"
alias anzhuang="apt-get install -y"
alias yongyouzhe="chown ${ANUSER}:${ANUSER}"

alias ssa="/etc/init.d/shadowsocks-r start"
alias ssb="/etc/init.d/shadowsocks-r stop"
alias ssc="/etc/init.d/shadowsocks-r status"
alias ssr="/etc/init.d/shadowsocks-r restart"
alias ruisua="/appex/bin/serverSpeeder.sh start"
alias ruisub="/appex/bin/serverSpeeder.sh stop"
alias ruisuc="/appex/bin/serverSpeeder.sh status"
alias ruisur="/appex/bin/serverSpeeder.sh restart"

alias scrl="screen ls"
alias scrgd="screen -U -R GoogleDrive"
alias renwu="ps aux | grep"
alias ${ANUSER}="su ${ANUSER}"
alias flexs="nano /root/.flexget/config.yml"
alias ios="iostat -d -x -k 1"
alias rtscreen="chmod -R 777 /dev/pts && sudo -u ${ANUSER} screen -r rtorrent"
alias qblog="cat /etc/inexistence/01.Log/qbittorrent.log"
alias cdb="cd .."
alias cesu="cesu --share"
alias cesujiedian="cesu --list | grep -v speedtest | head -10"
alias ls="ls -hAv --color --group-directories-first"
alias ll='ls -hAlvZ --color --group-directories-first'
alias tree='tree --dirsfirst'
alias gclone='git clone --depth=1'

alias eac3to='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe 2>/dev/null'
alias eacout='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe 2>/dev/null | tr -cd "\11\12\15\40-\176"'

################## Seedbox Script Mod END ##################

EOF


cat >>/etc/sysctl.conf<<EOF
fs.file-max = 1926817
fs.nr_open = 1926817
EOF

mkdir -p /etc/inexistence/02.Tools/eac3to
mkdir -p /etc/inexistence/04.Upload
mkdir -p /etc/inexistence/05.Output
mkdir -p /etc/inexistence/06.BluRay
mkdir -p /etc/inexistence/07.Screenshots
mkdir -p /etc/inexistence/08.BDinfo
mkdir -p /etc/inexistence/09.Torrents
mkdir -p /etc/inexistence/10.Demux
mkdir -p /etc/inexistence/11.Remux
mkdir -p /etc/inexistence/12.Output2

# 跳过文件夹，只复制最外层的……
cp -f "${local_packages}"/script/* /usr/local/bin >> /dev/null 2>&1

    echo "* - nofile 1926817">>/etc/security/limits.conf
    echo "* - nproc 1926817">>/etc/security/limits.conf
    echo "DefaultLimitNOFILE=123456">>/etc/systemd/system.conf
    echo "DefaultLimitNPROC=123456">>/etc/systemd/system.conf
    echo "precedence ::ffff:0:0/96 100">>/etc/gai.conf

    source /etc/profile
    locale
    sysctl -p

fi
}




# --------------------- 结尾 --------------------- #
function _end() {

_check_install_2
endtime=$(date +%s) 
timeused=$(( $endtime - $starttime ))
echo
clear

echo -e " ${baiqingse}${bold}    Clients URL    ${normal} "
echo
echo '-----------------------------------------------------------'
if [ ! "${QBVERSION}" == "No" ]; then
    echo -e " ${cyan}qBittorrent WebUI${normal}    http://${serveripv4}:2017"
fi

if [ ! "${DEVERSION}" == "No" ]; then
    echo -e " ${cyan}Deluge WebUI${normal}         http://${serveripv4}:8112"
fi

if [ ! "${TRVERSION}" == "No" ]; then
    echo -e " ${cyan}Transmission WebUI${normal}   http://${ANUSER}:${ANPASS}@${serveripv4}:9099"
fi

if [ ! "${RTVERSION}" == "No" ]; then
    echo -e " ${cyan}RuTorrent${normal}            https://${ANUSER}:${ANPASS}@${serveripv4}/rutorrent"
    echo -e " ${cyan}h5ai File Indexer${normal}    https://${ANUSER}:${ANPASS}@${serveripv4}"
    echo -e " ${cyan}webmin${normal}               https://${serveripv4}/webmin"
fi

if [ ! $flexget == "No" ]; then
    echo -e " ${cyan}Flexget WebUI${normal}        http://${serveripv4}:6566"
fi

# echo -e " ${cyan}MkTorrent WebUI${normal}      https://${ANUSER}:${ANPASS}@${serveripv4}/mktorrent"

echo '-----------------------------------------------------------'
echo
if [[ $timeused -gt 60 && $timeused -lt 3600 ]]; then
    timeusedmin=$(expr $timeused / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "${baiqingse}${bold}The installation took about ${timeusedmin} min ${timeusedsec} sec${normal}"
elif [[ $timeused -ge 3600 ]]; then
    timeusedhour=$(expr $timeused / 3600)
    timeusedmin=$(expr $(expr $timeused % 3600) / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "The installation took about ${timeusedhour} hour ${timeusedmin} min ${timeusedsec} sec${normal}"
else
   echo -e "${baiqingse}${bold}The installation took about ${timeused} sec${normal}"
fi
echo

}






# --------------------- 结构 --------------------- #

_intro
_checkroot
_warning
echo
echo
_askusername
_askpassword
_askaptsource
_askmt
_askqbt
_askdeluge
_askdelt
_askrt
_asktr
_askflex
_askrclone
# _askvnc
# _asktools

if [[ -d "/proc/vz" ]]; then
    echo -e "${yellow}${bold}Since your seedbox is based on ${red}OpenVZ${normal}${yellow}${bold}, and the normal BBR installation isn't supported by OpenVZ"
    echo -e "you should install BBR in another way${normal}"
    bbr='not supported by OpenVZ'
else
    _askbbr
fi

_asktweaks
_askcontinue

_setuser
_setsources

# --------------------- 安装 --------------------- #




if [ $bbr == "Yes" ]; then
    echo -n "Configuring BBR ... ";echo;echo;echo;_installbbr
else
    echo "Skip BBR installation";echo;echo;echo;echo;echo
fi


if [ "${QBVERSION}" == "No" ]; then
    echo "Skip qBittorrent installation";echo;echo;echo;echo;echo
else
    echo -n "Installing qBittorrent ... ";echo;echo;echo;_installqbt
    echo -n "Configuring qBittorrent ... ";echo;echo;echo;_setqbt
fi


if [ "${DEVERSION}" == "No" ]; then
    echo "Skip Deluge installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Deluge ... ";echo;echo;echo;_installde
    echo -n "Configuring Deluge ... ";echo;echo;echo;_setde
fi


if [ "${RTVERSION}" == "No" ]; then
    echo "Skip rTorrent installation";echo;echo;echo;echo;echo
else
    echo -n "Installing rTorrent ... ";echo;echo;echo;_installrt
fi


if [ "${TRVERSION}" == "No" ]; then
    echo "Skip Transmission installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Transmission ... ";echo;echo;echo;_installtr
    echo -n "Configuring Transmission ... ";echo;echo;echo;_settr
fi


if [ $flexget == "No" ]; then
    echo "Skip Flexget installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Flexget ... ";echo;echo;echo;_installflex
fi


if [ $rclone == "No" ]; then
    echo "Skip rclone installation";echo;echo;echo;echo;echo
else
    echo -n "Installing rclone ... ";echo;echo;echo;_installrclone
fi


if [ $tweaks == "No" ]; then
    echo "Skip System tweaks";echo;echo;echo;echo;echo
else
    echo -n "Configuring system settings ... ";echo;echo;echo;_tweaks
fi


_end
_askreboot


