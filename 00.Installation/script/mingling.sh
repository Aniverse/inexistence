#!/bin/bash
# Author: 弱鸡
# 方便盒子使用的一个辣鸡脚本

# --------------------------------
# echo $de_installed $rt_installed $qb_installed $tr_installed $flex_installed $rclone_installed $virtwhat_installed $lsb_installed $smartctl_installed

# 一些改进方向--------------------------------
# 1. 开关客户端那边，允许不使用 systemd 来开关（有一个问题，rt/qb这两个比较特殊，不同的人习惯的方法不一样）
# 2. 增加硬盘IO、网速的测试

# 判断客户端是否在运行---------------------------------------------------------------------

function _is_running_1 () {
    ps -ef | grep $kehuduan | grep -v grep > /dev/null
}

function _is_running_2(){
  _is_running_1
  if ( _is_running_1 ); then
      client_status="${green}${bold}正在运行${white}"
  else
      client_status="${red}${bold}没在运行${white}"
  fi
}

# 独服单块硬盘通电时间检测（对RAID无效）、硬盘空间计算 --------------------------------------------------------------------------------

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

power_time() {
	result=$(smartctl -a $(result=$(cat /proc/mounts) && echo $(echo "$result" | awk '/data=ordered/{print $1}') | awk '{print $1}') 2>&1) && power_time=$(echo "$result" | awk '/Power_On/{print $10}') && echo "$power_time"
}

# 检查是否安装了客户端 ----------------------------------------------------------------------- #

# 检查用的脚本
function _check_install(){
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
  elif [[ "${client_name}" == "virt-what" ]]; then
      client_name=virtwhat
  elif [[ "${client_name}" == "lsb_release" ]]; then
      client_name=lsb
  fi

  if [[ -a $client_location ]]; then
      eval "${client_name}"_installed=Yes
  else
      eval "${client_name}"_installed=No
  fi
}

# 检查客户端安装情况
for apps in qbittorrent-nox deluged rtorrent transmission-daemon flexget rclone virt-what lsb_release smartctl irssi ffmepg mediainfo; do
    client_name=$apps; _check_install
done

# 操作系统检测
get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

if [ -f /etc/redhat-faxingban ]; then
    faxingban="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    faxingban="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    faxingban="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    faxingban="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    faxingban="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    faxingban="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    faxingban="centos"
fi

# 颜色 -----------------------------------------------------------------------------------

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

# 定义变量 --------------------------------------------------------------------------------

lbit=$( getconf LONG_BIT )
opsy=$( get_opsy )
kern=$( uname -r )
serveripv4=$( wget --no-check-certificate -qO- http://v4.ipv6-test.com/api/myip.php) >> /dev/null 2>&1
serveripv6=$( wget --no-check-certificate -qO- -t1 -T2 ipv6.icanhazip.com )

disk_size1=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $2}' ))
disk_size2=($( LANG=C df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem' | awk '{print $3}' ))
disk_total_size=$( calc_disk ${disk_size1[@]} )
disk_used_size=$( calc_disk ${disk_size2[@]} )
uptime1=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days %d hour %d min\n",a,b,c)}' /proc/uptime )
uptime2=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
cputhreads=$( grep 'processor' /proc/cpuinfo | sort -u | wc -l )
cpucores=$( grep 'core id' /proc/cpuinfo | sort -u | wc -l )
physical_cpu_number=$( grep 'physical id' /proc/cpuinfo | cut -c15-17 )
cpu_percent=$( top -b -n 1|grep Cpu|awk '{print $2}'|cut -f 1 -d "." )

freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
swap=$( free -m | awk '/Swap/ {print $2}' )
uswap=$( free -m | awk '/Swap/ {print $3}' )
memory_usage=`free -m |grep -i mem | awk '{printf ("%.2f\n",$3/$2*100)}'`%
root_usage=`df -h / | awk '/\// {print $(NF-1)}'`
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", "exit !$2;$3/$2*100") }'`
users=`users | wc -w`
processes=`ps aux | wc -l`
date=$( date +%Y-%m-%d" "%H:%M:%S )

INEXISTENCE=$(cat /etc/profile | grep INEXISTENCE | cut -c13-)

# --------------------------------------------------------------------------------





# 00. 脚本的欢迎界面，还没写好
function _logo() {

clear
wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/03.Files/mingling.logo.1

if [[ $EUID != 0 ]]; then
    echo "${bold}你需要用 root 权限来运行本脚本${normal}"
	exit 1
fi

if [[ ! "$faxingban" =~ ("ubuntu"|"debian") ]]; then
    echo "${bold}${red}你运行的似乎不是 ${green}Debian/Ubuntu${white} 系统，本脚本的大部分功能无法正常使用${normal}"
fi

if [[ ! "$INEXISTENCE" == 1 ]]; then
    echo "${bold}${red}你似乎没有安装 inexistence 脚本，本脚本的部分功能无法正常使用${normal}"
fi

#echo -e "${bold}"
#echo -e ""
#echo -e "${normal}"
}





# 00. 导航菜单
function _main_menu() {

  echo
  stty -echo
  echo -e "${yellow}${bold}你想做些什么？ (默认选择退出)"
  echo -e ""

  if [[ "$INEXISTENCE" == 1 ]]; then
      echo -e "${green}(01) ${white}查看 SSH 命令"
	  echo -e "${green}(02) ${white}查看客户端的网址"
  fi

  echo -e "${green}(03) ${white}查看系统信息"
  echo -e "${green}(04) ${white}查看客户端版本"
  echo -e "${green}(05) ${white}查看客户端是否都在运行"
  echo -e "${green}(06) ${white}进入客户端操作菜单"
  echo -e "${green}(07) ${white}运行其他脚本"
  echo -e "${green}(08) ${white}查看本脚本的说明"
  echo -e "${green}(09) ${white}退出脚本"
  echo -e "${normal}"
read response
case $response in
    1 | 01) thingstodo=1 ;;
    2 | 02) thingstodo=2 ;;
    3 | 03) thingstodo=3 ;;
    4 | 04) thingstodo=4 ;;
    5 | 05) thingstodo=5 ;;
    6 | 06) thingstodo=6 ;;
    7 | 07) thingstodo=7 ;;
    8 | 08) thingstodo=8 ;;
    9 | 09 | "") thingstodo=9 ;;
    *) thingstodo=9 ;;
