#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
# --------------------------------------------------------------------------------
usage() {
bash <(curl -s https://raw.githubusercontent.com/Aniverse/inexistence/master/inexistence.sh)
}

tmp_1() {
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
}
# --------------------------------------------------------------------------------
SYSTEMCHECK=1
DeBUG=0
script_lang=eng
INEXISTENCEVER=1.1.0.3
INEXISTENCEDATE=2019.04.17
# --------------------------------------------------------------------------------



# 获取参数

OPTS=$(getopt -n "$0" -o dsyu:p:b: --long "branch,yes,tr-skip,skip,debug,apt-yes,apt-no,swap-yes,swap-no,bbr-yes,bbr-no,flood-yes,flood-no,rdp-vnc,rdp-x2go,rdp-no,wine-yes,wine-no,tools-yes,tools-no,flexget-yes,flexget-no,rclone-yes,rclone-no,enable-ipv6,tweaks-yes,tweaks-no,mt-single,mt-double,mt-max,mt-half,skip-apps,eng,chs,user:,password:,webpass:,de:,delt:,qb:,rt:,tr:,lt:" -- "$@")

eval set -- "$OPTS"

while true; do
  case "$1" in
    -u | --user     ) iUser=$2       ; shift ; shift ;;
    -p | --password ) iPass=$2       ; shift ; shift ;;
    -b | --branch   ) iBranch=$2     ; shift ; shift ;;

    --qb            ) { if [[ $2 == ppa ]]; then qb_version='Install from PPA'   ; elif [[ $2 == repo ]]; then qb_version='Install from repo'   ; else qb_version=$2   ; fi ; } ; shift ; shift ;;
    --tr            ) { if [[ $2 == ppa ]]; then tr_version='Install from PPA'   ; elif [[ $2 == repo ]]; then tr_version='Install from repo'   ; else tr_version=$2   ; fi ; } ; shift ; shift ;;
    --de            ) { if [[ $2 == ppa ]]; then de_version='Install from PPA'   ; elif [[ $2 == repo ]]; then de_version='Install from repo'   ; else de_version=$2   ; fi ; } ; shift ; shift ;;
    --rt            ) rt_version=$2 ; shift ; shift ;;
    --lt            ) lt_version=$2 ; shift ; shift ;;

    -d | --debug    ) DeBUG=1           ; shift ;;
    -s | --skip     ) SYSTEMCHECK=0     ; shift ;;
    -y | --yes      ) ForceYes=1        ; shift ;;

    --eng           ) script_lang=eng   ; shift ;;
    --chs           ) script_lang=chs   ; shift ;;
    --skip-apps     ) SKIPAPPS="Yes"    ; shift ;;
    --tr-skip       ) TRdefault="No"    ; shift ;;
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

if [ $# -gt 0 ]; then
  echo "No arguments allowed $1 is not a valid argument"
  exit 1
fi

if [[ $DeBUG == 1 ]]; then
    iUser=aniverse ; aptsources=No ; MAXCPUS=$(nproc)
fi

[[ -z $iBranch ]] && iBranch=master
iBranch
times=$(cat /log/inexistence/iUser.txt 2>/dev/null | wc -l)
times=$(expr $time + 1)
# --------------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export local_packages=/etc/inexistence/00.Installation
export LogBase=/log/inexistence
export LogTimes=$LogBase/$times
export SourceLocation=$LogTimes/source
export DebLocation=$LogTimes/deb
export LogLocation=$LogTimes/install
export LockLocation=$LogBase/lock
# 临时
# 一个想法，脚本传入到单个脚本里一个参数 log-base，比如装 de 脚本的 log 位置：
# log-base=/log/inexistence/$times, SourceLocation=$log-base/source
# bash deluge/configure -u aniverse -p test20190416 --dport 58856 --wport 8112 -iport 22022 --logbase /log/inexistence/$times
# --------------------------------------------------------------------------------
### 颜色样式 ###
function _colors() {
black=$(tput setaf 0)   ; red=$(tput setaf 1)          ; green=$(tput setaf 2)   ; yellow=$(tput setaf 3);  bold=$(tput bold)   ; jiacu=${normal}${bold}
blue=$(tput setaf 4)    ; magenta=$(tput setaf 5)      ; cyan=$(tput setaf 6)    ; white=$(tput setaf 7) ;  normal=$(tput sgr0)
on_black=$(tput setab 0); on_red=$(tput setab 1)       ; on_green=$(tput setab 2); on_yellow=$(tput setab 3)
on_blue=$(tput setab 4) ; on_magenta=$(tput setab 5)   ; on_cyan=$(tput setab 6) ; on_white=$(tput setab 7)
shanshuo=$(tput blink)  ; wuguangbiao=$(tput civis)    ; guangbiao=$(tput cnorm)
underline=$(tput smul)  ; reset_underline=$(tput rmul) ; dim=$(tput dim)
standout=$(tput smso)   ; reset_standout=$(tput rmso)  ; title=${standout}
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue} ; bailvse=${white}${on_green}
baiqingse=${white}${on_cyan}   ; baihongse=${white}${on_red} ; baizise=${white}${on_magenta}
heibaise=${black}${on_white}   ; heihuangse=${on_yellow}${black}
CW="${bold}${baihongse} ERROR ${jiacu}";ZY="${baihongse}${bold} ATTENTION ${jiacu}";JG="${baihongse}${bold} WARNING ${jiacu}" ; }
_colors
# --------------------------------------------------------------------------------
# 增加 swap
function _use_swap() { dd if=/dev/zero of=/root/.swapfile bs=1M count=2048  ;  mkswap /root/.swapfile  ;  swapon /root/.swapfile  ;  swapon -s  ;  }

# 关掉之前开的 swap
function _disable_swap() { swapoff /root/.swapfile  ;  rm -f /root/.swapfile ; }

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

