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
script_version=1.2.7.10
script_update=2020.09.13
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
OPTS=$(getopt -o dsyu:p:b:h --long "qb-source,help,hostname:,domain:,no-reboot,quick,branch:,yes,skip,no-system-upgrade,debug,no-source-change,swap,no-swap,bbr,no-bbr,flood,vnc,x2go,wine,mono,tools,filebrowser,no-filebrowser,flexget,no-flexget,rclone,enable-ipv6,tweaks,no-tweaks,mt-single,mt-double,mt-all,mt-half,tr-deb,eng,chs,sihuo,user:,password:,webpass:,de:,qb:,rt:,tr:,lt:,qb-static,separate" -- "$@")
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
export SCLocation=$LogTimes/source
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
    if   [[ $SysSupport =~ (1|2) ]]; then
        echo -e "\n${green}${bold}Excited! Your operating system is supported by this script. Let's make some big news ... ${normal}"
    elif [[ $SysSupport == "3" ]]; then
        echo -e "\n${bold}你可以使用这个脚本来升级系统，以使用本脚本\n${blue}https://github.com/DieNacht/debian-ubuntu-upgrade${normal}"
    else
        echo -e "\n${bold}${red}Too young too simple! Only Debian 9/10 and Ubuntu 16.04/18.04 is supported by this script${normal}"
        echo -e "${bold}If you want to run this script on unsupported distro, please use -s option\nExiting...${normal}\n"
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
    [[ $CODENAME =~ (bionic|buster)  ]] && SysSupport=1
    [[ $CODENAME =~ (xenial|stretch) ]] && SysSupport=2
    [[ $CODENAME =~ (jessie|wheezy|trusty) ]] && SysSupport=3
    [[ $DeBUG == 1 ]] && echo "${bold}DISTRO=$DISTRO, CODENAME=$CODENAME, osversion=$osversion, SysSupport=$SysSupport${normal}"

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

    echo "${bold}  ---------- [System Information] ----------${normal}"
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

    [[ $SYSTEMCHECK != 1 ]] && echo -e "\n  ${bold}${red}System Checking Skipped. $lang_note_that this script may not work on unsupported system${normal}"
    [[ -n "$rt_domain" ]] && [[ $(host "$rt_domain" 2>&1 | grep -oE "[0-9.]+\.[0-9.]+") != "$serveripv4" ]] &&
    echo -e "\n  ${yellow}${bold}It seems your domain $rt_domain does NOT resolve to your IPv4 address $serveripv4${normal}"

    if   [[ $CODENAME == jessie ]]; then
        echo -e "\n  ${bold}${red}警告：尽量不要使用 Debian 8 运行本脚本！${normal}"
    elif [[ $CODENAME == focal ]]; then
        echo -e "\n  ${bold}${red}警告：本脚本尚不支持 Ubuntu 20.04 LTS！${normal}"
    fi

    [[ $times != 1 ]] && echo -e "\n  ${bold}It seems this is the $times times you run this script${normal}"
    
    [[ ${virtual} != "No Virtualization Detected" ]] && [[ ${virtual} != "KVM" ]] && echo -e "\n  ${bold}${red}这个脚本基本上没有在非 KVM 的 VPS 测试过，不保证 OpenVZ、HyperV、Xen、Lxc 等架构下一切正常${normal}"

    echo -e "\n  ${bold}For more information about this script,\n  please refer README on GitHub (Chinese only)"
    echo -e "  Press ${on_red}Ctrl+C${normal} ${bold}to exit${jiacu}, or press ${bailvse}ENTER${normal} ${bold}to continue" ; [[ $ForceYes != 1 ]] && read input
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
    [[ -n $lt_version ]] && [[ $lt_version != RC_1_1 ]] &&
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
    echo -e "${bold}${magenta}1 - 60 minutes depending on your systems specs and your selections${normal}\n"
    [[ $script_lang == chs ]] &&
    echo -e "${bold}${magenta}开始安装所需的软件，由于所选选项的区别以及盒子硬件性能的差异，安装所需时间也会有所不同${normal}\n"
}