esac

stty echo

_doit
}






# 00. 做啊！
function _doit() {

if [ "${thingstodo}" == "1" ]; then
    _usage ; _main_menu

elif [ "${thingstodo}" == "2" ]; then
    _showurl ; _main_menu

elif [ "${thingstodo}" == "3" ]; then
	_stats ; _main_menu

elif [ "${thingstodo}" == "4" ]; then
    _client_version_check; _show_client_version ; _main_menu

elif [ "${thingstodo}" == "5" ]; then
    _ifrunning ; _main_menu

elif [ "${thingstodo}" == "6" ]; then
    _show_client_menu ; _client_menu_response

elif [ "${thingstodo}" == "7" ]; then
   _show_scripts_menu ; _scripts_menu_response
#    echo "这个功能还没做好"; echo
#    _main_menu

elif [ "${thingstodo}" == "8" ]; then
    _doc ; _main_menu

elif [ "${thingstodo}" == "9" ]; then
    clear; exit 0

fi
}





# 01. 查看 SSH 命令
function _usage() {

clear;echo

if [[ "$INEXISTENCE" == 1 ]] && [[ "$tweaks" == Yes ]]; then

    echo -e "${bailvse}${bold}                                         01. 一些常用命令                                          ${normal}"
    echo
    echo -e "${bold}###################################################################################################"
    echo -e "#                                                                                                 #"
    echo -e "#  ${green}qba${white} = 运行 qBittorrent-nox  ${green}dea${white} = 运行 Deluged  ${green}dewa${white} = 运行 Deluge WebUI  ${green}rta${white} = 运行 rTorrent  #"
    echo -e "#  ${green}qbb${white} = 关闭 qBittorrent-nox  ${green}deb${white} = 关闭 Deluged  ${green}dewb${white} = 关闭 Deluge WebUI  ${green}rtb${white} = 关闭 rTorrent  #"
    echo -e "#  ${green}qbc${white} = 检查 qBittorrent-nox  ${green}dec${white} = 检查 Deluged  ${green}dewc${white} = 检查 Deluge WebUI  ${green}rtc${white} = 检查 rTorrent  #"
    echo -e "#  ${green}qbr${white} = 重启 qBittorrent-nox  ${green}der${white} = 重启 Deluged  ${green}dewr${white} = 重启 Deluge WebUI  ${green}rtr${white} = 重启 rTorrent  #"
    echo -e "#                                                                                                 #"
    echo -e "#  ${green}cdqb${white}     = 切换目录到 qb 的下载目录并显示内容   ${green}flexa${white} = 运行 Flexget Daemon                    #"
    echo -e "#  ${green}cdde${white}     = 切换目录到 de 的下载目录并显示内容   ${green}flexb${white} = 关闭 Flexget Daemon                    #"
    echo -e "#  ${green}cdrt${white}     = 切换目录到 rt 的下载目录并显示内容   ${green}flexc${white} = 检查 Flexget Daemon                    #"
    echo -e "#  ${green}cdtr${white}     = 切换目录到 tr 的下载目录并显示内容   ${green}flexr${white} = 重启 Flexget Daemon                    #"
    echo -e "#  ${green}shanchu${white}  = rm -rf，删除                         ${green} tra ${white} = 运行 Transmission Daemon               #"
    echo -e "#  ${green}anzhuang${white} = apt-get install -y，安装             ${green} trb ${white} = 关闭 Transmission Daemon               #"
    echo -e "#  ${green}quanxian${white} = chmod -R 777，赋予权限               ${green} trc ${white} = 检查 Transmission Daemon               #"
    echo -e "#  ${green}xiugai${white}   = 编辑快捷命令                         ${green} trr ${white} = 重启 Transmission Daemon               #"
    echo -e "#                                                                                                 #"
    echo -e "###################################################################################################${normal}"

else

    echo -e "${bold}由于你没有使用 inexistence 脚本中的 tweaks，本功能无法使用"
	echo -e "不过我还是安利下 alias，用起来比较方便。可以参考下文："
	echo -e "${green}http://man.linuxde.net/alias${normal}"

fi
}