function version_ge(){ test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1" ; }

function _check_install_2(){
for apps in qbittorrent-nox deluged rtorrent transmission-daemon flexget rclone irssi ffmpeg mediainfo wget wine mono; do
    client_name=$apps ; _check_install_1
done ; }

function _client_version_check(){
[[ $qb_installed == Yes ]] && qbtnox_ver=$( qbittorrent-nox --version 2>&1 | awk '{print $2}' | sed "s/v//" )
[[ $de_installed == Yes ]] && deluged_ver=$( deluged --version 2>&1 | grep deluged | awk '{print $2}' ) && delugelt_ver=$( deluged --version 2>&1 | grep libtorrent | grep -Eo "[01].[0-9]+.[0-9]+" )
[[ $rt_installed == Yes ]] && rtorrent_ver=$( rtorrent -h 2>&1 | head -n1 | sed -ne 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\)[^0-9]*/\1/p' )
[[ $tr_installed == Yes ]] && trd_ver=$( transmission-daemon --help 2>&1 | head -n1 | awk '{print $2}' )
find /usr/lib -name libtorrent-rasterbar* 2>/dev/null | grep -q libtorrent-rasterbar && lt_exist=yes
lt_ver=$( pkg-config --exists --print-errors "libtorrent-rasterbar >= 3.0.0" 2>&1 | awk '{print $NF}' | grep -oE [0-9]+.[0-9]+.[0-9]+ )
lt_ver_qb3_ok=No ; [[ ! -z $lt_ver ]] && version_ge $lt_ver 1.0.6 && lt_ver_qb3_ok=Yes
lt_ver_de2_ok=No ; [[ ! -z $lt_ver ]] && version_ge $lt_ver 1.1.3 && lt_ver_de2_ok=Yes ; }

# --------------------------------------------------------------------------------
### 随机数 ###
function _string() { perl -le 'print map {(a..z,A..Z,0..9)[rand 62] } 0..pop' 15 ; }
# --------------------------------------------------------------------------------

### 输入自己想要的软件版本 ###
# ${blue}(use it at your own risk)${normal}
function _input_version() {
if [[ $script_lang == eng ]]; then
echo -e "\n${JG} ${bold}Use it at your own risk and make sure to input version correctly${normal}"
read -ep "${bold}${yellow}Input the version you want: ${cyan}" input_version_num; echo -n "${normal}"
elif [[ $script_lang == chs ]]; then
echo -e "\n${JG} ${bold}确保你输入的版本号能用，不然输错了脚本也不管的${normal}"
read -ep "${bold}${yellow}输入你想要的版本号： ${cyan}" input_version_num; echo -n "${normal}"
fi ; }

function _input_version_lt() {
echo -e "\n${baihongse}${bold} ATTENTION ${normal} ${bold}Make sure to input the correct version${normal}"
echo -e "${red}${bold} Here is a list of all the available versions${normal}\n"
# wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | pr -3 -t ; echo
rm -f $HOME/lt.git.tag
git ls-remote --tags  https://github.com/arvidn/libtorrent | awk -F'[/]' '{print $3}' >  $HOME/lt.git.tag
git ls-remote --heads https://github.com/arvidn/libtorrent | awk -F'[/]' '{print $3}' >> $HOME/lt.git.tag
cat $HOME/lt.git.tag | pr -3 -t
rm -f $HOME/lt.git.tag
read -ep "${bold}${yellow}Input the version you want: ${cyan}" input_version_num; echo -n "${normal}" ; }

### 检查系统是否被支持 ###
function _oscheck() {
if [[ ! "$SysSupport" == 1 ]]; then
echo -e "\n${bold}${red}Too young too simple! Only Debian 8/9 and Ubuntu 16.04/18.04 is supported by this script${normal}
${bold}If you want to run this script on unsupported distro, please use -s option\nExiting...${normal}\n"
exit 1
fi ; }

# Ctrl+C 时恢复样式
cancel() { echo -e "${normal}" ; reset -w ; exit ; }
trap cancel SIGINT

# --------------------------------------------------------------------------------
# 快速跳转
#[[ $script_lang == eng ]] &&
#[[ $script_lang == chs ]] &&

if [[ $script_lang == eng ]]; then

lang_do_not_install="Do not install"
language_select_another_version="Select another version"
which_version_do_you_want="Which version do you want?"
lang_yizhuang="You have already installed"
lang_will_be_installed="will be installed"
lang_note_that="Note that"
lang_would_you_like_to_install="Would you like to install"

elif [[ $script_lang == chs ]]; then

lang_do_not_install="我不想安装"
language_select_another_version="以上版本都不要，我要另选一个版本"
which_version_do_you_want="你想要装什么版本？"
lang_yizhuang="你已经安装了"
lang_will_be_installed="将会被安装"
lang_note_that="注意"
lang_would_you_like_to_install="是否需要安装"

fi










# --------------------- 系统检查 --------------------- #
function _intro() {

clear

# 检查是否以 root 权限运行脚本
if [[ ! $DeBUG == 1 ]]; then if [[ $EUID != 0 ]]; then echo -e "\n${title}${bold}Naive! I think this young man will not be able to run this script without root privileges.${normal}\n" ; exit 1
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
# 2019.04.09 有些特殊情况，还是再改下
# 最好不要依赖 ifconfig，因为说不定系统里没有 ifconfig
#[ -n "$(grep 'eth0:' /proc/net/dev)" ] && wangka=eth0 || wangka=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet|^he-ipv6|^docker' |awk 'NR==1 {print $0}'`
#wangka=` ifconfig -a | grep -B 1 $(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}') | head -n1 | awk '{print $1}' | sed "s/:$//"  `
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

  QB_latest_ver=$( wget -qO- https://github.com/qbittorrent/qBittorrent/releases | grep releases/tag | grep -Eo "[45]\.[0-9.]+" | head -n1 )
  [[ -z $QB_latest_ver ]] && QB_latest_ver=4.1.5

  DE_repo_ver=` apt-cache policy deluged | grep -B1 http | grep -Eo "[12]\.[0-9.]+\.[0-9.]+" | head -n1 `
  [[ -z $DE_repo_ver ]] && { [[ $CODENAME == bionic ]] && DE_repo_ver=1.3.15 ; [[ $CODENAME == xenial ]] && DE_repo_ver=1.3.12 ; [[ $CODENAME == jessie ]] && DE_repo_ver=1.3.10 ; [[ $CODENAME == stretch ]] && DE_repo_ver=1.3.13 ; }

  DE_latest_ver=$( wget -qO- https://dev.deluge-torrent.org/wiki/ReleaseNotes | grep wiki/ReleaseNotes | grep -Eo "[12]\.[0-9.]+" | sed 's/">/ /' | awk '{print $1}' | head -n1 )
  [[ -z $DE_latest_ver ]] && DE_latest_ver=1.3.15

# DE_github_latest_ver=` wget -qO- https://github.com/deluge-torrent/deluge/releases | grep releases/tag | grep -Eo "[12]\.[0-9.]+.*" | sed 's/\">//' | head -n1 `

  TR_repo_ver=` apt-cache policy transmission-daemon | grep -B1 http | grep -Eo "[23]\.[0-9.]+" | head -n1 `
  [[ -z $TR_repo_ver ]] && { [[ $CODENAME == bionic ]] && TR_repo_ver=2.92 ; [[ $CODENAME == xenial ]] && TR_repo_ver=2.84 ; [[ $CODENAME == jessie ]] && TR_repo_ver=2.84 ; [[ $CODENAME == stretch ]] && TR_repo_ver=2.92 ; }

  TR_latest_ver=$( wget -qO- https://github.com/transmission/transmission/releases | grep releases/tag | grep -Eo "[23]\.[0-9.]+" | head -n1 )
  [[ -z $TR_latest_ver ]] && TR_latest_ver=2.94


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

[[ $CODENAME == jessie ]] && echo -e "\n${bold}${red}Support of Debian 8 will be dropped in the future\n最近几个月可能会移除对 Debian 8 的支持${normal}"

[[ ! $SYSTEMCHECK == 1 ]] && echo -e "\n${bold}${red}System Checking Skipped. $lang_note_that this script may not work on unsupported system${normal}"

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
  iUser="$1" ; local min=1 ; local max=32
  # This list is not meant to be exhaustive. It's only the list from here: https://docs.microsoft.com/azure/virtual-machines/linux/usernames
  local reserved_names=" adm admin audio backup bin cdrom crontab daemon dialout dip disk fax floppy fuse games gnats irc kmem landscape libuuid list lp mail man messagebus mlocate netdev news nobody nogroup operator plugdev proxy root sasl shadow src ssh sshd staff sudo sync sys syslog tape tty users utmp uucp video voice whoopsie www-data "
  if [ -z "$iUser" ]; then
      username_valid=empty
  elif [ ${#iUser} -lt $min ] || [ ${#username} -gt $max ]; then
      echo -e "${CW} The username must be between $min and $max characters${normal}"
      username_valid=false
  elif ! [[ "$iUser" =~ ^[a-z][-a-z0-9_]*$ ]]; then
      echo -e "${CW} The username must contain only lowercase letters, digits, underscores and starts with a letter${normal}"
      username_valid=false
  elif [[ "$reserved_names" =~ " $iUser " ]]; then
      echo -e "${CW} The username cannot be an Ubuntu reserved name${normal}"
      username_valid=false
  else
      username_valid=true
  fi
}



# 询问用户名
function _askusername(){ clear

validate_username $iUser

if [[ $username_valid == empty ]]; then

    echo -e "${bold}${yellow}The script needs a username${jiacu}"
    echo -e "This will be your primary user. It can be an existing user or a new user ${normal}"
    _input_username

elif [[ $username_valid == false ]]; then

  # echo -e "${JG} The preset username doesn't pass username check, please set a new username"
    _input_username

elif [[ $username_valid == true ]]; then

  # iUser=`  echo $iUser | tr 'A-Z' 'a-z'  `
    echo -e "${bold}Username sets to ${blue}$iUser${normal}\n"

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

    iUser=$addname

done ; echo ; }






# 一定程度上的密码复杂度检测：https://stackoverflow.com/questions/36524872/check-single-character-in-array-bash-for-password-generator
# 询问密码。目前的复杂度判断还不够 Flexget 的程度，但总比没有强……

function _askpassword() {

local password1 ; local password2 ; #local exitvalue=0
exec 3>&1 >/dev/tty

if [[ $iPass = "" ]]; then

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

    iPass=$localpass
    exec >&3- ; echo ; # return $exitvalue

else

    echo -e "${bold}Password sets to ${blue}$iPass${normal}\n"

fi ; }





# --------------------- 询问安装前是否需要更换软件源 --------------------- #

function _askaptsource() {

while [[ $aptsources = "" ]]; do

    read -ep "${bold}${yellow}Would you like to change sources list?${normal} [${cyan}Y${normal}]es or [N]o: " responce
  # echo -ne "${bold}${yellow}Would you like to change sources list?${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

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
  # echo -e   "${red}99)${normal} Do not compile, install softwares from repo"

  # echo -e  "${bold}${red}$lang_note_that${normal} ${bold}using more than one thread to compile may cause failure in some cases${normal}"
    read -ep "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " version
  # echo -ne "${bold}${yellow}How many threads do you want to use when compiling?${normal} (Default ${cyan}01${normal}): " ; read -e responce

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
    echo -e "${bold}${baiqingse}Deluge/qBittorrent/Transmission $lang_will_be_installed from repo${normal}"
else
    echo -e "${bold}${baiqingse}[${MAXCPUS}]${normal} ${bold}thread(s) will be used when compiling${normal}"
fi

echo ; }






# --------------------- 询问是否使用 swap --------------------- #

function _askswap() {

if [[ $USESWAP = "" ]] && [[ $tram -le 1926 ]]; then

    echo -e  "${bold}${red}$lang_note_that${normal} ${bold}Your RAM is below ${red}1926MB${jiacu}, memory may got exhausted when compiling${normal}"
    read -ep "${bold}${yellow}Would you like to use swap when compiling?${normal} [${cyan}Y${normal}]es or [N]o: " version
  # echo -ne "${bold}${yellow}Would you like to use swap when compiling?${normal} [${cyan}Y${normal}]es or [N]o: " ; read -e responce

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

while [[ $qb_version = "" ]]; do

    echo -e "${green}01)${normal} qBittorrent ${cyan}3.3.11${normal}"
    echo -e "${green}02)${normal} qBittorrent ${cyan}3.3.16${normal}"
    echo -e "${green}03)${normal} qBittorrent ${cyan}4.0.4${normal}"
    echo -e "${green}04)${normal} qBittorrent ${cyan}4.1.3${normal}"
    echo -e "${green}05)${normal} qBittorrent ${cyan}4.1.4${normal}"
    echo -e "${green}06)${normal} qBittorrent ${cyan}4.1.5${normal}"
#   echo -e  "${blue}11)${normal} qBittorrent ${blue}4.2.0.alpha (unstable)${normal}"
    echo -e  "${blue}30)${normal} $language_select_another_version"
    echo -e "${green}40)${normal} qBittorrent ${cyan}$QB_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} qBittorrent ${cyan}$QB_latest_ver${normal} from ${cyan}Stable PPA${normal}"
    echo -e   "${red}99)${normal} $lang_do_not_install qBittorrent"

    [[ $qb_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang ${underline}qBittorrent ${qbtnox_ver}${normal}"

    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}06${normal}): " version
  # echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}06${normal}): " ; read -e version

    case $version in
        01 | 1) qb_version=3.3.11 ;;
        02 | 2) qb_version=3.3.16 ;;
        03 | 3) qb_version=4.0.4 ;;
        04 | 4) qb_version=4.1.3 ;;
        05 | 5) qb_version=4.1.4 ;;
        06 | 6) qb_version=4.1.5 ;;
        11) qb_version=4.2.0.alpha ;;
        30) _input_version && qb_version="${input_version_num}"  ;;
        40) qb_version='Install from repo' ;;
        50) qb_version='Install from PPA' ;;
        99) qb_version=No ;;
        * | "") qb_version=4.1.5 ;;
    esac

done

[[ $(echo $qb_version | grep -oP "[0-9.]+" | awk -F '.' '{print $1}') == 3 ]] && qbt_ver_3=Yes

# 2018.12.11 改来改去，我现在有点懵逼……
qBittorrent_4_2_0_later=No
[[ $(echo $qb_version | grep -oP "[0-9.]+") ]] && version_ge $qb_version 4.1.4 && qBittorrent_4_2_0_later=Yes

if [[ $qb_version == No ]]; then

    echo "${baizise}qBittorrent will ${baihongse}not${baizise} be installed${normal}"

elif [[ $qb_version == "Install from repo" ]]; then

    sleep 0

elif [[ $qb_version == "Install from PPA" ]]; then

    if [[ $DISTRO == Debian ]]; then
        echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
        echo -ne "Therefore "
        qb_version='Install from repo'
    else
        echo "${bold}${baiqingse}qBittorrent $QB_latest_ver${normal} ${bold}$lang_will_be_installed from Stable PPA${normal}"
    fi

elif [[ $qb_version == "4.2.0.alpha" ]]; then

    echo -e "${bold}${bailanse}qBittorrent ${qb_version}${normal} ${bold}$lang_will_be_installed${normal}"
  # echo -e "\n$${ZY} This is NOT a stable release${normal}"

else

    echo -e "${bold}${baiqingse}qBittorrent ${qb_version}${normal} ${bold}$lang_will_be_installed${normal}"
    [[ $qbt_ver_3 == Yes ]] && {
    echo -e "\n${bold}${bailanse}Attention${normal} ${bold}The option of qbt 3.3.x installation will be removed recently${normal}"
    echo -e "${bold}${baihongse}  注意！ ${normal} ${bold}在下一个版本会取消 qb 3.3.X 版本的安装选项${normal}" ; }

fi

if [[ $qb_version == "Install from repo" ]]; then

    echo "${bold}${baiqingse}qBittorrent $QB_repo_ver${normal} ${bold}$lang_will_be_installed from repository${normal}"

fi

echo ; }




# --------------------- 询问需要安装的 Deluge 版本 --------------------- #
# wget -qO- "http://download.deluge-torrent.org/source/" | grep -Eo "1\.3\.[0-9]+" | sort -u | pr -6 -t ; echo

function _askdeluge() {

while [[ $de_version = "" ]]; do

    echo -e "${green}01)${normal} Deluge ${cyan}1.3.9${normal}"
    echo -e "${green}02)${normal} Deluge ${cyan}1.3.13${normal}"
    echo -e "${green}03)${normal} Deluge ${cyan}1.3.14${normal}"
    echo -e "${green}04)${normal} Deluge ${cyan}1.3.15${normal}"
#   echo -e "${green}05)${normal} Deluge ${cyan}2.0${normal}"
    echo -e  "${blue}11)${normal} Deluge ${blue}2.0 dev${normal} ${blue}(unstable)${normal}"
    echo -e  "${blue}30)${normal} $language_select_another_version"
    echo -e "${green}40)${normal} Deluge ${cyan}$DE_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} Deluge ${cyan}$DE_latest_ver${normal} from ${cyan}PPA${normal}"
    echo -e   "${red}99)${normal} $lang_do_not_install Deluge"

    [[ $de_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang ${underline}Deluge ${deluged_ver}${reset_underline}${normal}"

    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}04${normal}): " version
  # echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}04${normal}): " ; read -e version

    case $version in
        01 | 1) de_version=1.3.9 ;;
        02 | 2) de_version=1.3.13 ;;
        03 | 3) de_version=1.3.14 ;;
        04 | 4) de_version=1.3.15 ;;
#       05 | 5) de_version=2.0 ;;
        11) de_version=2.0.dev ;;
        21) de_version='1.3.15_skip_hash_check' ;;
        30) _input_version && de_version="${input_version_num}" ;;
        31) _input_version && de_version="${input_version_num}" && de_test=yes &&  de_branch=yes ;;
        32) _input_version && de_version="${input_version_num}" && de_test=yes && de_version=yes ;;
        40) de_version='Install from repo' ;;
        50) de_version='Install from PPA' ;;
        99) de_version=No ;;
        * | "") de_version=1.3.15 ;;
    esac

done


