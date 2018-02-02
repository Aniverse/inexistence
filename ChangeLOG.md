# ChangeLog  
> 有时候代码内部排版问题、不怎么影响使用的修改就不列出来了  



































### 2018.02.02

`inexistence 0.9.5`  
1. 对一些选项进行重新编号  
2. 增加能够跳过校验的 Deluge 1.3.15 的选项  
**一切后果自负**  
3. 增加 Deluge 1.3.5-1.3.9 的隐藏选项，修复了这些旧版 Deluge SSL 连接的问题  
SSL 的修改代码和 Deluge 1.3.11 的一样  
4. Transmission 的无限打开文件数版本改到了 31 选项，目前还在测试阶段  
5. 修复了 Deluge libtorrent 判断的问题  
6. 密码长度要求降低到至少 8位  

`README 0.6.0`  
1. **更新了 inexistence 安装脚本的截图**  
2. 补充、修正了一些内容  

`ChangeLOG 0.1.2`  
1. 暂时先空着





### 2018.02.01

`inexistence 0.9.5`  
1. **Bump to 0.9.5**  
2. 优化界面  
3. 修复系统检查无效的问题  
4. **通过修改脚本开头的 SYSTEMCHECK=1，允许跳过系统检查**  
只不过 bug 我就不管了  
5. 修复录入用户名输入 No 后无限循环的问题  
6. **支持在 Debian 9 下编译 Transmission**  
7. **支持在 Ubuntu 16.04 下编译 qBittorrent 4.0**  
8. 使用 checkinstall 代替 make install，并写入对应的版本号  
9. **尝试使 Transmission 突破 1024 打开数的限制**  
因为可能存在问题，所以改成了需要手动输入版本的时候才会生效  
10. 隐藏安装 libtorrent-rasterbar 0.16 分支的选项  
11. 优化了检查 qb 版本是否大于等于 4.0 的判断方法  
12. **qBittorrent 安装部分重新编号，增加了可以跳过校验的 3.3.11 版本**  
**一切后果自负**  
13. IPv6 地址的检测时间增加到 8 秒  

`IPv6`  
1. **使用 systemctl reload-or-restart networking.service 代替 ifdown && ifup**  
应该没问题了吧，心情复杂  
2. 加上了脚本的修改日期  

`xiansu`  
1. 对应 IPv6 脚本，更新了网卡的检测方式  

`README 0.5.8`  
1. 随着脚本的更新，修正了一些内容  

`ChangeLOG 0.1.2`  
1. 超前写日志失败，昨天有事出去了结果没更新，尴尬……  
2. 2017.12-2018.02.01





### 2018.01.31

`README 0.5.5`  
1. **更新了 inexistence 安装脚本的截图**  





### 2018.01.30

`inexistence 0.9.4`  
1. 又缩短了一些语句，争取减少错位  
哎，真是心情复杂。我猜不用 read -p 的话大概是不会错位的？  
2. **export DEBIAN_FRONTEND=noninteractive**  
也不知道有没有用，反正学到了就用上吧，QuickBox 是用了  
3. 增加对 checkinstall 的安装，以及 checkinstall 设置的修改  
4. 去除之前编译 FD_SETSIZE 的修改（Tr 老版本没有这个=1024的设定）  
考虑明天直接上修改完后的包，不过这样有个问题，不好自定义版本，或者说要自定义版本得增加判断逻辑了，有点麻烦  
5. **估摸着现在能在 Debian 9 编译 Transmission 了**  
6. Transmission 的编译安装换用了 checkinstall  

`IPv6`  
1. 修复 Debian 9 下，默认网卡名多了一个冒号的问题  
2. **修复没有成功删除之前配置文件，导致多次运行脚本可能失败的问题**  
3. 考虑不用 ifup ifdown 了，失败率太高 ……  





### 2018.01.29

`inexistence 0.9.4`  
1. 编译安装 Transmission 时，设定 FD_SETSIZE=666666  
2. **增加 Transmission 2.93 的安装选项**  
3. **修复 qBittorrent 安装 libtorrent-rasterbar 判断逻辑错误的问题**  
这导致了 Ubuntu 16.04 下没装 lt-r-dev，Debian 9 下编译了两次 lt 1.0.11  
4. 修复 Deluge 编译 lt 时没写入版本号的问题  
5. qBittorrent 编译 lt 时采用 checkinstall，写入版本号为实际并不存在的 1.0.12  
6. 进一步缩短某些输出语句，尽量避免排版错位的问题  
7. 加入了新的 alias，查看脚本错误更方便  