# 02. 查看客户端的网址
function _showurl() {

clear;echo

if [[ "$INEXISTENCE" == 1 ]]; then

    echo -e " ${baiqingse}${bold}                                         02. 客户端的网址                                          ${normal} "
    echo
    echo "${bold}---------------------------------------------------------------------------------------------------"
    echo
    if [ ! "${qb_installed}" == "No" ]; then
        echo -e " ${cyan}qBittorrent WebUI${white}    http://${serveripv4}:2017"
    fi

    if [ ! "${de_installed}" == "No" ]; then
        echo -e " ${cyan}Deluge WebUI${white}         http://${serveripv4}:8112"
    fi

    if [ ! "${tr_installed}" == "No" ]; then
        echo -e " ${cyan}Transmission WebUI${white}   http://${ANUSER}:${ANPASS}@${serveripv4}:9099"
    fi

    if [ ! "${rt_installed}" == "No" ]; then
        echo -e " ${cyan}RuTorrent${white}            https://${ANUSER}:${ANPASS}@${serveripv4}/rutorrent"
    fi

    if [ ! "${flex_installed}" == "No" ]; then
        echo -e " ${cyan}Flexget WebUI${white}        http://${serveripv4}:6566"
    fi

#   echo -e " ${cyan}MkTorrent WebUI${white}      https://${ANUSER}:${ANPASS}@${serveripv4}/mktorrent"
    echo
    echo "---------------------------------------------------------------------------------------------------${normal}"

else

    echo -e "${bold}由于你没有使用 inexistence 脚本，本功能无法使用"

fi
}