[[ $(echo $de_version | grep -oP "[0-9.]+") ]] && { version_ge $de_version 1.3.11 || Deluge_ssl_fix_patch=Yes ; }
[[ $(echo $de_version | grep -oP "[0-9.]+") ]] && { version_ge $de_version 2.0 && Deluge_2_later=Yes || Deluge_2_later=No ; }
[[ $de_version == '1.3.15_skip_hash_check'  ]] && Deluge_1_3_15_skip_hash_check_patch=Yes


if [[ $de_version == No ]]; then

    echo "${baizise}Deluge will ${baihongse}not${baizise} be installed${normal}"

elif [[ $de_version == "Install from repo" ]]; then 

    sleep 0

elif [[ $de_version == "Install from PPA" ]]; then

    if [[ $DISTRO == Debian ]]; then
        echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
        echo -ne "Therefore "
        de_version='Install from repo'
    else
        echo "${bold}${baiqingse}Deluge $DE_latest_ver${normal} ${bold}$lang_will_be_installed from PPA${normal}"
    fi

elif [[ $de_version == "2.0.dev" ]]; then

    echo -e "${bold}${bailanse}Deluge ${de_version}${normal} ${bold}$lang_will_be_installed${normal}"
  # echo -e "\n${ZY} This is NOT a stable release${normal}"

else

    echo "${bold}${baiqingse}Deluge ${de_version}${normal} ${bold}$lang_will_be_installed${normal}"

fi


if [[ $de_version == "Install from repo" ]]; then 

    echo "${bold}${baiqingse}Deluge $DE_repo_ver${normal} ${bold}$lang_will_be_installed from repository${normal}"

fi

echo ; }





# 2018.04.26 禁用这个问题，统一使用 1.0.11
# 2018.11.15 随着 RC_1_1 分支的进步，准备重新启用
# 2018.11.15 不确定 PPA、apt 源里的版本是否会冲突，保险起见自己编译一次，因此移除了 PPA、repo 的选项
# 2018.11.15 qb 开发者打算要求使用 C++14 了的样子，不知道这对于同时使用 Deluge 的用户是否有影响
# --------------------- 询问需要安装的 libtorrent-rasterbar 版本 --------------------- #
# lt_version=$(  wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_1_" | sort -t _ -n -k 3 | tail -n1  )

function _lt_ver_ask() {

[[ $DeBUG == 1 ]] && echo "lt_version=$lt_version  lt_ver=$lt_ver  lt8_support=$lt8_support  qb_version=$qb_version  de_version=$de_version"

# 默认 lt 1.0 可用
lt8_support=Yes
# 当要安装 Deluge 2.0 或 qBittorrent 4.2.0(stable release) 时，lt 版本至少要 1.1.11；如果原先装了 1.0，那么这里必须升级到 1.1 或者 1.2
# 2019.01.30 这里不去掉 unset lt_version 就容易导致 opt 失效
[[ $Deluge_2_later == Yes || $qBittorrent_4_2_0_later == Yes ]] && lt8_support=No

[[ $DeBUG == 1 ]] && {
echo "Deluge_2_later=$Deluge_2_later   qBittorrent_4_2_0_later=$qBittorrent_4_2_0_later"
echo "lt_ver=$lt_ver  lt8_support=$lt8_support  lt_ver_qb3_ok=$lt_ver_qb3_ok  lt_ver_de2_ok=$lt_ver_de2_ok" ; }

while [[ $lt_version = "" ]]; do

    [[ $lt8_support == Yes ]] &&
    echo -e "${green}01)${normal} libtorrent-rasterbar ${cyan}1.0.11${normal} (${blue}RC_1_0${normal} branch)"
    echo -e "${green}02)${normal} libtorrent-rasterbar ${cyan}1.1.12${normal} (${blue}RC_1_1${normal} branch)"
    echo -e  "${blue}03)${normal} libtorrent-rasterbar ${blue}1.2.0 ${normal} (${blue}RC_1_2${normal} branch)"
    echo -e  "${blue}30)${normal} $language_select_another_version"
    [[ $lt_ver ]] && [[ $lt_ver_qb3_ok == Yes ]] &&
    echo -e "${green}99)${normal} libtorrent-rasterbar ${cyan}$lt_ver${normal} which is already installed"
  # echo -e "${bailanse}${bold} ATTENTION ${normal}${blue} both Deluge and qBittorrent use libtorrent-rasterbar \n            as torrent backend"

    # 已安装 libtorrent-rasterbar 且不使用 Deluge 2.0 或者 qBittorrent 4.2.0
    if [[ $lt_ver ]] && [[ $lt_ver_qb3_ok == Yes ]] && [[ $lt8_support == Yes ]]; then
            while [[ $lt_version == "" ]]; do
					read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}99${normal}): " version
                    case $version in
                          01 | 1) lt_version=RC_1_0 ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) lt_version=system ;;
                          ""    ) lt_version=system ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    # 已安装 libtorrent-rasterbar 的版本低于 1.0.6，无法用于编译 qBittorrent 3.3.x and later（但也不需要 1.1）
    elif [[ $lt_ver ]] && [[ $lt_ver_qb3_ok == No ]] && [[ ! $qb_version == No ]]; then
            while [[ $lt_version == "" ]]; do
                    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}01${normal}): " version
                    case $version in
                          01 | 1) lt_version=RC_1_0 ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) echo -e "\n${CW} qBittorrent 3.3 and later requires libtorrent-rasterbar 1.0.6 and later${normal}\n" ;;
                          ""    ) lt_version=RC_1_0 ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    # 已安装 libtorrent-rasterbar 且需要使用 Deluge 2.0 或者 qBittorrent 4.2.0，且系统里已经安装的 libtorrent-rasterbar 支持
    # 2018.12.03 发现这里写的有问题，试着更正下
    elif [[ $lt_ver ]] && [[ $lt8_support == No ]] && [[ $lt_ver_de2_ok == Yes ]]; then
            while [[ $lt_version == "" ]]; do
                    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}99${normal}): " version
                    case $version in
                          01 | 1) echo -e "\n${CW} Deluge 2.0 or qBittorrent 4.2.0 requires libtorrent-rasterbar 1.1.3 or later${normal}\n" ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) lt_version=system ;;
                          ""    ) lt_version=system ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    # 已安装 libtorrent-rasterbar 且需要使用 Deluge 2.0 或者 qBittorrent 4.2.0，但系统里已经安装的 libtorrent-rasterbar 不支持
    elif [[ $lt_ver ]] && [[ $lt8_support == No ]] && [[ $lt_ver_de2_ok == No ]]; then
            while [[ $lt_version == "" ]]; do
                    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}02${normal}): " version
                    case $version in
                          01 | 1) echo -e "\n${CW} Deluge 2.0 or qBittorrent 4.2.0 requires libtorrent-rasterbar 1.1.3 or later${normal}\n" ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) echo -e "\n${CW} Deluge 2.0 or qBittorrent 4.2.0 requires libtorrent-rasterbar 1.1.3 or later${normal}\n" ;;
                          ""    ) lt_version=RC_1_1 ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    # 未安装 libtorrent-rasterbar 且不使用 Deluge 2.0 或者 qBittorrent 4.2.0
    elif [[ ! $lt_ver ]] && [[ $lt8_support == Yes ]]; then
            while [[ $lt_version == "" ]]; do
                    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}01${normal}): " version
                    case $version in
                          01 | 1) lt_version=RC_1_0 ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) echo -e "\n${CW} libtorrent-rasterbar is a must for Deluge or qBittorrent, so you have to install it${normal}\n" ;;
                          ""    ) lt_version=RC_1_0 ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    # 未安装 libtorrent-rasterbar 且要使用 Deluge 2.0 或者 qBittorrent 4.2.0
    elif [[ ! $lt_ver ]] && [[ $lt8_support == No ]]; then
            while [[ $lt_version == "" ]]; do
                    echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}02${normal}): " ; read -e version
                    case $version in
                          01 | 1) echo -e "\n${CW} Deluge 2.0 or qBittorrent 4.2.0 requires libtorrent-rasterbar 1.1.3 or later${normal}\n" ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) echo -e "\n${CW} libtorrent-rasterbar is a must for Deluge or qBittorrent, so you have to install it${normal}\n" ;;
                          ""    ) lt_version=RC_1_1 ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    else
            while [[ $lt_version == "" ]]; do
                    echo -e "\n${bold}${yellow}你发现了一个 Bug！请带着以下信息联系作者……${normal}\n"
                    echo "Deluge_2_later=$Deluge_2_later   qBittorrent_4_2_0_later=$qBittorrent_4_2_0_later"
                    echo "lt_ver=$lt_ver  lt8_support=$lt8_support  lt_ver_qb3_ok=$lt_ver_qb3_ok  lt_ver_de2_ok=$lt_ver_de2_ok"
                    echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}02${normal}): " ; read -e version
                    case $version in
                          01 | 1) lt_version=RC_1_0 ;;
                          02 | 2) lt_version=RC_1_1 ;;
                          03 | 3) lt_version=RC_1_2 ;;
                          30    ) _input_version_lt && lt_version="${input_version_num}" ;;
                          98    ) lt_version=system ;;
                          99    ) lt_version=system ;;
                          ""    ) lt_version=system ;;
                          *     ) echo -e "\n${CW} Please input a valid opinion${normal}\n" ;;
                    esac
            done

    fi

done

lt_display_ver=$( echo "$lt_version" | sed "s/_/\./g" | sed "s/libtorrent-//" )
[[ $lt_version == RC_1_0  ]] && lt_display_ver=1.0.11
[[ $lt_version == RC_1_1  ]] && lt_display_ver=1.1.12
[[ $lt_version == RC_1_2  ]] && lt_display_ver=1.2.0
[[ $lt_version == master  ]] && lt_display_ver=1.2.0
# 检测版本号速度慢了点，所以还是手动指定
#[[ $lt_version == RC_1_0  ]] && lt_display_ver=$( wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_0_" | sort -t _ -n -k 3 | tail -n1 | sed "s/_/\./g" | sed "s/libtorrent-//" )
#[[ $lt_version == RC_1_1  ]] && lt_display_ver=$( wget -qO- "https://github.com/arvidn/libtorrent" | grep "data-name" | cut -d '"' -f2 | grep "libtorrent-1_1_" | sort -t _ -n -k 3 | tail -n1 | sed "s/_/\./g" | sed "s/libtorrent-//" )

    if [[ $lt_version == system ]]; then

        echo "${baiqingse}${bold}libtorrent-rasterbar $lt_ver${jiacu} will be used from system${normal}"

    else

        echo "${baiqingse}${bold}libtorrent-rasterbar ${lt_display_ver}${normal} ${bold}$lang_will_be_installed${normal}"

    fi

[[ $DeBUG == 1 ]] && {
echo "Deluge_2_later=$Deluge_2_later   qBittorrent_4_2_0_later=$qBittorrent_4_2_0_later
lt_ver=$lt_ver  lt8_support=$lt8_support  lt_ver_qb3_ok=$lt_ver_qb3_ok  lt_ver_de2_ok=$lt_ver_de2_ok
lt_version=$lt_version" ; }

echo ; }





# --------------------- 询问需要安装的 rTorrent 版本 --------------------- #