`ChangeLOG 0.1.0`  
1. 20171215-20180129  
2. 201710XX-20171015  





### 2018.01.28

`ChangeLOG 0.0.3`  
1. 20180104-20180127  
2. 201710XX-20171015  
3. 创建 WiKi，目前只存放日志  





### 2018.01.27

`inexistence 0.9.4`  
1. **Bump to 0.9.4**  
2. 输出文字调整  
缩短一些文字，以免小窗口下排版混乱  
录入密码部分不隐藏输入的密码  
3. **将 lsb-release 和 virt-what 的安装移到了后面**  
用很笨的办法直接从系统里检测系统版本，同时也不检测虚拟化技术了  
（考虑以后单独用 virt-what 的部分源码来检测）  
同时考虑加入检测是否 64位 和 x86 架构的问题……
4. qBittorrent 选项调整  
Debian 8 下不显示 qb 4.0 的选项，Debian 9 增加 4.0.2 的选项  
将不支持编译的提示增加到了 Ubuntu 16.04 （有待进一步测试）  
5. **qBittorrent 安装调整**  
Debian 9 下仍然选择编译安装 lt 1.0.11，因为 1.1.1 似乎有问题编译不了  
不编译 lt 的情况也都增加了 zlib1g-dev 这个包  
6. 无关紧要的脚本内部修正  
不使用 relno，全部用 CODENAME，此外增加了一些换行  
libtorrent1/2改成de/qb（checkinstall后包名也会变）  
7. rclone 加入了判断系统架构的选项，加了 log 输出  
但其实也就是 x86 和 x64 而已  
8. **不使用 curl 检测 IP 地址，只用 wget**  
在安装第一步还是尽量少安装一点，有些系统默认不带 curl 的  
wget 加入了是否安装的检测，没安装的话再执行安装  

`readme 0.5.1`  
1. 无关紧要的小幅改动  

`ChangeLOG 0.0.2`  
1. 20180104-20180127  





### 2018.01.23

`inexistence 0.9.3`  
1. **运行前先检测一次系统版本，不符合条件的话直接退出（不使用 lsb-release）**  
由于 wget 和 curl 某些精简系统可能没有，保险起见还是留着安装的命令  
2. 去掉了 installed.lock 里的账号密码，相对地增加了安装完输出结果的 log 保存  
3. 部分输出文字的细节优化  

`readme 0.5.0`  
1. 先随便写个初始版本号，就当 0.5.0 好了  
2. 久违的更新，修正了一些不符合最新脚本情况的内容  
3. 截图下次再说吧





### 2018.01.22

`inexistence 0.9.3`  
1. 修改了一些输出文字的问题  
2. 补充一些注释  
3. 增加了脚本文件夹到用户文件夹的软链  
4. 重新加回了隐藏输入密码的设计  
其实主要是我一时半会儿懒得调整这里的界面了  
5. 修复了 Debian 9 下的三个问题
更改了apt源，添加了 --allow-unauthenticated，修复了 qb 4.0.x 版本号  
6. 增加编译安装 libtorrent-rasterbar 的一些输出提示/注释，方便查错  

偶然想去测试下我基本不用的 Debian 9，没想到随便一试就发现了三个 bug ……





### 2018.01.21

`inexistence 0.9.3`  
1. **Bump to 0.9.3**
2. 从 bench.sh 和 军火脚本 参(chao)考(xi)了判断系统的代码  
打算以后用于代替 lsb_release 作系统判断，不然一开始的检测太慢了  
3. 调换了 30/40/50 的显示顺序  
30 自选版本，40 系统源，50 PPA（Debian 下隐藏）  
4. 在 installed.lock 添加了系统硬件参数，添加了打码账号密码的提示  
5. 为 ruTorrent 的 screenshots 插件添加了 m2ts 的支持
6. 增加/修改了部分 alias
7. 修复了之前使用 read -ep 导致两个暂停出不显示的问题
8. flexget 配置文件的存储路径移动到 ~/.config/flexget，更统一
9. 在安装 de/tr/qb 前备份以前可能存在的配置文件
10. **多处排版修改，预先添加了以后(不用root账户运行客户端)时候应该修改的命令**  
11. **BUG FIX libtorrent-rasterbar**  

