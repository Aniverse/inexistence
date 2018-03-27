#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH
# --------------------------------------------------------------------------------
SYSTEMCHECK=1
DISABLE=0
DeBUG=0
INEXISTENCEVER=099
INEXISTENCEDATE=2018.03.27.5
# --------------------------------------------------------------------------------



# 获取参数

OPTS=$(getopt -n "$0" -o dsyu:p: --long "yes,skip,debug,apt-yes,apt-no,swap-yes,swap-no,bbr-yes,bbr-no,flood-yes,flood-no,rdp-vnc,rdp-x2go,rdp-no,wine-yes,wine-no,tools-yes,tools-no,flexget-yes,flexget-no,rclone-yes,rclone-no,enable-ipv6,tweaks-yes,tweaks-no,mt-single,mt-double,mt-max,mt-half,user:,password:,webpass:,de:,delt:,qb:,rt:,tr:" -- "$@")

eval set -- "$OPTS"

while true; do
  case "$1" in
    -u | --user     ) ANUSER="$2"       ; shift ; shift ;;
    -p | --password ) ANPASS="$2"       ; shift ; shift ;;

    --qb            ) { if [[ $2 == ppa ]]; then QBVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then QBVERSION='Install from repo'   ; else QBVERSION=$2   ; fi ; } ; shift ; shift ;;
    --rt            ) { if [[ $2 == ppa ]]; then RTVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then RTVERSION='Install from repo'   ; else RTVERSION=$2   ; fi ; } ; shift ; shift ;;
    --tr            ) { if [[ $2 == ppa ]]; then TRVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then TRVERSION='Install from repo'   ; else TRVERSION=$2   ; fi ; } ; shift ; shift ;;
    --de            ) { if [[ $2 == ppa ]]; then DEVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then DEVERSION='Install from repo'   ; else DEVERSION=$2   ; fi ; } ; shift ; shift ;;
    --delt          ) { if [[ $2 == ppa ]]; then DELTVERSION='Install from PPA' ; elif [[ $2 == repo ]]; then DELTVERSION='Install from repo' ; else DELTVERSION=$2 ; fi ; } ; shift ; shift ;;

    -d | --debug    ) DeBUG=1           ; shift ;;
    -s | --skip     ) SYSTEMCHECK=0     ; shift ;;
    -y | --yes      ) ForceYes=1        ; shift ;;

    --enable-ipv6   ) IPv6Opt=-i        ; shift ;;
    --apt-yes       ) aptsources="Yes"  ; shift ;;
    --apt-no        ) aptsources="No"   ; shift ;;
    --swap-yes      ) USESWAP="Yes"     ; shift ;;
    --swap-no       ) USESWAP="No"      ; shift ;;
    --bbr-yes       ) InsBBR="Yes"      ; shift ;;
    --bbr-no        ) InsBBR="No"       ; shift ;;
    --flood-yes     ) InsFlood="Yes"    ; shift ;;
    --flood-no      ) InsFlood="No"     ; shift ;;
    --rdp-vnc       ) InsRDP="VNC"      ; shift ;;
    --rdp-x2go      ) InsRDP="X2Go"     ; shift ;;
    --rdp-no        ) InsRDP="No"       ; shift ;;
    --wine-yes      ) InsWine="Yes"     ; shift ;;
    --wine-no       ) InsWine="No"      ; shift ;;
    --tools-yes     ) InsTools="Yes"    ; shift ;;
    --tools-no      ) InsTools="No"     ; shift ;;
    --flexget-yes   ) InsFlex="Yes"     ; shift ;;
    --flexget-no    ) InsFlex="No"      ; shift ;;
    --rclone-yes    ) InsRclone="Yes"   ; shift ;;
    --rclone-no     ) InsRclone="No"    ; shift ;;
    --tweaks-yes    ) UseTweaks="Yes"   ; shift ;;
    --tweaks-no     ) UseTweaks="No"    ; shift ;;
    --mt-single     ) MAXCPUS=1         ; shift ;;
    --mt-double     ) MAXCPUS=2         ; shift ;;
    --mt-max        ) MAXCPUS=$(nproc)  ; shift ;;
    --mt-half       ) MAXCPUS=$(echo "$(nproc) / 2"|bc)  ; shift ;;

    -- ) shift; break ;;
     * ) break ;;
  esac
done

if [[ $DeBUG == 1 ]]; then
    ANUSER=aniverse ; aptsources=Yes ; MAXCPUS=$(nproc)
fi
# --------------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
local_packages=/etc/inexistence/00.Installation
# --------------------------------------------------------------------------------
### 颜色样式 ###
function _colors() {
black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3);
blue=$(tput setaf 4); magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7);
on_red=$(tput setab 1); on_green=$(tput setab 2); on_yellow=$(tput setab 3); on_blue=$(tput setab 4);
on_magenta=$(tput setab 5); on_cyan=$(tput setab 6); on_white=$(tput setab 7); bold=$(tput bold);
dim=$(tput dim); underline=$(tput smul); reset_underline=$(tput rmul); standout=$(tput smso);
reset_standout=$(tput rmso); normal=$(tput sgr0); alert=${white}${on_red}; title=${standout};
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue}; bailvse=${white}${on_green};
baiqingse=${white}${on_cyan}; baihongse=${white}${on_red}; baizise=${white}${on_magenta};
heibaise=${black}${on_white}; heihuangse=${on_yellow}${black}
jiacu=${normal}${bold}
shanshuo=$(tput blink); wuguangbiao=$(tput civis); guangbiao=$(tput cnorm) ; }
_colors
# --------------------------------------------------------------------------------
# 增加 swap
function _use_swap() { dd if=/dev/zero of=/root/.swapfile bs=1M count=1024  ;  mkswap /root/.swapfile  ;  swapon /root/.swapfile  ;  swapon -s  ;  }

# 关掉之前开的 swap
function _disable_swap() { swapoff /root/.swapfile  ;  rm -f /.swapfile  ;  }

# 用于退出脚本
export TOP_PID=$$
trap 'exit 1' TERM

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
    echo ${total_size} ; }

### 操作系统检测 ###
get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return ; }

# --------------------------------------------------------------------------------
### 是否为 IPv4 地址(其实也不一定是) ###
function isValidIpAddress() { echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$' ; }

### 是否为内网 IPv4 地址 ###
function isInternalIpAddress() { echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))' ; }

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
  fi ; }

function _check_install_2(){
for apps in qbittorrent-nox deluged rtorrent transmission-daemon flexget rclone irssi ffmpeg mediainfo wget wine mono; do
    client_name=$apps ; _check_install_1
done ; }

function _client_version_check(){
[[ "${qb_installed}" == "Yes" ]] && qbtnox_ver=`qbittorrent-nox --version | awk '{print $2}' | sed "s/v//"`
[[ "${de_installed}" == "Yes" ]] && deluged_ver=`deluged --version | grep deluged | awk '{print $2}'` && delugelt_ver=`  deluged --version | grep libtorrent | grep -Eo "[01].[0-9]+.[0-9]+"  `
[[ "${rt_installed}" == "Yes" ]] && rtorrent_ver=`rtorrent -h | head -n1 | sed -ne 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\)[^0-9]*/\1/p'`
[[ "${tr_installed}" == "Yes" ]] && trd_ver=`transmission-daemon --help | head -n1 | awk '{print $2}'` ; }

# --------------------------------------------------------------------------------
### 随机数 ###
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------
### 检查网站是否可以访问
check_url() { if [[ `wget -S --spider --no-check-certificate -t1 -T6 $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then return 0; else return 1; fi ; }

### 检查系统源是否可用 ###
function _checkrepo1() {
os_repo=0
echo -e "\n${bold}Checking the web sites we will need are accessible${normal}"

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
xmlrpc_url="https://github.com/Aniverse/xmlrpc-c"
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

echo ; }

### 输入自己想要的软件版本 ###
function _inputversion() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the correct version, or the installation will be FAILED${normal}"
read -ep "${bold}${yellow}Input the version you want: ${cyan}" inputversion; echo -n "${normal}" ; }

function _inputversionlt() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the correct version, or the installation will be FAILED${normal}"
echo -e "${red}${bold} Here is a list of all the available versions${normal}\n"
wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | pr -3 -t ; echo
read -ep "${bold}${yellow}Input the version you want: ${cyan}" inputversion; echo -n "${normal}" ; }

### 检查系统是否被支持 ###
function _oscheck() {
if [[ ! "$SysSupport" == 1 ]]; then
    echo -e "\n${bold}${red}Too young too simple! Only Debian 8, Debian 9 and Ubuntu 16.04 is supported by this script${normal}"
    echo -e "${bold}If you want to run this script on unsupported distro, please edit this script to skip system check\nExiting...${normal}\n"
    exit 1
fi ; }

# --------------------------------------------------------------------------------
###   Downloads\ScanDirsV2=@Variant(\0\0\0\x1c\0\0\0\0)
###   ("yakkety"|"xenial"|"wily"|"jessie"|"stretch"|"zesty"|"artful")
# --------------------------------------------------------------------------------





if [[ $DISABLE == 1 ]]; then clear ; echo "
${heibaise}${bold}                                                                   ${normal}
${heibaise}${bold}        :iLKW######Ef:                       ,fDKKEDj;::           ${normal}
${heibaise}${bold}  #KE####j           f######f        tDW###Wf          ,W#######   ${normal}
${heibaise}${bold}  ####j                   t#########EW#f                   #####   ${normal}
${heibaise}${bold}  LW##                      ######KE#W                      ##WK   ${normal}
${heibaise}${bold}    WG                      i###KG###i                      ##     ${normal}
${heibaise}${bold}    WK                      f#t    ;#i                      WE     ${normal}
${heibaise}${bold}    i#                      ##      ##                      #.     ${normal}
${heibaise}${bold}     W                     D#.      :#E                     W      ${normal}
${heibaise}${bold}     KL                   DW;        f#i                   fL      ${normal}
${heibaise}${bold}      W,                 GWi          tW:                  #       ${normal}
${heibaise}${bold}      :KW              ,#W              W#                #,       ${normal}
${heibaise}${bold}         WW#W:     ,K#Kj                  WWD.        ,#Kf         ${normal}
${heibaise}${bold}             .:W#:,                           :ftGWEf;             ${normal}
${heibaise}${bold}                                                                   ${normal}

###################################################################
#                                                                 #
#                       ${green}${bold}TOO YOUNG TOO SIMPLE  ${normal}                    #
#                                                                 #
#                   ${green}${bold}Please read README on GitHub${normal}                  #
#                                                                 #
###################################################################
" ; exit 1 ; fi ; clear





# --------------------- 系统检查 --------------------- #
function _intro() {

# 检查是否以 root 权限运行脚本
if [[ ! $DeBUG == 1 ]]; then if [[ $EUID != 0 ]]; then echo "${title}${bold}Navie! I think this young man will not be able to run this script without root privileges.${normal}" ; exit 1
else echo "${green}${bold}Excited! You're running this script as root. Let's make some big news ... ${normal}" ; fi ; fi

# 检查系统版本；不是 Ubuntu 或 Debian 的就不管了，反正不支持……
SysSupport=0
DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `
CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}'  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep -oE  "[0-9.]+" /etc/issue  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
[[ "$CODENAME" =~ ("xenial"|"jessie"|"stretch") ]] && SysSupport=1
[[ "$CODENAME" =~      ("wheezy"|"trusty")      ]] && SysSupport=2
[[ $DeBUG == 1 ]] && echo "${bold}DISTRO=$DISTRO, CODENAME=$CODENAME, osversion=$osversion, SysSupport=$SysSupport${normal}"

# 如果系统是 Debian 7 或 Ubuntu 14.04，询问是否升级到 Debian 8 / Ubuntu 16.04
[[ $SysSupport == 2 ]] && _ask_distro_upgrade





### if [[ ! $distro_up == Yes ]]; then





# 检查本脚本是否支持当前系统，可以关闭此功能
[[ $SYSTEMCHECK == 1 ]] && [[ ! $distro_up == Yes ]] && _oscheck

# 其实我也不知道 32位 系统行不行…… 也不知道这个能不能判断是不是 ARM
# if [[ ! $lbit = 64 ]]; then
#   echo '${title}${bold}Naive! Only 64bits system is supported${normal}'
#   echo ' Exiting...'
#   exit 1
# fi



# 装 wget 以防万一，不屏蔽错误输出
if [[ ! -n `command -v wget` ]]; then echo "${bold}Now the script is installing ${yellow}wget${jiacu} ...${normal}" ; apt-get install -y wget >> /dev/null ; fi
[[ ! $? -eq 0 ]] && echo -e "${red}${bold}Failed to install wget, please check it and rerun once it is resolved${normal}\n" && kill -s TERM $TOP_PID



  echo "${bold}Checking your server's public IPv4 address ...${normal}"
# serveripv4=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )
  serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}' )
  isInternalIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T7 -qO- ipecho.net/plain )
  isValidIpAddress "$serveripv4" || { echo "${bold}${red}${shanshuo}ERROR ${jiacu}${underline}Failed to detect your public IPv4 address, use internal address instead${normal}" ; serveripv4=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') ; }


  echo "${bold}Checking your server's public IPv6 address ...${normal}"

  serveripv6=$( wget -t1 -T5 -qO- v6.ipv6-test.com/api/myip.php | grep -Eo "[0-9a-z:]+" | head -n1 )
# serveripv6=$( wget --no-check-certificate -qO- -t1 -T8 ipv6.icanhazip.com )

# [ -n "$(grep 'eth0:' /proc/net/dev)" ] && wangka=eth0 || wangka=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet|^he-ipv6|^docker' |awk 'NR==1 {print $0}'`
# wangka=` ifconfig -a | grep -B 1 $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') | head -n1 | awk '{print $1}' | sed "s/:$//"  `
# wangka=`  ip route get 8.8.8.8 | awk '{print $5}'  `
# serverlocalipv6=$( ip addr show dev $wangka | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | head -n1 )


  echo "${bold}Checking your server's specification ...${normal}"


# DISTRO=$(lsb_release -is)
# RELEASE=$(lsb_release -rs)
# CODENAME=$(lsb_release -cs)
# SETNAME=$(lsb_release -rc)
  arch=$( uname -m ) # 架构，可以识别 ARM
  lbit=$( getconf LONG_BIT ) # 只显示多少位，无法识别 ARM
# relno=$(lsb_release -sr | cut -d. -f1)
  kern=$( uname -r )
  kv1=$(uname -r | cut  -d. -f1)
  kv2=$(uname -r | cut  -d. -f2)
  kv3=$(echo $kv1.$kv2)
  kv4=$(uname -r | cut  -d- -f1)
  kv5=$(uname -r | cut  -d- -f2)
  kv6=$(uname -r | cut  -d- -f3)

# Virt-what
  wget --no-check-certificate -qO /usr/local/bin/virt-what https://github.com/Aniverse/inexistence/raw/master/03.Files/app/virt-what
  mkdir -p /usr/lib/virt-what
  wget --no-check-certificate -qO /usr/lib/virt-what/virt-what-cpuid-helper https://github.com/Aniverse/inexistence/raw/master/03.Files/app/virt-what-cpuid-helper
  chmod +x /usr/local/bin/virt-what /usr/lib/virt-what/virt-what-cpuid-helper
  virtua=$(virt-what) 2>/dev/null

  _check_install_2
  _client_version_check

  cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
  cputhreads=$( grep 'processor' /proc/cpuinfo | sort -u | wc -l )
  cpucores_single=$( grep 'core id' /proc/cpuinfo | sort -u | wc -l )
  cpunumbers=$( grep 'physical id' /proc/cpuinfo | sort -u | wc -l )
  cpucores=$( expr $cpucores_single \* $cpunumbers )
  [[ $cpunumbers == 2 ]] && CPUNum='Dual ' ; [[ $cpunumbers == 4 ]] && CPUNum='Quad ' ; [[ $cpunumbers == 8 ]] && CPUNum='Octa '

  disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
  disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
  disk_total_size=$( calc_disk ${disk_size1[@]} )
  disk_used_size=$( calc_disk ${disk_size2[@]} )
  freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
  tram=$( free -m | awk '/Mem/ {print $2}' )
  uram=$( free -m | awk '/Mem/ {print $3}' )

  QB_repo_ver=` apt-cache policy qbittorrent-nox | grep -B1 http | grep -Eo "[234]\.[0-9.]+\.[0-9.]+" | head -n1 `
  QB_latest_ver=` wget -qO- https://github.com/qbittorrent/qBittorrent/releases | grep releases/tag | grep -Eo "[45]\.[0-9.]+" | head -n1 `
# QB_latest_ver=4.0.4
  DE_repo_ver=` apt-cache policy deluged | grep -B1 http | grep -Eo "[12]\.[0-9.]+\.[0-9.]+" | head -n1 `
# DE_github_latest_ver=` wget -qO- https://github.com/deluge-torrent/deluge/releases | grep releases/tag | grep -Eo "[12]\.[0-9.]+.*" | sed 's/\">//' | head -n1 `
  DE_latest_ver=` wget -qO- https://dev.deluge-torrent.org/wiki/ReleaseNotes | grep wiki/ReleaseNotes | grep -Eo "[12]\.[0-9.]+" | sed 's/">/ /' | awk '{print $1}' | head -n1 `
# DE_latest_ver=1.3.15
  PYLT_repo_ver=` apt-cache policy python-libtorrent | grep -B1 http | grep -Eo "[012]\.[0-9.]+\.[0-9.]+" | head -n1 `
# DELT_PPA_ver=1.0.11

  DELT_PPA_ver=` wget -qO- https://launchpad.net/~deluge-team/+archive/ubuntu/ppa | grep -B1 xenial | grep -Eo "[012]\.[0-9.]+\.[0-9.]+" | tail -n1 `

  TR_repo_ver=` apt-cache policy transmission-daemon | grep -B1 http | grep -Eo "[23]\.[0-9.]+" | head -n1 `
  TR_latest_ver=` wget -qO- https://github.com/transmission/transmission/releases | grep releases/tag | grep -Eo "[23]\.[0-9.]+" | head -n1 `
# TR_latest_ver=2.93

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

  echo "  CPU     : ${cyan}$CPUNum$cname${normal}"
  echo "  Cores   : ${cyan}${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
  echo "  Mem     : ${cyan}$tram MB ($uram MB Used)${normal}"
  echo "  Disk    : ${cyan}$disk_total_size GB ($disk_used_size GB Used)${normal}"
  echo "  OS      : ${cyan}$DISTRO $osversion $CODENAME ($arch) ${normal}"
  echo "  Kernel  : ${cyan}$kern${normal}"
  echo "  Script  : ${cyan}$INEXISTENCEDATE${normal}"

  echo -ne "  Virt    : "
  if [[ "${virtua}" ]]; then
      echo "${cyan}$virtua${normal}"
  else
      echo "${cyan}No Virtualization Detected${normal}"
  fi

[[ ! $SYSTEMCHECK == 1 ]] && echo -e "\n${bold}${red}System Checking Skipped. Note that this script may not work on unsupported system${normal}"

echo
echo -e "${bold}For more information about this script, please refer the README on GitHub"
echo -e "Press ${on_red}Ctrl+C${normal} ${bold}to exit${jiacu}, or press ${bailvse}ENTER${normal} ${bold}to continue" ; [[ ! $ForceYes == 1 ]] && read input


### fi


}