function _askrt() {

if [[ $script_lang == eng ]]; then

lang_ipv6_1="with IPv6 support"
lang_ipv6_2="with UNOFFICAL IPv6 support"
lang_3="released on Sep 04, 2015"
lang_4="feature-bind branch on Jan 30, 2018"
branch=branch

elif [[ $script_lang == chs ]]; then

lang_ipv6_1="支持 IPv6"
lang_ipv6_2="支持 IPv6 的修改版"
lang_3="2015 年的正式发布版本"
lang_4="2018 年 1 月 的 feature-bind 分支版本"
branch="分支"

fi


while [[ $rt_version = "" ]]; do




    [[ ! $rtorrent_dev == 1 ]] &&
    echo -e "${green}01)${normal} rTorrent ${cyan}0.9.2${normal}" &&
    echo -e "${green}02)${normal} rTorrent ${cyan}0.9.3${normal}" &&
    echo -e "${green}03)${normal} rTorrent ${cyan}0.9.4${normal}" &&
    echo -e "${green}04)${normal} rTorrent ${cyan}0.9.6${normal} ($lang_3)" &&
    echo -e "${green}11)${normal} rTorrent ${cyan}0.9.2${normal} ($lang_ipv6_1)" &&
    echo -e "${green}12)${normal} rTorrent ${cyan}0.9.3${normal} ($lang_ipv6_1)" &&
    echo -e "${green}13)${normal} rTorrent ${cyan}0.9.4${normal} ($lang_ipv6_1)"
    echo -e "${green}14)${normal} rTorrent ${cyan}0.9.6${normal} ($lang_4)"
    echo -e "${green}15)${normal} rTorrent ${cyan}0.9.7${normal} ($lang_ipv6_1)"
    echo -e   "${red}99)${normal} $lang_do_not_install rTorrent"

    [[ $rt_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang ${underline}rTorrent ${rtorrent_ver}${normal}"
#   [[ $rt_installed == Yes ]] && echo -e "${bold}If you want to downgrade or upgrade rTorrent, use ${blue}rtupdate${normal}"

    if [[ $rtorrent_dev == 1 ]]; then

        echo "${bold}${red}$lang_note_that${normal} ${bold}${green}Debian 9${jiacu} and ${green}Ubuntu 18.04 ${jiacu}is only supported by ${green}rTorrent 0.9.6 and later${normal}"
        read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}14${normal}): " version
      # echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}14${normal}): " ; read -e version

        case $version in
            14) rt_version='0.9.6 IPv6 supported' ;;
            15) rt_version=0.9.7 ;;
            99) rt_version=No ;;
            "" | *) rt_version='0.9.6 IPv6 supported' ;;
        esac

    else

        read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}14${normal}): " version
      # echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}14${normal}): " ; read -e version

        case $version in
            01 | 1) rt_version=0.9.2 ;;
            02 | 2) rt_version=0.9.3 ;;
            03 | 3) rt_version=0.9.4 ;;
            04 | 4) rt_version=0.9.6 ;;
            11) rt_version='0.9.2 IPv6 supported' ;;
            12) rt_version='0.9.3 IPv6 supported' ;;
            13) rt_version='0.9.4 IPv6 supported' ;;
            14) rt_version='0.9.6 IPv6 supported' ;;
            15) rt_version=0.9.7 ;;
            99) rt_version=No ;;
            "" | *) rt_version='0.9.6 IPv6 supported' ;;
        esac

    fi

done

[[ $IPv6Opt == -i ]] && rt_version=`echo $rt_version IPv6 supported`
[[ `echo $rt_version | grep IPv6` ]] && IPv6Opt=-i
[[ $rt_version == 0.9.7 ]] && IPv6Opt=-i
rt_versionIns=`echo $rt_version | grep -Eo [0-9].[0-9].[0-9]`

if [[ $rt_version == No ]]; then

    [[ $script_lang == eng ]] && echo "${baizise}rTorrent will ${baihongse}not${baizise} be installed${normal}"
    [[ $script_lang == chs ]] && echo "${baihongse}跳过${baizise} rTorrent 的安装${normal}"
    
    InsFlood='No rTorrent'

else

    if [[ `echo $rt_version | grep IPv6 | grep -Eo 0.9.[234]` ]]; then

        echo "${bold}${baiqingse}rTorrent $rt_versionIns ($lang_ipv6_2)${normal} ${bold}$lang_will_be_installed${normal}"

    elif [[ $rt_version == '0.9.6 IPv6 supported' ]]; then

        echo "${bold}${baiqingse}rTorrent 0.9.6 (feature-bind $branch)${normal} ${bold}$lang_will_be_installed${normal}"

    else

        echo "${bold}${baiqingse}rTorrent ${rt_version}${normal} ${bold}$lang_will_be_installed${normal}"

    fi

#   echo "${bold}${baiqingse}ruTorrent, vsftpd, h5ai, autodl-irssi${normal} ${bold}will also be installed${normal}"

fi

echo ; }






# --------------------- 询问是否安装 flood --------------------- #

function _askflood() {

while [[ $InsFlood = "" ]]; do

    read -ep "${bold}${yellow}$lang_would_you_like_to_install flood? ${normal} [Y]es or [${cyan}N${normal}]o: " responce
  # echo -ne "${bold}${yellow}$lang_would_you_like_to_install flood? ${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsFlood=Yes ;;
        [nN] | [nN][Oo] | "" ) InsFlood=No  ;;
        *) InsFlood=No ;;
    esac

done

if [[ $InsFlood == Yes ]]; then
    echo "${bold}${baiqingse}Flood${normal} ${bold}$lang_will_be_installed${normal}"
else
    echo "${baizise}Flood will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }






# --------------------- 询问需要安装的 Transmission 版本 --------------------- #
# wget -qO- "https://github.com/transmission/transmission" | grep "data-name" | cut -d '"' -f2 | pr -3 -t ; echo

function _asktr() {

while [[ $tr_version = "" ]]; do

    [[ ! $CODENAME == bionic ]] &&
    echo -e "${green}01)${normal} Transmission ${cyan}2.77${normal}" &&
    echo -e "${green}02)${normal} Transmission ${cyan}2.82${normal}" &&
    echo -e "${green}03)${normal} Transmission ${cyan}2.84${normal}" &&
    echo -e "${green}04)${normal} Transmission ${cyan}2.92${normal}"
    echo -e "${green}05)${normal} Transmission ${cyan}2.93${normal}"
    echo -e "${green}06)${normal} Transmission ${cyan}2.94${normal}"
    echo -e  "${blue}30)${normal} $language_select_another_version"
    echo -e "${green}40)${normal} Transmission ${cyan}$TR_repo_ver${normal} from ${cyan}repo${normal}"
    [[ $DISTRO == Ubuntu ]] &&
    echo -e "${green}50)${normal} Transmission ${cyan}$TR_latest_ver${normal} from ${cyan}PPA${normal}"
    echo -e   "${red}99)${normal} $lang_do_not_install Transmission"

    [[ $tr_installed == Yes ]] &&
    echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang ${underline}Transmission ${trd_ver}${normal}"

    read -ep "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}40${normal}): " version
  # echo -ne "${bold}${yellow}$which_version_do_you_want${normal} (Default ${cyan}40${normal}): " ; read -e version

    case $version in
            01 | 1) tr_version=2.77 ;;
            02 | 2) tr_version=2.82 ;;
            03 | 3) tr_version=2.84 ;;
            04 | 4) tr_version=2.92 ;;
            05 | 5) tr_version=2.93 ;;
            06 | 6) tr_version=2.94 ;;
            11) tr_version=2.92 && TRdefault=No ;;
            12) tr_version=2.93 && TRdefault=No ;;
            13) tr_version=2.94 && TRdefault=No ;;
            30) _input_version && tr_version="${input_version_num}" ;;
            31) _input_version && tr_version="${input_version_num}" && TRdefault=No ;;
            40) tr_version='Install from repo' ;;
            50) tr_version='Install from PPA' ;;
            99) tr_version=No ;;
            "" | *) tr_version='Install from repo';;
    esac

done


if [[ $tr_version == No ]]; then

    echo "${baizise}Transmission will ${baihongse}not${baizise} be installed${normal}"

else

    if [[ $tr_version == "Install from repo" ]]; then 

        sleep 0

    elif [[ $tr_version == "Install from PPA" ]]; then

        if [[ $DISTRO == Debian ]]; then

          echo -e "${bailanse}${bold} ATTENTION ${normal} ${bold}Your Linux distribution is ${green}Debian${jiacu}, which is not supported by ${green}Ubuntu${jiacu} PPA"
          echo -ne "Therefore "
          tr_version='Install from repo'

        else

          echo "${bold}${baiqingse}Transmission $TR_latest_ver ${normal} ${bold}$lang_will_be_installed from PPA${normal}"

        fi

    else

        echo "${bold}${baiqingse}Transmission ${tr_version}${normal} ${bold}$lang_will_be_installed${normal}"

    fi


    if [[ $tr_version == "Install from repo" ]]; then 

        echo "${bold}${baiqingse}Transmission $TR_repo_ver${normal} ${bold}$lang_will_be_installed from repository${normal}"

    fi

fi

echo ; }






# --------------------- 询问是否需要安装 Flexget --------------------- #

function _askflex() {

while [[ $InsFlex = "" ]]; do

    [[ $flex_installed == Yes ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang flexget${normal}"
    read -ep "${bold}${yellow}$lang_would_you_like_to_install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: " responce
  # echo -ne "${bold}${yellow}$lang_would_you_like_to_install Flexget?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsFlex=Yes ;;
        [nN] | [nN][Oo] | "" ) InsFlex=No ;;
        *) InsFlex=No ;;
    esac

done

if [ $InsFlex == Yes ]; then
    echo -e "${bold}${baiqingse}Flexget${normal} ${bold}$lang_will_be_installed${normal}\n"
else
    echo -e "${baizise}Flexget will ${baihongse}not${baizise} be installed${normal}\n"
fi ; }





# --------------------- 询问是否需要安装 rclone --------------------- #

function _askrclone() {

while [[ $InsRclone = "" ]]; do

    [[ $rclone_installed == Yes ]] && echo -e "${bailanse}${bold} ATTENTION ${normal} ${blue}${bold}$lang_yizhuang rclone${normal}"
    read -ep "${bold}${yellow}$lang_would_you_like_to_install rclone?${normal} [Y]es or [${cyan}N${normal}]o: " responce
  # echo -ne "${bold}${yellow}$lang_would_you_like_to_install rclone?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsRclone=Yes ;;
        [nN] | [nN][Oo] | "" ) InsRclone=No  ;;
        *) InsRclone=No ;;
    esac

done

if [[ $InsRclone == Yes ]]; then
    echo -e "${bold}${baiqingse}rclone${normal} ${bold}$lang_will_be_installed${normal}\n"
else
    echo -e "${baizise}rclone will ${baihongse}not${baizise} be installed${normal}\n"
fi ; }





# --------------------- 询问是否需要安装 远程桌面 --------------------- #

function _askrdp() {

while [[ $InsRDP = "" ]]; do

    echo -e "${green}01)${normal} VNC  with xfce4"
    echo -e "${green}02)${normal} X2Go with xfce4"
    echo -e   "${red}99)${normal} $lang_do_not_install remote desktop"
    read -ep "${bold}${yellow}$lang_would_you_like_to_install remote desktop?${normal} (Default ${cyan}99${normal}): " responce
  # echo -ne "${bold}${yellow}$lang_would_you_like_to_install remote desktop?${normal} (Default ${cyan}99${normal}): " ; read -e responce

    case $responce in
        01 | 1) InsRDP=VNC  ;;
        02 | 2) InsRDP=X2Go ;;
        99    ) InsRDP=No   ;;
        "" | *) InsRDP=No   ;;
    esac

done

if [[ $InsRDP == VNC ]]; then
    echo "${bold}${baiqingse}VNC${jiacu} and ${baiqingse}xfce4${jiacu} $lang_will_be_installed${normal}"
elif [[ $InsRDP == X2Go ]]; then
    echo "${bold}${baiqingse}X2Go${normal} and ${bold}${baiqingse}xfce4${jiacu} $lang_will_be_installed${normal}"
else
    echo "${baizise}VNC or X2Go will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }




# --------------------- 询问是否安装 wine 和 mono --------------------- #

function _askwine() {

while [[ $InsWine = "" ]]; do

    read -ep "${bold}${yellow}$lang_would_you_like_to_install wine and mono?${normal} [Y]es or [${cyan}N${normal}]o: " responce
  # echo -ne "${bold}${yellow}$lang_would_you_like_to_install wine and mono?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsWine=Yes ;;
        [nN] | [nN][Oo] | "" ) InsWine=No  ;;
        *) InsWine=No ;;
    esac

done

if [[ $InsWine == Yes ]]; then
    echo "${bold}${baiqingse}Wine${jiacu} and ${baiqingse}mono${jiacu} $lang_will_be_installed${normal}"
else
    echo "${baizise}Wine or mono will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }





