# Inexistence

> This is a seedbox script focus on Chinese users, I would prefer [QuickBox Lite](https://github.com/amefs/quickbox-lite), [QuickBox](https://quickbox.io/), [swizzin](https://swizzin.ltd), [PGBlitz](https://pgblitz.com), [rtinst](https://github.com/arakasi72/rtinst) for non-Chinese users.  
> Just a seedbox script, no Plex, no Emby, no NZB support.  
> And note that this README is outdated, I'm too lazy to keep it update.  

> 警告：不保证本脚本能正常使用，翻车了不负责；使用前还请三思  
> 建议重装完系统后安装本脚本，非全新安装的情况下翻车几率比较高  

> [基本没人来的本脚本交流群，有事别问群主](https://gist.github.com/Aniverse/cc885b91fb7c5d5139c3ffce7e28b0da)  
> 安利一下 efs 巨佬的牛逼盒子脚本，比我的脚本好多了：[QuickBox Lite](https://github.com/amefs/quickbox-lite)  
> ARM 用户（树莓派、SYS ARM 独服等）可以试试这个：[QuickBox ARM](https://github.com/amefs/quickbox-arm)  

由于作者很懒+喜欢咕咕，本文内容更新频率比较低，有些内容和当前的脚本可能已经不一样了，凑合着看吧。  


## Usage

```
bash <(wget --no-check-certificate -qO- https://github.com/Aniverse/inexistence/raw/master/inexistence.sh)
```

## Installation Guide

![脚本参数](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.09.png)

脚本支持自定义参数，具体参数的说明在下文中有说明  

![引导界面](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.01.png)

检查是否以 root 权限来运行脚本，检查公网 IP 地址与系统参数  

![升级系统](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.02.1.png)
![升级系统](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.02.2.png)

支持 `Ubuntu 16.04 / 18.04`、`Debian 8 / 9 / 10` ，其他系统不支持  
使用 ***`-s`*** 参数可以跳过对系统是否受支持的检查，不过这种情况下脚本能不能正常工作就是另一回事了  

![系统信息](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.03.png)

显示系统信息以及注意事项  

![安装时的选项](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.04.png)

1. ***是否升级系统***  
低于 `Ubuntu 18.04`、`Debian 10` 的 LTS 系统可以选择用脚本升级系统  
一般来说整个升级过程应该是无交互的，应该不会碰到什么问你 Yes or No 的问题  
升级完后会直接执行重启命令，重启完后你需要再次运行脚本来完成软件的安装  


2. ***账号密码***  
**`-u <username> -p <password>`**  
你输入的账号密码会被用于各类软件以及 SSH 的登录验证  
用户名需要以字母开头，长度 4-16 位；密码最好同时包含字母和数字，长度至少 8 位
恩，目前我话是这么说，但脚本里还没有检查账号密码是否合乎要求，所以还是自己注意点吧  


3. ***系统源***  
**`--apt-yes`**、**`--apt-no`**  
**目前默认直接换源不再提问，如果不想换源，请在运行脚本的使用 `--apt-no` 参数**  
其实大多数情况下无需换源；但某些盒子默认的源可能有点问题，所以我干脆做成默认都换源了  


4. ***线程数量***  
**`--mt-single`**、**`--mt-double`**、**`--mt-half`**、**`--mt-max`**  
**目前默认直接使用全部线程不再提问，如果不想使用全部线程，请在运行脚本的使用以上的参数来指定**  
编译时使用几个线程进行编译。一般来说用默认的选项，也就是全部线程都用于编译就行了  
某些 VPS 可能限制下线程数量能避免编译过程中因为内存不足翻车  


5. ***安装时是否创建 swap***  
**`--swap-yes`**，**`--swap-no`**  
**目前默认对于内存小于 1926MB 的服务器直接启用 swap 不再询问，如不想使用 swap 请用 `--swap-no` 参数**  
一些内存不够大的 VPS 在编译安装时可能物理内存不足，使用 swap 可以解决这个问题  
实测 1C1T 1GB 内存 的 Vultr VPS 安装 Flood 不开启 swap 的话会失败，开启就没问题了  
目前对于物理内存小于 1926MB 的都默认启用 swap，如果内存大于这个值那么你根本就不会看到这个选项……  


6. ***客户端安装选项***  
**`--de ppa --qb 3.3.11 --rt 0.9.4 --tr repo`**  
下面四大客户端的安装，指定版本的都是编译安装，安装速度相对较慢但可以任选版本  
选择 `30` 是自己指定另外的版本来安装  **（不会检查这个版本是否可用；可能会翻车）**  
选择 `40` 是从系统源里安装，安装速度快但版本往往比较老，且无法指定版本  
选择 `50` 是从 PPA 安装( Debian 不支持所以不会显示)，同样无法指定版本不过一般软件都是最新版  


7. ***qBittorrent***  
**`--qb 4.2.1`**、**`--qb ppa`**、**`--qb No`**  
注意：目前脚本安装的 flexget 和 qBittorrent 4.2.1 不兼容  


8. ***Deluge***  
**`--de '1.3.15 (Skip hash check)'`**、**`--de 1.3.9`**、**`--de repo`**、**`--de No`**  
默认选项为从源码安装 1.3.15  
2.0.3 目前运行在 Python 2.7 下，且仍然有较多 PT 站不支持 2.0.3  
此外还会安装一些实用的 Deluge 第三方插件：  
- `AutoRemovePlus` 是自动删种插件，支持 WebUI 与 GtkUI  
- `ltconfig` 是一个调整 `libtorrent-rasterbar` 参数的插件，在安装完后就启用了 `High Performance Seed` 模式  
- `Stats`、`TotalTraffic`、`Pieces`、`LabelPlus`、`YaRSS2`、`NoFolder` 都只能在 GUI 下设置，WebUI 下无法显示  
- `Stats` 和 `TotalTraffic`、`Pieces` 分别可以实现速度曲线和流量统计、区块统计  
- `LabelPlus` 是加强版的标签管理，支持自动根据 Tracker 对种子限速，刷 Frds 可用；也只有 GUI 可用    
- `YaRSS2` 是用于 RSS 的插件  
隐藏选项 21，是可以跳过校验、全磁盘预分配的 1.3.15 版本  
**使用修改版客户端、跳过校验 存在风险，后果自负**  


9. ***libtorrent-rasterbar***  
要安装 Deluge 或者 qBittorrent 中的任意一个，就必须安装 libtorrent-rasterbar，因为 libtorrent-rasterbar 是这两个软件所使用的后端  
从 Deluge 2.0 或 qBittorrent 4.1.4 开始，libtorrent-rasterbar 的最低版本要求升级到了 1.1  
需要注意的是，这个 libtorrent-rasterbar 和 rTorrent 所使用的 libtorrent 是不一样的，切勿混淆  
Deluge 和 qBittorrent 使用的是 [libtorrent-rasterbar](https://github.com/arvidn/libtorrent)，rTorrent 使用的则是 [libtorrent-rakshasa](https://github.com/rakshasa/libtorrent)  


10. ***rTorrent***  
**`--rt 0.9.4`**、**`--rt 0.9.3 --enable-ipv6`**、**`--rt No`**  
这部分是调用我修改的 [rtinst](https://github.com/Aniverse/rtinst) 来安装的  
注意，`Ubuntu 18.04` 和 `Debian 9/10` 因为 OpenSSL 的原因，只能使用 0.9.6 及以上的版本，更低版本无法直接安装  
- 安装 rTorrent，ruTorrent，nginx，ffmpeg，rar，h5ai 目录列表程序  
- 0.9.2-0.9.4 支持 IPv6 用的是打好补丁的版本，属于修改版客户端  
- 0.9.6 支持 IPv6 用的是 2018.01.30 的 feature-bind 分支，原生支持 IPv6  
- 设置了 Deluge、qBittorrent、Transmission、Flexget WebUI 的反代  
- ruTorrent 版本为来自 master 分支的 3.9 版，此外还安装了如下的第三方插件和主题  
- `club-QuickBox` `MaterialDesign` 第三方主题  
- `AutoDL-Irssi` （原版 rtinst 自带）  
- `Filemanager` 插件可以在 ruTorrent 上管理文件、右键创建压缩包、生成 mediainfo 和截图  
- `ruTorrent Mobile` 插件可以优化 ruTorrent 在手机上的显示效果（不需要的话可以手动禁用此插件）  
- `Fileshare` 插件创建有时限、可自定义密码的文件分享链接  
- `GeoIP2` 插件，代替原先的 GeoIP 插件，精确度更好，支持 IPv6 地址识别  


11. **Flood**  
**`--flood-yes`**、**`--flood-no`**  
选择不安装 rTorrent 的话这个选项不会出现  
Flood 是 rTorrent 的另一个 WebUI，界面更为美观，加载速度快，不过功能上不如 ruTorrent  
第一次登陆时需要填写信息，端口号是 5000，挂载点是 127.0.0.1  


12. ***Transmission***  
**`--tr repo`**、**`--tr ppa`**、**`--tr 2.93 --tr-skip`**、**`--tr No`**  
Transmission 默认选择从预先编译好的 deb 安装最新版 2.94（解决了文件打开数问题）  
此外还会安装 [加强版的 WebUI](https://github.com/ronggang/transmission-web-control)，更方便易用  
隐藏选项 11 和 12，分别对应可以跳过校验、无文件打开数限制的 2.92、2.93 版本（无 2.94 修改版）  
跳校验版本是选择【获取更多 peers】来实现跳校验（也就是替换了菜单里对应的功能）  
**使用修改版客户端、跳过校验 存在风险，后果自负**  


13. ***Remote Desktop***  
**`--rdp-vnc`**、**`--rdp-x2go`**、**`--rdp-no`**  
远程桌面选项，默认不安装  
远程桌面可以完成一些 CLI 下做不了或者 CLI 实现起来很麻烦的操作，比如 BD-Remux，wine uTorrent  
VNC 目前可能会存在问题，作者一时半会儿懒得修复了……  


14. ***wine & mono***  
**`--wine-yes`**、**`--wine-no`**  
这两个默认也是不安装的  
`wine` 可以实现在 Linux 上运行 Windows 程序，比如 DVDFab、uTorrent  
`mono` 是一个跨平台的 .NET 运行环境，BDinfoCLI、Jackett、Sonarr 等软件的运行都需要 mono   


15. ***Some additional tools***  
**`--tools-yes`**、**`--tools-no`**  
安装最新版本的 ffmpeg、mediainfo、mkvtoolnix、eac3to、bluray 脚本、mktorrent  
- `mediainfo` 用最新版是因为某些站发种填信息时有这方面的要求，比如 HDBits  
- `mkvtoolnix` 主要是用于做 BD-Remux  
- `ffmpeg` 对于大多数盒子用户来说主要是拿来做视频截图用，采用 git 的 Static Builds  
- `eac3to` 需要 wine 来运行，做 remux 时用得上  
- `mktorrent` 由于 1.1 版的实际表现不是很理想，因此选择从系统源安装 1.0 版本  
- `BDinfoCLI` 已经自带了，需要 mono 来运行  
- `bluray` 其实也自带了，不过这里的版本不是及时更新的，所以还是更新下  


16. ***Flexget***  
**`--flexget-yes`**、**`--flexget-no`**  
Flexget 是一个 RSS 工具，默认不安装；目前采用 Python 2.7 来运行  
我启用了 daemon 模式和 WebUI，还预设了一些模板，仅供参考  
因为配置文件里的 passkey 需要用户自己修改，所以我也没有启用 schedules 或 crontab，需要的话自己设置  


17. ***rclone***  
**`--rclone-yes`**、**`--rclone-no`**  
默认不安装。安装好后自己输入 rclone config 进行配置  


18. ***BBR***  
**`--bbr-yes`**、**`--bbr-no`**  
（如果你想安装魔改版 BBR 或 锐速，请移步到 [TrCtrlProToc0l](https://github.com/Aniverse/TrCtrlProToc0l) 脚本）  
会检测你当前的内核版本，大于 4.9 是默认不安装新内核与 BBR，高于 4.9 是默认直接启用BBR（不安装新内核）  
注意：更换内核有风险，可能会导致无法正常启动系统  



19. ***系统设置***  
**`--tweaks-yes`**、**`--tweaks-no`**  
默认启用，具体操作如下：  
- 修改时区为 UTC+8  
- 语言编码设置为 en.UTF-8  
- 设置 `alias` 简化命令（私货夹带）  
- 修改 screenrc 设置  


![确认信息](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.05.png)

如果你哪里写错了，先退出脚本重新选择；没什么问题的话就敲回车继续  
使用 ***`-y`*** 可以跳过开头的信息确认和此处的信息确认，配合其他参数可以做到无交互安装  

![使用参数](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.10.png)




-------------------



![安装完成界面](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.06.png)

安装完成后会输出各类 WebUI 的网址，以及本次安装花了多少时间，然后问你是否重启系统（默认是不重启）  

![安装失败界面](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.07.png)

如果报道上出现了偏差，会提示你如何查看日志（报错时请务必附上日志！）  

![WebUI](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/inexistence.08.png)

最后打开浏览器检查下各客户端是否都能正常访问，一般是没问题的……  





## mingling

方便刷子们使用的一个脚本，有很多功能如果你没安装 `inexistence` 的话是用不了的  
有些功能还没做完，不过这个脚本我有点放弃治疗了，无限期弃更，说真的这个东西我自己都懒得用  
不做具体的介绍了，直接看图吧  

![mingling.00](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.00.png)
![mingling.01](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.01.png)
![mingling.02](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.02.png)
![mingling.03](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.03.png)
![mingling.04](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.04.png)
![mingling.05](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.05.png)
![mingling.06](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.06.png)
![mingling.07](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.07.png)
![mingling.08](https://github.com/Aniverse/inexistence/raw/master/03.Files/images/mingling.08.png)








## BDinfo

这个是单独抽出来的，用于给 BDMV 扫描 BDinfo 的脚本  
运行完以后可以直接在 SSH 上输出 BDinfo Quick Summary  

![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.01.png)

如果没有 mono 或 BDinfo-Cli 的话，可以先运行 `bluray` 或者 `inexistence` 脚本安装需要的软件  

![bdinfo运行过程](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.02.png)

可以选择需要扫描的 mpls  

![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.03.png)
 






## IPv6

用于配置 IPv6 的脚本（主要是 Online，Ikoula 不适用），如果第一次运行不成功，可以试着再跑一遍  
如果你跑了 N 遍都不成功，有一种可能性是你那个 IPv6 本身不可用  
**2018.11.15 Update：可能跑完后机器会失联，如果这样的话试试后台重启下？**  
**2019.06.05 Update：不支持 Ubuntu 18.04，以后再更新**  
**2020.01.07 Update：支持 Ubuntu 18.04 和 Ikoula 的脚本在下边，自己看**  

``` 
bash -c "$(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6)"
``` 

可以在命令里写上 IPv6 的信息（复制粘贴更方便一些）  
第四项参数网卡名称可以让脚本自动检测，也可以手动指定  
```
wget https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6  
bash ipv6 [address] [subnet] [DUID] [interface]  
bash ipv6 2001:3bc8:2490:: 48 00:03:00:02:19:c4:c9:e3:75:26 enp2s0  
bash ipv6 [address] [subnet] [DUID]  
bash ipv6 2001:cb6:2521:240:: 57 00:03:00:01:d3:3a:15:b4:43:ad  
```

![ipv6.01](https://github.com/Aniverse/filesss/raw/master/Images/ipv6.01.png)

## IPv6.sh

新一代 IPv6 配置脚本，支持 Online 和 Ikoula，支持 Debian 8/9/10，Ubuntu 16.04/18.04  
还不是很完善，怎么用自己看代码吧……我目前懒得写了  

``` 
# 显示帮助
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -h
# 测试 IPv6 是否可用
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -t
# Online Ifdown, 适用于 Debian 8/9/10, Ubuntu 16.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ol  -6 [address] -d [DUID] -s [subnet]
# Online netpaln, 适用于 Ubuntu 18.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ol2 -6 XXX -d XXX -s 56
# Online dibbler, 适用于 Debian 8/9/10, Ubuntu 16.04/18.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ol3 -6 XXX -d XXX -s 56
# Online odhcp6c, 适用于 Debian 8/9/10, Ubuntu 16.04/18.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ol4 -6 XXX -d XXX -s 56
# Ikoula Debian 8/9/10, Ubuntu 16.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ik
# Ikoula Ubuntu 18.04
bash <(wget -qO- https://github.com/Aniverse/inexistence/raw/master/00.Installation/script/ipv6.sh) -m ik2
``` 







## xiansu

**2019.06.05 作者吐槽：这玩意儿有点时泪了的感觉，现在都是 OP 和 Hz，辣鸡 Online，限速涨价， 呸！**  
用于给盒子限制全局上传速度的脚本，适用于保证带宽有限的盒子，比如 Online.net 的一些独服  
更改限速速率时无需事先解除限速，脚本执行新的限速前会自动解除该网卡已经存在的限速  
直接输入 `xiansu eth0 300` 的话会直接限速，不会有任何提示，适合用于需要开机自启的情况  

``` 
xiansu  
xiansu [interface] [uploadspeed,Mbps]
xiansu eth0 300
```

![xiansu.01](https://github.com/Aniverse/filesss/raw/master/Images/xiansu.01.png)








## jietu

用于截图和生成 mediainfo 的脚本，对于 DVD 还会加入 IFO 文件的 mediainfo，PTP 发种用得上  
输入文件名则对这个文件进行操作，输入文件夹则寻找该文件夹内最大的文件当做视频文件进行操作  
你可以指定分辨率进行截图，也可以不写分辨率让脚本自动计算 DAR 后的分辨率  
比如有一张 DVD 的原始分辨率是 720x576，DAR 是 16:9，那么脚本就会采用 1024x576 来截图  

``` 
jietu [path/to/file] [resloution]  
jietu "/home/aniverse/[VCB-Studio][Saenai Heroine no Sodatekata Flat][01][Ma10p_1080p][x265_flac_aac]" 1920x1080  
jietu [path/to/folder]  
jietu "/home/aniverse/deluge/download/Your Name (2016) PAL DVD9"  
```

![jietu.01](https://github.com/Aniverse/filesss/raw/master/Images/jietu.01.png)








## guazai

用于把 ISO 挂载成文件夹的脚本，使用的是 mount 命令，因此一般来说需要 root 权限才能运行  

![guazai.03](https://github.com/Aniverse/filesss/raw/master/Images/guazai.03.png)

`guazai` 后输入文件名则挂载那个文件  

![guazai.01](https://github.com/Aniverse/filesss/raw/master/Images/guazai.01.png)
![guazai.02](https://github.com/Aniverse/filesss/raw/master/Images/guazai.02.png)

`guazai` 后输入路径则会寻找该路径下的所有 ISO 进行挂载  
直接输入 `guazai`，会在当前目录下寻找 ISO 挂载  







## jiegua

解除挂载用的脚本，会把能检测到的所有已挂载的 ISO 全部解除挂载

![jiegua.01](https://github.com/Aniverse/filesss/raw/master/Images/jiegua.01.png)

`guazai` + `jietu` + `jiegua` 三连








## Blu-ray

关于 bluray 脚本的介绍与使用，请移步到 [这里](https://github.com/Aniverse/bluray)  
inexistence 自带 bluray，不过不包括它的软件库  
（然而你可以直接用 inexistence 安装 ffmpeg、vcs、bdinfocli、mono、imagemagick）  







## Something else

还有一些脚本，比如 `zuozhong`，在此不作介绍了，基本看名字都知道是干什么用的了  

1. 有 bug 的话欢迎反馈，**但不保证能解决**，且有些问题可能不是本脚本造成的  
2. 有意见或者改进也欢迎告知  
3. [有问题也可以来这个基本没人的本脚本交流群反馈，有事别问群主……](https://gist.github.com/Aniverse/cc885b91fb7c5d5139c3ffce7e28b0da)  

## Issues

如需提交 bug ，请确保带有如下信息：  
1. 具体的日志，日志的查看方法在最后安装出错后会有提示（可以用 `s-end` 再次查看）  
2. SSH 输入 `s-opt` 后输出的全部信息

## Some references

https://github.com/arakasi72/rtinst  
https://github.com/QuickBox/QB  
https://github.com/liaralabs/swizzin  
https://github.com/qbittorrent/qBittorrent  
https://github.com/jfurrow/flood  
https://flexget.com  
https://wiki.winehq.org  
https://wiki.x2go.org  
http://www.mono-project.com  
https://rclone.org/install  
http://dev.deluge-torrent.org/wiki/UserGuide    
https://mkvtoolnix.download/downloads.html  
http://outlyer.net/etiq/projects/vcs  
https://amefs.net  
https://www.dwhd.org  
https://moeclub.org  
https://sometimesnaive.org  
https://www.94ish.me  
https://blog.gloriousdays.pw  
https://blog.rhilip.info  
https://ymgblog.com  
http://wilywx.com  
http://xiaofd.win/onekey-ruisu.html  
https://github.com/arfoll/unrarall  
https://github.com/teddysun/across  
https://github.com/FunctionClub  
https://github.com/oooldking/script  
https://github.com/gutenye/systemd-units  
https://github.com/outime/ipv6-dhclient-script  
https://github.com/jxzy199306/ipv6_dhclient_online_net  
https://github.com/GalaxyXL/qBittorrent-autoremove  
https://xxxxxx.org/forums/viewtopic?topicid=61434  
https://github.com/superlukia/transmission-2.92_skiphashcheck  
https://tieba.baidu.com/p/5536354634  
https://tieba.baidu.com/p/5532509017  
https://tieba.baidu.com/p/5158974574  
https://serverfault.com/questions/48724/100-non-interactive-debian-dist-upgrade  
https://github.com/Azure/azure-devops-utils  
https://stackoverflow.com/questions/36524872/check-single-character-in-array-bash-for-password-generator  