# --------------------- 询问是否升级系统 --------------------- #

function _ask_distro_upgrade() {

[[ $CODENAME == wheezy ]] && UPGRADE_DISTRO="Debian 8"     && echo -e "\nYou are now running ${cyan}${bold}Debian 7${normal}, which is not supported by this script"
[[ $CODENAME == trusty ]] && UPGRADE_DISTRO="Ubuntu 16.04" && echo -e "\nYou are now running ${cyan}${bold}Ubuntu 14.04${normal}, which is not supported by this script"
# read -ep "${bold}${yellow}Would you like to upgrade your system to ${UPGRADE_DISTRO}?${normal} [${cyan}Y${normal}]es or [N]o: " responce
echo -ne "${bold}${yellow}Would you like to upgrade your system to ${UPGRADE_DISTRO}? ${normal}[${cyan}Y${normal}]es or [N]o: " ; read -e responce

case $responce in
    [yY] | [yY][Ee][Ss] | "" ) distro_up=Yes ;;
    [nN] | [nN][Oo]          ) distro_up=No  ;;
    *                        ) distro_up=Yes ;;
esac

if [[ $distro_up == Yes ]]; then
    echo -e "\n${bold}${baiqingse}Your system will be upgraded to ${baizise}${UPGRADE_DISTRO}${baiqingse} after reboot${normal}"
    _distro_upgrade | tee /etc/00.distro_upgrade.log
else
    echo -e "\n${baizise}Your system will ${baihongse}not${baizise} be upgraded${normal}"
fi

echo ; }






# --------------------- 录入账号密码部分 --------------------- #

# 向用户确认信息，Yes or No

function _confirmation(){
local answer
while true ; do
    read answer
    case $answer in [yY] | [yY][Ee][Ss] | "" ) return 0 ;;
                    [nN] | [nN][Oo] ) return 1 ;;
                    * ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
    esac
done ; }


# 生成随机密码，genln=密码长度

function genpasswd() { local genln=$1 ; [ -z "$genln" ] && genln=12 ; tr -dc A-Za-z0-9 < /dev/urandom | head -c ${genln} | xargs ; }


# 询问用户名。检查用户名是否有效的功能以后再做

function _askusername(){ clear

if [[ $ANUSER = "" ]]; then

    echo "${bold}${yellow}The script needs a username${jiacu}"
    echo "This will be your primary user. It can be an existing user or a new user ${normal}"

    confirm_name=1
    while [[ $confirm_name = 1 ]]; do

        while [[ $answerusername = "" ]] || [[ $reinput_name = 1 ]]; do
            reinput_name=0
            read -ep "${bold}Enter username: ${blue}" answerusername
        done

        addname="${answerusername}"
        echo -n "${normal}${bold}Confirm that username is ${blue}${answerusername}${normal}, ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o? "

        read  answer
        case $answer in [yY] | [yY][Ee][Ss] | "" ) confirm_name=0 ;;
                        [nN] | [nN][Oo] ) reinput_name=1 ;;
                        * ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
        esac

        ANUSER=$addname

    done

    echo

else

    echo -e "${bold}Username sets to ${blue}$ANUSER${normal}\n"

fi ; }





# 询问密码。检查密码是否足够复杂的功能以后再做（需要满足 Flexget WebUI 密码复杂度的要求）

function _askpassword() {

#local exitvalue=0
local password1
local password2

exec 3>&1 >/dev/tty

if [[ $ANPASS = "" ]]; then

    echo "${bold}${yellow}The script needs a password, it will be used for Unix and WebUI${jiacu} "
    echo "The password must consist of characters and numbers and at least 8 chars,"
    echo "or you can leave it blank to generate a random password"

    while [ -z $localpass ]; do

      # echo -n "${bold}Enter the password: ${blue}" ; read -e password1
        read -ep "${jiacu}Enter the password: ${blue}" password1

        if [ -z $password1 ]; then

          # exitvalue=1
            localpass=$(genpasswd)
            echo "${jiacu}Random password sets to ${blue}$localpass${normal}"

        elif [ ${#password1} -lt 8 ]; then

            echo "${bold}${red}ERROR${normal} ${bold}Password needs to be at least ${red}[8]${jiacu} chars long${normal}" && continue

        else

            while [[ $password2 = "" ]]; do
                read -ep "${jiacu}Enter the new password again: ${blue}" password2
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
  # return $exitvalue

else

    echo -e "${bold}Password sets to ${blue}$ANPASS${normal}\n"

fi ; }





# --------------------- 询问安装前是否需要更换软件源 --------------------- #

function _askaptsource() {

while [[ $aptsources = "" ]]; do

#   read -ep "${bold}${yellow}Would you like to change sources list ?${normal} [${cyan}Y${normal}]es or [N]o: " responce
    echo -ne "${bold}${yellow}Would you like to change sources list ?${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) aptsources=Yes ;;
        [nN] | [nN][Oo]) aptsources=No ;;
        *) aptsources=Yes ;;
    esac

done

if [[ $aptsources == Yes ]]; then
    echo "${bold}${baiqingse}/etc/apt/sources.list${normal} ${bold}will be replaced${normal}"
else
    echo "${baizise}/etc/apt/sources.list will ${baihongse}not${baizise} be replaced${normal}"
fi

echo ; }





# --------------------- 询问编译安装时需要使用的线程数量 --------------------- #

function _askmt() {

while [[ $MAXCPUS = "" ]]; do

    echo -e "${green}01)${normal} Use ${cyan}all${normal} available threads (Default)"
    echo -e "${green}02)${normal} Use ${cyan}half${normal} of available threads"
    echo -e "${green}03)${normal} Use ${cyan}one${normal} thread"
    echo -e "${green}04)${normal} Use ${cyan}two${normal} threads"
#   echo -e   "${red}99)${normal} Do not compile, install softwares from repo"

#   echo -e  "${bold}${red}Note that${normal} ${bold}using more than one thread to compile may cause failure in some cases${normal}"
#   read -ep "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " version
    echo -ne "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " ; read -e responce

    case $responce in
        01 | 1 | "") MAXCPUS=$(nproc) ;;
        02 | 2) MAXCPUS=$(echo "$(nproc) / 2"|bc) ;;
        03 | 3) MAXCPUS=1 ;;
        04 | 4) MAXCPUS=2 ;;
        05 | 5) MAXCPUS=No ;;
        *) MAXCPUS=$(nproc) ;;
    esac

done

if [[ $MAXCPUS == No ]]; then
    echo -e "${bold}${baiqingse}Deluge/qBittorrent/Transmission will be installed from repo${normal}"
else
    echo -e "${bold}${baiqingse}[${MAXCPUS}]${normal} ${bold}thread(s) will be used when compiling${normal}"
fi

echo ; }






# --------------------- 询问是否使用 swap --------------------- #

function _askswap() {

if [[ $USESWAP = "" ]] && [[ $tram -le 1926 ]]; then

    echo -e  "${bold}${red}Note that${normal} ${bold}Your RAM is below ${red}1926MB${jiacu}, memory may got exhausted when compiling${normal}"
#   read -ep "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " version
    echo -ne "${bold}${yellow}Would you like to use swap when compiling?${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss] | "") USESWAP=Yes ;;
        [nN] | [nN][Oo]         ) USESWAP=No  ;;
        *                       ) USESWAP=Yes ;;
    esac

    if [[ $USESWAP == Yes ]]; then
        echo -e "${bold}${baiqingse} 1GB Swap ${normal} will be used"
    else
        echo -e "${bold}Swap will not be used${normal}"
    fi

echo

fi ; }






# --------------------- 询问需要安装的 qBittorrent 的版本 --------------------- #
# wget -qO- "https://github.com/qbittorrent/qBittorrent" | grep "data-name" | cut -d '"' -f2 | pr -4 -t ; echo

function _askqbt() {

while [[ $QBVERSION = "" ]]; do

    echo -e "${green}01)${normal} qBittorrent ${cyan}3.3.7${normal}"
    echo -e "${green}02)${normal} qBittorrent ${cyan}3.3.11${normal}"
    echo -e "${green}03)${normal} qBittorrent ${cyan}3.3.14${normal}"
    echo -e "${green}04)${normal} qBittorrent ${cyan}3.3.16${normal}"
    [[ ! $CODENAME = jessie ]] &&
    echo -e "${green}11)${normal} qBittorrent ${cyan}4.0.2${normal}" && 
    echo -e "${green}12)${normal} qBittorrent ${cyan}4.0.3${normal}" && 
    echo -e "${green}13)${normal} qBittorrent ${cyan}4.0.4${normal}"
    echo -e "${green}30)${normal} Select another version"
    echo -e "${green}40)${normal} qBittorrent ${cyan}$QB_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} qBittorrent ${cyan}$QB_latest_ver${normal} from ${cyan}Stable PPA${normal}"
    echo -e   "${red}99)${normal} Do not install qBittorrent"

    [[ $qb_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}qBittorrent ${qbtnox_ver}${normal}"

   #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}02${normal}): " version
    echo -ne "${bold}${yellow}Which version of qBittorrent do you want?${normal} (Default ${cyan}02${normal}): " ; read -e version

    case $version in
        01 | 1) QBVERSION=3.3.7 ;;
        02 | 2) QBVERSION=3.3.11 ;;
        03 | 3) QBVERSION=3.3.14 ;;
        04 | 4) QBVERSION=3.3.16 ;;
        11) QBVERSION=4.0.2 ;;
        12) QBVERSION=4.0.3 ;;
        13) QBVERSION=4.0.4 ;;
        21) QBVERSION='3.3.11 (Skip hash check)' && QBPATCH=Yes ;;
        30) _inputversion && QBVERSION="${inputversion}"  ;;
        40) QBVERSION='Install from repo' ;;
        50) QBVERSION='Install from PPA' ;;
        99) QBVERSION=No ;;
        * | "") QBVERSION=3.3.11 ;;
    esac

done


if [[ `echo $QBVERSION | cut -c1` == 4 ]]; then
    QBVERSION4=Yes
else
    QBVERSION4=No
fi


if [[ $QBVERSION == No ]]; then

    echo "${baizise}qBittorrent will ${baihongse}not${baizise} be installed${normal}"

elif [[ $QBVERSION == "Install from repo" ]]; then

    sleep 0

elif [[ $QBVERSION == "Install from PPA" ]]; then

    if [[ $DISTRO == Debian ]]; then
        echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
        echo -ne "Therefore "
        QBVERSION='Install from repo'
    else
        echo "${bold}${baiqingse}qBittorrent $QB_latest_ver${normal} ${bold}will be installed from Stable PPA${normal}"
    fi

else

    if [[ $CODENAME == jessie ]] && [[ $QBVERSION4 == Yes ]]; then
        echo -e "${bold}${red}ERROR${normal} ${bold}Since qBittorrent 4.0 needs qmake 5.5.1,\nBuilding qBittorrent 4 doesn't work on ${cyan}Debian 8 by normal method${normal}"
        QBVERSION=3.3.16 && QBVERSION4=No
        echo "${bold}The script will use qBittorrent ${QBVERSION} instead"
    fi

    echo "${bold}${baiqingse}qBittorrent ${QBVERSION}${normal} ${bold}will be installed${normal}"