# --------------------- 询问是否安装发种工具 --------------------- #

function _asktools() {

while [[ $InsTools = "" ]]; do

    echo -e "MKVToolnix, mktorrent, eac3to, mediainfo, ffmpeg ..."
#   read -ep "${bold}${yellow}$lang_would_you_like_to_install the above additional softwares?${normal} [Y]es or [${cyan}N${normal}]o: " responce
    echo -ne "${bold}${yellow}$lang_would_you_like_to_install the above additional softwares?${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

    case $responce in
        [yY] | [yY][Ee][Ss]  ) InsTools=Yes ;;
        [nN] | [nN][Oo] | "" ) InsTools=No  ;;
       *) InsTools=No ;;
    esac

done

if [[ $InsTools == Yes ]]; then
    echo "${bold}${baiqingse}Latest version of these softwares${jiacu} $lang_will_be_installed${normal}"
else
    echo "${baizise}These softwares will ${baihongse}not${baizise} be installed${normal}"
fi

echo ; }





# --------------------- BBR 相关 --------------------- #

# 检查是否已经启用BBR、BBR 魔改版
function check_bbr_status() { tcp_control=$(cat /proc/sys/net/ipv4/tcp_congestion_control)
if [[ $tcp_control =~ (bbr|bbr_powered|nanqinlang|tsunami) ]]; then bbrinuse=Yes ; else bbrinuse=No ; fi ; }

# 检查理论上内核是否支持原版 BBR
function check_kernel_version() {
kernel_vvv=$(uname -r | cut -d- -f1)
[[ ! -z $kernel_vvv ]] && version_ge $kernel_vvv 4.9 && bbrkernel=Yes || bbrkernel=No ; }

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
            echo -e "A new kernel (4.11.12) $lang_will_be_installed if BBR is to be installed"
            echo -e "${red}WARNING${normal} ${bold}Installing new kernel may cause reboot failure in some cases${normal}"
        #   read -ep "${bold}${yellow}$lang_would_you_like_to_install BBR? ${normal} [Y]es or [${cyan}N${normal}]o: " responce
            echo -ne "${bold}${yellow}$lang_would_you_like_to_install BBR? ${normal} [Y]es or [${cyan}N${normal}]o: " ; read -e responce

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
        echo "${bold}${baiqingse}TCP BBR${normal} ${bold}$lang_will_be_installed${normal}"
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
if [[ $script_lang == eng ]]; then
lang_1="Would you like to reboot the system now?"
lang_2="WTF, try reboot manually?"
lang_3="Reboot has been canceled..."
elif [[ $script_lang == chs ]]; then
lang_1="你现在想要重启系统么？"
lang_2="emmmm，重启失败，你手动重启试试？"
lang_3="已取消重启……"
fi

# read -ep "${bold}${yellow}Would you like to reboot the system now? ${normal} [y/${cyan}N${normal}]: " is_reboot
echo -ne "${bold}${yellow}$lang_1 ${normal} [y/${cyan}N${normal}]: "
if [[ $ForceYes == 1 ]];then reboot || echo "$lang_2" ; else read -e is_reboot ; fi
if [[ $is_reboot == "y" || $is_reboot == "Y" ]]; then reboot
else echo -e "${bold}$lang_3${normal}\n" ; fi ; }






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

[[ $script_lang == eng ]] && echo -e "\n${bold}Please check the following information${normal}"
[[ $script_lang == chs ]] && echo -e "\n${bold}                  请确认以下安装信息${normal}"
echo
echo '####################################################################'
echo
echo "                  ${cyan}${bold}Username${normal}      ${bold}${yellow}${iUser}${normal}"
echo "                  ${cyan}${bold}Password${normal}      ${bold}${yellow}${iPass}${normal}"
echo
echo "                  ${cyan}${bold}qBittorrent${normal}   ${bold}${yellow}${qb_version}${normal}"
echo "                  ${cyan}${bold}Deluge${normal}        ${bold}${yellow}${de_version}${normal}"
[[ ! $de_version == No ]] || [[ ! $qb_version == No ]] &&
echo "                  ${cyan}${bold}libtorrent${normal}    ${bold}${yellow}${lt_display_ver}${normal}"
echo "                  ${cyan}${bold}rTorrent${normal}      ${bold}${yellow}${rt_version}${normal}"
[[ ! $rt_version == No ]] &&
echo "                  ${cyan}${bold}Flood${normal}         ${bold}${yellow}${InsFlood}${normal}"
echo "                  ${cyan}${bold}Transmission${normal}  ${bold}${yellow}${tr_version}${normal}"
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
[[ $script_lang == eng ]] && echo -e "${bold}If you want to stop, Press ${baihongse}Ctrl+C${jiacu} ; or Press ${bailvse}ENTER${normal} ${bold}to start${normal}"
[[ $script_lang == chs ]] && echo -e "${bold}按 ${baihongse}Ctrl+C${jiacu} 取消安装，或者敲 ${bailvse}ENTER${normal}${bold} 开始安装${normal}"
[[ ! $ForceYes == 1 ]] && read input
[[ $script_lang == eng ]] && 
echo -e "${bold}${magenta}The selected softwares $lang_will_be_installed, this may take between${normal}" &&
echo -e "${bold}${magenta}1 - 100 minutes depending on your systems specs and your selections${normal}\n"
[[ $script_lang == chs ]] && 
echo -e "${bold}${magenta}开始安装所需的软件，由于所选选项的区别以及盒子硬件性能的差异，安装所需时间也会有所不同${normal}\n"
}





# --------------------- 创建用户、准备工作 --------------------- #

function _setuser() {

[[ -d /etc/inexistence ]] && mv /etc/inexistence /etc/inexistence_old_$(date "+%Y%m%d_%H%M")
git clone --depth=1 -b $iBranch https://github.com/Aniverse/inexistence /etc/inexistence
chmod -R 777 /etc/inexistence

if id -u ${iUser} >/dev/null 2>&1; then
    echo -e "\n${iUser} already exists\n"
else
    adduser --gecos "" ${iUser} --disabled-password --force-badname
    echo "${iUser}:${iPass}" | sudo chpasswd
fi

# 临时
mkdir -p $LogBase/app $SourceLocation $LockLocation $LogLocation $DebLocation
echo $iUser >> $LogBase/iUser.txt

export TZ="/usr/share/zoneinfo/Asia/Shanghai"

cat >> $LogTimes/installed.log << EOF
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
qb_version=${qb_version}
de_version=${de_version}
rt_version=${rt_version}
tr_version=${tr_version}
lt_version=${lt_version}
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
$iUser hard nofile 1048573
$iUser soft nofile 1048573
EOF

sed -i '/^DefaultLimitNOFILE.*/'d /etc/systemd/system.conf
sed -i '/^DefaultLimitNPROC.*/'d /etc/systemd/system.conf
echo "DefaultLimitNOFILE=999998" >> /etc/systemd/system.conf
echo "DefaultLimitNPROC=999998" >> /etc/systemd/system.conf

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

ln -s /etc/inexistence /var/www/h5ai/inexistence
ln -s /etc/inexistence /home/${iUser}/inexistence
cp -f /etc/inexistence/00.Installation/script/* /usr/local/bin ; }





# --------------------- 替换系统源 --------------------- #

function _setsources() {

[[ $USESWAP == Yes ]] && _use_swap

if [[ $aptsources == Yes ]] && [[ ! $CODENAME == jessie ]]; then
    cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y%m%d.%H%M")".bak
    wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/master/00.Installation/template/$DISTROL.apt.sources
    sed -i "s/RELEASE/$CODENAME/g" /etc/apt/sources.list
    [[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
elif [[ $aptsources == Yes ]] && [[ $CODENAME == jessie ]]; then
    cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y%m%d.%H%M")".bak
    echo 'Acquire::Check-Valid-Until 0;' > /etc/apt/apt.conf.d/10-no-check-valid-until
    cat > /etc/apt/sources.list << EOF
deb http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie main non-free contrib
deb http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie-updates main non-free contrib
deb http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie-backports main non-free contrib
deb http://snapshot.debian.org/archive/debian-security/20190321T212815Z/ jessie/updates main non-free contrib
deb-src http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie main non-free contrib
deb-src http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie-updates main non-free contrib
deb-src http://snapshot.debian.org/archive/debian/20190321T212815Z/ jessie-backports main non-free contrib
deb-src http://snapshot.debian.org/archive/debian-security/20190321T212815Z/ jessie/updates main non-free contrib
EOF
fi

apt-get -y update

dpkg --configure -a
apt-get -f -y install

# 其实很多包可能对于很多人没用，私货私货……
if [[ $SKIPAPPS == Yes ]]; then echo -e "\n${baizise}Skip useful apps installation${normal}\n" ; else
apt-get install -y screen git sudo zsh virt-what lsb-release curl python lrzsz locales aptitude gawk jq bc \
speedtest-cli mtr iperf iperf3 wondershaper       htop atop iotop dstat sysstat vnstat smartmontools psmisc dirmngr \
ca-certificates apt-transport-https gcc make checkinstall build-essential pkg-config     tree figlet toilet lolcat zip unzip ntpdate ruby uuid rsync socat \
ethtool net-tools libelf-dev
fi

if [ ! $? = 0 ]; then
    echo -e "\n${baihongse}${shanshuo}${bold} ERROR ${normal} ${red}${bold}Failed to install packages, please check it and rerun once it is resolved${normal}\n"
    kill -s TERM $TOP_PID
    exit 1
fi

# Debian 8 升级 vnstat
if [[ $CODENAME == jessie ]]; then
    cd ; wget https://humdi.net/vnstat/vnstat-1.18.tar.gz
    tar zxf vnstat-1.18.tar.gz
    cd vnstat-1.18
    ./configure --prefix=/usr
    make -j${MAXCPUS}
    make install
    cd ; rm -rf vnstat-1.18.tar.gz vnstat-1.18
fi

# 指定 vnstat 网卡
[[ -z $wangka ]] && [[ ! $wangka == eth0 ]] && sed -i "s/Interface.*/Interface $wangka/" /etc/vnstat.conf

# 安装 NConvert
wget -t1 -T5 http://download.xnview.com/NConvert-linux64.tgz -O NConvert-linux64.tgz && {
tar zxf NConvert-linux64.tgz
mv NConvert/nconvert /usr/local/bin
rm -rf NConvert* ; }

echo -e "\n\n\n${bailvse}  STEP-ONE-COMPLETED  ${normal}\n\n"

sed -i "s/TRANSLATE=1/TRANSLATE=0/g" /etc/checkinstallrc >/dev/null 2>&1
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





# --------------------- 安装 libtorrent-rasterbar --------------------- #

