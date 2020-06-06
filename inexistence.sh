#!/bin/bash
#
# https://github.com/Aniverse/inexistence
# Author: Aniverse
#
# --------------------------------------------------------------------------------
usage() {
    bash <(wget -qO- https://git.io/abcde)
    bash <(curl -s https://raw.githubusercontent.com/Aniverse/inexistence/master/inexistence.sh)
}

# --------------------------------------------------------------------------------
script_version=1.2.5.9
script_update=2020.06.06
script_name=inexistence
script_cmd="bash <(wget -qO- git.io/abcde)"

SYSTEMCHECK=1
DeBUG=0
script_lang=eng
default_branch=master
aptsources=Yes
# --------------------------------------------------------------------------------

# 获取参数
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/options)
OPTS=$(getopt -o dsyu:p:b:h --long "help,hostname:,domain:,no-reboot,quick,branch:,yes,skip,no-system-upgrade,debug,no-source-change,swap,no-swap,bbr,no-bbr,flood,vnc,x2go,wine,mono,tools,filebrowser,no-filebrowser,flexget,no-flexget,rclone,enable-ipv6,tweaks,no-tweaks,mt-single,mt-double,mt-all,mt-half,tr-deb,eng,chs,sihuo,user:,password:,webpass:,de:,qb:,rt:,tr:,lt:,qb-static,separate" -- "$@")
[ ! $? = 0 ] && show_inex_usage
eval set -- "$OPTS"
opts_action "$@"

# [ $# -gt 0 ] && { echo "No arguments allowed $1 is not a valid argument" ; exit 1 ; }
[[ $DeBUG == 1 ]] && { iUser=aniverse ; aptsources=No ; MAXCPUS=$(nproc) ; }

[[ -z $iBranch ]] && iBranch=$default_branch
times=$(cat /log/inexistence/info/installed.user.list.txt 2>/dev/null | wc -l)
times=$(expr $times + 1)
# --------------------------------------------------------------------------------
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/check-sys)
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/function)
source <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/ask)
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$PATH

export TZ=/usr/share/zoneinfo/Asia/Shanghai
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
export local_packages=/etc/inexistence/00.Installation
export local_script=/usr/local/bin/abox

export LogBase=/log/inexistence
export LogTimes=$LogBase/$times
export SourceLocation=$LogTimes/source
export DebLocation=$LogTimes/deb
export LogLocation=$LogTimes/log
export LOCKLocation=$LogBase/.lock
export WebROOT=/var/www
set_language
MaxDisk=$(df -k | sort -rn -k4 | awk '{print $1}' | grep -v overlay | head -1)
# --------------------------------------------------------------------------------

# 用于退出脚本
export TOP_PID=$$
trap 'exit 1' TERM

# --------------------------------------------------------------------------------

### 检查系统是否被支持 ###
function _oscheck() {
    if [[ $SysSupport =~ (1|4) ]]; then
        echo -e "\n${green}${bold}Excited! Your operating system is supported by this script. Let's make some big news ... ${normal}"
    else
        echo -e "\n${bold}${red}Too young too simple! Only Debian 9/10 and Ubuntu 16.04/18.04 is supported by this script${normal}
        ${bold}If you want to run this script on unsupported distro, please use -s option\nExiting...${normal}\n"
        exit 1
    fi
}

# Ctrl+C 时恢复样式
cancel() { echo -e "${normal}" ; reset -w ; exit ; }
trap cancel SIGINT





