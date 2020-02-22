#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
script_update=2020.02.20
script_version=r23430
################################################################################################

usage_guide() {
s=/usr/local/bin/ipv66;rm -f $s;nano $s;chmod 755 $s
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ol2 -6 XXX -d XXX -s 56 ; }

################################################################################################ Get options

reboot=no

OPTS=$(getopt -o m:d:s:6:rhtc --long "mode:,ipv6:,duid:,subnet:,help,reboot,test,clean" -- "$@")
[ ! $? = 0 ] && { echo -e "Invalid option" ; exit 1 ; }
eval set -- "$OPTS"

while true; do
  case "$1" in
    -m | --mode   ) mode="$2"   ; shift 2 ;;
    -6 | --ipv6   ) IPv6="$2"   ; shift 2 ;;
    -d | --duid   ) DUID="$2"   ; shift 2 ;;
    -s | --subnet ) subnet="$2" ; shift 2 ;;
    -r | --reboot ) reboot=yes  ; shift   ;;
    -h | --help   ) mode=h      ; shift   ;;
    -t | --test   ) mode=t      ; shift   ;;
    -c | --clean  ) mode=c      ; shift   ;;
     * ) break ;;
  esac
done

[[ -z $mode ]] && mode=m

################################################################################################ Colors

black=$(tput setaf 0)   ; red=$(tput setaf 1)          ; green=$(tput setaf 2)   ; yellow=$(tput setaf 3);  bold=$(tput bold)
blue=$(tput setaf 4)    ; magenta=$(tput setaf 5)      ; cyan=$(tput setaf 6)    ; white=$(tput setaf 7) ;  normal=$(tput sgr0)
on_black=$(tput setab 0); on_red=$(tput setab 1)       ; on_green=$(tput setab 2); on_yellow=$(tput setab 3)
on_blue=$(tput setab 4) ; on_magenta=$(tput setab 5)   ; on_cyan=$(tput setab 6) ; on_white=$(tput setab 7)
shanshuo=$(tput blink)  ; wuguangbiao=$(tput civis)    ; guangbiao=$(tput cnorm) ; jiacu=${normal}${bold}
underline=$(tput smul)  ; reset_underline=$(tput rmul) ; dim=$(tput dim)
standout=$(tput smso)   ; reset_standout=$(tput rmso)  ; title=${standout}
baihuangse=${white}${on_yellow}; bailanse=${white}${on_blue} ; bailvse=${white}${on_green}
baiqingse=${white}${on_cyan}   ; baihongse=${white}${on_red} ; baizise=${white}${on_magenta}
heibaise=${black}${on_white}   ; heihuangse=${on_yellow}${black}
CW="${bold}${baihongse} ERROR ${jiacu}";ZY="${baihongse}${bold} ATTENTION ${jiacu}";JG="${baihongse}${bold} WARNING ${jiacu}"

################################################################################################

SysSupport="可能不支持"
DISTRO=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
CODENAME=$(cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}')
[[ $DISTRO == Ubuntu ]] && osversion=$(grep Ubuntu /etc/issue | head -1 | grep -oE  "[0-9.]+")
[[ $DISTRO == Debian ]] && osversion=$(cat /etc/debian_version)
[[ $CODENAME =~ (xenial|bionic|jessie|stretch|) ]] && SysSupport="支持"
#[[ $SysSupport == 0 ]] && echo -e "${red}Your system is not supported!${normal}" && exit 1
type=ifdown
[[ -f /etc/netplan/01-netcfg.yaml ]] && [[ $CODENAME == bionic ]] && type=netplan
[[ $type == ifdown ]] && [[ -z $(which ifdown) ]] && { echo -e "${green}Installing ifdown ...${normal}" ; apt-get install ifupdown -y ; }

[[ -z $(which ifconfig) ]] && { echo -e "${green}Installing ifconfig ...${normal}" ; apt-get install net-tools -y  ; }
[[ -z $(which ifconfig) ]] && { echo -e "${red}Error: No ifconfig!${normal}"  ; exit 1 ; }