function _install_lt() {

[[ $DeBUG == 1 ]] && {
echo "Deluge_2_later=$Deluge_2_later   qBittorrent_4_2_0_later=$qBittorrent_4_2_0_later
lt_ver=$lt_ver  lt8_support=$lt8_support  lt_ver_qb3_ok=$lt_ver_qb3_ok  lt_ver_de2_ok=$lt_ver_de2_ok
lt_version=$lt_version" ; }

if [[ $arch == x86_64 ]]; then

if   [[ $lt_version == RC_1_0 ]]; then
    bash $local_packages/install/install_libtorrent_rasterbar -m deb
elif [[ $lt_version == RC_1_1 ]]; then
    bash $local_packages/install/install_libtorrent_rasterbar -m deb2
elif [[ $lt_version == RC_1_2 ]]; then
  # bash $local_packages/install/install_libtorrent_rasterbar -m deb3
    bash $local_packages/install/install_libtorrent_rasterbar -b RC_1_2
else
    bash $local_packages/install/install_libtorrent_rasterbar -v $lt_version
fi

fi ; }






# --------------------- 安装 qBittorrent --------------------- #

function _installqbt() {

if [[ $qb_version == "Install from repo" ]]; then

    apt-get install -y qbittorrent-nox
    echo -e "\n\n${bailvse}  QBITTORRENT-INSTALLATION-COMPLETED  ${normal}\n\n"

elif [[ $qb_version == "Install from PPA" ]]; then

    apt-get install -y software-properties-common
    add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
    apt-get update
    apt-get install -y qbittorrent-nox
    echo -e "\n\n${bailvse}  QBITTORRENT-INSTALLATION-COMPLETED  ${normal}\n\n"

else

    [[ `  dpkg -l | grep -v qbittorrent-headless | grep qbittorrent-nox  ` ]] && apt-get purge -y qbittorrent-nox

    if [[ $CODENAME == jessie ]]; then

        apt-get purge -y qtbase5-dev qttools5-dev-tools libqt5svg5-dev
        apt-get autoremove -y
        apt-get install -y libgl1-mesa-dev

        wget --no-check-certificate -qO qt_5.5.1-1_amd64_debian8.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Other%20Tools/qt_5.5.1-1_amd64_debian8.deb
        dpkg -i qt_5.5.1-1_amd64_debian8.deb && rm -f qt_5.5.1-1_amd64_debian8.deb

        export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/Qt-5.5.1/lib/pkgconfig
        export PATH=/usr/local/Qt-5.5.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        qmake --version

    else

        apt-get install -y qtbase5-dev qttools5-dev-tools libqt5svg5-dev

    fi

    cd $SourceLocation

    qb_version=`echo $qb_version | grep -oE [0-9.]+`
    git clone https://github.com/qbittorrent/qBittorrent qBittorrent-$qb_version

    cd qBittorrent-$qb_version

    if [[ $qb_version == 4.2.0 ]]; then
        git checkout master
    elif [[ $qb_version == 4.1.2 ]]; then
        git checkout release-$qb_version
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        git cherry-pick 262c3a7
    else
        git checkout release-$qb_version
    fi
    
    ./configure --prefix=/usr --disable-gui

    make -j$MAXCPUS

    mkdir -p doc-pak
    echo "qBittorrent BitTorrent client headless (qbittorrent-nox)" > description-pak

    if [[ $qb_installed == Yes ]]; then
        make install
    else
      # [[ $(which qbittorrent-nox) ]] && { apt-get purge -y qbittorrent-nox ; dpkg-r qbittorrent-headless ; }
        checkinstall -y --pkgname=qbittorrent-nox --pkgversion=$qb_version --pkggroup qbittorrent
        mv -f qbittorrent*deb $DebLocation
    fi

    cd
    echo -e "\n\n${bailvse}  QBITTORRENT-INSTALLATION-COMPLETED  ${normal}\n\n"

fi ; }

# 设置 qBittorrent#
function _setqbt() {
bash $local_packages/install/qbittorrent/configure -u $iUser -p $iPass -w 2017 -i 9002
}

# --------------------- 安装 Deluge --------------------- #

function _installde() {

    if [[ $de_test == yes ]]; then

        [[ $de_version == yes ]] && bash <(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/install/install_deluge) -v $de_version

        [[ $de_branch  == yes ]] && bash <(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/install/install_deluge) -b $de_version &&
        wget -q https://github.com/Aniverse/filesss/raw/master/TorrentGrid.js -O /usr/lib/python2.7/dist-packages/deluge-1.3.15.dev0-py2.7.egg/deluge/ui/web/js/deluge-all/TorrentGrid.js

    else

if [[ $de_version == "Install from repo" ]]; then

    apt-get install -y deluge deluged deluge-web deluge-console deluge-gtk

elif [[ $de_version == "Install from PPA" ]]; then

    apt-get install -y software-properties-common
    add-apt-repository -y ppa:deluge-team/ppa
    apt-get update
    apt-get install -y deluge deluged deluge-web deluge-console deluge-gtk

else

    # 安装 Deluge 依赖
    apt-get install -y python python-twisted python-openssl python-setuptools intltool python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako python-pip

    # Deluge 2.0 需要高版本的这些
    [[ $Deluge_2_later == Yes ]] &&
    pip install --upgrade pip &&
    /usr/local/bin/pip install --upgrade twisted pillow rencode pyopenssl

    cd $SourceLocation

    if [[ $Deluge_1_3_15_skip_hash_check_patch == Yes ]]; then
        export de_version=1.3.15
        wget --no-check-certificate -O deluge-$de_version.tar.gz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Deluge/deluge-$de_version.skip.tar.gz
        tar xf deluge-$de_version.tar.gz
        rm -f deluge-$de_version.tar.gz
        cd deluge-$de_version
    elif [[ $de_version == 2.0.dev ]]; then
        git clone -b develop https://github.com/deluge-torrent/deluge deluge-$de_version
        cd deluge-$de_version
    else
        wget --no-check-certificate http://download.deluge-torrent.org/source/deluge-$de_version.tar.gz
        tar xf deluge-$de_version.tar.gz
        rm -f deluge-$de_version.tar.gz
        cd deluge-$de_version
    fi

    ### 修复稍微新一点的系统（比如 Debian 8）（Ubuntu 14.04 没问题）下 RPC 连接不上的问题。这个问题在 Deluge 1.3.11 上已解决
    ### http://dev.deluge-torrent.org/attachment/ticket/2555/no-sslv3.diff
    ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.9/deluge/core/rpcserver.py
    ### https://github.com/deluge-torrent/deluge/blob/deluge-1.3.11/deluge/core/rpcserver.py

    if [[ $Deluge_ssl_fix_patch == Yes ]]; then
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
    python setup.py install --install-layout=deb --record $LogLocation/install_deluge_filelist_$de_version.txt  > /dev/null # 输出太长了，省略大部分，反正也不重要
    python setup.py install_data # 给桌面环境用的

    [[ $Deluge_ssl_fix_patch == Yes ]] && mv -f /usr/bin/deluged2 /usr/bin/deluged # 让老版本 Deluged 保留，其他用新版本

fi

    fi

cd ; echo -e "\n\n\n\n${bailanse}  DELUGE-INSTALLATION-COMPLETED  ${normal}\n\n\n" ; }





# --------------------- Deluge 启动脚本、配置文件 --------------------- #

function _setde() {

mkdir -p /home/${iUser}/deluge/{download,torrent,watch} /var/www
rm -rf /var/www/h5ai/deluge
ln -s /home/${iUser}/deluge/download /var/www/h5ai/deluge
chmod -R 777 /home/${iUser}/deluge
chown -R ${iUser}:${iUser} /home/${iUser}/deluge

chmod -R 666 /etc/inexistence/01.Log

mkdir -p /root/.config && cd /root/.config
[[ -d /root/.config/deluge ]] && { rm -rf /root/.config/deluge.old ; mv -f /root/.config/deluge /root/.config/deluge.old ; }
cp -rf /etc/inexistence/00.Installation/template/config/deluge /root/.config/deluge
chmod -R 666 /root/.config
cd

cat >/etc/inexistence/00.Installation/script/special/deluge.userpass.py<<EOF
#!/usr/bin/env python
#
# Deluge password generator
#
#   deluge.password.py <password> <salt>
#
#

import hashlib
import sys

password = sys.argv[1]
salt = sys.argv[2]

s = hashlib.sha1()
s.update(salt)
s.update(password)

print s.hexdigest()
EOF

DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
DWP=$(python /etc/inexistence/00.Installation/script/special/deluge.userpass.py ${iPass} ${DWSALT})
echo "${iUser}:${iPass}:10" >> /root/.config/deluge/auth
sed -i "s/delugeuser/${iUser}/g" /root/.config/deluge/core.conf
sed -i "s/DWSALT/${DWSALT}/g" /root/.config/deluge/web.conf
sed -i "s/DWP/${DWP}/g" /root/.config/deluge/web.conf

cp -f /etc/inexistence/00.Installation/template/systemd/deluged.service /etc/systemd/system/deluged.service
cp -f /etc/inexistence/00.Installation/template/systemd/deluge-web.service /etc/systemd/system/deluge-web.service
[[ $Deluge_2_later == Yes ]] && sed -i "s/deluge-web -l/deluge-web -d -l/" /etc/systemd/system/deluge-web.service

systemctl daemon-reload
systemctl enable /etc/systemd/system/deluge-web.service
systemctl enable /etc/systemd/system/deluged.service
systemctl start deluged
systemctl start deluge-web

touch $LockLocation/deluge.lock ; }





# --------------------- 使用修改版 rtinst 安装 rTorrent, ruTorrent，h5ai, vsftpd --------------------- #

function _installrt() {

bash -c "$(wget --no-check-certificate -qO- https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup)"

sed -i "s/make\ \-s\ \-j\$(nproc)/make\ \-s\ \-j${MAXCPUS}/g" /usr/local/bin/rtupdate

if [[ $rt_installed == Yes ]]; then
    rtupdate $IPv6Opt $rt_versionIns
else
    rtinst --ssh-default --ftp-default --rutorrent-master --force-yes --log $IPv6Opt -v $rt_versionIns -u $iUser -p $iPass -w $iPass
fi

mv /root/rtinst.log $LogLocation/07.rtinst.script.log
mv /home/${iUser}/rtinst.info $LogLocation/07.rtinst.info.txt
ln -s /home/${iUser} /var/www/h5ai/user.folder

cp -f /etc/inexistence/00.Installation/template/systemd/rtorrent@.service /etc/systemd/system/rtorrent@.service
cp -f /etc/inexistence/00.Installation/template/systemd/irssi@.service /etc/systemd/system/irssi@.service

touch $LockLocation/rtorrent.lock
cd ; echo -e "\n\n\n\n${baihongse}  RT-INSTALLATION-COMPLETED  ${normal}\n\n\n" ; }





# --------------------- 安装 Node.js 与 flood --------------------- #

function _installflood() {

# https://github.com/nodesource/distributions/blob/master/README.md
# curl -sL https://deb.nodesource.com/setup_11.x | bash -
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y nodejs build-essential python-dev
npm install -g node-gyp
git clone --depth=1 https://github.com/jfurrow/flood.git /srv/flood
cd /srv/flood
cp config.template.js config.js
npm install
sed -i "s/127.0.0.1/0.0.0.0/" /srv/flood/config.js

npm run build 2>&1 | tee /tmp/flood.log
rm -rf $LockLocation/flood.fail.lock
# [[ `grep "npm ERR!" /tmp/flood.log` ]] && touch $LockLocation/flood.fail.lock

cp -f /etc/inexistence/00.Installation/template/systemd/flood.service /etc/systemd/system/flood.service
systemctl start flood
systemctl enable flood

touch $LockLocation/flood.lock

cd ; echo -e "\n\n\n\n${baihongse}  FLOOD-INSTALLATION-COMPLETED  ${normal}\n\n\n" ; }






# --------------------- 安装 Transmission --------------------- #

function _installtr() {

if [[ "${tr_version}" == "Install from repo" ]]; then

    apt-get install -y transmission-daemon

elif [[ "${tr_version}" == "Install from PPA" ]]; then

    apt-get install -y software-properties-common
    add-apt-repository -y ppa:transmissionbt/ppa
    apt-get update
    apt-get install -y transmission-daemon

else

  # [[ `dpkg -l | grep transmission-daemon` ]] && apt-get purge -y transmission-daemon

    apt-get install -y build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev ca-certificates libssl-dev pkg-config checkinstall cmake git # > /dev/null
    apt-get install -y openssl
    [[ $CODENAME == stretch ]] && apt-get install -y libssl1.0-dev # https://tieba.baidu.com/p/5532509017?pn=2#117594043156l

    cd $SourceLocation
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
        wget --no-check-certificate -O transmission-$tr_version.tar.gz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/TransmissionMod/transmission-$tr_version.tar.gz
        tar xf transmission-$tr_version.tar.gz ; rm -f transmission-$tr_version.tar.gz
        cd transmission-$tr_version
    else
        git clone https://github.com/transmission/transmission transmission-$tr_version
        cd transmission-$tr_version
        git checkout $tr_version
        # 修复 Transmission 2.92 无法在 Ubuntu 18.04 下编译的问题（openssl 1.1.0），https://github.com/transmission/transmission/pull/24
        [[ $tr_version == 2.92 ]] && { git config --global user.email "you@example.com" ; git config --global user.name "Your Name" ; git cherry-pick eb8f500 -m 1 ; }
        # 修复 2.93 以前的版本可能无法过 configure 的问题，https://github.com/transmission/transmission/pull/215
        [[ ! `grep m4_copy_force m4/glib-gettext.m4 ` ]] && sed -i "s/m4_copy/m4_copy_force/g" m4/glib-gettext.m4
        # 解决 Transmission 2.9X 版本文件打开数被限制到 1024 的问题，https://github.com/transmission/transmission/issues/309
        # [[ `grep FD_SETSIZE=1024 CMakeLists.txt ` ]] && sed -i "s/FD_SETSIZE=1024/FD_SETSIZE=777777/g" CMakeLists.txt
        # 经测试发现没啥卵用，还是不改了 ……
    fi

    ./autogen.sh
    ./configure --prefix=/usr

    mkdir -p doc-pak
    echo "A fast, easy, and free BitTorrent client" > description-pak

    make -j$MAXCPUS

    if [[ $tr_installed == Yes ]]; then
        make install
    else
        checkinstall -y --pkgversion=$tr_version --pkgname=transmission-seedbox --pkggroup transmission
        mv -f tr*deb $DebLocation
    fi

fi

cd ; echo -e "\n\n\n\n${baizise}  TR-INSTALLATION-COMPLETED  ${normal}\n\n\n" ; }





# --------------------- 配置 Transmission --------------------- #

function _settr() {

echo 1 | bash -c "$(wget --no-check-certificate -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control.sh)"

[[ -d /root/.config/transmission-daemon ]] && rm -rf /root/.config/transmission-daemon.old && mv /root/.config/transmission-daemon /root/.config/transmission-daemon.old

mkdir -p /home/${iUser}/transmission/{download,torrent,watch} /var/www /root/.config/transmission-daemon
chmod -R 777 /home/${iUser}/transmission
chown -R ${iUser}:${iUser} /home/${iUser}/transmission
rm -rf /var/www/h5ai/transmission
ln -s /home/${iUser}/transmission/download /var/www/h5ai/transmission

cp -f /etc/inexistence/00.Installation/template/config/transmission.settings.json /root/.config/transmission-daemon/settings.json
cp -f /etc/inexistence/00.Installation/template/systemd/transmission.service /etc/systemd/system/transmission.service
[[ `command -v transmission-daemon` == /usr/local/bin/transmission-daemon ]] && sed -i "s/usr/usr\/local/g" /etc/systemd/system/transmission.service

sed -i "s/RPCUSERNAME/${iUser}/g" /root/.config/transmission-daemon/settings.json
sed -i "s/RPCPASSWORD/${iPass}/g" /root/.config/transmission-daemon/settings.json

systemctl daemon-reload
systemctl enable transmission
systemctl start transmission

touch $LockLocation/transmission.lock ; }





# --------------------- 安装、配置 Flexget --------------------- #

function _installflex() {

  apt-get -y install python-pip
  pip install --upgrade pip setuptools
  /usr/local/bin/pip install markdown
  /usr/local/bin/pip install flexget
  /usr/local/bin/pip install transmissionrpc
  /usr/local/bin/pip install deluge-client

  mkdir -p /home/${iUser}/{transmission,qbittorrent,rtorrent,deluge}/{download,watch} /root/.config/flexget

  cp -f /etc/inexistence/00.Installation/template/config/flexget.config.yml /root/.config/flexget/config.yml
  sed -i "s/SCRIPTUSERNAME/${iUser}/g" /root/.config/flexget/config.yml
  sed -i "s/SCRIPTPASSWORD/${iPass}/g" /root/.config/flexget/config.yml

  touch /home/$iUser/cookies.txt

  flexget web passwd $iPass 2>&1 | tee /tmp/flex.pass.output
  rm -rf $LockLocation/flexget.{pass,conf}.lock
  [[ `grep "not strong enough" /tmp/flex.pass.output` ]] && { export FlexPassFail=1 ; echo -e "\nFailed to set flexget webui password\n"            ; touch $LockLocation/flexget.pass.lock ; }
  [[ `grep "schema validation" /tmp/flex.pass.output` ]] && { export FlexConfFail=1 ; echo -e "\nFailed to set flexget config and webui password\n" ; touch $LockLocation/flexget.conf.lock ; }

  cp -f /etc/inexistence/00.Installation/template/systemd/flexget.service /etc/systemd/system/flexget.service
  systemctl daemon-reload
  systemctl enable /etc/systemd/system/flexget.service
  systemctl start flexget

  touch $LockLocation/flexget.lock
  echo -e "\n\n\n${bailvse}  FLEXGET-INSTALLATION-COMPLETED  ${normal}\n\n" ; }







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
touch $LockLocation/rclone.lock
echo -e "\n\n\n${bailvse}  RCLONE-INSTALLATION-COMPLETED  ${normal}\n\n" ; }






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
echo -e "\n\n${bailvse}  BBR-INSTALLATION-COMPLETED  ${normal}\n" ; }

