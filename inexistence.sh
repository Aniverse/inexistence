#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
# --------------------------------------------------------------------------------
INEXISTENCEVER=095
INEXISTENCEDATE=20180201
SYSTEMCHECK=1
# --------------------------------------------------------------------------------
local_packages=/etc/inexistence/00.Installation
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
### 操作系统检测 ###
get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}
# --------------------------------------------------------------------------------
### 是否为 IPv4 地址(其实也不一定是) ###
function isValidIpAddress() {
    echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$'
}

### 是否为内网 IPv4 地址 ###
function isInternalIpAddress() {
    echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))'
}
# --------------------------------------------------------------------------------
# 检查客户端是否已安装、客户端版本
function _check_install_1(){
  client_location=$( command -v ${client_name} )

  [[ "${client_name}" == "qbittorrent-nox" ]] && client_name=qb
  [[ "${client_name}" == "transmission-daemon" ]] && client_name=tr
  [[ "${client_name}" == "deluged" ]] && client_name=de
  [[ "${client_name}" == "rtorrent" ]] && client_name=rt
  [[ "${client_name}" == "flexget" ]] && client_name=flex

  if [[ -a $client_location ]]; then
      eval "${client_name}"_installed=Yes
  else
      eval "${client_name}"_installed=No
  fi
}

function _check_install_2(){
for apps in qbittorrent-nox deluged rtorrent transmission-daemon flexget rclone irssi ffmepg mediainfo wget; do
    client_name=$apps; _check_install_1
done
}

function _client_version_check(){
[[ "${qb_installed}" == "Yes" ]] && qbtnox_ver=`qbittorrent-nox --version | awk '{print $2}' | sed "s/v//"`
[[ "${de_installed}" == "Yes" ]] && deluged_ver=`deluged --version | grep deluged | awk '{print $2}'` && delugelt_ver=`deluged --version | grep libtorrent | awk '{print $2}'`
[[ "${rt_installed}" == "Yes" ]] && rtorrent_ver=`rtorrent -h | head -n1 | sed -ne 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\)[^0-9]*/\1/p'`
[[ "${tr_installed}" == "Yes" ]] && trd_ver=`transmission-daemon --help | head -n1 | awk '{print $2}'`
}
# --------------------------------------------------------------------------------
### 随机数 ###
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------
### 检查网站是否可以访问
check_url() {   if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then return 0; else return 1; fi; }

### 检查系统源是否可用 ###
function _checkrepo1() {
os_repo=0

echo
echo "${bold}Checking the web sites we will need are accessible${normal}"

for i in $(cat /etc/apt/sources.list | grep "^deb http" | cut -d' ' -f2 | uniq ); do
  echo -n $i": "
  check_url $i && echo "${green}OK${normal}" || { echo "${bold}${red}FAIL${normal}"; os_repo=1; }
done

if [ $os_repo = 1 ]; then
  echo "${bold}${baihongse}FAILED${normal} ${bold}Some of your $DISTRO mirrors are down, you need to fix it mannually${normal}"
fi
}

### 第三方源的网址 ###
rt_url="http://rtorrent.net/downloads/"
xmlrpc_url="https://svn.code.sf.net/p/xmlrpc-c/code/stable"
ru_url="https://github.com/Novik/ruTorrent"
adl_url="https://github.com/autodl-community"
inex_url="https://github.com/Aniverse/inexistence"
qbt_url="https://github.com/qbittorrent/qBittorrent"
de_url="http://download.deluge-torrent.org"
lt_url="https://github.com/arvidn/libtorrent"
rtinst_url="https://github.com/Aniverse/rtinst"
libevent_url="https://github.com/libevent/libevent"
tr_url="https://github.com/transmission/transmission"
trweb_url="https://github.com/ronggang/transmission-web-control"
rclone_url="https://downloads.rclone.org"

### 检查第三方源是否可用 ###
function _checkrepo2() {
major_repo=0
echo
echo "Checking major 3rd party components"
# echo -n ": "; check_url $_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Inexistence: "; check_url $inex_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "qBittorrent: "; check_url $qbt_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Deluge: "; check_url $de_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Libtorrent-rasterbar: "; check_url $lt_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "rtinst Aniverse Mod: "; check_url $rtinst_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Rtorrent: "; check_url $rt_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "xmlrpc-c: "; check_url $xmlrpc_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "RuTorrent: ";check_url $ru_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Autodl-irssi: "; check_url $adl_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "libevent: "; check_url $libevent_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Transmission: "; check_url $tr_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "Transmission Web Control: "; check_url $trweb_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo -n "rclone: "; check_url $rclone_url && echo "${green}OK${normal}" || { echo "${red}FAIL${normal}"; major_repo=1; }
echo

if [ $major_repo = 1 ]; then
  echo "${bold}${baihongse}WARNING${normal} ${bold}Some of the repositories we need are not currently available"
  echo "We will continue for now, but may not be able to finish${normal}"
fi

echo
}

### 输入自己想要的软件版本 ###
function _inputversion() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the right version number, otherwise the installation will be failed${normal}"
read -ep "${bold}${yellow}Input the version you want: ${cyan}" inputversion; echo -n "${normal}"
}

### 检查系统是否被支持 ###
function _oscheck() {
if [[ ! "$SysSupport" == 1 ]]; then
    echo "Too young too simple! Only Debian 8, Debian 9 and Ubuntu 16.04 is supported by this script"
    echo "Exiting..."
    exit 1
fi
}
# --------------------------------------------------------------------------------
###   Downloads\ScanDirsV2=@Variant(\0\0\0\x1c\0\0\0\0)
###   ("yakkety"|"xenial"|"wily"|"jessie"|"stretch"|"zesty"|"artful")
# --------------------------------------------------------------------------------






clear






# --------------------- 系统检查 --------------------- #
function _intro() {

  # 检查是否以 root 权限运行脚本

  if [[ $EUID != 0 ]]; then
    echo '${title}${bold}Navie! I think this young man will not be able to run this script without root privileges.${normal}'
    echo ' Exiting...'
    exit 1
  fi

  echo "${green}${bold}Excited! You're running this script as root. Let's make some big news ... ${normal}"


  # 检查系统是否为支持的系统

# cat /etc/os-release，刚发现这玩意儿，瞬间感觉我下面写的一堆东西和 SB 一样 ……
# 先放着再说

# ubosversion=`grep -oE  "[0-9.]+" /etc/issue`
# deosversion=`cat /etc/debian_version`

# 不是 Ubuntu 或 Debian 的就不管了，反正不支持……
# DISTRO=`awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release`
# CODENAME=`cat /etc/os-release | grep "(" | cut -d '(' -f2 | cut -d ')' -f1 | head -n1 | awk '{print $1}' | tr '[A-Z]' '[a-z]'`
# [[ "$CODENAME" =~ ("xenial"|"jessie"|"stretch") ]] && SysSupport=1


opsy=$( get_opsy )
OPSYDEBIAN=`echo $opsy | egrep 'Ubuntu|Debian'`
OPSYUB1404=`echo $opsy | grep 'Ubuntu' | grep '14.04'` ; OPSYUB1410=`echo $opsy | grep 'Ubuntu' | grep '14.10'`
OPSYUB1504=`echo $opsy | grep 'Ubuntu' | grep '15.04'` ; OPSYUB1510=`echo $opsy | grep 'Ubuntu' | grep '15.10'`
OPSYUB1604=`echo $opsy | grep 'Ubuntu' | grep '16.04'` ; OPSYUB1610=`echo $opsy | grep 'Ubuntu' | grep '16.10'`
OPSYUB1704=`echo $opsy | grep 'Ubuntu' | grep '17.04'` ; OPSYUB1710=`echo $opsy | grep 'Ubuntu' | grep '17.10'` ; OPSYUB1804=`echo $opsy | grep 'Ubuntu' | grep '18.04'`
OPSYDE7=`echo $opsy | grep 'Debian' | grep '7'`        ; OPSYDE8=`echo $opsy | grep 'Debian' | grep '8'`        ; OPSYDE9=`echo $opsy | grep 'Debian' | grep '9'`  

[[ -n "$OPSYUB1404" ]] && RELEASE=14.04                     && DISTRO=Ubuntu && CODENAME=trusty
[[ -n "$OPSYUB1410" ]] && RELEASE=14.10                     && DISTRO=Ubuntu && CODENAME=utopic
[[ -n "$OPSYUB1504" ]] && RELEASE=15.04                     && DISTRO=Ubuntu && CODENAME=vivid
[[ -n "$OPSYUB1510" ]] && RELEASE=15.10                     && DISTRO=Ubuntu && CODENAME=wily
[[ -n "$OPSYUB1610" ]] && RELEASE=16.10                     && DISTRO=Ubuntu && CODENAME=yakkety
[[ -n "$OPSYUB1704" ]] && RELEASE=17.04                     && DISTRO=Ubuntu && CODENAME=zesty
[[ -n "$OPSYUB1710" ]] && RELEASE=17.10                     && DISTRO=Ubuntu && CODENAME=artful
[[ -n "$OPSYUB1804" ]] && RELEASE=18.04                     && DISTRO=Ubuntu && CODENAME=bionic
[[ -n   "$OPSYDE7"  ]] && RELEASE=`cat /etc/debian_version` && DISTRO=Debian && CODENAME=wheezy

[[ -n "$OPSYUB1604" ]] && RELEASE=16.04                     && DISTRO=Ubuntu && CODENAME=xenial     && SysSupport=1 && relno=16
[[ -n   "$OPSYDE8"  ]] && RELEASE=`cat /etc/debian_version` && DISTRO=Debian && CODENAME=jessie     && SysSupport=1 && relno=8
[[ -n   "$OPSYDE9"  ]] && RELEASE=`cat /etc/debian_version` && DISTRO=Debian && CODENAME=stretch    && SysSupport=1 && relno=9

# echo "DISTRO=$DISTRO" && echo "CODENAME=$CODENAME" && echo "RELEASE=$RELEASE" && echo "relno=$relno" && echo "SysSupport=$SysSupport"


# 检查本脚本是否支持当前系统，可以关闭此功能
[[ $SYSTEMCHECK == 1 ]] && _oscheck

# 其实我也不知道 32位 系统行不行…… 也不知道这个能不能判断是不是 ARM

# if [[ ! $lbit = 64 ]]; then
#   echo '${title}${bold}Naive! Only 64bits system is supported${normal}'
#   echo ' Exiting...'
#   exit 1
# fi


  # 装 wget 以防万一，不屏蔽错误输出

if [[ ! -n `command -v wget` ]]; then
    echo "${bold}Now the script is installing ${yellow}wget${white} ...${normal}"
    apt-get install -y wget >> /dev/null
fi

[[ ! $? -eq 0 ]] && echo -e "${red}${bold}Failed to install wget or curl, please check it and rerun once it is resolved${normal}\n" && exit 1


# echo "${bold}Now the script is installing ${yellow}lsb-release${white} and ${yellow}virt-what${white} for server spec detection ...${normal}"
# apt-get -y install lsb-release virt-what >> /dev/null 2>&1
# [[ ! $? -eq 0 ]] && echo -e "${red}${bold}Failed to install packages, please check it and rerun once it is resolved${normal}\n" && exit 1


  echo "${bold}Checking your server's public IPv4 address ...${normal}"
# serveripv4=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )
  serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )
  isInternalIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T7 -qO- ipecho.net/plain )
  isValidIpAddress "$serveripv4" || echo "${bold}${red}${shanshuo}ERROR ${white}${underline}Failed to detect your public IPv4 address, use internal address instead${normal}" && serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')


  echo "${bold}Checking your server's public IPv6 address ...${normal}"
  serveripv6=$( wget -qO- -t1 -T5 ipv6.icanhazip.com )