# --------------------- 系统检查 --------------------- #
function _intro() {
    [[ $DeBUG != 1 ]] && clear
    
    # 检查是否以 root 权限运行脚本
    if [[ $DeBUG != 1 ]]; then if [[ $EUID != 0 ]]; then echo -e "\n${title}${bold}Naive! I think this young man will not be able to run this script without root privileges.${normal}\n" ; exit 1
    else echo -e "\n${green}${bold}Excited! You're running this script as root. Let's make some big news ... ${normal}" ; fi ; fi
    
    # 检查是否为 x86_64 架构
    [[ $arch != x86_64 ]] && { echo -e "${title}${bold}Too simple! Only x86_64 is supported${normal}" ; exit 1 ; }

    # 检查系统版本；不是 Ubuntu 或 Debian 的就不管了，反正不支持……
    SysSupport=0
    [[ $CODENAME =~  (bionic|buster)  ]] && SysSupport=1
    [[ $CODENAME =~  (xenial|stretch) ]] && SysSupport=4
    [[ $CODENAME ==  trusty  ]] && SysSupport=2
    [[ $CODENAME ==  wheezy  ]] && SysSupport=3
    [[ $CODENAME ==  jessie ]] && SysSupport=5
    [[ $DeBUG == 1 ]] && echo "${bold}DISTRO=$DISTRO, CODENAME=$CODENAME, osversion=$osversion, SysSupport=$SysSupport${normal}"

    # 允许跳过系统升级选项的问题
    [[ $skip_system_upgrade != 1 ]] && {
        # 如果系统是 Debian 7 或 Ubuntu 14.04，询问是否升级
        [[ $SysSupport == 2 ]] && _ask_distro_upgrade_1
        [[ $SysSupport == 3 ]] && _ask_distro_upgrade_2
        # 如果系统是 Debian 8/9 或 Ubuntu 16.04，提供升级选项
        [[ $SysSupport == 4 ]] && _ask_distro_upgrade_3
        [[ $SysSupport == 5 ]] && _ask_distro_upgrade_4
    }

    # rTorrent 是否只能安装 feature-bind branch 的 0.9.6 或者 0.9.7 及以上
    [[ $CODENAME =~ (stretch|bionic|buster) ]] && rtorrent_dev=1

    # 检查本脚本是否支持当前系统，可以关闭此功能
    [[ $SYSTEMCHECK == 1 ]] && [[ $distro_up != Yes ]] && _oscheck

    # 装 wget 以防万一（虽然脚本一般情况下就是 wget 下来的……）
    which wget | grep -q wget || { echo "${bold}Now the script is installing ${yellow}wget${jiacu} ...${normal}" ; apt-get install -y wget ; }
    which wget | grep -q wget || { echo -e "${red}${bold}Failed to install wget, please check it and rerun once it is resolved${normal}\n" && kill -s TERM $TOP_PID ; }

    ipv4_check
    ip_ipapi
    ipv6_check
    echo -e "${bold}Checking your server's specification ...${normal}"
    hardware_check_1
    echo -e "${bold}Checking bittorrent clients' version ...${normal}"
    check_install_2
    get_clients_version

    clear

    wget --no-check-certificate -t1 -T5 -qO- https://raw.githubusercontent.com/Aniverse/inexistence/files/logo/inexistence.logo.1

    echo "${bold}---------- [System Information] ----------${normal}"
    echo
    
    echo -e  "  CPU       : ${cyan}$CPUNum$cname${normal}"
    echo -e  "  Cores     : ${cyan}${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)${normal}"
    echo -e  "  Mem       : ${cyan}$tram MB ($uram MB Used)${normal}"
    echo -e  "  Disk      : ${cyan}$disk_total_size GB ($disk_used_size GB Used)${normal}"
    echo -e  "  OS        : ${cyan}$displayOS${normal}"
    echo -e  "  Kernel    : ${cyan}$running_kernel${normal}"
    echo -e  "  Script    : ${cyan}$script_version ($script_update), $iBranch branch${normal}"
    echo -e  "  Virt      : ${cyan}$virtual${normal}"
    echo
    [[ -n "$rt_domain" ]] &&
    echo -e  "  Domain    : ${cyan}$rt_domain${normal}"
    echo -ne "  IPv4      : ";[[ -n ${serveripv4} ]] && echo "${cyan}$serveripv4${normal}" || echo "${cyan}No Public IPv4 Address Found${normal}"
    echo -ne "  IPv6      : ";[[ -n ${serveripv6} ]] && echo "${cyan}$serveripv6${normal}" || echo "${cyan}No Public IPv6 Address Found${normal}"
    echo -e  "  ASN & ISP : ${cyan}$asnnnnn, $isppppp${normal}"
    echo -ne "  Location  : ${cyan}";[[ -n $cityyyy ]] && echo -ne "$cityyyy, ";[[ -n $regionn ]] && echo -ne "$regionn, ";[[ -n $country ]] && echo -ne "$country";echo -e "${normal}"

    [[ $SYSTEMCHECK != 1 ]] && echo -e "\n${bold}${red}System Checking Skipped. $lang_note_that this script may not work on unsupported system${normal}"
    [[ -n "$rt_domain" ]] && [[ $(host "$rt_domain" 2>&1 | grep -oE "[0-9.]+\.[0-9.]+") != "$serveripv4" ]] &&
    echo -e "\n${yellow}${bold}It seems your domain $rt_domain does NOT resolve to your IPv4 address $serveripv4${normal}"

    if [[ $CODENAME == jessie ]]; then
        echo -e "\n${bold}${red}警告：除非万不得已，不然不要使用 Debian 8 运行本脚本！${normal}"
    elif [[ $CODENAME == focal ]]; then
        echo -e "\n${bold}${red}警告：本脚本尚不支持 Ubuntu 20.04 LTS！${normal}"
    elif [[ $CODENAME == stretch ]]; then
        sleep 0.1 # echo -e "\n${bold}${red}建议升级到 Debian 10 再使用本脚本${normal}"
    elif [[ $CODENAME == xenial ]]; then
        sleep 0.1 # echo -e "\n${bold}${red}建议升级到 Ubuntu 18.04 再使用本脚本${normal}"
    fi

    [[ $times != 1 ]] && echo -e "\n${bold}It seems this is the $times times you run this script${normal}"
    
    [[ ${virtual} != "No Virtualization Detected" ]] && [[ ${virtual} != "KVM" ]] && echo -e "\n${bold}${red}这个脚本基本上没有在非 KVM 的 VPS 测试过，不保证 OpenVZ、HyperV、Xen、Lxc 等架构下一切正常${normal}"

    echo -e "\n${bold}For more information about this script,\nplease refer README on GitHub (Chinese only)"
    echo -e "Press ${on_red}Ctrl+C${normal} ${bold}to exit${jiacu}, or press ${bailvse}ENTER${normal} ${bold}to continue" ; [[ $ForceYes != 1 ]] && read input
}