fi

if [[ $QBVERSION == "Install from repo" ]]; then

    echo "${bold}${baiqingse}qBittorrent $QB_repo_ver${normal} ${bold}will be installed from repository${normal}"

fi

echo ; }




# --------------------- 询问需要安装的 Deluge 版本 --------------------- #
# wget -qO- "http://download.deluge-torrent.org/source/" | grep -Eo "1\.3\.[0-9]+" | sort -u | pr -6 -t ; echo

function _askdeluge() {

while [[ $DEVERSION = "" ]]; do

    echo -e "${green}01)${normal} Deluge ${cyan}1.3.11${normal}"
    echo -e "${green}02)${normal} Deluge ${cyan}1.3.12${normal}"
    echo -e "${green}03)${normal} Deluge ${cyan}1.3.13${normal}"
    echo -e "${green}04)${normal} Deluge ${cyan}1.3.14${normal}"
    echo -e "${green}05)${normal} Deluge ${cyan}1.3.15${normal}"
#   echo -e "${green}21)${normal} Deluge ${cyan}1.3.15 (Skip hash check)${normal}"
    echo -e "${green}30)${normal} Select another version"
    echo -e "${green}40)${normal} Deluge ${cyan}$DE_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} Deluge ${cyan}$DE_latest_ver${normal} from ${cyan}PPA${normal}"
    echo -e   "${red}99)${normal} Do not install Deluge"

    [[ $de_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}Deluge ${deluged_ver}${reset_underline}${normal}"

    [[ $DISTRO == Ubuntu ]] && dedefaultnum=50 ; [[ $DISTRO == Debian ]] && dedefaultnum=05
   #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}${dedefaultnum}${normal}): " version

    echo -ne "${bold}${yellow}Which version of Deluge do you want?${normal} (Default ${cyan}${dedefaultnum}${normal}): " ; read -e version

    if [[ $DISTRO == Ubuntu ]]; then

        case $version in
            01 | 1) DEVERSION=1.3.11 ;;
            02 | 2) DEVERSION=1.3.12 ;;
            03 | 3) DEVERSION=1.3.13 ;;
            04 | 4) DEVERSION=1.3.14 ;;
            05 | 5) DEVERSION=1.3.15 ;;
            11) DEVERSION=1.3.5 ;;
            12) DEVERSION=1.3.6 ;;
            13) DEVERSION=1.3.7 ;;
            14) DEVERSION=1.3.8 ;;
            15) DEVERSION=1.3.9 ;;
            21) DEVERSION='1.3.15 Skip hash check' && DESKIP=Yes ;;
            30) _inputversion && DEVERSION="${inputversion}"  ;;
            40) DEVERSION='Install from repo' ;;
            50) DEVERSION='Install from PPA' ;;
            99) DEVERSION=No ;;
            * | "") DEVERSION='Install from PPA' ;;
        esac

    elif [[ $DISTRO == Debian ]]; then

        case $version in
            01 | 1) DEVERSION=1.3.11 ;;
            02 | 2) DEVERSION=1.3.12 ;;
            03 | 3) DEVERSION=1.3.13 ;;
            04 | 4) DEVERSION=1.3.14 ;;
            05 | 5) DEVERSION=1.3.15 ;;
            11) DEVERSION=1.3.5 ;;
            12) DEVERSION=1.3.6 ;;
            13) DEVERSION=1.3.7 ;;
            14) DEVERSION=1.3.8 ;;
            15) DEVERSION=1.3.9 ;;
            21) DEVERSION='1.3.15 (Skip hash check)' && DESKIP=Yes ;;
            30) _inputversion && DEVERSION="${inputversion}"  ;;
            40) DEVERSION='Install from repo' ;;
            50) DEVERSION='Install from PPA' ;;
            99) DEVERSION=No ;;
            * | "") DEVERSION=1.3.15 ;;
        esac

    fi

done


[[ `echo $DEVERSION | cut -c5` -lt 11 ]] && DESSL=Yes


  if [[ $DEVERSION == No ]]; then

      echo "${baizise}Deluge will ${baihongse}not${baizise} be installed${normal}"
      DELTVERSION=NoDeluge

  elif [[ $DEVERSION == "Install from repo" ]]; then 

      sleep 0

  elif [[ $DEVERSION == "Install from PPA" ]]; then

      if [[ $DISTRO == Debian ]]; then
          echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
          echo -ne "Therefore "
          DEVERSION='Install from repo'
      else
          echo "${bold}${baiqingse}Deluge $DE_latest_ver${normal} ${bold}will be installed from PPA${normal}"
      fi

  else

      echo "${bold}${baiqingse}Deluge ${DEVERSION}${normal} ${bold}will be installed${normal}"

  fi


  if [[ $DEVERSION == "Install from repo" ]]; then 

      echo "${bold}${baiqingse}Deluge $DE_repo_ver${normal} ${bold}will be installed from repository${normal}"

  fi

  echo ; }





# --------------------- 询问需要安装的 Deluge libtorrent 版本 --------------------- #
# DELTVERSION=$(  wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_1_" | sort -t _ -n -k 3 | tail -n1  )

function _askdelt() {

while [[ $DELTVERSION = "" ]]; do

    if [[ $DEVERSION == "Install from repo" ]]; then

        DELTVERSION='Install from repo' && DeLTDefault=1

    elif [[ $DEVERSION == "Install from PPA" ]]; then

        DELTVERSION='Install from PPA' && DeLTDefault=1

    else

      # echo -e "${green}00)${normal} libtorrent-rasterbar ${cyan}0.16.19${normal} (NOT recommended)"
        echo -e "${green}01)${normal} libtorrent-rasterbar ${cyan}1.0.11${normal}"
        echo -e "${green}02)${normal} libtorrent-rasterbar ${cyan}1.1.6 ${normal} (NOT recommended)"
        echo -e "${green}30)${normal} Select another version"
        echo -e "${green}40)${normal} libtorrent-rasterbar ${cyan}$PYLT_repo_ver${normal} from ${cyan}repo${normal}"
        [[ $DISTRO == Ubuntu ]] &&
        echo -e "${green}50)${normal} libtorrent-rasterbar ${cyan}$DELT_PPA_ver${normal} from ${cyan}Deluge PPA${normal}"
        [[ $de_installed == Yes ]] &&
        echo -e "${red}99)${normal} Do not install libtorrent-rasterbar AGAIN"

        [[ $delugelt_ver ]] &&
        echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}libtorrent-rasterbar ${delugelt_ver}${reset_underline}${normal}"

        echo "${shanshuo}${baihongse}${bold} ATTENTION ${normal} ${blue}${bold}USE THE ${heihuangse}DEFAULT${normal}${blue}${bold} OPINION UNLESS YOU KNOW WHAT'S THIS${normal}"
      # echo -e "${bailanse}${bold} 注意！ ${normal} ${blue}${bold}如果你不知道这是什么玩意儿，请使用默认选项${normal}"


        if [[ $CODENAME == stretch ]]; then

          # read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}01${normal}): " version
            echo -ne "${bold}${yellow}Which version of libtorrent do you want to be used for Deluge?${normal} (Default ${cyan}01${normal}): " ; read -e version

            case $version in
                  00 | 0) DELTVERSION=libtorrent-0_16_19 ;;
                  01 | 1) DELTVERSION=libtorrent-1_0_11 && DeLTDefault=1 ;;
                  02 | 2) DELTVERSION=libtorrent-1_1_6 ;;
                  30) _inputversionlt && DELTVERSION="${inputversion}" ;;
                  40) DELTVERSION='Install from repo' ;;
                  50) DELTVERSION='Install from PPA' ;;
                  99) DELTVERSION=No ;;
                  "" | *) DELTVERSION=libtorrent-1_0_11 && DeLTDefault=1 ;;
            esac

        else

           #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}40${normal}): " version
            echo -ne "${bold}${yellow}Which version of libtorrent do you want to be used for Deluge?${normal} (Default ${cyan}40${normal}): " ; read -e version

            case $version in
                  00 | 0) DELTVERSION=libtorrent-0_16_19 ;;
                  01 | 1) DELTVERSION=libtorrent-1_0_11 ;;
                  02 | 2) DELTVERSION=libtorrent-1_1_6 ;;
                  30) _inputversionlt && DELTVERSION="${inputversion}" ;;
                  40 | "") DELTVERSION='Install from repo' && DeLTDefault=1 ;;
                  50) DELTVERSION='Install from PPA' ;;
                  99) DELTVERSION=No ;;
                  *) DELTVERSION='Install from repo' && DeLTDefault=1 ;;
            esac

        fi

    fi

    if [[ ! $DeLTDefault == 1 ]]; then

        echo -e  "\n${bailanse}${bold} 注意！${normal} ${blue}${bold}不要老是想着搞个大新闻，不用默认选项很可能引发 bug！"
        echo -e  "只有某些特殊情况下才需要选择非默认选项，比如之前已经安装过了\n不然我都想把这个极容易导致翻车的选项直接去除改成强制选择默认的了 ……"
        echo -ne "${yellow}即使如此你还是要选 ${blue}$DELTVERSION${jiacu} 这个选项么？${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e confirm

        case $confirm in
              [yY] | [yY][Ee][Ss]  ) Zuosi=Yes && echo -e "\n${bold}作死成功，翻车了别来汇报 bug，这个本来就是这样的 (╯‵□′)╯︵┻━┻ ${normal}\n" ;;
              [nN] | [nN][Oo] | "" ) Zuosi=No  && echo -e "\n${bold}那我再问你一次，这次你自己看着办吧${normal}\n" && unset DELTVERSION ;;
              *) Zuosi=No && unset DELTVERSION && echo -e "\n${bold}那我还是再问你一遍吧，这次你自己看着办${normal}\n" ;;
        esac

    fi

done


DELTPKG=`  echo "$DELTVERSION" | sed "s/_/\./g" | sed "s/libtorrent-//"  `


    if [[ $DELTVERSION == "Install from repo" ]]; then

       echo "${bold}${baiqingse}libtorrent-rasterbar $PYLT_repo_ver${normal} ${bold}will be installed from repository${normal}"

    elif [[ $DELTVERSION == "Install from PPA" ]]; then

        echo "${baiqingse}${bold}libtorrent-rasterbar 1.0.11${normal} ${bold}will be installed from Deluge PPA${normal}"

    elif [[ $DELTVERSION == No ]]; then

        echo "${baiqingse}${bold}libtorrent-rasterbar ${delugelt_ver}${normal}${bold} will be used from system${normal}"

    else

        echo "${baiqingse}${bold}libtorrent-rasterbar ${DELTPKG}${normal} ${bold}will be installed${normal}"

    fi

echo ; }





# --------------------- 询问需要安装的 rTorrent 版本 --------------------- #

function _askrt() {

while [[ $RTVERSION = "" ]]; do

    [[ ! $CODENAME == stretch ]] &&
    echo -e "${green}01)${normal} rTorrent ${cyan}0.9.2${normal}" &&
    echo -e "${green}02)${normal} rTorrent ${cyan}0.9.3${normal}" &&
    echo -e "${green}03)${normal} rTorrent ${cyan}0.9.4${normal}" &&
    echo -e "${green}04)${normal} rTorrent ${cyan}0.9.6${normal}" &&
    echo -e "${green}11)${normal} rTorrent ${cyan}0.9.2${normal} (with IPv6 support)" &&
    echo -e "${green}12)${normal} rTorrent ${cyan}0.9.3${normal} (with IPv6 support)" &&
    echo -e "${green}13)${normal} rTorrent ${cyan}0.9.4${normal} (with IPv6 support)"
    echo -e "${green}14)${normal} rTorrent ${cyan}0.9.6${normal} (with IPv6 support)"
    echo -e   "${red}99)${normal} Do not install rTorrent"

    [[ $rt_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}rTorrent ${rtorrent_ver}${normal}"
#   [[ $rt_installed == Yes ]] && echo -e "${bold}If you want to downgrade or upgrade rTorrent, use ${blue}rtupdate${normal}"
  
    if [[ $CODENAME == stretch ]]; then

        echo "${bold}${red}Note that${normal} ${bold}${green}Debian 9${normal} ${bold}is only supported by ${green}rTorrent 0.9.6${normal}"
       #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}04${normal}): " version
        echo -ne "${bold}${yellow}Which version of rTorrent do you want?${normal} (Default ${cyan}14${normal}): " ; read -e version

        case $version in
            14) RTVERSION='0.9.4 IPv6 supported' ;;
            99) RTVERSION=No ;;
            "" | *) RTVERSION='0.9.4 IPv6 supported' ;;
        esac

    else

       #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}02${normal}): " version
        echo -ne "${bold}${yellow}Which version of rTorrent do you want?${normal} (Default ${cyan}03${normal}): " ; read -e version

        case $version in
            01 | 1) RTVERSION=0.9.2 ;;
            02 | 2) RTVERSION=0.9.3 ;;
            03 | 3) RTVERSION=0.9.4 ;;
            04 | 4) RTVERSION=0.9.6 ;;
            11) RTVERSION='0.9.2 IPv6 supported' ;;
            12) RTVERSION='0.9.3 IPv6 supported' ;;
            13) RTVERSION='0.9.4 IPv6 supported' ;;
            14) RTVERSION='0.9.6 IPv6 supported' ;;
            99) RTVERSION=No ;;
            "" | *) RTVERSION=0.9.4 ;;
        esac

    fi

done

[[ $IPv6Opt == -i ]] && RTVERSION=`echo $RTVERSION IPv6 supported`
[[ `echo $RTVERSION | grep IPv6` ]] && IPv6Opt=-i
RTVERSIONIns=`echo $RTVERSION | grep -Eo [0-9].[0-9].[0-9]`

if [[ $RTVERSION == No ]]; then

    echo "${baizise}rTorrent will ${baihongse}not${baizise} be installed${normal}"
    InsFlood='No rTorrent'

else

    if [[ `echo $RTVERSION | grep IPv6 | grep -Eo 0.9.[234]` ]]; then

        echo "${bold}${baiqingse}rTorrent $RTVERSIONIns (with UNOFFICAL IPv6 support)${normal} ${bold}will be installed${normal}"

    elif [[ $RTVERSION == '0.9.4 IPv6 supported' ]]; then

        echo "${bold}${baiqingse}rTorrent 0.9.6 (feature-bind branch)${normal} ${bold}will be installed${normal}"

    else

        echo "${bold}${baiqingse}rTorrent ${RTVERSION}${normal} ${bold}will be installed${normal}"

    fi


#   echo "${bold}${baiqingse}ruTorrent, vsftpd, h5ai, autodl-irssi${normal} ${bold}will also be installed${normal}"

fi

echo ; }






# --------------------- 询问是否安装 flood --------------------- #

function _askflood() {

while [[ $InsFlood = "" ]]; do

#   read -ep "${bold}${yellow}Would you like to install flood? ${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}Would you like to install flood? ${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsFlood=Yes ;;
        [nN] | [nN][Oo] | "" ) InsFlood=No  ;;
        *) InsFlood=No ;;
    esac

