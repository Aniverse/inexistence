#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
# bash <(curl -s https://raw.githubusercontent.com/Aniverse/inexistence/master/inexistence.sh)
# bash -c "$(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/inexistence.sh)"
#
# PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
# export PATH
# --------------------------------------------------------------------------------
SYSTEMCHECK=1
DISABLE=0
DeBUG=0
INEXISTENCEVER=1.0.8
INEXISTENCEDATE=2018.10.23
# --------------------------------------------------------------------------------



# 获取参数

OPTS=$(getopt -n "$0" -o dsyu:p: --long "yes,tr-skip,skip,debug,apt-yes,apt-no,swap-yes,swap-no,bbr-yes,bbr-no,flood-yes,flood-no,rdp-vnc,rdp-x2go,rdp-no,wine-yes,wine-no,tools-yes,tools-no,flexget-yes,flexget-no,rclone-yes,rclone-no,enable-ipv6,tweaks-yes,tweaks-no,mt-single,mt-double,mt-max,mt-half,user:,password:,webpass:,de:,delt:,qb:,rt:,tr:" -- "$@")

eval set -- "$OPTS"

while true; do
  case "$1" in
    -u | --user     ) ANUSER="$2"       ; shift ; shift ;;
    -p | --password ) ANPASS="$2"       ; shift ; shift ;;

    --qb            ) { if [[ $2 == ppa ]]; then QBVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then QBVERSION='Install from repo'   ; else QBVERSION=$2   ; fi ; } ; shift ; shift ;;
    --rt            ) { if [[ $2 == ppa ]]; then RTVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then RTVERSION='Install from repo'   ; else RTVERSION=$2   ; fi ; } ; shift ; shift ;;
    --tr            ) { if [[ $2 == ppa ]]; then TRVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then TRVERSION='Install from repo'   ; else TRVERSION=$2   ; fi ; } ; shift ; shift ;;
    --de            ) { if [[ $2 == ppa ]]; then DEVERSION='Install from PPA'   ; elif [[ $2 == repo ]]; then DEVERSION='Install from repo'   ; else DEVERSION=$2   ; fi ; } ; shift ; shift ;;
#   --delt          ) { if [[ $2 == ppa ]]; then DELTVERSION='Install from PPA' ; elif [[ $2 == repo ]]; then DELTVERSION='Install from repo' ; else DELTVERSION=$2 ; fi ; } ; shift ; shift ;;

    -d | --debug    ) DeBUG=1           ; shift ;;
    -s | --skip     ) SYSTEMCHECK=0     ; shift ;;
    -y | --yes      ) ForceYes=1        ; shift ;;

    --tr-skip       ) TRdefault=No      ; shift ;;
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
shanshuo=$(tput blink); wuguangbiao=$(tput civis); guangbiao=$(tput cnorm)
CW="${bold}${baihongse} ERROR ${jiacu}";ZY="${baihongse}${bold} ATTENTION ${jiacu}";JG="${baihongse}${bold} WARNING ${jiacu}" ; }
_colors
# --------------------------------------------------------------------------------
# 增加 swap
function _use_swap() { dd if=/dev/zero of=/root/.swapfile bs=1M count=1024  ;  mkswap /root/.swapfile  ;  swapon /root/.swapfile  ;  swapon -s  ;  }

# 关掉之前开的 swap
function _disable_swap() { swapoff /root/.swapfile  ;  rm -f /.swapfile ; }

# 用于退出脚本
export TOP_PID=$$
trap 'exit 1' TERM

# 判断是否在运行
function _if_running () { ps -ef | grep "$1" | grep -v grep > /dev/null && echo "${green}Running ${normal}" || echo "${red}Inactive${normal}" ; }

### 硬盘计算 ###
calc_disk() {
local total_size=0 ; local array=$@
for size in ${array[@]} ; do
    [ "${size}" == "0" ] && size_t=0 || size_t=`echo ${size:0:${#size}-1}`
    [ "`echo ${size:(-1)}`" == "K" ] && size=0
    [ "`echo ${size:(-1)}`" == "M" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' / 1024}' )
    [ "`echo ${size:(-1)}`" == "T" ] && size=$( awk 'BEGIN{printf "%.1f", '$size_t' * 1024}' )
    [ "`echo ${size:(-1)}`" == "G" ] && size=${size_t}
    total_size=$( awk 'BEGIN{printf "%.1f", '$total_size' + '$size'}' )
done ; echo ${total_size} ; }