# 03. 查看系统信息
function _stats() {

if [[ "${virtwhat_installed}" == "No" ]] || [[ "${lsb_installed}" == "No" ]] || [[ "${smartctl_installed}" == "No" ]]; then
    echo  -ne "${wuguangbiao}${cyan}${bold}你可能是第一次运行 mingling, ${normal}"
    echo  -ne "${cyan}${bold}现在正在安装 ${yellow}lsb-release${white} ${yellow}virt-what${white} ${yellow}smartmontools${white} 用于系统信息监测 ...${normal}"
    apt-get install -yqq virt-what lsb_release smartmontools >> /dev/null 2>&1
    echo  -e "${guangbiao}"
fi

DISTRO=$(lsb_release -is)
RELEASE=$(lsb_release -rs)
CODENAME=$(lsb_release -cs)
virtua=$(virt-what) 2>/dev/null
disk_time=$(power_time)

  clear
  echo
  echo "${bailanse}${bold}                                           03. 系统信息                                            ${normal}"
  echo "${bold}"

# echo -e "${bold}  CPU 核心数  : ${cyan}$cores${normal}"
# echo -e "${bold}  CPU 频率    : ${cyan}$freq MHz${normal}"
# echo -e "${bold}  内存占用    : ${cyan}$memory_usage${normal}"
# echo -e "${bold}  交换占用    : ${cyan}$swap_usage${normal}"

  echo -e "${bold}  CPU 型号    : ${cyan}$cname${normal}"
  echo -e "${bold}  CPU 核心    : ${cyan}${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
  echo -e "${bold}  CPU 状态    : ${cyan}${freq} MHz, ${cpu_percent}% Utilization${normal}"
  echo -e "${bold}  硬盘大小    : ${cyan}$disk_total_size GB ($disk_used_size GB Used) ($root_usage)${normal}"

  if [[ ${disk_time} ]]; then
      echo -e "${bold}  硬盘通电    : ${cyan}$disk_time Hours${normal}"
  fi

  echo -e "${bold}  内存大小    : ${cyan}$tram MB ($uram MB Used) ($memory_usage)${normal}"
  echo -e "${bold}  交换分区    : ${cyan}$swap MB ($uswap MB Used)${normal}"
  echo -e "${bold}  运行时间    : ${cyan}$uptime1${normal}"
  echo -e "${bold}  系统负载    : ${cyan}$load${normal}"
  echo
  echo -e "${bold}  操作系统    : ${cyan}$DISTRO $RELEASE $CODENAME ($lbit Bit)${normal}"
  echo -e "${bold}  系统内核    : ${cyan}$kern${normal}"
  echo -ne "${bold}  虚拟化      : "
  if [[ ${virtua} ]]; then
    echo -e "${cyan}$virtua${normal}"
  else
    echo -e "${cyan}无虚拟化 (比如独服)${normal}"
  fi
  echo -e "${bold}  IPv4 地址   : ${cyan}$serveripv4${normal}"
  echo -ne "${bold}  IPv6 地址   : ${cyan}"
  if [[ "${serveripv6}" ]]; then
    echo -e "$serveripv6${normal}"
  else
    echo -e "No IPv6 Address${normal}"
  fi
  echo -e "${bold}  服务器时间  : ${cyan}$date${normal}"

}





# 04. 查看安装的客户端的版本

# 判断软件版本。部分使用正则表达式提取数字部分，如果有类似 dev/beta 这样的版本号则无法显示出来；此外 Flexget 本身执行速度较慢
function _client_version_check() {

clear

if [[ ! "${qbtnox_ver}" ]]; then
    echo  -e "${wuguangbiao}${cyan}${bold}正在检查相关客户端的版本 ...${normal}"

    if [ ! "${qb_installed}" == "No" ]; then
        qbtnox_ver=`qbittorrent-nox --version | cut -c14-`
    else
        qbtnox_ver="好像没安装"
    fi

    if [ ! "${de_installed}" == "No" ]; then
        delugelt_ver=`deluged --version | grep libtorrent --color=never | cut -c13-`
        deluged_ver=`deluged --version | grep deluged --color=never | cut -c10-`
    else
        delugelt_ver="好像没安装"
        deluged_ver="好像没安装"
    fi

    if [ ! "${tr_installed}" == "No" ]; then
        trd_ver=`transmission-daemon --help | grep http | grep -oP --color=never '\d*\.\d*.\d+'`
    else
        trd_ver="好像没安装"
    fi

    if [ ! "${rt_installed}" == "No" ]; then
        rtorrent_ver=`rtorrent -h | grep version | sed -ne 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\)[^0-9]*/\1/p'`
    else
        rtorrent_ver="好像没安装"
    fi

    if [ ! "${flex_installed}" == "No" ]; then
        flexget_ver=`flexget -V | grep -v release`
    else
        flexget_ver="好像没安装"
    fi

    if [ ! "${rclone_installed}" == "No" ]; then
        rclone_ver=`rclone --version | grep rclone --color=never | cut -c9-`
    else
        rclone_ver="好像没安装"
    fi

    if [ ! "${irssi_installed}" == "No" ]; then
        irssi_ver=`irssi --version | cut -c7-`
    else
        irssi_ver="好像没安装"
    fi

    if [ ! "${ffmpeg_installed}" == "No" ]; then
        ffmpeg_ver=`ffmpeg -version | grep 2000 | awk '{print $(NF-6)}'`
    else
        ffmpeg_ver="好像没安装"
    fi

    if [ ! "${mediainfo_installed}" == "No" ]; then
        mp_ver=`mediainfo --version | grep Lib | cut -c17-`
    else
        mp_ver="好像没安装"
    fi



    echo  -e "${guangbiao}"

fi
}