# 安装 4.11.12 的内核
# 2019.04.09 我看也写成单独脚本算了
function _bbr_kernel_4_11_12() {

if [[ $CODENAME == stretch ]]; then
    [[ ! `dpkg -l | grep libssl1.0.0` ]] && { echo -ne "\n  {bold}Installing libssl1.0.0 ...${normal} "
    # 2019.04.09 为毛要用 hk 的？估摸着我当时问毛球要的？
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
touch $LockLocation/bbr.lock ; }


# Online.net 独服补充固件（For BBR）
# 下次看看 efs 巨佬的
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
$iPass
$iPass
EOF
vncserver && vncserver -kill :1
cd; mkdir -p .vnc
cp -f /etc/inexistence/00.Installation/template/xstartup.1.xfce4 /root/.vnc/xstartup
chmod +x /root/.vnc/xstartup
cp -f /etc/inexistence/00.Installation/template/systemd/vncserver.service /etc/systemd/system/vncserver.service

systemctl daemon-reload
systemctl enable vncserver
systemctl start vncserver
systemctl status vncserver

touch $LockLocation/vnc.lock

echo -e "\n\n\n${bailvse}  VNC-INSTALLATION-COMPLETED  ${normal}\n\n" ; }






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

touch $LockLocation/x2go.lock

echo -e "\n\n\n${bailvse}  X2GO-INSTALLATION-COMPLETED  ${normal}\n\n" ; }





# --------------------- 安装 wine 与 mono --------------------- #

function _installwine() {

# mono
# http://www.mono-project.com/download/stable/#download-lin
# https://download.mono-project.com/sources/mono/
# http://www.mono-project.com/docs/compiling-mono/compiling-from-git/

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/${DISTROL} stable-${CODENAME} main" > /etc/apt/sources.list.d/mono.list
apt-get -y update
apt-get install -y mono-complete ca-certificates-mono

echo -e "\n\n\n${bailanse}  MONO-INSTALLATION-COMPLETED  ${normal}\n\n"

# wine
# https://wiki.winehq.org/Debian

dpkg --add-architecture i386
wget --no-check-certificate -qO- https://dl.winehq.org/wine-builds/Release.key | apt-key add -
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 76F1A20FF987672F

if [[ $DISTRO == Ubuntu ]]; then
    apt-get install -y software-properties-common
    apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu/
elif [[ $DISTRO == Debian ]]; then
    echo "deb https://dl.winehq.org/wine-builds/${DISTROL}/ ${CODENAME} main" > /etc/apt/sources.list.d/wine.list
fi

apt-get update -y
apt-get install -y --install-recommends winehq-stable

wget --no-check-certificate -q https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
mv winetricks /usr/local/bin

touch $LockLocation/winemono.lock

echo -e "\n\n\n${bailvse}Version${normal}"
echo "${bold}${green}`wine --version`"
echo "mono `mono --version 2>&1 | head -n1 | awk '{print $5}'`${normal}"
echo -e "\n\n\n${bailanse}  WINE-INSTALLATION-COMPLETED  ${normal}\n\n" ; }





# --------------------- 安装 mkvtoolnix／mktorrent／ffmpeg／mediainfo／eac3to --------------------- #