### 操作系统检测 ###
get_opsy() { [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
[ -f /etc/os-release  ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
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
[[ $qb_installed == Yes ]] && qbtnox_ver=`qbittorrent-nox --version | awk '{print $2}' | sed "s/v//"`
[[ $de_installed == Yes ]] && deluged_ver=`deluged --version | grep deluged | awk '{print $2}'` && delugelt_ver=`  deluged --version | grep libtorrent | grep -Eo "[01].[0-9]+.[0-9]+"  `
[[ $rt_installed == Yes ]] && rtorrent_ver=`rtorrent -h | head -n1 | sed -ne 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\)[^0-9]*/\1/p'`
[[ $tr_installed == Yes ]] && trd_ver=`transmission-daemon --help | head -n1 | awk '{print $2}'` ; }

# --------------------------------------------------------------------------------
### 随机数 ###
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------

### 输入自己想要的软件版本 ###
function _inputversion() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the correct version${normal}"
read -ep "${bold}${yellow}Input the version you want: ${cyan}" inputversion; echo -n "${normal}" ; }

function _inputversionlt() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the correct version${normal}"
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

# 进度显示
spinner() {
    local pid=$1
    local delay=0.25
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [${bold}${yellow}%c${normal}]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
    echo -ne "${OK}"
}

# --------------------------------------------------------------------------------






# --------------------- 系统检查 --------------------- #
function _intro() {

clear

# 检查是否以 root 权限运行脚本
if [[ ! $DeBUG == 1 ]]; then if [[ $EUID != 0 ]]; then echo -e "\n${title}${bold}Navie! I think this young man will not be able to run this script without root privileges.${normal}\n" ; exit 1
else echo -e "\n${green}${bold}Excited! You're running this script as root. Let's make some big news ... ${normal}" ; fi ; fi

arch=$( uname -m ) # 架构，可以识别 ARM
lbit=$( getconf LONG_BIT ) # 只显示多少位，无法识别 ARM

# 检查是否为 x86_64 架构
[[ ! $arch == x86_64 ]] && { echo -e "${title}${bold}Too simple! Only x86_64 is supported${normal}" ; exit 1 ; }

# 检查系统版本；不是 Ubuntu 或 Debian 的就不管了，反正不支持……
SysSupport=0
DISTRO=`  awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release  `
DISTROL=`  echo $DISTRO | tr 'A-Z' 'a-z'  `
CODENAME=`  cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}'  `
[[ $DISTRO == Ubuntu ]] && osversion=`  grep Ubuntu /etc/issue | head -1 | grep -oE  "[0-9.]+"  `
[[ $DISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
[[ $CODENAME =~ (xenial|bionic|jessie|stretch) ]] && SysSupport=1
[[ $CODENAME =~        (wheezy|trusty)         ]] && SysSupport=2
[[ $DeBUG == 1 ]] && echo "${bold}DISTRO=$DISTRO, CODENAME=$CODENAME, osversion=$osversion, SysSupport=$SysSupport${normal}"

# 如果系统是 Debian 7 或 Ubuntu 14.04，询问是否升级到 Debian 8 / Ubuntu 16.04
[[ $SysSupport == 2 ]] && _ask_distro_upgrade

# rTorrent 是否只能安装 feature-bind branch 的 0.9.6 或者 0.9.7 及以上
[[ $CODENAME =~ (stretch|bionic) ]] && rtorrent_dev=1

# 检查本脚本是否支持当前系统，可以关闭此功能
[[ $SYSTEMCHECK == 1 ]] && [[ ! $distro_up == Yes ]] && _oscheck

# 装 wget 以防万一（虽然脚本一般情况下就是 wget 下来的……）
if [[ ! -n `command -v wget` ]]; then echo "${bold}Now the script is installing ${yellow}wget${jiacu} ...${normal}" ; apt-get install -y wget ; fi
[[ ! $? -eq 0 ]] && echo -e "${red}${bold}Failed to install wget, please check it and rerun once it is resolved${normal}\n" && kill -s TERM $TOP_PID



  echo -e "${bold}Checking your server's public IPv4 address ...${normal}"
# serveripv4=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )
# serveripv4=$( ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" )
  serveripv4=$( ip route get 8.8.8.8 | awk '{print $3}' )
  isInternalIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
  isValidIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T7 -qO- ipecho.net/plain )
  isValidIpAddress "$serveripv4" || { echo "${bold}${red}${shanshuo}ERROR ${jiacu}${underline}Failed to detect your public IPv4 address, use internal address instead${normal}" ; serveripv4=$( ip route get 8.8.8.8 | awk '{print $3}' ) ; }

  wget --no-check-certificate -t1 -T6 -qO- https://ipapi.co/json >~/ipapi 2>&1
  ccoodde=$( cat ~/ipapi | grep \"country\"      | awk -F '"' '{print $4}' ) 2>/dev/null
  country=$( cat ~/ipapi | grep \"country_name\" | awk -F '"' '{print $4}' ) 2>/dev/null
  regionn=$( cat ~/ipapi | grep \"region\"       | awk -F '"' '{print $4}' ) 2>/dev/null
  cityyyy=$( cat ~/ipapi | grep \"city\"         | awk -F '"' '{print $4}' ) 2>/dev/null
  isppppp=$( cat ~/ipapi | grep \"org\"          | awk -F '"' '{print $4}' ) 2>/dev/null
  asnnnnn=$( cat ~/ipapi | grep \"asn\"          | awk -F '"' '{print $4}' ) 2>/dev/null
  [[ $cityyyy == Singapore ]] && unset cityyyy
  [[ $isppppp == "" ]] && isp="No ISP detected"
  [[ $asnnnnn == "" ]] && isp="No ASN detected"
  rm -f ~/ipapi 2>&1

  echo "${bold}Checking your server's public IPv6 address ...${normal}"

  serveripv6=$( wget -t1 -T5 -qO- v6.ipv6-test.com/api/myip.php | grep -Eo "[0-9a-z:]+" | head -n1 )
# serveripv6=$( wget --no-check-certificate -qO- -t1 -T8 ipv6.icanhazip.com )

# 2018.10.10 重新启用对于网卡的判断。我忘了是出于什么原因我之前禁用了它？
[ -n "$(grep 'eth0:' /proc/net/dev)" ] && wangka=eth0 || wangka=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet|^he-ipv6|^docker' |awk 'NR==1 {print $0}'`
wangka=` ifconfig -a | grep -B 1 $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') | head -n1 | awk '{print $1}' | sed "s/:$//"  `
wangka=`  ip route get 8.8.8.8 | awk '{print $5}'  `
# serverlocalipv6=$( ip addr show dev $wangka | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | grep -v fe80 | head -n1 )




  echo -e "${bold}Checking your server's specification ...${normal}"

  kern=$( uname -r )

# Virt-what
  wget --no-check-certificate -qO /usr/local/bin/virt-what https://github.com/Aniverse/inexistence/raw/master/03.Files/app/virt-what
  mkdir -p /usr/lib/virt-what
  wget --no-check-certificate -qO /usr/lib/virt-what/virt-what-cpuid-helper https://github.com/Aniverse/inexistence/raw/master/03.Files/app/virt-what-cpuid-helper
  chmod +x /usr/local/bin/virt-what /usr/lib/virt-what/virt-what-cpuid-helper
  virtua="$(virt-what)" 2>/dev/null

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



  echo -e "${bold}Checking bittorrent clients' version ...${normal}"

  _check_install_2
  _client_version_check

  # 有可能出现刚开的机器没有 apt update，直接 apt-cache policy 提示找不到包的情况

  QB_repo_ver=` apt-cache policy qbittorrent-nox | grep -B1 http | grep -Eo "[234]\.[0-9.]+\.[0-9.]+" | head -n1 `
  [[ -z $QB_repo_ver ]] && { [[ $CODENAME == bionic ]] && QB_repo_ver=4.0.3 ; [[ $CODENAME == xenial ]] && QB_repo_ver=3.3.1 ; [[ $CODENAME == jessie ]] && QB_repo_ver=3.1.10 ; [[ $CODENAME == stretch ]] && QB_repo_ver=3.3.7 ; }
  QB_latest_ver=4.1.3
  QB_latest_ver=` wget -qO- https://github.com/qbittorrent/qBittorrent/releases | grep releases/tag | grep -Eo "[45]\.[0-9.]+" | head -n1 `

  DE_repo_ver=` apt-cache policy deluged | grep -B1 http | grep -Eo "[12]\.[0-9.]+\.[0-9.]+" | head -n1 `
  [[ -z $DE_repo_ver ]] && { [[ $CODENAME == bionic ]] && DE_repo_ver=1.3.15 ; [[ $CODENAME == xenial ]] && DE_repo_ver=1.3.12 ; [[ $CODENAME == jessie ]] && DE_repo_ver=1.3.10 ; [[ $CODENAME == stretch ]] && DE_repo_ver=1.3.13 ; }
  DE_latest_ver=1.3.15
  DE_latest_ver=` wget -qO- https://dev.deluge-torrent.org/wiki/ReleaseNotes | grep wiki/ReleaseNotes | grep -Eo "[12]\.[0-9.]+" | sed 's/">/ /' | awk '{print $1}' | head -n1 `

# DE_github_latest_ver=` wget -qO- https://github.com/deluge-torrent/deluge/releases | grep releases/tag | grep -Eo "[12]\.[0-9.]+.*" | sed 's/\">//' | head -n1 `

  TR_repo_ver=` apt-cache policy transmission-daemon | grep -B1 http | grep -Eo "[23]\.[0-9.]+" | head -n1 `
  [[ -z $TR_repo_ver ]] && { [[ $CODENAME == bionic ]] && TR_repo_ver=2.92 ; [[ $CODENAME == xenial ]] && TR_repo_ver=2.84 ; [[ $CODENAME == jessie ]] && TR_repo_ver=2.84 ; [[ $CODENAME == stretch ]] && TR_repo_ver=2.92 ; }
  TR_latest_ver=2.94
  TR_latest_ver=` wget -qO- https://github.com/transmission/transmission/releases | grep releases/tag | grep -Eo "[23]\.[0-9.]+" | head -n1 `


  clear

  wget --no-check-certificate -t1 -T5 -qO- https://raw.githubusercontent.com/Aniverse/inexistence/master/03.Files/inexistence.logo.1

  echo "${bold}---------- [System Information] ----------${normal}"
  echo

  echo -ne "  IPv4      : "
  if [[ "${serveripv4}" ]]; then
      echo "${cyan}$serveripv4${normal}"
  else
      echo "${cyan}No Public IPv4 Address Found${normal}"
  fi

  echo -ne "  IPv6      : "
  if [[ "${serveripv6}" ]]; then
      echo "${cyan}$serveripv6${normal}"
  else
      echo "${cyan}No IPv6 Address Found${normal}"
  fi

  echo -e  "  ASN & ISP : ${cyan}$asnnnnn, $isppppp${normal}"
  echo -ne "  Location  : ${cyan}"
  [[ ! $cityyyy == "" ]] && echo -ne "$cityyyy, "
  [[ ! $regionn == "" ]] && echo -ne "$regionn, "
  [[ ! $country == "" ]] && echo -ne "$country"
# [[ ! $ccoodde == "" ]] && echo -ne " / $ccoodde"
  echo -e  "${normal}"

  echo -e  "  CPU       : ${cyan}$CPUNum$cname${normal}"
  echo -e  "  Cores     : ${cyan}${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
  echo -e  "  Mem       : ${cyan}$tram MB ($uram MB Used)${normal}"
  echo -e  "  Disk      : ${cyan}$disk_total_size GB ($disk_used_size GB Used)${normal}"
  echo -e  "  OS        : ${cyan}$DISTRO $osversion $CODENAME ($arch) ${normal}"
  echo -e  "  Kernel    : ${cyan}$kern${normal}"
  echo -e  "  Script    : ${cyan}$INEXISTENCEDATE${normal}"

  echo -ne "  Virt      : "
  if [[ "${virtua}" ]]; then
      echo "${cyan}$virtua${normal}"
  else
      echo "${cyan}No Virtualization Detected${normal}"
  fi

[[ ! $SYSTEMCHECK == 1 ]] && echo -e "\n${bold}${red}System Checking Skipped. Note that this script may not work on unsupported system${normal}"

echo
echo -e "${bold}For more information about this script, please refer the README on GitHub"
echo -e "Press ${on_red}Ctrl+C${normal} ${bold}to exit${jiacu}, or press ${bailvse}ENTER${normal} ${bold}to continue" ; [[ ! $ForceYes == 1 ]] && read input

}






# --------------------- 询问是否升级系统 --------------------- #

function _ask_distro_upgrade() {

[[ $CODENAME == wheezy || $CODENAME == trusty ]] && echo -e "\nYou are now running ${cyan}${bold}$DISTRO $osversion${normal}, which is not supported by this script"
[[ $CODENAME == wheezy ]] && { UPGRADE_DISTRO_1="Debian 8"     ; UPGRADE_DISTRO_2="Debian 9"     ; UPGRADE_CODENAME_1=jessie ; UPGRADE_CODENAME_2=stretch ; }
[[ $CODENAME == trusty ]] && { UPGRADE_DISTRO_1="Ubuntu 16.04" ; UPGRADE_DISTRO_2="Ubuntu 18.04" ; UPGRADE_CODENAME_1=xenial ; UPGRADE_CODENAME_2=bionic  ; }
echo
echo -e "${green}01)${normal} Upgrade to ${cyan}$UPGRADE_DISTRO_1${normal} (Default)"
echo -e "${green}02)${normal} Upgrade to ${cyan}$UPGRADE_DISTRO_2${normal}"
echo -e "${green}03)${normal} Do NOT upgrade system and exit script"
echo -ne "${bold}${yellow}Would you like to upgrade your system?${normal} (Default ${cyan}01${normal}): " ; read -e responce

case $responce in
    01 | 1 | "") distro_up=Yes && UPGRADE_CODENAME=$UPGRADE_CODENAME_1  && UPGRADE_DISTRO=$UPGRADE_DISTRO_1                 ;;
    02 | 2     ) distro_up=Yes && UPGRADE_CODENAME=$UPGRADE_CODENAME_2  && UPGRADE_DISTRO=$UPGRADE_DISTRO_2 && UPGRDAE2=Yes ;;
    03 | 3     ) distro_up=No                                                                                               ;;
    *          ) distro_up=Yes && UPGRADE_CODENAME=$UPGRADE_CODENAME_2  && UPGRADE_DISTRO=$UPGRADE_DISTRO_1                 ;;
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
                    [nN] | [nN][Oo]          ) return 1 ;;
                    *                        ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
    esac
done ; }


# 生成随机密码，genln=密码长度
function genpasswd() { local genln=$1 ; [ -z "$genln" ] && genln=12 ; tr -dc A-Za-z0-9 < /dev/urandom | head -c ${genln} | xargs ; }


# 检查用户名的有效性，抄自：https://github.com/Azure/azure-devops-utils
function validate_username() {
  ANUSER="$1" ; local min=1 ; local max=32
  # This list is not meant to be exhaustive. It's only the list from here: https://docs.microsoft.com/azure/virtual-machines/linux/usernames
  local reserved_names=" adm admin audio backup bin cdrom crontab daemon dialout dip disk fax floppy fuse games gnats irc kmem landscape libuuid list lp mail man messagebus mlocate netdev news nobody nogroup operator plugdev proxy root sasl shadow src ssh sshd staff sudo sync sys syslog tape tty users utmp uucp video voice whoopsie www-data "
  if [ -z "$ANUSER" ]; then
      username_valid=empty
  elif [ ${#ANUSER} -lt $min ] || [ ${#username} -gt $max ]; then
      echo -e "${CW} The username must be between $min and $max characters${normal}"
      username_valid=false
  elif ! [[ "$ANUSER" =~ ^[a-z][-a-z0-9_]*$ ]]; then
      echo -e "${CW} The username must contain only lowercase letters, digits, underscores and starts with a letter${normal}"
      username_valid=false
  elif [[ "$reserved_names" =~ " $ANUSER " ]]; then
      echo -e "${CW} The username cannot be an Ubuntu reserved name${normal}"
      username_valid=false
  else
      username_valid=true
  fi
}



# 询问用户名
function _askusername(){ clear

validate_username $ANUSER

if [[ $username_valid == empty ]]; then

    echo -e "${bold}${yellow}The script needs a username${jiacu}"
    echo -e "This will be your primary user. It can be an existing user or a new user ${normal}"
    _input_username

elif [[ $username_valid == false ]]; then

  # echo -e "${JG} The preset username doesn't pass username check, please set a new username"
    _input_username

elif [[ $username_valid == true ]]; then

  # ANUSER=`  echo $ANUSER | tr 'A-Z' 'a-z'  `
    echo -e "${bold}Username sets to ${blue}$ANUSER${normal}\n"

fi ; }



# 录入用户名
function _input_username(){

local answerusername ; local reinput_name
confirm_name=false

while [[ $confirm_name == false ]]; do

    while [[ $answerusername = "" ]] || [[ $reinput_name = true ]] || [[ $username_valid = false ]]; do
        reinput_name=false
        read -ep "${bold}Enter username: ${blue}" answerusername ; echo -n "${normal}"
        validate_username $answerusername
    done

    addname=$answerusername
    echo -n "${normal}${bold}Confirm that username is ${blue}${addname}${normal}, ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o? "

    read answer
    case $answer in [yY] | [yY][Ee][Ss] | "" ) confirm_name=true ;;
                    [nN] | [nN][Oo]          ) reinput_name=true ;;
                    *                        ) echo "${bold}Please enter ${bold}${green}[Y]es${normal} or [${bold}${red}N${normal}]o";;
    esac

    ANUSER=$addname

done ; echo ; }






# 一定程度上的密码复杂度检测：https://stackoverflow.com/questions/36524872/check-single-character-in-array-bash-for-password-generator
# 询问密码。目前的复杂度判断还不够 Flexget 的程度，但总比没有强……

function _askpassword() {

local password1 ; local password2 ; #local exitvalue=0
exec 3>&1 >/dev/tty

if [[ $ANPASS = "" ]]; then

    echo "${bold}${yellow}The script needs a password, it will be used for Unix and WebUI${jiacu} "
    echo "The password must consist of characters and numbers and at least 8 chars,"
    echo "or you can leave it blank to generate a random password"

    while [ -z $localpass ]; do

      # echo -n "${bold}Enter the password: ${blue}" ; read -e password1
        read -ep "${jiacu}Enter the password: ${blue}" password1 ; echo -n "${normal}"

        if [ -z $password1 ]; then

            localpass=$(genpasswd) ; # exitvalue=1
            echo "${jiacu}Random password sets to ${blue}$localpass${normal}"

        # At least [8] chars long
        elif [ ${#password1} -lt 8 ]; then

            echo "${bold}${red}ERROR${normal} ${bold}Password must be at least ${red}[8]${jiacu} chars long${normal}" && continue

        # At least [1] number
        elif ! echo "$password1" | grep -q '[0-9]'; then

            echo "${bold}${red}ERROR${normal} ${bold}Password must have at least ${red}[1] number${normal}" && continue

        # At least [1] letter
        elif ! echo "$password1" | grep -q '[a-zA-Z]'; then

            echo "${bold}${red}ERROR${normal} ${bold}Password must have at least ${red}[1] letter${normal}" && continue

        else

            while [[ $password2 = "" ]]; do
                read -ep "${jiacu}Enter the new password again: ${blue}" password2 ; echo -n "${normal}"
            done

            if [ $password1 != $password2 ]; then
                echo "${bold}${red}WARNING${normal} ${bold}Passwords do not match${normal}" ; unset password2
            else
                localpass=$password1
            fi

        fi

    done

    ANPASS=$localpass
    exec >&3- ; echo ; # return $exitvalue

else

    echo -e "${bold}Password sets to ${blue}$ANPASS${normal}\n"

fi ; }





# --------------------- 询问安装前是否需要更换软件源 --------------------- #

function _askaptsource() {

while [[ $aptsources = "" ]]; do

#   read -ep "${bold}${yellow}Would you like to change sources list?${normal} [${cyan}Y${normal}]es or [N]o: " responce
    echo -ne "${bold}${yellow}Would you like to change sources list?${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss] | "" ) aptsources=Yes ;;
        [nN] | [nN][Oo]          ) aptsources=No ;;
        *                        ) aptsources=Yes ;;
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
        02 | 2     ) MAXCPUS=$(echo "$(nproc) / 2"|bc) ;;
        03 | 3     ) MAXCPUS=1 ;;
        04 | 4     ) MAXCPUS=2 ;;
        05 | 5     ) MAXCPUS=No ;;
        *          ) MAXCPUS=$(nproc) ;;
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
    echo -e "${green}11)${normal} qBittorrent ${cyan}4.0.4${normal}"
    echo -e "${green}12)${normal} qBittorrent ${cyan}4.1.0${normal}"
    echo -e "${green}13)${normal} qBittorrent ${cyan}4.1.1${normal}"
    echo -e "${green}14)${normal} qBittorrent ${cyan}4.1.2${normal}"
    echo -e "${green}15)${normal} qBittorrent ${cyan}4.1.3${normal}"
    echo -e "${green}30)${normal} Select another version"
    echo -e "${green}40)${normal} qBittorrent ${cyan}$QB_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} qBittorrent ${cyan}$QB_latest_ver${normal} from ${cyan}Stable PPA${normal}"
    echo -e   "${red}99)${normal} Do not install qBittorrent"

    [[ $qb_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}qBittorrent ${qbtnox_ver}${normal}"

   #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}02${normal}): " version
    echo -ne "${bold}${yellow}Which version of qBittorrent do you want?${normal} (Default ${cyan}15${normal}): " ; read -e version

    case $version in
        01 | 1) QBVERSION=3.3.7 ;;
        02 | 2) QBVERSION=3.3.11 ;;
        03 | 3) QBVERSION=3.3.14 ;;
        04 | 4) QBVERSION=3.3.16 ;;
        11) QBVERSION=4.0.4 ;;
        12) QBVERSION=4.1.0 ;;
        13) QBVERSION=4.1.1 ;;
        14) QBVERSION=4.1.2 ;;
        15) QBVERSION=4.1.3 ;;
        21) QBVERSION='3.3.11 (Skip hash check)' ;;
        22) QBVERSION=4.1.1.1 ;;
        30) _inputversion && QBVERSION="${inputversion}"  ;;
        40) QBVERSION='Install from repo' ;;
        50) QBVERSION='Install from PPA' ;;
        99) QBVERSION=No ;;
        * | "") QBVERSION=4.1.3 ;;
    esac