done

if [[ $InsFlood == Yes ]]; then
    echo "${bold}${baiqingse}Flood${normal} ${bold}will be installed${normal}"
else
    echo "${baizise}Flood will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }






# --------------------- 询问需要安装的 Transmission 版本 --------------------- #
# wget -qO- "https://github.com/transmission/transmission" | grep "data-name" | cut -d '"' -f2 | pr -3 -t ; echo

function _asktr() {

while [[ $TRVERSION = "" ]]; do

    echo -e "${green}01)${normal} Transmission ${cyan}2.77${normal}"
    echo -e "${green}02)${normal} Transmission ${cyan}2.82${normal}"
    echo -e "${green}03)${normal} Transmission ${cyan}2.84${normal}"
    echo -e "${green}04)${normal} Transmission ${cyan}2.92${normal}"
    echo -e "${green}05)${normal} Transmission ${cyan}2.93${normal}"
    echo -e "${green}30)${normal} Select another version"
    echo -e "${green}40)${normal} Transmission ${cyan}$TR_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} Transmission ${cyan}$TR_latest_ver${normal} from ${cyan}PPA${normal}"
    echo -e   "${red}99)${normal} Do not install Transmission"

    [[ $tr_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}Transmission ${trd_ver}${normal}"

   #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}40${normal}): " version
    echo -ne "${bold}${yellow}Which version of Transmission do you want?${normal} (Default ${cyan}40${normal}): " ; read -e version

    case $version in
            01 | 1) TRVERSION=2.77 ;;
            02 | 2) TRVERSION=2.82 ;;
            03 | 3) TRVERSION=2.84 ;;
            04 | 4) TRVERSION=2.92 ;;
            05 | 5) TRVERSION=2.93 ;;
            11) TRVERSION=2.92 && TRdefault=No ;;
            12) TRVERSION=2.93 && TRdefault=No ;;
            30) _inputversion && TRVERSION="${inputversion}" ;;
            31) _inputversion && TRVERSION="${inputversion}" && TRdefault=No ;;
            40) TRVERSION='Install from repo' ;;
            50) TRVERSION='Install from PPA' ;;
            99) TRVERSION=No ;;
            "" | *) TRVERSION='Install from repo';;
    esac

done


if [[ $TRVERSION == No ]]; then

    echo "${baizise}Transmission will ${baihongse}not${baizise} be installed${normal}"

else

    if [[ $TRVERSION == "Install from repo" ]]; then 

        sleep 0

    elif [[ $TRVERSION == "Install from PPA" ]]; then

        if [[ $DISTRO == Debian ]]; then

          echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
          echo -ne "Therefore "
          TRVERSION='Install from repo'

        else

          echo "${bold}${baiqingse}Transmission $TR_latest_ver ${normal} ${bold}will be installed from PPA${normal}"

        fi

    else

        echo "${bold}${baiqingse}Transmission ${TRVERSION}${normal} ${bold}will be installed${normal}"

    fi


    if [[ $TRVERSION == "Install from repo" ]]; then 

        echo "${bold}${baiqingse}Transmission $TR_repo_ver${normal} ${bold}will be installed from repository${normal}"

    fi

fi

echo ; }






# --------------------- 询问是否需要安装 Flexget --------------------- #

function _askflex() {

while [[ $InsFlex = "" ]]; do

    [[ $flex_installed == Yes ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed flexget${normal}"
#   read -ep "${bold}${yellow}Would you like to install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}Would you like to install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsFlex=Yes ;;
        [nN] | [nN][Oo] | "" ) InsFlex=No ;;
        *) InsFlex=No ;;
    esac

done

if [ $InsFlex == Yes ]; then
    echo -e "${bold}${baiqingse}Flexget${normal} ${bold}will be installed${normal}\n"
else
    echo -e "${baizise}Flexget will ${baihongse}not${baizise} be installed${normal}\n"
fi ; }





# --------------------- 询问是否需要安装 rclone --------------------- #

function _askrclone() {

while [[ $InsRclone = "" ]]; do

    [[ $rclone_installed == Yes ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed rclone${normal}"
#   read -ep "${bold}${yellow}Would you like to install rclone?${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}Would you like to install rclone?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsRclone=Yes ;;
        [nN] | [nN][Oo] | "" ) InsRclone=No  ;;
        *) InsRclone=No ;;
    esac

done

if [[ $InsRclone == Yes ]]; then
    echo -e "${bold}${baiqingse}rclone${normal} ${bold}will be installed${normal}\n"
else
    echo -e "${baizise}rclone will ${baihongse}not${baizise} be installed${normal}\n"
fi ; }





# --------------------- 询问是否需要安装 远程桌面 --------------------- #

function _askrdp() {

while [[ $InsRDP = "" ]]; do

    echo -e "${green}01)${normal} VNC  with xfce4 (may have some issues)"
    echo -e "${green}02)${normal} X2Go with xfce4"
    echo -e   "${red}99)${normal} Do not install remote desktop"
#   echo -e "目前 VNC 在某些情况下连不上，谷歌找了 N 个小时也没找到解决办法\n因此如果需要的话建议用 X2Go，或者你自己手动安装 VNC 试试？"
#   read -ep "${bold}${yellow}Would you like to install remote desktop?${normal} (Default ${cyan}99${normal}): " responce
    echo -ne "${bold}${yellow}Would you like to install remote desktop?${normal} (Default ${cyan}99${normal}): " ; read -e responce

    case $responce in
        01 | 1) InsRDP=VNC  ;;
        02 | 2) InsRDP=X2Go ;;
        99    ) InsRDP=No   ;;
        "" | *) InsRDP=No   ;;
    esac

done

if [[ $InsRDP == VNC ]]; then
    echo "${bold}${baiqingse}VNC${normal} and ${bold}${baiqingse}xfce4${normal} will be installed"
elif [[ $InsRDP == X2Go ]]; then
    echo "${bold}${baiqingse}X2Go${normal} and ${bold}${baiqingse}xfce4${normal} will be installed"
else
    echo "${baizise}VNC or X2Go will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }




# --------------------- 询问是否安装 wine 和 mono --------------------- #

function _askwine() {

while [[ $InsWine = "" ]]; do

#   read -ep "${bold}${yellow}Would you like to install wine and mono?${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}Would you like to install wine and mono?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsWine=Yes ;;
        [nN] | [nN][Oo] | "" ) InsWine=No  ;;
        *) InsWine=No ;;
    esac

done

if [[ $InsWine == Yes ]]; then
    echo "${bold}${baiqingse}Wine${normal} and ${bold}${baiqingse}mono${normal} ${bold}will be installed${normal}"
else
    echo "${baizise}Wine or mono will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }





# --------------------- 询问是否安装发种工具箱 --------------------- #

function _asktools() {

while [[ $InsTools = "" ]]; do

    echo -e "MKVToolnix, mktorrent, eac3to, mediainfo, ffmpeg ..."
#   read -ep "${bold}${yellow}Would you like to install the above additional softwares?${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}Would you like to install the above additional softwares?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsTools=Yes ;;
        [nN] | [nN][Oo] | "" ) InsTools=No  ;;
       *) InsTools=No ;;
    esac

done

if [[ $InsTools == Yes ]]; then
    echo "${bold}${baiqingse}Latest version of these softwares${normal} ${bold}will be installed${normal}"
else
    echo "${baizise}These softwares will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }





# --------------------- BBR 相关 --------------------- #

# 检查是否已经启用BBR、BBR 魔改版
function check_bbr_status() { bbrstatus=$(sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}') ; if [[ $bbrstatus =~ ("bbr"|"bbr_powered"|"nanqinlang"|"tsunami") ]]; then bbrinuse=Yes ; else bbrinuse=No ; fi ; }

# 检查系统内核版本是否大于4.9
function check_kernel_version() { if [[ $kv1 -ge 4 ]] && [[ $kv2 -ge 9 ]]; then bbrkernel=Yes ; else bbrkernel=No ; fi ; }

# 询问是否安装BBR
function _askbbr() { check_bbr_status

if [[ $bbrinuse == Yes ]]; then

    echo -e "${bold}${yellow}TCP BBR has been installed. Skip ...${normal}"
    InsBBR=Already\ Installed

else

    check_kernel_version

    while [[ $InsBBR = "" ]]; do

        if [[ $bbrkernel == Yes ]]; then

            echo -e "${bold}Your kernel is newer than ${green}4.9${normal}${bold}, but BBR is not enabled${normal}"
            read -ep "${bold}${yellow}Would you like to use BBR? ${normal} [${cyan}Y${normal}]es or [N]o: " responce

            case $responce in
                [yY] | [yY][Ee][Ss] | "" ) InsBBR=To\ be\ enabled ;;
                [nN] | [nN][Oo]          ) InsBBR=No ;;
                *                        ) InsBBR=Yes ;;
            esac

        else

        #   echo -e "${bold}Your kernel is below than ${green}4.9${normal}${bold} while BBR requires at least a ${green}4.9${normal}${bold} kernel"
            echo -e "A new kernel (4.11.12) will be installed if BBR is to be installed"
            echo -e "${red}WARNING${normal} ${bold}Installing new kernel may cause reboot failure in some cases${normal}"
        #   read -ep "${bold}${yellow}Would you like to install BBR? ${normal} [Y]es or [${cyan}N${normal}]o: " responce
            echo -ne "${bold}${yellow}Would you like to install BBR? ${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

            case $responce in
                [yY] | [yY][Ee][Ss]  ) InsBBR=Yes ;;
                [nN] | [nN][Oo] | "" ) InsBBR=No ;;
                *                    ) InsBBR=No ;;
            esac

        fi

    done

    if [[ $InsBBR == Yes ]] || [[ $InsBBR == To\ be\ enabled ]]; then
        echo "${bold}${baiqingse}TCP BBR${normal} ${bold}will be installed${normal}"
    else
        echo "${baizise}TCP BBR will ${baihongse}not${baizise} be installed${normal}"
    fi

fi ; echo ; }





# --------------------- 询问是否需要修改一些设置 --------------------- #

function _asktweaks() {

while [[ $UseTweaks = "" ]]; do

#   read -ep "${bold}${yellow}Would you like to configure some system settings? ${normal} [${cyan}Y${normal}]es or [N]o: " responce
    echo -ne "${bold}${yellow}Would you like to do some system tweaks? ${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) UseTweaks=Yes ;;
        [nN] | [nN][Oo]          ) UseTweaks=No ;;
        *                        ) UseTweaks=Yes ;;
    esac

done

if [[ $UseTweaks == Yes ]]; then
    echo "${bold}${baiqingse}System tweaks${normal} ${bold}will be configured${normal}"
else
    echo "${baizise}System tweaks will ${baihongse}not${baizise} be configured${normal}"
fi

echo ; }






# --------------------- 询问是否重启 --------------------- #

function _askreboot() {
# read -ep "${bold}${yellow}Would you like to reboot the system now? ${normal} [y/${cyan}N${normal}]: " is_reboot
echo -ne "${bold}${yellow}Would you like to reboot the system now? ${normal} [y/${cyan}N${normal}]: "
if [[ $ForceYes == 1 ]];then reboot ; else read -e is_reboot ; fi
if [[ $is_reboot == "y" || $is_reboot == "Y" ]]; then reboot
else echo -e "${bold}Reboot has been canceled...${normal}\n" ; fi ; }





# --------------------- 输出所用时间 --------------------- #