# 显示版本
function _show_client_version() {

  clear;echo
  echo -e " ${white}${on_magenta}${bold}                                         04. 客户端的版本                                         ${normal} "
  echo
  echo -e "    ${cyan}${bold}qBittorrent${normal}          ${bold}${yellow}"${qbtnox_ver}"${normal}"
  echo -e "    ${cyan}${bold}Deluge${normal}               ${bold}${yellow}"${deluged_ver}"${normal}"
  echo -e "    ${cyan}${bold}Deluge libtorrent${normal}    ${bold}${yellow}"${delugelt_ver}"${normal}"
  echo -e "    ${cyan}${bold}rTorrent${normal}             ${bold}${yellow}"${rtorrent_ver}"${normal}"
  echo -e "    ${cyan}${bold}Transmission${normal}         ${bold}${yellow}"${trd_ver}"${normal}"
  echo -e "    ${cyan}${bold}Flexget${normal}              ${bold}${yellow}"${flexget_ver}"${normal}"
  echo -e "    ${cyan}${bold}rclone${normal}               ${bold}${yellow}"${rclone_ver}"${normal}"
  echo -e "    ${cyan}${bold}AutoDL-Irssi${normal}         ${bold}${yellow}"${irssi_ver}"${normal}"
  echo -e "    ${cyan}${bold}ffmpeg${normal}               ${bold}${yellow}"${ffmpeg_ver}"${normal}"
  echo -e "    ${cyan}${bold}mediainfo${normal}            ${bold}${yellow}"${mp_ver}"${normal}"
  echo

}





# 05. 查看客户端是否都在运行
function _ifrunning() {

clear;echo
echo -e " ${baihongse}${bold}                                        05. 客户端运行状况                                         ${normal} "
echo -e "${bold}"

if [ ! "${qb_installed}" == "No" ]; then
#   qb_status_2="$( qbc | grep Active --color=never | cut -c12- | sed 's/sin.*//' )"
    kehuduan=qbittorrent-nox
    _is_running_2
    qb_status_1="${client_status}"
    echo -e " ${cyan}qBittorrent ${white}           "${qb_status_1}""
fi

if [ ! "${de_installed}" == "No" ]; then
#   de_status_2="$( dec | grep Active --color=never | cut -c12- | sed 's/sin.*//' )"
    kehuduan=deluged
    _is_running_2
    de_status_1="${client_status}"
    echo -e " ${cyan}Deluged ${white}               "${de_status_1}""
    kehuduan=deluge-web
    _is_running_2
    dew_status_1="${client_status}"
    echo -e " ${cyan}Deluge Web ${white}            "${dew_status_1}""
fi

if [ ! "${tr_installed}" == "No" ]; then
#   tr_status_2="$( trc | grep Active --color=never | cut -c12- | sed 's/sin.*//' )"
    kehuduan=transmission-daemon
    _is_running_2
    tr_status_1="${client_status}"
    echo -e " ${cyan}Transmission ${white}          "${tr_status_1}""
fi

if [ ! "${rt_installed}" == "No" ]; then
    kehuduan=rtorrent
    _is_running_2
    rt_status_1="${client_status}"
    echo -e " ${cyan}rTorrent ${white}              "${rt_status_1}""
fi

if [ ! "${irssi_installed}" == "No" ]; then
    kehuduan=irssi
    _is_running_2
    irssi_status_1="${client_status}"
    echo -e " ${cyan}AutoDL-Irssi ${white}          "${irssi_status_1}""
fi

if [ ! "${flex_installed}" == "No" ]; then
    kehuduan=flexget
    _is_running_2
    flex_status_1="${client_status}"
    echo -e " ${cyan}Flexget ${white}               "${flex_status_1}""
fi

echo -e "${normal}"
echo -e " ${baihongse}${bold}                             注意：客户端在运行不代表你就能打开 WebUI                              ${normal}"

}





# 06-1. 客户端操作菜单
function _show_client_menu() {

  clear;echo
  echo -e " ${red}${on_white}${bold}                                        06. 客户端操作菜单                                         ${normal} "
  echo -e "${bold}"
  echo -e "${green}(01) ${white}运行 qBittorrent          ${green}(10) ${white}运行 Deluge               ${green} ${white}"
  echo -e "${green}(02) ${white}关闭 qBittorrent          ${green}(11) ${white}关闭 Deluge               ${green} ${white}"
  echo -e "${green}(03) ${white}重启 qBittorrent          ${green}(12) ${white}重启 Deluge               ${green} ${white}"
  echo -e "${green}(04) ${white}运行 Transmission         ${green}(13) ${white}运行 rTorrent             ${green} ${white}"
  echo -e "${green}(05) ${white}关闭 Transmission         ${green}(14) ${white}关闭 rTorrent             ${green} ${white}"
  echo -e "${green}(06) ${white}重启 Transmission         ${green}(15) ${white}重启 rTorrent             ${green} ${white}"
  echo -e "${green}(07) ${white}运行 Flexget Daemon       ${green}(16) ${white}重启 seedbox              ${green} ${white}"
  echo -e "${green}(08) ${white}关闭 Flexget Daemon       ${green}(17) ${white}返回 main menu            ${green} ${white}"
  echo -e "${green}(09) ${white}重启 Flexget Daemon       ${green}(18) ${white}退出 Script               ${green} ${white}"
  echo -e ""
  _systemd_check
  echo -ne "${bold}${yellow}你想做什么？(默认返回主菜单) ${normal}"
}