# wangka=`ifconfig -a | grep -B 1 $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') | head -n1 | awk '{print $1}'`
# serverlocalipv6=$( ip addr show dev $wangka | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' )


  echo "${bold}Checking your server's specification ...${normal}"


# DISTRO=$(lsb_release -is)
# RELEASE=$(lsb_release -rs)
# CODENAME=$(lsb_release -cs)
# SETNAME=$(lsb_release -rc)
  arch=$( uname -m )
  lbit=$( getconf LONG_BIT )
# relno=$(lsb_release -sr | cut -d. -f1)
  kern=$( uname -r )
  kv1=$(uname -r | cut  -d. -f1)
  kv2=$(uname -r | cut  -d. -f2)
  kv3=$(echo $kv1.$kv2)
  kv4=$(uname -r | cut  -d- -f1)
  kv5=$(uname -r | cut  -d- -f2)
  kv6=$(uname -r | cut  -d- -f3)

  _check_install_2
  _client_version_check

# virtua=$(virt-what) 2>/dev/null
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

  wget --no-check-certificate -t1 -T5 -qO- https://raw.githubusercontent.com/Aniverse/inexistence/master/03.Files/inexistence.logo.1

  echo "${bold}---------- [System Information] ----------${normal}"
  echo

  echo -ne "  IPv4    : "
  if [[ "${serveripv4}" ]]; then
      echo "${cyan}$serveripv4${normal}"
  else
      echo "${cyan}No Public IPv4 Address Found${normal}"
  fi

  echo -ne "  IPv6    : "
  if [[ "${serveripv6}" ]]; then
      echo "${cyan}$serveripv6${normal}"
  else
      echo "${cyan}No IPv6 Address Found${normal}"
  fi

  echo "  CPU     : ${cyan}$cname${normal}"
  echo "  Cores   : ${cyan}${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
  echo "  Mem     : ${cyan}$tram MB ($uram MB Used)${normal}"
  echo "  Disk    : ${cyan}$disk_total_size GB ($disk_used_size GB Used)${normal}"
  echo "  OS      : ${cyan}$DISTRO $RELEASE $CODENAME ($arch) ${normal}"
  echo "  Kernel  : ${cyan}$kern${normal}"
  echo "  Script  : ${cyan}$INEXISTENCEDATE${normal}"

# echo -ne "  Virt    : "
# if [[ "${virtua}" ]]; then
#     echo "${cyan}$virtua${normal}"
# else
#     echo "${cyan}No Virt${normal}"
# fi

  [[ ! $SYSTEMCHECK == 1 ]] && echo -e "\n"${bold}System Checking Skipped. Note that this script may not work on unsupported system"${normal} \n"

  echo

}





# --------------------- 询问是否继续 Type-A --------------------- #

function _warning() {

  echo
  echo "${bold}${white}This script will try to do the following things"
  echo "but it couldn't work fine on every seedbox${blue}"
  echo
  echo " 1. Install qBittorrent, Deluge, rTorrent, Transmission"
  echo " 2. Install Flexget, rclone, BBR and some other softwares"
  echo " 3. Do some system tweaks"
  echo
  echo "${white}For more information, please refer the README on GitHub"
  echo "Press ${on_red}Ctrl+C${normal} ${bold}to exit${white}, or press ${bailvse}ENTER${normal} ${bold}to continue"
  read input
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
    echo "This will be your primary user. It can be an existing user or a new user ${normal}"

    confirm_name=1
    while [[ $confirm_name = 1 ]]; do

        while [[ $answerusername = "" ]] || [[ $reinput_name = 1 ]]; do
            reinput_name=0
            read -ep "${white}${bold}Enter username: ${blue}" answerusername
        done

        addname="${answerusername}"
        echo -n "${normal}${bold}Confirm that username is ${blue}"${answerusername}"${normal}, ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o ? "

        read answer
        case $answer in [yY] | [yY][Ee][Ss] | "" ) confirm_name=0 ;;
                        [nN] | [nN][Oo] ) reinput_name=1 ;;
                        * ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
        esac

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

  echo -n "${bold}Enter the password, or leave blank to generate a random one${blue} "
  read -e password1

  if [ -z $password1 ]; then

      exitvalue=1
      localpass=$(genpasswd)
      echo "${bold}${white}Random password sets to ${blue}$localpass${normal}"

  elif [ ${#password1} -lt 9 ]; then

      echo "${bold}${red}ERROR${normal} ${bold}Password needs to be at least ${on_yellow}[9]${normal}${bold} chars long${normal}" && continue

  else

      while [[ $password2 = "" ]]; do
          read -ep "${white}${bold}Enter the new password again${blue} " password2
      done

      if [ $password1 != $password2 ]; then
          echo "${bold}${red}WARNING${normal} ${bold}Passwords do not match${normal}"
      else
          localpass=$password1
      fi

  fi

done

ANPASS=$localpass
exec >&3-
echo
return $exitvalue

}





# --------------------- 询问安装前是否需要更换软件源 --------------------- #

function _askaptsource() {

  read -ep "${bold}${yellow}Would you like to change sources list ?${normal} [${cyan}Y${white}]es or [N]o: " responce

  case $responce in
      [yY] | [yY][Ee][Ss] | "" ) aptsources=Yes ;;
      [nN] | [nN][Oo]) aptsources=No ;;
      *) aptsources=Yes ;;
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

  echo -e "${green}01)${white} Use ${cyan}all${white} avaliable threads (Default)"
  echo -e "${green}02)${white} Use ${cyan}half${white} of avaliable threads"
  echo -e "${green}03)${white} Use ${cyan}one${white} thread"
  echo -e "${green}04)${white} Use ${cyan}two${white} threads"
# echo -e   "${red}99)${white} Do not compile, install softwares from repo"

  echo -e "${bold}${red}Note that${normal} ${bold}using more than one thread to compile may cause failure in some cases${normal}"
  read -ep "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " version

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
  echo -e "${green}02)${white} qBittorrent ${cyan}3.3.11${white}"
  echo -e "${green}03)${white} qBittorrent ${cyan}3.3.11${white} (Skip Hash Check)"
  echo -e "${green}04)${white} qBittorrent ${cyan}3.3.14${white}"
  echo -e "${green}05)${white} qBittorrent ${cyan}3.3.16${white}"
  [[ ! $CODENAME = jessie ]] && echo -e "${green}11)${white} qBittorrent ${cyan}4.0.2${white}"
  [[ ! $CODENAME = jessie ]] && echo -e "${green}12)${white} qBittorrent ${cyan}4.0.3${white}"
  echo -e "${green}30)${white} Select another version"
  echo -e "${green}40)${white} qBittorrent from ${cyan}repo${white}"
  [[ $DISTRO == Ubuntu ]] && echo -e "${green}50)${white} qBittorrent from ${cyan}PPA${white}"
  echo -e   "${red}99)${white} Do not install qBittorrent"

  [[ "${qb_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed ${underline}qBittorrent ${qbtnox_ver}${normal}"
  read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}05${normal}): " version

  case $version in
      01 | 1) QBVERSION=3.3.7 ;;
      02 | 2 | "") QBVERSION=3.3.11 ;;
      03 | 3) QBVERSION=3.3.11 && QBPATCH=Yes ;;
      04 | 4) QBVERSION=3.3.14 ;;
      05 | 5) QBVERSION=3.3.16 ;;
      11) QBVERSION=4.0.2 ;;
      12) QBVERSION=4.0.3 ;;
      30) _inputversion && QBVERSION="${inputversion}"  ;;
      40) QBVERSION='Install from repo' ;;
      50) QBVERSION='Install from PPA' ;;
      99) QBVERSION=No ;;
      *) QBVERSION=3.3.11 ;;
  esac

  if [[ `echo $QBVERSION | cut -c1` == 4 ]]; then
      QBVERSION4=Yes
  else
      QBVERSION4=No
  if

  if [ "${QBVERSION}" == "No" ]; then

      echo "${baizise}qBittorrent will ${baihongse}not${baizise} be installed${normal}"

  elif [ "${QBVERSION4}" == "Yes" ]; then

      echo "${bold}${red}WARNING${normal} ${bold}Building qBittorrent 4 doesn't work on ${cyan}Debian 8${white}"

      if [ $CODENAME = jessie ]; then
          QBVERSION=3.3.16 && QBVERSION4=No
          echo "${bold}The script will use qBittorrent "${QBVERSION}" instead"
          echo "${bold}${baiqingse}qBittorrent "${QBVERSION}"${normal} ${bold}will be installed${normal}"
      fi

  elif [[ "${QBVERSION}" == "Install from repo" ]]; then

      sleep 0

  elif [[ "${QBVERSION}" == "Install from PPA" ]]; then

      if [[ $DISTRO == Debian ]]; then
          echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
          echo -ne "Therefore "
          QBVERSION='Install from repo'
      else
          echo "${bold}qBittorrent will be installed from Stable PPA, usually it will be ${cyan}the latest version${normal}"
      fi

  else

      echo "${bold}${baiqingse}qBittorrent "${QBVERSION}"${normal} ${bold}will be installed${normal}"

  fi


  if [[ "${QBVERSION}" == "Install from repo" ]]; then

      echo -ne "${bold}qBittorrent will be installed from repository, and "

      if [ $CODENAME = stretch ]; then
          echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}qBittorrent 3.3.7${normal}"
      elif [ $CODENAME = jessie ]; then
          echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}qBittorrent 3.1.10${normal}"
      elif [ $CODENAME = xenial ]; then
          echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}qBittorrent 3.3.1${normal}"
      fi

  fi

  echo

}