function _time() {
endtime=$(date +%s)
timeused=$(( $endtime - $starttime ))
if [[ $timeused -gt 60 && $timeused -lt 3600 ]]; then
    timeusedmin=$(expr $timeused / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "${baiqingse}${bold}The $timeWORK took about ${timeusedmin} min ${timeusedsec} sec${normal}"
elif [[ $timeused -ge 3600 ]]; then
    timeusedhour=$(expr $timeused / 3600)
    timeusedmin=$(expr $(expr $timeused % 3600) / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "The $timeWORK took about ${timeusedhour} hour ${timeusedmin} min ${timeusedsec} sec${normal}"
else
    echo -e "${baiqingse}${bold}The $timeWORK took about ${timeused} sec${normal}"
fi ; }





# --------------------- 询问是否继续 --------------------- #

function _askcontinue() {

  echo -e "\n${bold}Please check the following information${normal}"
  echo
  echo '####################################################################'
  echo
  echo "                  ${cyan}${bold}Username${normal}      ${bold}${yellow}${ANUSER}${normal}"
  echo "                  ${cyan}${bold}Password${normal}      ${bold}${yellow}${ANPASS}${normal}"
  echo
  echo "                  ${cyan}${bold}qBittorrent${normal}   ${bold}${yellow}${QBVERSION}${normal}"
  echo "                  ${cyan}${bold}Deluge${normal}        ${bold}${yellow}${DEVERSION}${normal}"
  [[ ! $DEVERSION == No ]] &&
  echo "                  ${cyan}${bold}libtorrent${normal}    ${bold}${yellow}${DELTVERSION}${normal}"
  echo "                  ${cyan}${bold}rTorrent${normal}      ${bold}${yellow}${RTVERSION}${normal}"
  [[ ! $RTVERSION == No ]] &&
  echo "                  ${cyan}${bold}Flood${normal}         ${bold}${yellow}${InsFlood}${normal}"
  echo "                  ${cyan}${bold}Transmission${normal}  ${bold}${yellow}${TRVERSION}${normal}"
  echo "                  ${cyan}${bold}RDP${normal}           ${bold}${yellow}${InsRDP}${normal}"
  echo "                  ${cyan}${bold}Wine / mono${normal}   ${bold}${yellow}${InsWine}${normal}"
  echo "                  ${cyan}${bold}UpTools${normal}       ${bold}${yellow}${InsTools}${normal}"
  echo "                  ${cyan}${bold}Flexget${normal}       ${bold}${yellow}${InsFlex}${normal}"
  echo "                  ${cyan}${bold}rclone${normal}        ${bold}${yellow}${InsRclone}${normal}"
  echo "                  ${cyan}${bold}BBR${normal}           ${bold}${yellow}${InsBBR}${normal}"
  echo "                  ${cyan}${bold}System tweak${normal}  ${bold}${yellow}${UseTweaks}${normal}"
  echo "                  ${cyan}${bold}Threads${normal}       ${bold}${yellow}${MAXCPUS}${normal}"
  echo "                  ${cyan}${bold}SourceList${normal}    ${bold}${yellow}${aptsources}${normal}"
  echo
  echo '####################################################################'
  echo
  echo -e "${bold}If you want to stop, Press ${on_red}Ctrl+C${normal} ${bold}; or Press ${on_green}ENTER${normal} ${bold}to start${normal}" ; [[ ! $ForceYes == 1 ]] && read input
  echo -e "\n${bold}${magenta}The selected softwares will be installed, this may take between${normal}"
  echo -e "${bold}${magenta}1 - 100 minutes depending on your systems specs and your selections${normal}\n" ; }





# --------------------- 创建用户、准备工作 --------------------- #

function _setuser() {

rm -rf /etc/inexistence2
[[ -d /etc/inexistence ]] && mv /etc/inexistence /etc/inexistence2
git clone --depth=1 https://github.com/Aniverse/inexistence /etc/inexistence
mkdir -p /etc/inexistence/01.Log/INSTALLATION/packages
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
如果要截图请截完整点，包含下面所有信息
CPU     : $cname"
Cores   : ${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)"
Mem     : $tram MB ($uram MB Used)"
Disk    : $disk_total_size GB ($disk_used_size GB Used)
OS      : $DISTRO $osversion $CODENAME ($arch)
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
FLEXGET=${InsFlex}
RCLONE=${InsRclone}
BBR=${InsBBR}
USETWEAKS=${UseTweaks}
UPLOADTOOLS=${InsTools}
RDP=${InsRDP}
WINE=${InsWine}
FLOOD=${InsFlood}
#################################
EOF

mkdir -p /etc/inexistence/01.Log/lock
touch /etc/inexistence/01.Log/lock/username.$ANUSER.lock

cat>/etc/inexistence/01.Log/lock/inexistence.lock<<EOF
##### Used for future script determination #####
INEXISTENCEinstalled=Yes
INEXISTENCEVER=${INEXISTENCEVER}
INEXISTENCEDATE=${INEXISTENCEDATE}
USETWEAKS=${UseTweaks}
ANUSER=${ANUSER}
##### U ########################################
EOF


# 脚本设置
mkdir -p /etc/inexistence/00.Installation
mkdir -p /etc/inexistence/01.Log
mkdir -p /etc/inexistence/02.Tools/eac3to
mkdir -p /etc/inexistence/03.Files
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

# For Wine DVDFab10
mkdir -p /root/Documents/DVDFab10/BDInfo
ln -s /root/Documents/DVDFab10/BDInfo /etc/inexistence/08.BDinfo/DVDFab

ln -s /etc/inexistence /var/www/inexistence
ln -s /etc/inexistence /home/${ANUSER}/inexistence
cp -f "${local_packages}"/script/* /usr/local/bin ; }





# --------------------- 替换系统源 --------------------- #

function _setsources() {

# rm /var/lib/dpkg/updates/*
# rm -rf /var/lib/apt/lists/partial/*
# apt-get -y upgrade

[[ $USESWAP == Yes ]] && _use_swap

if [[ $aptsources == Yes ]]; then

    if [[ $DISTRO == Debian ]]; then

        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
        wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/debian.apt.sources
        sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
        apt-get --yes --force-yes update

    elif [[ $DISTRO == Ubuntu ]]; then

        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
        wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/ubuntu.apt.sources
        sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
        apt-get -y update

    fi

else

    apt-get -y update

fi

# _checkrepo1 2>&1 | tee /etc/00.checkrepo1.log
# _checkrepo2 2>&1 | tee /etc/00.checkrepo2.log

# dpkg --configure -a
# apt-get -f -y install

apt-get install -y python dstat sysstat vnstat wondershaper lrzsz mtr tree figlet toilet psmisc dirmngr zip unzip locales aptitude ntpdate smartmontools ruby screen git sudo zsh virt-what lsb-release curl checkinstall ca-certificates apt-transport-https iperf3 uuid gcc make gawk build-essential rsync

if [ ! $? = 0 ]; then
    echo -e "\n${baihongse}${shanshuo}${bold} ERROR ${normal} ${red}${bold}Failed to install packages, please check it and rerun once it is resolved${normal}\n"
    kill -s TERM $TOP_PID
fi

echo -e "${bailvse}\n\n\n  STEP-ONE-COMPLETED  \n\n${normal}"

# apt-get remove --purge -y libgnutls-deb0-28

sed -i "s/TRANSLATE=1/TRANSLATE=0/g" /etc/checkinstallrc >/dev/null 2>&1
# sed -i "s/ACCEPT_DEFAULT=0/ACCEPT_DEFAULT=1/g" /etc/checkinstallrc

}





# --------------------- 升级系统 --------------------- #
# https://serverfault.com/questions/48724/100-non-interactive-debian-dist-upgrade

function _distro_upgrade() {

starttime=$(date +%s)

echo -e "${baihongse}executing apt-listchanges remove${normal}\n"
apt-get remove apt-listchanges --assume-yes --force-yes

echo 'libc6 libraries/restart-without-asking boolean true' | debconf-set-selections

echo -e "${baihongse}executing apt sources change${normal}\n"
[[ $CODENAME == wheezy ]] && sed -i "s/wheezy/jessie/g" /etc/apt/sources.list
[[ $CODENAME == trusty ]] && sed -i "s/trusty/xenial/g" /etc/apt/sources.list

echo -e "${baihongse}executing autoremove${normal}\n" ; apt-get -fuy --force-yes autoremove

echo -e "${baihongse}executing clean${normal}\n" ; apt-get --force-yes clean

echo -e "${baihongse}executing update${normal}\n" ; apt-get update

echo -e "\n\n\n${baihongse}executing upgrade${normal}\n\n\n"
apt-get --force-yes -o Dpkg::Options::="--force-confold" --force-yes -o Dpkg::Options::="--force-confdef" -fuy upgrade

echo -e "\n\n\n${baihongse}executing dist-upgrade${normal}\n\n\n"
apt-get --force-yes -o Dpkg::Options::="--force-confold" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade

timeWORK=upgradation
echo -e "\n\n\n" ; _time

[[ ! $DeBUG == 1 ]] && echo -e "\n${shanshuo}${baihongse}Reboot system now. You need to rerun this script after reboot${normal}\n\n\n\n\n" && reboot

sleep 20
kill -s TERM $TOP_PID
exit 0 ; }





# --------------------- 编译安装 qBittorrent --------------------- #

function _installqbt() {

# libtorrent-rasterbar 可以从系统源/PPA源里安装，或者用之前 deluge 用的 libtorrent-rasterbar；而编译 qbittorrent-nox 需要 libtorrent-rasterbar 的版本高于 1.0.6

# 好吧，先检查下系统源里的 libtorrent-rasterbar-dev 版本是多少压压惊
SysLTDEVer0=`  apt-cache policy libtorrent-rasterbar-dev | grep Candidate | awk '{print $2}' | sed "s/[^0-9]/ /g"  `
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
if [[ $( command -v deluged ) ]] && [[ ` deluged --version 2>/dev/null | grep libtorrent ` ]]; then
    DeLTVer0=`deluged --version 2>/dev/null | grep libtorrent | awk '{print $2}' | sed "s/[^0-9]/ /g"`
    DeLTVer1=`echo $DeLTVer0 | awk '{print $1}'`
    DeLTVer2=`echo $DeLTVer0 | awk '{print $2}'`
    DeLTVer3=`echo $DeLTVer0 | awk '{print $3}'`
    [[ $DeLTVer0 ]] && DeLTVer4=`echo ${DeLTVer1}.${DeLTVer2}.${DeLTVer3}`
fi

SysQbLT=No
[[ "${SysLTDEVer1}" == 1 ]] && [[ "${SysLTDEVer2}" == 0 ]] && [[ "${SysLTDEVer3}" -ge 6 ]] && SysQbLT=Yes
[[ "${SysLTDEVer1}" == 1 ]] && [[ "${SysLTDEVer2}" == 1 ]] && [[ "${SysLTDEVer3}" -ge 2 ]] && SysQbLT=Yes

DeQbLT=No
[[ "${DeLTVer1}" == 1 ]] && [[ "${DeLTVer2}" == 0 ]] && [[ "${DeLTVer3}" -ge 6 ]] && DeLT=8 && DeQbLT=Yes
[[ "${DeLTVer1}" == 1 ]] && [[ "${DeLTVer2}" == 1 ]] && [[ "${DeLTVer3}" -ge 2 ]] && DeLT=9 && DeQbLT=Yes

# DeLT 表示 libtorrent-ratserbar几，比如 0.16.18 对应 7，1.0.11 对应 8，1.1.6 对应 9

# 检测 deluge 用的 libtorrent 是不是来自于 python-libtorrent 这个包（其实这个 same 并不严谨，有可能不是同一个版本，但我懒得管了...）
[[ $SysLTDEVer4 == $DeLTVer4 ]] && SameLT=Yes

# 不用之前选择的版本做判断是为了防止出现有的人之前单独安装了 Deluge with 1.0.7 lt，又用脚本装 qb 导致出现 lt 冲突的情况

# DeBUG 用的，在 Log 里也可以看
# if [[ $DeBUG == 1 ]]; then  ; fi
echo -e "${bailanse}\n\n" ; echo DeQbLT=$DeQbLT ; echo SysQbLT=$SysQbLT ; echo DeLTVer4=$DeLTVer4 ; echo BuildedLTVer4=$BuildedLTVer4 ; echo SysLTDEVer4=$SysLTDEVer4 ; echo InstalledLTVer4=$InstalledLTVer4 ; echo -e "\n${normal}"

# [[ $DeQbLT == Yes ]] && [[ $BuildedLT ]] && echo 123






if [[ "${QBVERSION}" == "Install from repo" ]]; then

    apt-get install -y qbittorrent-nox
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

elif [[ "${QBVERSION}" == "Install from PPA" ]]; then

    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
    apt-get update
    apt-get install -y qbittorrent-nox
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

else

    # 2018.03.17 我真的是被 qBittorrent 这个依赖给搞烦起来了，索性以后用 iFeral 的方法算了？

    # 1. 不需要再安装 libtorrent-rasterbar
    #### 之前在安装 Deluge 的时候已经编译了 libtorrent-rasterbar，且版本满足 qBittorrent 编译的需要
    #### 2018.02.05 发现 Deluge 不能用 C++11 模式编译，不然 deluged 运行不了

    #### 2018.03.17 Debian 9 下 qBittorrent 4.0 似乎不需要 C++11，所以用 Deluge 编译的 libtorrent 应该是可以的
    #### 而如果用 Ubuntu 16.04 一般也不会有人去选择编译（如果编译了的话那么 xenial 下无法完成 qb 4.0 的编译）

    if [[ $DeQbLT == Yes ]] && [[ $BuildedLT ]]; then

        apt-get install -y build-essential pkg-config automake libtool git libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev qtbase5-dev qttools5-dev-tools libqt5svg5-dev python3 zlib1g-dev # > /dev/null

        echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-DEPENDENCY-INSTALLATION-COMPLETED  \n\n\n\n${normal}"
        echo "qBittorrent libtorrent-rasterbar from deluge" >> /etc/inexistence/01.Log/installed.log

    # 2. 需要安装 libtorrent-rasterbar-dev
    #### 第一个情况，Ubuntu 16.04（$SysQbLT = yes） ，没装 deluge，或者装了 deluge 且用的 libtorrent 是源的版本（$SameLT = Yes），且需要装的 qBittorrent 版本不是 4.0 的

    ################ 还有一个情况，Ubuntu 16.04 或者 Debian 9，Deluge 用的是编译的 libtorrent-rasterbar 0.16.19，不确定能不能用这个办法，所以还是再用第三个方案编译一次算了……
    # 2018.02.01 这个情况一般不会出现了，因为我又隐藏了 libtorrent-rasterbar 0.16 分支的选项……

    elif [[ $SysQbLT == Yes && $QBVERSION4 == No && ! $DeLTVer4 ]] || [[ $SysQbLT == Yes && $SameLT == Yes && $QBVERSION4 == No ]]; then

        apt-get install -y build-essential pkg-config automake libtool git libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev qtbase5-dev qttools5-dev-tools libqt5svg5-dev python3 zlib1g-dev libtorrent-rasterbar-dev # > /dev/null

        echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-DEPENDENCY-INSTALLATION-COMPLETED  \n\n\n\n${normal}"
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

    #### 2018.02.05：如果之前 Deluge 用的是编译的 libtorrent-rasterbar，这里再编译一次的话似乎会冲突……

    else

        apt-get purge -y libtorrent-rasterbar-dev
        apt-get install -y libqt5svg5-dev libboost-dev libboost-system-dev build-essential qtbase5-dev qttools5-dev-tools geoip-database libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev pkg-config zlib1g-dev automake autoconf libtool git python python3 checkinstall # > /dev/null
        cd; git clone --depth=1 -b libtorrent-1_0_11 --single-branch https://github.com/arvidn/libtorrent
        cd libtorrent
        ./autotool.sh

        if [[ "$CODENAME" =~ ("jessie"|"stretch") ]]; then
          ./configure --disable-debug --enable-encryption --with-libgeoip=system
        else
          ./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++11
        fi

      # [[ $tram -le 1900 ]] && _use_swap

        make clean
        make -j${MAXCPUS} && QBLTFail=0 || export QBLTCFail=1
        make install

      # [[ $tram -le 1900 ]] && _disable_swap

      # checkinstall -y --pkgname=libtorrentqb --pkgversion=1.0.11
        ldconfig
        echo;echo;echo;echo;echo;echo "  QB-LIBTORRENT-BUULDING-COMPLETED  ";echo;echo;echo;echo;echo

        echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-LIBTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"
        echo "qBittorrent libtorrent-rasterbar from building" >> /etc/inexistence/01.Log/installed.log

    fi

    cd; git clone https://github.com/qbittorrent/qBittorrent
    cd qBittorrent

#   [[ "${QBVERSION}" == '3.3.11 (Skip hash check)' ]] && QBVERSION=3.3.11
    QBVERSION=`echo $QBVERSION | cut -c1-7 | sed "s/ //g" | sed "s/(//g"`
    git checkout release-${QBVERSION}

    if [[ "${QBPATCH}" == "Yes" ]]; then
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        git cherry-pick db3158c
        git cherry-pick b271fa9
        git cherry-pick 1ce71fc #IO
        echo -e "\n\n\nQB 3.3.11 SKIP HASH CHECK (FOR LOG)\n\n\n"
    fi
    
    ./configure --prefix=/usr --disable-gui

    make -j${MAXCPUS} && QBCFail=0 || export QBCFail=1

    if [[ $qb_installed == Yes ]]; then
        make install && QBCFail=0 || export QBCFail=1
    else
#       dpkg -r qbittorrentnox
        checkinstall -y --pkgname=qbittorrentnox --pkgversion=$QBVERSION
    fi

    mv qbittorrentnox*deb /etc/inexistence/01.Log/INSTALLATION/packages
#     make install
    cd;rm -rf libtorrent qBittorrent
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

fi ; }






# --------------------- 下载安装 qBittorrent --------------------- #

function _installqbt2() { git clone --depth=1 https://github.com/Aniverse/iFeral /etc/iFeral ; chmod -R +x iFeral ; }






# --------------------- 设置 qBittorrent --------------------- #

function _setqbt() {

[[ -d /root/.config/qBittorrent ]] && rm -rf /root/.config/qBittorrent.old && mv /root/.config/qBittorrent /root/.config/qBittorrent.old
# [[ -d /home/${ANUSER}/.config/qBittorrent ]] && rm -rf /home/${ANUSER}/qBittorrent.old && mv /home/${ANUSER}/.config/qBittorrent /root/.config/qBittorrent.old
mkdir -p /home/${ANUSER}/qbittorrent/{download,torrent,watch} /var/www /root/.config/qBittorrent  #/home/${ANUSER}/.config/qBittorrent
chmod -R 777 /home/${ANUSER}/qbittorrent
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/qbittorrent  #/home/${ANUSER}/.config/qBittorrent
chmod -R 777 /etc/inexistence/01.Log  #/home/${ANUSER}/.config/qBittorrent
rm -rf /var/www/qbittorrent.download
ln -s /home/${ANUSER}/qbittorrent/download /var/www/qbittorrent.download

cp -f "${local_packages}"/template/config/qBittorrent.conf /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf
QBPASS=$(python "${local_packages}"/script/special/qbittorrent.userpass.py ${ANPASS})
sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf
sed -i "s/SCRIPTQBPASS/${QBPASS}/g" /root/.config/qBittorrent/qBittorrent.conf  #/home/${ANUSER}/.config/qBittorrent/qBittorrent.conf

if [[ $qb_download == Yes ]]; then
cp -f "${local_packages}"/template/systemd/qbittorrent.download.service /etc/systemd/system/qbittorrent.service
sed -i "s/VERSION/$QBVERSION/" /etc/systemd/system/qbittorrent.service
else
#cp -f "${local_packages}"/template/systemd/qbittorrent@.service /etc/systemd/system/qbittorrent@.service
cp -f "${local_packages}"/template/systemd/qbittorrent.service /etc/systemd/system/qbittorrent.service
fi

systemctl daemon-reload
systemctl enable qbittorrent
systemctl start qbittorrent
# systemctl enable qbittorrent@${ANUSER}
# systemctl start qbittorrent@${ANUSER}

touch /etc/inexistence/01.Log/lock/qbittorrent.lock ; }




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

      # 从源里安装 libtorrent-rasterbar[789] 以及对应版本的 python-libtorrent
      if [[ $DELTVERSION == "Install from repo" ]]; then

          apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako python-libtorrent # > /dev/null
          touch /etc/inexistence/01.Log/lock/deluge.libtorrent.python.lock

      # 从 PPA 安装 libtorrent-rasterbar8 以及对应版本的 python-libtorrent
      elif [[ $DELTVERSION == "Install from PPA" ]]; then

          apt-get install -y software-properties-common python-software-properties
          add-apt-repository -y ppa:deluge-team/ppa
          apt-get update
          apt-get install -y --allow-downgrades libtorrent-rasterbar8
          apt-get install -y --allow-downgrades python-libtorrent
          apt-mark hold libtorrent-rasterbar8 python-libtorrent
          apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako # > /dev/null
          touch /etc/inexistence/01.Log/lock/deluge.libtorrent.ppa.lock

      # 不安装 libtorrent-rasterbar（因为之前装过了，再装一次有时候会冲突）
      elif [[ $DELTVERSION == No ]]; then

          apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako # > /dev/null
          touch /etc/inexistence/01.Log/lock/deluge.libtorrent.no.lock
          echo -e "${bailanse}\n\n\n\n  DELUGE-DEPENDENCY-COMPLETED  \n\n\n${normal}"

      # 编译安装 libtorrent-rasterbar
      else

          apt-get install -y build-essential checkinstall libboost-system-dev libboost-python-dev libssl-dev libgeoip-dev libboost-chrono-dev libboost-random-dev python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako git libtool automake autoconf # > /dev/null
          echo -e "${bailanse}\n\n\n\n  DE-DEPENDENCY-COMPLETED  \n\n\n${normal}"
          cd; git clone --depth=1 -b ${DELTVERSION} --single-branch https://github.com/arvidn/libtorrent
          cd libtorrent
          ./autotool.sh
          ./configure --enable-python-binding --with-libiconv --with-libgeoip=system #这个是qb的参数

        # [[ $tram -le 1900 ]] && _use_swap

          make -j${MAXCPUS} && DELTCFail=0 || export DELTCFail=1
          dpkg -r libtorrentde
          checkinstall -y --pkgname=libtorrentde --pkgversion=${DELTPKG}

        # [[ $tram -le 1900 ]] && _disable_swap

          mv libtorrent*deb /etc/inexistence/01.Log/INSTALLATION/packages
          ldconfig
          touch /etc/inexistence/01.Log/lock/deluge.libtorrent.compile.lock
          echo -e "${bailanse}\n\n\n\n  DELUGE-LIBTORRENT-BUILDING-COMPLETED  \n\n\n${normal}"

      fi

      if [[ $DESKIP == Yes ]]; then
          DEVERSION=1.3.15
          cd; wget --no-check-certificate -O deluge-"${DEVERSION}".tar.gz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deluge/deluge-"${DEVERSION}".skip.tar.gz
          echo -e "\n\n\nDELUGE SKIP HASH CHECK (FOR LOG)\n\n\n"
      else
          cd; wget --no-check-certificate http://download.deluge-torrent.org/source/deluge-"${DEVERSION}".tar.gz
      fi

      tar zxf deluge-"${DEVERSION}".tar.gz
      cd deluge-"${DEVERSION}"

      ### 修复稍微新一点的系统（比如 Debian 8）下 RPC 连接不上的问题。这个问题在 Deluge 1.3.11 上已解决
      ### http://dev.deluge-torrent.org/attachment/ticket/2555/no-sslv3.diff
      ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.9/deluge/core/rpcserver.py
      ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.11/deluge/core/rpcserver.py
      if [[ $DESSL == Yes ]]; then
          sed -i "s/SSL.SSLv3_METHOD/SSL.SSLv23_METHOD/g" deluge/core/rpcserver.py
          sed -i "/        ctx = SSL.Context(SSL.SSLv23_METHOD)/a\        ctx.set_options(SSL.OP_NO_SSLv2 & SSL.OP_NO_SSLv3)" deluge/core/rpcserver.py
          echo -e "\n\nSSL FIX (FOR LOG)\n\n"
      fi

      python setup.py build  > /dev/null
      python setup.py install --install-layout=deb  > /dev/null
#     python setup.py install_data
      cd; rm -rf deluge* libtorrent

  fi

  echo -e "${bailanse}\n\n\n\n  DELUGE-INSTALLATION-COMPLETED  \n\n\n${normal}" ; }





# --------------------- Deluge 启动脚本、配置文件 --------------------- #

function _setde() {

# [[ -d /home/${ANUSER}/.config/deluge ]] && rm-rf /home/${ANUSER}/.config/deluge.old && mv /home/${ANUSER}/.config/deluge /root/.config/deluge.old
mkdir -p /home/${ANUSER}/deluge/{download,torrent,watch} /var/www
rm -rf /var/www/transmission.download
ln -s /home/${ANUSER}/deluge/download/ /var/www/deluge.download
chmod -R 777 /home/${ANUSER}/deluge  #/home/${ANUSER}/.config
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/deluge  #/home/${ANUSER}/.config

touch /etc/inexistence/01.Log/deluged.log /etc/inexistence/01.Log/delugeweb.log
chmod -R 777 /etc/inexistence/01.Log

# mkdir -p /home/${ANUSER}/.config  && cd /home/${ANUSER}/.config && rm -rf deluge
# cp -f -r "${local_packages}"/template/config/deluge /home/${ANUSER}/.config
mkdir -p /root/.config && cd /root/.config
[[ -d /root/.config/deluge ]] && rm-rf /root/.config/deluge && mv /root/.config/deluge /root/.config/deluge.old
cp -f "${local_packages}"/template/config/deluge.config.tar.gz /root/.config/deluge.config.tar.gz
tar zxf deluge.config.tar.gz
chmod -R 777 /root/.config
rm -rf deluge.config.tar.gz; cd

DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DWP=$(python "${local_packages}"/script/special/deluge.userpass.py ${ANPASS} ${DWSALT})
echo "${ANUSER}:${ANPASS}:10" >> /root/.config/deluge/auth  #/home/${ANUSER}/.config/deluge/auth
sed -i "s/delugeuser/${ANUSER}/g" /root/.config/deluge/core.conf  #/home/${ANUSER}/.config/deluge/core.conf
sed -i "s/DWSALT/${DWSALT}/g" /root/.config/deluge/web.conf  #/home/${ANUSER}/.config/deluge/web.conf
sed -i "s/DWP/${DWP}/g" /root/.config/deluge/web.conf  #/home/${ANUSER}/.config/deluge/web.conf

cp -f "${local_packages}"/template/systemd/deluged.service /etc/systemd/system/deluged.service
cp -f "${local_packages}"/template/systemd/deluge-web.service /etc/systemd/system/deluge-web.service
# cp -f "${local_packages}"/template/systemd/deluged@.service /etc/systemd/system/deluged@.service
# cp -f "${local_packages}"/template/systemd/deluge-web@.service /etc/systemd/system/deluge-web@.service

systemctl daemon-reload
systemctl enable /etc/systemd/system/deluge-web.service
systemctl enable /etc/systemd/system/deluged.service
systemctl start deluged
systemctl start deluge-web
# systemctl enable {deluged,deluge-web}@${ANUSER}
# systemctl start {deluged,deluge-web}@${ANUSER}

touch /etc/inexistence/01.Log/lock/deluge.lock ; }





# --------------------- 使用修改版 rtinst 安装 rTorrent, ruTorrent，h5ai, vsftpd --------------------- #

function _installrt() {

bash -c "$(wget --no-check-certificate -qO- https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup)"

# [[ $DeBUG == 1 ]] && echo $IPv6Opt && echo $RTVERSIONIns

if [[ $rt_installed == Yes ]]; then
    rtupdate $IPv6Opt $RTVERSIONIns
else
    rtinst --ssh-default --ftp-default --rutorrent-master --force-yes --log $IPv6Opt -v $RTVERSIONIns -u $ANUSER -p $ANPASS -w $ANPASS
fi

rtwebmin

# openssl req -x509 -nodes -days 3650 -subj /CN=$serveripv4 -config /etc/ssl/ruweb.cnf -newkey rsa:2048 -keyout /etc/ssl/private/ruweb.key -out /etc/ssl/ruweb.crt
mv /root/rtinst.log /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log
mv /home/${ANUSER}/rtinst.info /etc/inexistence/01.Log/INSTALLATION/07.rtinst.info.txt
ln -s /home/${ANUSER} /var/www/user.folder

cp -f "${local_packages}"/template/systemd/rtorrent@.service /etc/systemd/system/rtorrent@.service
cp -f "${local_packages}"/template/systemd/irssi@.service /etc/systemd/system/irssi@.service
systemctl daemon-reload

touch /etc/inexistence/01.Log/lock/rtorrent.lock
cd ; echo -e "${baihongse}\n\n\n\n\n  RT-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }






# --------------------- 安装 Node.js 与 flood --------------------- #

function _installflood() {

# [[ $tram -le 1900 ]] && _use_swap

bash <(curl -sL https://deb.nodesource.com/setup_9.x)
apt-get install -y nodejs build-essential python-dev
npm install -g node-gyp
git clone --depth=1 https://github.com/jfurrow/flood.git /srv/flood
cd /srv/flood
cp config.template.js config.js
npm install
sed -i "s/127.0.0.1/0.0.0.0/" /srv/flood/config.js

npm run build && FloodFail=0 || export FloodFail=1

# [[ $tram -le 1900 ]] && _disable_swap

cp -f "${local_packages}"/template/systemd/flood.service /etc/systemd/system/flood.service
systemctl start flood
systemctl enable flood

touch /etc/inexistence/01.Log/lock/flood.lock

cd ; echo -e "${baihongse}\n\n\n\n\n  FLOOD-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }






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

    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev ca-certificates libssl-dev pkg-config checkinstall cmake git # > /dev/null
    apt-get install -y openssl
    [[ $CODENAME = stretch ]] && apt-get install -y libssl1.0-dev
    cd; wget --no-check-certificate https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
    tar xvf release-2.1.8-stable.tar.gz
    mv libevent-release-2.1.8-stable libevent
    cd libevent
    ./autogen.sh
    ./configure
    make -j${MAXCPUS}
    make install
#   checkinstall -y --pkgversion=2.1.8
    cd; rm -rf libevent release-2.1.8-stable.tar.gz
#   ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib/libevent-2.1.so.6
    ldconfig

    if [[ "${TRdefault}" == "No" ]]; then
        wget --no-check-certificate https://github.com/Aniverse/BitTorrentClientCollection/raw/master/TransmissionMod/transmission-${TRVERSION}.tar.gz
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

#   dpkg -r transmission
    if [[ "${tr_installed}" == "Yes" ]]; then
        make install
    else
        checkinstall -y --pkgversion=$TRVERSION
    fi

    mv tr*deb /etc/inexistence/01.Log/INSTALLATION/packages
    cd; rm -rf transmission*

fi

cd ; echo -e "${baizise}\n\n\n\n\n  TR-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }





# --------------------- 配置 Transmission --------------------- #

function _settr() {

wget --no-check-certificate -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control.sh | bash

# [[ -d /home/${ANUSER}/.config/transmission-daemon ]] && rm -rf /home/${ANUSER}/.config/transmission-daemon.old && mv /home/${ANUSER}/.config/transmission-daemon /home/${ANUSER}/.config/transmission-daemon.old
[[ -d /root/.config/transmission-daemon ]] && rm -rf /root/.config/transmission-daemon.old && mv /root/.config/transmission-daemon /root/.config/transmission-daemon.old

mkdir -p /home/${ANUSER}/{download,torrent,watch} /var/www /root/.config/transmission-daemon  #/home/${ANUSER}/.config/transmission-daemon
chmod -R 777 /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
rm -rf /var/www/transmission.download
ln -s /home/${ANUSER}/transmission/download/ /var/www/transmission.download

cp -f "${local_packages}"/template/config/transmission.settings.json /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json
cp -f "${local_packages}"/template/systemd/transmission.service /etc/systemd/system/transmission.service
# cp -f "${local_packages}"/template/systemd/transmission@.service /etc/systemd/system/transmission@.service
[[ `command -v transmission-daemon` == /usr/local/bin/transmission-daemon ]] && sed -i "s/usr/usr\/local/g" /etc/systemd/system/transmission.service

sed -i "s/RPCUSERNAME/${ANUSER}/g" /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json
sed -i "s/RPCPASSWORD/${ANPASS}/g" /root/.config/transmission-daemon/settings.json  #/home/${ANUSER}/.config/transmission-daemon/settings.json

systemctl daemon-reload
systemctl enable transmission
systemctl start transmission
# systemctl enable transmission@${ANUSER}
# systemctl start transmission@${ANUSER}

touch /etc/inexistence/01.Log/lock/transmission.lock ; }





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

  flexget web passwd $ANPASS 2>&1 | tee /tmp/flex.pass.output
  rm -rf /etc/inexistence/01.Log/lock/flexget.{pass,conf}.lock
  [[ `grep "not strong enough" /tmp/flex.pass.output` ]] && { export FlexPassFail=1 ; echo -e "\nFailed to set flexget webui password\n"            ; touch /etc/inexistence/01.Log/lock/flexget.pass.lock ; }
  [[ `grep "schema validation" /tmp/flex.pass.output` ]] && { export FlexConfFail=1 ; echo -e "\nFailed to set flexget config and webui password\n" ; touch /etc/inexistence/01.Log/lock/flexget.conf.lock ; }
  
# [[ $DeBUG == 1 ]] && echo "FlexConfFail=$FlexConfFail  FlexPassFail=$FlexPassFail"

  cp -f "${local_packages}"/template/systemd/flexget.service /etc/systemd/system/flexget.service
# cp -f "${local_packages}"/template/systemd/flexget@.service /etc/systemd/system/flexget@.service
  systemctl daemon-reload
  systemctl enable /etc/systemd/system/flexget.service
  systemctl start flexget
# systemctl enable flexget@${ANPASS}
# systemctl start flexget@${ANPASS}

  touch /etc/inexistence/01.Log/lock/flexget.lock
  echo -e "${bailvse}\n\n\n  FLEXGET-INSTALLATION-COMPLETED  \n\n${normal}" ; }





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
touch /etc/inexistence/01.Log/lock/rclone.lock
echo -e "${bailvse}\n\n\n  RCLONE-INSTALLATION-COMPLETED  \n\n${normal}" ; }






# --------------------- 安装 BBR --------------------- #

function _install_bbr() {
_online_ubuntu_bbr_firmware
_bbr_kernel_4_11_12
_enable_bbr
echo -e "${bailvse}\n\n\n  BBR-INSTALLATION-COMPLETED  \n\n${normal}" ; }

# 安装 4.11.12 的内核
function _bbr_kernel_4_11_12() {
wget --no-check-certificate -qO 1.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Kernel/BBR/linux-headers-4.11.12-all.deb
wget --no-check-certificate -qO 2.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Kernel/BBR/linux-headers-4.11.12-amd64.deb
wget --no-check-certificate -qO 3.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Kernel/BBR/linux-image-4.11.12-generic-amd64.deb
dpkg -i [123].deb
rm -rf [123].deb
update-grub ; }


# 开启 BBR
function _enable_bbr() {
bbrname=bbr
sed -i '/net.core.default_qdisc.*/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control.*/d' /etc/sysctl.conf
echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = $bbrname" >> /etc/sysctl.conf
sysctl -p
touch /etc/inexistence/01.Log/lock/bbr.lock ; }


# Online.net 独服补充固件（For BBR）
function _online_ubuntu_bbr_firmware() {
mkdir -p /lib/firmware/bnx2
wget -qO /lib/firmware/bnx2/bnx2-mips-06-6.2.3.fw https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Firmware/bnx2-mips-06-6.2.3.fw
wget -qO /lib/firmware/bnx2/bnx2-mips-09-6.2.1b.fw https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Firmware/bnx2-mips-09-6.2.1b.fw
wget -qO /lib/firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Firmware/bnx2-rv2p-09ax-6.0.17.fw
wget -qO /lib/firmware/bnx2/bnx2-rv2p-09-6.0.17.fw https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Firmware/bnx2-rv2p-09-6.0.17.fw
wget -qO /lib/firmware/bnx2/bnx2-rv2p-06-6.0.15.fw https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux%20Firmware/bnx2-rv2p-06-6.0.15.fw ; }







# --------------------- 安装 VNC --------------------- #

function _installvnc() {

apt-get install -y vnc4server
apt-get install -y --install-recommends xfce4 xfce4-goodies fonts-noto xfonts-intl-chinese-big xfonts-wqy #fcitx
apt-get install -y xfonts-100dpi xfonts-75dpi xfonts-scalable x11-xfs-utils x11proto-xf86bigfont-dev x11proto-fonts-dev

vncpasswd=`date +%s | sha256sum | base64 | head -c 8`
vncpasswd <<EOF
$ANPASS
$ANPASS
EOF
vncserver && vncserver -kill :1
cd; mkdir -p .vnc
cp -f "${local_packages}"/template/xstartup.1.xfce4 /root/.vnc/xstartup
chmod +x /root/.vnc/xstartup
cp -f "${local_packages}"/template/systemd/vncserver.service /etc/systemd/system/vncserver.service

systemctl daemon-reload
systemctl enable vncserver
systemctl start vncserver
systemctl status vncserver

touch /etc/inexistence/01.Log/lock/vnc.lock

echo -e "${bailvse}\n\n\n  VNC-INSTALLATION-COMPLETED  \n\n${normal}" ; }






# --------------------- 安装 X2Go --------------------- #

function _installx2go() {

apt-get install -y xfce4 xfce4-goodies fonts-noto xfonts-intl-chinese-big xfonts-wqy
echo -e "\n\n\n  xfce4  \n\n\n\n"

if [[ $DISTRO == Ubuntu ]]; then
    apt-get install -y software-properties-common firefox
    apt-add-repository -y ppa:x2go/stable
elif [[ $DISTRO == Debian ]]; then
    cat >/etc/apt/sources.list.d/x2go.list<<EOF
# X2Go Repository (release builds)
deb http://packages.x2go.org/debian ${CODENAME} main
# X2Go Repository (sources of release builds)
deb-src http://packages.x2go.org/debian ${CODENAME} main
# X2Go Repository (nightly builds)
#deb http://packages.x2go.org/debian ${CODENAME} heuler
# X2Go Repository (sources of nightly builds)
#deb-src http://packages.x2go.org/debian ${CODENAME} heuler
EOF
#   gpg --keyserver http://keyserver.ubuntu.com --recv E1F958385BFE2B6E
#   gpg --export E1F958385BFE2B6E > /etc/apt/trusted.gpg.d/x2go.gpg
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1F958385BFE2B6E
    apt-get -y update
    apt-get -y install x2go-keyring iceweasel
fi

apt-get -y update
apt-get -y install x2goserver x2goserver-xsession pulseaudio

touch /etc/inexistence/01.Log/lock/x2go.lock

echo -e "${bailvse}\n\n\n  X2GO-INSTALLATION-COMPLETED  \n\n${normal}" ; }





# --------------------- 安装 wine 与 mono --------------------- #

function _installwine() {

# mono
# http://www.mono-project.com/download/stable/#download-lin
# https://download.mono-project.com/sources/mono/
# http://www.mono-project.com/docs/compiling-mono/compiling-from-git/

InsMonoMode=apt

if [[ $InsMonoMode == Building ]]; then

    apt-get install -y git autoconf libtool automake build-essential mono-devel gettext cmake python libtool-bin
    git clone --depth=1 -b mono-5.13.0.302 https://github.com/mono/mono
    cd mono
    ./autogen.sh --prefix=/usr/local
    make -j${MAXCPUS}
    make install
    cd .. ; rm -rf mono

elif [[ $InsMonoMode == apt ]]; then

    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb http://download.mono-project.com/repo/${DISTROL} stable-${CODENAME} main" > /etc/apt/sources.list.d/mono.list
    apt-get -y update
    apt-get install -y mono-complete ca-certificates-mono

fi

echo -e "${bailanse}\n\n\n\n\n  MONO-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

# wine
# https://wiki.winehq.org/Debian

InsWineMode=apt

if [[ $InsWineMode == Building ]]; then

    # wget --no-check-certificate https://dl.winehq.org/wine/source/3.x/wine-3.3.tar.xz
    cd ; git clone git://source.winehq.org/git/wine.git
    cd wine
    ./configure
    make -j${MAXCPUS}
    make install
    cd .. ; rm -rf wine

elif [[ $InsWineMode == apt ]]; then

    dpkg --add-architecture i386
    wget --no-check-certificate -qO- https://dl.winehq.org/wine-builds/Release.key | apt-key add -

    if [[ $DISTRO == Ubuntu ]]; then
        apt-get install -y software-properties-common
        apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/
    elif [[ $DISTRO == Debian ]]; then
        echo "deb https://dl.winehq.org/wine-builds/${DISTROL}/ ${CODENAME} main" > /etc/apt/sources.list.d/wine.list
    fi

    apt-get update -y
    apt-get install -y --install-recommends winehq-stable

fi

wget --no-check-certificate https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
mv winetricks /usr/local/bin

touch /etc/inexistence/01.Log/lock/winemono.lock

echo -e "\n\n\n${bailvse}Version${normal}"
echo "${bold}${green}`wine --version`"
echo "mono `mono --version 2>&1 | head -n1 | awk '{print $5}'`${normal}"
echo -e "${bailanse}\n\n\n\n\n  WINE-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }





# --------------------- 安装 mkvtoolnix／mktorrent／ffmpeg／mediainfo／eac3to --------------------- #

function _installtools() {

# DISTROL=debian ; CODENAME=jessie

########## Blu-ray ##########

wget --no-check-certificate -qO /usr/local/bin/bluray https://github.com/Aniverse/bluray/raw/master/bluray
chmod +x /usr/local/bin/bluray

########## 安装 新版 ffmpeg ##########

cd ; wget --no-check-certificate -O ffmpeg-3.4.2-64bit-static.tar.xz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Other%20Tools/ffmpeg-3.4.2-64bit-static.tar.xz
tar xf ffmpeg-3.4.2-64bit-static.tar.xz
rm -rf ffmpeg-*-64bit-static/{manpages,GPLv3.txt,readme.txt}
cp -f ffmpeg-*-64bit-static/* /usr/bin
chmod 777 /usr/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
rm -rf ffmpeg-*-64bit-static*

########## 安装 新版 mkvtoolnix 与 mediainfo ##########

wget --no-check-certificate -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -
echo -n  > /etc/apt/sources.list.d/mkvtoolnix.list
echo "deb https://mkvtoolnix.download/${DISTROL}/${CODENAME}/ ./" >> /etc/apt/sources.list.d/mkvtoolnix.list
echo "deb-src https://mkvtoolnix.download/${DISTROL}/${CODENAME}/ ./" >> /etc/apt/sources.list.d/mkvtoolnix.list

wget --no-check-certificate -q https://mediaarea.net/repo/deb/repo-mediaarea_1.0-5_all.deb
dpkg -i repo-mediaarea_1.0-5_all.deb
rm -rf repo-mediaarea_1.0-5_all.deb

apt-get -y update
apt-get install -y mkvtoolnix mkvtoolnix-gui mediainfo mktorrent imagemagick

########### 编译安装 mktorrent 1.1  ###########
# mktorrent 1.1 可以不用写 announce，支持了多线程，但是制作过程中没有进度条了
# 并且据某位大佬说，他在 LT2016 上用 mktorrent 1.1 比 mktorrent 1.0 更慢，因此还是用系统源里的 1.0 算了

# wget --no-check-certificate https://github.com/Rudde/mktorrent/archive/v1.1.tar.gz
# tar zxf v1.1.tar.gz
# cd mktorrent-1.1
# make -j${MAXCPUS}
# make install
# cd ..
# rm -rf mktorrent-1.1 v1.1.tar.gz

# MkTorrent WebUI，存在 bug 不可用，且就算能用好像也不是那么的实用，就算了
mkdir -p /var/www/mktorrent
cp -f "${local_packages}"/template/mktorrent.php /var/www/mktorrent/index.php
sed -i "s/REPLACEUSERNAME/${ANUSER}/g" /var/www/mktorrent/index.php

######################  eac3to  ######################

cd /etc/inexistence/02.Tools/eac3to
wget --no-check-certificate -q http://madshi.net/eac3to.zip
unzip -qq eac3to.zip
rm -rf eac3to.zip ; cd

touch /etc/inexistence/01.Log/lock/tools.lock

echo -e "\n\n\n${bailvse}Version${normal}${bold}${green}"
mktorrent -h | head -n1
mkvmerge --version
echo "Mediainfo `mediainfo --version | grep Lib | cut -c17-`"
echo "ffmpeg `ffmpeg 2>&1 | head -n1 | awk '{print $3}'`${normal}"
echo -e "${bailanse}\n\n\n\n\n  UPTOOLBOX-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }





# --------------------- 一些设置修改 --------------------- #
function _tweaks() {

# Oh my zsh
#sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
#cp -f "${local_packages}"/template/config/zshrc ~/.zshrc
#wget -O ~/.oh-my-zsh/themes/agnosterzak.zsh-theme http://raw.github.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
#chsh -s /bin/zsh


# PowerFonts
git clone --depth=1 -b master --single-branch https://github.com/powerline/fonts
cd fonts;./install.sh
cd; rm -rf fonts


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

# sed -i '$d' /etc/bash.bashrc

[[ `grep "Inexistence Mod" /etc/bash.bashrc` ]] && sed -i -n -e :a -e '1,137!{P;N;D;};N;ba' /etc/bash.bashrc

cat>>/etc/bash.bashrc<<EOF


################## Inexistence Mod Start ##################

function _colors() {
black=\$(tput setaf 0); red=\$(tput setaf 1); green=\$(tput setaf 2); yellow=\$(tput setaf 3);
blue=\$(tput setaf 4); magenta=\$(tput setaf 5); cyan=\$(tput setaf 6); white=\$(tput setaf 7);
on_red=\$(tput setab 1); on_green=\$(tput setab 2); on_yellow=\$(tput setab 3); on_blue=\$(tput setab 4);
on_magenta=\$(tput setab 5); on_cyan=\$(tput setab 6); on_white=\$(tput setab 7); bold=\$(tput bold);
dim=\$(tput dim); underline=\$(tput smul); reset_underline=\$(tput rmul); standout=\$(tput smso);
reset_standout=\$(tput rmso); normal=\$(tput sgr0); alert=\${white}\${on_red}; title=\${standout};
baihuangse=\${white}\${on_yellow}; bailanse=\${white}\${on_blue}; bailvse=\${white}\${on_green};
baiqingse=\${white}\${on_cyan}; baihongse=\${white}\${on_red}; baizise=\${white}\${on_magenta};
heibaise=\${black}\${on_white}; heihuangse=\${on_yellow}\${black}
jiacu=\${normal}\${bold}
shanshuo=\$(tput blink); wuguangbiao=\$(tput civis); guangbiao=\$(tput cnorm) ; }
_colors

io_test() { (LANG=C dd if=/dev/zero of=test_\$\$ bs=64k count=16k conv=fdatasync && rm -f test_\$\$ ) 2>&1 | awk -F, '{io=\$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*\$//' ; }
iotest() { io1=\$( io_test ) ; echo -e "\n\${bold}硬盘I/O (第一次测试) : \${yellow}\$io1\${normal}"
io2=\$( io_test ) ; echo -e "\${bold}硬盘I/O (第二次测试) : \${yellow}\$io2\${normal}" ; io3=\$( io_test ) ; echo -e "\${bold}硬盘I/O (第三次测试) : \${yellow}\$io3\${normal}\n" ; }

wangka=` ip route get 8.8.8.8 | awk '{print $5}' | head -n1 `

ulimit -SHn 666666

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias qba="systemctl start qbittorrent"
alias qbb="systemctl stop qbittorrent"
alias qbc="systemctl status qbittorrent"
alias qbr="systemctl restart qbittorrent"
alias qbl="tail -n100 /etc/inexistence/01.Log/qbittorrent.log"
alias qbs="nano /root/.config/qBittorrent/qBittorrent.conf"
alias dea="systemctl start deluged"
alias deb="systemctl stop deluged"
alias dec="systemctl status deluged"
alias der="systemctl restart deluged"
alias del="tail -n100 /etc/inexistence/01.Log/deluged.log"
alias dewa="systemctl start deluge-web"
alias dewb="systemctl stop deluge-web"
alias dewc="systemctl status deluge-web"
alias dewr="systemctl restart deluge-web"
alias dewl="tail -n100 /etc/inexistence/01.Log/delugeweb.log"
alias tra="systemctl start transmission"
alias trb="systemctl stop transmission"
alias trc="systemctl status transmission"
alias trr="systemctl restart transmission"
alias rta="su ${ANUSER} -c 'rt start'"
alias rtb="su ${ANUSER} -c 'rt -k stop'"
alias rtc="su ${ANUSER} -c 'rt'"
alias rtr="su ${ANUSER} -c 'rt -k restart'"
alias rtscreen="chmod -R 777 /dev/pts && su ${ANUSER} -c 'screen -r rtorrent'"
alias irssia="su ${ANUSER} -c 'rt -i start'"
alias irssib="su ${ANUSER} -c 'rt -i -k stop'"
alias irssic="su ${ANUSER} -c 'rt -i'"
alias irssir="su ${ANUSER} -c 'rt -i -k restart'"
alias irssiscreen="chmod -R 777 /dev/pts && su ${ANUSER} -c 'screen -r irssi'"
alias fla="systemctl start flexget"
alias flaa="flexget daemon start --daemonize"
alias flb="systemctl stop flexget"
alias flc="systemctl status flexget"
alias flcc="flexget daemon status"
alias flr="systemctl restart flexget"
alias flrr="flexget daemon reload-config"
alias fll="echo ; tail -n100 /root/.config/flexget/flexget.log ; echo"
alias fls="nano /root/.config/flexget/config.yml"
alias flcheck="flexget check"
alias fle="flexget execute"
alias ssa="/etc/init.d/shadowsocks-r start"
alias ssb="/etc/init.d/shadowsocks-r stop"
alias ssc="/etc/init.d/shadowsocks-r status"
alias ssr="/etc/init.d/shadowsocks-r restart"
alias ruisua="/appex/bin/serverSpeeder.sh start"
alias ruisub="/appex/bin/serverSpeeder.sh stop"
alias ruisuc="/appex/bin/serverSpeeder.sh status"
alias ruisur="/appex/bin/serverSpeeder.sh restart"

alias yongle="du -sB GB"
alias rtyongle="du -sB GB /home/${ANUSER}/rtorrent/download"
alias qbyongle="du -sB GB /home/${ANUSER}/qbittorrent/download"
alias deyongle="du -sB GB /home/${ANUSER}/deluge/download"
alias tryongle="du -sB GB /home/${ANUSER}/transmission/download"
alias cdde="cd /home/${ANUSER}/deluge/download"
alias cdqb="cd /home/${ANUSER}/qbittorrent/download"
alias cdrt="cd /home/${ANUSER}/rtorrent/download"
alias cdtr="cd /home/${ANUSER}/transmission/download"

alias shanchu="rm -rf"
alias xiugai="nano /etc/bash.bashrc && source /etc/bash.bashrc"
alias quanxian="chmod -R 777"
alias anzhuang="apt-get install"
alias yongyouzhe="chown ${ANUSER}:${ANUSER}"

alias banben1='apt-cache policy'
alias banben2='dpkg -l | grep'
alias scrl="screen -ls"
alias scrgd="screen -U -R GoogleDrive"
alias scrgdb="screen -S GoogleDrive -X quit"
alias jincheng="ps aux | grep -v grep | grep"

alias cdb="cd .."
alias tree="tree --dirsfirst"
alias ls="ls -hAv --color --group-directories-first"
alias ll="ls -hAlvZ --color --group-directories-first"
alias gclone="git clone --depth=1"

alias cesu="echo;spdtest --share;echo"
alias cesu2="echo;spdtest --share --server"
alias cesu3="echo;spdtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ios="iostat -dxm 1"
alias vms="vmstat 1 10"
alias vns="vnstat -l -i $wangka"

alias sousuo1="find / -name"
alias sousuo2="find /home/${ANUSER} -name"

alias yuan="nano /etc/apt/sources.list"
alias cronr="/etc/init.d/cron restart"
alias sshr="sed -i '/^PermitRootLogin.*/ c\PermitRootLogin yes' /etc/ssh/sshd_config && /etc/init.d/ssh restart  >/dev/null 2>&1 ; echo -e '\n已开启 root 登陆\n'"

alias eac3to='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe'
alias eacout='wine /etc/inexistence/02.Tools/eac3to/eac3to.exe 2>/dev/null | tr -cd "\11\12\15\40-\176"'

alias jiaobenxuanxiang="clear && cat /etc/inexistence/01.Log/installed.log && echo"
alias jiaobende="clear && cat /etc/inexistence/01.Log/INSTALLATION/03.de1.log && echo"
alias jiaobenqb="clear && cat /etc/inexistence/01.Log/INSTALLATION/05.qb1.log && echo"
alias jiaobenrt1="clear && cat /etc/inexistence/01.Log/INSTALLATION/07.rt.log && echo"
alias jiaobenrt2="clear && cat /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log && echo"
alias jiaobentr="clear && cat /etc/inexistence/01.Log/INSTALLATION/08.tr1.log && echo"
alias jiaobenfl="clear && cat /etc/inexistence/01.Log/INSTALLATION/10.flexget.log && echo"
alias jiaobenend="clear && cat /etc/inexistence/01.Log/INSTALLATION/99.end.log && echo"

################## Inexistence Mod END ##################


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

# 将最大的分区的保留空间设置为 0%
tune2fs -m 0 `df -k | sort -rn -k4 | awk '{print $1}' | head -1`

locale-gen en_US.UTF-8
locale
sysctl -p
# source /etc/bash.bashrc

# apt-get -y upgrade
apt-get -y autoremove

touch /etc/inexistence/01.Log/lock/tweaks.lock ; }





# --------------------- 结尾 --------------------- #

function _end() {

[[ $USESWAP == Yes ]] && _disable_swap

_check_install_2

clear

echo -e " ${baiqingse}${bold}      INSTALLATION COMPLETED      ${normal} \n"
echo '-----------------------------------------------------------'


if [[ ! $QBVERSION == No ]] && [[ $qb_installed == Yes ]]; then
    echo -e " ${cyan}qBittorrent WebUI${normal}    https://${serveripv4}/qb"
elif [[ ! $QBVERSION == No ]] && [[ $qb_installed == No ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}qBittorrent installation FAILED${normal}"
    QBFAILED=1 ; INSFAILED=1
fi


if [[ ! $DEVERSION == No ]] && [[ $de_installed == Yes ]]; then
    echo -e " ${cyan}Deluge WebUI${normal}         https://${serveripv4}/de"
elif [[ ! $DEVERSION == No ]] && [[ $de_installed == No ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Deluge installation FAILED${normal}"
    DEFAILED=1 ; INSFAILED=1
fi


if [[ ! $TRVERSION == No ]] && [[ $tr_installed == Yes ]]; then
    echo -e " ${cyan}Transmission WebUI${normal}   https://${ANUSER}:${ANPASS}@${serveripv4}/tr"
elif [[ ! $TRVERSION == No ]] && [[ $tr_installed == No ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Transmission installation FAILED${normal}"
    TRFAILED=1 ; INSFAILED=1
fi


if [[ ! $RTVERSION == No ]] && [[ $rt_installed == Yes ]]; then
    echo -e " ${cyan}RuTorrent${normal}            https://${ANUSER}:${ANPASS}@${serveripv4}/rt"
    [[ $InsFlood == Yes ]] && [[ ! $FloodFail == 1 ]] &&
    echo -e " ${cyan}Flood${normal}                http://${serveripv4}:3000"
    [[ $InsFlood == Yes ]] && [[   $FloodFail == 1 ]] &&
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Flood installation FAILED${normal}"
    echo -e " ${cyan}h5ai File Indexer${normal}    https://${ANUSER}:${ANPASS}@${serveripv4}"
    echo -e " ${cyan}webmin${normal}               https://${serveripv4}/webmin"
elif [[ ! $RTVERSION == No ]] && [[ $rt_installed == No ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}rTorrent installation FAILED${normal}"
    echo -e " ${cyan}h5ai File Indexer${normal}    https://${ANUSER}:${ANPASS}@${serveripv4}"
    RTFAILED=1 ; INSFAILED=1
fi


if [[ ! $InsFlex == No ]] && [[ $flex_installed == Yes ]]; then
    echo -e " ${cyan}Flexget WebUI${normal}        http://${serveripv4}:6566 ${bold}(username is ${underline}flexget${reset_underline}${normal})"
elif [[ ! $InsFlex == No ]] && [[ $flex_installed == No ]]; then
    echo -e " ${bold}${baihongse}ERROR${normal}                ${bold}${red}Flexget installation FAILED${normal}"
    FLFAILED=1 ; INSFAILED=1
fi


# echo -e " ${cyan}MkTorrent WebUI${normal}      https://${ANUSER}:${ANPASS}@${serveripv4}/mktorrent"

echo
echo -e " ${cyan}Your Username${normal}        ${bold}${ANUSER}${normal}"
echo -e " ${cyan}Your Password${normal}        ${bold}${ANPASS}${normal}"
[[ $InsRDP == VNC ]] && [[ $CODENAME == xenial ]] && echo -e " ${cyan}VNC  Password${normal}        ${bold}` echo ${ANPASS} | cut -c1-8` ${normal}"
# [[ $DeBUG == 1 ]] && echo "FlexConfFail=$FlexConfFail  FlexPassFail=$FlexPassFail"
[[ -e /etc/inexistence/01.Log/lock/flexget.pass.lock ]] && echo -e "\n${bold}${bailanse} Naive! ${normal} You need to set Flexget WebUI password by typing \n        ${bold}flexget web passwd <new password>${normal}"
[[ -e /etc/inexistence/01.Log/lock/flexget.conf.lock ]] && echo -e "\n${bold}${bailanse} Naive! ${normal} You need to check your Flexget config file\n        maybe your password is too young too simple?${normal}"

echo '-----------------------------------------------------------'
echo

timeWORK=installation
_time

    if [[ $INSFAILED == 1 ]]; then
echo "${bold}Unfortunately something went wrong during installation.
Check log by typing these commands:
${yellow}cat /etc/inexistence/01.Log/installed.log"
[[ $QBFAILED == 1 ]]  && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/05.qb1.log" && echo "QBLTCFail=$QBLTCFail   QBCFail=$QBCFail"
[[ $DEFAILED == 1 ]]  && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/03.de1.log" && echo "DELTCFail=$DELTCFail"
[[ $TRFAILED == 1 ]]  && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/08.tr1.log"
[[ $RTFAILED == 1 ]]  && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/07.rt.log\ncat /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log"
[[ $FloodFail == 1 ]] && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/07.flood.log"
[[ $FLFAILED == 1 ]]  && echo -e "cat /etc/inexistence/01.Log/INSTALLATION/10.flexget.log"
echo -ne "${normal}"
    fi

echo ; }





# --------------------- 结构 --------------------- #

_intro
_askusername
_askpassword
_askaptsource
_askmt
_askswap
_askdeluge
[[ ! $DEVERSION == No ]] && 
_askdelt
_askqbt
_askrt
[[ ! $RTVERSION == No ]] && 
_askflood
_asktr
_askrdp
_askwine
_asktools
_askflex
_askrclone

if [[ -d /proc/vz ]]; then
    echo -e "${yellow}${bold}Since your seedbox is based on ${red}OpenVZ${normal}${yellow}${bold}, skip BBR installation${normal}\n"
    InsBBR='Not supported on OpenVZ'
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
# mv /etc/00.checkrepo1.log /etc/inexistence/01.Log/INSTALLATION/00.checkrepo1.log
# mv /etc/00.checkrepo2.log /etc/inexistence/01.Log/INSTALLATION/00.checkrepo2.log
mv /etc/01.setuser.log /etc/inexistence/01.Log/INSTALLATION/01.setuser.log

# --------------------- 安装 --------------------- #


if   [[ $InsBBR == Yes ]]; then
     echo -ne "Configuring BBR ... \n\n\n" ; _install_bbr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/02.bbr.log
elif [[ $InsBBR == To\ be\ enabled ]]; then
     echo -ne "Configuring BBR ... \n\n\n" ; _enable_bbr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/02.bbr.log
else
     echo -e  "Skip BBR installation\n\n\n\n\n"
fi

if  [[ $DEVERSION == No ]]; then
    echo -e  "Skip Deluge installation \n\n\n\n"
else
    echo -ne "Installing Deluge ... \n\n\n" ; _installde 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/03.de1.log
    echo -ne "Configuring Deluge ... \n\n\n" ; _setde 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/04.de2.log
fi


if  [[ $QBVERSION == No ]]; then
    echo -e  "Skip qBittorrent installation\n\n\n\n"
else
    echo -ne "Installing qBittorrent ... \n\n\n" ; _installqbt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/05.qb1.log
    echo -ne "Configuring qBittorrent ... \n\n\n" ; _setqbt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/06.qb2.log
fi


if  [[ $RTVERSION == No ]]; then
    echo -e  "Skip rTorrent installation\n\n\n"
else
    echo -ne "Installing rTorrent ... \n\n\n" ; _installrt 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/07.rt.log
    [[ $InsFlood == Yes ]] && { echo -ne "Installing Flood ... \n\n\n" ; _installflood 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/07.flood.log ; }
fi


if  [[ $TRVERSION == No ]]; then
    echo -e  "Skip Transmission installation\n\n\n\n"
else
    echo -ne "Installing Transmission ... \n\n\n" ; _installtr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/08.tr1.log
    echo -ne "Configuring Transmission ... \n\n\n" ; _settr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/09.tr2.log
fi


if  [[ $InsFlex == Yes ]]; then
    echo -ne "Installing Flexget ... \n\n\n" ; _installflex 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/10.flexget.log
else
    echo -e  "Skip Flexget installation\n\n\n\n"
fi


if  [[ $InsRclone == Yes ]]; then
    echo -ne "Installing rclone ... " ; _installrclone 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/11.rclone.log
else
    echo -e  "Skip rclone installation\n\n\n\n"
fi


####################################

if   [[ $InsRDP == VNC ]]; then
     echo -ne "Installing VNC ... \n\n\n" ; _installvnc 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/12.rdp.log
elif [[ $InsRDP == X2Go ]]; then
     echo -ne "Installing X2Go ... \n\n\n" ; _installx2go 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/12.rdp.log
else
     echo -e  "Skip RDP installation\n\n\n\n"
fi


if  [[ $InsWine == Yes ]]; then
    echo -ne "Installing Wine ... \n\n\n" ; _installwine 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/12.wine.log
else
    echo -e  "Skip Wine installation\n\n\n\n"
fi


if  [[ $InsTools == Yes ]]; then
    echo -ne "Installing Uploading Toolbox ... \n\n\n" ; _installtools 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/13.tool.log
else
    echo -e  "Skip Uploading Toolbox installation\n\n\n\n"
fi

####################################


if [[ $UseTweaks == Yes ]]; then
    echo -ne "Configuring system settings ... \n\n\n" ; _tweaks
else
    echo -e  "Skip System tweaks\n\n\n\n"
fi






_end 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/99.end.log
rm "$0" >> /dev/null 2>&1
_askreboot