################################################################################################ 检测 IP 地址

function isValidIpAddress() { echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$' ; }
function isInternalIpAddress() { echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))' ; }
serveripv4=$( ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p' )

function _ip() {
    echo -e "${bold}正在检查服务器的 IPv4 信息 ...${normal}"

    isInternalIpAddress "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
    isValidIpAddress    "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
    isValidIpAddress    "$serveripv4" || serveripv4=$( wget --no-check-certificate -t1 -T7 -qO- ipecho.net/plain )
    isValidIpAddress    "$serveripv4" || { echo "${red}${shanshuo}WARNING ${jiacu}${underline}Failed to detect your public IPv4 address, use internal address instead${jiacu}" ; serveripv4=$( ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p' ) ; }

    echo -e "${bold}正在检查服务器的 IPv6 信息 ...${normal}"
    serveripv6=$( wget -t1 -T5 -qO- v6.ipv6-test.com/api/myip.php | grep -Eo "[0-9a-z:]+" | head -1 )

    if [[ -n $serveripv6 ]];then
        serveripv6_show=$serveripv6
    else
        serveripv6_show="未检测到公网 IPv6 地址"
    fi
    serveripv4_show=$serveripv4
}

################################################################################################## 判断网卡

# 锐速脚本的写法，我稍微改了下。这个不依赖 ip 和 ifconfig，依赖要求最低，但是有的时候可能出错
[ -n "$(grep 'eth0:' /proc/net/dev)" ] && wangka1=eth0 || wangka1=`cat /proc/net/dev |awk -F: 'function trim(str){sub(/^[ \t]*/,"",str); sub(/[ \t]*$/,"",str); return str } NR>2 {print trim($1)}'  |grep -Ev '^lo|^sit|^stf|^gif|^dummy|^vmnet|^vir|^gre|^ipip|^ppp|^bond|^tun|^tap|^ip6gre|^ip6tnl|^teql|^venet|^he-ipv6|^docker' |awk 'NR==1 {print $0}'`
# swizzin 脚本的写法
wangka2=$(ip link show | grep -i broadcast | grep -m1 UP  | cut -d: -f 2 | cut -d@ -f 1 | sed 's/ //g')
# 忘了哪里看来的了
#wangka3=$(ip route get 8.8.8.8 | awk '{print $5}')
# 不配佬写的，稍微改了下
#wangka4=$(ifconfig | grep 'e.*UP' | awk 'NR==1{print$1}' | sed 's|:||')

# 对比 wangka1 和 wangka2，看看是否一致
if [[ -n $wangka2 ]]; then
    if [[ $wangka1 == $wangka2 ]];then
        interface=$wangka1
    else
        interface=$wangka2
        # 我感觉还是第二种方法准一些
    fi
else
    interface=$wangka1
fi

sysctl -w net.ipv6.conf.$interface.autoconf=0 > /dev/null
ik_ipv6="2a00:c70:1:${serveripv4//./:}:1"
ik_way6="${ik_ipv6/${serveripv4##*.}::1}"
AAA=$( echo $serveripv4 | awk -F '.' '{print $1}' )
BBB=$( echo $serveripv4 | awk -F '.' '{print $2}' )
CCC=$( echo $serveripv4 | awk -F '.' '{print $3}' )
DDD=$( echo $serveripv4 | awk -F '.' '{print $4}' )
    
function _ipip() {
    echo -e "${bold}正在检查服务器的其他 IP 信息 ... (比较慢)${normal}"
    ipip_result=/tmp/ipip_result
    [[ ! -f $ipip_result ]] && wget --no-check-certificate -qO- https://www.ipip.net/ip.html > $ipip_result 2>&1

      ipip_IP=$( cat $ipip_result | grep -A3 IP     | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | head -1 )
     ipip_ASN=$( cat $ipip_result | grep -C7 ASN    | grep -oE "AS[0-9]+" | head -1 )
    ipip_CIDR=$( cat $ipip_result | grep -C7 ASN    | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" | head -1 )
    ipip_AS=$( cat $ipip_result | grep -A1 $ipip_CIDR | grep -v $ipip_CIDR | grep -o "$ipip_ASN.*</a" | cut -d '>' -f2 | cut -d '<' -f1 )
    ipip_rDNS=$( cat $ipip_result | grep -oE "rDNS: [a-zA-Z0-9.-]+" | sed "s/rDNS: //" )
     ipip_Loc=$( cat $ipip_result | grep -A10 "https://tools.ipip.net/traceroute.php?ip=" | grep 720px | grep -oE ">.*<" | sed "s/>//" | sed "s/<//" )
     ipip_ISP=$( cat $ipip_result | grep "display: inline-block;text-align: center;width: 720px;float: left;line-height: 46px" | sed -n '2p' | grep -oE ">.*<" | sed "s/>//" | sed "s/<//" )

 #  rm -f $ipip_result
    ASN=$(echo $ipip_ASN | grep -oE "AS[0-9]+")

    if [[ $ASN == AS24940 ]];then
        server=Hetzner
        script_support="不需要支持"
        script_support_add="，因为 Hz 装完自带 IPv6"
    elif [[ $ASN == AS16276 ]];then
        server=OVH
        script_support="不需要支持"
        script_support_add="，因为 OVH 装完自带 IPv6"
    elif [[ $ASN == AS12876 ]];then
        server=Online
        script_support="支持"
        script_support_add="，请填写相关参数"
    elif [[ $ASN == AS21409 ]];then
        server=Ikoula
        script_support="支持"
        script_support_add=""
    else
        server=Unknown
        script_support="不支持"
        script_support_add=""
    fi
}



################################################################################################ 运行相关的 function



function check_var() {
    [[ -z $IPv6 ]] && echo "${red}No IPv6${normal}" && exit 1
    [[ -z $DUID ]] && echo "${red}No DUID${normal}" && exit 1
    [[ -z $subnet ]] && echo "${red}No subnet${normal}" && exit 1
}

# Ikoula 独服（/etc/network/interfaces）
# 这个是只添加
function ikoula_interfaces() {
    if [[ ! $(grep -q "iface $interface inet6 static" /etc/network/interfaces) ]] || [[ $force == 1 ]] ; then
        file_backup
        [[ $force == 1 ]] && interfaces_file_clean
        cat << EOF >> /etc/network/interfaces
### Added by IPv6_Script ###
iface $interface inet6 static
address 2a00:c70:1:$AAA:$BBB:$CCC:$DDD:1
netmask 96
gateway 2a00:c70:1:$AAA:$BBB:$CCC::1
### IPv6_Script END ###
EOF
        systemctl_restart
    fi
}

# 这个是覆盖重写
function ikoula_interfaces2() {
    file_backup
    cat << EOF > /etc/network/interfaces
# Network configuration file
# Auto generated by Ikoula

iface lo inet loopback
auto lo

auto $interface
	iface eth0 inet static
	address $AAA.$BBB.$CCC.$DDD
	netmask 255.255.255.00
	broadcast $AAA.$BBB.$CCC.255
	network $AAA.$BBB.$CCC.0
	gateway $AAA.$BBB.$CCC.1
	dns-nameservers 213.246.36.14 213.246.33.144 80.93.83.11

	### Added by IPv6_Script ###
	iface $interface inet6 static
	address 2a00:c70:1:$AAA:$BBB:$CCC:$DDD:1
	netmask 96
	gateway 2a00:c70:1:$AAA:$BBB:$CCC::1
	### IPv6_Script END ###
EOF
    systemctl_restart
}




# Ikoula 独服，Ubuntu 18.04 系统（netplan）
function ikoula_netplan() {
    file_backup
    cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: no
      dhcp6: no
      accept-ra: no
      addresses: [$AAA.$BBB.$CCC.$DDD/24, '2400:c70:1:$AAA:$BBB:$CCC:$DDD:1/96']
      gateway4: $AAA.$BBB.$CCC.1
      gateway6: 2a00:c70:1:$AAA:$BBB:$CCC::1
      nameservers:
        addresses: [213.246.36.14,213.246.33.144,80.93.83.11]
EOF
    netplan apply
}


################################################################################################


function write_dhclient6_conf() {
    cat << EOF > /etc/dhcp/dhclient6.conf
interface \"$interface\" {
send dhcp6.client-id $DUID;
request;
}
EOF
}


function write_dhclient6_systemd() {
    cat << EOF > /etc/systemd/system/dhclient.service
[Unit]
Description=dhclient for sending DUID IPv6
Wants=network.target
Before=network.target
[Service]
Type=forking
ExecStart=$(which dhclient) -cf /etc/dhcp/dhclient6.conf -6 -P -v $interface
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable dhclient.service
}


function write_dhclient_netplan_systemd() {
    cat << EOF > /etc/systemd/system/dhclient-netplan.service
[Unit]
Description=redo netplan apply after dhclient
Wants=dhclient.service
After=dhclient.service
Before=network.target
[Service]
Type=oneshot
ExecStart=/usr/sbin/netplan apply
[Install]
WantedBy=dhclient.service
EOF
    systemctl daemon-reload
    systemctl enable dhclient-netplan.service
}



function online_interfaces_file_mod() {
    cat << EOF >> /etc/network/interfaces
### Added by IPv6_Script ###
iface $interface inet6 static
address $IPv6
netmask $subnet
#accept_ra 1
#pre-up modprobe ipv6
#pre-up dhclient -cf /etc/dhcp/dhclient6.conf -pf /run/dhclient6.$interface.pid -6 -P $interface
#pre-down dhclient -x -pf /run/dhclient6.$interface.pid
### IPv6_Script END ###
EOF
}



# Online／OneProvider Paris 独服，Ubuntu 16.04，Debian 8/9/10
function online_interfaces() {
    check_var
    file_backup
    if [[ ! $(grep -q "iface $interface inet6 static" /etc/network/interfaces) ]]; then
        interfaces_file_clean
        online_interfaces_file_mod
    fi
    write_dhclient6_conf
    write_dhclient6_systemd
    systemctl start dhclient.service
    systemctl_restart
}


# Online／OneProvider Paris 独服，Ubuntu 18.04 系统（netplan）
function online_netplan() {
    check_var
    file_backup

    write_dhclient6_conf
    write_dhclient6_systemd
    write_dhclient_netplan_systemd
    netplan_netcfg_file_clean
    cat << EOF >> /etc/netplan/01-netcfg.yaml
### Added by IPv6_Script ###
      dhcp6: no
      accept-ra: yes
      addresses:
      - $IPv6/$subnet
### IPv6_Script END ###
EOF
    systemctl start dhclient.service
    systemctl start dhclient-netplan.service
}


########################################################################### dibbler


function dibbler_install() {
    dpkg-query -W -f='${Status}' build-essential 2>/dev/null | grep -q "ok installed" || apt-get install -y build-essential
    wget https://netix.dl.sourceforge.net/project/dibbler/dibbler/1.0.1/dibbler-1.0.1.tar.gz
    tar zxvf dibbler-1.0.1.tar.gz
    cd dibbler-1.0.1
    ./configure
    make -j$(nproc)
    make install
    cd ..
    rm -rf dibble*
    [[ ! -f /usr/local/sbin/dibbler-client ]] && echo -e "\nError: No dibbler-client found!\n" && exit 1
}


function online_dibbler_action() {
    mkdir -p       /var/lib/dibbler    /etc/dibbler/
    echo "$DUID" > /var/lib/dibbler/client-duid
    cat << EOF > /etc/dibbler/client.conf
log-level 7
duid-type duid-ll
inactive-mode

iface $interface {
pd
}
EOF
    file_backup
    interfaces_file_clean
    online_interfaces_file_mod
    cat << EOF > /etc/systemd/system/dibbler-client.service
[Unit]
Description=Dibbler Client
After=networking.service

[Service]
Type=simple
ExecStart=/usr/local/sbin/dibbler-client start

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable dibbler-client.service
}


function online_dibbler() {
    check_var
    dibbler_install
    online_dibbler_action
}




########################################################################### odhcp6c




function odhcp6c_install() {
    for app in cmake git build-essential ; do
        dpkg-query -W -f='${Status}' $app 2>/dev/null | grep -q "ok installed" || apt-get install -y $app
    done

    git clone --depth=1 https://github.com/openwrt/odhcp6c
    cd odhcp6c
    cmake .
    make
    make install
    cd ..
    rm -rf odhcp6c
}


function write_odhcp6c_systemd() {
    cat << EOF > /etc/systemd/system/odhcp6c.service
[Unit]
Description=odhcp6c
Wants=network.target
Before=network.target
[Service]
Type=forking
ExecStart=$(which odhcp6c) -c $DUID -P $subnet -d $interface
ExecStartPost=$(which ip) -6 a a $IPv6/$subnet dev $interface
ExecStartPost=$(which ip) -6 r a $IPv6/$subnet dev $interface
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable odhcp6c.service
}


function online_odhcp6c() {
    check_var
    odhcp6c_install
    write_odhcp6c_systemd
    systemctl start odhcp6c
}


###########################################################################



function file_backup() {
    mkdir -p /log/script
    if [[ $type == netplan ]]; then
        cp -f   /etc/netplan/01-netcfg.yaml  /log/script/netcfg.yaml.$(date "+%Y.%m.%d.%H.%M.%S").bak
    elif [[ $type == ifdown ]]; then
        cp -f   /etc/network/interfaces      /log/script/interfaces.$(date "+%Y.%m.%d.%H.%M.%S").bak
    fi
}

function interfaces_file_clean() {
    while grep -q "IPv6_Script" /etc/network/interfaces ; do
        sed -i '$d' /etc/network/interfaces
    done
}

function netplan_netcfg_file_clean() {
    while grep -q "IPv6_Script" /etc/netplan/01-netcfg.yaml ; do
        sed -i '$d' /etc/netplan/01-netcfg.yaml
    done
}

function systemctl_restart() {
  # systemctl restart networking.service || echo -e "\n${red}systemctl restart networking.service FAILED${normal}"
    sleep 0
}

function ipv6_test() {
    echo -ne "\n${bold}Testing IPv6 connectivity ... ${normal}"
    IPv6_test=$(ping6 -c 5 ipv6.google.com | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
    if [[ $IPv6_test > 0 ]]; then
        echo "${bold}${yellow}Success!${normal}"
        exit 0
    else
        echo "${bold}${red}Failed${normal}"
        exit 1
    fi
}

function sysctl_enable_ipv6() {
    sysctl -w net.ipv6.conf.$interface.autoconf=0 > /dev/null
    sed -i '/^net.ipv6.conf.*/'d /etc/sysctl.conf
    echo "net.ipv6.conf.$interface.autoconf=0" >> /etc/sysctl.conf
}

function ask_reboot() {
    if [[ $reboot == no ]]; then
        echo -e "${bold}Press ${on_red}Ctrl+C${normal} ${bold}to exit${jiacu}, or press ${bailvse}ENTER${normal} ${bold}to reboot${normal} "
        read input
    fi
  # echo -e "\n${bold}Rebooting ... ${normal}"
    reboot -f
    init 6
}

function cleanup() {
    echo -n "Cleanup ... "
    if [[ $type == ifdown ]]; then
        interfaces_file_clean
    else
        netplan_netcfg_file_clean
    fi
    systemctl stop    dhclient-netplan.service  2>/dev/null
    systemctl stop    dhclient.service          2>/dev/null
    systemctl stop    dibbler-client.service    2>/dev/null
    systemctl disable dhclient-netplan.service  2>/dev/null
    systemctl disable dhclient.service          2>/dev/null
    systemctl disable dibbler-client.service    2>/dev/null
    systemctl daemon-reload
    rm -f /etc/systemd/system/dhclient.service
    rm -f /etc/systemd/system/dhclient-netplan.service
    rm -f /etc/systemd/system/dibbler-client.service
    rm -f /etc/dhcp/dhclient6.conf    /etc/dibbler/client.conf   /var/lib/dibbler/client-duid
    echo "DONE"
}

function info() {
    echo -e "
script_update=$script_update
script_version=$script_version

DISTRO=$DISTRO
CODENAME=$CODENAME
IPv4=$serveripv4
interface=$interface
mode=$mode   type=$type
reboot=$reboot

IPv6=$IPv6
DUID=$DUID
subnet=$subnet
"
    echo -e "${yellow}cat /etc/network/interfaces${normal}\n"
    cat /etc/network/interfaces     2>/dev/null
    echo -e "\n${yellow}cat /etc/netplan/01-netcfg.yaml${normal}\n"
    cat /etc/netplan/01-netcfg.yaml 2>/dev/null
    echo -e "
cd /log/script && ls
netplan apply
systemctl restart networking.service
ping6 -c 5 ipv6.google.com"
}

function ask_pause() {
    read -p "${bold}敲回车开始配置${normal} " pause
}

function show_help() {
    echo -e "
${bold}${baiqingse}IPv6 Script $script_version${normal}

${bold}${green}Usage: ${normal}
-m     Specify IPv6 configuring mode, can be specified ask_reboot
       ik    Ikoula interfaces, only for Ikoula servers ifdown
             Typically, This is for Ubuntu 14.04/16.04, Debian 7/8/9/10
       ik2   Ikoula netplan, only for Ikoula servers using netplan
             Typically, This is ONLY for Ubuntu 18.04
       ol    Online interfaces, only for Online/OneProvider servers using ifdown
             Typically, This is for Ubuntu 16.04, Debian 8/9/10
       ol2   Online netplan, only for Online/OneProvider servers using netplan
             Typically, This is ONLY for Ubuntu 18.04
       ol3   Online dibbler, only for Online/OneProvider servers
             Typically, This is for Ubuntu 16.04/18.04, Debian 8/9/10
       ol4   Online odhcp6c, only for Online/OneProvider servers
             Still in development
-6     Inupt IPv6
-d     Input DUID
-s     Input subnet
-r     Do a reboot without confirmation after executing script
-h     Show this info
-t     Test IPv6 connectivity

${bold}${green}Examples: ${normal}

Ikoula Dedicated Server using Ubuntu 16.04
${underline}ipv6 -m ik${reset_underline}

Ikoula Dedicated Server using Ubuntu 18.04
${underline}ipv6 -m ik2${reset_underline}

OneProvider Dedicated Server using Debian 9
${underline}ipv6 -m ol    -6 2001:3bc8:2490::    -d 00:03:00:02:19:c4:c9:e3:75:26  -s 56${reset_underline}

Online Dedicated Server using Ubuntu 18.04
${underline}ipv6 -m ol3   -6 2001:cb6:2521:240:: -d 00:03:00:01:d3:3a:15:b4:43:ad  -s 56${reset_underline}
"
}


function ipv6_menu() {

    _ip
    _ipip
    #if [[ ! -f /tmp/ip_check.lock ]]; then
    #    _ip
    #    _ipip
    #    touch /tmp/ip_check.lock
    #fi

    echo -e "
${bold}${on_magenta}             IPv6 配置脚本             ${jiacu}

  IPv4 地址             ${cyan}$serveripv4_show${jiacu}
  IPv6 地址             ${cyan}$serveripv6_show${jiacu}
  反向域名              ${cyan}$ipip_rDNS${jiacu}
  运营商                ${cyan}$ipip_ISP${jiacu}
  AS  信息              ${cyan}$ipip_ASN, $ipip_AS${jiacu}
  地理位置              ${cyan}$ipip_Loc${jiacu}

  操作系统              ${cyan}$DISTRO $osversion $CODENAME${jiacu}
  系统支持性            ${cyan}$SysSupport${jiacu}
  脚本可用性            ${cyan}${script_support}${script_support_add}${jiacu}

${on_blue}-------------------- 下列为可修改的参数 --------------------${jiacu}

${green}<1>${cyan} 待配置的 IPv6 地址        ${blue}$IPv6${jiacu}
${green}<2>${cyan} 待配置的 DUID             ${blue}$DUID${jiacu}
${green}<3>${cyan} 待配置的 subnet           ${blue}$subnet${jiacu}

这些参数就 Online 的独服必须设置，Ikoula 不用设置

${on_blue}------------------- 下列为可用的配置模式 -------------------${jiacu}

${green}<11>${cyan} Online interfaces （Debian 8/9/10，Ubuntu 16.04）
${green}<12>${cyan} Online netplan    （Ubuntu 18.04）
${green}<13>${cyan} Online dibbler    （Debian 8/9/10，Ubuntu 16.04/18.04）
${green}<14>${cyan} Online odhcp6c    （Debian 8/9/10，Ubuntu 16.04/18.04）
${green}<21>${cyan} Ikoula interfaces （Debian 8/9/10，Ubuntu 16.04）
${green}<22>${cyan} Ikoula netplan    （Ubuntu 18.04）

${red}<98>${jiacu} 测试 IPv6 连接性
${red}<99>${jiacu} 退出脚本
"
    read -ep "${bold}${yellow}输入对应的数值进行修改${blue}  " response ; echo "${normal}"
    case $response in
         1) read -ep "${bold}输入待配置的 IPv6 地址：${blue}" IPv6   ; echo -n "${normal}" ; ipv6_menu ;;
         2) read -ep "${bold}输入待配置的 DUID：${blue}"      DUID   ; echo -n "${normal}" ; ipv6_menu ;;
         3) read -ep "${bold}输入待配置的 subnet：${blue}"    subnet ; echo -n "${normal}" ; ipv6_menu ;;
        11) mode=ol  ; ask_pause ; mode_action ;;
        12) mode=ol2 ; ask_pause ; mode_action ;;
        13) mode=ol3 ; ask_pause ; mode_action ;;
        14) mode=ol4 ; ask_pause ; mode_action ;;
        21) mode=ik  ; ask_pause ; mode_action ;;
        22) mode=ik2 ; ask_pause ; mode_action ;;
        98) ipv6_test; ipv6_menu ;;
        99) exit ;;
         *) exit ;;
    esac
}