# 06-2. 客户端选项读取
function _client_menu_response() {

stty -echo
read response
case $response in
    01 | 1) client_action=01 ;;
    02 | 2) client_action=02 ;;
    03 | 3) client_action=03 ;;
    04 | 4) client_action=04 ;;
    05 | 5) client_action=05 ;;
    06 | 6) client_action=06 ;;
    07 | 7) client_action=07 ;;
    08 | 8) client_action=08 ;;
    09 | 9) client_action=09 ;;
    10) client_action=10 ;;
    11) client_action=11 ;;
    12) client_action=12 ;;
    13) client_action=13 ;;
    14) client_action=14 ;;
    15) client_action=15 ;;
    16) client_action=16 ;;
    17 | "") client_action=17 ;;
    18) client_action=18 ;;
    *) client_action=17 ;;
esac
stty echo
_client_action
}


function _xunwen1() {
echo -ne "${yellow}${bold}你还想做什么吗？(默认返回主菜单) ${normal}"
}


# 06-3. 客户端操作执行
function _client_action() {

wenzi1="现在应该已在运行了 ......"
wenzi2="现在应该已经关掉了 ......"
wenzi3="应该已经重启了一次 ......"

if [[ "${client_action}" == "01" ]]; then

    echo; echo
    systemctl start qbittorrent >> /dev/null 2>&1
    echo -e "${cyan}${bold}qBittorrent "${wenzi1}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "02" ]]; then

    echo; echo
    systemctl stop qbittorrent >> /dev/null 2>&1
    echo -e "${cyan}${bold}qBittorrent "${wenzi2}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "03" ]]; then

    echo; echo
    systemctl restart qbittorrent >> /dev/null 2>&1
    echo -e "${cyan}${bold}qBittorrent "${wenzi3}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "04" ]]; then

    echo; echo
    systemctl start transmission>> /dev/null 2>&1
    echo -e "${cyan}${bold}Transmission "${wenzi1}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "05" ]]; then

    echo; echo
    systemctl stop transmission >> /dev/null 2>&1
    echo -e "${cyan}${bold}Transmission "${wenzi2}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "06" ]]; then

    echo; echo
    systemctl restart transmission >> /dev/null 2>&1
    echo -e "${cyan}${bold}Transmission "${wenzi3}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "07" ]]; then

    echo; echo
    systemctl start flexget >> /dev/null 2>&1
    echo -e "${cyan}${bold}Flexget Daemon "${wenzi1}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "08" ]]; then

    echo; echo
    systemctl stop flexget >> /dev/null 2>&1
    echo -e "${cyan}${bold}Flexget Daemon "${wenzi2}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "09" ]]; then

    echo; echo
    systemctl restart flexget >> /dev/null 2>&1
    echo -e "${cyan}${bold}Flexget Daemon "${wenzi3}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "10" ]]; then

    echo; echo
    systemctl start deluged >> /dev/null 2>&1
    systemctl start deluge-web >> /dev/null 2>&1
    echo -e "${cyan}${bold}Deluge "${wenzi1}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "11" ]]; then

    echo; echo
    systemctl stop deluged >> /dev/null 2>&1
    systemctl stop deluge-web >> /dev/null 2>&1
    echo -e "${cyan}${bold}Deluge "${wenzi2}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "12" ]]; then

    echo; echo
    systemctl restart deluge >> /dev/null 2>&1
    systemctl restart deluge-web >> /dev/null 2>&1
    echo -e "${cyan}${bold}Deluge "${wenzi3}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "13" ]]; then

    echo; echo
    systemctl start rtorrent@${ANUSER} >> /dev/null 2>&1
    echo -e "${cyan}${bold}rTorrent "${wenzi1}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "14" ]]; then

    echo; echo
	systemctl stop rtorrent@${ANUSER} >> /dev/null 2>&1
    echo -e "${cyan}${bold}rTorrent "${wenzi2}"${normal}"; echo
    _xunwen1
    _client_menu_response