# --------------------- 询问需要安装的 Deluge 版本 --------------------- #

function _askdeluge() {

  echo -e "${green}01)${white} Deluge ${cyan}1.3.11${white}"
  echo -e "${green}02)${white} Deluge ${cyan}1.3.12${white}"
  echo -e "${green}03)${white} Deluge ${cyan}1.3.13${white}"
  echo -e "${green}04)${white} Deluge ${cyan}1.3.14${white}"
  echo -e "${green}05)${white} Deluge ${cyan}1.3.15${white}"
  echo -e "${green}30)${white} Select another version"
  echo -e "${green}40)${white} Deluge from ${cyan}repo${white}"
  [[ $DISTRO == Ubuntu ]] && echo -e "${green}50)${white} Deluge from ${cyan}PPA${white}"
  echo -e   "${red}99)${white} Do not install Deluge"

  [[ "${de_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed ${underline}Deluge ${deluged_ver}${reset_underline} with ${underline}libtorrent ${delugelt_ver}${normal}"
  [[ $DISTRO == Ubuntu ]] && dedefaultnum=50
  [[ $DISTRO == Debian ]] && dedefaultnum=05
  read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}${dedefaultnum}${normal}): " version

  if [[ $DISTRO == Ubuntu ]]; then

      case $version in
          01 | 1) DEVERSION=1.3.11 ;;
          02 | 2) DEVERSION=1.3.12 ;;
          03 | 3) DEVERSION=1.3.13 ;;
          04 | 4) DEVERSION=1.3.14 ;;
          05 | 5) DEVERSION=1.3.15 ;;
          21) DEVERSION=1.3.5 ;;
          22) DEVERSION=1.3.6 ;;
          30) _inputversion && DEVERSION="${inputversion}"  ;;
          40) DEVERSION='Install from repo' ;;
          50 | "") DEVERSION='Install from PPA' ;;
          99) DEVERSION=No ;;
          *) DEVERSION='Install from PPA' ;;
          esac

  elif [[ $DISTRO == Debian ]]; then

      case $version in
          01 | 1) DEVERSION=1.3.11 ;;
          02 | 2) DEVERSION=1.3.12 ;;
          03 | 3) DEVERSION=1.3.13 ;;
          04 | 4) DEVERSION=1.3.14 ;;
          05 | 5 | "") DEVERSION=1.3.15 ;;
          21) DEVERSION=1.3.5 ;;
          22) DEVERSION=1.3.6 ;;
          30) _inputversion && DEVERSION="${inputversion}"  ;;
          40) DEVERSION='Install from repo' ;;
          50) DEVERSION='Install from PPA' ;;
          99) DEVERSION=No ;;
          *) DEVERSION=1.3.15 ;;
      esac

  fi

  if [ "${DEVERSION}" == "No" ]; then

      echo "${baizise}Deluge will ${baihongse}not${baizise} be installed${normal}"

  elif [[ "${DEVERSION}" == "Install from repo" ]]; then 

      sleep 0

  elif [[ "${DEVERSION}" == "Install from PPA" ]]; then

      if [[ $DISTRO == Debian ]]; then
          echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
          echo -ne "Therefore "
          DEVERSION='Install from repo'
      else
          echo "${bold}Deluge will be installed from PPA, usually it will be ${cyan}the latest version${normal}"
      fi

  else

      echo "${bold}${baiqingse}Deluge "${DEVERSION}"${normal} ${bold}will be installed${normal}"

  fi


  if [[ "${DEVERSION}" == "Install from repo" ]]; then 

      echo -ne "${bold}Deluge will be installed from repository, and "

      if [ $CODENAME = stretch ]; then
          echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}Deluge 1.3.13${normal}"
      elif [ $CODENAME = jessie ]; then
          echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}Deluge 1.3.10${normal}"
      elif [ $CODENAME = xenial ]; then
          echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}Deluge 1.3.12${normal}"
      fi

  fi

}




# --------------------- 询问需要安装的 Deluge libtorrent 版本 --------------------- #

function _askdelt() {

  if [[ "${DEVERSION}" == "No" ]] || [[ "${DEVERSION}" == "Install from repo" ]] || [[ "${DEVERSION}" == "Install from PPA" ]]; then

      echo

  else

      echo
#     echo -e "${green}01)${white} libtorrent ${cyan}RC_0_16${white} (NOT recommended)"
      echo -e "${green}02)${white} libtorrent ${cyan}RC_1_0${white}"
      echo -e "${green}03)${white} libtorrent ${cyan}RC_1_1${white}  (NOT recommended)"
      echo -e "${green}04)${white} libtorrent from ${cyan}repo${white}"

      echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}If you do not know what's this, please use the default opinion${normal}"
      

      if [ $CODENAME = stretch ]; then

          read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}02${normal}): " version

          case $version in
              01 | 1) DELTVERSION=RC_0_16 && DELTPKG=0.16.19 ;;
              02 | 2 | "") DELTVERSION=RC_1_0 && DELTPKG=1.0.11 ;;
              03 | 3) DELTVERSION=RC_1_1 && DELTPKG=1.1.6 ;;
              04 | 4) DELTVERSION='Install from repo' ;;
              *) DELTVERSION=DELTVERSION=RC_1_0 && DELTPKG=1.0.11 ;;
          esac

      else

          read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}04${normal}): " version

          case $version in
              01 | 1) DELTVERSION=RC_0_16 && DELTPKG=0.16.19 ;;
              02 | 2) DELTVERSION=RC_1_0 && DELTPKG=1.0.11 ;;
              03 | 3) DELTVERSION=RC_1_1 && DELTPKG=1.1.6 ;;
              04 | 4 | "") DELTVERSION='Install from repo' ;;
              *) DELTVERSION='Install from repo' ;;
          esac

      fi


      if [[ $DELTVERSION == "Install from repo" ]]; then

          echo -ne "${bold}libtorrent-rasterbar will be installed from repository, and "

          if [ $CODENAME = stretch ]; then
              echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}libtorrent 1.1.1${normal}"
          elif [ $CODENAME = jessie ]; then
              echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}libtorrent 0.16.18${normal}"
          elif [ $CODENAME = xenial ]; then
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
  echo -e "${green}02)${white} rTorrent ${cyan}0.9.4${white}"
  echo -e "${green}03)${white} rTorrent ${cyan}0.9.4${white} (with IPv6 support)"
  echo -e "${green}04)${white} rTorrent ${cyan}0.9.6${white} (with IPv6 support)"
  echo -e   "${red}99)${white} Do not install rTorrent"

  [[ "${rt_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed ${underline}rTorrent ${rtorrent_ver}${normal}"
  [[ "${rt_installed}" == "Yes" ]] && echo -e "${bold}If you want to downgrade or upgrade rTorrent, use ${blue}rtupdate${normal}"
  read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}02${normal}): " version

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
          echo "${bold}${baiqingse}rTorrent 0.9.4 (with UNOFFICAL IPv6 support)${normal} ${bold}will be installed${normal}"
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
  echo -e "${green}04)${white} Transmission ${cyan}2.92${white}"
  echo -e "${green}05)${white} Transmission ${cyan}2.93${white}"
  echo -e "${green}30)${white} Select another version"
  echo -e "${green}40)${white} Transmission from ${cyan}repo${white}"
  [[ $DISTRO == Ubuntu ]] && echo -e "${green}50)${white} Transmission from ${cyan}PPA${white}"
  echo -e   "${red}99)${white} Do not install Transmission"

  [[ "${tr_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed ${underline}Transmission ${trd_ver}${normal}"
  read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}40${normal}): " version

  case $version in
      01 | 1) TRVERSION=2.77 ;;
      02 | 2) TRVERSION=2.82 ;;
      03 | 3) TRVERSION=2.84 ;;
      04 | 4) TRVERSION=2.92 ;;
      05 | 5) TRVERSION=2.93 ;;
      30) _inputversion && TRVERSION="${inputversion}" && TRdefault=No ;;
      40 | "") TRVERSION='Install from repo' ;;
      50) TRVERSION='Install from PPA' ;;
      99) TRVERSION=No ;;
      *) TRVERSION='Install from repo';;
  esac

  if [ "${TRVERSION}" == "No" ]; then

      echo "${baizise}Transmission will ${baihongse}not${baizise} be installed${normal}"

  else

          if [[ "${TRVERSION}" == "Install from repo" ]]; then 

              sleep 0

          elif [[ "${TRVERSION}" == "Install from PPA" ]]; then

              if [[ $DISTRO == Debian ]]; then
                  echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${white}, which is not supported by ${green}Ubuntu${white} PPA"
                  echo -ne "Therefore "
                  TRVERSION='Install from repo'
              else
                  echo "${bold}${white}Transmission will be installed from PPA, usually it will be the latest version${normal}"
              fi

          else

              echo "${bold}${baiqingse}Transmission "${TRVERSION}"${normal} ${bold}will be installed${normal}"

          fi


          if [[ "${TRVERSION}" == "Install from repo" ]]; then 

              echo -ne "${bold}Transmission will be installed from repository, and "

              if [ "$CODENAME" = "stretch" ]; then
                  echo "${green}${bold}Debian 9${normal} ${bold}will use ${baiqingse}Transmission 2.92${normal}"
              elif [ "$CODENAME" = "jessie" ]; then
                  echo "${green}${bold}Debian 8${normal} ${bold}will use ${baiqingse}Transmission 2.84${normal}"
              elif [ "$CODENAME" = "xenial" ]; then
                  echo "${green}${bold}Ubuntu 16.04${normal} ${bold}will use ${baiqingse}Transmission 2.84${normal}"
              fi

          fi

  fi

  echo

}