function _installtools() {

########## Blu-ray ##########

wget --no-check-certificate -qO /usr/local/bin/bluray https://github.com/Aniverse/bluray/raw/master/bluray
chmod +x /usr/local/bin/bluray

########## 安装 新版 ffmpeg ##########
cd ; wget --no-check-certificate -qO ffmpeg-4.1-64bit-static.tar.xz https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Other%20Tools/ffmpeg-4.1-64bit-static.tar.xz
tar xf ffmpeg-4.1-64bit-static.tar.xz
rm -rf ffmpeg-*bit-static/{manpages,presets,model,readme.txt,GPLv3.txt}
cp -f ffmpeg-*-64bit-static/* /usr/bin
chmod 755 /usr/bin/{ffmpeg,ffprobe,ffmpeg-10bit,qt-faststart}
rm -rf ffmpeg-*-64bit-static*

########## 安装 新版 mkvtoolnix 与 mediainfo ##########

wget --no-check-certificate -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -
echo "deb https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" > /etc/apt/sources.list.d/mkvtoolnix.list
echo "deb-src https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" >> /etc/apt/sources.list.d/mkvtoolnix.list

wget --no-check-certificate -q https://mediaarea.net/repo/deb/repo-mediaarea_1.0-6_all.deb
dpkg -i repo-mediaarea_1.0-6_all.deb
rm -rf repo-mediaarea_1.0-6_all.deb

apt-get -y update
apt-get install -y mkvtoolnix mkvtoolnix-gui mediainfo mktorrent imagemagick

######################  eac3to  ######################

cd /etc/inexistence/02.Tools/eac3to
wget --no-check-certificate -q http://madshi.net/eac3to.zip
unzip -qq eac3to.zip
rm -rf eac3to.zip ; cd

touch $LockLocation/tools.lock

echo -e "\n\n\n${bailvse}Version${normal}${bold}${green}"
mktorrent -h | head -n1
mkvmerge --version
echo "Mediainfo `mediainfo --version | grep Lib | cut -c17-`"
echo "ffmpeg `ffmpeg 2>&1 | head -n1 | awk '{print $3}'`${normal}"
echo -e "\n\n\n${bailanse}  TOOLBOX-INSTALLATION-COMPLETED  ${normal}\n\n" ; }





# --------------------- 一些设置修改 --------------------- #
function _tweaks() {

# 修改时区为东八区
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

ntpdate time.windows.com
hwclock -w

# 修改语言为英语
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
echo 'LANG="en_US.UTF-8"' > /etc/default/locale
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=en_US.UTF-8

# screen 设置
cat >> /etc/screenrc <<EOF
shell -$SHELL

startup_message off
defutf8 on
defencoding utf8  
encoding utf8 utf8 
defscrollback 23333
EOF

# alias 与 文字编码
bash $local_packages/install/alias $iUser $wangka $LogTimes

# 将最大的分区的保留空间设置为 0%
tune2fs -m 0 $(df -k | sort -rn -k4 | awk '{print $1}' | head -1)

locale-gen en_US.UTF-8
locale
sysctl -p

apt-get -y autoremove

touch $LockLocation/tweaks.lock ; }





# --------------------- 结尾 --------------------- #

function _end() {

[[ $USESWAP == Yes ]] && _disable_swap

_check_install_2

unset INSFAILED QBFAILED TRFAILED DEFAILED RTFAILED FDFAILED FXFAILED

#if [[ ! $rt_version == No ]]; then RTWEB="/rt" ; TRWEB="/tr" ; DEWEB="/de" ; QBWEB="/qb" ; sss=s ; else RTWEB="/rutorrent" ; TRWEB=":9099" ; DEWEB=":8112" ; QBWEB=":2017" ; fi

RTWEB="/rutorrent" ; TRWEB=":9099" ; DEWEB=":8112" ; QBWEB=":2017"
FXWEB=":6566" ; FDWEB=":3000"

if [[ `  ps -ef | grep deluged | grep -v grep ` ]] && [[ `  ps -ef | grep deluge-web | grep -v grep ` ]] ; then destatus="${green}Running ${normal}" ; else destatus="${red}Inactive${normal}" ; fi

# systemctl is-active flexget 其实不准，flexget daemon status 输出结果太多种……
# [[ $(systemctl is-active flexget) == active ]] && flexget_status="${green}Running ${normal}" || flexget_status="${red}Inactive${normal}"

flexget daemon status 2>&1 >> /tmp/flexgetpid.log # 这个速度慢了点但应该最靠谱
[[ `grep PID /tmp/flexgetpid.log` ]] && flexget_status="${green}Running  ${normal}" || flexget_status="${red}Inactive ${normal}"
[[ -e $LockLocation/flexget.pass.lock ]] && flexget_status="${bold}${bailanse}CheckPass${normal}"
[[ -e $LockLocation/flexget.conf.lock ]] && flexget_status="${bold}${bailanse}CheckConf${normal}"
Installation_FAILED="${bold}${baihongse} ERROR ${normal}"

clear

echo -e " ${baiqingse}${bold}      INSTALLATION COMPLETED      ${normal} \n"
echo '---------------------------------------------------------------------------------'


if   [[ ! $qb_version == No ]] && [[ $qb_installed == Yes ]]; then
     echo -e " ${cyan}qBittorrent WebUI${normal}   $(_if_running qbittorrent-nox    )   http${sss}://${serveripv4}${QBWEB}"
elif [[ ! $qb_version == No ]] && [[ $qb_installed == No ]]; then
     echo -e " ${red}qBittorrent WebUI${normal}   ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     QBFAILED=1 ; INSFAILED=1
fi


if   [[ ! $de_version == No ]] && [[ $de_installed == Yes ]]; then
     echo -e " ${cyan}Deluge WebUI${normal}        $destatus   http${sss}://${serveripv4}${DEWEB}"
elif [[ ! $de_version == No ]] && [[ $de_installed == No ]]; then
     echo -e " ${red}Deluge WebUI${normal}        ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     DEFAILED=1 ; INSFAILED=1
fi


if   [[ ! $tr_version == No ]] && [[ $tr_installed == Yes ]]; then
     echo -e " ${cyan}Transmission WebUI${normal}  $(_if_running transmission-daemon)   http${sss}://${iUser}:${iPass}@${serveripv4}${TRWEB}"
elif [[ ! $tr_version == No ]] && [[ $tr_installed == No ]]; then
     echo -e " ${red}Transmission WebUI${normal}  ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     TRFAILED=1 ; INSFAILED=1
fi


if   [[ ! $rt_version == No ]] && [[ $rt_installed == Yes ]]; then
     echo -e " ${cyan}RuTorrent${normal}           $(_if_running rtorrent           )   https://${iUser}:${iPass}@${serveripv4}${RTWEB}"
     [[ $InsFlood == Yes ]] && [[ ! -e $LockLocation/flood.fail.lock ]] && 
     echo -e " ${cyan}Flood${normal}               $(_if_running npm                )   http://${serveripv4}${FDWEB}"
     [[ $InsFlood == Yes ]] && [[   -e $LockLocation/flood.fail.lock ]] &&
     echo -e " ${red}Flood${normal}               ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}" && { INSFAILED=1 ; FDFAILED=1 ; }
     echo -e " ${cyan}h5ai File Indexer${normal}   $(_if_running nginx              )   https://${iUser}:${iPass}@${serveripv4}/h5ai"
   # echo -e " ${cyan}webmin${normal}              $(_if_running webmin             )   https://${serveripv4}/webmin"
elif [[ ! $rt_version == No ]] && [[ $rt_installed == No  ]]; then
     echo -e " ${red}RuTorrent${normal}           ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     [[ $InsFlood == Yes ]] && [[ ! -e $LockLocation/flood.fail.lock ]] &&
     echo -e " ${cyan}Flood${normal}               $(_if_running npm                )   http://${serveripv4}${FDWEB}"
     [[ $InsFlood == Yes ]] && [[   -e $LockLocation/flood.fail.lock ]] &&
     echo -e " ${red}Flood${normal}               ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}" && FDFAILED=1
   # echo -e " ${cyan}h5ai File Indexer${normal}   $(_if_running webmin             )   https://${iUser}:${iPass}@${serveripv4}/h5ai"
     RTFAILED=1 ; INSFAILED=1
fi

# flexget 状态可能是 8 位字符长度的
if   [[ ! $InsFlex == No ]] && [[ $flex_installed == Yes ]]; then
     echo -e " ${cyan}Flexget WebUI${normal}       $flexget_status  http://${serveripv4}${FXWEB}" #${bold}(username is ${underline}flexget${reset_underline}${normal})
elif [[ ! $InsFlex == No ]] && [[ $flex_installed == No  ]]; then
     echo -e " ${red}Flexget WebUI${normal}       ${bold}${baihongse} ERROR ${normal}    ${bold}${red}Installation FAILED${normal}"
     FXFAILED=1 ; INSFAILED=1
fi


#    echo -e " ${cyan}MkTorrent WebUI${normal}            https://${iUser}:${iPass}@${serveripv4}/mktorrent"


echo
echo -e " ${cyan}Your Username${normal}       ${bold}${iUser}${normal}"
echo -e " ${cyan}Your Password${normal}       ${bold}${iPass}${normal}"
[[ ! $InsFlex == No ]] && [[ $flex_installed == Yes ]] &&
echo -e " ${cyan}Flexget Login${normal}       ${bold}flexget${normal}"
[[ $InsRDP == VNC ]] && [[ $CODENAME == xenial ]] &&
echo -e " ${cyan}VNC  Password${normal}       ${bold}` echo ${iPass} | cut -c1-8` ${normal}"
# [[ $DeBUG == 1 ]] && echo "FlexConfFail=$FlexConfFail  FlexPassFail=$FlexPassFail"
[[ -e $LockLocation/flexget.pass.lock ]] &&
echo -e "\n ${bold}${bailanse} Naive! ${normal} You need to set Flexget WebUI password by typing \n          ${bold}flexget web passwd <new password>${normal}"
[[ -e $LockLocation/flexget.conf.lock ]] &&
echo -e "\n ${bold}${bailanse} Naive! ${normal} You need to check your Flexget config file\n          maybe your password is too young too simple?${normal}"

echo '---------------------------------------------------------------------------------'
echo

timeWORK=installation
_time

    if [[ ! $INSFAILED == "" ]]; then
echo -e "\n ${bold}Unfortunately something went wrong during installation.
 You can check logs by typing these commands:
 ${yellow}cat /etc/inexistence/01.Log/installed.log"
[[ ! $QBFAILED == "" ]] && echo -e " cat $LogLocation/05.qb1.log" #&& echo "QBLTCFail=$QBLTCFail   QBCFail=$QBCFail"
[[ ! $DEFAILED == "" ]] && echo -e " cat $LogLocation/03.de1.log" #&& echo "DELTCFail=$DELTCFail"
[[ ! $TRFAILED == "" ]] && echo -e " cat $LogLocation/08.tr1.log"
[[ ! $RTFAILED == "" ]] && echo -e " cat $LogLocation/07.rt.log\n cat $LogLocation/07.rtinst.script.log"
[[ ! $FDFAILED == "" ]] && echo -e " cat $LogLocation/07.flood.log"
[[ ! $FXFAILED == "" ]] && echo -e " cat $LogLocation/10.flexget.log"
echo -ne "${normal}"
    fi

echo ; }





# --------------------- 结构 --------------------- #

_intro
_askusername
_askpassword
[[ $SKIPAPPS == Yes ]] && echo -e "\n${baizise}Useful apps will ${baihongse}not${baizise} be installed${normal}\n"
_askaptsource
[[ -z $MAXCPUS ]] && MAXCPUS=$(nproc)   ; _askmt
[[ -z $USESWAP ]] && [[ $tram -le 1926 ]] && USESWAP=Yes ; _askswap
_askqbt
_askdeluge
if [[ ! $de_version == No ]] || [[ ! $qb_version == No ]]; then _lt_ver_ask ; fi
_askrt
[[ ! $rt_version == No ]] && 
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

mv /etc/00.info.log $LogLocation/00.info.log
mv /etc/00.setsources.log $LogLocation/00.setsources.log
mv /etc/01.setuser.log $LogLocation/01.setuser.log

# --------------------- 安装 --------------------- #


if   [[ $InsBBR == Yes ]] || [[ $InsBBR == To\ be\ enabled ]]; then
     echo -ne "Configuring BBR ... \n\n\n" ; _install_bbr 2>&1 | tee $LogLocation/02.bbr.log
else
     echo -e  "Skip BBR installation\n\n\n\n\n"
fi


# [[ -f $LockLocation/libtorrent-rasterbar.lock ]]
[[ ! -z $lt_version ]] && [[ ! $lt_version == system ]] && _install_lt


if  [[ $qb_version == No ]]; then
    echo -e  "Skip qBittorrent installation\n\n\n\n"
else
    echo -ne "Installing qBittorrent ... \n\n\n" ; _installqbt 2>&1 | tee $LogLocation/05.qb1.log
    echo -ne "Configuring qBittorrent ... \n\n\n" ; _setqbt 2>&1 | tee $LogLocation/06.qb2.log
fi


if  [[ $de_version == No ]]; then
    echo -e  "Skip Deluge installation \n\n\n\n"
else
    echo -ne "Installing Deluge ... \n\n\n" ; _installde 2>&1 | tee $LogLocation/03.de1.log
    echo -ne "Configuring Deluge ... \n\n\n" ; _setde 2>&1 | tee $LogLocation/04.de2.log
fi


if  [[ $rt_version == No ]]; then
    echo -e  "Skip rTorrent installation\n\n\n"
else
    echo -ne "Installing rTorrent ... \n\n\n" ; _installrt 2>&1 | tee $LogLocation/07.rt.log
    [[ $InsFlood == Yes ]] && { echo -ne "Installing Flood ... \n\n\n" ; _installflood 2>&1 | tee $LogLocation/07.flood.log ; }
fi


if  [[ $tr_version == No ]]; then
    echo -e  "Skip Transmission installation\n\n\n\n"
else
    echo -ne "Installing Transmission ... \n\n\n" ; _installtr 2>&1 | tee $LogLocation/08.tr1.log
    echo -ne "Configuring Transmission ... \n\n\n" ; _settr 2>&1 | tee $LogLocation/09.tr2.log
fi


if  [[ $InsFlex == Yes ]]; then
    echo -ne "Installing Flexget ... \n\n\n" ; _installflex 2>&1 | tee $LogLocation/10.flexget.log
else
    echo -e  "Skip Flexget installation\n\n\n\n"
fi


if  [[ $InsRclone == Yes ]]; then
    echo -ne "Installing rclone ... " ; _installrclone 2>&1 | tee $LogLocation/11.rclone.log
else
    echo -e  "Skip rclone installation\n\n\n\n"
fi


####################################

if   [[ $InsRDP == VNC ]]; then
     echo -ne "Installing VNC ... \n\n\n" ; _installvnc 2>&1 | tee $LogLocation/12.rdp.log
elif [[ $InsRDP == X2Go ]]; then
     echo -ne "Installing X2Go ... \n\n\n" ; _installx2go 2>&1 | tee $LogLocation/12.rdp.log
else
     echo -e  "Skip RDP installation\n\n\n\n"
fi


if  [[ $InsWine == Yes ]]; then
    echo -ne "Installing Wine ... \n\n\n" ; _installwine 2>&1 | tee $LogLocation/12.wine.log
else
    echo -e  "Skip Wine installation\n\n\n\n"
fi


if  [[ $InsTools == Yes ]]; then
    echo -ne "Installing Uploading Toolbox ... \n\n\n" ; _installtools 2>&1 | tee $LogLocation/13.tool.log
else
    echo -e  "Skip Uploading Toolbox installation\n\n\n\n"
fi

####################################

if [[ $UseTweaks == Yes ]]; then
    echo -ne "Configuring system settings ... \n\n\n" ; _tweaks
else
    echo -e  "Skip System tweaks\n\n\n\n"
fi


_end 2>&1 | tee $LogTimes/end.log
rm "$0" >> /dev/null 2>&1
_askreboot