# --------------------- 替换系统源、创建用户、准备工作 --------------------- #

function preparation() {

    [[ $USESWAP == Yes ]] && swap_on
    mkdir -p $LogBase/app $LogBase/info $SCLocation $LOCKLocation $LogLocation $DebLocation $WebROOT/h5ai/$iUser
    echo $iUser >> /log/inexistence/info/installed.user.list.txt

    if [[ $aptsources == Yes ]] && [[ $CODENAME != jessie ]]; then
        cp /etc/apt/sources.list /etc/apt/sources.list."$(date "+%Y%m%d.%H%M")".bak >> "$OutputLOG" 2>&1
        apt_sources_replace
        [[ $DISTROL == debian ]] && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117 >> "$OutputLOG" 2>&1
    fi
    apt_sources_add

    # wget -nv https://mediaarea.net/repo/deb/repo-mediaarea_1.0-6_all.deb && dpkg -i repo-mediaarea_1.0-6_all.deb && rm -rf repo-mediaarea_1.0-6_all.deb
    APT_UPGRADE_SINGLE=1   APT_UPGRADE

    # Install atop may causedpkg failure in some VPS, so install it separately
    [[ -d /proc/vz ]] && apt-get -y install atop >> "$OutputLOG" 2>&1

    echo -n "Installing packages ..."
    apt_install_check screen git sudo zsh nano wget curl cron lrzsz locales aptitude ca-certificates apt-transport-https virt-what lsb-release     \
                      atop htop iotop dstat sysstat ifstat vnstat vnstati nload psmisc dirmngr hdparm smartmontools                                \
                      ethtool net-tools mtr iperf iperf3                             gawk jq bc ntpdate rsync tmux file tree time parted fuse perl \
                      dos2unix subversion nethogs fontconfig ntp patch locate        lsof pciutils gnupg whiptail                                  \
                      debian-archive-keyring software-properties-common zip unzip p7zip-full mediainfo mktorrent fail2ban lftp
                    # uuid socat figlet toilet lolcat
                    # speedtest-cli nvme-cli libgd-dev libelf-dev libssl-dev zlib1g-dev bwm-ng wondershaper
    apt_install_together & spinner $!

    unset apt_install_failed ; source /tmp/apt_status >> "$OutputLOG" 2>&1
    if [[ $apt_install_failed == 1 ]]; then
        echo -e "\n${baihongse}${shanshuo}${bold} ERROR ${normal} ${red}${bold}Please check it and rerun once it is resolved${normal}\n"
        kill -s TERM $TOP_PID
        exit 1
    else
        status_done
    fi

    # Fix interface in vnstat.conf
    [[ -n $interface ]] && [[ $interface != eth0 ]] && sed -i "s/Interface.*/Interface $interface/" /etc/vnstat.conf >> "$OutputLOG" 2>&1

    # Get repository
    [[ -d /etc/inexistence ]] && mv /etc/inexistence /etc/inexistence_old_$(date "+%Y%m%d_%H%M") >> "$OutputLOG" 2>&1
    git clone --depth=1 -b $iBranch https://github.com/Aniverse/inexistence /etc/inexistence >> "$OutputLOG" 2>&1
    chmod -R 755 /etc/inexistence >> "$OutputLOG" 2>&1
    chmod -R 644 /etc/inexistence/00.Installation/template/systemd/* >> "$OutputLOG" 2>&1

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
FileBrowser=${InsFB}
Tweaks=${UseTweaks}

bbr=${InsBBR}
rclone=${InsRclone}
Tools=${InsTools}
Flood=${InsFlood}
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
    sed -i "s/iUser/$iUser/g" $local_packages/s-alias     >> "$OutputLOG" 2>&1
    # Do not give s-alias execute permission so when user input s-alias it will be: -bash: /usr/local/bin/s-alias: Permission denied
    # And which s-alias will return nothing, while command -v s-alias returns /usr/local/bin/s-alias
    chmod 644 /usr/local/bin/s-alias

    if [[ $UseTweaks == Yes ]]; then
        sed -i "/source \/usr\/local\/bin\/s-alias/"d /etc/bash.bashrc  >> "$OutputLOG" 2>&1
        echo -e "\nsource /usr/local/bin/s-alias" >> /etc/bash.bashrc
    fi

    mkdir -p $local_script
    ln -s    $local_packages/script/*    $local_script   >> "$OutputLOG" 2>&1
    ln -s    $local_packages/hezi        $local_script   >> "$OutputLOG" 2>&1
    echo "export PATH=$local_script:$PATH" >> /etc/bash.bashrc

    ln -s /etc/inexistence   $WebROOT/h5ai/inexistence   >> "$OutputLOG" 2>&1
    ln -s /log               $WebROOT/h5ai/log           >> "$OutputLOG" 2>&1

    if [[ ! -f /etc/abox/app/BDinfoCli.0.7.3/BDInfo.exe ]]; then
        mkdir -p /etc/abox/app                                                 >> "$OutputLOG" 2>&1
        cd /etc/abox/app                                                       >> "$OutputLOG" 2>&1
        svn co https://github.com/Aniverse/bluray/trunk/tools/BDinfoCli.0.7.3  >> "$OutputLOG" 2>&1
        mv -f BDinfoCli.0.7.3 BDinfoCli                                        >> "$OutputLOG" 2>&1
    fi

    if [[ ! -f /etc/abox/app/bdinfocli.exe ]]; then
        wget https://github.com/Aniverse/bluray/raw/master/tools/bdinfocli.exe -O -nv -N /etc/abox/app/bdinfocli.exe >> "$OutputLOG" 2>&1
    fi

    # sed -i -e "s|username=.*|username=$iUser|" -e "s|password=.*|password=$iPass|" /usr/local/bin/rtskip
    echo -e "Preparation ${green}${bold}DONE${normal}"
}



function system_tweaks() {
    # Set timezone to UTC+8
    rm -rf /etc/localtime
    ln -s  /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata  >> "$OutputLOG" 2>&1
    ntpdate time.windows.com                   >> "$OutputLOG" 2>&1
    hwclock -w                                 >> "$OutputLOG" 2>&1
    # Change default system language to English
    # sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    if (grep -q "en_US.UTF-8 UTF-8" /etc/locale.gen >/dev/null 2>&1); then
        sed -i "s/#\s*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
    else
        echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
    fi
    if (grep -q "zh_CN.UTF-8 UTF-8" /etc/locale.gen >/dev/null 2>&1); then
        sed -i "s/#\s*zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen
    else
        echo "zh_CN.UTF-8 UTF-8" >>/etc/locale.gen
    fi
    apt-get install locales -y   >> "$OutputLOG" 2>&1
    echo 'LANG="en_US.UTF-8"' > /etc/default/locale
    locale-gen                                           >> "$OutputLOG" 2>&1
    locale-gen en_US.UTF-8                               >> "$OutputLOG" 2>&1
    update-locale LANG=en_US.UTF-8                       >> "$OutputLOG" 2>&1
  # DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales >/dev/null   2>&1
    dpkg-reconfigure --frontend=noninteractive locales   >> "$OutputLOG" 2>&1
    locale                                               >> "$OutputLOG" 2>&1
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
        tune2fs -m 1 $MaxDisk       >> "$OutputLOG" 2>&1
    fi
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
rm -f /etc/00.preparation.log  /etc/01.preparation.log
OutputLOG=/etc/00.preparation.log     preparation 2>&1 | tee -a /etc/01.preparation.log
{ lines2 ; cat /etc/01.preparation.log ; } >> /etc/00.preparation.log
rm -f /etc/01.preparation.log
mv /etc/00.preparation.log  $LogLocation/00.preparation.log

######################################################################################################

do_installation
[[ $USESWAP == Yes ]] && swap_off
check_install_2
echo ; [[ $sihuo != yes ]] && clear
END_output_url 2>&1 | sed 's/[ \t]*$//g' | tee -a $LogBase/end.log
ask_reboot