# --------------------- 询问是否需要安装 Flexget --------------------- #

function _askflex() {

  [[ "${flex_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed flexget${normal}"
  read -ep "${bold}${yellow}Would you like to install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: " responce

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

  [[ "${rclone_installed}" == "Yes" ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}It seems you have already installed rclone${normal}"
  read -ep "${bold}${yellow}Would you like to install rclone?${normal} [Y]es or [${cyan}N${normal}]o: " responce

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
# 目前不启用

function _askvnc() {

  read -ep "${bold}${yellow}Would you like to install VNC and wine? ${normal} [Y]es or [${cyan}N${normal}]o: " responce

  case $responce in
      [yY] | [yY][Ee][Ss]) vnc=Yes ;;
      [nN] | [nN][Oo] | "" ) vnc=No ;;
      *) vnc=No ;;
  esac

  if [ $tweaks == "Yes" ]; then
      echo "${bold}${baiqingse}VNC${normal} and ${baiqingse}wine${normal} ${bold}will be installed${normal}"
  else
      echo "${baizise}VNC or wine will ${baihongse}not${baizise} be installed${normal}"
  fi

  echo

}





# --------------------- 询问是否安装发种工具箱 --------------------- #
# 目前不启用

function _asktools() {

  echo -e "mono, BDinfo, eac3to, MKVToolnix, mktorrent, mediainfo ..."
  read -ep "${bold}${yellow}Would you like to install the above additional softwares ? ${normal} [Y]es or [${cyan}N${normal}]o: " responce

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





# --------------------- BBR 相关 --------------------- #

# 检查是否已经启用BBR、BBR 魔改版
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

      echo -e "${bold}${yellow}TCP BBR has been installed. Skip ...${normal}"
      bbr=Already\ Installed

  else

      check_kernel_version

      if [[ "${bbrkernel}" == "Yes" ]]; then

          echo -e "${bold}Your kernel version is newer than ${green}4.9${normal}${bold}, but BBR is not enabled${normal}"
          read -ep "${bold}${yellow}Would you like to use BBR? ${normal} [${cyan}Y${normal}]es or [N]o: " responce

          case $responce in
              [yY] | [yY][Ee][Ss] | "" ) bbr=Yes ;;
              [nN] | [nN][Oo]) bbr=No ;;
              *) bbr=Yes ;;
          esac

      else

          echo -e "${bold}Your kernel version is below than ${green}4.9${normal}${bold} while BBR requires at least a ${green}4.9${normal}${bold} kernel"
          echo -e "A latest kernel will be installed if BBR is to be installed"
          echo -e "${red}WARNING${normal} ${bold}Installing new kernel may cause reboot failure in some cases${normal}"
          read -ep "${bold}${yellow}Would you like to install BBR? ${normal} [Y]es or [${cyan}N${normal}]o: " responce

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





# --------------------- 询问是否需要修改一些设置 --------------------- #

function _asktweaks() {

  read -ep "${bold}${yellow}Would you like to configure some system settings? ${normal} [${cyan}Y${normal}]es or [N]o: " responce

  case $responce in
      [yY] | [yY][Ee][Ss] | "" ) tweaks=Yes ;;
      [nN] | [nN][Oo]) tweaks=No ;;
      *) tweaks=Yes ;;
  esac

  if [ $tweaks == "Yes" ]; then
      echo "${bold}${baiqingse}System tweaks${normal} ${bold}will be configured${normal}"
  else
      echo "${baizise}System tweaks will ${baihongse}not${baizise} be configured${normal}"
  fi

  echo

}






# --------------------- 装完后询问是否重启 --------------------- #

function _askreboot() {

  read -ep "${bold}${yellow}Would you like to reboot the system now? ${normal} [y/${cyan}N${normal}]: " is_reboot

  if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
      reboot
  else
      echo -e "${bold}Reboot has been canceled...${normal}"
      echo
  fi

}




# --------------------- 询问是否继续 Type-B --------------------- #

function _askcontinue() {

  echo -e "\n${bold}Please check the following information${normal}"
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
# echo -e "                  ${cyan}${bold}VNC${normal}           ${bold}${yellow}"${vnc}"${normal}"
  echo -e "                  ${cyan}${bold}BBR${normal}           ${bold}${yellow}"${bbr}"${normal}"
  echo -e "                  ${cyan}${bold}System tweak${normal}  ${bold}${yellow}"${tweaks}"${normal}"
  echo -e "                  ${cyan}${bold}Threads${normal}       ${bold}${yellow}"${MAXCPUS}"${normal}"
  echo -e "                  ${cyan}${bold}SourceList${normal}    ${bold}${yellow}"${aptsources}"${normal}"
  echo
  echo '####################################################################'
  echo
  echo -e "${bold}If you want to stop or correct some selections, Press ${on_red}Ctrl+C${normal} ${bold}; or Press ${on_green}ENTER${normal} ${bold}to start${normal}"
  read input
  echo ""
  echo "${bold}${magenta}The selected softwares will be installed, this may take between${normal}"
  echo "${bold}${magenta}1 and 90 minutes depending on your systems specs and your selections${normal}"
  echo ""

}





# --------------------- 创建用户、准备工作 --------------------- #