这是本次更新的重点…… 忍不住吐槽下，辣鸡 VPS 编译一次 libtorrent-rasterbar 要40分钟，让我测试得真是没耐心，并且以前单核1GB跑下来也没压力，这次我不开 swap 就不行了  
之前残留的 bug 这次我在编译完 libtorrent 又安装 python-libtorrent 的时候碰到了，于是先把 deluge 编译时的这个包去掉  
然后考虑了各种可能的情况，把 qb 安装 lt 分成了三种情况来处理，其实有点蛋疼  

- `不需要再安装 libtorrent-rasterbar`  
适用于之前在安装 Deluge 的时候已经编译了 libtorrent-rasterbar 的情况。有一个问题在于这个检查方式依赖 checkinstall  
- `需要安装 libtorrent-rasterbar-dev`  
适用于 Ubuntu16.04 或 Debian9 系统，没装deluge，或者装了 deluge 且用的 libtorrent 是源的版本的情况
- `需要编译安装 libtorrent-rasterbar`  
适用于 Debian8 系统没装 Deluge 或者 Deluge 没有用编译的 libtorrent-rasterbar 1.0/1.1 的情况  
这也是我想避免的情况，因为编译 lt 实在是花时间；考虑到这个情况可能更通用，我就把它写成了 else  

考虑到有的人可能只是用脚本单独安装 qb，所以必须得从系统里检测 deluge 和已编译的 lt 的情况  
这个问题我也挺奇怪的，我和别人都用默认设置安装下来，有的人就是翻车，我自己测试基本就没问题……反正让我这种菜鸡挺头疼的，希望这次是解决了这个 bug 了吧  
这次 commit 偷懒用中文写了（讲道理吧英文写得也很烂，并且反正也没人看，就是写着自嗨的东西）  
说到这个，我挺好奇我这种写着自嗨的东西有没有人看的，如果谁看到了 QQ 敲下我吧 233  
最后再次吐槽下垃圾 VPS，以前全部安装、编译两次 libtorrent 也就50分钟左右，现在 Ubuntu 16.04 不编绎 libtorrent 竟然都要63分钟  





### 2018.01.19

`inexistence 0.9.2`  
1. **Bump to 0.9.2**
1. 大幅修改排版，加了很多换行  
2. read -ep 代替 echo -ne/read -e，不会出现 backspace 后 echo 文字消失的情况  
3. **将 libtorrent-rasterbar for deluge 的默认选项改回了从系统源安装**  
4. Ubuntu 系统默认从 PPA 安装 Deluge  
5. Debian 系统不显示从 PPA 安装的 40 选项  
6. 询问版本时加入了 50 选项，允许自己输入软件版本  
7. 增加对 /etc/systemd/user.conf LimitNOFILE 的修改  
8. **加入了对 /etc/screenrc 的修改**  
9. alias 里 space 改成 yongle  
10. 检查安装软件是否成功，失败的话直接退出脚本  
11. 替换 /etc/apt/sources.list 前先做一个备份  
12. 加入了检查系统和 Deluge 所用的 libtorrent-ratserbar 的功能  
13. 将针对 qBittorrent 是否编译 libtorrent-ratserbar 时判断条件里的是否为 Debian 修正为是否为 Debian 8 系统
14. 有一个严重 bug 我也不知道解决了没有（2017.01.22：没有！）  
在 Online.net 独服的 Ubuntu 16.04 下，安装 Deluge 编译完 libtorrent-rasterbar 后安装 libtorrent-rasterbar-dev ，会导致冲突，然后 apt-get install 就炸了……  





### 2018.01.18

`inexistence 0.9.1`  
1. 先检查 root 权限，再做之后的检查  
2. 将检查IP地址的提示分成了 IPv4 和 IPv6 两部分  
3. 加回了 rtwebmin 但不启用





### 2018.01.15

`inexistence 0.9.1`  
1. 修复系统为 Debian 8，不安装 Deluge 时 qBittorrent 由于 libtorrent-rasterbar-dev 版本过低无法编译的情况  

`ChangeLOG 0.0.1`  
1. 第一次写 changelog，20180104-20180115  





### 2018.01.12

`inexistence 0.9.1`  
1. 修复了一个我自己都不知道什么鬼的 bug  
由于计时不知道怎么回事丢了 starttime 所以无法计算，脚本直接跳过了 _end 的剩余代码，不输出最后结果了  
2. 注释了 PowerFonts 的安装  
3. 取消了检查系统源 OK 后的绿色粗体  





### 2018.01.11 