done


[[ $QBVERSION == '3.3.11 (Skip hash check)' ]] && QBPATCH=Yes


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

   #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}${dedefaultnum}${normal}): " version

    echo -ne "${bold}${yellow}Which version of Deluge do you want?${normal} (Default ${cyan}05${normal}): " ; read -e version

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
        21) DEVERSION='1.3.15 (Skip hash check)' ;;
        30) _inputversion && DEVERSION="${inputversion}"  ;;
        40) DEVERSION='Install from repo' ;;
        50) DEVERSION='Install from PPA' ;;
        99) DEVERSION=No ;;
        * | "") DEVERSION=1.3.15 ;;
    esac

done

[[ ` echo $DEVERSION | grep -oP "[0-9.]+" | awk -F '.' '{print $3}' ` -lt 11 ]] && DESSL=Yes
[[ $DEVERSION == '1.3.15 (Skip hash check)' ]] && DESKIP=Yes

if [[ $DEVERSION == No ]]; then

    echo "${baizise}Deluge will ${baihongse}not${baizise} be installed${normal}"
#   DELTVERSION=NoDeluge

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




# 2018.04.26 禁用这个问题，统一使用 1.0.11
# --------------------- 询问需要安装的 Deluge libtorrent 版本 --------------------- #
# DELTVERSION=$(  wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_1_" | sort -t _ -n -k 3 | tail -n1  )

function _askdelt() {

while [[ $DELTVERSION = "" ]]; do

    if [[ $DEVERSION == "Install from repo" ]]; then

        DELTVERSION='Install from repo' && DeLTDefault=1

    elif [[ $DEVERSION == "Install from PPA" ]]; then

        DELTVERSION='Install from PPA' && DeLTDefault=1

    else

        echo -e "${green}01)${normal} libtorrent-rasterbar ${cyan}1.0.11${normal}"
        echo -e "${green}02)${normal} libtorrent-rasterbar ${cyan}1.1.10 ${normal}"
        echo -e "${green}30)${normal} Select another version"
        echo -e "${green}40)${normal} libtorrent-rasterbar ${cyan}$PYLT_repo_ver${normal} from ${cyan}repo${normal}"
        [[ $DISTRO == Ubuntu ]] &&
        echo -e "${green}50)${normal} libtorrent-rasterbar ${cyan}$DELT_PPA_ver${normal} from ${cyan}Deluge PPA${normal}"
      # [[ $de_installed == Yes ]] &&
        echo -e "${red}99)${normal} Do not install libtorrent-rasterbar AGAIN"

        [[ $delugelt_ver ]] &&
        echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}libtorrent-rasterbar ${delugelt_ver}${reset_underline}${normal}"

        echo "${shanshuo}${baihongse}${bold} ATTENTION ${normal} ${blue}${bold}USE THE ${heihuangse}DEFAULT${normal}${blue}${bold} OPINION UNLESS YOU KNOW WHAT'S THIS${normal}"
      # echo -e "${bailanse}${bold} 注意！ ${normal} ${blue}${bold}如果你不知道这是什么玩意儿，请使用默认选项${normal}"

      # read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}01${normal}): " version
        echo -ne "${bold}${yellow}Which version of libtorrent do you want?${normal} (Default ${cyan}01${normal}): " ; read -e version

        case $version in
              01 | 1) DELTVERSION=1.0.11 && DeLTDefault=1 ;;
              02 | 2) DELTVERSION=RC_1_1 ;;
              03 | 3) DELTVERSION=RC_1_0 ;;
              30) _inputversionlt && DELTVERSION="${inputversion}" ;;
              40) DELTVERSION='Install from repo' ;;
              50) DELTVERSION='Install from PPA' ;;
              99) DELTVERSION=No ;;
              "" | *) DELTVERSION=1.0.11 && DeLTDefault=1 ;;
        esac

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
[[ $DELTVERSION == RC_0_16 ]] && DELTPKG=` wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-0_16_" | sort -t _ -n -k 3 | tail -n1 | sed "s/_/\./g" | sed "s/libtorrent-//" `
[[ $DELTVERSION == RC_1_0  ]] && DELTPKG=` wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_0_" | sort -t _ -n -k 3 | tail -n1 | sed "s/_/\./g" | sed "s/libtorrent-//" `
[[ $DELTVERSION == RC_1_1  ]] && DELTPKG=` wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_1_" | sort -t _ -n -k 3 | tail -n1 | sed "s/_/\./g" | sed "s/libtorrent-//" `
[[ $DELTVERSION == 1.0.11  ]] && DELTPKG=1.0.11

    if [[ $DELTVERSION == "Install from repo" ]]; then

       echo "${bold}${baiqingse}libtorrent-rasterbar $PYLT_repo_ver${normal} ${bold}will be installed from repository${normal}"

    elif [[ $DELTVERSION == "Install from PPA" ]]; then

        echo "${baiqingse}${bold}libtorrent-rasterbar $DELT_PPA_ver${normal} ${bold}will be installed from Deluge PPA${normal}"

    elif [[ $DELTVERSION == No ]]; then

        echo "${baiqingse}${bold}libtorrent-rasterbar ${delugelt_ver}${normal}${bold} will be used from system${normal}"

    else

        echo "${baiqingse}${bold}libtorrent-rasterbar ${DELTPKG}${normal} ${bold}will be installed${normal}"

    fi

echo ; }





# --------------------- 询问需要安装的 rTorrent 版本 --------------------- #