function _setuser() {

rm -rf /etc/inexistence2
[[ -d /etc/inexistence ]] && mv /etc/inexistence /etc/inexistence2
git clone --depth=1 https://github.com/Aniverse/inexistence /etc/inexistence
mkdir -p /etc/inexistence/01.Log/INSTALLATION
mkdir -p /etc/inexistence/OLD
chmod -R 777 /etc/inexistence

mv /etc/inexistence2/* /etc/inexistence/OLD
rm -rf /etc/inexistence2

if id -u ${ANUSER} >/dev/null 2>&1; then
    echo;echo "${ANUSER} already exists";echo
else
    adduser --gecos "" ${ANUSER} --disabled-password
    echo "${ANUSER}:${ANPASS}" | sudo chpasswd
fi

export TZ="/usr/share/zoneinfo/Asia/Shanghai"

cat>>/etc/inexistence/01.Log/installed.log<<EOF
CPU     : $cname"
Cores   : ${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)"
Mem     : $tram MB ($uram MB Used)"
Disk    : $disk_total_size GB ($disk_used_size GB Used)
OS      : $DISTRO $RELEASE $CODENAME ($arch)
Kernel  : $kern
#################################
INEXISTENCEVER=${INEXISTENCEVER}
INEXISTENCEDATE=${INEXISTENCEDATE}
SETUPDATE=$(date "+%Y.%m.%d.%H.%M.%S")
#################################
MAXCPUS=${MAXCPUS}
APTSOURCES=${aptsources}
QBVERSION=${QBVERSION}
DEVERSION=${DEVERSION}
DELTVERSION=${DELTVERSION}
RTVERSION=${RTVERSION}
TRVERSION=${TRVERSION}
FLEXGETINSTALLED=${flexget}
RCLONEINSTALLED=${rclone}
BBRINSTALLED=${bbr}
USETWEAKS=${tweaks}
UPLOADTOOLS=${tools}
VNCINSTALLED=${vnc}
#################################
EOF

sed -i '/^INEXISTEN*/'d /etc/profile
sed -i '/^ANUSER/'d /etc/profile
sed -i '/^USETWEAKS/'d /etc/profile
sed -i '/^#####\ U.*/'d /etc/profile

cat>>/etc/profile<<EOF

##### Used for future script determination #####
INEXISTENCEinstalled=Yes
INEXISTENCEVER=${INEXISTENCEVER}
INEXISTENCEDATE=${INEXISTENCEDATE}
USETWEAKS=${tweaks}
ANUSER=${ANUSER}
##### U ########################################
EOF

source /etc/profile

# 脚本设置
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
mkdir -p /var/www

ln -s /etc/inexistence /var/www/inexistence
ln -s /etc/inexistence /home/${ANUSER}/inexistence
cp -f "${local_packages}"/script/* /usr/local/bin

}





# --------------------- 替换系统源 --------------------- #

function _setsources() {

# rm /var/lib/dpkg/updates/*
# rm -rf /var/lib/apt/lists/partial/*
# apt-get -y upgrade

# 关闭交互
export DEBIAN_FRONTEND=noninteractive

if [ $aptsources == "Yes" ]; then

    if [[ $DISTRO == Debian ]]; then

        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
        wget -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/debian.apt.sources
        sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
        apt-get --yes --force-yes update

    elif [[ $DISTRO == Ubuntu ]]; then

        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
        wget -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/ubuntu.apt.sources
        sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
        apt-get -y update

    fi

else

    apt-get -y update

fi

_checkrepo1 2>&1 | tee /etc/00.checkrepo1.log
_checkrepo2 2>&1 | tee /etc/00.checkrepo2.log

# dpkg --configure -a
# apt-get -f -y install

apt-get install -y python sysstat vnstat wondershaper lrzsz mtr tree figlet toilet psmisc dirmngr zip unzip locales aptitude ntpdate smartmontools ruby screen git sudo zsh virt-what lsb-release curl checkinstall
[[ ! $? -eq 0 ]] && echo "${red}${bold}Failed to install packages, please check it and rerun once it is resolved${normal}\n" && exit 1

sed -i "s/TRANSLATE=1/TRANSLATE=0/g" /etc/checkinstallrc
# sed -i "s/ACCEPT_DEFAULT=0/ACCEPT_DEFAULT=1/g" /etc/checkinstallrc

}





# --------------------- 编译安装 qBittorrent --------------------- #

function _installqbt() {

# libtorrent-rasterbar 可以从系统源/PPA源里安装，或者用之前 deluge 用的 libtorrent-rasterbar；而编译 qbittorrent-nox 需要 libtorrent-rasterbar 的版本高于 1.0.6

# 好吧，先检查下系统源里的 libtorrent-rasterbar-dev 版本是多少压压惊
SysLTDEVer0=`apt-cache policy libtorrent-rasterbar-dev | grep Candidate | awk '{print $2}' | sed "s/[^0-9]/ /g"`
SysLTDEVer1=`echo $SysLTDEVer0 | awk '{print $1}'`
SysLTDEVer2=`echo $SysLTDEVer0 | awk '{print $2}'`
SysLTDEVer3=`echo $SysLTDEVer0 | awk '{print $3}'`
[[ $SysLTDEVer0 ]] && SysLTDEVer4=`echo ${SysLTDEVer1}.${SysLTDEVer2}.${SysLTDEVer3}`

# 检查 python-libtorrent 版本
PyLTVer0=`dpkg -l | grep python-libtorrent | awk '{print $3}' | sed 's/[^0-9]/ /g'`
PyLTVer1=`echo $PyLTVer0 | awk '{print $1}'`
PyLTVer2=`echo $PyLTVer0 | awk '{print $2}'`
PyLTVer3=`echo $PyLTVer0 | awk '{print $3}'`
[[ $PyLTVer0 ]] && PyLTVer4=`echo ${PyLTVer1}.${PyLTVer2}.${PyLTVer3}`

# 检查已安装的 libtorrent-rasterbar 版本
InstalledLTVer0=`dpkg -l | egrep libtorrent-rasterbar[789] | awk '{print $3}' | sed 's/[^0-9]/ /g'`
InstalledLTVer1=`echo $InstalledLTVer0 | awk '{print $1}'`
InstalledLTVer2=`echo $InstalledLTVer0 | awk '{print $2}'`
InstalledLTVer3=`echo $InstalledLTVer0 | awk '{print $3}'`
[[ $InstalledLTVer0 ]] && InstalledLTVer4=`echo ${InstalledLTVer1}.${InstalledLTVer2}.${InstalledLTVer3}`

# 检查已编译的 libtorrent-rasterbar 版本（只能检查到之前用脚本 checkinstall 安装且写入了版本号的）
BuildedLT=`dpkg -l | egrep "libtorrentde"`
BuildedLTVer0=`dpkg -l | egrep "libtorrentde" | awk '{print $3}' | sed 's/[^0-9]/ /g'`
BuildedLTVer1=`echo $BuildedLTVer0 | awk '{print $1}'`
BuildedLTVer2=`echo $BuildedLTVer0 | awk '{print $2}'`
BuildedLTVer3=`echo $BuildedLTVer0 | awk '{print $3}'`
[[ $BuildedLT ]] && BuildedLTVer4=`echo ${BuildedLTVer1}.${BuildedLTVer2}.${BuildedLTVer3}`

# 检查当前 Deluge 用的 libtorrent-rasterbar 版本（当之前安装 Deluge 是编译 libtorrent 的时候，这里的版本可能和 python-libtorrent 不一样）
if [[ -a $( command -v deluged ) ]]; then
    DeLTVer0=`deluged --version 2>/dev/null | grep libtorrent | awk '{print $2}' | sed "s/[^0-9]/ /g"`
    DeLTVer1=`echo $DeLTVer0 | awk '{print $1}'`
    DeLTVer2=`echo $DeLTVer0 | awk '{print $2}'`
    DeLTVer3=`echo $DeLTVer0 | awk '{print $3}'`
    [[ $DeLTVer0 ]] && DeLTVer4=`echo ${DeLTVer1}.${DeLTVer2}.${DeLTVer3}`
fi

[[ "${SysLTDEVer1}" == 0 ]] && SysQbLT=No
[[ "${SysLTDEVer1}" == 1 ]] && [[ "${SysLTDEVer2}" == 0 ]] && [[ "${SysLTDEVer3}" -lt 6 ]] && SysQbLT=No
[[ "${SysLTDEVer1}" == 1 ]] && [[ "${SysLTDEVer2}" == 0 ]] && [[ "${SysLTDEVer3}" -ge 6 ]] && SysQbLT=Yes
[[ "${SysLTDEVer1}" == 1 ]] && [[ "${SysLTDEVer2}" == 1 ]] && [[ "${SysLTDEVer3}" -ge 2 ]] && SysQbLT=Yes
[[ "${DeLTVer1}" == 0 ]] && DeLT=7 && DeQbLT=No
[[ "${DeLTVer1}" == 1 ]] && [[ "${DeLTVer2}" == 0 ]] && [[ "${DeLTVer3}" -ge 6 ]] && DeLT=8 && DeQbLT=Yes
[[ "${DeLTVer1}" == 1 ]] && [[ "${DeLTVer2}" == 0 ]] && [[ "${DeLTVer3}" -lt 6 ]] && DeLT=8 && DeQbLT=No
[[ "${DeLTVer1}" == 1 ]] && [[ "${DeLTVer2}" == 1 ]] && [[ "${DeLTVer3}" -ge 2 ]] && DeLT=9 && DeQbLT=Yes
# libtorrent 1.2.0 这种 beta 的东西就不管了

# 其实这个 same 并不严谨，有可能不是同一个版本，但我懒得管了。。。
[[ "${SysLTDEVer4}" == "${DeLTVer4}" ]] && SameLT=Yes

# 不用之前选择的版本做判断是为了防止出现有的人之前单独安装了 Deluge with 1.0.7 lt，又用脚本装 qb 导致出现 lt 冲突的情况

# 测试用的，在 Log 里也可以看
echo DeQbLT=$DeQbLT ; echo SysQbLT=$SysQbLT ; echo DeLTVer4=$DeLTVer4 ; echo BuildedLTVer4=$BuildedLTVer4 ; echo SysLTDEVer4=$SysLTDEVer4 ; echo InstalledLTVer4=$InstalledLTVer4
# [[ $DeQbLT == Yes ]] && [[ $BuildedLT ]] && echo 123


  if [[ "${QBVERSION}" == "Install from repo" ]]; then

      apt-get install -y qbittorrent-nox

  elif [[ "${QBVERSION}" == "Install from PPA" ]]; then

      apt-get install -y software-properties-common python-software-properties
      add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
      apt-get update
      apt-get install -y qbittorrent-nox

  else

      # 1. 不需要再安装 libtorrent-rasterbar
      #### 之前在安装 Deluge 的时候已经编译了 libtorrent-rasterbar，且版本满足 qBittorrent 编译的需要

      if [[ $DeQbLT == Yes ]] && [[ $BuildedLT ]]; then

          apt-get install -y build-essential pkg-config automake libtool git libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev qtbase5-dev qttools5-dev-tools libqt5svg5-dev python3 zlib1g-dev

          echo "qBittorrent libtorrent-rasterbar from deluge" >> /etc/inexistence/01.Log/installed.log

      # 2. 需要安装 libtorrent-rasterbar-dev
      #### Ubuntu 16.04 ，没装 deluge，或者装了 deluge 且用的 libtorrent 是源的版本，且需要装的 qBittorrent 版本不是 4.0 的
      ################ 还有一个情况，Ubuntu 16.04 或者 Debian 9，Deluge 用的是编译的 libtorrent-rasterbar 0.16.19，不确定能不能用这个办法，所以还是再用第三个方案编译一次算了……
      # 2018.02.01 这个情况一般不会出现了，因为我又隐藏了 libtorrent-rasterbar 0.16 分支的选项……

      elif [[ $SysQbLT == Yes && $QBVERSION4 == No && ! $DeLTVer4 ]] || [[ $SysQbLT == Yes && $SameLT == Yes && $QBVERSION4 == No ]]; then

          apt-get install -y build-essential pkg-config automake libtool git libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev qtbase5-dev qttools5-dev-tools libqt5svg5-dev python3 zlib1g-dev libtorrent-rasterbar-dev

          echo "qBittorrent libtorrent-rasterbar from system repo" >> /etc/inexistence/01.Log/installed.log

      # 3. 需要编译安装 libtorrent-rasterbar，安装速度慢
      #### Debian8 没装 Deluge 或者 Deluge 没有用编译的 libtorrent-rasterbar 1.0/1.1
      #### elif [[ $SysQbLT == Yes && ! -a $DeLTVer4 ]] || [[ $SysQbLT == Yes && $SameLT == Yes ]]; then
      #### 比较蛋疼的是我也不敢确定我的判断条件有没有写少了的，所以还是用 else

      #### 2018.01.26：今天我非常蛋疼地发现，Debian 9 自带的 libtorrent 1.1.1 可能编译 qb 的时候会出问题，所以 Debian 9 还是指定来编译 1.0 的 libtorrent 算了
      #### 也就是说现在 libtorrent 版本需要是 1.0.6-1.0.11，或 1.1.2 及以上 （？？？）
      #### https://github.com/qbittorrent/qBittorrent/issues/6197

      #### 2018.02.01：再补充一个需要安装的情况：Ubuntu 16.04 如果想要安装 qb 4.0 及以后的版本，repo 或 Deluge PPA 的 lt 都不行，必须在 C++11 模式下编译 lt
      #### https://github.com/qbittorrent/qBittorrent/issues/7863

      else

          apt-get purge -y libtorrent-rasterbar-dev
          apt-get install -y libqt5svg5-dev libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git python python3 checkinstall
          cd; git clone --depth=1 -b RC_1_0 --single-branch https://github.com/arvidn/libtorrent
          cd libtorrent
          ./autotool.sh
          ./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++11
          make clean
          make -j${MAXCPUS}
#         make install
          checkinstall -y --pkgname=libtorrentqb --pkgversion=1.0.11 || make install
          ldconfig
          echo;echo;echo;echo;echo;echo "  QB-LIBTORRENT-BUULDING-COMPLETED  ";echo;echo;echo;echo;echo

          echo "qBittorrent libtorrent-rasterbar from building" >> /etc/inexistence/01.Log/installed.log

      fi

      cd; git clone https://github.com/qbittorrent/qBittorrent
      cd qBittorrent
      git checkout release-${QBVERSION}

      if [[ "${QBPATCH}" == "Yes" ]]; then
          git cherry-pick db3158c
          git cherry-pick b271fa9
      fi
      
      ./configure --prefix=/usr --disable-gui
      make -j${MAXCPUS}
      checkinstall -y --pkgname=qbittorrentnox --pkgversion=$QBVERSION
#     make install
      cd;rm -rf libtorrent qBittorrent
      echo;echo;echo;echo;echo;echo "  QBITTORRENT-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

  fi

}





# --------------------- 设置 qBittorrent --------------------- #

function _setqbt() {

      [[ -d /root/.config/qBittorrent ]] && rm -rf /root/.config/qBittorrent.old && mv /root/.config/qBittorrent /root/.config/qBittorrent.old
#     [[ -d /home/${ANUSER}/.config/qBittorrent ]] && rm -rf /home/${ANUSER}/qBittorrent.old && mv /home/${ANUSER}/.config/qBittorrent /root/.config/qBittorrent.old
      mkdir -p /home/${ANUSER}/qbittorrent/{download,torrent,watch} /var/www /root/.config/qBittorrent  #/home/${ANUSER}/.config/qBittorrent
      chmod -R 777 /home/${ANUSER}/qbittorrent
      chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/qbittorrent  #/home/${ANUSER}/.config/qBittorrent
      chmod -R 777 /etc/inexistence/01.Log  #/home/${ANUSER}/.config/qBittorrent
      ln -s /home/${ANUSER}/qbittorrent/download /var/www/qbittorrent.download

      cp -f "${local_packages}"/template/config/qBittorrent.conf /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf
      cp -f "${local_packages}"/template/systemd/qbittorrent.service /etc/systemd/system/qbittorrent.service
#     cp -f "${local_packages}"/template/systemd/qbittorrent@.service /etc/systemd/system/qbittorrent@.service
      QBPASS=$(python "${local_packages}"/script/special/qbittorrent.userpass.py ${ANPASS})
      sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf
      sed -i "s/SCRIPTQBPASS/${QBPASS}/g" /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf

      systemctl daemon-reload
      systemctl enable qbittorrent
      systemctl start qbittorrent
#     systemctl enable qbittorrent@${ANUSER}
#     systemctl start qbittorrent@${ANUSER}

}




# --------------------- 编译安装 Deluge --------------------- #

function _installde() {

  if [[ "${DEVERSION}" == "Install from repo" ]]; then

      apt-get install -y deluged deluge-web

  elif [[ "${DEVERSION}" == "Install from PPA" ]]; then

      apt-get install -y software-properties-common python-software-properties
      add-apt-repository -y ppa:deluge-team/ppa
      apt-get update
#     apt-get install -y --allow-downgrades libtorrent-rasterbar8 python-libtorrent
      apt-get install -y --allow-downgrades libtorrent-rasterbar8=1.0.11-1~xenial~ppa1.1 python-libtorrent=1.0.11-1~xenial~ppa1.1
      apt-mark hold libtorrent-rasterbar8 python-libtorrent
      apt-get install -y deluged deluge-web

  else

      # 编译安装 libtorrent-rasterbar
      if [ ! $DELTVERSION == "Install from repo" ]; then

          apt-get install -y build-essential checkinstall libboost-system-dev libboost-python-dev libssl-dev libgeoip-dev libboost-chrono-dev libboost-random-dev python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako git libtool automake autoconf
          cd; git clone --depth=1 -b ${DELTVERSION} --single-branch https://github.com/arvidn/libtorrent
          cd libtorrent
          ./autotool.sh
          ./configure --enable-python-binding --with-libiconv --with-libgeoip=system CXXFLAGS=-std=c++11
          make -j${MAXCPUS}
          checkinstall -y --pkgname=libtorrentde --pkgversion=${DELTPKG}
          ldconfig
          echo;echo;echo;echo;echo;echo "  DE-LIBTORRENT-BUULDING-COMPLETED  ";echo;echo;echo;echo;echo

      # 从源里安装 libtorrent-rasterbar[789] 以及对应版本的 python-libtorrent
      else

          apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako python-libtorrent

      fi

      cd; wget --no-check-certificate -q http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
      tar zxf deluge-"${DEVERSION}".tar.gz
      cd deluge-"${DEVERSION}"
      python setup.py build
      python setup.py install --install-layout=deb
#     python setup.py install_data
      cd; rm -rf deluge* libtorrent

  fi

  echo;echo;echo;echo;echo;echo "  DELUGE-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

}




# --------------------- Deluge 启动脚本、配置文件 --------------------- #

function _setde() {

  if [ ! "${DEVERSION}" == "No" ]; then

#     [[ -d /home/${ANUSER}/.config/deluge ]] && rm-rf /home/${ANUSER}/.config/deluge.old && mv /home/${ANUSER}/.config/deluge /root/.config/deluge.old
      mkdir -p /home/${ANUSER}/deluge/{download,torrent,watch} /var/www
      ln -s /home/${ANUSER}/deluge/download/ /var/www/deluge.download
      chmod -R 777 /home/${ANUSER}/deluge  #/home/${ANUSER}/.config
      chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/deluge  #/home/${ANUSER}/.config

      touch /etc/inexistence/01.Log/deluged.log /etc/inexistence/01.Log/delugeweb.log
      chmod -R 777 /etc/inexistence/01.Log

#     mkdir -p /home/${ANUSER}/.config  && cd /home/${ANUSER}/.config && rm -rf deluge
#     cp -f -r "${local_packages}"/template/config/deluge /home/${ANUSER}/.config
      mkdir -p /root/.config && cd /root/.config
      [[ -d /root/.config/deluge ]] && rm-rf /root/.config/deluge && mv /root/.config/deluge /root/.config/deluge.old
      cp -f "${local_packages}"/template/config/deluge.config.tar.gz /root/.config/deluge.config.tar.gz
      tar zxf deluge.config.tar.gz
      chmod -R 777 /root/.config
      rm -rf deluge.config.tar.gz; cd

      DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      DWP=$(python "${local_packages}"/script/special/deluge.userpass.py ${ANPASS} ${DWSALT})
      echo "${ANUSER}:${ANPASS}:10" > /root/.config/deluge/auth  #/home/${ANUSER}/.config/deluge/auth
      sed -i "s/delugeuser/${ANUSER}/g" /root/.config/deluge/core.conf  #/home/${ANUSER}/.config/deluge/core.conf
      sed -i "s/DWSALT/${DWSALT}/g" /root/.config/deluge/web.conf  #/home/${ANUSER}/.config/deluge/web.conf
      sed -i "s/DWP/${DWP}/g" /root/.config/deluge/web.conf  #/home/${ANUSER}/.config/deluge/web.conf

      cp -f "${local_packages}"/template/systemd/deluged.service /etc/systemd/system/deluged.service
      cp -f "${local_packages}"/template/systemd/deluge-web.service /etc/systemd/system/deluge-web.service
#     cp -f "${local_packages}"/template/systemd/deluged@.service /etc/systemd/system/deluged@.service
#     cp -f "${local_packages}"/template/systemd/deluge-web@.service /etc/systemd/system/deluge-web@.service

      systemctl daemon-reload
      systemctl enable /etc/systemd/system/deluge-web.service
      systemctl enable /etc/systemd/system/deluged.service
      systemctl start deluged
      systemctl start deluge-web
#     systemctl enable {deluged,deluge-web}@${ANUSER}
#     systemctl start {deluged,deluge-web}@${ANUSER}

  fi

}




# --------------------- 使用修改版 rtinst 安装 rTorrent，h5ai --------------------- #

function _installrt() {

  wget --no-check-certificate https://raw.githubusercontent.com/Aniverse/rtinst/h5ai-ipv6/rtsetup

  if [ "${RTVERSION}" == "0.9.4 ipv6 supported" ]; then
      export RTVERSION=0.9.4
      bash rtsetup h5ai-ipv6
  elif [ "${RTVERSION}" == "0.9.4" ]; then
      bash rtsetup h5ai
  else
      bash rtsetup h5ai-ipv6
  fi

wget --no-check-certificate --timeout=10 -q https://raw.githubusercontent.com/Aniverse/rtinst/h5ai-ipv6/rarlinux-x64-5.5.0.tar.gz
tar zxf rarlinux-x64-5.5.0.tar.gz 2>/dev/null
chmod -R +x rar
cp -f rar/rar /usr/bin/rar
cp -f rar/unrar /usr/bin/unrar
rm -rf rar rarlinux-x64-5.5.0.tar.gz

apt-get install -y --allow-unauthenticated libncurses5-dev libncursesw5-dev
sed -i "s/rtorrentrel=''/rtorrentrel='${RTVERSION}'/g" /usr/local/bin/rtinst
sed -i "s/make\ \-s\ \-j\$(nproc)/make\ \-s\ \-j${MAXCPUS}/g" /usr/local/bin/rtupdate

  rtinst -t -l -y -u ${ANUSER} -p ${ANPASS} -w ${ANPASS}
# rtwebmin

sed -i "s/\"mkv\"/\"mkv\",\"m2ts\"/g" /var/www/rutorrent/plugins/screenshots/conf.php

openssl req -x509 -nodes -days 3650 -subj /CN=$serveripv4 -config /etc/ssl/ruweb.cnf -newkey rsa:2048 -keyout /etc/ssl/private/ruweb.key -out /etc/ssl/ruweb.crt
mv /root/rtinst.log /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log
mv /home/${ANUSER}/rtinst.info /etc/inexistence/01.Log/INSTALLATION/07.rtinst.info.txt
ln -s /home/${ANUSER} /var/www/user.folder
  
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

if [[ "${TRVERSION}" == "Install from repo" ]]; then

    apt-get install -y transmission-daemon

elif [[ "${TRVERSION}" == "Install from PPA" ]]; then

    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:transmissionbt/ppa
    apt-get update
    apt-get install -y transmission-daemon

else

    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev ca-certificates libssl-dev pkg-config checkinstall cmake git
    apt-get install -y openssl
    [[ "$CODENAME" = "stretch" ]] && apt-get install -y libssl1.0-dev
    cd; wget --no-check-certificate https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
    tar xvf release-2.1.8-stable.tar.gz
    mv libevent-release-2.1.8-stable libevent
    cd libevent
    ./autogen.sh
    ./configure
    make -j${MAXCPUS}
#   make install
    checkinstall -y --pkgversion=2.1.8
    cd; rm -rf libevent release-2.1.8-stable.tar.gz
#   ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib/libevent-2.1.so.6
    ldconfig

    if [[ "${TRdefault}" == "No" ]]; then
        wget https://github.com/Aniverse/BitTorrentClientCollection/raw/master/TransmissionMod/transmission-${TRVERSION}.tar.gz
        tar xvf transmission-${TRVERSION}.tar.gz
        cd transmission-${TRVERSION}
    else
        git clone --depth=1 -b ${TRVERSION} --single-branch https://github.com/transmission/transmission
        cd transmission
        [[ ! "$TRVERSION" = "2.93" ]] && sed -i "s/m4_copy/m4_copy_force/g" m4/glib-gettext.m4
#       sed -i "s/FD_SETSIZE=1024/FD_SETSIZE=666666/g" CMakeLists.txt
    fi

    ./autogen.sh
    ./configure --prefix=/usr
    make -j${MAXCPUS}
#   make install
    checkinstall -y --pkgversion=$TRVERSION
    cd; rm -rf transmission*

fi

echo;echo;echo;echo;echo;echo "  TR-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

}




# --------------------- 配置 Transmission --------------------- #

function _settr() {

if [ ! "${TRVERSION}" == "No" ]; then

    wget --no-check-certificate -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control.sh | bash

#   [[ -d /home/${ANUSER}/.config/transmission-daemon ]] && rm -rf /home/${ANUSER}/.config/transmission-daemon.old && mv /home/${ANUSER}/.config/transmission-daemon /home/${ANUSER}/.config/transmission-daemon.old
    [[ -d /root/.config/transmission-daemon ]] && rm -rf /root/.config/transmission-daemon.old && mv /root/.config/transmission-daemon /root/.config/transmission-daemon.old

    mkdir -p /home/${ANUSER}/{download,torrent,watch} /var/www /root/.config/transmission-daemon  #/home/${ANUSER}/.config/transmission-daemon
    chmod -R 777 /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
    chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
    ln -s /home/${ANUSER}/transmission/download/ /var/www/transmission.download

    cp -f "${local_packages}"/template/config/transmission.settings.json /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json
    cp -f "${local_packages}"/template/systemd/transmission.service /etc/systemd/system/transmission.service
#   cp -f "${local_packages}"/template/systemd/transmission@.service /etc/systemd/system/transmission@.service
    [[ `command -v transmission-daemon` == /usr/local/bin/transmission-daemon ]] && sed -i "s/usr/usr\/local/g" /etc/systemd/system/transmission.service
    
    sed -i "s/RPCUSERNAME/${ANUSER}/g" /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json
    sed -i "s/RPCPASSWORD/${ANPASS}/g" /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json

    systemctl daemon-reload
    systemctl enable transmission
    systemctl start transmission
#   systemctl enable transmission@${ANUSER}
#   systemctl start transmission@${ANUSER}

fi

}




# --------------------- 安装、配置 Flexget --------------------- #

function _installflex() {

  apt-get -y install python-pip
  pip install --upgrade setuptools pip
  pip install flexget transmissionrpc

  mkdir -p /home/${ANUSER}/{transmission,qBittorrent,rtorrent,deluge}/{download,watch} /root/.config/flexget   #/home/${ANUSER}/.config/flexget

  cp -f "${local_packages}"/template/config/flexfet.config.yml /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
  sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
  sed -i "s/SCRIPTPASSWORD/${ANPASS}/g" /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
# chmod -R 777 /home/${ANUSER}/.config/flexget
# chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/.config/flexget

  flexget web passwd ${ANPASS}

  cp -f "${local_packages}"/template/systemd/flexget.service /etc/systemd/system/flexget.service
# cp -f "${local_packages}"/template/systemd/flexget@.service /etc/systemd/system/flexget@.service
  systemctl daemon-reload
  systemctl enable /etc/systemd/system/flexget.service
  systemctl start flexget
# systemctl enable flexget@${ANPASS}
# systemctl start flexget@${ANPASS}

  echo;echo;echo;echo;echo;echo "  FLEXGET-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

}




# --------------------- 安装 rclone --------------------- #

function _installrclone() {

  apt-get install -y nload htop fuse p7zip-full
  [[ "$lbit" == '32' ]] && KernelBitVer='i386'
  [[ "$lbit" == '64' ]] && KernelBitVer='amd64'
  [[ -z "$KernelBitVer" ]] && KernelBitVer='amd64'
  cd; wget --no-check-certificate https://downloads.rclone.org/rclone-current-linux-$KernelBitVer.zip
  unzip rclone-current-linux-$KernelBitVer.zip
  cd rclone-*-linux-$KernelBitVer
  cp rclone /usr/bin/
  chown root:root /usr/bin/rclone
  chmod 755 /usr/bin/rclone
  mkdir -p /usr/local/share/man/man1
  cp rclone.1 /usr/local/share/man/man1
  mandb
  cd; rm -rf rclone-*-linux-$KernelBitVer rclone-current-linux-$KernelBitVer.zip
  cp "${local_packages}"/script/dalao/rcloned /etc/init.d/recloned
# bash /etc/init.d/recloned init
  echo;echo;echo;echo;echo;echo "  RCLONE-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

}





# --------------------- 安装 BBR --------------------- #

function _installbbr() {

cd
bash "${local_packages}"/script/dalao/bbr1.sh
mv install_bbr.log /etc/inexistence/01.Log/install_bbr.log

# 下边增加固件是为了解决 Online.net 服务器安装 BBR 后无法开机的问题
mkdir -p /lib/firmware/bnx2
cp -f /etc/inexistence/03.Files/firmware/bnx2-mips-06-6.2.3.fw /lib/firmware/bnx2/bnx2-mips-06-6.2.3.fw
cp -f /etc/inexistence/03.Files/firmware/bnx2-mips-09-6.2.1b.fw /lib/firmware/bnx2/bnx2-mips-09-6.2.1b.fw
cp -f /etc/inexistence/03.Files/firmware/bnx2-rv2p-09ax-6.0.17.fw /lib/firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw
cp -f /etc/inexistence/03.Files/firmware/bnx2-rv2p-09-6.0.17.fw /lib/firmware/bnx2/bnx2-rv2p-09-6.0.17.fw
cp -f /etc/inexistence/03.Files/firmware/bnx2-rv2p-06-6.0.15.fw /lib/firmware/bnx2/bnx2-rv2p-06-6.0.15.fw

echo;echo;echo;echo;echo;echo "  BBR-INSTALLATION-COMPLETED  ";echo;echo;echo;echo;echo

}





# --------------------- 安装 VNC/wine --------------------- #

function _installvnc() {

dpkg --add-architecture i386 
wget --no-check-certificate -qO- https://dl.winehq.org/wine-builds/Release.key | apt-key add -
apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install -y --install-recommends winehq-stable
apt-get install -y fonts-noto
apt-get install -y vnc4server
apt-get install -y xfonts-intl-chinese-big fcitx xfonts-wqy
apt-get install -y xfce4
#apt-get install -y mate-desktop-environment-extras
vncpasswd=`date +%s | sha256sum | base64 | head -c 8`
vncpasswd <<EOF
$ANPASS
$ANPASS
EOF
vncserver && vncserver -kill :1
cd; mkdir -p .vnc
cp -f "${local_packages}"/template/xstartup.1 /root/.vnc/xstartup
cp -f "${local_packages}"/template/systemd/vncserver.service /etc/systemd/system/vncserver.service

systemctl daemon-reload
systemctl enable vncserver
systemctl start vncserver

#vncserver -geometry 1366x768

}





# --------------------- 安装 mkvtoolnix／wine／mktorrent／ffmpeg／mediainfo --------------------- #
# 没写完，目前不会投入使用

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

    if [ $CODENAME = stretch ]; then

cat >>/etc/apt/sources.list<<EOF
deb https://mkvtoolnix.download/debian/jessie/ ./
deb-src https://mkvtoolnix.download/debian/jessie/ ./
EOF

    elif [ $CODENAME = jessie ]; then

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

########### 安装 mediainfo ########## 
# https://mediaarea.net/en/MediaInfo/Download/Debian

wget --no-check-certificate https://mediaarea.net/repo/deb/repo-mediaarea_1.0-5_all.deb
dpkg -i repo-mediaarea_1.0-5_all.deb
rm -rf repo-mediaarea_1.0-5_all.deb
apt-get update
apt-get -y install mediainfo

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
cp -f "${local_packages}"/template/mktorrent.php /var/www/mktorrent/index.php
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


# Oh my zsh
#sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
#cp -f "${local_packages}"/template/config/zshrc ~/.zshrc
#wget -O ~/.zshrc https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/config/zshrc
#wget -O ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

#chsh -s /bin/zsh


# PowerFonts
#git clone --depth=1 -b master --single-branch https://github.com/powerline/fonts
#cd fonts;./install.sh
#cd; rm -rf fonts


#修改时区
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
ntpdate time.windows.com
hwclock -w


#screen 设置
cat>>/etc/screenrc<<EOF
shell -$SHELL

startup_message off
defutf8 on
defencoding utf8  
encoding utf8 utf8 
defscrollback 23333
EOF


#设置编码与alias
cat>>/etc/profile<<EOF
################## Seedbox Script Mod Start ##################

ulimit -SHn 666666

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
alias fla="systemctl start flexget"
alias flb="systemctl stop flexget"
alias flc="flexget daemon status"
alias flr="systemctl restart flexget"
alias cdde="cd /home/${ANUSER}/deluge/download"
alias cdqb="cd /home/${ANUSER}/qbittorrent/download"
alias cdrt="cd /home/${ANUSER}/rtorrent/download"
alias cdtr="cd /home/${ANUSER}/transmission/download"
alias shanchu="rm -rf"
alias xiugai="nano /etc/profile && source /etc/profile"
alias quanxian="chmod -R 777"
alias anzhuang="apt-get install"
alias yongyouzhe="chown ${ANUSER}:${ANUSER}"

alias ssa="/etc/init.d/shadowsocks-r start"
alias ssb="/etc/init.d/shadowsocks-r stop"
alias ssc="/etc/init.d/shadowsocks-r status"
alias ssr="/etc/init.d/shadowsocks-r restart"
alias ruisua="/appex/bin/serverSpeeder.sh start"
alias ruisub="/appex/bin/serverSpeeder.sh stop"
alias ruisuc="/appex/bin/serverSpeeder.sh status"
alias ruisur="/appex/bin/serverSpeeder.sh restart"

alias del="tail -n100 /etc/inexistence/01.Log/deluged.log"
alias dewl="tail -n100 /etc/inexistence/01.Log/delugeweb.log"
alias qbl="tail -n100 /etc/inexistence/01.Log/qbittorrent.log"
alias qbs="nano /root/.config/qBittorrent/qBittorrent.conf"
alias fll="tail -n100 /root/.config/flexget/flexget.log"
alias fls="nano /root/.config/flexget/config.yml"
alias rtscreen="chmod -R 777 /dev/pts && sudo -u ${ANUSER} screen -r rtorrent"

alias banben1='apt-cache policy'
alias banben2='dpkg -l | grep'
alias yongle='du -sB GB'
alias scrl="screen -ls"
alias scrgd="screen -U -R GoogleDrive"
alias jincheng="ps aux | grep -v grep | grep"
alias ios="iostat -d -x -k 1"
alias cdb="cd .."
alias cesu="echo;spdtest --share;echo"
alias cesu2="echo;spdtest --share --server"
alias cesu3="echo;spdtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ls="ls -hAv --color --group-directories-first"
alias ll="ls -hAlvZ --color --group-directories-first"
alias wget="wget --no-check-certificate"
alias tree="tree --dirsfirst"
alias gclone="git clone --depth=1"

alias eac3to='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe'
alias eacout='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe 2>/dev/null | tr -cd "\11\12\15\40-\176"'

alias jiaobenxuanxiang="clear && cat /etc/inexistence/01.Log/installed.log && echo"
alias jiaobende="clear && cat /etc/inexistence/01.Log/INSTALLATION/03.de1.log && echo"
alias jiaobenqb="clear && cat /etc/inexistence/01.Log/INSTALLATION/05.qb1.log && echo"
alias jiaobenrt="clear && cat /etc/inexistence/01.Log/INSTALLATION/07.rt.log && echo"
alias jiaobentr="clear && cat /etc/inexistence/01.Log/INSTALLATION/08.tr1.log && echo"
alias jiaobenfl="clear && cat /etc/inexistence/01.Log/INSTALLATION/10.flexget.log && echo"
alias jiaobenend="clear && cat /etc/inexistence/01.Log/INSTALLATION/99.end.log && echo"

################## Seedbox Script Mod END ##################
EOF


# 提高文件打开数

sed -i '/^fs.file-max.*/'d /etc/sysctl.conf
sed -i '/^fs.nr_open.*/'d /etc/sysctl.conf
echo "fs.file-max = 666666" >> /etc/sysctl.conf
echo "fs.nr_open = 666666" >> /etc/sysctl.conf

sed -i '/.*nofile.*/'d /etc/security/limits.conf
sed -i '/.*nproc.*/'d /etc/security/limits.conf

cat>>/etc/security/limits.conf<<EOF
* - nofile 666666
* - nproc 666666
$ANUSER soft nofile 666666
$ANUSER hard nofile 666666
root soft nofile 666666
root hard nofile 666666
EOF

sed -i '/^DefaultLimitNOFILE.*/'d /etc/systemd/system.conf
sed -i '/^DefaultLimitNPROC.*/'d /etc/systemd/system.conf
echo "DefaultLimitNOFILE=666666" >> /etc/systemd/system.conf
echo "DefaultLimitNPROC=666666" >> /etc/systemd/system.conf

sed -i '/^DefaultLimitNOFILE.*/'d /etc/systemd/user.conf
sed -i '/^DefaultLimitNPROC.*/'d /etc/systemd/user.conf
echo "DefaultLimitNOFILE=666666" >> /etc/systemd/user.conf
echo "DefaultLimitNPROC=666666" >> /etc/systemd/user.conf

# 将最大的分区的保留空间设置为 0%
tune2fs -m 0 `df -k | sort -rn -k4 | awk '{print $1}' | head -1`

locale-gen en_US.UTF-8
locale
sysctl -p
# source /etc/profile

# apt-get -y upgrade
# apt-get -y autoremove

fi

}