`inexistence 0.9.1`  
1. **Bump to 0.9.1**  
2. **在某些情况下不编译 libtorrent-rasterbar**  
安装 qBittorrent 时，当 deluge libtorrent 版本选择非 0.16 分支或 Deluge libtorrent 不选择从 Debian 的系统源安装时，不编绎 libtorrent-rasterbar，选择用 libtorrent-rasterbar-dev 这个包代替以节省时间
3. **顺序变动：先安装 Deluge 再安装 qBittorrent**  
4. 安装前检查安装源的网站是否可以访问，系统源出错时直接退出脚本  
5. 选择 qBittorrent 版本后不显示将会使用的 libtorrent 的版本  
6. 不再隐藏 libtorrent-rasterbar 的 1.1 和 from repo 选项  
7. 完善了 log  





### 2018.01.09

`inexistence 0.9.0`  
1. **Bump to 0.9.0**  
2. **系统优化默认选项改成了 Yes**  
3. 隐藏 qBittorrent 4.0.2 的选项  
4. 在 /var/www 建立了到用户文件夹的软链
5. 系统源加入了 wget 的安装（以防万一）  
6. 补充了 wine 的 PPA（尚未启用）  
7. 补充了 oh-my-zsh 的代码（尚未完全启用）  
8. 增加 IPv6 检测的时间到 5 秒  





### 2018.01.04

`ipv6 & xiansu`  
1. 改进判断默认网卡的方式  
先是识别出本机 IPv4 地址，然后再在 ifconfig 的结果里找包含这个地址的上一排里的网卡名  
也不知道靠不靠谱，感觉大概比之前的靠谱吧  





### 2018.01.03

`inexistence 0.8.9`  
1. 抄来了一个 rcloned 用于自动挂载  
2. **aptsources 默认改为 Yes**  
3. 增加 sudo 的安装  
4. **更新 tr-webui 到新版本**  
5. **针对 Ubuntu PPA 安装 deluge，增加了 apt-mark hold 和指定安装 deluge ppa lt 的操作**  
6. ipv6.sh 重命名为 ipv6  

`readme 0.4.9`  
1. 更新 ipv6  



### 2018.01.02

`inexistence 0.8.9`  
1. cesu 重命名为 spdtest  
2. 缩短公网 IP 检测时间的长度  


























### 2017.12.29

`inexistence 0.8.9`  
01. 修复 local packages 没有及时更新的问题  
02. 对 rTorrent 和 Transmission-daemon 的 systemd 文件增加了 LimitNOFILE=100000  
03. 更新了 mediainfo 最新版本的安装方法  
04. 在 /etc/profile 增加了 ulimit -SHn 666666  
05. 修改打开文件数上限到 666666  
06. 在 /etc/security/limits.conf 增加了一些行数，应该比之前有用吧  
07. **增加每个软件安装过程的日志记录功能，方便查错**  





### 2017.12.27

`inexistence 0.8.9`  
1. 增加了 Deluge 1.3.5/1.3.6 的隐藏选项  
但其实好像编译出来有问题……  
2. 加了 lt 0.16 支持双栈IP汇报的提示  
3. 在 BBR 处临时指定了另一个 $local_packages  
4. 1926817→192617

`ipv6.sh`  
1. 临时修复把默认网卡 eno1 识别成 eno2 的问题  
治标不治本（已在2018.01.04里修复）





### 2017.12.25

`inexistence 0.8.9`  
1. **Bump to 0.8.9**  
2. alias xuanxiang，同时去掉了双引号（会显示在 cat里）  
3. 输出文字大小写优化  
4. 隐藏了 qb 3.12/13/15 的选项，Ubuntu 下 4.0.2 改成 4.0.3  
5. **installed.lock 代替 /ect/profile 的安装信息注释**  
6. 脚本版本和修改日期移到了脚本开头  
7. 计时开始处移到了 _setsources  
8. **_setsources 处增加了一些软件的安装**  
9. **文件打开数修改处，会删除之前可能存在的文件打开数设置**  

`readme 0.4.8`  
1. Known Issues、Under Consideration、To Do List  






### 2017.12.23

`inexistence 0.8.8`  
1. 增加了 QBVERSION4 的判断  
2. lt 增加了显示每个系统对应源里版本的功能  
3. 创建脚本文件夹的软链之前先创建 /var/www 文件夹  
4. alias 里 cdde 之类的去掉了 ll
5. 增加一步 locale-gen en_US.UTF-8（不 source 好像也没意思）  
6. 调整 wine 与 VNC 的安装  
7. 安装结束时的 Clients URL 改成 INSTALLATION COMPLETED  
8. _setsources 放在了 _setuser 之前，避免安装不了 git 的问题  