function ask_continue() {
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
    [[ -n $lt_version ]] &&
    echo "                  ${cyan}${bold}libtorrent${normal}    ${bold}${yellow}${lt_version}${normal}"
    echo "                  ${cyan}${bold}rTorrent${normal}      ${bold}${yellow}${rt_version}${normal}"

    echo "                  ${cyan}${bold}Transmission${normal}  ${bold}${yellow}${tr_version}${normal}"
    echo "                  ${cyan}${bold}FlexGet${normal}       ${bold}${yellow}${InsFlex}${normal}"
    echo "                  ${cyan}${bold}FileBrowser${normal}   ${bold}${yellow}${InsFB}${normal}"
    echo "                  ${cyan}${bold}System Tweak${normal}  ${bold}${yellow}${UseTweaks}${normal}"
    echo "                  ${cyan}${bold}Threads${normal}       ${bold}${yellow}${MAXCPUS}${normal}"
    echo "                  ${cyan}${bold}SourceList${normal}    ${bold}${yellow}${aptsources}${normal}"

    [[ -n $InsFlood ]] &&
    echo "                  ${cyan}${bold}Flood${normal}         ${bold}${yellow}${InsFlood}${normal}"
    [[ -n $InsBBR ]] &&
    echo "                  ${cyan}${bold}BBR${normal}           ${bold}${yellow}${InsBBR}${normal}"
    [[ -n $InsVNC ]] &&
    echo "                  ${cyan}${bold}noVNC${normal}         ${bold}${yellow}${InsVNC}${normal}"
    [[ -n $InsX2Go ]] &&
    echo "                  ${cyan}${bold}X2Go${normal}          ${bold}${yellow}${InsX2Go}${normal}"
    [[ -n $InsWine ]] &&
    echo "                  ${cyan}${bold}Wine${normal}          ${bold}${yellow}${InsWine}${normal}"
    [[ -n $InsMono ]] &&
    echo "                  ${cyan}${bold}mono${normal}          ${bold}${yellow}${InsMono}${normal}"
    [[ -n $InsTools ]] &&
    echo "                  ${cyan}${bold}UpTools${normal}       ${bold}${yellow}${InsTools}${normal}"
    [[ -n $InsRclone ]] &&
    echo "                  ${cyan}${bold}rclone${normal}        ${bold}${yellow}${InsRclone}${normal}"
    [[ $sihuo == yes ]] && echo &&
    echo "                  ${cyan}${bold}私货${normal}          ${bold}${yellow}有${normal}"
    echo
    echo '####################################################################'
    echo
    [[ $script_lang == eng ]] && echo -e "${bold}If you want to stop, Press ${baihongse} Ctrl+C ${normal}${bold} ; or Press ${bailvse} ENTER ${normal} ${bold}to start${normal}"
    [[ $script_lang == chs ]] && echo -e "${bold}按 ${baihongse} Ctrl+C ${normal}${bold} 取消安装，或者敲 ${bailvse} ENTER ${normal}${bold} 开始安装${normal}"
    [[ $ForceYes != 1 ]] && read input
    [[ $script_lang == eng ]] &&
    echo -e "${bold}${magenta}The selected softwares $lang_will_be_installed, this may take between${normal}" &&
    echo -e "${bold}${magenta}1 - 100 minutes depending on your systems specs and your selections${normal}\n"
    [[ $script_lang == chs ]] &&
    echo -e "${bold}${magenta}开始安装所需的软件，由于所选选项的区别以及盒子硬件性能的差异，安装所需时间也会有所不同${normal}\n"
}





# --------------------- 替换系统源、创建用户、准备工作 --------------------- #