# --------------------- 结尾 --------------------- #

function _end() {

_check_install_2

timeused=$(( $endtime - $starttime ))

echo
clear

echo -e " ${baiqingse}${bold}      INSTALLATION COMPLETED      ${normal} "
echo
echo '-----------------------------------------------------------'

if [[ ! "${QBVERSION}" == "No" ]] && [[ "${qb_installed}" == "Yes" ]]; then
    echo -e " ${cyan}qBittorrent WebUI${normal}    http://${serveripv4}:2017"
elif [[ ! "${QBVERSION}" == "No" ]] && [[ "${qb_installed}" == "No" ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}qBittorrent installation FAILED${normal}"
fi

if [[ ! "${DEVERSION}" == "No" ]] && [[ "${de_installed}" == "Yes" ]]; then
    echo -e " ${cyan}Deluge WebUI${normal}         http://${serveripv4}:8112"
elif [[ ! "${DEVERSION}" == "No" ]] && [[ "${de_installed}" == "No" ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Deluge installation FAILED${normal}"
fi

if [[ ! "${TRVERSION}" == "No" ]] && [[ "${tr_installed}" == "Yes" ]]; then
    echo -e " ${cyan}Transmission WebUI${normal}   http://${ANUSER}:${ANPASS}@${serveripv4}:9099"
elif [[ ! "${TRVERSION}" == "No" ]] && [[ "${tr_installed}" == "No" ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Transmission installation FAILED${normal}"
fi

if [[ ! "${RTVERSION}" == "No" ]] && [[ "${rt_installed}" == "Yes" ]]; then
    echo -e " ${cyan}RuTorrent${normal}            https://${ANUSER}:${ANPASS}@${serveripv4}/rutorrent"
    echo -e " ${cyan}h5ai File Indexer${normal}    https://${ANUSER}:${ANPASS}@${serveripv4}"
#   echo -e " ${cyan}webmin${normal}               https://${serveripv4}/webmin"
elif [[ ! "${RTVERSION}" == "No" ]] && [[ "${rt_installed}" == "No" ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}rTorrent installation FAILED${normal}"
fi

if [[ ! $flexget == "No" ]] && [[ "${flex_installed}" == "Yes" ]]; then
    echo -e " ${cyan}Flexget WebUI${normal}        http://${serveripv4}:6566"
elif [[ ! $flexget == "No" ]] && [[ "${flex_installed}" == "No" ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Flexget installation FAILED${normal}"
fi

# echo -e " ${cyan}MkTorrent WebUI${normal}      https://${ANUSER}:${ANPASS}@${serveripv4}/mktorrent"

echo -e "\n ${cyan}Your Username${normal}        ${bold}${ANUSER}${normal}"
echo -e " ${cyan}Your Password${normal}        ${bold}${ANPASS}${normal}"


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
_warning
_askusername
_askpassword
_askaptsource
_askmt
_askdeluge
_askdelt
_askqbt
_askrt
_asktr
_askflex
_askrclone
# _askvnc
# _asktools

if [[ -d "/proc/vz" ]]; then
    echo -e "${yellow}${bold}Since your seedbox is based on ${red}OpenVZ${normal}${yellow}${bold}, skip BBR installation${normal}"
    echo
    bbr='Not supported on OpenVZ'
else
    _askbbr
fi

_asktweaks
_askcontinue | tee /etc/00.info.log

starttime=$(date +%s)

_setsources 2>&1 | tee /etc/00.setsources.log
_setuser 2>&1 | tee /etc/01.setuser.log

mv /etc/00.info.log /etc/inexistence/01.Log/INSTALLATION/00.info.log
mv /etc/00.setsources.log /etc/inexistence/01.Log/INSTALLATION/00.setsources.log
mv /etc/00.checkrepo1.log /etc/inexistence/01.Log/INSTALLATION/00.checkrepo1.log
mv /etc/00.checkrepo2.log /etc/inexistence/01.Log/INSTALLATION/00.checkrepo2.log
mv /etc/01.setuser.log /etc/inexistence/01.Log/INSTALLATION/01.setuser.log

# --------------------- 安装 --------------------- #



if [ $bbr == "Yes" ]; then
    echo -n "Configuring BBR ... ";echo;echo;echo; _installbbr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/02.bbr.log
else
    echo "Skip BBR installation";echo;echo;echo;echo;echo
fi

if [ "${DEVERSION}" == "No" ]; then
    echo "Skip Deluge installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Deluge ... ";echo;echo;echo; _installde 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/03.de1.log
    echo -n "Configuring Deluge ... ";echo;echo;echo; _setde 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/04.de2.log
fi


if [ "${QBVERSION}" == "No" ]; then
    echo "Skip qBittorrent installation";echo;echo;echo;echo;echo
else
    echo -n "Installing qBittorrent ... ";echo;echo;echo; _installqbt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/05.qb1.log
    echo -n "Configuring qBittorrent ... ";echo;echo;echo;  _setqbt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/06.qb2.log
fi


if [ "${RTVERSION}" == "No" ]; then
    echo "Skip rTorrent installation";echo;echo;echo;echo;echo
else
    echo -n "Installing rTorrent ... ";echo;echo;echo; _installrt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/07.rt.log
fi


if [ "${TRVERSION}" == "No" ]; then
    echo "Skip Transmission installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Transmission ... ";echo;echo;echo; _installtr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/08.tr1.log
    echo -n "Configuring Transmission ... ";echo;echo;echo; _settr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/09.tr2.log
fi


if [ $flexget == "No" ]; then
    echo "Skip Flexget installation";echo;echo;echo;echo;echo
else
    echo -n "Installing Flexget ... ";echo;echo;echo; _installflex 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/10.flexget.log
fi


if [ $rclone == "No" ]; then
    echo "Skip rclone installation";echo;echo;echo;echo;echo
else
    echo -n "Installing rclone ... ";echo;echo;echo; _installrclone 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/11.rclone.log
fi


if [ $tweaks == "No" ]; then
    echo "Skip System tweaks";echo;echo;echo;echo;echo
else
    echo -n "Configuring system settings ... ";echo;echo;echo;_tweaks
fi


endtime=$(date +%s)
_end 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/99.end.log
rm "$0" >> /dev/null 2>&1
_askreboot