`readme 0.4.7`  
1. 更新开头的介绍  





### 2017.12.22

`readme 0.4.6`  
1. 更新  bdupload 的案例介绍  
2. 部分内容调整  
3. 增加参考资料名单  

`ipv6.sh`  
1. 直接改成增 3次 ifup  
似乎然并卵  





### 2017.12.21

`inexistence 0.8.8`  
1. 已安装 rt 的话，提示改成请使用 rtupdate 更换版本
2. 增加了到用户文件夹的软链  
3. 增加了 screen 和 vnstat 的安装

`bdupload`  
1. 修复时间判断不正确的问题  
2. 增加了每张截图的时间间隔  





### 2017.12.17

`inexistence 0.8.8`  
1. 界面、输出文字调整  
2. 账号密码输出到 installed.lock  
3. 脚本运行完毕后删除脚本自身  
4. 移动 rtinst 和 bbr 脚本的 log  

`mingling 0.5.7`  
1. **重写了《一些常用命令》**  
排版真累啊  
2. 更新软件版本的检查方式，awk  

`bdinfo bdjietu bdupload jietu zuozhong`  
1. 优化输出的结果显示  

`readme 0.4.2-0.4.5`  
1. 更新 bdupload、bdjietu、bdinfo 等脚本的用法说明  
2. 修复一些地方标题没有大写的问题  





### 2017.12.16

`inexistence 0.8.8`  
1. **Bump to 0.8.8**  
2. 修复 curl 参数写成 wget 参数的问题  
3. **以防万一，在一开始增加了 wget 和 crul 的安装**  
4. 输出文字调整  
5. cesujiedian 简化  
6. 去掉 IPv4 优先的设定  
某些情况下直接连不上 IPv6 了 orz  
7. **增加已安装客户端版本的检查**  
8. **增加显示会安装的、来自 repo 版本的功能**  
9. **Transmission 默认改为从 repo 安装**  
10. **已安装客户端的话会提示已安装的版本**  
11. **安装失败的话在最后会有检查、提示**  

`ipv6.sh`  
1. **彩色化界面**  
2. **优化默认网卡判断**  
代码来自于 Vicer 大佬的锐速一键脚本  
3. **检查 ifup 是否成功**  
4. **移除可能存在的 IPv6 设置，让脚本在失败的情况下可以多次运行**  

`bdinfo`  
1. 增加了运行出错时的提示  

`xiansu`  
1. 优化网卡判断（eth1的情况）  
2. 使用 bash 代替 sh  

`readme 0.3.6-0.4.1`  
1. 懒得写了……  
2. 大量内容新增、补充、重写  
3. IPv6 脚本公开上线  
4. --no-check-certificate 参数写在了开头的介绍，简化命令  





### 2017.12.15

`inexistence 0.8.7`  
1. **去掉 webmin 的安装**  
2. **增加了修改时区的功能**  
3. 完善 alias  
4. **将最大的分区的保留空间设置为 0**  
5. 设定 IPv4 优先  
6. 隐藏从 repo 安装 Deluge 的选项  
应该是从这个时候发现 Deluge 与 qBittorrent libtorrent-rasterbar 冲突的问题  

`mingling 0.5.6`  
1. 对应修改了 alias 的提示  
2. 用 awk 替换之前的一些版本检查方法  
3. 去除了检查 rclone 版本时多余的提示  





### 2017.12.13

`inexistence 0.8.7`  
1. 











### 2017.12.08

`inexistence `  
1. 大量新脚本上传、内容更改  
2. 一些小问题修复  

















### 2017.11.30





### 2017.11.29





### 2017.11.28






### 2017.11.27





### 2017.11.24





### 2017.11.23





### 2017.11.22






### 2017.11.19






### 2017.11.17






### 2017.11.14






### 2017.11.13






### 2017.11.10






### 2017.11.09

`Seedbox 0.4.2-0.4.4` 
1. 2017.11.09 00:28/01;02/12;09
2.





### 2017.11.08

`Seedbox 0.4.0-0.4.1` 
1. 2017.11.08 20:00/20:07  
2. 





### 2017.11.07

`Seedbox 0.3.9` 
1. 2017.11.07 12:28  
2. 