elif [[ "${client_action}" == "15" ]]; then

    echo; echo
    systemctl restart rtorrent@${ANUSER} >> /dev/null 2>&1
    echo -e "${cyan}${bold}rTorrent "${wenzi3}"${normal}"; echo
    _xunwen1
    _client_menu_response ;echo

elif [[ "${client_action}" == "16" ]]; then

    echo; echo
    stty -echo
    echo -ne "${bold}${cyan}你确定要重启盒子？${normal} [${cyan}Y${white}/n]:${normal} "; read is_reboot
    case $is_reboot in
        [yY] | [yY][Ee][Ss] | "" ) is_reboot=Yes ;;
        [nN] | [nN][Oo]) is_reboot=No ;;
        *) is_reboot=Yes ;;
    esac

    if [[ ${is_reboot} == "Yes" ]]; then
        echo
        echo -e "${bold}正在重启 ...${normal}"
        reboot
    else
        echo; echo
        echo -e "${bold}已取消重启 ...${normal}"
        echo
        _xunwen1
        _client_menu_response ;echo
    fi

elif [[ "${client_action}" == "17" ]]; then
    echo; echo
    _main_menu
elif [[ "${client_action}" == "18" ]]; then
    exit 0
fi
}


# 06-4. 检查开关脚本是否存在
function _systemd_check() {

if [[ ! -f "/etc/systemd/system/qbittorrent.service" ]]; then
    echo -e "${red}${bold}未检测到  qBittorent  的 systemd ，本菜单中  qBittorent  的相关操作无法使用${normal}"
fi

if [[ ! -f "/etc/systemd/system/transmission.service" ]]; then
    echo -e "${red}${bold}未检测到 Transmission 的 systemd ，本菜单中 Transmission 的相关操作无法使用${normal}"
fi

if [[ ! -f "/etc/systemd/system/flexget.service" ]]; then
    echo -e "${red}${bold}未检测到   Flexget    的 systemd ，本菜单中    Flexget   的相关操作无法使用${normal}"
fi

if [[ ! -f "/etc/systemd/system/deluged.service" ]] || [[ ! -f "/etc/systemd/system/deluge-web.service" ]]; then
    echo -e "${red}${bold}未检测到    Deluge    的 systemd ，本菜单中    Deluge    的相关操作无法使用${normal}"
fi

if [[ ! -f "/etc/systemd/system/rtorrent@.service" ]]; then
    echo -e "${red}${bold}未检测到   rTorrent   的 systemd ，本菜单中   rTorrent   的相关操作无法使用${normal}"
fi

#if [[ ! -f "/etc/systemd/system/irssi@.service" ]]; then
#    echo -e "${red}${bold}未检测到     irssi    的 systemd ，本菜单中     irssi    的相关操作无法使用${normal}"
#fi

if [[ ! -f "/etc/systemd/system/qbittorrent.service" ]] || [[ ! -f "/etc/systemd/system/deluged.service" ]] || [[ ! -f "/etc/systemd/system/transmission.service" ]] || [[ ! -f "/etc/systemd/system/flexget.service" ]] || [[ ! -f "/etc/systemd/system/rtorrent@.service" ]] || [[ ! -f "/etc/systemd/system/deluge-web.service" ]]; then
    echo -e "${red}${bold}虽然某些功能无法使用，但是选项还在，你仍可以输入相关选项"
    echo -e "输入后本脚本会告诉你客户端已经关了或者开起来了，而实际上什么也没有发生 ←_←${normal}"
    echo
fi

}





