#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
script_update=2019.05.24
script_version=r20003
################################################################################################

usage_guide() {

bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6) -m deb2 ; }

################################################################################################ Get options

OPTS=$(getopt -n "$0" -o  --long "" -- "$@")

eval set -- "$OPTS"

while true; do
  case "$1" in
    -m | --install-mode ) mode="$2"     ; shift ; shift ;;
    -v | --version      ) version="$2"  ; shift ; shift ;;
    -b | --branch       ) branch="$2"   ; shift ; shift ;;
         --debug        ) debug=1       ; shift ;;
         --logbase      ) LogTimes="$2" ; shift ;;
     * ) break ;;
  esac
done

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

SysSupport=0
Mode=ifdown
DISTRO=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
CODENAME=$(cat /etc/os-release | grep VERSION= | tr '[A-Z]' '[a-z]' | sed 's/\"\|(\|)\|[0-9.,]\|version\|lts//g' | awk '{print $2}')
[[ $DDDISTRO == Ubuntu ]] && osversion=`  grep Ubuntu /etc/issue | head -1 | grep -oE  "[0-9.]+"  `
[[ $DDDISTRO == Debian ]] && osversion=`  cat /etc/debian_version  `
[[ $CCCODENAME =~ (xenial|bionic|jessie|stretch) ]] && SysSupport=1
[[ $CCCODENAME == bionic ]] && Mode=netplan

################################################################################################

[[ -z $(which ifconfig) ]] && { echo -e "{green}Installing ifconfig${normal}" ; apt-get install net-tools -y  ; }
[[ -z $(which ifconfig) ]] && { echo -e "${red}Error: No ifconfig!${normal}"  ; exit 1 ; }
[[ -z $(which ifdown)   ]] && { echo -e "{green}Installing ifdown${normal}"   ; apt-get install ifdown -y    ; }

function isValidIpAddress() { echo $1 | grep -qE '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$' ; }
function isInternalIpAddress() { echo $1 | grep -qE '(192\.168\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(172\.((1[6-9])|(2\d)|(3[0-1]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))|(10\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.((\d{1,2})$|(1\d{2})$|(2[0-4]\d)$|(25[0-5])$))' ; }

#serveripv4=$( ip route get 8.8.8.8 | awk '{print $3}' )
#isInternalIpAddress "$serveripv4" && serveripv4=$( wget -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
serveripv4=$( wget -t1 -T6 -qO- v4.ipv6-test.com/api/myip.php )
isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T6 -qO- checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//' )
isValidIpAddress "$serveripv4" || serveripv4=$( wget -t1 -T7 -qO- ipecho.net/plain )
isValidIpAddress "$serveripv4" || {
unset serveripv4
echo -e "${CW} Failed to detect your public IPv4 address, please write your public IPv4 address: ${normal}"
while [[ -z $serveripv4 ]]; do
    read -e serveripv4
    isInternalIpAddress "$serveripv4" && { echo -e "${CW} This is INTERNAL IPv4 address, not PUBLIC IPv4 address, please write your public IPv4: ${normal}" ; unset serveripv4 ; }
    isValidIpAddress "$serveripv4" || { echo -e "${CW} This is not a valid public IPv4 address, please write your public IPv4: ${normal}" ; unset serveripv4 ; }
done ; }

interface=$(ip route get 8.8.8.8 | awk '{print $5}')
AAA=$( echo $serveripv4 | awk -F '.' '{print $1}' )
BBB=$( echo $serveripv4 | awk -F '.' '{print $2}' )
CCC=$( echo $serveripv4 | awk -F '.' '{print $3}' )
DDD=$( echo $serveripv4 | awk -F '.' '{print $4}' )

################################################################################################

################################################################################################



function ikoula_interfaces(){
grep -q "iface $interface inet6 static" /etc/network/interfaces || { cp -f /etc/network/interfaces /log/interfaces.$(date "+%Y.%m.%d.%H.%M.%S").bak
cat << EOF >> /etc/network/interfaces
iface $interface inet6 static
address 2a00:c70:1:$AAAAA:$BBBBB:$CCCCC:$DDDDD:1
netmask 96
gateway 2a00:c70:1:$AAAAA:$BBBBB:$CCCCC::1
EOF
}

sysctl -w net.ipv6.conf.$interface.autoconf=0
systemctl restart networking.service || echo -e "\n${red}systemctl restart networking.service FAILED{normal}"
}


function ikoula_netplan(){
cp -f /etc/netplan/01-netcgf.yaml /log/01-netcgf.yaml.$(date "+%Y.%m.%d.%H.%M.%S").bak
cat << EOF > /etc/netplan/01-netcgf.yaml
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





function online_netplan(){

cat << EOF > /etc/dhcp/dhclient6.conf
interface "$interface" {
  send dhcp6.client-id $DUID;
  request;
}
EOF

cat << EOF > /etc/systemd/system/dhclient.service
[Unit]
Description=dhclient for sending DUID IPv6
Wants=network.target
Before=network.target
[Service]
Type=forking
ExecStart=/sbin/dhclient -cf /etc/dhcp/dhclient6.conf -6 -P -v $interface
[Install]
WantedBy=multi-user.target
EOF

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

cp -f /etc/netplan/01-netcgf.yaml /log/01-netcgf.yaml.$(date "+%Y.%m.%d.%H.%M.%S").bak
cat << EOF >> /etc/netplan/01-netcfg.yaml
      dhcp6: no
      accept-ra: yes
      addresses:
      - $ipv6/$subnet
EOF

systemctl daemon-reload
systemctl start dhclient.service
systemctl start dhclient-netplan.service
systemctl enable dhclient.service
systemctl enable dhclient-netplan.service

}