`Seedbox 0.3.8` 
1. 2017.11.07 10:51  
2. 





### 2017.10.27

`Seedbox 0.3.7` 
1. 2017.10.27 16:29  
2. 

`Seedbox 0.3.6` 
1. 2017.10.27 13:29  
2. 





### 2017.10.26

`Seedbox 0.3.5.2` 
1. 2017.10.26 24:30  
2. 

`Seedbox 0.3.5.1` 
1. 2017.10.26 24:30  
2. 


`Seedbox 0.3.4` 
1. 2017.10.26 20:00  
2. 


`Seedbox 0.3.3` 
1. 2017.10.26 19:02  
2. 


`Seedbox 0.3.2` 
1. 2017.10.26 18:46  
2. 


`Seedbox 0.3.1` 
1. 2017.10.26 18:24  
2. 


`Seedbox 0.3.0` 
1. 2017.10.26 17:33  
2. 

`Seedbox 0.2.9` 
1. 2017.10.26 17:18  
2. 

`Seedbox 0.2.8` 
1. 2017.10.26 17:00  
2. 

`Seedbox 0.2.7` 
1. 2017.10.26 16:18  
2. 

`Seedbox 0.2.6` 
1. 2017.10.26 15:21  
2. 





### 2017.10.25

`Seedbox 0.2.5` 
1. 2017.10.25 20:53  
2. 

`Seedbox 0.2.4` 
1. 2017.10.25 19:30  
2. 

`Seedbox 0.2.3` 
1. 2017.10.25 19:03  
2. 





### 2017.10.24

`Seedbox 0.2.2` 
1. 2017.10.24 23:33  
2. 

`Seedbox 0.2.1` 
1. 2017.10.24 23:15  
2. 

`Seedbox 0.2.0` 
1. 2017.10.24 21:27  
2. 

`Seedbox 0.1.9` 
1. 2017.10.24 21:14  
2. 

`Seedbox 0.1.8` 
1. 2017.10.24 20:18  
2. 

`Seedbox 0.1.7` 
1. 2017.10.24 16:30  
2. 





### 2017.10.21

`Seedbox 0.1.6` 
1. 2017.10.21 22:33  
2. 

`Seedbox 0.1.5` 
1. 2017.10.21 12:45  
2. 

`Seedbox 0.1.4` 
1. 2017.10.21 10:47  
2. 

`Seedbox 0.1.3` 
1. 2017.10.21 00:44  
2. 


`Seedbox 0.1.2` 
1. 2017.10.21 00:19  
2. 





### 2017.10.18

`Seedbox 0.1.1`  
1. 2017.10.18 19:10  
2. 

`Seedbox 0.1.0`  
1. 2017.10.18 18:26  
2. 

`Seedbox 0.0.9`  
1. 2017.10.18 18:40  
2. 

`Seedbox 0.0.8`  
1. 2017.10.18 18:08  
2. 





### 2017.10.15

`Seedbox 0.0.7`  
1. 2017.10.15 23:30  
2. 输出修改  
3. 去掉了手滑写多的 apt-get install  





### 2017.10.13

`Seedbox 0.0.6`  
1. 2017.10.13 13:44  
2. 补充注释  
3. libtorrent-rasterbar 加入了不编绎的选项  
4. 一些默认选项的修改  
5. **增加了安装 rclone 的功能**  
6. 输出修改  





### 2017.10.12

`Seedbox 0.0.5`  
1. 2017.10.12 24:10  
2. libtorrent-rasterbar master branch，Deluge dev branch  
3. alias、排版、补写 fi  

`Seedbox 0.0.4`  
1. 2017.10.12 23:09  
2. **增加了安装 rTorrent 与 ruTorrent 的功能**  
3. **增加了安装 Flexget 的功能**  

`Seedbox 0.0.3`  
1. **Rename to Seedbox Script**  
1. 2017.10.12 19:37  
2. This is the choice of Steins;Gate.  
3. 询问是否创建 log  
4. 补充、完善输出文字，比如正在安装什么的提示  
5. **增加安装 Deluge 以及 libtorrent-rasterbar 的功能**  
6. **增加了 alias**  
7. **增加了滚动条？**  

`qbt 0.0.2`  
1. 2017.10.12 13:14  
2. **加入了部分设置 qb 参数的功能**  
3. **完善界面**  





### 2017.10.XX

`qbt 0.0.1`  
1. 第一个版本，只能安装 qBittorrent  