function _askrt() {

while [[ $RTVERSION = "" ]]; do

    [[ ! $rtorrent_dev == 1 ]] &&
    echo -e "${green}01)${normal} rTorrent ${cyan}0.9.2${normal}" &&
    echo -e "${green}02)${normal} rTorrent ${cyan}0.9.3${normal}" &&
    echo -e "${green}03)${normal} rTorrent ${cyan}0.9.4${normal}" &&
    echo -e "${green}04)${normal} rTorrent ${cyan}0.9.6${normal} (released on Sep 04, 2015)" &&
    echo -e "${green}11)${normal} rTorrent ${cyan}0.9.2${normal} (with IPv6 support)" &&
    echo -e "${green}12)${normal} rTorrent ${cyan}0.9.3${normal} (with IPv6 support)" &&
    echo -e "${green}13)${normal} rTorrent ${cyan}0.9.4${normal} (with IPv6 support)"
    echo -e "${green}14)${normal} rTorrent ${cyan}0.9.6${normal} (feature-bind branch on Jan 30, 2018)"
    echo -e "${green}15)${normal} rTorrent ${cyan}0.9.7${normal} (with IPv6 support)"
    echo -e   "${red}99)${normal} Do not install rTorrent"

    [[ $rt_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}You have already installed ${underline}rTorrent ${rtorrent_ver}${normal}"
#   [[ $rt_installed == Yes ]] && echo -e "${bold}If you want to downgrade or upgrade rTorrent, use ${blue}rtupdate${normal}"

    if [[ $rtorrent_dev == 1 ]]; then

        echo "${bold}${red}Note that${normal} ${bold}${green}Debian 9${jiacu} and ${green}Ubuntu 18.04 ${jiacu}is only supported by ${green}rTorrent 0.9.6 and later${normal}"
       #read -ep "${bold}${yellow}Which version do you want?${normal} (Default ${cyan}04${normal}): " version
        echo -ne "${bold}${yellow}Which version of rTorrent do you want?${normal} (Default ${cyan}14${normal}): " ; read -e version

        case $version in
            14) RTVERSION='0.9.6 IPv6 supported' ;;
            15) RTVERSION=0.9.7 ;;
            99) RTVERSION=No ;;
            "" | *) RTVERSION='0.9.6 IPv6 supported' ;;
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
            15) RTVERSION=0.9.7 ;;
            99) RTVERSION=No ;;
            "" | *) RTVERSION=0.9.4 ;;
        esac

    fi

done

[[ $IPv6Opt == -i ]] && RTVERSION=`echo $RTVERSION IPv6 supported`
[[ `echo $RTVERSION | grep IPv6` ]] && IPv6Opt=-i
[[ $RTVERSION == 0.9.7 ]] && IPv6Opt=-i
RTVERSIONIns=`echo $RTVERSION | grep -Eo [0-9].[0-9].[0-9]`

if [[ $RTVERSION == No ]]; then

    echo "${baizise}rTorrent will ${baihongse}not${baizise} be installed${normal}"
    InsFlood='No rTorrent'

else

    if [[ `echo $RTVERSION | grep IPv6 | grep -Eo 0.9.[234]` ]]; then

        echo "${bold}${baiqingse}rTorrent $RTVERSIONIns (with UNOFFICAL IPv6 support)${normal} ${bold}will be installed${normal}"

    elif [[ $RTVERSION == '0.9.6 IPv6 supported' ]]; then

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

    [[ ! $CODENAME == bionic ]] &&
    echo -e "${green}01)${normal} Transmission ${cyan}2.77${normal}" &&
    echo -e "${green}02)${normal} Transmission ${cyan}2.82${normal}" &&
    echo -e "${green}03)${normal} Transmission ${cyan}2.84${normal}" &&
    echo -e "${green}04)${normal} Transmission ${cyan}2.92${normal}"
    echo -e "${green}05)${normal} Transmission ${cyan}2.93${normal}"
    echo -e "${green}06)${normal} Transmission ${cyan}2.94${normal}"
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
            06 | 6) TRVERSION=2.94 ;;
            11) TRVERSION=2.92 && TRdefault=No ;;
            12) TRVERSION=2.93 && TRdefault=No ;;
            13) TRVERSION=2.94 && TRdefault=No ;;
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

    echo -e "${green}01)${normal} VNC  with xfce4"
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
    echo "${bold}${baiqingse}VNC${jiacu} and ${baiqingse}xfce4${jiacu} will be installed${normal}"
elif [[ $InsRDP == X2Go ]]; then
    echo "${bold}${baiqingse}X2Go${normal} and ${bold}${baiqingse}xfce4${jiacu} will be installed${normal}"
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
    echo "${bold}${baiqingse}Wine${jiacu} and ${baiqingse}mono${jiacu} will be installed${normal}"
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
    echo "${bold}${baiqingse}Latest version of these softwares${jiacu} will be installed${normal}"
else
    echo "${baizise}These softwares will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }





# --------------------- BBR 相关 --------------------- #

# 检查是否已经启用BBR、BBR 魔改版
function check_bbr_status() { tcp_control=$(cat /proc/sys/net/ipv4/tcp_congestion_control)
if [[ $tcp_control =~ (bbr|bbr_powered|nanqinlang|tsunami) ]]; then bbrinuse=Yes ; else bbrinuse=No ; fi ; }

# 检查理论上内核是否支持原版 BBR
function version_ge(){ test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1" ; }
function check_kernel_version() { kernel_vvv=$(uname -r | cut -d- -f1)
if version_ge $kernel_vvv 4.9  ; then bbrkernel=Yes ; else bbrkernel=No ; fi }

# [[ ` ls /lib/modules/\$(uname -r)/kernel/net/ipv4 | grep tcp_bbr.ko ` ]]

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
                *                        ) InsBBR=To\ be\ enabled ;;
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

    # 主要是考虑到使用 opt 的情况
   [[ $InsBBR == Yes ]] && [[ $bbrkernel == Yes ]] && InsBBR=To\ be\ enabled

    if [[ $InsBBR == Yes ]]; then
        echo "${bold}${baiqingse}TCP BBR${normal} ${bold}will be installed${normal}"
    elif [[ $InsBBR == To\ be\ enabled ]]; then
        echo "${bold}${baiqingse}TCP BBR${normal} ${bold}will be enabled${normal}"
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
if [[ $ForceYes == 1 ]];then reboot || echo "WTF, try reboot manually?" ; else read -e is_reboot ; fi
if [[ $is_reboot == "y" || $is_reboot == "Y" ]]; then reboot
else echo -e "${bold}Reboot has been canceled...${normal}\n" ; fi ; }






# --------------------- 输出所用时间 --------------------- #