# 07-1. 脚本菜单，未完待续
function _show_scripts_menu() {

mkdir -p /tmp/mingling
clear;echo

  echo -e " ${black}${on_white}${bold}                                       07. 运行其他一键脚本                                         ${normal} "
  echo -e "${bold}"
  stty -echo
  echo -e ""
  echo -e "${green}(01) ${white}安装 inexistence"
  echo -e "${green}(02) ${white}安装 BBR"
  echo -e "${green}(03) ${white}安装 锐速"
  echo -e "${green}(04) ${white}安装 ShadowSocks"
  echo -e "${green}(05) ${white}重装 系统 "
  echo -e "${green}(06) ${white}运行 Bench.sh"
  echo -e "${green}(07) ${white}运行 UnixBench"
  echo -e "${green}(08) ${white}配置 ipv6"
  echo -e "${green}(09) ${white}广告位招租"
  echo -e "${green}(10) ${white}返回 main menu"
  echo -e "${normal}"
  echo -ne "${bold}${yellow}你想做什么？(默认返回主菜单) ${normal}"

stty echo

rm -rf /tmp/mingling/*

}


# 07-2. 脚本菜单回应
function _scripts_menu_response() {
read response
case $response in
    01 | 1) scripts_action=01 ;;
    02 | 2) scripts_action=02 ;;
    03 | 3) scripts_action=03 ;;
    04 | 4) scripts_action=04 ;;
    05 | 5) scripts_action=05 ;;
    06 | 6) scripts_action=06 ;;
    07 | 7) scripts_action=07 ;;
    08 | 8) scripts_action=08 ;;
    09 | 9) scripts_action=09 ;;
    10 | "") scripts_action=10 ;;
    *) scripts_action=10 ;;
esac
_scripts_action
}


# 07-3. 脚本操作执行
function _scripts_action() {
if [[ "${scripts_action}" == "01" ]]; then

    echo; echo -e "准备开始安装辣鸡脚本 ..."
    wget --no-check-certificate -qO /tmp/mingling/inexistence.sh https://raw.githubusercontent.com/Aniverse/inexistence/master/inexistence.sh
	bash /tmp/mingling/inexistence.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "02" ]]; then

#    echo; echo -e "准备开始安装BBR ..."
    echo "本功能还在施工中 ... 目前无法使用"
#    wget --no-check-certificate -qO /tmp/mingling/bbrinstall.sh https://raw.githubusercontent.com/Aniverse/inexistence/master/还没写好呢
#    bash /tmp/mingling/bbrinstall.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "03" ]]; then

#    echo; echo -e "准备开始安装锐速 ..."
    echo "本功能还在施工中 ... 目前无法使用"
#    wget --no-check-certificate -qO /tmp/mingling/ruisuinstall.sh https://raw.githubusercontent.com/Aniverse/inexistence/master/还没写好呢
#    bash /tmp/mingling/ruisuinstall.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "04" ]]; then

    echo; echo -e "准备开始安装 ShadowSocksR ..."
    wget --no-check-certificate -qO /tmp/mingling/shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
	bash /tmp/mingling/shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "05" ]]; then

#    echo; echo -e "重装系统准备ing ..."
    echo "本功能还在施工中 ... 目前无法使用"
#    wget --no-check-certificate -qO /tmp/mingling/systemreinsatll.sh https://raw.githubusercontent.com/Aniverse/inexistence/master/还没写好呢
#    bash /tmp/mingling/systemreinsatll.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "06" ]]; then

    echo; echo -e "准备开始运行一键测试脚本 ..."
    wget -qO- bench.sh | bash
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "07" ]]; then

    echo; echo -e "准备开始运行 Linux 性能测试脚本 ..."
    wget --no-check-certificate -qO /tmp/mingling/unixbench.sh wget --no-check-certificate https://github.com/teddysun/across/raw/master/unixbench.sh
	bash /tmp/mingling/unixbench.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "08" ]]; then

    echo; echo -e "准备开始配置 IPV6 ..."
    wget --no-check-certificate -qO /tmp/mingling/ipv6.sh https://raw.githubusercontent.com/Aniverse/inexistence/master/00.Installation/script/dalao/ipv6.sh
	bash /tmp/mingling/ipv6.sh
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "09" ]]; then

    echo; echo -e "我还没想好加什么功能 ..."; echo
    _xunwen1; _scripts_menu_response

elif [[ "${scripts_action}" == "10" ]]; then

    echo; echo
    _main_menu

fi

}






# 08. 说明文档
function _doc() {

  clear;echo
  echo -e " ${black}${on_white}${bold}                                       08. 某辣鸡的脚本说明                                         ${normal} "
  echo -e "${bold}"
  echo -e " ${red}注意${white} 作者水平菜鸡，不保证本脚本的所有功能都能正常使用，不保证检测的信息一定正确                               "
  echo -e " 很多代码是各处抄来的，具体抄了哪些此处就不写上了。感谢那些写脚本的大佬                "

  echo -e " 如果你的 SSH 窗口宽度值较小，可能排版会比较糟糕，建议拉大一点看看                                             "
  echo -e " "
  echo -e " 如果客户端操作菜单中，提示你未检测到 systemd 但你已经安装了对应的客户端，你可以选择手动配置 systemd           "
  echo -e " 如果你发现客户端在运行但你就是打不开 WebUI，重启了也没用———别问我，我也不知道 ......                          "
  echo -e "${normal}"
}





# 顺序

_logo
_main_menu