function preparation() {

    [[ $USESWAP == Yes ]] && swap_on

    # 临时
    mkdir -p $LogBase/app $LogBase/info $SourceLocation $LOCKLocation $LogLocation $DebLocation $WebROOT/h5ai/$iUser
    echo $iUser >> /log/inexistence/info/installed.user.list.txt

    if [[ $aptsources == Yes ]] && [[ $CODENAME != jessie ]]; then
        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y%m%d.%H%M")".bak >> "$OutputLOG" 2>&1
        wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/$default_branch/00.Installation/template/$DISTROL.apt.sources  >> "$OutputLOG" 2>&1
        sed -i "s/RELEASE/$CODENAME/g" /etc/apt/sources.list >> "$OutputLOG" 2>&1
        [[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117 >> "$OutputLOG" 2>&1
    fi

    # wget -nv https://mediaarea.net/repo/deb/repo-mediaarea_1.0-6_all.deb && dpkg -i repo-mediaarea_1.0-6_all.deb && rm -rf repo-mediaarea_1.0-6_all.deb
    APT_UPGRADE_SINGLE=1   APT_UPGRADE

    # Install atop may causedpkg failure in some VPS, so install it separately
    [[ ! -d /proc/vz ]] && apt-get -y install atop >> "$OutputLOG" 2>&1

    echo -n "Installing packages ..."
    apt_install_check screen git sudo zsh nano wget curl cron lrzsz locales aptitude ca-certificates apt-transport-https virt-what lsb-release     \
                      htop iotop dstat sysstat ifstat vnstat vnstati nload psmisc dirmngr hdparm smartmontools nvme-cli                            \
                      ethtool net-tools speedtest-cli mtr iperf iperf3               gawk jq bc ntpdate rsync tmux file tree time parted fuse perl \
                      dos2unix subversion nethogs fontconfig ntp patch locate        lsof pciutils gnupg whiptail                                  \
                      libgd-dev libelf-dev libssl-dev zlib1g-dev                     debian-archive-keyring software-properties-common             \
                      zip unzip p7zip-full mediainfo mktorrent fail2ban lftp         bwm-ng wondershaper
                    # uuid socat figlet toilet lolcat
    apt_install_together & spinner $!
    status_done

    if [ ! $? = 0 ]; then
        echo -e "\n${baihongse}${shanshuo}${bold} ERROR ${normal} ${red}${bold}Please check it and rerun once it is resolved${normal}\n"
        kill -s TERM $TOP_PID
        exit 1
    fi

    # Fix interface in vnstat.conf
    [[ -n $interface ]] && [[ $interface != eth0 ]] && sed -i "s/Interface.*/Interface $interface/" /etc/vnstat.conf

    # Get repository
    [[ -d /etc/inexistence ]] && mv /etc/inexistence /etc/inexistence_old_$(date "+%Y%m%d_%H%M")
    git clone --depth=1 -b $iBranch https://github.com/Aniverse/inexistence /etc/inexistence >> "$OutputLOG" 2>&1
    chmod -R 755 /etc/inexistence
    chmod -R 644 /etc/inexistence/00.Installation/template/systemd/*

    hezi_add_user $iUser $iPass >> "$OutputLOG" 2>&1

    echo -e "
如果要截图请截完整点，包含下面所有信息
CPU        : $cname
Cores      : ${freq} MHz, ${cpucores} Core(s), ${cputhreads} Thread(s)
Mem        : $tram MB ($uram MB Used)
Disk       : $disk_total_size GB ($disk_used_size GB Used)
OS         : $DISTRO $osversion $CODENAME ($arch)
Kernel     : $running_kernel
ASN & ISP  : $asnnnnn, $isppppp
Location   : $cityyyy, $regionn, $country
Virt       : $virtual
#################################
InstalledTimes=$times
INEXISTENCEVER=${script_version}
INEXISTENCEDATE=${script_update}
Setup_date=$(date "+%Y.%m.%d %H:%M")
MaxDisk=$MaxDisk
HomeUserNum=$(ls /home | wc -l)
use_swap=$USESWAP
#################################
qb_version=${qb_version}
de_version=${de_version}
rt_version=${rt_version}
tr_version=${tr_version}
lt_version=${lt_version}
MaxCPUs=${MAXCPUS}
apt_sources=${aptsources}
FlexGet=${InsFlex}
Flood=${InsFlood}
FileBrowser=${InsFB}
Tweaks=${UseTweaks}

bbr=${InsBBR}
rclone=${InsRclone}
Tools=${InsTools}
wine=${InsWine}
mono=${InsMono}
noVNC=${InsVNC}
X2Go=${InsX2Go}
#################################
如果要截图请截完整点，包含上面所有信息
" >> $LogBase/installed.log

    cat << EOF >> $LogBase/info/version.txt
inexistence.times       $times
inexistence.version     $script_version
inexistence.update      $script_update
inexistence.lang        $script_lang
inexistence.user        $iUser
inexistence.setup       $(date "+%Y.%m.%d %H:%M")

EOF

    echo "${asnnnnn}"        > $LogBase/info/asn.txt
    echo "${serveripv4}"     > $LogBase/info/serveripv4.txt
    if [[ -n $serveripv6 ]]; then
        echo "${serveripv6}" > $LogBase/info/serveripv6.txt
    fi

    # Raise open file limits
    sed -i '/^fs.file-max.*/'d /etc/sysctl.conf
    sed -i '/^fs.nr_open.*/'d /etc/sysctl.conf
    echo "fs.file-max = 1048576" >> /etc/sysctl.conf
    echo "fs.nr_open = 1048576" >> /etc/sysctl.conf
    sed -i '/.*nofile.*/'d /etc/security/limits.conf
    sed -i '/.*nproc.*/'d /etc/security/limits.conf
    cat << EOF >> /etc/security/limits.conf
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

    # alias and locales
    ln -s $local_packages/s-alias /usr/local/bin/s-alias  >> "$OutputLOG" 2>&1
    sed -i "s/iUser/$iUser/g" $local_packages/s-alias
    # Do not give s-alias execute permission so when user input s-alias it will be: -bash: /usr/local/bin/s-alias: Permission denied
    # And which s-alias will return nothing, while command -v s-alias returns /usr/local/bin/s-alias
    chmod 644 /usr/local/bin/s-alias

    if [[ $UseTweaks == Yes ]]; then
        sed -i "/source \/usr\/local\/bin\/s-alias/"d /etc/bash.bashrc
        echo -e "\nsource /usr/local/bin/s-alias" >> /etc/bash.bashrc
    fi

    mkdir -p $local_script
    ln -s    $local_packages/script/*    $local_script   >> "$OutputLOG" 2>&1
    ln -s    $local_packages/hezi        $local_script   >> "$OutputLOG" 2>&1
    echo "export PATH=$local_script:$PATH" >> /etc/bash.bashrc

    ln -s /etc/inexistence   $WebROOT/h5ai/inexistence   >> "$OutputLOG" 2>&1
    ln -s /log               $WebROOT/h5ai/log           >> "$OutputLOG" 2>&1

    if [[ ! -f /etc/abox/app/BDinfoCli.0.7.3/BDInfo.exe ]]; then
        mkdir -p /etc/abox/app
        cd /etc/abox/app
        svn co https://github.com/Aniverse/bluray/trunk/tools/BDinfoCli.0.7.3 >> "$OutputLOG" 2>&1
        mv -f BDinfoCli.0.7.3 BDinfoCli
    fi

    if [[ ! -f /etc/abox/app/bdinfocli.exe ]]; then
        wget https://github.com/Aniverse/bluray/raw/master/tools/bdinfocli.exe -O -nv -N /etc/abox/app/bdinfocli.exe >> "$OutputLOG" 2>&1
    fi

    # sed -i -e "s|username=.*|username=$iUser|" -e "s|password=.*|password=$iPass|" /usr/local/bin/rtskip
    echo -e "Preparation ${green}${bold}DONE${normal}"
}


function _distro_upgrade_upgrade() {
    echo -e "\n\n\n${baihongse}executing upgrade${normal}\n\n\n"
    apt-get --force-yes -o Dpkg::Options::="--force-confnew" --force-yes -o Dpkg::Options::="--force-confdef" -fuy upgrade

    echo -e "\n\n\n${baihongse}executing dist-upgrade${normal}\n\n\n"
    apt-get --force-yes -o Dpkg::Options::="--force-confnew" --force-yes -o Dpkg::Options::="--force-confdef" -fuy dist-upgrade
}


function _distro_upgrade() {
    DEBIAN_FRONTEND=noninteractive
    APT_LISTCHANGES_FRONTEND=none
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
    wget --no-check-certificate -O /etc/apt/sources.list https://github.com/Aniverse/inexistence/raw/$default_branch/00.Installation/template/$DISTROL.apt.sources
    [[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117

    if [[ $UPGRDAE3 == Yes ]]; then
        sed -i "s/RELEASE/${UPGRADE_CODENAME_1}/g" /etc/apt/sources.list
        apt-get -y update
        _distro_upgrade_upgrade
        sed -i "s/${UPGRADE_CODENAME_1}/${UPGRADE_CODENAME_2}/g" /etc/apt/sources.list
        apt-get -y update
        _distro_upgrade_upgrade
        sed -i "s/${UPGRADE_CODENAME_2}/${UPGRADE_CODENAME_3}/g" /etc/apt/sources.list
        apt-get -y update
    elif [[ $UPGRDAE2 == Yes ]]; then
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

    echo -e "\n\n\n" ; _time upgradation

    [[ $DeBUG != 1 ]] && echo -e "\n\n ${shanshuo}${baihongse}Reboot system now. You need to rerun this script after reboot${normal}\n\n\n\n\n"
    sleep 5  ;  eboot -f  ;  init 6  ;  sleep 5  ;  kill -s TERM $TOP_PID ; exit
}





function install_deluge() {

    if [[ $separate == 10086 ]] ; then
        bash $local_packages/package/deluge/install -v $de_version
    else
        apt-get install -y python python-pip python-setuptools
        apt-get install -y python-twisted python-openssl python-xdg python-chardet geoip-database python-notify python-pygame python-glade2 librsvg2-common xdg-utils python-mako
        if [[ $Deluge_2_later == Yes ]]; then
            apt-get install -y python-pip
            pip2 install --upgrade pip
            hash -d pip2
            pip2 install --upgrade setuptools
            pip2 install --upgrade twisted[tls] twisted pillow rencode pyopenssl
        fi
        cd $SourceLocation

        if [[ $de_version == 2.0.3 ]]; then
            while true ; do
                wget -nv -N https://ftp.osuosl.org/pub/deluge/source/2.0/deluge-2.0.3.tar.xz && break
                sleep 1
            done
            tar xf deluge-$de_version.tar.xz
            rm -f deluge-$de_version.tar.xz
            cd deluge-2.0.3
        else
            [[ $Deluge_1_3_15_skip_hash_check_patch == Yes  ]] && de_version=1.3.15
            while true ; do
                wget -nv -N https://github.com/deluge-torrent/deluge/archive/deluge-$de_version.tar.gz && break
                sleep 1
            done
            tar xf deluge-$de_version.tar.gz
            rm -f deluge-$de_version.tar.gz
            cd deluge*$de_version
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
            python setup.py install --install-layout=deb --record /log/inexistence/deluge_filelist.txt > /dev/null
            mv -f /usr/bin/deluged /usr/bin/deluged2
            wget -nv -N http://download.deluge-torrent.org/source/deluge-1.3.15.tar.gz
            tar xf deluge-1.3.15.tar.gz && rm -f deluge-1.3.15.tar.gz && cd deluge-1.3.15
        fi

        python setup.py build  > /dev/null
        python setup.py install --install-layout=deb --record $LogLocation/install_deluge_filelist_$de_version.txt  > /dev/null # 输出太长了，省略大部分，反正也不重要
        python setup.py install_data # For Desktop users

        if [[ $Deluge_1_3_15_skip_hash_check_patch == Yes ]]; then
            wget https://raw.githubusercontent.com/Aniverse/inexistence/files/miscellaneous/deluge.1.3.15.skip.no.full.allocate.patch \
            -O /tmp/deluge.1.3.15.skip.no.full.allocate.patch
            cd /usr/lib/python2.7/dist-packages/deluge-1.3.15-py2.7.egg/deluge
            patch -p1 < /tmp/deluge.1.3.15.skip.no.full.allocate.patch
        fi
        # 这个私货是修改 Deluge WebUI 里各个标签的默认排序以及宽度，符合我个人的习惯（默认的简直没法用，每次都要改很麻烦）
        if [[ $sihuo == yes ]]; then
            wget -nv https://github.com/Aniverse/inexistence/raw/files/miscellaneous/deluge.status.bar.patch \
            -O /tmp/deluge.status.bar.patch
            cd /usr/lib/python2.7/dist-packages/deluge-${de_version}-py2.7.egg/deluge
            patch -p1 < /tmp/deluge.status.bar.patch
        fi
        [[ $Deluge_ssl_fix_patch == Yes ]] && mv -f /usr/bin/deluged2 /usr/bin/deluged # 让老版本 Deluged 保留，其他用新版本
    fi

    cd
}





function config_deluge() {
    mkdir -p /home/$iUser/deluge/{download,torrent,watch}
    ln -s /home/$iUser/deluge/download $WebROOT/h5ai/$iUser/deluge
    chown -R $iUser.$iUser /home/$iUser/deluge

    mkdir -p /root/.config
    [[ -d /root/.config/deluge ]] && { rm -rf /root/.config/deluge.old ; mv -f /root/.config/deluge /root/.config/deluge.old ; }
    cp -rf /etc/inexistence/00.Installation/template/config/deluge /root/.config/deluge
    chmod -R 755 /root/.config

    cat > /tmp/deluge.userpass.py <<EOF
#!/usr/bin/env python
import hashlib
import sys
password = sys.argv[1]
salt = sys.argv[2]
s = hashlib.sha1()
s.update(salt)
s.update(password)
print s.hexdigest()
EOF
    DWSALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -1)
    DWP=$(python /tmp/deluge.userpass.py ${iPass} ${DWSALT})
    echo "$iUser:$iPass:10" >> /root/.config/deluge/auth
    chmod 600 /root/.config/deluge/auth
    sed -i "s/delugeuser/$iUser/g" /root/.config/deluge/core.conf
    sed -i "s/DWSALT/$DWSALT/g" /root/.config/deluge/web.conf
    sed -i "s/DWP/$DWP/g" /root/.config/deluge/web.conf

    cp -f /etc/inexistence/00.Installation/template/systemd/deluged.service /etc/systemd/system/deluged.service
    cp -f /etc/inexistence/00.Installation/template/systemd/deluge-web.service /etc/systemd/system/deluge-web.service
    [[ $Deluge_2_later == Yes ]] && sed -i "s/deluge-web -l/deluge-web -d -l/" /etc/systemd/system/deluge-web.service
    # or perhaps Type=forking ?

    systemctl daemon-reload
    systemctl enable /etc/systemd/system/deluge-web.service
    systemctl enable /etc/systemd/system/deluged.service
    systemctl start deluged
    systemctl start deluge-web

    touch $LOCKLocation/deluge.lock
}





function install_rtorrent() {
    bash -c "$(wget -qO- https://raw.githubusercontent.com/Aniverse/rtinst/master/rtsetup)"
    sed -i "s/make\ \-s\ \-j\$(nproc)/make\ \-s\ \-j${MAXCPUS}/g" /usr/local/bin/rtupdate

    if [[ $rt_installed == Yes ]]; then
        rtupdate $IPv6Opt $rt_versionIns
    else
        rtinst --ssh-default --ftp-default --rutorrent-master --force-yes --log $IPv6Opt -v $rt_versionIns -u $iUser -p $iPass -w $iPass
    fi

    if [[ -n "$rt_domain" ]] && [[ $(systemctl is-active nginx 2>/dev/null) == active ]]; then
        cd ; wget -O- https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh | INSTALLONLINE=1  sh
        /root/.acme.sh/acme.sh --issue -d $rt_domain --webroot /var/www && \
        /root/.acme.sh/acme.sh --installcert -d $rt_domain \
        --key-file   /etc/ssl/private/ruweb.key \
        --fullchain-file /etc/ssl/ruweb.crt \
        --reloadcmd  "service nginx force-reload"
        rm -f master.tar.gz
    fi

    mv /root/rtinst.log $LogLocation/07.rtinst.script.log
    mv /home/$iUser/rtinst.info $LogLocation/07.rtinst.info.txt
    ln -s /home/${iUser} $WebROOT/h5ai/$iUser/user.root
    touch $LOCKLocation/rtorrent.lock
}





function install_flood() {
    # https://github.com/nodesource/distributions/blob/master/README.md
    # curl -sL https://deb.nodesource.com/setup_11.x | bash -
    curl -sL https://deb.nodesource.com/setup_10.x | bash -
    apt-get install -y nodejs build-essential # python3-dev
    npm install -g node-gyp
    git clone --depth=1 https://github.com/jfurrow/flood.git /srv/flood
    cd /srv/flood
    cp config.template.js config.js
    npm install
    sed -i "s/127.0.0.1/0.0.0.0/" /srv/flood/config.js

    npm run build 2>&1 | tee /tmp/flood.log
    rm -rf $LOCKLocation/flood.fail.lock
    # [[ `grep "npm ERR!" /tmp/flood.log` ]] && touch $LOCKLocation/flood.fail.lock

    cp -f /etc/inexistence/00.Installation/template/systemd/flood.service /etc/systemd/system/flood.service
    systemctl start  flood
    systemctl enable flood

    touch $LOCKLocation/flood.lock
    cd
}





function install_transmission() {
    if [[ "${tr_version}" == 2.94 ]] && [[ "${TRdefault}" == deb ]]; then
        list="transmission-common_2.94-1mod1_all.deb
    transmission-cli_2.94-1mod1_amd64.deb
    transmission-daemon_2.94-1mod1_amd64.deb
    transmission-gtk_2.94-1mod1_amd64.deb
    transmission-qt_2.94-1mod1_amd64.deb
    transmission_2.94-1mod1_all.deb"
        mkdir -p /tmp/tr_deb
        cd /tmp/tr_deb
        for deb in $list ; do
            wget -nv -O $deb https://github.com/Aniverse/inexistence-files/raw/master/deb/${CODENAME}/transmission/$deb
          # apt-get -y install /tmp/tr_deb/$deb
        done
        if [[ $CODENAME != jessie ]]; then
            apt-get -y install ./*deb
        else
            dpkg -i ./*deb
            apt-get -fy install
        fi
        cd
        apt-mark hold transmission-common transmission-cli transmission-daemon transmission-gtk transmission-qt transmission
    else
        apt-get install -y libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev # > /dev/null
        apt-get install -y pkg-config automake autoconf cmake libtool intltool build-essential # 也不知道要不要，保险起见先装上去了
        apt-get install -y openssl
        [[ $CODENAME == stretch ]] && apt-get install -y libssl1.0-dev # https://tieba.baidu.com/p/5532509017?pn=2#117594043156l

        cd $SourceLocation
        wget -nv -N https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
        tar xf release-2.1.8-stable.tar.gz ; rm -rf release-2.1.8-stable.tar.gz
        mv libevent-release-2.1.8-stable libevent-2.1.8
        cd libevent-2.1.8
        ./autogen.sh
        ./configure
        make -j$MAXCPUS
        make install

        ldconfig # ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib/libevent-2.1.so.6
        cd ..
        git clone https://github.com/transmission/transmission transmission-$tr_version
        cd transmission-$tr_version
        git checkout $tr_version
        # 修复 Transmission 2.92 无法在 Ubuntu 18.04 下编译的问题（openssl 1.1.0），https://github.com/transmission/transmission/pull/24
        [[ $tr_version == 2.92 ]] && { git config --global user.email "you@example.com" ; git config --global user.name "Your Name" ; git cherry-pick eb8f500 -m 1 ; }
        # 修复 2.93 以前的版本可能无法过 configure 的问题，https://github.com/transmission/transmission/pull/215
        grep m4_copy_force m4/glib-gettext.m4 -q || sed -i "s/m4_copy/m4_copy_force/g" m4/glib-gettext.m4
        ./autogen.sh
        ./configure --prefix=/usr
        make -j$MAXCPUS
        make install
    fi

    echo 1 | bash -c "$(wget -qO- https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control.sh)"
    touch $LOCKLocation/transmission.lock
}





function install_bbr() {
    if [[ $bbrinuse == Yes ]]; then
        sleep 0
    elif [[ $bbrkernel == Yes && $bbrinuse == No ]]; then
        enable_bbr
    else
        bnx2_firmware
        bbr_kernel_4_11_12
        enable_bbr
    fi
    echo -e "\n\n${bailvse}  BBR-INSTALLATION-COMPLETED  ${normal}\n"
}

# 安装 4.11.12 的内核
function bbr_kernel_4_11_12() {
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

    wget -nv -N O 1.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux.Kernel/BBR/linux-headers-4.11.12-all.deb
    wget -nv -N O 2.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux.Kernel/BBR/linux-headers-4.11.12-amd64.deb
    wget -nv -N O 3.deb https://github.com/Aniverse/BitTorrentClientCollection/raw/master/Linux.Kernel/BBR/linux-image-4.11.12-generic-amd64.deb
    dpkg -i [123].deb
    rm -rf [123].deb
    update-grub
}

# 开启 BBR
function enable_bbr() {
    bbrname=bbr
    sed -i '/net.core.default_qdisc.*/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control.*/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = $bbrname" >> /etc/sysctl.conf
    sysctl -p
    touch $LOCKLocation/bbr.lock
}

# Install firmware for BCM NIC
function bnx2_firmware() {
    if lspci | grep -i bcm >/dev/null; then
        mkdir -p /lib/firmware/bnx2 && cd /lib/firmware/bnx2
        bnx2="bnx2-mips-09-6.2.1b.fw bnx2-mips-06-6.2.3.fw bnx2-rv2p-09ax-6.0.17.fw bnx2-rv2p-09-6.0.17.fw bnx2-rv2p-06-6.0.15.fw"
        for f in $bnx2 ; do
            wget -nv -N https://sourceforge.net/projects/inexistence/files/firmware/bnx2/$f/download -O $f
        done
    fi
}






function install_x2go() {
    apt-get install -y xfce4 xfce4-goodies fonts-noto xfonts-intl-chinese-big xfonts-wqy

    if [[ $DISTRO == Ubuntu ]]; then
        apt-get install -y software-properties-common firefox
        apt-add-repository -y ppa:x2go/stable
    elif [[ $DISTRO == Debian ]]; then
        cat << EOF > /etc/apt/sources.list.d/x2go.list
    # X2Go Repository (release builds)
    deb http://packages.x2go.org/debian ${CODENAME} main
    # X2Go Repository (sources of release builds)
    deb-src http://packages.x2go.org/debian ${CODENAME} main
    # X2Go Repository (nightly builds)
    #deb http://packages.x2go.org/debian ${CODENAME} heuler
    # X2Go Repository (sources of nightly builds)
    #deb-src http://packages.x2go.org/debian ${CODENAME} heuler
EOF
        # gpg --keyserver http://keyserver.ubuntu.com --recv E1F958385BFE2B6E
        # gpg --export E1F958385BFE2B6E > /etc/apt/trusted.gpg.d/x2go.gpg
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1F958385BFE2B6E
        APT_UPGRADE
        apt-get -y install x2go-keyring iceweasel
    fi

    APT_UPGRADE
    apt-get -y install x2goserver x2goserver-xsession pulseaudio

    touch $LOCKLocation/x2go.lock
}





function install_tools() {
    ########## NConvert ##########
    cd $SourceLocation
    wget -t1 -T5 -nv -N http://download.xnview.com/NConvert-linux64.tgz && {
        tar zxf NConvert-linux64.tgz
        mv NConvert/nconvert /usr/local/bin
        rm -rf NConvert*
    }
    ########## Blu-ray script ##########
    bash <(wget -qO- git.io/bluray) -u
    ########## ffmpeg ########## https://johnvansickle.com/ffmpeg/
    if [[ -z $(command -v ffmpeg) ]]; then
        mkdir -p /log/inexistence/ffmpeg && cd /log/inexistence/ffmpeg && rm -rf *
        wget -t2 -T5 -nv -N https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
        tar xf ffmpeg-release-amd64-static.tar.xz
        cd ffmpeg*
        cp -f {ffmpeg,ffprobe,qt-faststart} /usr/bin
        cd && rm -rf /log/inexistence/ffmpeg
    fi
    ########## mkvtoolnix ##########
    wget -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -
    echo "deb https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" > /etc/apt/sources.list.d/mkvtoolnix.list
    echo "deb-src https://mkvtoolnix.download/${DISTROL}/ $CODENAME main" >> /etc/apt/sources.list.d/mkvtoolnix.list

    apt-get -y update
    apt-get install -y mkvtoolnix mkvtoolnix-gui imagemagick mktorrent
    ######################  eac3to  ######################
    cd /etc/abox/app
    wget -nv -N http://madshi.net/eac3to.zip
    unzip -qq eac3to.zip
    rm -rf eac3to.zip ; cd

    touch $LOCKLocation/tools.lock
    echo -e "\n\n\n${bailvse}Version${normal}${bold}${green}"
    mktorrent -h | head -n1
    mkvmerge --version
    echo "Mediainfo `mediainfo --version | grep Lib | cut -c17-`"
    echo "ffmpeg `ffmpeg 2>&1 | head -n1 | awk '{print $3}'`${normal}"
}





function system_tweaks() {
    # Set timezone to UTC+8
    rm -rf /etc/localtime
    ln -s  /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata  >> "$OutputLOG" 2>&1
    ntpdate time.windows.com                   >> "$OutputLOG" 2>&1
    hwclock -w                                 >> "$OutputLOG" 2>&1
    # Change default system language to English
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale
    dpkg-reconfigure --frontend=noninteractive locales   >> "$OutputLOG" 2>&1
    update-locale LANG=en_US.UTF-8                       >> "$OutputLOG" 2>&1
    # screen config
    if ! grep "defencoding utf8" /etc/screenrc -q ; then
        cat << EOF >> /etc/screenrc
shell -$SHELL

startup_message off
defutf8 on
defencoding utf8
encoding utf8 utf8
defscrollback 23333
EOF
    fi
    # 将最大的分区的保留空间设置为 1 %
    if mount | grep $MaxDisk | grep ext4 -q ; then
        tune2fs -m 1 $MaxDisk   >> "$OutputLOG" 2>&1
    fi

    locale-gen en_US.UTF-8          >> "$OutputLOG" 2>&1
    locale                          >> "$OutputLOG" 2>&1
    sysctl -p                       >> "$OutputLOG" 2>&1
    apt-get -y autoremove           >> "$OutputLOG" 2>&1
    touch $LOCKLocation/tweaks.lock
}





######################################################################################################

_intro
[[ -z $MAXCPUS ]] && MAXCPUS=$(nproc)
ask_username
ask_password
ask_apt_sources
ask_swap
ask_qbittorrent
ask_deluge
ask_rtorrent
ask_transmission
ask_flexget
ask_filebrowser
ask_tweaks

if_need_lt=0
[[ $qb_version != No ]] && [[ -z $qb_mode ]] && if_need_lt=1
[[ $de_version != No ]] && if_need_lt=1
[[ $if_need_lt  == 1 ]] && [[ -z $lt_version ]] && lt_version=RC_1_1
ask_continue

starttime=$(date +%s)
OutputLOG=/etc/00.preparation.log     preparation 2>&1 | tee /etc/00.preparation.log
mv /etc/00.preparation.log  $LogLocation/00.preparation.log

######################################################################################################

do_installation
[[ $USESWAP == Yes ]] && swap_off
check_install_2
echo ; [[ $sihuo != yes ]] && clear
END_output_url 2>&1 | tee -a $LogBase/end.log
# rm -f "$0" > /dev/null 2>&1
ask_reboot