function _time() {
endtime=$(date +%s)
timeused=$(( $endtime - $starttime ))
if [[ $timeused -gt 60 && $timeused -lt 3600 ]]; then
    timeusedmin=$(expr $timeused / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e " ${baiqingse}${bold}The $timeWORK took about ${timeusedmin} min ${timeusedsec} sec${normal}"
elif [[ $timeused -ge 3600 ]]; then
    timeusedhour=$(expr $timeused / 3600)
    timeusedmin=$(expr $(expr $timeused % 3600) / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e " ${baiqingse}${bold}The $timeWORK took about ${timeusedhour} hour ${timeusedmin} min ${timeusedsec} sec${normal}"
else
    echo -e " ${baiqingse}${bold}The $timeWORK took about ${timeused} sec${normal}"
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
# [[ ! $DEVERSION == No ]] &&
# echo "                  ${cyan}${bold}libtorrent${normal}    ${bold}${yellow}${DELTVERSION}${normal}"
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
    adduser --gecos "" ${ANUSER} --disabled-password --force-badname
    echo "${ANUSER}:${ANPASS}" | sudo chpasswd
fi

export TZ="/usr/share/zoneinfo/Asia/Shanghai"

cat>>/etc/inexistence/01.Log/installed.log<<EOF
如果要截图请截完整点，包含下面所有信息
CPU        : $cname"
Cores      : ${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)"
Mem        : $tram MB ($uram MB Used)"
Disk       : $disk_total_size GB ($disk_used_size GB Used)
OS         : $DISTRO $osversion $CODENAME ($arch)
Kernel     : $kern
ASN & ISP  : $asnnnnn, $isppppp
Location   : $cityyyy, $regionn, $country
#################################
INEXISTENCEVER=${INEXISTENCEVER}
INEXISTENCEDATE=${INEXISTENCEDATE}
SETUPDATE=$(date "+%Y.%m.%d.%H.%M.%S")
MAXDISK=$(df -k | sort -rn -k4 | awk '{print $1}' | head -1)
HOMEUSER=$(ls /home)
#################################
MAXCPUS=${MAXCPUS}
APTSOURCES=${aptsources}
QBVERSION=${QBVERSION}
DEVERSION=${DEVERSION}
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
如果要截图请截完整点，包含上面所有信息
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
mkdir -p /var/www/h5ai

# For Wine DVDFab10
mkdir -p /root/Documents/DVDFab10/BDInfo
ln -s /root/Documents/DVDFab10/BDInfo /etc/inexistence/08.BDinfo/DVDFab

ln -s /etc/inexistence /var/www/h5ai/inexistence
ln -s /etc/inexistence /home/${ANUSER}/inexistence
cp -f "${local_packages}"/script/* /usr/local/bin ; }





# --------------------- 替换系统源 --------------------- #

function _setsources() {

# rm /var/lib/dpkg/updates/*
# rm -rf /var/lib/apt/lists/partial/*
# apt-get -y upgrade

[[ $USESWAP == Yes ]] && _use_swap

if [[ $aptsources == Yes ]]; then

    cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
    wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/$DISTROL.apt.sources
    sed -i "s/RELEASE/${CODENAME}/g" /etc/apt/sources.list
    [[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
    apt-get -y update

else

    apt-get -y update

fi

# _checkrepo1 2>&1 | tee /etc/00.checkrepo1.log
# _checkrepo2 2>&1 | tee /etc/00.checkrepo2.log

dpkg --configure -a
apt-get -f -y install

package_list="figlet toilet lolcat ruby tree
gcc automake make gawk build-essential checkinstall python
screen git sudo zsh curl nano zip unzip lrzsz rsync bc locales aptitude ntpdate
software-properties-common python-software-properties apt-transport-https ca-certificates
dstat sysstat vnstat vmstat htop iotop smartmontools virt-what lsb-release iperf3 speedtest-cli mtr wondershaper uuid"

# for package_name in $package_list ; do
#     if [ $(apt-cache show -q=0 $package_name 2>&1 | grep -c "No packages found") -eq 0 ]; then
#         if [ $(dpkg-query -W -f='${Status}' $package_name 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
#             install_list="$install_list $package_name"
#         fi
#     else
#         echo "$package_name not found, skipping"
#     fi
# done

# test -z "$install_list" || apt-get -y install $install_list

# 其实很多包可能对于很多人没用，私货私货……
apt-get install -y \
screen git sudo zsh virt-what lsb-release curl python lrzsz locales aptitude gawk jq bc \
speedtest-cli mtr iperf iperf3 wondershaper \
htop atop iotop dstat sysstat vnstat smartmontools psmisc dirmngr \
ca-certificates apt-transport-https gcc make checkinstall build-essential \
tree figlet toilet lolcat zip unzip ntpdate ruby uuid rsync socat

if [ ! $? = 0 ]; then
    echo -e "\n${baihongse}${shanshuo}${bold} ERROR ${normal} ${red}${bold}Failed to install packages, please check it and rerun once it is resolved${normal}\n"
    kill -s TERM $TOP_PID
    exit 1
fi

echo -e "${bailvse}\n\n\n  STEP-ONE-COMPLETED  \n\n${normal}"

# apt-get remove --purge -y libgnutls-deb0-28

sed -i "s/TRANSLATE=1/TRANSLATE=0/g" /etc/checkinstallrc >/dev/null 2>&1
# sed -i "s/ACCEPT_DEFAULT=0/ACCEPT_DEFAULT=1/g" /etc/checkinstallrc

}





# --------------------- 升级系统 --------------------- #
# https://serverfault.com/questions/48724/100-non-interactive-debian-dist-upgrade

function _distro_upgrade_upgrade() {
echo -e "\n\n\n${baihongse}executing upgrade${normal}\n\n\n"
apt-get --force-yes -o Dpkg::Options::="--force-confnew" --force-yes -o Dpkg::Options::="--force-confdef" -fuy upgrade

echo -e "\n\n\n${baihongse}executing dist-upgrade${normal}\n\n\n"
apt-get --force-yes -o Dpkg::Options::="--force-confnew" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade ; }




function _distro_upgrade() {

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

starttime=$(date +%s)

# apt-get -f install

echo -e "\n${baihongse}executing apt-listchanges remove${normal}\n"
apt-get remove apt-listchanges --assume-yes --force-yes

echo 'libc6 libraries/restart-without-asking boolean true' | debconf-set-selections

echo -e "${baihongse}executing apt sources change${normal}\n"
sed -i "s/$CODENAME/$UPGRADE_CODENAME/g" /etc/apt/sources.list

echo -e "${baihongse}executing autoremove${normal}\n"
apt-get -fuy --force-yes autoremove

echo -e "${baihongse}executing clean${normal}\n"
apt-get --force-yes clean



echo -e "${baihongse}executing update${normal}\n"
cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y.%m.%d.%H.%M.%S")".bak
wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/$DISTROL.apt.sources
[[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117

if [[ $UPGRDAE2 == Yes ]]; then
    sed -i "s/RELEASE/${UPGRADE_CODENAME_1}/g" /etc/apt/sources.list
    apt-get -y update
    _distro_upgrade_upgrade
    sed -i "s/${UPGRADE_CODENAME_1}/${UPGRADE_CODENAME_2}/g" /etc/apt/sources.list
    apt-get -y update
else
    sed -i "s/RELEASE/${UPGRADE_CODENAME}/g" /etc/apt/sources.list
    apt-get -y update
fi

_distro_upgrade_upgrade

timeWORK=upgradation
echo -e "\n\n\n" ; _time

[[ ! $DeBUG == 1 ]] && echo -e "\n\n ${shanshuo}${baihongse}Reboot system now. You need to rerun this script after reboot${normal}\n\n\n\n\n"

sleep 5
reboot -f
init 6

sleep 5
kill -s TERM $TOP_PID
exit 0 ; }







# --------------------- 编译安装 libtorrent-rasterbar --------------------- #

function _compile_lt() {

[[ `dpkg -l | grep libtorrent-rasterbar-dev` ]] && apt-get purge -y libtorrent-rasterbar-dev
[[ `dpkg -l | grep python-libtorrent` ]] && apt-get purge -y python-libtorrent
apt-get -y autoremove

cd /etc/inexistence/00.Installation/MAKE

DELTVERSION=RC_1_0
DELTPKG=1.0.11

# 安装依赖 
apt-get install -y                                                                  \
build-essential pkg-config autoconf automake libtool git checkinstall               \
libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev \
geoip-database libgeoip-dev                                                         \
libboost-python-dev

git clone --depth=1 -b $DELTVERSION --single-branch https://github.com/arvidn/libtorrent libtorrent-$DELTPKG
cd libtorrent-$DELTPKG

# 修改源码，不然 C++11 编译完后 Deluge 无法使用
sed -i "s/+ target_specific(),/+ target_specific() + ['-std=c++11'],/" bindings/python/setup.py

./autotool.sh
./configure --enable-python-binding --with-libiconv \
            --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++11 # 第一行是 Deluge 的参数，第二行是 qBittorrent 的参数
make -j${MAXCPUS}

mkdir -p doc-pak
cat >description-pak<<EOF
an efficient feature complete C++ bittorrent implementation
EOF

checkinstall -y --pkgname=libtorrent-rasterbar-seedbox --pkggroup libtorrent --pkgversion $DELTPKG
cp -f libtorrent-rasterb*.deb /etc/inexistence/01.Log/INSTALLATION/packages

cd ; ldconfig ; }








# --------------------- 使用 deb 包安装 libtorrent-rasterbar --------------------- #

function _install_lt_deb_1011() {

cd /etc/inexistence/00.Installation/MAKE

# 安装依赖 
apt-get install -y                                                                  \
build-essential pkg-config autoconf automake libtool git checkinstall               \
libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev \
geoip-database libgeoip-dev                                                         \
libboost-python-dev                                                                 \
zlib1g-dev

if [[ $CODENAME == jessie ]]; then
    wget --no-check-certificate https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deb%20Package/Jessie/libtorrent-rasterbar_1.0.11_jessie_amd64.deb -qO lt.deb
elif [[ $CODENAME == xenial ]]; then
    wget --no-check-certificate https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deb%20Package/Xenial/libtorrent-rasterbar_1.0.11_xenial_amd64.deb -qO lt.deb
elif [[ $CODENAME == stretch ]]; then
    wget --no-check-certificate https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deb%20Package/Stretch/libtorrent-rasterbar_1.0.11_stretch_amd64.deb -qO lt.deb
elif [[ $CODENAME == bionic ]]; then
    wget --no-check-certificate https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deb%20Package/Bionic/libtorrent-rasterbar-seedbox_1.0.11_bionic_amd64.deb -qO lt.deb
fi

dpkg -i lt.deb && rm -rf lt.deb

cd ; ldconfig ; }








# --------------------- 编译安装 qBittorrent --------------------- #

function _installqbt() {

if [[ $QBVERSION == "Install from repo" ]]; then

    apt-get install -y qbittorrent-nox
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

elif [[ $QBVERSION == "Install from PPA" ]]; then

    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
    apt-get update
    apt-get install -y qbittorrent-nox
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

else

    # 使用 deb 包安装 libtorrent-rasterbar 1.0.11
    _install_lt_deb_1011

    [[ `  dpkg -l | grep -v qbittorrent-headless | grep qbittorrent-nox  ` ]] && apt-get purge -y qbittorrent-nox

    if [[ $CODENAME == jessie ]]; then

        apt-get purge -y qtbase5-dev qttools5-dev-tools libqt5svg5-dev
        apt-get autoremove -y
        apt-get install -y libgl1-mesa-dev

        wget --no-check-certificate -qO qt_5.5.1-1_amd64_debian8.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Other%20Tools/qt_5.5.1-1_amd64_debian8.deb
        dpkg -i qt_5.5.1-1_amd64_debian8.deb

        export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/Qt-5.5.1/lib/pkgconfig
        export PATH=/usr/local/Qt-5.5.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        qmake --version | tee -a /etc/inexistence/01.Log/installed.log

    else

        apt-get install -y qtbase5-dev qttools5-dev-tools libqt5svg5-dev

    fi

    cd /etc/inexistence/00.Installation/MAKE
    [[ -d qBittorrent ]] && mv -f qBittorrent.old.$(date "+%Y.%m.%d.%H.%M.%S")
    git clone https://github.com/qbittorrent/qBittorrent

    cd qBittorrent
    QBVERSION=`echo $QBVERSION | grep -oE [0-9.]+`
    git checkout release-$QBVERSION

    if [[ $QBVERSION == 4.1.2 ]]; then
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        git cherry-pick 262c3a7
        echo -e "\n\n\nQB 4.1.2 WebUI Fix (FOR LOG)\n\n\n"
    fi

    # 这是 qBittorrent master 分支 merge pr #9375 #8217 以后，把版本号从 4.2.0.alpha 改成了 4.1.1
    # 等官方 merge 都不知道要啥时候了，用着也没啥问题，自己先用用吧……
    if [[ $QBVERSION == 4.1.1.1 ]]; then
        cd ..
        git clone --depth=1 https://github.com/Aniverse/qbt411master
        cd qbt411master
    fi

    if [[ $QBPATCH == Yes ]]; then
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        git cherry-pick db3158c
        git cherry-pick b271fa9 # WebUI 跳过校验
        git cherry-pick 1ce71fc # 显示 IO 状况
        echo -e "\n\n\nQB 3.3.11 SKIP HASH CHECK (FOR LOG)\n\n\n"
    fi
    
    ./configure --prefix=/usr --disable-gui

    make -j$MAXCPUS

    mkdir -p doc-pak
    cat >description-pak<<EOF
qBittorrent BitTorrent client headless (qbittorrent-nox)
EOF

    if [[ $qb_installed == Yes ]]; then
        make install
    else
      # [[ /usr/bin/qbittorrent-nox ]] && mv -f /usr/bin/qbittorrent-nox /usr/bin/qbittorrent-nox.old
        checkinstall -y --pkgname=qbittorrent-headless --pkgversion=$QBVERSION --pkggroup qbittorrent
        mv -f qbittorrent*deb /etc/inexistence/01.Log/INSTALLATION/packages
    fi

    cd
    echo -e "${bailvse}\n\n\n\n\n  QBITTORRENT-INSTALLATION-COMPLETED  \n\n\n\n${normal}"

fi ; }






# --------------------- 下载安装 qBittorrent --------------------- #

function _installqbt2() { git clone --depth=1 https://github.com/Aniverse/qBittorrent-nox /etc/iFeral/qb ; chmod -R +x /etc/iFeral/qb ; }







# --------------------- 设置 qBittorrent --------------------- #

function _setqbt() {

[[ -d /root/.config/qBittorrent ]] && { rm -rf /root/.config/qBittorrent.old ; mv /root/.config/qBittorrent /root/.config/qBittorrent.old ; }
# [[ -d /home/${ANUSER}/.config/qBittorrent ]] && rm -rf /home/${ANUSER}/qbittorrent.old && mv /home/${ANUSER}/.config/qBittorrent /root/.config/qBittorrent.old
mkdir -p /home/${ANUSER}/qbittorrent/{download,torrent,watch} /var/www /root/.config/qBittorrent  #/home/${ANUSER}/.config/qBittorrent
chmod -R 777 /home/${ANUSER}/qbittorrent
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/qbittorrent  #/home/${ANUSER}/.config/qBittorrent
chmod -R 666 /etc/inexistence/01.Log  #/home/${ANUSER}/.config/qBittorrent
rm -rf /var/www/h5ai/qbittorrent
ln -s /home/${ANUSER}/qbittorrent/download /var/www/h5ai/qbittorrent
# chown www-data:www-data /var/www/h5ai/qbittorrent

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

touch /etc/inexistence/01.Log/qbittorrent.log

systemctl daemon-reload
systemctl enable qbittorrent
systemctl start qbittorrent
# systemctl enable qbittorrent@${ANUSER}
# systemctl start qbittorrent@${ANUSER}

touch /etc/inexistence/01.Log/lock/qbittorrent.lock ; }






# --------------------- 安装 Deluge --------------------- #

function _installde() {

if [[ $DEVERSION == "Install from repo" ]]; then

    apt-get install -y deluge deluged deluge-web deluge-console deluge-gtk 

elif [[ $DEVERSION == "Install from PPA" ]]; then

    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:deluge-team/ppa
    apt-get update
    apt-get install -y --allow-change-held-packages --allow-downgrades libtorrent-rasterbar8 python-libtorrent
    # 写两次是为了防止以后 Deluge PPA 升级后指定版本无效（不过其实我可以设定检测版本的，暂时懒得搞了）
    # 指定版本是为了在同时启用 Deluge 和 qBittorrent PPA 的情况下使用 libtorrent-rasterbar 1.0.11，毕竟 Deluge 1.3.15 对 libtorrent 1.1 支持还不完善
    apt-get install -y --allow-change-held-packages --allow-downgrades libtorrent-rasterbar8=1.0.11-1~xenial~ppa1.1 python-libtorrent=1.0.11-1~xenial~ppa1.1
    apt-mark hold libtorrent-rasterbar8 python-libtorrent
    apt-get install -y deluge deluged deluge-web deluge-console deluge-gtk 

else

    # 使用 deb 包安装 libtorrent-rasterbar 1.0.11
    _install_lt_deb_1011

    # 安装 Deluge 依赖
    apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako

    cd /etc/inexistence/00.Installation/MAKE

    if [[ $DESKIP == Yes ]]; then
        export DEVERSION=1.3.15
        wget --no-check-certificate -O deluge-$DEVERSION.tar.gz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deluge/deluge-$DEVERSION.skip.tar.gz
        echo -e "\n\n\nDELUGE SKIP HASH CHECK (FOR LOG)\n\n\n"
    else
        wget --no-check-certificate http://download.deluge-torrent.org/source/deluge-$DEVERSION.tar.gz
    fi

    tar xf deluge-$DEVERSION.tar.gz
    rm -f deluge-$DEVERSION.tar.gz
    cd deluge-$DEVERSION

    ### 修复稍微新一点的系统（比如 Debian 8）下 RPC 连接不上的问题。这个问题在 Deluge 1.3.11 上已解决
    ### http://dev.deluge-torrent.org/attachment/ticket/2555/no-sslv3.diff
    ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.9/deluge/core/rpcserver.py
    ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.11/deluge/core/rpcserver.py

    if [[ $DESSL == Yes ]]; then
        sed -i "s/SSL.SSLv3_METHOD/SSL.SSLv23_METHOD/g" deluge/core/rpcserver.py
        sed -i "/        ctx = SSL.Context(SSL.SSLv23_METHOD)/a\        ctx.set_options(SSL.OP_NO_SSLv2 & SSL.OP_NO_SSLv3)" deluge/core/rpcserver.py
        echo -e "\n\nSSL FIX (FOR LOG)\n\n"
        python setup.py build  > /dev/null
        python setup.py install --install-layout=deb  > /dev/null
        mv -f /usr/bin/deluged /usr/bin/deluged2
        wget --no-check-certificate http://download.deluge-torrent.org/source/deluge-1.3.15.tar.gz
        tar xf deluge-1.3.15.tar.gz && rm -f deluge-1.3.15.tar.gz && cd deluge-1.3.15
    fi

    python setup.py build  > /dev/null
    python setup.py install --install-layout=deb  > /dev/null # 输出太长了，省略大部分，反正也不重要
    python setup.py install_data # 给桌面环境用的

    [[ $DESSL == Yes ]] && mv -f /usr/bin/deluged2 /usr/bin/deluged # 让老版本 Deluged 保留，其他用新版本

fi

cd ; echo -e "${bailanse}\n\n\n\n  DELUGE-INSTALLATION-COMPLETED  \n\n\n${normal}" ; }





# --------------------- Deluge 启动脚本、配置文件 --------------------- #

function _setde() {

# [[ -d /home/${ANUSER}/.config/deluge ]] && rm-rf /home/${ANUSER}/.config/deluge.old && mv /home/${ANUSER}/.config/deluge /root/.config/deluge.old
mkdir -p /home/${ANUSER}/deluge/{download,torrent,watch} /var/www
rm -rf /var/www/h5ai/deluge
ln -s /home/${ANUSER}/deluge/download /var/www/h5ai/deluge
# chown www-data:www-data /var/www/h5ai/deluge
chmod -R 777 /home/${ANUSER}/deluge  #/home/${ANUSER}/.config
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/deluge  #/home/${ANUSER}/.config

touch /etc/inexistence/01.Log/deluged.log /etc/inexistence/01.Log/delugeweb.log
chmod -R 666 /etc/inexistence/01.Log

# mkdir -p /home/${ANUSER}/.config  && cd /home/${ANUSER}/.config && rm -rf deluge
# cp -f -r "${local_packages}"/template/config/deluge /home/${ANUSER}/.config
mkdir -p /root/.config && cd /root/.config
[[ -d /root/.config/deluge ]] && { rm -rf /root/.config/deluge.old ; mv /root/.config/deluge /root/.config/deluge.old ; }
cp -f "${local_packages}"/template/config/deluge.config.tar.gz /root/.config/deluge.config.tar.gz
tar zxf deluge.config.tar.gz
chmod -R 666 /root/.config
rm -rf deluge.config.tar.gz ; cd

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

# Deluge update-tracker，用于 AutoDL-Irssi
deluged_ver_2=`deluged --version | grep deluged | awk '{print $2}'`
deluged_port=$( grep daemon_port /root/.config/deluge/core.conf | grep -oP "\d+" )

cp "${local_packages}"/script/special/update-tracker.py /usr/lib/python2.7/dist-packages/deluge-$deluged_ver_2-py2.7.egg/deluge/ui/console/commands/update-tracker.py
sed -i "s/ANUSER/$ANUSER/g" /usr/local/bin/deluge-update-tracker
sed -i "s/ANPASS/$ANPASS/g" /usr/local/bin/deluge-update-tracker
sed -i "s/DAEMONPORT/$deluged_port/g" /usr/local/bin/deluge-update-tracker
chmod +x /usr/lib/python2.7/dist-packages/deluge-$deluged_ver_2-py2.7.egg/deluge/ui/console/commands/update-tracker.py /usr/local/bin/deluge-update-tracker

touch /etc/inexistence/01.Log/lock/deluge.lock ; }





# --------------------- 使用修改版 rtinst 安装 rTorrent, ruTorrent，h5ai, vsftpd --------------------- #

function _installrt() {

bash -c "$(wget --no-check-certificate -qO- https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup)"

# [[ $DeBUG == 1 ]] && echo $IPv6Opt && echo $RTVERSIONIns

sed -i "s/make\ \-s\ \-j\$(nproc)/make\ \-s\ \-j${MAXCPUS}/g" /usr/local/bin/rtupdate

if [[ $rt_installed == Yes ]]; then
    rtupdate $IPv6Opt $RTVERSIONIns
else
    rtinst --ssh-default --ftp-default --rutorrent-master --force-yes --log $IPv6Opt -v $RTVERSIONIns -u $ANUSER -p $ANPASS -w $ANPASS
fi

# rtwebmin
# openssl req -x509 -nodes -days 3650 -subj /CN=$serveripv4 -config /etc/ssl/ruweb.cnf -newkey rsa:2048 -keyout /etc/ssl/private/ruweb.key -out /etc/ssl/ruweb.crt

[[ -e /etc/php5/fpm/php.ini ]] && sed -i 's/^.*memory_limi.*/memory_limit = 512M/' /etc/php5/fpm/php.ini
[[ -e /etc/php/7.0/fpm/php.ini ]] && sed -i 's/^.*memory_limit.*/memory_limit = 512M/' /etc/php/7.0/fpm/php.ini
[[ -e /etc/php/7.2/fpm/php.ini ]] && sed -i 's/^.*memory_limit.*/memory_limit = 512M/' /etc/php/7.2/fpm/php.ini

mv /root/rtinst.log /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log
mv /home/${ANUSER}/rtinst.info /etc/inexistence/01.Log/INSTALLATION/07.rtinst.info.txt
ln -s /home/${ANUSER} /var/www/h5ai/user.folder

cp -f "${local_packages}"/template/systemd/rtorrent@.service /etc/systemd/system/rtorrent@.service
cp -f "${local_packages}"/template/systemd/irssi@.service /etc/systemd/system/irssi@.service

touch /etc/inexistence/01.Log/lock/rtorrent.lock
cd ; echo -e "${baihongse}\n\n\n\n\n  RT-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }






# --------------------- Preparation for rtorrent_fast_resume.pl --------------------- #
function _rt_fast_resume() {
cd ; wget http://search.cpan.org/CPAN/authors/id/I/IW/IWADE/Convert-Bencode_XS-0.06.tar.gz
wget https://rt.cpan.org/Ticket/Attachment/1433449/761974/patch-t_001_tests_t
tar xf Convert-Bencode_XS-0.06.tar.gz
cd Convert-Bencode_XS-0.06
patch -uNp0 -i ../patch-t_001_tests_t
perl Makefile.PL
make ; make install ; cd
rm -rf Convert-Bencode_XS-0.06 Convert-Bencode_XS-0.06.tar.gz patch-t_001_tests_t ; }





# --------------------- 安装 Node.js 与 flood --------------------- #

function _installflood() {

bash <(curl -sL https://deb.nodesource.com/setup_9.x)
apt-get install -y nodejs build-essential python-dev
npm install -g node-gyp
git clone --depth=1 https://github.com/jfurrow/flood.git /srv/flood
cd /srv/flood
cp config.template.js config.js
npm install
sed -i "s/127.0.0.1/0.0.0.0/" /srv/flood/config.js

npm run build 2>&1 | tee /tmp/flood.log
rm -rf /etc/inexistence/01.Log/lock/flood.fail.lock
# [[ `grep "npm ERR!" /tmp/flood.log` ]] && touch /etc/inexistence/01.Log/lock/flood.fail.lock

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

  # [[ `dpkg -l | grep transmission-daemon` ]] && apt-get purge -y transmission-daemon

    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev ca-certificates libssl-dev pkg-config checkinstall cmake git # > /dev/null
    apt-get install -y openssl
    [[ $CODENAME == stretch ]] && apt-get install -y libssl1.0-dev # https://tieba.baidu.com/p/5532509017?pn=2#117594043156l

    cd /etc/inexistence/00.Installation/MAKE
    wget --no-check-certificate -O release-2.1.8-stable.tar.gz https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
    tar xf release-2.1.8-stable.tar.gz ; rm -rf release-2.1.8-stable.tar.gz
    mv libevent-release-2.1.8-stable libevent-2.1.8
    cd libevent-2.1.8
    ./autogen.sh
    ./configure
    make -j$MAXCPUS

    checkinstall -y --pkgversion=2.1.8 --pkgname=libevent --pkggroup libevent # make install
    ldconfig                                                                  # ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib/libevent-2.1.so.6
    cd ..

    if [[ $TRdefault == No ]]; then
        wget --no-check-certificate -O transmission-$TRVERSION.tar.gz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/TransmissionMod/transmission-$TRVERSION.tar.gz
        tar xf transmission-$TRVERSION.tar.gz ; rm -f transmission-$TRVERSION.tar.gz
        cd transmission-$TRVERSION
    else
        git clone https://github.com/transmission/transmission transmission-$TRVERSION
        cd transmission-$TRVERSION
        git checkout $TRVERSION
        # 修复 Transmission 2.92 无法在 Ubuntu 18.04 下编译的问题（openssl 1.1.0），https://github.com/transmission/transmission/pull/24
        [[ $TRVERSION == 2.92 ]] && { git config --global user.email "you@example.com" ; git config --global user.name "Your Name" ; git cherry-pick eb8f500 -m 1 ; }
        # 修复 2.93 以前的版本可能无法过 configure 的问题，https://github.com/transmission/transmission/pull/215
        [[ ! `grep m4_copy_force m4/glib-gettext.m4 ` ]] && sed -i "s/m4_copy/m4_copy_force/g" m4/glib-gettext.m4
        # 解决 Transmission 2.9X 版本文件打开数被限制到 1024 的问题，https://github.com/transmission/transmission/issues/309
        # [[ `grep FD_SETSIZE=1024 CMakeLists.txt ` ]] && sed -i "s/FD_SETSIZE=1024/FD_SETSIZE=777777/g" CMakeLists.txt
        # 经测试发现没啥卵用，还是不改了 ……
    fi

    ./autogen.sh
    ./configure --prefix=/usr

    mkdir -p doc-pak
    cat >description-pak<<EOF
A fast, easy, and free BitTorrent client
EOF
    make -j$MAXCPUS

  # dpkg -r transmission
    if [[ $tr_installed == Yes ]]; then
        make install
    else
        checkinstall -y --pkgversion=$TRVERSION --pkgname=transmission-seedbox --pkggroup transmission
        mv -f tr*deb /etc/inexistence/01.Log/INSTALLATION/packages
    fi

fi

cd ; echo -e "${baizise}\n\n\n\n\n  TR-INSTALLATION-COMPLETED  \n\n\n\n${normal}" ; }





# --------------------- 配置 Transmission --------------------- #

function _settr() {

echo 1 | bash -c "$(wget --no-check-certificate -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control.sh)"

# [[ -d /home/${ANUSER}/.config/transmission-daemon ]] && rm -rf /home/${ANUSER}/.config/transmission-daemon.old && mv /home/${ANUSER}/.config/transmission-daemon /home/${ANUSER}/.config/transmission-daemon.old
[[ -d /root/.config/transmission-daemon ]] && rm -rf /root/.config/transmission-daemon.old && mv /root/.config/transmission-daemon /root/.config/transmission-daemon.old

mkdir -p /home/${ANUSER}/transmission/{download,torrent,watch} /var/www /root/.config/transmission-daemon  #/home/${ANUSER}/.config/transmission-daemon
chmod -R 777 /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/transmission  #/home/${ANUSER}/.config/transmission-daemon
rm -rf /var/www/h5ai/transmission
ln -s /home/${ANUSER}/transmission/download /var/www/h5ai/transmission
# chown -R www-data:www-data /var/www/h5ai

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
  pip install --upgrade pip setuptools
  /usr/local/bin/pip install markdown
  /usr/local/bin/pip install flexget
# /usr/local/bin/pip install flexget==2.16.2
  /usr/local/bin/pip install transmissionrpc

  mkdir -p /home/${ANUSER}/{transmission,qbittorrent,rtorrent,deluge}/{download,watch} /root/.config/flexget   #/home/${ANUSER}/.config/flexget

  cp -f "${local_packages}"/template/config/flexget.config.yml /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
  sed -i "s/SCRIPTUSERNAME/${ANUSER}/g" /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
  sed -i "s/SCRIPTPASSWORD/${ANPASS}/g" /root/.config/flexget/config.yml  #/home/${ANUSER}/.config/flexget/config.yml
# chmod -R 666 /home/${ANUSER}/.config/flexget
# chown -R ${ANUSER}:${ANUSER} /home/${ANUSER}/.config/flexget

  touch /home/$ANUSER/cookies.txt

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
apt-get install -y nload fuse p7zip-full
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
if [[ $bbrinuse == Yes ]]; then
    sleep 0
elif [[ $bbrkernel == Yes && $bbrinuse == No ]]; then
    _enable_bbr
else
    _online_ubuntu_bbr_firmware
    _bbr_kernel_4_11_12
    _enable_bbr
fi
echo -e "${bailvse}\n\n\n  BBR-INSTALLATION-COMPLETED  \n\n${normal}" ; }

# 安装 4.11.12 的内核
function _bbr_kernel_4_11_12() {

if [[ $CODENAME == stretch ]]; then
    [[ ! `dpkg -l | grep libssl1.0.0` ]] && { echo -ne "\n  {bold}Installing libssl1.0.0 ...${normal} "
    echo -e "\ndeb http://ftp.hk.debian.org/debian jessie main\c" >> /etc/apt/sources.list
    apt-get update
    apt-get install -y libssl1.0.0
    sed  -i '/deb http:\/\/ftp\.hk\.debian\.org\/debian jessie main/d' /etc/apt/sources.list
    apt-get update ; }
else
    [[ ! `dpkg -l | grep libssl1.0.0` ]] && { echo -ne "\n  ${bold}Installing libssl1.0.0 ...${normal} "  ; apt-get install -y libssl1.0.0 ; }
fi

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
        if [[ $CODENAME == bionic ]]; then # 暂时没有 Ubuntu 18.04 的源，只能手动加 17.10 的了
            echo "deb https://dl.winehq.org/wine-builds/ubuntu/ artful main" > /etc/apt/sources.list.d/wine.list
        else
            apt-get install -y software-properties-common
            apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/
        fi
    elif [[ $DISTRO == Debian ]]; then
        echo "deb https://dl.winehq.org/wine-builds/${DISTROL}/ ${CODENAME} main" > /etc/apt/sources.list.d/wine.list
    fi

    apt-get update -y
    apt-get install -y --install-recommends winehq-stable

fi

wget --no-check-certificate -q https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
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
cd ; wget --no-check-certificate -qO ffmpeg-4.0.2-64bit-static.tar.xz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Other%20Tools/ffmpeg-4.0.2-64bit-static.tar.xz
tar xf ffmpeg-4.0.2-64bit-static.tar.xz
rm -rf ffmpeg-*bit-static/{manpages,presets,model,readme.txt,GPLv3.txt}
cp -f ffmpeg-*-64bit-static/* /usr/bin
chmod 755 /usr/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
rm -rf ffmpeg-*-64bit-static*

########## 安装 新版 mkvtoolnix 与 mediainfo ##########

wget --no-check-certificate -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -
echo "deb https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" > /etc/apt/sources.list.d/mkvtoolnix.list
echo "deb-src https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" >> /etc/apt/sources.list.d/mkvtoolnix.list

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

# 修改时区
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
ntpdate time.windows.com
hwclock -w


# screen 设置
cat>>/etc/screenrc<<EOF
shell -$SHELL

startup_message off
defutf8 on
defencoding utf8  
encoding utf8 utf8 
defscrollback 23333
EOF


# 设置编码与alias

# sed -i '$d' /etc/bash.bashrc

[[ `grep "Inexistence Mod" /etc/bash.bashrc` ]] && sed -i -n -e :a -e '1,148!{P;N;D;};N;ba' /etc/bash.bashrc

# 以后这堆私货另外处理吧，以后。上边那个检测也应该要改下

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

function gclone(){ git clone --depth=1 \$1 && cd \$(echo \${1##*/}) ;}
io_test() { (LANG=C dd if=/dev/zero of=test_\$\$ bs=64k count=16k conv=fdatasync && rm -f test_\$\$ ) 2>&1 | awk -F, '{io=\$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*\$//' ; }
iotest() { io1=\$( io_test ) ; echo -e "\n\${bold}硬盘 I/O (第一次测试) : \${yellow}\$io1\${normal}"
io2=\$( io_test ) ; echo -e "\${bold}硬盘 I/O (第二次测试) : \${yellow}\$io2\${normal}" ; io3=\$( io_test ) ; echo -e "\${bold}硬盘 I/O (第三次测试) : \${yellow}\$io3\${normal}\n" ; }

wangka=` ip route get 8.8.8.8 | awk '{print $5}' | head -n1 `

ulimit -SHn 999999

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

alias qba="systemctl start qbittorrent"
alias qbb="systemctl stop qbittorrent"
alias qbc="systemctl status qbittorrent"
alias qbr="systemctl restart qbittorrent"
alias qbl="tail -n300 /etc/inexistence/01.Log/qbittorrent.log"
alias qbs="nano /root/.config/qBittorrent/qBittorrent.conf"
alias dea="systemctl start deluged"
alias deb="systemctl stop deluged"
alias dec="systemctl status deluged"
alias der="systemctl restart deluged"
alias del="grep -v TotalTraffic /etc/inexistence/01.Log/deluged.log | grep -v 'Successfully loaded' | grep -v 'Saving the state' | tail -n300"
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
alias fga="systemctl start flexget"
alias fgaa="flexget daemon start --daemonize"
alias fgb="systemctl stop flexget"
alias fgc="systemctl status flexget"
alias fgcc="flexget daemon status"
alias fgr="systemctl restart flexget"
alias fgrr="flexget daemon reload-config"
alias fgl="echo ; tail -n300 /root/.config/flexget/flexget.log ; echo"
alias fgs="nano /root/.config/flexget/config.yml"
alias fgcheck="flexget check"
alias fge="flexget execute"
alias fla="systemctl start flood"
alias flb="systemctl stop flood"
alias flc="systemctl status flood"
alias flr="systemctl restart flood"
alias ssra="/etc/init.d/shadowsocks-r start"
alias ssrb="/etc/init.d/shadowsocks-r stop"
alias ssrc="/etc/init.d/shadowsocks-r status"
alias ssrr="/etc/init.d/shadowsocks-r restart"
alias ruisua="/appex/bin/serverSpeeder.sh start"
alias ruisub="/appex/bin/serverSpeeder.sh stop"
alias ruisuc="/appex/bin/serverSpeeder.sh status"
alias ruisur="/appex/bin/serverSpeeder.sh restart"
alias ruisus="nano /etc/serverSpeeder.conf"
alias nginxr="/etc/init.d/nginx restart"

alias yongle="du -sB GB"
alias rtyongle="du -sB GB /home/${ANUSER}/rtorrent/download"
alias qbyongle="du -sB GB /home/${ANUSER}/qbittorrent/download"
alias deyongle="du -sB GB /home/${ANUSER}/deluge/download"
alias tryongle="du -sB GB /home/${ANUSER}/transmission/download"
alias cdde="cd /home/${ANUSER}/deluge/download"
alias cdqb="cd /home/${ANUSER}/qbittorrent/download"
alias cdrt="cd /home/${ANUSER}/rtorrent/download"
alias cdtr="cd /home/${ANUSER}/transmission/download"
alias cdin="cd /etc/inexistence/"
alias cdrut="cd /var/www/rutorrent"

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

alias cesu="echo;spdtest --share;echo"
alias cesu2="echo;spdtest --share --server"
alias cesu3="echo;spdtest --list 2>&1 | head -n30 | grep --color=always -P '(\d+)\.(\d+)\skm|(\d+)(?=\))';echo"
alias ios="iostat -dxm 1"
alias vms="vmstat 1 10"
alias vns="vnstat -l -i $wangka"
alias vnss="vnstat -m && vnstat -d"

alias sousuo="find / -name"
alias sousuo2="find /home/${ANUSER} -name"
alias enableswap="dd if=/dev/zero of=/root/.swapfile bs=1M count=1024;mkswap /root/.swapfile;swapon /root/.swapfile;swapon -s"
alias disableswap="swapoff /root/.swapfile;rm -f /.swapfile"

alias yuan="nano /etc/apt/sources.list"
alias cronr="/etc/init.d/cron restart"
alias sshr="sed -i '/.*AllowGroups.*/d' /etc/ssh/sshd_config ; sed -i '/.*PasswordAuthentication.*/d' /etc/ssh/sshd_config ; sed -i '/.*PermitRootLogin.*/d' /etc/ssh/sshd_config ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config ; /etc/init.d/ssh restart  >/dev/null 2>&1 && echo -e '\n已开启 root 登陆\n'"

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
echo "fs.file-max = 1048576" >> /etc/sysctl.conf
echo "fs.nr_open = 1048576" >> /etc/sysctl.conf

sed -i '/.*nofile.*/'d /etc/security/limits.conf
sed -i '/.*nproc.*/'d /etc/security/limits.conf

cat>>/etc/security/limits.conf<<EOF
* - nofile 1048575
* - nproc 1048575
root soft nofile 1048574
root hard nofile 1048574
$ANUSER hard nofile 1048573
$ANUSER soft nofile 1048573

EOF

sed -i '/^DefaultLimitNOFILE.*/'d /etc/systemd/system.conf
sed -i '/^DefaultLimitNPROC.*/'d /etc/systemd/system.conf
echo "DefaultLimitNOFILE=999998" >> /etc/systemd/system.conf
echo "DefaultLimitNPROC=999998" >> /etc/systemd/system.conf

# 将最大的分区的保留空间设置为 0%
echo `df -k | sort -rn -k4 | awk '{print $1}' | head -1`
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

unset INSFAILED QBFAILED TRFAILED DEFAILED RTFAILED FDFAILED FXFAILED

#if [[ ! $RTVERSION == No ]]; then RTWEB="/rt" ; TRWEB="/tr" ; DEWEB="/de" ; QBWEB="/qb" ; sss=s ; else RTWEB="/rutorrent" ; TRWEB=":9099" ; DEWEB=":8112" ; QBWEB=":2017" ; fi

RTWEB="/rutorrent" ; TRWEB=":9099" ; DEWEB=":8112" ; QBWEB=":2017"
FXWEB=":6566" ; FDWEB=":3000"

if [[ `  ps -ef | grep deluged | grep -v grep ` ]] && [[ `  ps -ef | grep deluge-web | grep -v grep ` ]] ; then destatus="${green}Running ${normal}" ; else destatus="${red}Inactive${normal}" ; fi


# systemctl is-active flexget 其实不准，flexget daemon status 输出结果太多种……
# [[ $(systemctl is-active flexget) == active ]] && flexget_status="${green}Running ${normal}" || flexget_status="${red}Inactive${normal}"

flexget daemon status 2>1 >> /tmp/flexgetpid.log # 这个速度慢了点但应该最靠谱
[[ `grep PID /tmp/flexgetpid.log` ]] && flexget_status="${green}Running  ${normal}" || flexget_status="${red}Inactive ${normal}"
[[ -e /etc/inexistence/01.Log/lock/flexget.pass.lock ]] && flexget_status="${bold}${bailanse}CheckPass${normal}"
[[ -e /etc/inexistence/01.Log/lock/flexget.conf.lock ]] && flexget_status="${bold}${bailanse}CheckConf${normal}"
Installation_FAILED="${bold}${baihongse} ERROR ${normal}"

clear

echo -e " ${baiqingse}${bold}      INSTALLATION COMPLETED      ${normal} \n"
echo '---------------------------------------------------------------------------------'


if   [[ ! $QBVERSION == No ]] && [[ $qb_installed == Yes ]]; then
     echo -e " ${cyan}qBittorrent WebUI${normal}   $(_if_running qbittorrent-nox    )   http${sss}://${serveripv4}${QBWEB}"
elif [[ ! $QBVERSION == No ]] && [[ $qb_installed == No ]]; then
     echo -e " ${red}qBittorrent WebUI${normal}   ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     QBFAILED=1 ; INSFAILED=1
fi


if   [[ ! $DEVERSION == No ]] && [[ $de_installed == Yes ]]; then
     echo -e " ${cyan}Deluge WebUI${normal}        $destatus   http${sss}://${serveripv4}${DEWEB}"
elif [[ ! $DEVERSION == No ]] && [[ $de_installed == No ]]; then
     echo -e " ${red}Deluge WebUI${normal}        ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     DEFAILED=1 ; INSFAILED=1
fi


if   [[ ! $TRVERSION == No ]] && [[ $tr_installed == Yes ]]; then
     echo -e " ${cyan}Transmission WebUI${normal}  $(_if_running transmission-daemon)   http${sss}://${ANUSER}:${ANPASS}@${serveripv4}${TRWEB}"
elif [[ ! $TRVERSION == No ]] && [[ $tr_installed == No ]]; then
     echo -e " ${red}Transmission WebUI${normal}  ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     TRFAILED=1 ; INSFAILED=1
fi


if   [[ ! $RTVERSION == No ]] && [[ $rt_installed == Yes ]]; then
     echo -e " ${cyan}RuTorrent${normal}           $(_if_running rtorrent           )   https://${ANUSER}:${ANPASS}@${serveripv4}${RTWEB}"
     [[ $InsFlood == Yes ]] && [[ ! -e /etc/inexistence/01.Log/lock/flood.fail.lock ]] && 
     echo -e " ${cyan}Flood${normal}               $(_if_running npm                )   http://${serveripv4}${FDWEB}"
     [[ $InsFlood == Yes ]] && [[   -e /etc/inexistence/01.Log/lock/flood.fail.lock ]] &&
     echo -e " ${red}Flood${normal}               ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}" && { INSFAILED=1 ; FDFAILED=1 ; }
     echo -e " ${cyan}h5ai File Indexer${normal}   $(_if_running nginx              )   https://${ANUSER}:${ANPASS}@${serveripv4}/h5ai"
   # echo -e " ${cyan}webmin${normal}              $(_if_running webmin             )   https://${serveripv4}/webmin"
elif [[ ! $RTVERSION == No ]] && [[ $rt_installed == No  ]]; then
     echo -e " ${red}RuTorrent${normal}           ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     [[ $InsFlood == Yes ]] && [[ ! -e /etc/inexistence/01.Log/lock/flood.fail.lock ]] &&
     echo -e " ${cyan}Flood${normal}               $(_if_running npm                )   http://${serveripv4}${FDWEB}"
     [[ $InsFlood == Yes ]] && [[   -e /etc/inexistence/01.Log/lock/flood.fail.lock ]] &&
     echo -e " ${red}Flood${normal}               ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}" && FDFAILED=1
   # echo -e " ${cyan}h5ai File Indexer${normal}   $(_if_running webmin             )   https://${ANUSER}:${ANPASS}@${serveripv4}/h5ai"
     RTFAILED=1 ; INSFAILED=1
fi

# flexget 状态可能是 8 位字符长度的
if   [[ ! $InsFlex == No ]] && [[ $flex_installed == Yes ]]; then
     echo -e " ${cyan}Flexget WebUI${normal}       $flexget_status  http://${serveripv4}${FXWEB}" #${bold}(username is ${underline}flexget${reset_underline}${normal})
elif [[ ! $InsFlex == No ]] && [[ $flex_installed == No  ]]; then
     echo -e " ${red}Flexget WebUI${normal}       ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     FXFAILED=1 ; INSFAILED=1
fi


#    echo -e " ${cyan}MkTorrent WebUI${normal}            https://${ANUSER}:${ANPASS}@${serveripv4}/mktorrent"


echo
echo -e " ${cyan}Your Username${normal}       ${bold}${ANUSER}${normal}"
echo -e " ${cyan}Your Password${normal}       ${bold}${ANPASS}${normal}"
[[ ! $InsFlex == No ]] && [[ $flex_installed == Yes ]] &&
echo -e " ${cyan}Flexget Login${normal}       ${bold}flexget${normal}"
[[ $InsRDP == VNC ]] && [[ $CODENAME == xenial ]] &&
echo -e " ${cyan}VNC  Password${normal}       ${bold}` echo ${ANPASS} | cut -c1-8` ${normal}"
# [[ $DeBUG == 1 ]] && echo "FlexConfFail=$FlexConfFail  FlexPassFail=$FlexPassFail"
[[ -e /etc/inexistence/01.Log/lock/flexget.pass.lock ]] &&
echo -e "\n ${bold}${bailanse} Naive! ${normal} You need to set Flexget WebUI password by typing \n          ${bold}flexget web passwd <new password>${normal}"
[[ -e /etc/inexistence/01.Log/lock/flexget.conf.lock ]] &&
echo -e "\n ${bold}${bailanse} Naive! ${normal} You need to check your Flexget config file\n          maybe your password is too young too simple?${normal}"

echo '---------------------------------------------------------------------------------'
echo

timeWORK=installation
_time

    if [[ ! $INSFAILED == "" ]]; then
echo -e "\n ${bold}Unfortunately something went wrong during installation.
 You can check logs by typing these commands:
 ${yellow}cat /etc/inexistence/01.Log/installed.log"
[[ ! $QBFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/05.qb1.log" #&& echo "QBLTCFail=$QBLTCFail   QBCFail=$QBCFail"
[[ ! $DEFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/03.de1.log" #&& echo "DELTCFail=$DELTCFail"
[[ ! $TRFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/08.tr1.log"
[[ ! $RTFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/07.rt.log\n cat /etc/inexistence/01.Log/INSTALLATION/07.rtinst.script.log"
[[ ! $FDFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/07.flood.log"
[[ ! $FXFAILED == "" ]] && echo -e " cat /etc/inexistence/01.Log/INSTALLATION/10.flexget.log"
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
# [[ ! $DEVERSION == No ]] && 
# _askdelt
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

DELTVERSION=1.0.11

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


if   [[ $InsBBR == Yes ]] || [[ $InsBBR == To\ be\ enabled ]]; then
     echo -ne "Configuring BBR ... \n\n\n" ; _install_bbr 2>&1 | tee /etc/inexistence/01.Log/INSTALLATION/02.bbr.log
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