###########################################################################

function mode_action() {
case $mode in
    ik  ) ikoula_interfaces   ; ask_reboot ;;
    ik2 ) ikoula_netplan      ; ipv6_test  ;;
    ol  ) online_interfaces   ; ipv6_test   ; ask_reboot ;;
    ol2 ) online_netplan      ; ipv6_test  ;;
    ol3 ) online_dibbler      ; ask_reboot ;;
    ol4 ) online_odhcp6c      ; ipv6_test  ;;
    t   ) info ; ipv6_test    ;;
    h   ) show_help           ;;
    c   ) cleanup             ;;
    m   ) ipv6_menu           ;;
esac
}

mode_action

###########################################################################



function references() {
其实有些我也没参考，先留着当个备份，或许以后有用呢
# https://npchk.info/online-net-dedibox-dibbler-ipv6/
# https://blog.gloriousdays.pw/2019/03/14/configure-online-net-ipv6-on-ubuntu-18-04/
# https://blog.gloriousdays.pw/2019/08/27/configure-ikoula-ipv6-under-netplan-io/
# https://blog.gloriousdays.pw/2018/11/24/something-about-ikoula-seedbox/
# https://blog.gloriousdays.pw/2017/10/11/online-dedibox-ipv6-configuration/
# https://ymgblog.com/2018/03/14/383/
# https://ymgblog.com/2018/03/12/345/
# https://documentation.online.net/en/dedicated-server/network/ipv6/prefix
sleep 0
}
